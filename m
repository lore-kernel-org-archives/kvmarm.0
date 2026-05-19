Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322E1348C40
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197404; cv=none; b=LRQADTKp69dDowYXPIj4G9u2AddNX+2eGAg2TAiDUJeQfxkIXlR5sK5HLMXP+e0sJhoqYbQBK1dOi9QkUQbWaa3jPd1ggUU+IDKE58LKQj95VtVPcD5cI257DEOupas/iOmVhNXd8ait3+g/Jyk/rBuxKJrNW7atDVuaoVgAulI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197404; c=relaxed/simple;
	bh=DYjj11LRJOQkJ4E5v96W+xs86ckkTPQ+1NfcOQcJKCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MYhcUeT5CJ6JIUAqdgKGpfgt5N9bMP0+RJ9nFSmMZ07w0Xph8Uk+j4Nk7EJvNqeYtndxrK3FhutZ2WdgYOavOgnwybyaW2zU6etjyKvZFdf2HDqyGdyvO/KUpZKm0HLtzsR+8dEPA+8IXdYZwwu/IPDNMlN2Dz3PKg3itOIeNuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZQ7xFPh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZQ7xFPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2Xr+fTzJIcnFDLkVVYJvYLH1jE72SWzHC7DC1a1qLo=;
	b=dZQ7xFPhjI1VoJ4D8+NxF0CI9V2J2UoNwQ4iRpK9CSc9mEFwEhxS3UsjAmS0Wy8NJMAPEy
	g2bJgxaDYjJKCHqBKMTsWTFl1cn1vyhrgLjgT721WJlww6BLQiPkauHUiOL6vGYKjAJI/6
	hhAlxdtQBOtCWuhg/AtmeaE4o4kv254=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-bKHvwoyVNR2ZGeg1BBuAZQ-1; Tue,
 19 May 2026 09:29:58 -0400
X-MC-Unique: bKHvwoyVNR2ZGeg1BBuAZQ-1
X-Mimecast-MFC-AGG-ID: bKHvwoyVNR2ZGeg1BBuAZQ_1779197397
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEA381800371;
	Tue, 19 May 2026 13:29:56 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 68A261800352;
	Tue, 19 May 2026 13:29:50 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 06/18] scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
Date: Tue, 19 May 2026 15:27:20 +0200
Message-ID: <20260519132905.145643-7-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Z1wmOswkffbs_QkLtjpdxGLok_UZ9ocN-9rdsa53Yio_1779197397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a script that takes as input the Registers.json file
delivered in the AARCHMRS Features Model downloadable from the
Arm Developer A-Profile Architecture Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
and automates the generation of system register properties definitions.

generates target/arm/cpu-idregs.h.inc containing definitions for
feature ID registers.

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 .../update-aarch64-cpu-sysreg-properties.py   | 168 ++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py

diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
new file mode 100644
index 0000000000..3571e228ee
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -0,0 +1,168 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs target/arm/cpu-sysreg-properties.c content.
+# There, initialize_cpu_sysreg_properties() populates arm64_id_regs array
+# with the name of each ID register and definition of all its fields
+# including their name and min/max bit under the form of the below pattern:
+#
+# /* CCSIDR2_EL1 */
+# ARM64SysReg *CCSIDR2_EL1 = arm64_sysreg_get(CCSIDR2_EL1_IDX);
+# CCSIDR2_EL1->name = "CCSIDR2_EL1";
+# arm64_sysreg_add_field(CCSIDR2_EL1, "NumSets", 0, 23);
+#
+# Copyright (C) 2026 Red Hat, Inc.
+#
+# Authors: Eric Auger <eric.auger@redhat.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+
+import json
+import os
+import sys
+from aarch64_sysreg_helpers import extract_idregs_from_registers_json
+
+def collect_fields(item, bit_offset=0):
+    """
+    Recursively finds all field-like objects, handling Fields.Array,
+    Fields.ArrayField, and ConditionalField structures.
+    Applies bit_offset from containers to child fields.
+    """
+    fields = []
+    if not isinstance(item, dict):
+        return fields
+
+    _type = item.get('_type', '')
+
+    # Array types (for example CLIDR_EL1 Ctype<n>, Ttype<n>)
+    if _type == 'Fields.Array':
+        name_template = item.get('name') or item.get('label', '')
+        index_info = item.get('indexes', [{}])[0]
+        start_idx = index_info.get('start', 0)
+        count = index_info.get('width', 0)
+
+        full_range = item.get('rangeset', [{}])[0]
+        bit_start = full_range.get('start', 0) + bit_offset
+        elem_width = full_range.get('width', 0) // count if count else 0
+
+        for i in range(count):
+            idx = start_idx + i
+            # Correctly handle indexed names like Ctype1, Ctype2
+            field_name = name_template.replace('<n>', str(idx))
+            fields.append({
+                'name': field_name,
+                'rangeset': [{
+                    'start': bit_start + (i * elem_width),
+                    'width': elem_width
+                }],
+                '_type': 'Fields.Field'
+            })
+        return fields
+
+    # ConditionalFields
+    elif _type == 'Fields.ConditionalField':
+        inner_offset = bit_offset
+        if item.get('rangeset'):
+            # Parent container defines the absolute start bit
+            inner_offset = item['rangeset'][0].get('start', bit_offset)
+
+        for entry in item.get('fields', []):
+            inner = entry.get('field')
+            if inner:
+                fields.extend(collect_fields(inner, inner_offset))
+        return fields
+
+    # Normal Field Types
+    leaf_types = ['Fields.Field', 'Fields.ConstantField',
+                  'Fields.EnumeratedField', 'Fields.Bitfield']
+    if _type in leaf_types:
+        field_copy = item.copy()
+        if field_copy.get('rangeset'):
+            new_ranges = []
+            for r in field_copy['rangeset']:
+                nr = r.copy()
+                # Apply the cumulative offset to the field's start bit
+                nr['start'] = r.get('start', 0) + bit_offset
+                new_ranges.append(nr)
+            field_copy['rangeset'] = new_ranges
+        fields.append(field_copy)
+        return fields
+
+    # Traverse the hierarchy for other cases
+    for key in ['fields', 'values', 'fieldsets']:
+        for nested in item.get(key, []):
+            fields.extend(collect_fields(nested, bit_offset))
+
+    return fields
+
+
+def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
+    with open(raw_json_path, 'r') as f:
+        register_data = json.load(f)
+
+    regs = {r.get('name'): r for r in register_data if r.get('_type') == 'Register'}
+
+    final_output = ""
+
+    for reg_name in id_reg_names:
+        register = regs.get(reg_name)
+        if not register:
+            continue
+
+        final_output += f"    IDREG_START({reg_name})\n"
+
+        unique_fields = {}
+        for fieldset in register.get('fieldsets', []):
+            candidates = collect_fields(fieldset)
+            for val in candidates:
+                name = (val.get('name') or val.get('label', '')).strip()
+                if not name or "RESERVED" in name.upper():
+                    continue
+                for r in val.get('rangeset', []):
+                    lsb = int(r.get('start'))
+                    width = r.get('width')
+                    msb = lsb + int(width) - 1
+
+                    # Only keep the fields with the highest MSB
+                    # needed fir CCSIDR_EL1
+                    if name not in unique_fields or msb > unique_fields[name]['msb']:
+                        unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width}
+
+        # Sort decreasing lsbs
+        sorted_fields = sorted(unique_fields.items(),
+                               key=lambda x: x[1]['lsb'], reverse=True)
+
+        for name, bits in sorted_fields:
+            line = (f"    IDREG_FIELD({reg_name}, "
+                    f"{name}, {bits['lsb']}, {bits['width']})\n")
+            final_output += line
+        final_output += f"    IDREG_END({reg_name})\n"
+        final_output += "\n"
+
+    os.makedirs("target/arm", exist_ok=True)
+    with open("target/arm/cpu-idregs.h.inc", 'w') as f:
+        f.write("/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n\n")
+        f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
+        f.write("/* IDREG_START(REG) */\n")
+        f.write("/* IDREG_FIELD(REG, FIELD, SHIFT, LENGTH) */\n")
+        f.write("/* ... */\n")
+        f.write("/* IDREG_END(REG) */\n\n")
+        f.write(final_output)
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print("Usage: python scripts/update-aarch64-cpu-sysreg-properties.py "
+              "<path_to_registers_json>")
+    else:
+        json_path = sys.argv[1]
+
+        id_regs_dict = extract_idregs_from_registers_json(json_path)
+        sorted_names = sorted(id_regs_dict.keys())
+
+        if sorted_names:
+            generate_sysreg_properties_from_registers_json(sorted_names, json_path)
+            print("Generated target/arm/cpu-idregs.h.inc")
-- 
2.53.0

