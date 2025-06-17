Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C118B2E265C
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167470; cv=none; b=pgcs8e5Fn3mZReIJERD9hSOEXnOXtaSyuK8UVe0Zd420c7aXW7Fzn3oEFXm+zKt04S+On6dt1T6PqNqAk/JjN9RwRSe7q3Hes0pWoQKsA5eswFGtbL1G1Ns5ttl+vIP3FYP8xQFYnr/6RbwuR4Ohw2XO+bEunmkyes6uWXtuX9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167470; c=relaxed/simple;
	bh=2iaCJJBTqxr+2KL/te1yL3ZXEzoh66oh0r70FcAmms4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hx+XPMyZtei8ZOYDbXkObpcU/9arJm8SxRSnVdpD95p/dKebHLDH7o1mRe0S2FUZa++Kn2e30O12IZvlW3e6mB96eDcFxJ09cwDa6sy8qUaUkfCJQ7bSRBECpFk1wFZLDuda+l9VjhNNOyB2yi/0mDoFxbTWJzo65bxLx9nx4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E95F1596;
	Tue, 17 Jun 2025 06:37:26 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 657653F673;
	Tue, 17 Jun 2025 06:37:45 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 7/7] KVM: arm64: VHE: Centralize ISBs when returning to host
Date: Tue, 17 Jun 2025 14:37:18 +0100
Message-Id: <20250617133718.4014181-8-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VHE hyp code has recently gained a few ISBs. Simplify this to one
unconditional ISB in __kvm_vcpu_run_vhe(), and remove the unnecessary
ISB from the kvm_call_hyp_ret() macro.

While kvm_call_hyp_ret() is also used to invoke
__vgic_v3_get_gic_config(), but no ISB is necessary in that case either.

For the moment, an ISB is left in kvm_call_hyp(), as there are many more
users, and removign the ISB would require a more thorough audit.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h         |  6 ++----
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  3 ---
 arch/arm64/kvm/hyp/vhe/switch.c           | 25 +++++++++++------------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 382b382d14dac..2e3c152668eb8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1289,9 +1289,8 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 	})
 
 /*
- * The couple of isb() below are there to guarantee the same behaviour
- * on VHE as on !VHE, where the eret to EL1 acts as a context
- * synchronization event.
+ * The isb() below is there to guarantee the same behaviour on VHE as on !VHE,
+ * where the eret to EL1 acts as a context synchronization event.
  */
 #define kvm_call_hyp(f, ...)						\
 	do {								\
@@ -1309,7 +1308,6 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 									\
 		if (has_vhe()) {					\
 			ret = f(__VA_ARGS__);				\
-			isb();						\
 		} else {						\
 			ret = kvm_call_hyp_nvhe(f, ##__VA_ARGS__);	\
 		}							\
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 73881e1dc2679..502a5b73ee70c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -167,9 +167,6 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
-
-	if (has_vhe())
-		isb();
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 32b4814eb2b7a..477f1580ffeaa 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -558,10 +558,10 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	sysreg_save_host_state_vhe(host_ctxt);
-
 	fpsimd_lazy_switch_to_guest(vcpu);
 
+	sysreg_save_host_state_vhe(host_ctxt);
+
 	/*
 	 * Note that ARM erratum 1165522 requires us to configure both stage 1
 	 * and stage 2 translation for the guest context before we clear
@@ -586,18 +586,23 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__deactivate_traps(vcpu);
 
-	/* Ensure CPTR trap deactivation has taken effect */
+	sysreg_restore_host_state_vhe(host_ctxt);
+
+	__debug_switch_to_host(vcpu);
+
+	/*
+	 * Ensure that all system register writes above have taken effect
+	 * before returning to the host. In VHE mode, CPTR traps for
+	 * FPSIMD/SVE/SME also apply to EL2, so FPSIMD/SVE/SME state must be
+	 * manipulated after the ISB.
+	 */
 	isb();
 
 	fpsimd_lazy_switch_to_host(vcpu);
 
-	sysreg_restore_host_state_vhe(host_ctxt);
-
 	if (guest_owns_fp_regs())
 		__fpsimd_save_fpexc32(vcpu);
 
-	__debug_switch_to_host(vcpu);
-
 	return exit_code;
 }
 NOKPROBE_SYMBOL(__kvm_vcpu_run_vhe);
@@ -627,12 +632,6 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	local_daif_restore(DAIF_PROCCTX_NOIRQ);
 
-	/*
-	 * When we exit from the guest we change a number of CPU configuration
-	 * parameters, such as traps.  We rely on the isb() in kvm_call_hyp*()
-	 * to make sure these changes take effect before running the host or
-	 * additional guests.
-	 */
 	return ret;
 }
 
-- 
2.30.2

