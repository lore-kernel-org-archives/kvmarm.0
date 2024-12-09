Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E6270819
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767817; cv=none; b=EBERARNtNWxmlp0WX5tDpZmuaLN2JzCFiytEKcML8g6v/3t7lZvbtr9U31g94XDwxwlaeSoMB3MqxfU7kcxuyXx8+PghypUH6X9rwkeJ4uvkeF3FYaklj++q5b87exqW4+sHXxd49Xvsl5zqxucQ4KQbkeI66ltxxJHgu6h+3y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767817; c=relaxed/simple;
	bh=/LHazkqhrSocVGEJhxMDE0sV6KbSCOV8kbPBgRZr7zY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ad1Gzyy0AQkuxmj8jyEEqMRHkCC8SgFbqAg7e/+fVtn97iMjOJQLUGzmhpbxW9mKAf7a8mPBG9MCG+WYufI2mYVHUQ4XQyO2uELnCwQyhYaslxhsiJ/UGaGhyy/xLdqKGxGsY+BAyKP1+jHqeSMTp8wGyFa1lHbecIdwzT/sUOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EMa6gcMl; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EMa6gcMl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLXf32+H6J/agX4Ph3CeEGfK2Uph4thhlzPR8GlTAFM=;
	b=EMa6gcMlUcsim8+2CEpWPHpdluEVpM/zcC5nvYBoGQYnzYFaru96szswiHNUl4OWrglabM
	vvuNc7eCC4MpYAkqg4dhugwpMaSnyJKWKWVxzK20CjEgntayw7N42yKmLqPChos+YKmDB9
	RLjtnE4euRrR55E9WPucig8s0irl7xk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 13/16] KVM: arm64: Don't hijack guest context MDSCR_EL1
Date: Mon,  9 Dec 2024 10:09:23 -0800
Message-Id: <20241209180926.2161373-14-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Stealing MDSCR_EL1 in the guest's kvm_cpu_context for external debugging
is rather gross. Just add a field for this instead and let the context
switch code pick the correct one based on the debug owner.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h          |  2 +-
 arch/arm64/kvm/debug.c                     | 73 +++++++++++-----------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 39 ++++++++----
 3 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c630d59e7f4c..e7036096d9c2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -751,6 +751,7 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
+	u64 external_mdscr_el1;
 
 	enum {
 		VCPU_DEBUG_FREE,
@@ -771,7 +772,6 @@ struct kvm_vcpu_arch {
 	 * are using guest debug.
 	 */
 	struct {
-		u32	mdscr_el1;
 		bool	pstate_ss;
 	} guest_debug_preserved;
 
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index eb645ede2053..3e6066b466e1 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -31,19 +31,12 @@
  */
 static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
-	u64 val = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
-
-	vcpu->arch.guest_debug_preserved.mdscr_el1 = val;
 	vcpu->arch.guest_debug_preserved.pstate_ss =
 					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
 }
 
 static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 {
-	u64 val = vcpu->arch.guest_debug_preserved.mdscr_el1;
-
-	vcpu_write_sys_reg(vcpu, val, MDSCR_EL1);
-
 	if (vcpu->arch.guest_debug_preserved.pstate_ss)
 		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
 	else
@@ -148,36 +141,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 				*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
 			else
 				*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-
-			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
-			mdscr |= DBG_MDSCR_SS;
-			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
-		} else {
-			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
-			mdscr &= ~DBG_MDSCR_SS;
-			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
-		}
-
-		/*
-		 * Enable breakpoints and watchpoints if userspace wants them.
-		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
-			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
-			mdscr |= DBG_MDSCR_MDE;
-			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
-
-		/*
-		 * The OS Lock blocks debug exceptions in all ELs when it is
-		 * enabled. If the guest has enabled the OS Lock, constrain its
-		 * effects to the guest. Emulate the behavior by clearing
-		 * MDSCR_EL1.MDE. In so doing, we ensure that host debug
-		 * exceptions are unaffected by guest configuration of the OS
-		 * Lock.
-		 */
-		} else if (kvm_vcpu_os_lock_enabled(vcpu)) {
-			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
-			mdscr &= ~DBG_MDSCR_MDE;
-			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
 }
@@ -223,6 +186,41 @@ void kvm_init_host_debug_data(void)
 		host_data_set_flag(HAS_TRBE);
 }
 
+/*
+ * Configures the 'external' MDSCR_EL1 value for the guest, i.e. when the host
+ * has taken over MDSCR_EL1.
+ *
+ *  - Userspace is single-stepping the guest, and MDSCR_EL1.SS is forced to 1.
+ *
+ *  - Userspace is using the breakpoint/watchpoint registers to debug the
+ *    guest, and MDSCR_EL1.MDE is forced to 1.
+ *
+ *  - The guest has enabled the OS Lock, and KVM is forcing MDSCR_EL1.MDE to 0,
+ *    masking all debug exceptions affected by the OS Lock.
+ */
+static void setup_external_mdscr(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Use the guest's MDSCR_EL1 as a starting point, since there are
+	 * several other features controlled by MDSCR_EL1 that are not relevant
+	 * to the host.
+	 *
+	 * Clear the bits that KVM may use which also satisfies emulation of
+	 * the OS Lock as MDSCR_EL1.MDE is cleared.
+	 */
+	u64 mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1) & ~(MDSCR_EL1_SS |
+							   MDSCR_EL1_MDE |
+							   MDSCR_EL1_KDE);
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		mdscr |= MDSCR_EL1_SS;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+		mdscr |= MDSCR_EL1_MDE | MDSCR_EL1_KDE;
+
+	vcpu->arch.external_mdscr_el1 = mdscr;
+}
+
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 {
 	u64 mdscr;
@@ -245,6 +243,7 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 	 */
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		vcpu->arch.debug_owner = VCPU_DEBUG_HOST_OWNED;
+		setup_external_mdscr(vcpu);
 	} else {
 		mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a998b2f6abcb..76ff095c6b6e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -18,9 +18,34 @@
 
 static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
 
+static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
+
+	if (!vcpu)
+		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
+
+	return vcpu;
+}
+
+static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
+{
+	return host_data_ptr(host_ctxt) != ctxt;
+}
+
+static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
+{
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
+
+	if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
+		return &vcpu->arch.external_mdscr_el1;
+
+	return &ctxt_sys_reg(ctxt, MDSCR_EL1);
+}
+
 static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
+	*ctxt_mdscr_el1(ctxt)	= read_sysreg(mdscr_el1);
 
 	// POR_EL0 can affect uaccess, so must be saved/restored early.
 	if (ctxt_has_s1poe(ctxt))
@@ -33,16 +58,6 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
 }
 
-static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
-{
-	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
-
-	if (!vcpu)
-		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
-
-	return vcpu;
-}
-
 static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
@@ -139,7 +154,7 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 
 static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt_sys_reg(ctxt, MDSCR_EL1),  mdscr_el1);
+	write_sysreg(*ctxt_mdscr_el1(ctxt),  mdscr_el1);
 
 	// POR_EL0 can affect uaccess, so must be saved/restored early.
 	if (ctxt_has_s1poe(ctxt))
-- 
2.39.5

