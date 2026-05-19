Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972BF2580F2
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197399; cv=none; b=SmwwAPAuE3wHYMuUT5LtqEQ6uIO5Lt/zzOtCyNe98GQVpvOqzUJJ7ICb70TR9IyEY/3aRXLyUB82xwUqtFtfTQ2losTgUvRsbHUOdAkLFbXMSKFlDJhxHhZ7qB1QxuZPYDzdO8qUGfAJHUaeqSvK9x2PhuQexV0XswRZOpvXp78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197399; c=relaxed/simple;
	bh=3H7fv26MEmewKv0W4ZWOaUSdcRMl4Xu6W+EsL2/wuV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E0woLARHwMxKTt1Pmf9j4VDeXDTG0Hlx+mta3h45UTIsO1V+HEeDfCsXAyX/Z9S0Cli8ryNPECBTWWSAKuo4UVR3YlMu/dql65sCaf0eyLdVZtPnegmqcsr4Jt/gEKqQ9OWMivAuBCyCKFkI5RiH4rDSkMlLb0BOAm66cvxcMos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dOux9Jye; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dOux9Jye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2dgC0fflJ1IwtES7qZ7pmfKjjmQsGVnqh8/2aG4sPf8=;
	b=dOux9JyeaoxGPchGrWP3hfzU7TsT9Kf1ex/0CRXQFkcs8ZRA8wbCV5mt8AmRuCF8eFBz2Q
	qbKJTuxGbHw8x8+7F2La2n2wYzySid6yV7FEP0yujVEpJDnL/yEGZuHL0LFQv8wfO/XhKV
	EzltieuWiMF/5xtbeBt8j9/9eiM6enY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-VXXyV1WNM56UHtLRmgR6sw-1; Tue,
 19 May 2026 09:29:52 -0400
X-MC-Unique: VXXyV1WNM56UHtLRmgR6sw-1
X-Mimecast-MFC-AGG-ID: VXXyV1WNM56UHtLRmgR6sw_1779197390
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6E8D195608E;
	Tue, 19 May 2026 13:29:49 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07F86180034E;
	Tue, 19 May 2026 13:29:43 +0000 (UTC)
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
Subject: [PATCH v5 05/18] scripts: Introduce scripts/aarch64_sysreg_helpers module
Date: Tue, 19 May 2026 15:27:19 +0200
Message-ID: <20260519132905.145643-6-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ROXkvCy5UbFRY9XaM-n2Dhmsei2JHSthtsiaNlf5Jag_1779197390
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

We plan to reuse get_opcode() and extract_idregs_from_registers_json()
functions in another script. So let's move them into a module

No functional change intended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 scripts/aarch64_sysreg_helpers.py            | 109 +++++++++++++++++++
 scripts/update-aarch64-cpu-sysregs-header.py |  85 +--------------
 2 files changed, 110 insertions(+), 84 deletions(-)
 create mode 100644 scripts/aarch64_sysreg_helpers.py

diff --git a/scripts/aarch64_sysreg_helpers.py b/scripts/aarch64_sysreg_helpers.py
new file mode 100644
index 0000000000..dd5ec4bafa
--- /dev/null
+++ b/scripts/aarch64_sysreg_helpers.py
@@ -0,0 +1,109 @@
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
+    registers = [r for r in register_data if isinstance(r, dict) and \
+                r.get('_type') == 'Register']
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
index 8c337147dd..43107264e9 100755
--- a/scripts/update-aarch64-cpu-sysregs-header.py
+++ b/scripts/update-aarch64-cpu-sysregs-header.py
@@ -17,90 +17,7 @@
 import json
 import os
 import sys
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
-    registers = [r for r in register_data if isinstance(r, dict) and \
-                r.get('_type') == 'Register']
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

