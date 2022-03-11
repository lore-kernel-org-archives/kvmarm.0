Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3862CC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 04:49:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E825C49ED8;
	Thu, 10 Mar 2022 23:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id weux-qVP4bmE; Thu, 10 Mar 2022 23:49:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4F1E49EF7;
	Thu, 10 Mar 2022 23:49:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1087E49EBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lPxaw4e0X-6j for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 23:49:02 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C759849ECB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 23:49:01 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 f18-20020a623812000000b004f6a259bbf4so4545693pfa.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 20:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=P6w9BVvAXiEumM7YPj7nhW02oDd+02fdwpSOhJH2kYw=;
 b=QVWaTn/U/hi+unViUFh9VLttYMSUf6cDc/FxUCXGkEl5EOtX3tjwK3KjdtPgHgt57a
 2nLGHdqHReQ3NkV7bpq4OmqCpeJgr/OMmPjlnVPYMJvIi/nxZwOay0M09Bvd8nrLodDN
 kUuBQRV7QPS5YPu1XY0pCwlTP4Ayg7ryZNTmlfrxeTExwLwbyaW/iqMat80nqOpwtmhX
 ERIiwVNtBI7kYgwnYjKhFvRTgiJ7bUP4UWqo877BRXCl7VSc6A2DqZ2JAU61883oAJx/
 UaJjKTKW4YgIEvRd6AheikMzCYTkvL2XhtfvINICgbBq7MY3INyR/b46s7pEnQ260GHc
 rqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=P6w9BVvAXiEumM7YPj7nhW02oDd+02fdwpSOhJH2kYw=;
 b=hN8izuNzCI1OstQlKeJCYh5TIZVZ7pTO8P9cqDbo0k4rozsOHPERicZhJ/XaKIRTZv
 AGt1kVJLebPurpTTqAsxShdC4KQ1amc1XnCwvpmC/fHHQirMoGlm354Tv8abn4KIkkx4
 zPzV+oYnfvyhAQcAwBQUdWRe+vTzizQdPWsX2gMya428A4HTbW0sp58uP/M3mkbSz0el
 0LvHU0l6OopNXMrRSpgbN6gfu1bGYcO7n/dFhnPI9Qthk6cnnuP2RTDymWB6ZxRh8bkl
 RL9Qycaggbg8aHSWrYmInQYmwIe8/HmGXN8Me7o83WOG9x2Lq1BtjckjdMGlzvH91VTE
 x1fQ==
X-Gm-Message-State: AOAM532dFwreD715lL19pf18Vz9FiRz+pgFhLOFhNUPrqJ2DoqYfGPFP
 IZL9VzvfUjXIK27X2HnoYOVBrjGCTRc=
X-Google-Smtp-Source: ABdhPJzhh1U7y5CL8ltfYwY4d+qtiQiox0IYx4/Dpt56merG9aO2FQSKi2C7GJaXW+1lU89FVH7aAQfnGfw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:d482:b0:153:12b0:60b5 with SMTP id
 c2-20020a170902d48200b0015312b060b5mr8606210plg.105.1646974140996; Thu, 10
 Mar 2022 20:49:00 -0800 (PST)
Date: Thu, 10 Mar 2022 20:48:04 -0800
In-Reply-To: <20220311044811.1980336-1-reijiw@google.com>
Message-Id: <20220311044811.1980336-19-reijiw@google.com>
Mime-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v6 18/25] KVM: arm64: Introduce framework to trap disabled
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
 arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 5 deletions(-)

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
index b44a3bf488c1..a754099d2a73 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -284,6 +284,27 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
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
 /* id_reg_desc flags field values */
 #define ID_DESC_REG_UNALLOC	(1UL << 0)
 #define ID_DESC_REG_HIDDEN	(1UL << 1)
@@ -291,6 +312,9 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
 
+	/* Sanitized system value */
+	u64	sys_val;
+
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
 	 * system value with bits set/cleared for unsupported features for the
@@ -335,6 +359,9 @@ struct id_reg_desc {
 	 */
 	u64 (*vcpu_mask)(const struct kvm_vcpu *vcpu,
 			 const struct id_reg_desc *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static inline struct id_reg_desc *sys_to_id_desc(const struct sys_reg_desc *r)
@@ -352,6 +379,7 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 		return;
 
 	val = read_sanitised_ftr_reg(id);
+	id_reg->sys_val = val;
 	id_reg->vcpu_limit_val = val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
@@ -807,6 +835,24 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
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
+	val = read_id_reg_with_encoding(vcpu, ctrl->ftr_reg);
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1761,6 +1807,46 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
 static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
+static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
+					  const struct id_reg_desc *id_reg)
+{
+	u64 val;
+	int i = 0;
+	const struct feature_config_ctrl **ctrlp_array, *ctrl;
+
+	if (!id_reg->trap_features)
+		/* No information to trap a feature */
+		return;
+
+	val = __read_id_reg(vcpu, id_reg);
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
@@ -3763,6 +3849,31 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * This function activates vcpu's trapping of features that are included in
+ * trap_features[] of id_reg_desc if the features are supported on the
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
+	struct id_reg_desc *idr;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_desc_table); i++) {
+		idr = (struct id_reg_desc *)id_reg_desc_table[i];
+		if (!idr)
+			continue;
+
+		id_reg_features_trap_activate(vcpu, idr);
+	}
+}
+
 #if IS_ENABLED(CONFIG_KVM_KUNIT_TEST)
 #include "sys_regs_test.c"
 #endif
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
