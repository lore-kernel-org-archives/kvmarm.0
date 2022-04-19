Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC79C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E3D4B20A;
	Tue, 19 Apr 2022 02:57:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rQElBJachOnQ; Tue, 19 Apr 2022 02:57:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C49B4B1FB;
	Tue, 19 Apr 2022 02:57:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 705084B1D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPZm6SPVVS4G for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:42 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC484B220
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:40 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 br6-20020a17090b0f0600b001cdf82a4f79so1170825pjb.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JEHgWGXC0IGyIA5eE8wz+3k5C/TVMDQDmfAi50muP4E=;
 b=RhHlP7hgGeUD2CjcSSfimqmUChdwE2bH2GjXKlWM5/j3UQgqqhx6lx8GLaWJxsg4C0
 KxnYyBp8j9Ub95dCV3wbNPlOi/46m46bBl1dpMSNoMPJUf1jE4tgCFCo2q5qEyZ70uxV
 KTSmCZqjJiGNBxSwlY4wLX4orvMM5bStg05ECjglKfGCWFNzscN6GEvbt0Bxo4vdqyz3
 TuNDA6p3+vD3KoXm/LoaiogaivAMZAfLYoEgA3v8T6Zhm+iosT0VzxEcfjk0Tih94IR7
 HCdug7BP0BnduCn425Oa53UrTo53AtKe9Q2r4J0+xOiBrE6itQ/ZQd/O+8JhPmNFOswQ
 Gp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JEHgWGXC0IGyIA5eE8wz+3k5C/TVMDQDmfAi50muP4E=;
 b=OUG3mNUO+coThXi8dDiLTHxK4b9AfPamKH8a3G8LqpMTIYQsCK0TQaY8SoX23FRegH
 pQhtxDTq0DhgJR6UVm/oLsCF+PWTEKFIhj2uCke5B6rNKarvHSbl7pplYxVPeeC69BiH
 kcHgeQAl7W0+HGd4QCl1Opsc4hqR82Ngqr6pEKYqFxxDSjank45+eFY0YRvBX62V3gU2
 lkvdsFExBi/UhOye0zXzb1dyWV4Wsupp4kBlLbR2VlPRrwWFkmH6D6fUZ4T92oK9T/Lt
 uXumI8CHyxMQqIC3VBufbb6pcvEnkxJ4yeUntjbJboQNDjEqCmbotBZTXDImSAy2H/zl
 rG5w==
X-Gm-Message-State: AOAM531bWKR9rY3UMTqiHeBdaJqm19AH0TI8Ixc6Hxxo1O6ljJqlDeoY
 rc6uWEJFOGrSViQA6cYzug38boNPn+I=
X-Google-Smtp-Source: ABdhPJzASKF1mdud+lojqbob7DwNr6IhW5KBhupg9DEi1JxaqrREIndqN+zLI2GeNUHkgP3K/a5UpF/tXz4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:99c:b0:50a:9b27:a06d with SMTP id
 u28-20020a056a00099c00b0050a9b27a06dmr131007pfg.27.1650351460083; Mon, 18 Apr
 2022 23:57:40 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:27 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-22-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 21/38] KVM: arm64: Add consistency checking for frac fields
 of ID registers
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

Feature fractional field of an ID register cannot be simply validated
at KVM_SET_ONE_REG because its validity depends on its (main) feature
field value, which could be in a different ID register (and might be
set later).  Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 113 +++++++++++++++++++++++++++++-
 3 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dbed94e759a8..b85af83b4542 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -789,6 +789,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu);
+int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04312f7ee0da..5c1cee04aa95 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -524,6 +524,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_check_frac_fields(vcpu))
+		return -EPERM;
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1045319c474e..fc7a8f2539a4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4028,6 +4028,100 @@ void kvm_sys_reg_table_init(void)
 	id_reg_desc_init_all();
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	id;
+	u32	shift;
+	u32	frac_id;
+	u32	frac_shift;
+};
+
+static struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_RAS_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_MPAM_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_CSV2_SHIFT,
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ * This function validates only the fractional feature field,
+ * and relies on the fact the feature field is validated before
+ * through arm64_check_features.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_desc *id_reg;
+	u32 id;
+	u64 val, lim, mask;
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+
+	mask = ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	id_reg = get_id_reg_desc(id);
+	val = __read_id_reg(vcpu, id_reg) & mask;
+	lim = id_reg->vcpu_limit_val & mask;
+
+	if (val != lim)
+		/*
+		 * The feature level is lower than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+
+	mask = ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
+	id_reg = get_id_reg_desc(id);
+	val = __read_id_reg(vcpu, id_reg) & mask;
+	lim = id_reg->vcpu_limit_val & mask;
+
+	if (val == lim)
+		/*
+		 * Both the feature and fractional fields are the same
+		 * as limit.
+		 */
+		return 0;
+
+	return arm64_check_features(id_reg->ftr_bits, val, lim);
+}
+
+int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu)
+{
+	int i, err;
+	const struct feature_frac *frac;
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * at KVM_SET_ONE_REG.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /*
  * Update the ID register's field with @fval for the guest.
  * The caller is expected to hold the kvm->lock.
@@ -4055,9 +4149,6 @@ static struct id_reg_desc id_aa64pfr0_el1_desc = {
 
 static struct id_reg_desc id_aa64pfr1_el1_desc = {
 	.reg_desc = ID_SANITISED(ID_AA64PFR1_EL1),
-	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
 	.init = init_id_aa64pfr1_el1_desc,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
@@ -4329,6 +4420,8 @@ static void id_reg_desc_init_all(void)
 {
 	int i;
 	struct id_reg_desc *id_reg;
+	struct feature_frac *frac;
+	u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
 		id_reg = (struct id_reg_desc *)id_reg_desc_table[i];
@@ -4337,6 +4430,20 @@ static void id_reg_desc_init_all(void)
 
 		id_reg_desc_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_desc.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = get_id_reg_desc(frac->frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= ftr_mask << frac->frac_shift;
+	}
 }
 
 /*
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
