Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F913DD849
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639490; cv=none; b=Ze/ALWzszJ3TB6x91jMJh71eAdb84GVG8E6yIDVypzUhIXR/pLJaEVqDx8cRvcVPcSX2HsIlZr8BI+2zyySwXtzY2ObK2rM3YdFVpuuWcO1p1b06NabWHF2EiRXRTxIYqiNk8PfwHENfpsAxeFaXgezsvJEbKMbEZjkbTsABdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639490; c=relaxed/simple;
	bh=caOCndAJLxHVI+67Yp9O2Ig2uWhxggle+x6hlZS/slk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gKSg7sNsCHWfSEKSLnLvUU/lkYJG5J7+iEdEfcsCv8tekyQG83xg0yrGl1A4t6nhk0/meQ5clB8euaffJQzPJHx2M59C5KDSTOH/BpPUvH+HQ/yIXzcUgoE8JsXqx4OvDlPaqK028KNuzURFjFQweqOAxD1CjGGKtTqz7l4yJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWzGf/xy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWzGf/xy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zMymiCc6qFGUfLZrmpJjxZKSMoCg+G0Tr++d0qjFL0=;
	b=IWzGf/xybnb24l/vnAZPprOBdvLQOuMgrlV9VqwSx6UA0Mcxj+n2OrKCsMXcw0Jd5YBQDh
	CiMB1DAYLiJ9mNuF3BXrXo0eqTbsWjZNRh41J31sYVJfQVQwXFqgvZWGE032YynrFh6Fem
	5K99bMa52AEKKJXXaPIgUTXTKGOmECA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-Z4dtRfjRNQq8KefrgrrSvQ-1; Sat,
 10 Oct 2026 13:38:01 +0000
X-MC-Unique: Z4dtRfjRNQq8KefrgrrSvQ-1
X-Mimecast-MFC-AGG-ID: Z4dtRfjRNQq8KefrgrrSvQ_1791639475
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3469D1801321;
	Sat, 10 Oct 2026 13:37:55 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B042130000E5;
	Sat, 10 Oct 2026 13:37:50 +0000 (UTC)
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
Subject: [PATCH v10 04/26] target/arm/cpu-sysregs.h.inc: Update with automatic generation
Date: Sat, 10 Oct 2026 15:36:08 +0200
Message-ID: <20261010133725.642498-5-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: W9RENN_C2P7VS-zbqZmAJEqnn8ZHZHtbnQVKSoSG7Q0_1791639475
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce scripts/update-aarch64-cpu-sysregs-header.py that takes
as input the Registers.json file delivered in the AARCHMRS Features
Model downloadable from the Arm Developer A-Profile Architecture
Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads

and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) or
DEF_MUX(<name>, <op0>, <op1>, <crn>, <crm>, <op2>, <length>)

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

As we plan to reuse get_opcode() and extract_idregs_from_registers_json()
functions in another script, put them in a separate module.

Update target/arm/cpu-sysregs.h.inc with the script.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v9 -> v10:
- squashed 3 patches: main script, module and generated file
- improve the comment related to skipped registers. Move is_demux in
  the loop. Fix indent.
- sort by reg name inside the helper
- add support for DEMUX register
---
 target/arm/cpu-sysregs.h.inc                 |  10 ++
 scripts/aarch64_sysreg_helpers.py            | 118 +++++++++++++++++++
 scripts/update-aarch64-cpu-sysregs-header.py |  59 ++++++++++
 3 files changed, 187 insertions(+)
 create mode 100644 scripts/aarch64_sysreg_helpers.py
 create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index f148f6f565..c15ce8fc7e 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,12 +1,21 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
+/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
+/* DEF_MUX(<name>, <op0>, <op1>, <crn>, <crm>, <op2>, <length>) */
+
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
+DEF_MUX(CCSIDR2_EL1, 3, 1, 0, 0, 2, 16)
 DEF_MUX(CCSIDR_EL1, 3, 1, 0, 0, 0, 16)
 DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
 DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(GMID_EL1, 3, 1, 0, 0, 4)
 DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
 DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
 DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
 DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
 DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
@@ -47,3 +56,4 @@ DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
 DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
+DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
diff --git a/scripts/aarch64_sysreg_helpers.py b/scripts/aarch64_sysreg_helpers.py
new file mode 100644
index 0000000000..53ca0eecbf
--- /dev/null
+++ b/scripts/aarch64_sysreg_helpers.py
@@ -0,0 +1,118 @@
+#!/usr/bin/env python3
+
+# Helpers used in aarch64 sysreg definition generation
+#
+# Copyright (C) 2026 Red Hat, Inc.
+#
+# Authors: Eric Auger <eric.auger@redhat.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+import json
+import os
+
+# Some regs have op code values like 000x, 001x. skip them explicitly
+# as they are not needed anyway. Also, although VMPIDR_EL2 and VPIDR_EL2
+# have opcodes outside of the ID reg scope, they have MPIDR_EL1/MIDR_EL1
+# accessors because if EL2 is not implemented, reads of those register
+# return the value of MPIDR_EL1/MIDR_EL1. Skip them too.
+
+skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', 'VMPIDR_EL2', 'VPIDR_EL2']
+
+# return a tuple containing whether a register is a demux register and if yes
+# we also output its length. Currently we only handle CCSIDR.
+
+def get_demux_register_info(r):
+    name = r.get('name', '')
+    if not isinstance(r, dict):
+        return False, 0
+
+    if name.startswith("CCSIDR"):
+        return True, 16
+
+    return False, 0
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
+    Load a Registers.json file and extract all ID registers into
+    idregs[] dictionary whose key is the name of the register and
+    the value a string containing the opcodes.
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
+                            op0 = get_opcode(encoding_source, 'op0')
+                            op1 = get_opcode(encoding_source, 'op1')
+                            op2 = get_opcode(encoding_source, 'op2')
+                            crn = get_opcode(encoding_source, 'CRn')
+                            crm = get_opcode(encoding_source, 'CRm')
+                            encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
+
+                            # ID regs are assumed within this scope
+                            if op0 == 3 and op1 in (0, 1, 3) and \
+                               crn == 0 and (0 <= crm <= 7) and (0 <= op2 <= 7):
+                                is_demux, demux_length = get_demux_register_info(register)
+                                idregs[reg_name] = {
+                                        "encoding": encoding_str,
+                                        "is_demux": is_demux,
+                                        "demux_length": demux_length
+                                }
+
+    # sort by register name
+    return dict(sorted(idregs.items()))
diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
new file mode 100755
index 0000000000..669314384b
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysregs-header.py
@@ -0,0 +1,59 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
+# under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) or
+# DEF_MUX(<name>, <op0>, <op1>, <crn>, <crm>, <op2>, <length>)
+#
+# Copyright (C) 2027 Red Hat, Inc.
+#
+# Authors: Eric Auger <eric.auger@redhat.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+import json
+import os
+import sys
+
+from aarch64_sysreg_helpers import extract_idregs_from_registers_json
+
+if __name__ == "__main__":
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
+        idregs = extracted_registers.items()
+
+        # format lines as DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
+        final_output = ""
+        for reg_name, info in idregs:
+            reformatted_encoding = info["encoding"].replace(" ", ", ")
+            is_demux = info.get("is_demux", False)
+            demux_length = info.get("demux_length", 0)
+
+            if is_demux:
+                final_output += (
+                    f"DEF_MUX({reg_name}, {reformatted_encoding}, "
+                    f"{demux_length})\n"
+                )
+            else:
+                final_output += f"DEF({reg_name}, {reformatted_encoding})\n"
+
+        with open("target/arm/cpu-sysregs.h.inc", 'w') as f:
+            f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
+            f.write("/* This file is autogenerated by ")
+            f.write("scripts/update-aarch64-cpu-sysregs-header.py */\n")
+            f.write("/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */\n")
+            f.write("/* DEF_MUX(<name>, <op0>, <op1>, <crn>, <crm>, <op2>, "
+                    "<length>) */\n\n")
+            f.write(final_output)
+        print("updated target/arm/cpu-sysregs.h.inc")
-- 
2.53.0

