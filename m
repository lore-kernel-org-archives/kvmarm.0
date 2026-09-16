Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF8D35C687
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570083; cv=none; b=YiFZ/LXSdZzkXRSjHenBz92hykK4+omePca4I1pSTp+33nminH6xeG4J6Lnvkn5UGxrpr4HLpfi1ciL3957gajBrul5g5dPh/DGTGot4OdxvspjDwRn0E00ARAY27C7VNIK4CNlz+za3xSS8R4ZNkNPUJERINY4Ej7+HC/iyZ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570083; c=relaxed/simple;
	bh=RLDCzJkia/UGqOaVjqQ6btRMSdgv0996DfLKAF/lbIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oLA7KHaJn0mN8RuoYDuqMuYAiwUevSQHuSf0RS4/H3ebPd8J7rPZkoI1YuG/MeyoZSRA7DGhCIzXI6dkllGuY/1Ngh9TpEr9+Re01um9182TGEmvrK0hHCLd88Tbxx+Cyb098oTDY7Zr9ectj13wqF93gIW09scmIqEBIhnYOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvTNHFGT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvTNHFGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYMDAiuX3NMXS8zhqozIt3cUizP2vJsejo6cSarl3BA=;
	b=cvTNHFGTg/21yfqxem5h+sWcBuDK6FrrrsB50I6yhCceT85jdZ9vckdplY4yZA2x+8pLT/
	7l/LPDLzdzV4r0sRW06udXz835BdtbhhuHJT6Oo0SxHMirRkiSNEICFaNTgZpadhqn/GmU
	5mQxrKYT7Mcb/0Gph4xpEyh6wsJaq0w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-gQg_Eu7xMh-2uSLynwL-zQ-1; Wed,
 16 Sep 2026 10:47:55 -0400
X-MC-Unique: gQg_Eu7xMh-2uSLynwL-zQ-1
X-Mimecast-MFC-AGG-ID: gQg_Eu7xMh-2uSLynwL-zQ_1789570073
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82B841944DC5;
	Wed, 16 Sep 2026 14:47:53 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F63019560AB;
	Wed, 16 Sep 2026 14:47:48 +0000 (UTC)
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
Subject: [PATCH v9 04/26] arm/cpu: Add infra to handle generated ID register definitions
Date: Wed, 16 Sep 2026 16:45:27 +0200
Message-ID: <20260916144721.751810-5-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: bOfNLY6Y5N_rri8KVf950JZUvbGAlvmK0FOVPYztPTA_1789570073
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

