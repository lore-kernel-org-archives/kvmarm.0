Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7D154BFC
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767810; cv=none; b=ggaIt+4dNTfGT3EiHlCIoosJRgd0Hq2jX5LUiJQPmjmcOGXWjd2jNkHJSBwOAuaMZg5rc7ydlgehouN1kdD0cd9LI0/VfjSDsZPPxZTREyl/CdYLuGLdc0g0A1GeKgO6zTT9DdJkUjIVzFbt1bp0ar7jbYbbRerHJusvEUG2850=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767810; c=relaxed/simple;
	bh=UxCLLtv5GPxlPhRUppL344v7yHMDUFymW8N1kQERGYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8Wt2FN+8EYDPvIBJXe6KENd3paYfgEFvfdp9cHusMYJTLu43UDKh7f+28jxuhyHtjj8rXMMAV9M3K5otDODyUNS+DhgiJnTadE9eglny2KNzCDW2k8HZ24HMhIFe8qLaHLw+DNivMaQJW/Dw2SogQ6a7FA/orG85I7u8HQ6yP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wka+WodX; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wka+WodX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NKrHkxFwDn2R/JJiPKVdlgdd3deX6AE61qTNPrqnM0=;
	b=Wka+WodXjHa/EMQPEQ/3H3G0d0dCRYcsJSSCIlMBGRS/k+t58HE1bBjAkjRzYQB/1ZL62n
	2Rzp8qYrmfAh2rX0390HAIwg1rVqqeOo7rHny9BJVOpogra+N0mMyuHWQPe8FVjae4fmAr
	+axTtQE7B/WzbnBqsvb9p8Y5jnwfnRM=
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
Subject: [PATCH v3 10/16] KVM: arm64: Use debug_owner to track if debug regs need save/restore
Date: Mon,  9 Dec 2024 10:09:20 -0800
Message-Id: <20241209180926.2161373-11-oliver.upton@linux.dev>
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

Use the debug owner to determine if the debug regs are in use instead of
keeping around the DEBUG_DIRTY flag. Debug registers are now
saved/restored after the first trap, regardless of whether it was a read
or a write. This also shifts the point at which KVM becomes lazy to
vcpu_put() rather than the next exception taken from the guest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h          |  4 +--
 arch/arm64/kvm/debug.c                     | 19 ++-----------
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  2 --
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 +--
 arch/arm64/kvm/sys_regs.c                  | 33 ----------------------
 5 files changed, 7 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 905b84e59c24..a6796a952af7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -917,8 +917,6 @@ struct kvm_vcpu_arch {
 #define EXCEPT_AA64_EL2_IRQ	__vcpu_except_flags(5)
 #define EXCEPT_AA64_EL2_FIQ	__vcpu_except_flags(6)
 #define EXCEPT_AA64_EL2_SERR	__vcpu_except_flags(7)
-/* Guest debug is live */
-#define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
 
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(0))
@@ -1356,6 +1354,8 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu);
 	((vcpu)->arch.debug_owner != VCPU_DEBUG_FREE)
 #define kvm_host_owns_debug_regs(vcpu)		\
 	((vcpu)->arch.debug_owner == VCPU_DEBUG_HOST_OWNED)
+#define kvm_guest_owns_debug_regs(vcpu)		\
+	((vcpu)->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED)
 
 int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 65c5871603c2..54c93b37a06a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -84,15 +84,9 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
 
 	/*
-	 * Trap debug register access when one of the following is true:
-	 *  - Userspace is using the hardware to debug the guest
-	 *  (KVM_GUESTDBG_USE_HW is set).
-	 *  - The guest is not using debug (DEBUG_DIRTY clear).
-	 *  - The guest has enabled the OS Lock (debug exceptions are blocked).
+	 * Trap debug registers if the guest doesn't have ownership of them.
 	 */
-	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
-	    !vcpu_get_flag(vcpu, DEBUG_DIRTY) ||
-	    kvm_vcpu_os_lock_enabled(vcpu))
+	if (!kvm_guest_owns_debug_regs(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 }
 
@@ -119,8 +113,7 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
  * debug related registers.
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
- * the guest is not actively using them (see the DEBUG_DIRTY
- * flag on vcpu->arch.iflags).  Since the guest must not interfere
+ * the guest is not actively using them. Since the guest must not interfere
  * with the hardware state when debugging the guest, we must ensure that
  * trapping is enabled whenever we are debugging the guest using the
  * debug registers.
@@ -189,8 +182,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			mdscr |= DBG_MDSCR_MDE;
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 
-			vcpu_set_flag(vcpu, DEBUG_DIRTY);
-
 		/*
 		 * The OS Lock blocks debug exceptions in all ELs when it is
 		 * enabled. If the guest has enabled the OS Lock, constrain its
@@ -206,10 +197,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* If KDE or MDE are set, perform a full save/restore cycle. */
-	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
-		vcpu_set_flag(vcpu, DEBUG_DIRTY);
-
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 9e3051225039..c14586d87361 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -176,8 +176,6 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-
-	vcpu_clear_flag(vcpu, DEBUG_DIRTY);
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a651c43ad679..a998b2f6abcb 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -283,7 +283,7 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
-	if (has_vhe() || vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (has_vhe() || kvm_debug_regs_in_use(vcpu))
 		__vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
@@ -300,7 +300,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
 
-	if (has_vhe() || vcpu_get_flag(vcpu, DEBUG_DIRTY))
+	if (has_vhe() || kvm_debug_regs_in_use(vcpu))
 		write_sysreg(__vcpu_sys_reg(vcpu, DBGVCR32_EL2), dbgvcr32_el2);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f84306b11261..5b8982bcc0bb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -621,40 +621,12 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 	}
 }
 
-/*
- * We want to avoid world-switching all the DBG registers all the
- * time:
- *
- * - If we've touched any debug register, it is likely that we're
- *   going to touch more of them. It then makes sense to disable the
- *   traps and start doing the save/restore dance
- * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
- *   then mandatory to save/restore the registers, as the guest
- *   depends on them.
- *
- * For this, we use a DIRTY bit, indicating the guest has modified the
- * debug registers, used as follow:
- *
- * On guest entry:
- * - If the dirty bit is set (because we're coming back from trapping),
- *   disable the traps, save host registers, restore guest registers.
- * - If debug is actively in use (DBG_MDSCR_KDE or DBG_MDSCR_MDE set),
- *   set the dirty bit, disable the traps, save host registers,
- *   restore guest registers.
- * - Otherwise, enable the traps
- *
- * On guest exit:
- * - If the dirty bit is set, save guest registers, restore host
- *   registers and clear the dirty bit. This ensure that the host can
- *   now use the debug registers.
- */
 static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
 	access_rw(vcpu, p, r);
 	if (p->is_write)
-		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
 	kvm_debug_set_guest_ownership(vcpu);
 	return true;
@@ -665,9 +637,6 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
  *
  * A 32 bit write to a debug register leave top bits alone
  * A 32 bit read from a debug register only returns the bottom bits
- *
- * All writes will set the DEBUG_DIRTY flag to ensure the hyp code
- * switches between host and guest values in future.
  */
 static void reg_to_dbg(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
@@ -682,8 +651,6 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	val &= ~mask;
 	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
-
-	vcpu_set_flag(vcpu, DEBUG_DIRTY);
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
-- 
2.39.5

