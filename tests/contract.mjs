#!/usr/bin/env node
/**
 * Static checks for the public ACK example. Does not call Alibaba Cloud.
 */
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const root = new URL('..', import.meta.url).pathname;
const errors = [];

function walk(dir, acc = []) {
  for (const name of readdirSync(dir)) {
    if (name === '.terraform' || name === '.git' || name === '.terraform-plugin-cache') continue;
    const full = join(dir, name);
    const st = statSync(full);
    if (st.isDirectory()) walk(full, acc);
    else acc.push(full);
  }
  return acc;
}

const files = walk(root);
const tf = files.filter((file) => file.endsWith('.tf'));
const text = tf.map((file) => readFileSync(file, 'utf8')).join('\n');
const compact = text.replace(/\s+/g, '');

function fail(message) {
  errors.push(message);
}

const forbidden = [
  [/LTAI[A-Za-z0-9]{8,}/, 'access key id'],
  [/BEGIN (RSA |OPENSSH )?PRIVATE KEY/, 'private key'],
  [/password\s*=\s*"/, 'hard-coded password'],
  [/alicloud_forward_entry/, 'DNAT forward entry'],
  [/slb_internet_enabled\s*=\s*true/, 'public API load balancer'],
  [/new_nat_gateway\s*=\s*true/, 'ACK-managed NAT'],
  [/cen_instance_id/, 'automatic CEN attachment'],
  [/type\s*=\s*"LoadBalancer"/, 'public Argo CD service'],
  [/system_disk_kms_key\s*=\s*"alias\/acs\//, 'explicit ECS service key'],
];

for (const [pattern, label] of forbidden) {
  if (pattern.test(text)) fail(`forbidden ${label}`);
}

for (const needle of [
  'slb_internet_enabled=false',
  'deletion_protection=true',
  'enable_rrsa=true',
  'internet_max_bandwidth_out=0',
  'system_disk_encrypted=true',
  'name="LockID"',
  'type="String"',
  'sse_algorithm="AES256"',
  'acl="private"',
  'backend"oss"{}',
  'type="ClusterIP"',
]) {
  if (!compact.includes(needle)) fail(`missing required snippet: ${needle}`);
}

if (files.some((file) => file.endsWith('.tfstate') || file.includes('.terraform/'))) {
  fail('generated state or provider cache is present');
}

if (errors.length) {
  console.error(errors.join('\n'));
  process.exit(1);
}

console.log(`ACK example contract passed (${tf.length} Terraform files).`);
