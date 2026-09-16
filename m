Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DFB388860
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570065; cv=none; b=H99bInwruQMLDnEQ5qDLLep7fCCBvxyQqsUYKWroZA1kGDVzXGNuzu5jisEQsx41E5eOJ4Tl08HQ3Rc6bXP4IVZSxEZ6w5iJSP2JQwCuRBchicR9odYpHN8Dax/DUBKZKFoEgJ9GDCHCHtLErZcj/yUUU4flL6NW5e8x4aJuZYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570065; c=relaxed/simple;
	bh=8gnDPXsWeTBYmvnrkFrARbwZBlFF81RnL4gTstX5JUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=KDtgkI4NH6/aI6OBdCIPNx8tLATuaND8/7TrZ2WA/8cgdQmUzHYH3Qvg1TcMHpyXIkWI+4aYITGKZt9TCzXqApRh0HUohj0KIaVCtfeUGWWJnQ4w3wUdJo/oi01OPU1hjadPXr1eAGwcyCNmBC6PrDBNgCew23OiaycUN1AT4Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3m5b8Ct; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3m5b8Ct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uP03KlOKpeHTeMd95FcR9Hp02Sc9mHGn69j2cuzds7M=;
	b=O3m5b8CtsXz7DpiL+gLHysrQXIhmpFIj7mFwV4eiQ+WGd7d4G4H2lxyHF7D79x54QYUVWJ
	gFklA8li+WC3CardEGHRPGsm8uMfDKigUwBN1Z5SGY+1cIn9GH970FkGefYruwbTPF0Y92
	+tSEUVwn7ZfkxvWE3V4AvU1vCZGoIHk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-37z_ZSZfPG-gflJfr6UcsA-1; Wed,
 16 Sep 2026 10:47:39 -0400
X-MC-Unique: 37z_ZSZfPG-gflJfr6UcsA-1
X-Mimecast-MFC-AGG-ID: 37z_ZSZfPG-gflJfr6UcsA_1789570057
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAB8E1955D5A;
	Wed, 16 Sep 2026 14:47:36 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D17761955F73;
	Wed, 16 Sep 2026 14:47:31 +0000 (UTC)
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
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v9 01/26] scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
Date: Wed, 16 Sep 2026 16:45:24 +0200
Message-ID: <20260916144721.751810-2-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: L5djE4bqQC0Lb1ULG0J0NjQUIkYlXCEQoX8N5fpaYTo_1789570057
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a script that takes as input the Registers.json file
delivered in the AARCHMRS Features Model downloadable from the
Arm Developer A-Profile Architecture Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>).

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Signed-off-by: Eric Auger <eric.auger@redhat.com>
[CH: note correct op1 range, don't skip CCSIDR]
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20251208163751.611186-2-eric.auger@redhat.com>
---
 scripts/update-aarch64-cpu-sysregs-header.py | 146 +++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py

diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
new file mode 100755
index 0000000000..ef1471a197
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysregs-header.py
@@ -0,0 +1,146 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
+# under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
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
+
+def is_demux_register(r):
+    name = r.get('name', '')
+
+    if name.startswith("CCSIDR"):
+        return True
+
+    return False
+
+# Some regs have op code values like 000x, 001x. Anyway we don't need
+# them. Besides some regs are undesired in the generated file such as
+# VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
+# are interested in and are tricky to decode as their system accessor
+# refer to MPIDR_EL1/MIDR_EL1 respectively
+
+skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
+            'VMPIDR_EL2', 'VPIDR_EL2']
+
+# returns the int value of a given @opcode for a reg @encoding
+def get_opcode(encoding, opcode):
+    fvalue = encoding.get(opcode)
+    if fvalue:
+        value = fvalue.get('value')
+        if isinstance(value, str):
+            value = value.strip("'")
+            value = int(value, 2)
+            return value
+    return -1
+
+def extract_idregs_from_registers_json(filename):
+    """
+    Load a Registers.json file and extract all ID registers, decode their
+    opcode and dump the information in target/arm/cpu-sysregs.h.inc
+
+    Args:
+        filename (str): The path to the Registers.json
+    returns:
+        idregs: list of ID regs and their encoding
+    """
+    if not os.path.exists(filename):
+        print(f"Error: {filename} could not be found!")
+        return {}
+
+    try:
+        with open(filename, 'r') as f:
+            register_data = json.load(f)
+
+    except json.JSONDecodeError:
+        print(f"Could not decode json from '{filename}'!")
+        return {}
+    except Exception as e:
+        print(f"Unexpected error while reading {filename}: {e}")
+        return {}
+
+    registers = [
+        r for r in register_data
+        if isinstance(r, dict)
+        and r.get('_type') == 'Register'
+        and not is_demux_register(r)
+    ]
+
+    idregs = {}
+
+    for register in registers:
+        reg_name = register.get('name')
+
+        is_skipped = any(term in (reg_name or "").upper() for term in skiplist)
+
+        if reg_name and not is_skipped:
+            accessors = register.get('accessors', [])
+
+            for accessor in accessors:
+                type = accessor.get('_type')
+                if type in ['Accessors.SystemAccessor']:
+                    encoding_list = accessor.get('encoding')
+
+                    if isinstance(encoding_list, list) and encoding_list and \
+                       isinstance(encoding_list[0], dict):
+                        encoding_wrapper = encoding_list[0]
+                        encoding_source = encoding_wrapper.get('encodings', \
+                                                               encoding_wrapper)
+
+                        if isinstance(encoding_source, dict):
+                                op0 = get_opcode(encoding_source, 'op0')
+                                op1 = get_opcode(encoding_source, 'op1')
+                                op2 = get_opcode(encoding_source, 'op2')
+                                crn = get_opcode(encoding_source, 'CRn')
+                                crm = get_opcode(encoding_source, 'CRm')
+                                encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
+
+                # ID regs are assumed within this scope
+                if op0 == 3 and (op1 == 0 or op1 == 1 or op1 == 3) and \
+                   crn == 0 and (crm >= 0 and crm <= 7) and (op2 >= 0 and op2 <= 7):
+                    idregs[reg_name] = encoding_str
+
+    return idregs
+
+if __name__ == "__main__":
+    # Single arg expected: the path to the Registers.json file
+    if len(sys.argv) < 2:
+        print("Usage: python scripts/update-aarch64-cpu-sysregs-header.py "
+              "<path_to_registers_json>")
+        sys.exit(1)
+    else:
+        json_file_path = sys.argv[1]
+
+    extracted_registers = extract_idregs_from_registers_json(json_file_path)
+
+    if extracted_registers:
+        output_list = extracted_registers.items()
+
+        # Sort by register name
+        sorted_output = sorted(output_list, key=lambda item: item[0])
+
+        # format lines as DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
+        final_output = ""
+        for reg_name, encoding in sorted_output:
+            reformatted_encoding = encoding.replace(" ", ", ")
+            final_output += f"DEF({reg_name}, {reformatted_encoding})\n"
+
+        with open("target/arm/cpu-sysregs.h.inc", 'w') as f:
+            f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
+            f.write("/* This file is autogenerated by ")
+            f.write("scripts/update-aarch64-cpu-sysregs-header.py */\n")
+            f.write("/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */\n\n")
+            f.write(final_output)
+        print("updated target/arm/cpu-sysregs.h.inc")
-- 
2.53.0

