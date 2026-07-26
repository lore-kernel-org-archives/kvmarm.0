Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B5826C3BD
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080009; cv=none; b=VnBUXASBozJTnuWrEhNHKEyWSvSUzdB+xxVEfP4nAgt5nrmJuwTNtEUPzPzlcyzoM19GK/oMKQulRMidMwVn7OIYl9Ttc9Un57S/RSECOeCt4jac8FsK9+k9qUJ4rtqsaI8me1olADSqy90Tf0I4ojc3Br/xlFKBOfP+H8T1syw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080009; c=relaxed/simple;
	bh=JaF/9gF9rNCCuCP30cU28vNTQmp5P8ITBidcQtJIROI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=g9y/2GxWoYJEvPTE3cCfSbWsRi9c2dzc4NCBwojlBBZIAduHGi5dQmvjMJslVwO7qSLUeTrI90A/pJWNhPzm/uJVZB4EvtocV3F6oF/+P2BzQW/8l3K+1Qnd7rKhSg1XMm2ocEYmC3+nChD2yNT/2MBjb/1RbDmUpSiGgQ0DV4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eVYm/YbS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eVYm/YbS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785080007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DhixsKWT24zFPVpdhrpfzjTHfnfa7NPGnY2SIEHR/6Y=;
	b=eVYm/YbSDdM7fKTFGz3gyJcGFIFYmOdzlyTKg0F0grpoibt2eE3Eamqp4JFa6/Rsx68uqt
	q53YBKUu2ZZvaMwDnIJw+GvM/0ReuuD/nWMZB3xobqCWqYxim5Us4qnycgR0WUNbwi/Q47
	Bv8esocjhKazdaOqQqJF81WNnUIQESw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-INEQfpN2M0y1X2eE5i0EbQ-1; Sun,
 26 Jul 2026 11:33:23 -0400
X-MC-Unique: INEQfpN2M0y1X2eE5i0EbQ-1
X-Mimecast-MFC-AGG-ID: INEQfpN2M0y1X2eE5i0EbQ_1785080001
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C29D61956068;
	Sun, 26 Jul 2026 15:33:21 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.32.63])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 05A31180044F;
	Sun, 26 Jul 2026 15:33:10 +0000 (UTC)
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
Subject: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID register definitions
Date: Sun, 26 Jul 2026 17:29:42 +0200
Message-ID: <20260726153221.24773-5-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-1-eric.auger@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: LSJFLu36LT5I9hw7ev8Uiud_mYRjR0u2NbTRL0eWEts_1785080001
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce an infrastructure to store the definition of all ID regs:
This include their name, index and array of named fields.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>

---

v5 -> v6:
- add ArmIdRegArchVal
---
 target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..245f1c8103
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,41 @@
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
+typedef struct ArmIdRegArchVal {
+    uint64_t value;
+    const char *name;
+} ArmIdRegArchVal;
+
+typedef struct ARM64SysRegField {
+    const char *name; /* name of the field, for instance CTR_EL0_IDC */
+    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
+    int shift; /* lsb of the field in the register */
+    int length; /* highest bit number */
+    ArmIdRegArchVal *arch_vals;
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

