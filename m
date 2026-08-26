Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70DB36F912
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737118; cv=none; b=NlYe15aZKgD8JoJViV2Nl4i/cbJQJCFr4QbzvjucoDJmykZe0iFHvFHVetB0TyqVSjLx4OFvAnXxp107p3M/qDwygmBloibaXvgkGF8Jd4czcoeeYkMAmd9Kz5MRWF+eLnR3yKoTBkboyRLSewsEOOEcgzd5GO72/fqm8d5BLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737118; c=relaxed/simple;
	bh=kvz+RSTashcOtWos/7NpJJSyuce0mX2dBIyehRqE6Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MAVp7hiMzB03x23pSUdsse7l3Fq24iUBjavuzdcswBHcuC1lo2xORvLYZmOlHLDN/AZfh8PSMzpEoxZQPD3pmEbE2FVZL4sFJ6oVM/UVOO8WrVrIPNPjhBW9CWfVC+jfo1WU4tsO0dixKFVAc1SuWeMOogVolpWPfRaWUKwDUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5d+r1Ea; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5d+r1Ea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XmgKG6NMohjgsyNM/iCgqjlycA3hA6zWHQIfm95HhtQ=;
	b=S5d+r1EaR7XKtPA4bgEZTzbPP4eJaDP5DeQzlnW2cRYfXZuJTEX9R3ZVTrnqKFT+IIYDTI
	ivU5zFmxf8vYP6XIqal56o9OkT6GiZ5OytrkvyxHTrV+Zbf4C1FmQOMqpHbl60FolOrfiA
	UoYdb7o0vHIIdppcw9io0MuL2xFFiUA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-3ARD8plnOByV-xzSflukgA-1; Wed,
 26 Aug 2026 05:38:32 -0400
X-MC-Unique: 3ARD8plnOByV-xzSflukgA-1
X-Mimecast-MFC-AGG-ID: 3ARD8plnOByV-xzSflukgA_1787737110
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 253F918CC496;
	Wed, 26 Aug 2026 09:38:30 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3F751955F05;
	Wed, 26 Aug 2026 09:38:23 +0000 (UTC)
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
Subject: [RFC PATCH v8 05/20] scripts: Introduce scripts/aarch64_sysreg_helpers module
Date: Wed, 26 Aug 2026 11:36:10 +0200
Message-ID: <20260826093747.1670077-6-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: XeYScZUG0Nka6DXknr3rdzSpNsQfWCwFnCRasFItiGI_1787737110
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We plan to reuse get_opcode() and extract_idregs_from_registers_json()
functions in another script. So let's move them into a module

No functional change intended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Khushit Shah <khushit.shah@nutanix.com>
---
 scripts/aarch64_sysreg_helpers.py            | 121 +++++++++++++++++++
 scripts/update-aarch64-cpu-sysregs-header.py |  97 +--------------
 2 files changed, 122 insertions(+), 96 deletions(-)
 create mode 100644 scripts/aarch64_sysreg_helpers.py

diff --git a/scripts/aarch64_sysreg_helpers.py b/scripts/aarch64_sysreg_helpers.py
new file mode 100644
index 0000000000..24bbc5bb3d
--- /dev/null
+++ b/scripts/aarch64_sysreg_helpers.py
@@ -0,0 +1,121 @@
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
+
+import json
+import os
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
+    # Some regs have op code values like 000x, 001x. Anyway we don't need
+    # them. Besides some regs are undesired in the generated file such as
+    # VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
+    # are interested in and are tricky to decode as their system accessor
+    # refer to MPIDR_EL1/MIDR_EL1 respectively
+
+    skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
+                'VMPIDR_EL2', 'VPIDR_EL2']
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
+
+
diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
index ef1471a197..43107264e9 100755
--- a/scripts/update-aarch64-cpu-sysregs-header.py
+++ b/scripts/update-aarch64-cpu-sysregs-header.py
@@ -17,102 +17,7 @@
 import json
 import os
 import sys
-
-def is_demux_register(r):
-    name = r.get('name', '')
-
-    if name.startswith("CCSIDR"):
-        return True
-
-    return False
-
-# Some regs have op code values like 000x, 001x. Anyway we don't need
-# them. Besides some regs are undesired in the generated file such as
-# VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
-# are interested in and are tricky to decode as their system accessor
-# refer to MPIDR_EL1/MIDR_EL1 respectively
-
-skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
-            'VMPIDR_EL2', 'VPIDR_EL2']
-
-# returns the int value of a given @opcode for a reg @encoding
-def get_opcode(encoding, opcode):
-    fvalue = encoding.get(opcode)
-    if fvalue:
-        value = fvalue.get('value')
-        if isinstance(value, str):
-            value = value.strip("'")
-            value = int(value, 2)
-            return value
-    return -1
-
-def extract_idregs_from_registers_json(filename):
-    """
-    Load a Registers.json file and extract all ID registers, decode their
-    opcode and dump the information in target/arm/cpu-sysregs.h.inc
-
-    Args:
-        filename (str): The path to the Registers.json
-    returns:
-        idregs: list of ID regs and their encoding
-    """
-    if not os.path.exists(filename):
-        print(f"Error: {filename} could not be found!")
-        return {}
-
-    try:
-        with open(filename, 'r') as f:
-            register_data = json.load(f)
-
-    except json.JSONDecodeError:
-        print(f"Could not decode json from '{filename}'!")
-        return {}
-    except Exception as e:
-        print(f"Unexpected error while reading {filename}: {e}")
-        return {}
-
-    registers = [
-        r for r in register_data
-        if isinstance(r, dict)
-        and r.get('_type') == 'Register'
-        and not is_demux_register(r)
-    ]
-
-    idregs = {}
-
-    for register in registers:
-        reg_name = register.get('name')
-
-        is_skipped = any(term in (reg_name or "").upper() for term in skiplist)
-
-        if reg_name and not is_skipped:
-            accessors = register.get('accessors', [])
-
-            for accessor in accessors:
-                type = accessor.get('_type')
-                if type in ['Accessors.SystemAccessor']:
-                    encoding_list = accessor.get('encoding')
-
-                    if isinstance(encoding_list, list) and encoding_list and \
-                       isinstance(encoding_list[0], dict):
-                        encoding_wrapper = encoding_list[0]
-                        encoding_source = encoding_wrapper.get('encodings', \
-                                                               encoding_wrapper)
-
-                        if isinstance(encoding_source, dict):
-                                op0 = get_opcode(encoding_source, 'op0')
-                                op1 = get_opcode(encoding_source, 'op1')
-                                op2 = get_opcode(encoding_source, 'op2')
-                                crn = get_opcode(encoding_source, 'CRn')
-                                crm = get_opcode(encoding_source, 'CRm')
-                                encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
-
-                # ID regs are assumed within this scope
-                if op0 == 3 and (op1 == 0 or op1 == 1 or op1 == 3) and \
-                   crn == 0 and (crm >= 0 and crm <= 7) and (op2 >= 0 and op2 <= 7):
-                    idregs[reg_name] = encoding_str
-
-    return idregs
+from aarch64_sysreg_helpers import extract_idregs_from_registers_json
 
 if __name__ == "__main__":
     # Single arg expected: the path to the Registers.json file
-- 
2.53.0

