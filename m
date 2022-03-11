Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93899C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A4149EED;
	Thu, 10 Mar 2022 23:49:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bka0SVqh8T3c; Thu, 10 Mar 2022 23:48:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 552F549EE4;
	Thu, 10 Mar 2022 23:48:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5EEF49E46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9J8WRzD844AK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:48:55 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0E9649EBA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:48:53 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 c12-20020a170902848c00b0015025f53e9cso3933008plo.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DltmKg7opwhIQvsCwmEx6qs3h14xPlDqswCiLBq3BvI=;
 b=N39NQTTkdbZnRTzSRZEqZFrgTaFi2lK42y1/qZ1pn8Pbr5yj0p9nYTSuhihb/Lu7sN
 dcVYmv/4AvKdLQy0RzMJr/m5lgP/QBuf9FWhQU5tcKmJLEpCItk3qaBIYUuyaqVenVRb
 QPqY7gVLWPRDfezgK4RqFc7luPzOknbDAl0I0mtaKwd/XlEWy/XLC2GGb8aWgsnsZ/ld
 DT+bSp2hAUW+34+S4eKwqMNUNcpyxVHKM97cmvbV3wBjdQJNAzCQTistKsISe5uLVoZz
 8//fO4tniGmbUOmnQGpOVgylJluO75sgWNrifgjIbTlzAefKYxlH7Fi09jTmhfkjfLl6
 r6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DltmKg7opwhIQvsCwmEx6qs3h14xPlDqswCiLBq3BvI=;
 b=StjwvaMP4S/uvI6Vtms5phnIOLJDJf/ls9uU5Cs2KhoBaeblK2U4byVMrdysP2pFxu
 2kD/iSlXvh+v+kVa0xbDe3sut3mKX3dyUSX+mwXTjFrVrs2HY+g1w/GqKgqQXBW+/ZVH
 f56mR6O97yDOC3reoJCsBSTgp7P9VEAKRZ3V4D3HnUpwsFbANMqqHMR9YfOxmxZfb5B7
 BTCMdWqLlwQQ7m6kSDkZ+ZvrwMgE+2WpZVVR1PumLbzE4pTFVw3ixJkHjidnoKRDcX61
 YA0qsFktPu+6x6jIV6NtV8fpXdEtx0QEHVkBwzuU+cv6KH8SNfyK8l1yQqWdzbPg0VOS
 b0Iw==
X-Gm-Message-State: AOAM532GzImNi/HzGSxpLKCFi65fF7q9TiwSP9ntErARivrSNtiDdH7u
 FrIBMfVix4Rfza8HodLqggHtCt2mocQ=
X-Google-Smtp-Source: ABdhPJwFRwT5Fgamh4l+5MQdfg7BYHp05vvdFwuVRvSeFNzp6LJbqoSWM+rN32ZUxVO+QSRSMIPfjJ4nruM=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:10cf:b0:4f6:5834:aefb with SMTP id
 d15-20020a056a0010cf00b004f65834aefbmr8229183pfu.77.1646974132762; Thu, 10
 Mar 2022 20:48:52 -0800 (PST)
Date: Thu, 10 Mar 2022 20:47:59 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-14-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 13/25] KVM: arm64: Add consistency checking for frac fields
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
 arch/arm64/kvm/sys_regs.c         | 112 ++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

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
index ba851de6486d..3805b69ed23e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3397,6 +3397,102 @@ void kvm_sys_reg_table_init(void)
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
+ * through arm64_check_features_kvm.
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
+	id_reg = get_id_reg_desc(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	val = __read_id_reg(vcpu, id_reg) & mask;
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
+	id_reg = get_id_reg_desc(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
+	val = __read_id_reg(vcpu, id_reg) & mask;
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
 /*
  * Update the ID register's field with @fval for the guest.
  * The caller is expected to hold the kvm->lock.
@@ -3600,6 +3696,8 @@ static void id_reg_desc_init_all(void)
 {
 	int i;
 	struct id_reg_desc *id_reg;
+	struct feature_frac *frac;
+	u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
 		id_reg = (struct id_reg_desc *)id_reg_desc_table[i];
@@ -3608,6 +3706,20 @@ static void id_reg_desc_init_all(void)
 
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
