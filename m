Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE4933AD9C
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737111; cv=none; b=Fg6MnN3f9fS5Tuul15GV+50gbeyMC2/QSQQMhxaLsXwXZ9lRPltPd/hZQ4SfYrw3ppeYO9KSP/aREIQ5pEf4/iy0K9VnnWXoG+iBiJElCyqmC4eMRgYlPQRRDJnEnv64Ia/VvEJ5HcCgw4iP90eP2UTnU4BDBYGE7LtfgpfJvbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737111; c=relaxed/simple;
	bh=RLDCzJkia/UGqOaVjqQ6btRMSdgv0996DfLKAF/lbIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Jm/yT2+MjC9uj91coBYeMlCV4A+ziDzlRsv9niSSix6wNN47EbNIb76CT2mVEdd3cQWuJwft9gibXvuaAMsTkCeUrphNP+RjhC5gSG33SCskb1ARh12bEfGmO3XxWAvzzVxLKnxtEwhrmOsaNN/1IoW1PbxDxQF/WhYAEQXXsXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KaSAxlxv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KaSAxlxv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYMDAiuX3NMXS8zhqozIt3cUizP2vJsejo6cSarl3BA=;
	b=KaSAxlxvtW+sIDlr2m5z825LMMargv/T5dCD7ppypfgTzBqAwUibTeGdmKNRFp2AXBrqjY
	6dvZ6jv4TRhcr0XdxeYYq6ktuFcPnYmILcomPqliGSLAeSzC1EofpOisMXWMHLde5TYn0r
	BbRCoyStSNRhKKXBvXDxDq+6kC2TbHg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-VmDD3r8fPwquTFttcLukuw-1; Wed,
 26 Aug 2026 05:38:25 -0400
X-MC-Unique: VmDD3r8fPwquTFttcLukuw-1
X-Mimecast-MFC-AGG-ID: VmDD3r8fPwquTFttcLukuw_1787737103
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A3D0197765F;
	Wed, 26 Aug 2026 09:38:23 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5CC9F1955F05;
	Wed, 26 Aug 2026 09:38:17 +0000 (UTC)
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
Subject: [RFC PATCH v8 04/20] arm/cpu: Add infra to handle generated ID register definitions
Date: Wed, 26 Aug 2026 11:36:09 +0200
Message-ID: <20260826093747.1670077-5-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: mp_jnMx07zvFwR2BegwkAAUhdWHsALZqVaCx0PCCtLI_1787737103
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce an infrastructure to store the definition of all ID regs:
This include their name, index and array of named fields.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

---
v7 -> v8:
- remove typedef struct ArmIdRegArchVal

v5 -> v6:
- add ArmIdRegArchVal
---
 target/arm/cpu-idregs.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..98c7a7518f
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,36 @@
+/*
+ * handle ID registers and their fields
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#ifndef TARGET_ARM_CPU_IDREGS_H
+#define TARGET_ARM_CPU_IDREGS_H
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "cpu.h"
+#include "cpu-sysregs.h"
+
+typedef struct ARM64SysRegField {
+    const char *name; /* name of the field, for instance CTR_EL0_IDC */
+    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
+    int shift; /* lsb of the field in the register */
+    int length; /* highest bit number */
+    uint64_t *arch_vals;
+    uint32_t arch_vals_count;
+} ARM64SysRegField;
+
+typedef struct ARM64SysReg {
+    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
+    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
+    struct ARM64SysRegField *fields;
+    uint32_t fields_count;
+    uint64_t writable_mask;
+} ARM64SysReg;
+
+/*
+ * List of exposed ID regs (automatically populated from AARCHMRS Registers.json)
+ */
+extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
+
+#endif
-- 
2.53.0

