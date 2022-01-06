Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990A5C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDE349F13;
	Wed,  5 Jan 2022 23:28:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nnpJobPMWP0X; Wed,  5 Jan 2022 23:28:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 027B549F15;
	Wed,  5 Jan 2022 23:28:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D1649F15
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fq4acj1iV7S9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:41 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC0D340D2E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:41 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 35-20020a17090a0fa600b001b160e1ecffso999946pjz.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kbEpa3NW3/F54H+JiSS5EZmEGUFjbjn4q49NB5SkOFY=;
 b=F5MiqeiGa7mT0rV8KX4bnNCqVNXjhRt084mESpWkocsg0soeVmifRqlwvxgC/0GsnJ
 AaSLM7NzF+tlwOF5mFc622o7gr7nwsCptip41Y/Ph1Swj6R34CmAzu5hSLVJFZbXUJUm
 a61KKqDvbSMcjVvkPDCrimC0hVZJkvtt1VWPpOdn8XAmT2qXzsI7RxXjQqVEYQAPg9tN
 bvAjFSOh7Otm5E6SRs4XP0frxdSpV13j2L1wiRPRJIZoguEy4GqPpYxQY6OwMzr/099+
 k+AQFgI9NwPdcRSaQDz3w2X8Ppm/5u6BdugPZQK7DwTgxn5BZ7NOzVfS3E/bL2xItv0X
 Q3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kbEpa3NW3/F54H+JiSS5EZmEGUFjbjn4q49NB5SkOFY=;
 b=pxoM6Wof+vs3eo2z3WLLIrtcMvHtxF3305Av88aSxnLaSJDWrRoLNL1ryZAUbBKJ0j
 Dywx/+kR+TZ0He0PfALLyhdigCjDbDfm7UByu1MR6MTWWM2yAPbGwniJBp/B7jiUUzpU
 n+MJ5zdWbfGo1zuxa+U3Wzy1r7XkI6vC2ppNjPYpyKrXmWoMDcpjjKh4Bj/V1DgJXiIH
 i7ZTToJhIvmChkuynhBNFUnFqJJn3sa+i5iXF/vTkG6KvGDm8n7OAn3omdkeKdzF8oz/
 RXON1rjZ2r6qxUKnt/jr3SLqYNFF07iVsho/87wjTmS3arG6c004NYa1G7Fyb/rovWc4
 7qag==
X-Gm-Message-State: AOAM533wY+Twe4yVcTwORs2QIKK3HE/tYPMCaPhViPf9tMAgtNB+/ixg
 ez2zGGDmrzQyI8++/vePoi/E+QdoBVM=
X-Google-Smtp-Source: ABdhPJyTnlP5OuFiYcs3Gvlpu341c7pETgqpLszhf4MJt8zQ5rVfV6AjjEqjrwjfR5pVVTgMWHWnhTfnA1M=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:114d:b0:4a2:87bd:37f with SMTP id
 b13-20020a056a00114d00b004a287bd037fmr58810603pfm.82.1641443321070; Wed, 05
 Jan 2022 20:28:41 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:49 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-8-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 07/26] KVM: arm64: Make ID_AA64ISAR1_EL1 writable
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
index 3f1313875be5..2f79997016a4 100644
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
 	u32	sys_reg;	/* Register ID */
 
@@ -397,6 +415,36 @@ static int validate_id_aa64isar0_el1(struct kvm_vcpu *vcpu,
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
@@ -434,8 +482,14 @@ static void init_id_aa64pfr1_el1_info(struct id_reg_info *id_reg)
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
@@ -446,6 +500,12 @@ static u64 vcpu_mask_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu,
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
@@ -469,6 +529,13 @@ static struct id_reg_info id_aa64isar0_el1_info = {
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
@@ -481,6 +548,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
+	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
@@ -1398,13 +1466,6 @@ static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
