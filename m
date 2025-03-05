Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0BB2517AF
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 16:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192958; cv=none; b=WCBNI0LOpOB2XjSPcBbkLuruPARBJfv8EARxG1tfU9L0hMaKai5CxXJeXAbGGqxofVjCHtRvBElw23ska8CK+EQYaocKkDaXTjuuNrlAthshf+lxMnHpgtOiVVMUXlmAT14Mme8OCciK5w8CycromImZakiFioA7m/1jZXtxgWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192958; c=relaxed/simple;
	bh=xWfKtodQDkcZ7NLEzQfqs0PRFXwuRBEPhtJr+oE/jOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jkGRHeQhdYALqv+fPIk2gAh771VOpzOu5da9NxvEH2YE/B0Ga9B1v0SvCs/zEs6TA5iZ0Sp4udgzij3VN2KUYGbvv+qHuvJvhzuFWNrKmlufQbhwFDBJXUb3lEFm4B4pU/nKJObS1M3r4LOpZuv+szCpBFp+ckzpEIzkERYhLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=buPA8CYn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="buPA8CYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnclmN74HTl3Tg3O8yHBiRcH3fZb18iLB6RZpAFmyvI=;
	b=buPA8CYnFnNil17i2SkhCUCC1ZrybH0ZLp95RYJpE/eJNtjOmeOBsIL6ch1h4345IT5KPe
	bAle0Qr2/cBpzfc2ZhOILIe89H7O30O3wfM0pxXDLe/Nq5L6e94Y2jcbIRLwK6xwst7Q7L
	BDrj60d157BKQiI+KRB2HtscKikvC8k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-GmwD5RQxNv2yt9VQwdL2Mw-1; Wed,
 05 Mar 2025 11:42:33 -0500
X-MC-Unique: GmwD5RQxNv2yt9VQwdL2Mw-1
X-Mimecast-MFC-AGG-ID: GmwD5RQxNv2yt9VQwdL2Mw_1741192951
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F88F1828A80;
	Wed,  5 Mar 2025 16:42:31 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.9])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D91C31956095;
	Wed,  5 Mar 2025 16:42:15 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 14/14] arm/cpu: Add generated files
Date: Wed,  5 Mar 2025 17:38:19 +0100
Message-ID: <20250305163819.2477553-15-cohuck@redhat.com>
In-Reply-To: <20250305163819.2477553-1-cohuck@redhat.com>
References: <20250305163819.2477553-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

And switch to using the generated definitions.

Generated against Linux 6.14-rc1.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h     | 116 +-----------------------
 target/arm/cpu-sysregs.h.inc | 167 +++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 114 deletions(-)
 create mode 100644 target/arm/cpu-sysregs.h.inc

diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
index 54a4fadbf0c1..6074516c6d2c 100644
--- a/target/arm/cpu-sysregs.h
+++ b/target/arm/cpu-sysregs.h
@@ -13,120 +13,8 @@
      ((crm) << CP_REG_ARM64_SYSREG_CRM_SHIFT) |         \
      ((op2) << CP_REG_ARM64_SYSREG_OP2_SHIFT))
 
-typedef enum ARMIDRegisterIdx {
-    ID_AA64PFR0_EL1_IDX,
-    ID_AA64PFR1_EL1_IDX,
-    ID_AA64SMFR0_EL1_IDX,
-    ID_AA64DFR0_EL1_IDX,
-    ID_AA64DFR1_EL1_IDX,
-    ID_AA64ISAR0_EL1_IDX,
-    ID_AA64ISAR1_EL1_IDX,
-    ID_AA64ISAR2_EL1_IDX,
-    ID_AA64MMFR0_EL1_IDX,
-    ID_AA64MMFR1_EL1_IDX,
-    ID_AA64MMFR2_EL1_IDX,
-    ID_AA64MMFR3_EL1_IDX,
-    ID_PFR0_EL1_IDX,
-    ID_PFR1_EL1_IDX,
-    ID_DFR0_EL1_IDX,
-    ID_MMFR0_EL1_IDX,
-    ID_MMFR1_EL1_IDX,
-    ID_MMFR2_EL1_IDX,
-    ID_MMFR3_EL1_IDX,
-    ID_ISAR0_EL1_IDX,
-    ID_ISAR1_EL1_IDX,
-    ID_ISAR2_EL1_IDX,
-    ID_ISAR3_EL1_IDX,
-    ID_ISAR4_EL1_IDX,
-    ID_ISAR5_EL1_IDX,
-    ID_MMFR4_EL1_IDX,
-    ID_ISAR6_EL1_IDX,
-    MVFR0_EL1_IDX,
-    MVFR1_EL1_IDX,
-    MVFR2_EL1_IDX,
-    ID_PFR2_EL1_IDX,
-    ID_DFR1_EL1_IDX,
-    ID_MMFR5_EL1_IDX,
-    ID_AA64ZFR0_EL1_IDX,
-    CTR_EL0_IDX,
-    NUM_ID_IDX,
-} ARMIDRegisterIdx;
-
-typedef enum ARMSysRegs {
-    SYS_ID_AA64PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 0),
-    SYS_ID_AA64PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 1),
-    SYS_ID_AA64SMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 5),
-    SYS_ID_AA64DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 0),
-    SYS_ID_AA64DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 1),
-    SYS_ID_AA64ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 0),
-    SYS_ID_AA64ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 1),
-    SYS_ID_AA64ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 2),
-    SYS_ID_AA64MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 0),
-    SYS_ID_AA64MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 1),
-    SYS_ID_AA64MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 2),
-    SYS_ID_AA64MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 3),
-    SYS_ID_PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 0),
-    SYS_ID_PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 1),
-    SYS_ID_DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 2),
-    SYS_ID_MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 4),
-    SYS_ID_MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 5),
-    SYS_ID_MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 6),
-    SYS_ID_MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 7),
-    SYS_ID_ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 0),
-    SYS_ID_ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 1),
-    SYS_ID_ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 2),
-    SYS_ID_ISAR3_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 3),
-    SYS_ID_ISAR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 4),
-    SYS_ID_ISAR5_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 5),
-    SYS_ID_MMFR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 6),
-    SYS_ID_ISAR6_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 7),
-    SYS_MVFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 0),
-    SYS_MVFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 1),
-    SYS_MVFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 2),
-    SYS_ID_PFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 4),
-    SYS_ID_DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 5),
-    SYS_ID_MMFR5_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 6),
-    SYS_ID_AA64ZFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 4),
-    SYS_CTR_EL0 = ENCODE_ID_REG(3, 3, 0, 0, 1),
-} ARMSysRegs;
-
-static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
-    [ID_AA64PFR0_EL1_IDX] = SYS_ID_AA64PFR0_EL1,
-    [ID_AA64PFR1_EL1_IDX] = SYS_ID_AA64PFR1_EL1,
-    [ID_AA64SMFR0_EL1_IDX] = SYS_ID_AA64SMFR0_EL1,
-    [ID_AA64DFR0_EL1_IDX] = SYS_ID_AA64DFR0_EL1,
-    [ID_AA64DFR1_EL1_IDX] = SYS_ID_AA64DFR1_EL1,
-    [ID_AA64ISAR0_EL1_IDX] = SYS_ID_AA64ISAR0_EL1,
-    [ID_AA64ISAR1_EL1_IDX] = SYS_ID_AA64ISAR1_EL1,
-    [ID_AA64ISAR2_EL1_IDX] = SYS_ID_AA64ISAR2_EL1,
-    [ID_AA64MMFR0_EL1_IDX] = SYS_ID_AA64MMFR0_EL1,
-    [ID_AA64MMFR1_EL1_IDX] = SYS_ID_AA64MMFR1_EL1,
-    [ID_AA64MMFR2_EL1_IDX] = SYS_ID_AA64MMFR2_EL1,
-    [ID_AA64MMFR3_EL1_IDX] = SYS_ID_AA64MMFR3_EL1,
-    [ID_PFR0_EL1_IDX] = SYS_ID_PFR0_EL1,
-    [ID_PFR1_EL1_IDX] = SYS_ID_PFR1_EL1,
-    [ID_DFR0_EL1_IDX] = SYS_ID_DFR0_EL1,
-    [ID_MMFR0_EL1_IDX] = SYS_ID_MMFR0_EL1,
-    [ID_MMFR1_EL1_IDX] = SYS_ID_MMFR1_EL1,
-    [ID_MMFR2_EL1_IDX] = SYS_ID_MMFR2_EL1,
-    [ID_MMFR3_EL1_IDX] = SYS_ID_MMFR3_EL1,
-    [ID_ISAR0_EL1_IDX] = SYS_ID_ISAR0_EL1,
-    [ID_ISAR1_EL1_IDX] = SYS_ID_ISAR1_EL1,
-    [ID_ISAR2_EL1_IDX] = SYS_ID_ISAR2_EL1,
-    [ID_ISAR3_EL1_IDX] = SYS_ID_ISAR3_EL1,
-    [ID_ISAR4_EL1_IDX] = SYS_ID_ISAR4_EL1,
-    [ID_ISAR5_EL1_IDX] = SYS_ID_ISAR5_EL1,
-    [ID_MMFR4_EL1_IDX] = SYS_ID_MMFR4_EL1,
-    [ID_ISAR6_EL1_IDX] = SYS_ID_ISAR6_EL1,
-    [MVFR0_EL1_IDX] = SYS_MVFR0_EL1,
-    [MVFR1_EL1_IDX] = SYS_MVFR1_EL1,
-    [MVFR2_EL1_IDX] = SYS_MVFR2_EL1,
-    [ID_PFR2_EL1_IDX] = SYS_ID_PFR2_EL1,
-    [ID_DFR1_EL1_IDX] = SYS_ID_DFR1_EL1,
-    [ID_MMFR5_EL1_IDX] = SYS_ID_MMFR5_EL1,
-    [ID_AA64ZFR0_EL1_IDX] = SYS_ID_AA64ZFR0_EL1,
-    [CTR_EL0_IDX] = SYS_CTR_EL0,
-};
+/* include generated definitions */
+#include "cpu-sysregs.h.inc"
 
 int get_sysreg_idx(ARMSysRegs sysreg);
 uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
new file mode 100644
index 000000000000..9236c36696df
--- /dev/null
+++ b/target/arm/cpu-sysregs.h.inc
@@ -0,0 +1,167 @@
+/* GENERATED FILE -- DO NOT EDIT */
+#ifndef ARCH_ARM_CPU_SYSREGS_H_INC
+#define ARCH_ARM_CPU_SYSREGS_H_INC
+
+typedef enum ARMIDRegisterIdx {
+    ID_PFR0_EL1_IDX,
+    ID_PFR1_EL1_IDX,
+    ID_DFR0_EL1_IDX,
+    ID_AFR0_EL1_IDX,
+    ID_MMFR0_EL1_IDX,
+    ID_MMFR1_EL1_IDX,
+    ID_MMFR2_EL1_IDX,
+    ID_MMFR3_EL1_IDX,
+    ID_ISAR0_EL1_IDX,
+    ID_ISAR1_EL1_IDX,
+    ID_ISAR2_EL1_IDX,
+    ID_ISAR3_EL1_IDX,
+    ID_ISAR4_EL1_IDX,
+    ID_ISAR5_EL1_IDX,
+    ID_ISAR6_EL1_IDX,
+    ID_MMFR4_EL1_IDX,
+    MVFR0_EL1_IDX,
+    MVFR1_EL1_IDX,
+    MVFR2_EL1_IDX,
+    ID_PFR2_EL1_IDX,
+    ID_DFR1_EL1_IDX,
+    ID_MMFR5_EL1_IDX,
+    ID_AA64PFR0_EL1_IDX,
+    ID_AA64PFR1_EL1_IDX,
+    ID_AA64PFR2_EL1_IDX,
+    ID_AA64ZFR0_EL1_IDX,
+    ID_AA64SMFR0_EL1_IDX,
+    ID_AA64FPFR0_EL1_IDX,
+    ID_AA64DFR0_EL1_IDX,
+    ID_AA64DFR1_EL1_IDX,
+    ID_AA64DFR2_EL1_IDX,
+    ID_AA64AFR0_EL1_IDX,
+    ID_AA64AFR1_EL1_IDX,
+    ID_AA64ISAR0_EL1_IDX,
+    ID_AA64ISAR1_EL1_IDX,
+    ID_AA64ISAR2_EL1_IDX,
+    ID_AA64ISAR3_EL1_IDX,
+    ID_AA64MMFR0_EL1_IDX,
+    ID_AA64MMFR1_EL1_IDX,
+    ID_AA64MMFR2_EL1_IDX,
+    ID_AA64MMFR3_EL1_IDX,
+    ID_AA64MMFR4_EL1_IDX,
+    CCSIDR_EL1_IDX,
+    CLIDR_EL1_IDX,
+    CCSIDR2_EL1_IDX,
+    GMID_EL1_IDX,
+    SMIDR_EL1_IDX,
+    CSSELR_EL1_IDX,
+    CTR_EL0_IDX,
+    DCZID_EL0_IDX,
+    NUM_ID_IDX,
+} ARMIDRegisterIdx;
+
+
+typedef enum ARMSysRegs {
+    SYS_ID_PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 0),
+    SYS_ID_PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 1),
+    SYS_ID_DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 2),
+    SYS_ID_AFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 3),
+    SYS_ID_MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 4),
+    SYS_ID_MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 5),
+    SYS_ID_MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 6),
+    SYS_ID_MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 1, 7),
+    SYS_ID_ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 0),
+    SYS_ID_ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 1),
+    SYS_ID_ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 2),
+    SYS_ID_ISAR3_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 3),
+    SYS_ID_ISAR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 4),
+    SYS_ID_ISAR5_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 5),
+    SYS_ID_ISAR6_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 7),
+    SYS_ID_MMFR4_EL1 = ENCODE_ID_REG(3, 0, 0, 2, 6),
+    SYS_MVFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 0),
+    SYS_MVFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 1),
+    SYS_MVFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 2),
+    SYS_ID_PFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 4),
+    SYS_ID_DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 5),
+    SYS_ID_MMFR5_EL1 = ENCODE_ID_REG(3, 0, 0, 3, 6),
+    SYS_ID_AA64PFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 0),
+    SYS_ID_AA64PFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 1),
+    SYS_ID_AA64PFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 2),
+    SYS_ID_AA64ZFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 4),
+    SYS_ID_AA64SMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 5),
+    SYS_ID_AA64FPFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 4, 7),
+    SYS_ID_AA64DFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 0),
+    SYS_ID_AA64DFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 1),
+    SYS_ID_AA64DFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 2),
+    SYS_ID_AA64AFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 4),
+    SYS_ID_AA64AFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 5, 5),
+    SYS_ID_AA64ISAR0_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 0),
+    SYS_ID_AA64ISAR1_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 1),
+    SYS_ID_AA64ISAR2_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 2),
+    SYS_ID_AA64ISAR3_EL1 = ENCODE_ID_REG(3, 0, 0, 6, 3),
+    SYS_ID_AA64MMFR0_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 0),
+    SYS_ID_AA64MMFR1_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 1),
+    SYS_ID_AA64MMFR2_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 2),
+    SYS_ID_AA64MMFR3_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 3),
+    SYS_ID_AA64MMFR4_EL1 = ENCODE_ID_REG(3, 0, 0, 7, 4),
+    SYS_CCSIDR_EL1 = ENCODE_ID_REG(3, 1, 0, 0, 0),
+    SYS_CLIDR_EL1 = ENCODE_ID_REG(3, 1, 0, 0, 1),
+    SYS_CCSIDR2_EL1 = ENCODE_ID_REG(3, 1, 0, 0, 2),
+    SYS_GMID_EL1 = ENCODE_ID_REG(3, 1, 0, 0, 4),
+    SYS_SMIDR_EL1 = ENCODE_ID_REG(3, 1, 0, 0, 6),
+    SYS_CSSELR_EL1 = ENCODE_ID_REG(3, 2, 0, 0, 0),
+    SYS_CTR_EL0 = ENCODE_ID_REG(3, 3, 0, 0, 1),
+    SYS_DCZID_EL0 = ENCODE_ID_REG(3, 3, 0, 0, 7),
+} ARMSysRegs;
+
+
+static const uint32_t id_register_sysreg[NUM_ID_IDX] = {
+    [ID_PFR0_EL1_IDX] = SYS_ID_PFR0_EL1,
+    [ID_PFR1_EL1_IDX] = SYS_ID_PFR1_EL1,
+    [ID_DFR0_EL1_IDX] = SYS_ID_DFR0_EL1,
+    [ID_AFR0_EL1_IDX] = SYS_ID_AFR0_EL1,
+    [ID_MMFR0_EL1_IDX] = SYS_ID_MMFR0_EL1,
+    [ID_MMFR1_EL1_IDX] = SYS_ID_MMFR1_EL1,
+    [ID_MMFR2_EL1_IDX] = SYS_ID_MMFR2_EL1,
+    [ID_MMFR3_EL1_IDX] = SYS_ID_MMFR3_EL1,
+    [ID_ISAR0_EL1_IDX] = SYS_ID_ISAR0_EL1,
+    [ID_ISAR1_EL1_IDX] = SYS_ID_ISAR1_EL1,
+    [ID_ISAR2_EL1_IDX] = SYS_ID_ISAR2_EL1,
+    [ID_ISAR3_EL1_IDX] = SYS_ID_ISAR3_EL1,
+    [ID_ISAR4_EL1_IDX] = SYS_ID_ISAR4_EL1,
+    [ID_ISAR5_EL1_IDX] = SYS_ID_ISAR5_EL1,
+    [ID_ISAR6_EL1_IDX] = SYS_ID_ISAR6_EL1,
+    [ID_MMFR4_EL1_IDX] = SYS_ID_MMFR4_EL1,
+    [MVFR0_EL1_IDX] = SYS_MVFR0_EL1,
+    [MVFR1_EL1_IDX] = SYS_MVFR1_EL1,
+    [MVFR2_EL1_IDX] = SYS_MVFR2_EL1,
+    [ID_PFR2_EL1_IDX] = SYS_ID_PFR2_EL1,
+    [ID_DFR1_EL1_IDX] = SYS_ID_DFR1_EL1,
+    [ID_MMFR5_EL1_IDX] = SYS_ID_MMFR5_EL1,
+    [ID_AA64PFR0_EL1_IDX] = SYS_ID_AA64PFR0_EL1,
+    [ID_AA64PFR1_EL1_IDX] = SYS_ID_AA64PFR1_EL1,
+    [ID_AA64PFR2_EL1_IDX] = SYS_ID_AA64PFR2_EL1,
+    [ID_AA64ZFR0_EL1_IDX] = SYS_ID_AA64ZFR0_EL1,
+    [ID_AA64SMFR0_EL1_IDX] = SYS_ID_AA64SMFR0_EL1,
+    [ID_AA64FPFR0_EL1_IDX] = SYS_ID_AA64FPFR0_EL1,
+    [ID_AA64DFR0_EL1_IDX] = SYS_ID_AA64DFR0_EL1,
+    [ID_AA64DFR1_EL1_IDX] = SYS_ID_AA64DFR1_EL1,
+    [ID_AA64DFR2_EL1_IDX] = SYS_ID_AA64DFR2_EL1,
+    [ID_AA64AFR0_EL1_IDX] = SYS_ID_AA64AFR0_EL1,
+    [ID_AA64AFR1_EL1_IDX] = SYS_ID_AA64AFR1_EL1,
+    [ID_AA64ISAR0_EL1_IDX] = SYS_ID_AA64ISAR0_EL1,
+    [ID_AA64ISAR1_EL1_IDX] = SYS_ID_AA64ISAR1_EL1,
+    [ID_AA64ISAR2_EL1_IDX] = SYS_ID_AA64ISAR2_EL1,
+    [ID_AA64ISAR3_EL1_IDX] = SYS_ID_AA64ISAR3_EL1,
+    [ID_AA64MMFR0_EL1_IDX] = SYS_ID_AA64MMFR0_EL1,
+    [ID_AA64MMFR1_EL1_IDX] = SYS_ID_AA64MMFR1_EL1,
+    [ID_AA64MMFR2_EL1_IDX] = SYS_ID_AA64MMFR2_EL1,
+    [ID_AA64MMFR3_EL1_IDX] = SYS_ID_AA64MMFR3_EL1,
+    [ID_AA64MMFR4_EL1_IDX] = SYS_ID_AA64MMFR4_EL1,
+    [CCSIDR_EL1_IDX] = SYS_CCSIDR_EL1,
+    [CLIDR_EL1_IDX] = SYS_CLIDR_EL1,
+    [CCSIDR2_EL1_IDX] = SYS_CCSIDR2_EL1,
+    [GMID_EL1_IDX] = SYS_GMID_EL1,
+    [SMIDR_EL1_IDX] = SYS_SMIDR_EL1,
+    [CSSELR_EL1_IDX] = SYS_CSSELR_EL1,
+    [CTR_EL0_IDX] = SYS_CTR_EL0,
+    [DCZID_EL0_IDX] = SYS_DCZID_EL0,
+};
+
+#endif /* ARCH_ARM_CPU_SYSREGS_H_INC */
-- 
2.48.1

