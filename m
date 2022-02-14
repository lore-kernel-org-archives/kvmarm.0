Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1849CC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 07:01:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C382A49E1B;
	Mon, 14 Feb 2022 02:01:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UQ+v+ikqI34a; Mon, 14 Feb 2022 02:01:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5394849E38;
	Mon, 14 Feb 2022 02:01:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA14340068
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qpdYHAEGqrUw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 02:01:15 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D409249E08
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 02:01:15 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 b9-20020a17090aa58900b001b8b14b4aabso11505861pjq.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 23:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ODKlCnJ+oDdhrPLjcew2EifH1Z7m1Qcdn/bAY4qUTjc=;
 b=YTh3VjXMey35X0Uzn/geCrZuF+AAYEhvErfshDJ6V6ZZx2JWhs8SBnUgu0VuE5EBpm
 diOU2pGfvkcvQY7H1WIwvdF6i+EVb03j9blCKF5AiBms8tDv0rCCTZNe9h/7Vm7jHB+E
 bZCsrTlbiw+MZQTAQ5B/ijT6XWUEoZ5JsTeNfd/oSuy8Y8wtB/gBJS3qNaTKitRKVW8l
 KAWDsA4zHE3P2PEPsE/BHLYkMisZmlvKn2X4KRrUuAgPLC6kAKi71OdXP5LK6D+2YGyd
 zTBd3dpNxjvrWksBCL1t+JBIrbebzaeZ6GpfJFSb/9/u1j0dpceP+A8rglzux2PdJ0Uj
 Ravw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ODKlCnJ+oDdhrPLjcew2EifH1Z7m1Qcdn/bAY4qUTjc=;
 b=QEXVSxgipoZ49mvNm1+LhyKqPk7MUuWQX4ln/mW3C2GT/QZ7C7KEO6UGWUwU4k8obo
 53peO8qrBkeffQFN7Yo8hor4kjKnvU+bQMKUHK6H12sNICbEODKN9e+JaQO+ip4M1CZB
 /gCpT5wuzTA1E6y4O64vK4DH5twMEFi4QB6kWyP9no1HwzEIV4LKtUq86q55dEU9sbq8
 YxtWYdiCD2mV7Z8gHNsWb6FhWPo42cSo17u2eVFbMyr89w0wCkZhVkhr9vY7bl7SP+YZ
 0PahV3e5pIC+2h5XBPpYsSJXWPeXXYkXUo+lrB9+OfpsyDBw50SO3s4bfSsYB6pRGjZu
 Q4uw==
X-Gm-Message-State: AOAM532S2+ZpAh8BHXf0svTeH7aQUf39Y5T2iiR1CKyfNHyvDK0dIs7d
 Zx/VfNjb7g0u0DLEOgT9mzqtCn6jCaY=
X-Google-Smtp-Source: ABdhPJxLgZLNaiReuS2zrqDion211dMUzQCuxAZBqyjs12+KsRwfxViCryGR38A+IT8Nmm1ibEStEjcih80=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:1c81:: with SMTP id
 oo1mr12985775pjb.192.1644822075045; Sun, 13 Feb 2022 23:01:15 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:39 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-21-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 20/27] KVM: arm64: Introduce framework to trap disabled
 features
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

When a CPU feature that is supported on the host is not exposed to
its guest, emulating a real CPU's behavior (by trapping or disabling
guest's using the feature) is generally a desirable behavior (when
it's possible without any or little side effect).

Introduce feature_config_ctrl structure, which manages feature
information to program configuration register to trap or disable
the feature when the feature is not exposed to the guest, and
functions that uses the structure to activate the vcpu's trapping the
feature.  Those codes don't update trap configuration registers
themselves (HCR_EL2, etc) but values for the registers in
kvm_vcpu_arch at the first KVM_RUN.

At present, no feature has feature_config_ctrl yet and the following
patches will add the feature_config_ctrl for some features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |  13 ++--
 arch/arm64/kvm/sys_regs.c         | 112 ++++++++++++++++++++++++++++--
 3 files changed, 117 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5e53102a1ac1..9b7fad07fcb0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -749,6 +749,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ce7229010a78..dfd247d2746f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -631,13 +631,16 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
-	/*
-	 * Initialize traps for protected VMs.
-	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
-	 * the code is in place for first run initialization at EL2.
-	 */
+	/* Initialize traps for the guest. */
 	if (kvm_vm_is_protected(kvm))
+		/*
+		 * NOTE: Move to run in EL2 directly, rather than via a
+		 * hypercall, once the code is in place for first run
+		 * initialization at EL2.
+		 */
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
+	else
+		kvm_vcpu_init_traps(vcpu);
 
 	mutex_lock(&kvm->lock);
 	kvm->arch.ran_once = true;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 77a106d255be..faa28e7926b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -283,10 +283,34 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+/*
+ * Feature information to program configuration register to trap or disable
+ * guest's using a feature when the feature is not exposed to the guest.
+ */
+struct feature_config_ctrl {
+	/* ID register/field for the feature */
+	u32	ftr_reg;	/* ID register */
+	bool	ftr_signed;	/* Is the feature field signed ? */
+	u8	ftr_shift;	/* Field of ID register for the feature */
+	s8	ftr_min;	/* Min value that indicate the feature */
+
+	/*
+	 * Function to check trapping is needed. This is used when the above
+	 * fields are not enough to determine if trapping is needed.
+	 */
+	bool	(*ftr_need_trap)(struct kvm_vcpu *vcpu);
+
+	/* Function to activate trapping the feature. */
+	void	(*trap_activate)(struct kvm_vcpu *vcpu);
+};
+
 struct id_reg_info {
 	/* Register ID */
 	u32	sys_reg;
 
+	/* Sanitized system value */
+	u64	sys_val;
+
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
 	 * system value with bits set/cleared for unsupported features for the
@@ -328,13 +352,15 @@ struct id_reg_info {
 	 */
 	u64 (*vcpu_mask)(const struct kvm_vcpu *vcpu,
 			 const struct id_reg_info *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static void id_reg_info_init(struct id_reg_info *id_reg)
 {
-	u64 val = read_sanitised_ftr_reg(id_reg->sys_reg);
-
-	id_reg->vcpu_limit_val = val;
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = id_reg->sys_val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
 
@@ -345,7 +371,8 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
 	 * on the host.
 	 */
 	WARN_ON_ONCE(arm64_check_features_kvm(id_reg->sys_reg,
-					      id_reg->vcpu_limit_val, val));
+					      id_reg->vcpu_limit_val,
+					      id_reg->sys_val));
 }
 
 static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
@@ -900,6 +927,24 @@ static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
 	return err;
 }
 
+static inline bool feature_avail(const struct feature_config_ctrl *ctrl,
+				 u64 id_val)
+{
+	int field_val = cpuid_feature_extract_field(id_val,
+				ctrl->ftr_shift, ctrl->ftr_signed);
+
+	return (field_val >= ctrl->ftr_min);
+}
+
+static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
+					const struct feature_config_ctrl *ctrl)
+{
+	u64 val;
+
+	val = __read_id_reg(vcpu, ctrl->ftr_reg);
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1849,6 +1894,46 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
 static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
+static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
+					  const struct id_reg_info *id_reg)
+{
+	u64 val;
+	int i = 0;
+	const struct feature_config_ctrl **ctrlp_array, *ctrl;
+
+	if (!id_reg || !id_reg->trap_features)
+		/* No information to trap a feature */
+		return;
+
+	val = __read_id_reg(vcpu, id_reg->sys_reg);
+	if (val == id_reg->sys_val)
+		/* No feature needs to be trapped (no feature is disabled). */
+		return;
+
+	ctrlp_array = *id_reg->trap_features;
+	while ((ctrl = ctrlp_array[i++]) != NULL) {
+		if (WARN_ON_ONCE(!ctrl->trap_activate))
+			/* Shouldn't happen */
+			continue;
+
+		if (ctrl->ftr_need_trap && ctrl->ftr_need_trap(vcpu)) {
+			ctrl->trap_activate(vcpu);
+			continue;
+		}
+
+		if (!feature_avail(ctrl, id_reg->sys_val))
+			/* The feature is not supported on the host. */
+			continue;
+
+		if (feature_avail(ctrl, val))
+			/* The feature is enabled for the guest. */
+			continue;
+
+		/* The feature is supported but disabled. */
+		ctrl->trap_activate(vcpu);
+	}
+}
+
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -3481,6 +3566,25 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/*
+ * This function activates vcpu's trapping of features that are included in
+ * trap_features[] of id_reg_info if the features are supported on the
+ * host, but are hidden from the guest (i.e. values of ID registers for
+ * the guest are modified to not show the features' availability).
+ * This function just updates values for trap configuration registers (e.g.
+ * HCR_EL2, etc) in kvm_vcpu_arch, which will be restored before switching
+ * to the guest, but doesn't update the registers themselves.
+ * This function should be called once at the first KVM_RUN (ID registers
+ * are immutable after the first KVM_RUN).
+ */
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++)
+		id_reg_features_trap_activate(vcpu, id_reg_info_table[i]);
+}
+
 /* ID register's fractional field information with its feature field. */
 struct feature_frac {
 	u32	id;
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
