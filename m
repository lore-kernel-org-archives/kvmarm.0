Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F931C4608
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104717; cv=none; b=M9W6GioIkBGCxdC/b1YvKli69J/HIt/FcOBWCcgxPLvFz7q5JVggsC0nkDPUU56/SpkztkF0O+3xF/L0S55o3/huCv/1Uf+DgpItSYXQIVG+jCHB3Au8dxoQcmBYq4+vD3+JylAoZ/Wq//zANbuY5QcX97MNRS1nyruOR+kC2zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104717; c=relaxed/simple;
	bh=TAWTO5ZBeVnwJwn5hYrzZH/3TJ4st5tAWUbzyOXrPLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WUDAdcxQKwrxcm6vSctJ6krEGfiLZCGBOV3axuOtU/OD263tGVXxZrHjvBOBd+s54Qn//8L6v4ShT7zFtPVXO8DcTpH8i1BATGlNQlKXUmasf9x0BvCOYbSzPHNxQmvepOqzhJsKPtazMLr8dKnsu6S3kS5k8YRNoH5m4V1N1G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ThIFakEB; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ThIFakEB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQUnPj5JXCZOdN7E+4MfnJ05LqQBZzFVsgfPAxUaQWU=;
	b=ThIFakEBanrk3bBhPqUdygy4uDYx+Xdh0fqXT6fTcwYsWUAu/M86xGmWE5RsKPYIwDUugH
	xVuxYvAPQ+hZaw8O6aJuqp49T15VKeska8oI7yWSOlWnsWiyiZQQZr2BHQ7QMqb7i1Zoq5
	3MoiH/P3B/kX/3C0nDoTBUAGacdN6Ck=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 14/15] KVM: arm64: Don't hijack guest context MDSCR_EL1
Date: Fri,  8 Nov 2024 14:24:18 -0800
Message-Id: <20241108222418.1677420-15-oliver.upton@linux.dev>
In-Reply-To: <20241108222418.1677420-1-oliver.upton@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/debug.c                     | 45 ++++------------------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 38 ++++++++++++------
 3 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8c7e37180ab..036c6de5819e 100644
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
index 9ac237c3ae0c..a23d214a0fb0 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -32,19 +32,12 @@
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
@@ -149,36 +142,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
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
@@ -232,6 +195,14 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 	KVM_BUG_ON(vcpu_get_flag(vcpu, SYSREGS_ON_CPU), vcpu->kvm);
 
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
+		mdscr = MDSCR_EL1_TDCC;
+
+		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+			mdscr |= MDSCR_EL1_SS;
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
+			mdscr |= MDSCR_EL1_MDE;
+
+		vcpu->arch.external_mdscr_el1 = mdscr;
 		vcpu->arch.debug_owner = VCPU_DEBUG_HOST_OWNED;
 	} else {
 		mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a998b2f6abcb..49770963cf84 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -18,9 +18,33 @@
 
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
+#define ctxt_mdscr_el1(ctxt)						\
+({									\
+	u64 *__p = &ctxt_sys_reg(ctxt, MDSCR_EL1);			\
+	struct kvm_vcpu *__v = ctxt_to_vcpu(ctxt);			\
+	if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(__v))	\
+		__p = &(__v)->arch.external_mdscr_el1;			\
+	__p;								\
+})
+
 static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt_sys_reg(ctxt, MDSCR_EL1)	= read_sysreg(mdscr_el1);
+	*ctxt_mdscr_el1(ctxt)	= read_sysreg(mdscr_el1);
 
 	// POR_EL0 can affect uaccess, so must be saved/restored early.
 	if (ctxt_has_s1poe(ctxt))
@@ -33,16 +57,6 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
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
@@ -139,7 +153,7 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 
 static inline void __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt_sys_reg(ctxt, MDSCR_EL1),  mdscr_el1);
+	write_sysreg(*ctxt_mdscr_el1(ctxt),  mdscr_el1);
 
 	// POR_EL0 can affect uaccess, so must be saved/restored early.
 	if (ctxt_has_s1poe(ctxt))
-- 
2.39.5

