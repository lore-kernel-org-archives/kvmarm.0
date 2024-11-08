Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079181DE896
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104718; cv=none; b=WKTPezR25ofadxr+VG3bIjlIWDPsSJi7Qg7Kl5dboBeFH+DmmGMXxH/H6lH0jb5jBMu2ov+h47afB5zD1ovwnF8ZEBAzTGLmrf7kJPGzC/F8rP9PMgvGlnV+WRNI+lVLF60lvlI1X5UHToleuM8IbBuH5O73lkbIMGDvgph0tMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104718; c=relaxed/simple;
	bh=rQzz07HE1N1UC3ykLn3hpT7QK0x3bNfI61Z9FbBc8t4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fFs1bvHuM6DRZhlKsKmbQCtX1aQY35zWI0tSYPb3oDw9FUb4TZYSgADpXL0k4EWk/fLI7631ql/r01tpqQfIepYv9iSazgse0I0krO06VQmJpypskLqDckHr5ExxGzZMSMOT57PWkwNOlnIP5YgLmwdPT9f8vBuL+ZtcI5XS7qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xd17eUZE; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xd17eUZE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OyhH4L6dg4wQz1xEhrEdJmNj7ibheAB3WYjLn2619GM=;
	b=xd17eUZEa52yDbkLIy0Xii2B2nEEL1iP/Bu0nU+jcpQeW8XOaLi+DU4hcjg6EKB6547ySw
	J2LFpTMpbs3TmVqttzrM0wTXaxo+qfx1H4RSyT/2xdKViqcuVZ86e6stv8gUT4qQEy6J3y
	YC85cNu//4ped2LN+SxQIXGfknNbSPw=
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
Subject: [PATCH 15/15] KVM: arm64: Manage software step state at load/put
Date: Fri,  8 Nov 2024 14:24:19 -0800
Message-Id: <20241108222418.1677420-16-oliver.upton@linux.dev>
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

KVM takes over the guest's software step state machine if the VMM is
debugging the guest, but it does the save/restore fiddling for every
guest entry.

Note that the only constraint on host usage of software step is that the
guest's configuration remains visible to userspace via the ONE_REG
ioctls. So, we can cut down on the amount of fiddling by doing this at
load/put instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  24 ++---
 arch/arm64/kvm/arm.c              |   4 +-
 arch/arm64/kvm/debug.c            | 149 ++++++++----------------------
 arch/arm64/kvm/guest.c            |   2 +-
 arch/arm64/kvm/handle_exit.c      |   2 +-
 5 files changed, 47 insertions(+), 134 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 036c6de5819e..680f997be5f9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -764,17 +764,6 @@ struct kvm_vcpu_arch {
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
 
-	/*
-	 * Guest registers we preserve during guest debugging.
-	 *
-	 * These shadow registers are updated by the kvm_handle_sys_reg
-	 * trap handler if the guest accesses or updates them while we
-	 * are using guest debug.
-	 */
-	struct {
-		bool	pstate_ss;
-	} guest_debug_preserved;
-
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 	spinlock_t mp_state_lock;
@@ -924,12 +913,14 @@ struct kvm_vcpu_arch {
 #define IN_WFIT			__vcpu_single_flag(sflags, BIT(1))
 /* vcpu system registers loaded on physical CPU */
 #define SYSREGS_ON_CPU		__vcpu_single_flag(sflags, BIT(2))
-/* Software step state is Active-pending */
-#define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(3))
+/* Software step state is Active-pending for external debug */
+#define HOST_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(3))
+/* Software step state is Active pending for guest debug */
+#define GUEST_SS_ACTIVE_PENDING __vcpu_single_flag(sflags, BIT(4))
 /* PMUSERENR for the guest EL0 is on physical CPU */
-#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(4))
+#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(5))
 /* WFI instruction trapped */
-#define IN_WFI			__vcpu_single_flag(sflags, BIT(5))
+#define IN_WFI			__vcpu_single_flag(sflags, BIT(6))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -1341,9 +1332,8 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 
 void kvm_init_host_debug_data(void);
-void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
-void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
+void kvm_vcpu_put_debug(struct kvm_vcpu *vcpu);
 void kvm_handle_debug_access(struct kvm_vcpu *vcpu);
 void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ec581aeb41f9..563cd0b626b9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -622,6 +622,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_vhe(vcpu);
@@ -1181,7 +1182,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
-		kvm_arm_setup_debug(vcpu);
 		kvm_arch_vcpu_ctxflush_fp(vcpu);
 
 		/**************************************************************
@@ -1198,8 +1198,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * Back from guest
 		 *************************************************************/
 
-		kvm_arm_clear_debug(vcpu);
-
 		/*
 		 * We must sync the PMU state before the vgic state so
 		 * that the vgic can properly sample the updated state of the
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index a23d214a0fb0..106382810d4b 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -16,34 +16,6 @@
 
 #include "trace.h"
 
-/*
- * save/restore_guest_debug_regs
- *
- * For some debug operations we need to tweak some guest registers. As
- * a result we need to save the state of those registers before we
- * make those modifications.
- *
- * Guest access to MDSCR_EL1 is trapped by the hypervisor and handled
- * after we have restored the preserved value to the main context.
- *
- * When single-step is enabled by userspace, we tweak PSTATE.SS on every
- * guest entry. Preserve PSTATE.SS so we can restore the original value
- * for the vcpu after the single-step is disabled.
- */
-static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.guest_debug_preserved.pstate_ss =
-					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
-}
-
-static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.guest_debug_preserved.pstate_ss)
-		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
-	else
-		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-}
-
 /**
  * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
  *
@@ -84,89 +56,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 }
 
-/**
- * kvm_arm_setup_debug - set up debug related stuff
- *
- * @vcpu:	the vcpu pointer
- *
- * This is called before each entry into the hypervisor to setup any
- * debug related registers.
- *
- * Additionally, KVM only traps guest accesses to the debug registers if
- * the guest is not actively using them. Since the guest must not interfere
- * with the hardware state when debugging the guest, we must ensure that
- * trapping is enabled whenever we are debugging the guest using the
- * debug registers.
- */
-
-void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
-{
-	unsigned long mdscr;
-
-	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
-
-	/* Check if we need to use the debug registers. */
-	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
-		/* Save guest debug state */
-		save_guest_debug_regs(vcpu);
-
-		/*
-		 * Single Step (ARM ARM D2.12.3 The software step state
-		 * machine)
-		 *
-		 * If we are doing Single Step we need to manipulate
-		 * the guest's MDSCR_EL1.SS and PSTATE.SS. Once the
-		 * step has occurred the hypervisor will trap the
-		 * debug exception and we return to userspace.
-		 *
-		 * If the guest attempts to single step its userspace
-		 * we would have to deal with a trapped exception
-		 * while in the guest kernel. Because this would be
-		 * hard to unwind we suppress the guest's ability to
-		 * do so by masking MDSCR_EL.SS.
-		 *
-		 * This confuses guest debuggers which use
-		 * single-step behind the scenes but everything
-		 * returns to normal once the host is no longer
-		 * debugging the system.
-		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-			/*
-			 * If the software step state at the last guest exit
-			 * was Active-pending, we don't set DBG_SPSR_SS so
-			 * that the state is maintained (to not run another
-			 * single-step until the pending Software Step
-			 * exception is taken).
-			 */
-			if (!vcpu_get_flag(vcpu, DBG_SS_ACTIVE_PENDING))
-				*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
-			else
-				*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-		}
-	}
-}
-
-void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
-{
-	trace_kvm_arm_clear_debug(vcpu->guest_debug);
-
-	/*
-	 * Restore the guest's debug registers if we were using them.
-	 */
-	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
-			if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
-				/*
-				 * Mark the vcpu as ACTIVE_PENDING
-				 * until Software Step exception is taken.
-				 */
-				vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
-		}
-
-		restore_guest_debug_regs(vcpu);
-	}
-}
-
 void kvm_init_host_debug_data(void)
 {
 	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
@@ -197,8 +86,24 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		mdscr = MDSCR_EL1_TDCC;
 
-		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		/*
+		 * Steal the guest's single-step state machine if userspace wants
+		 * single-step the guest.
+		 */
+		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 			mdscr |= MDSCR_EL1_SS;
+
+			if (*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
+				vcpu_clear_flag(vcpu, GUEST_SS_ACTIVE_PENDING);
+			else
+				vcpu_set_flag(vcpu, GUEST_SS_ACTIVE_PENDING);
+
+			if (!vcpu_get_flag(vcpu, HOST_SS_ACTIVE_PENDING))
+				*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+			else
+				*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
+		}
+
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW)
 			mdscr |= MDSCR_EL1_MDE;
 
@@ -220,6 +125,26 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
+void kvm_vcpu_put_debug(struct kvm_vcpu *vcpu)
+{
+	if (likely(!(vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
+		return;
+
+	/*
+	 * Save the host's single-step state machine and restore the guest's
+	 * before potentially returning to userspace.
+	 */
+	if (!(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
+		vcpu_set_flag(vcpu, HOST_SS_ACTIVE_PENDING);
+	else
+		vcpu_clear_flag(vcpu, HOST_SS_ACTIVE_PENDING);
+
+	if (vcpu_get_flag(vcpu, GUEST_SS_ACTIVE_PENDING))
+		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
+	else
+		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
+}
+
 void kvm_handle_debug_access(struct kvm_vcpu *vcpu)
 {
 	if (kvm_host_owns_debug_regs(vcpu))
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b72eec27adc7..bea56c23bf98 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -926,7 +926,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (!(dbg->control & KVM_GUESTDBG_ENABLE)) {
 		vcpu->guest_debug = 0;
-		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		vcpu_clear_flag(vcpu, HOST_SS_ACTIVE_PENDING);
 		return 0;
 	}
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9e..1e302f0c8903 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -193,7 +193,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
 		break;
 	case ESR_ELx_EC_SOFTSTP_LOW:
-		vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
+		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
 		break;
 	}
 
-- 
2.39.5

