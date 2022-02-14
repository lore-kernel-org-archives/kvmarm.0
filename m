Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CAEC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:00:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4521408A7;
	Mon, 14 Feb 2022 02:00:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wY33egAKSkU6; Mon, 14 Feb 2022 02:00:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 867E149E1B;
	Mon, 14 Feb 2022 02:00:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 721A849E1B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id irPxa+e4GkZm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:00:47 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD946405C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:00:47 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 z15-20020a25bb0f000000b00613388c7d99so32243673ybg.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Rhm0G4Hndfns0WwS5RiUqsnxD09RQ4PSWOitjVcchSA=;
 b=hMB7PKfeq4wP8cmvwOKAPsq8tMblTDA9ipBzD4QqMrvaqHeFOtd4qd2QujezGEmhjy
 drmVsLzZ98LR3Ay3+/d0fcBLocjvZsoDen0n80H8V77zYY8nJgoSD13SEETmzOfZHT/r
 7DnXAb2ILeeorZwG0F5e435FUvXz118Mjwtitjl2GXMlOSUZyHrLD42zzZHdT8m6C4qY
 4U7zQfFkL/GUuOIN2LldrYMRhbKo9oROypdAGqiUlhXG5bcmXYKqugsL+Icjrh1IFE+5
 wMVjqarY+5xMoB39RlQcJD4OoUPtj173ospvYKmzx0FkEdEHBigzbUrKDjOks1BbTbyt
 cDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Rhm0G4Hndfns0WwS5RiUqsnxD09RQ4PSWOitjVcchSA=;
 b=Bbii+pADWY+t5ILahrZF1Nyk2MA+lqTqMGDEYJ4NrdkalbApca6bdY9ewb1B1JUzUj
 KDBz6vJPP828sc5DpomHw3mM7HrIfVx+FnxakXEeZRyui5abNCWIL3TU+InOW+A1GK4x
 OohzWAfJ9qVM++8M/pi7B+JrrGVNRn6RG1vQqgFA0pKmZCUnWQyuqWRzhIX2JaKTgmpC
 ODasDJsmJPzJ1Ejy68HKmXPtCZ1l+Wu1HZSAa4h/ZgcAy7NQAqD+mZC5G8jnTes3VRsd
 ikCWw6bLzzgneFg0/J7y6XiH6wVzHrkfJ9ivk0eXzIrG2l0r3xp0Z7npqu+r1RtkH3BK
 blrw==
X-Gm-Message-State: AOAM533w39z7rgrGpGn0zct6V69IGmJKmTQbLMFMX1dwjraAV8KPwyLq
 dzZBG9soKFOcQSHyvnY+cw3dWL9GdJY=
X-Google-Smtp-Source: ABdhPJwr6+bnTjWiqQtguZ4ziJGjLXvQhPLKCUpg9BP1fWujKsSOpVQ18DxW9zhbhpZl5zvE1334R+e8vtc=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:af13:: with SMTP id
 a19mr10423130ybh.543.1644822047431; 
 Sun, 13 Feb 2022 23:00:47 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:34 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-16-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 15/27] KVM: arm64: Add consistency checking for frac fields
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
set later).
Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 115 +++++++++++++++++++++++++++++-
 3 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9ffe6604a58a..5e53102a1ac1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
+int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 91110d996ed6..e7dcc7704302 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -599,6 +599,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_check_frac_fields(vcpu))
+		return -EPERM;
+
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d7041a10b41..b7329075a69f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -793,9 +793,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
@@ -3484,10 +3481,108 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
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
+ * through arm64_check_features_kvm.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_info *id_reg;
+	u32 id;
+	u64 val, lim, mask;
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	val = __read_id_reg(vcpu, id) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
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
+	id_reg = GET_ID_REG_INFO(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
+	val = __read_id_reg(vcpu, id) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
+
+	if (val == lim)
+		/*
+		 * Both the feature and fractional fields are the same
+		 * as limit.
+		 */
+		return 0;
+
+	return arm64_check_features_kvm(id, val, lim);
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
 static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3496,6 +3591,20 @@ static void id_reg_info_init_all(void)
 
 		id_reg_info_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_info.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = GET_ID_REG_INFO(frac->frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= ftr_mask << frac->frac_shift;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
