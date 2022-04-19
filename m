Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21E5C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AC8D4B224;
	Tue, 19 Apr 2022 02:57:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1ZjaPXsAqQIC; Tue, 19 Apr 2022 02:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8E584B25F;
	Tue, 19 Apr 2022 02:57:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742F84B1E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YJqmfutiGgTt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:49 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F04044B218
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:48 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 m8-20020a17090aab0800b001cb1320ef6eso1185763pjq.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=B1I2hIjHdTMX5JOJBkL6j3t0rzu4sj1sIMHdlZhAORQ=;
 b=sLdKpYgmWisFvw0h7w4vqAUGy5Ze3pz+9xltI0cwBnIXOZCk8SJ4JMMtSX69/qpU4w
 MQ1CbtoOKdWZBT5iEP7QAjdBxJXIU+2i1+xuvL2Bxgwqw7IsamVZ81oLl4ixcYtFI59O
 xN3n/t1sCzaDNHDXkKLETaKyxQQqRxL8PSHH6lu2uuKBr3DSKcjRwRvtXAZnAWAxd0M5
 jqUNRAdecFmD+UoygrYyhbdhhrPAiXaiQaxKhtP7eaexV5wKabO4nr+ozUPwa9hbAXsQ
 G+/C0K2bNs1fpPEWvTbwEN3UHMHKe8wq5dYQRzd/kEhfhGeK23Bic1Pw8G1TlOe2ExO1
 2POw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=B1I2hIjHdTMX5JOJBkL6j3t0rzu4sj1sIMHdlZhAORQ=;
 b=vK57Zej5WFGa0GT6Xq3xhK/xAfT3ntOhuRAa91VtV7SYg6m/CcMFRyrveIeLQh61+B
 oKAmRaxgnKieUJFjqaNPZLMyFaDe9oxkL5mw5lAhyYXkT70D6QBwvUW3wKxm04NfvJhB
 zjkZ/E99FeVWnSi/ut07dIzfodvkZPt6LSQYKe+ZQSLP6pFJgSDgS7fjn6QPnrh9QoYp
 88+gqWIlkfaklPyj+GXFLC+zI7qmP+XJb7FpDhqsyCDsp70R9RsJu0XI/OATkq4aV5XX
 cRlmHhbtPlcwqSYrqVORnO1ey/nbHJkP8bYhoACfeYcNT8OtiQI9qL1Nmj6NFLhSpEIG
 ehcA==
X-Gm-Message-State: AOAM533iWwjZ/Jm/U/urNxNOb/AbnI7t/iJpUE2uLL69xuCW1wQgdypc
 7EBOUBpJNFOE2Xqjb1C/J1XBYzqZJeY=
X-Google-Smtp-Source: ABdhPJzN1iwm3YJb0ZtY2RQlAXZkF8VXrNv44zhCAriIwP97RNc+KwflV5KlNxeryAwEWROW0FPqTsPglMU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:8384:0:b0:507:3460:6395 with SMTP id
 h126-20020a628384000000b0050734606395mr16169854pfe.81.1650351468194; Mon, 18
 Apr 2022 23:57:48 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:32 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-27-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 26/38] KVM: arm64: Introduce framework to trap disabled
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
index b85af83b4542..92785b33df0f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -790,6 +790,7 @@ void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
 void kvm_vcpu_breakpoint_config(struct kvm_vcpu *vcpu);
 int kvm_id_regs_check_frac_fields(const struct kvm_vcpu *vcpu);
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 69189907579c..bcccf3876fcf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -556,13 +556,16 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a71c52aee34e..7fe44dec11fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -299,6 +299,27 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR2_GPA3_SHIFT) >= \
 	 ID_AA64ISAR2_GPA3_ARCHITECTED)
 
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
 #define __FTR_BITS(ftr_sign, ftr_type, bit_pos, safe) {		\
 	.sign = ftr_sign,					\
 	.type = ftr_type,					\
@@ -321,6 +342,9 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 struct id_reg_desc {
 	const struct sys_reg_desc	reg_desc;
 
+	/* Sanitized system value */
+	u64	sys_val;
+
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
 	 * system value with bits set/cleared for unsupported features for the
@@ -376,6 +400,9 @@ struct id_reg_desc {
 	 * UNSIGNED+LOWER_SAFE entries during KVM's initialization.
 	 */
 	struct arm64_ftr_bits	ftr_bits[FTR_FIELDS_NUM];
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static inline struct id_reg_desc *sys_to_id_desc(const struct sys_reg_desc *r)
@@ -393,6 +420,7 @@ static void id_reg_desc_init(struct id_reg_desc *id_reg)
 		return;
 
 	val = read_sanitised_ftr_reg(id);
+	id_reg->sys_val = val;
 	id_reg->vcpu_limit_val = val;
 
 	id_reg_desc_init_ftr(id_reg);
@@ -908,6 +936,24 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
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
@@ -2387,6 +2433,46 @@ static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
 	return __access_id_reg(vcpu, p, r, true);
 }
 
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
@@ -4487,6 +4573,31 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
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
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
