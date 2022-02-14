Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62418C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:59:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0743A40AEA;
	Mon, 14 Feb 2022 01:59:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qq6umJXiPxZI; Mon, 14 Feb 2022 01:59:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CFDB40BDC;
	Mon, 14 Feb 2022 01:59:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D352A40BC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eHAgJc-IUljL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:36 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8986540AEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:36 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 md16-20020a17090b23d000b001b8bd5e35e2so10341784pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9HWK2NuyhhyEgB8wjO5dIoYbvn8UVleDNCoL8GsEyHo=;
 b=ZetGQBiCPI1x9OJJic+8ZrDGNot52XaUnaWWc3V8haKmWLaCliopibcQ4OPJfG2wd4
 MiC1wGtd+xOxrH/A1++qveFTpTi7WJ7MpUng8sOWpJkQXjnH4E74mZwiysSq3bvAHR9n
 pAxElk0XlPcknnyNNIMu/CfIEGd0bpa807HcGSJibtt8CbezAabn+IxSaMiglSfuOXGO
 4MOboLh83MQsBy7ErlmYnmxq+5D7eV9sqRZ86wB6ZGaaNkDmbxDwHV7uIvuAuBmX3XSP
 W39PDgD8eGr0KgFO4hX8N4L8m5qfGofJFd50151Fmv1eQXiE/eQf9SgehXDP1UvjiqP0
 qRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9HWK2NuyhhyEgB8wjO5dIoYbvn8UVleDNCoL8GsEyHo=;
 b=BIIN2hp622MEUPVLxYQK1WdIm96/0KxZiNY847mkXmn+LDkqFWAFZ2nfEeQIibwb8o
 mLuIIM4zvh1wSZoJIK6mQeEoqZyd9OafIefj2F7hZnH5w6DRrwScOKT+tBKRjr+uNjY7
 G4jyaAx1eAEF6NkCLqYxBKn52XkJLB97lY47LwnOm7hXhUjkEM66pGiDSvm73vUf8c5d
 uhQ3dEcBYfhaDSnsb8OVpZ/kys6UidEiiUaOsVJQH9Zo8vPhhCznNpKocB1eRQCLCmNw
 TS7l6ANhxgsILsa6H3T/QzO2Tj5/tKIH710AyjBX7yo1Jg2x1vhY5s6S+rNqfFPyntux
 /iFw==
X-Gm-Message-State: AOAM530ZIE+Ho0vE17ytkXRq7DJt3mm+81o8fwXyhnGcuPE7kOOMggAl
 DXrBXY0RVZoNIBPOWB9aXiFG2IDWHUE=
X-Google-Smtp-Source: ABdhPJyCaHptDFMSE+RPFCR/UHTTbzXP99lLXwipwWCS7IQN6bwAutS1tWd7nWyBwrjwPq0xKJD0r1fIUkI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:c94c:: with SMTP id
 i12mr12741956pla.18.1644821975617; Sun, 13 Feb 2022 22:59:35 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:26 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-8-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 07/27] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This patch adds id_reg_info for ID_AA64ISAR1_EL1 to make it
writable by userspace.

Return an error if userspace tries to set PTRAUTH related fields
of the register to values that conflict with PTRAUTH configuration,
which was configured by KVM_ARM_VCPU_INIT, for the guest.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 77 +++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eb2ae03cbf54..7032a7285447 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -265,6 +265,24 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+#define PTRAUTH_MASK	(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) | \
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |	\
+			 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI))
+
+#define aa64isar1_has_apa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_APA_SHIFT) >= \
+	 ID_AA64ISAR1_APA_ARCHITECTED)
+#define aa64isar1_has_api(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_API_SHIFT) >= \
+	 ID_AA64ISAR1_API_IMP_DEF)
+#define aa64isar1_has_gpa(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPA_SHIFT) >= \
+	 ID_AA64ISAR1_GPA_ARCHITECTED)
+#define aa64isar1_has_gpi(val)	\
+	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
+	 ID_AA64ISAR1_GPI_IMP_DEF)
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
@@ -410,6 +428,36 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	bool has_gpi, has_gpa, has_api, has_apa;
+	bool generic, address;
+
+	has_gpi = aa64isar1_has_gpi(val);
+	has_gpa = aa64isar1_has_gpa(val);
+	has_api = aa64isar1_has_api(val);
+	has_apa = aa64isar1_has_apa(val);
+	if ((has_gpi && has_gpa) || (has_api && has_apa))
+		return -EINVAL;
+
+	generic = has_gpi || has_gpa;
+	address = has_api || has_apa;
+	/*
+	 * Since the current KVM guest implementation works by enabling
+	 * both address/generic pointer authentication features,
+	 * return an error if they conflict.
+	 */
+	if (generic ^ address)
+		return -EPERM;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_ptrauth(vcpu) ^ (generic && address))
+		return -EPERM;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -447,8 +495,14 @@ static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
 		id_reg->vcpu_limit_val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 }
 
+static void init_id_aa64isar1_el1_info(struct id_reg_info *id_reg)
+{
+	if (!system_has_full_ptr_auth())
+		id_reg->vcpu_limit_val &= ~PTRAUTH_MASK;
+}
+
 static u64 vcpu_mask_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu,
-					 const struct id_reg_info *idr)
+				     const struct id_reg_info *idr)
 {
 	return vcpu_has_sve(vcpu) ? 0 : ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
 }
@@ -459,6 +513,12 @@ static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
 	return kvm_has_mte(vcpu->kvm) ? 0 : (ARM64_FEATURE_MASK(ID_AA64PFR1_MTE));
 }
 
+static u64 vcpu_mask_id_aa64isar1_el1(const struct kvm_vcpu *vcpu,
+					  const struct id_reg_info *idr)
+{
+	return vcpu_has_ptrauth(vcpu) ? 0 : PTRAUTH_MASK;
+}
+
 static struct id_reg_info id_aa64pfr0_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR0_EL1,
 	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR0_GIC),
@@ -482,6 +542,13 @@ static struct id_reg_info id_aa64isar0_el1_info = {
 	.validate = validate_id_aa64isar0_el1,
 };
 
+static struct id_reg_info id_aa64isar1_el1_info = {
+	.sys_reg = SYS_ID_AA64ISAR1_EL1,
+	.init = init_id_aa64isar1_el1_info,
+	.validate = validate_id_aa64isar1_el1,
+	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -494,6 +561,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1418,13 +1486,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
 
 	switch (id) {
-	case SYS_ID_AA64ISAR1_EL1:
-		if (!vcpu_has_ptrauth(vcpu))
-			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_APA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_API) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPA) |
-				 ARM64_FEATURE_MASK(ID_AA64ISAR1_GPI));
-		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
 		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
