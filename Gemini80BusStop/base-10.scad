// Gemini Storage Rack
// By Hans Christian Saustrup <hc@saustrup.net>
model_version = "v0.0.1";

use <lib/gemini-storage-rack.scad>

$fn = $preview ? 0 : 50;

gemini_storage_rack(cards=10);

