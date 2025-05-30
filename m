Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3F528BAA3
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 23:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646404; cv=none; b=gvI/SM1ofUNQ5hCC1DKaFuULFATqUwV6jYcoyEELa6THnxOtxWzNgYxAXGrba6B+QHCDIopGUrjD1SqFdKBlEVXstrbvNPj1csXs9QGuRujNLEEh8HiiO/vRibYi7R/UKYBt0Ceol/dawJAuVjcbW4lvg19GoS9A7Q7seLMqGrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646404; c=relaxed/simple;
	bh=DyPUtS93T/stWmSKu91pXmQq2Zn8drxixqgK1j9AwZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tConERqfEgeraA8qPYJgtJkmE2X3sZRZyHSKQtuc5ADhULFAhJV9BR7r3Ox1iest6XWc6Oh0LFz935VoG5t3paUTFRWLpzDfvQOjvIzPDRaTwC2xJ2dDsxjt1L9x8cm+cUMoVq3kSbkVel9aP3U8EWN/sGYh/PnUuW+ZgbyFE1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=trnLQjV3; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="trnLQjV3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NH9SpQzJyhDtU3tA1VdFBI1OcLejqzsYvr4DerIATCs=;
	b=trnLQjV3JlzBPOHDuZK8iBX+EsEZ4nCsuXs+6sr6raV38NQpfeMUF0qrYJ+n4iHDuzfQSU
	i17uEwB+78775r0OSqqyH5BbAbRhP8ppI+6p02gVHWoqU9LbyTcILpR5BzTw9eoKdn25eS
	uGmNHWTQhf2DRTE+OmPI0XgzeRP9WMY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/4] KVM: arm64: nv: Honor SError exception routing / masking
Date: Fri, 30 May 2025 16:06:22 -0700
Message-Id: <20250530230623.650888-4-oliver.upton@linux.dev>
In-Reply-To: <20250530230623.650888-1-oliver.upton@linux.dev>
References: <20250530230623.650888-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To date KVM has used HCR_EL2.VSE to track the state of a pending SError
for the guest. With this bit set, hardware respects the EL1 exception
routing / masking rules and injects the vSError when appropriate.

This isn't correct for NV guests as hardware is oblivious to vEL2's
intentions for SErrors. Better yet, with FEAT_NV2 the guest can change
the routing behind our back as HCR_EL2 is redirected to memory. Cope
with this mess by:

 - Using a flag (instead of HCR_EL2.VSE) to track the pending SError
   state when SErrors are unconditionally masked for the current context

 - Resampling the routing / masking of a pending SError on every guest
   entry/exit

 - Emulating exception entry when SError routing implies a translation
   regime change

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++++++-
 arch/arm64/include/asm/kvm_host.h    | 20 +++++++++++++---
 arch/arm64/include/asm/kvm_nested.h  |  2 ++
 arch/arm64/kvm/arm.c                 |  4 ++++
 arch/arm64/kvm/emulate-nested.c      | 33 +++++++++++++++++++++++++
 arch/arm64/kvm/guest.c               | 32 ++++++++++++++-----------
 arch/arm64/kvm/handle_exit.c         |  4 ++--
 arch/arm64/kvm/inject_fault.c        | 24 +++++++------------
 arch/arm64/kvm/mmu.c                 |  2 +-
 arch/arm64/kvm/nested.c              | 36 ++++++++++++++++++++++++++++
 10 files changed, 137 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index e0fa8a5a2530..55ac1e88d028 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -45,7 +45,8 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
-void kvm_inject_vabt(struct kvm_vcpu *vcpu);
+void __kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
+int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
 void __kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
@@ -60,12 +61,25 @@ static inline int kvm_inject_sea_iabt(struct kvm_vcpu *vcpu, u64 addr)
 	return kvm_inject_sea(vcpu, true, addr);
 }
 
+static inline int kvm_inject_serror(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * ESR_ELx.ISV (later renamed to IDS) indicates whether or not
+	 * ESR_ELx.ISS contains IMPLEMENTATION DEFINED syndrome information.
+	 *
+	 * Set the bit when injecting an SError w/o an ESR to indicate ISS
+	 * does not follow the architected format.
+	 */
+	return kvm_inject_serror_esr(vcpu, ESR_ELx_ISV);
+}
+
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
 int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
+int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr);
 
 static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d941abc6b5ee..75f7b6fde8be 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -817,7 +817,7 @@ struct kvm_vcpu_arch {
 	u8 iflags;
 
 	/* State flags for kernel bookkeeping, unused by the hypervisor code */
-	u8 sflags;
+	u16 sflags;
 
 	/*
 	 * Don't run the guest (internal implementation need).
@@ -953,9 +953,23 @@ struct kvm_vcpu_arch {
 		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
+#define __vcpu_test_and_clear_flag(v, flagset, f, m)		\
+	({							\
+		typeof(v->arch.flagset) set;			\
+								\
+		__vcpu_flags_preempt_disable();			\
+		set = __vcpu_get_flag(v, flagset, f, m);	\
+		__vcpu_clear_flag(v, flagset, f, m);		\
+		__vcpu_flags_preempt_enable();			\
+								\
+		set;						\
+	})
+
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
+#define vcpu_test_and_clear_flag(v, ...)			\
+	__vcpu_test_and_clear_flag((v), __VA_ARGS__)
 
 /* KVM_ARM_VCPU_INIT completed */
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
@@ -1015,6 +1029,8 @@ struct kvm_vcpu_arch {
 #define IN_WFI			__vcpu_single_flag(sflags, BIT(6))
 /* KVM is currently emulating a nested ERET */
 #define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(7))
+/* SError pending for nested guest */
+#define NESTED_SERROR_PENDING	__vcpu_single_flag(sflags, BIT(8))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -1370,8 +1386,6 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
 	return (vcpu_arch->steal.base != INVALID_GPA);
 }
 
-void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
-
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0bd07ea068a1..7fd76f41c296 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -80,6 +80,8 @@ extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
 extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
+extern void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu);
+extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
 	phys_addr_t output;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 36cfcffb40d8..5a4aca8082e7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1187,6 +1187,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
+		kvm_nested_flush_hwstate(vcpu);
+
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_flush_hwstate(vcpu);
 
@@ -1286,6 +1288,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
 
+		kvm_nested_sync_hwstate(vcpu);
+
 		preempt_enable();
 
 		/*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3d2f98fdca2f..1039613aabce 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2836,3 +2836,36 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 
 	return kvm_inject_s2_fault(vcpu, esr);
 }
+
+/*
+ * Injects an SError into a nested guest according to the exception routing /
+ * masking rules in R_NMMXK and R_JFKMF, respectively.
+ */
+int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
+{
+	bool el2 = __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_TGE | HCR_AMO);
+
+	/*
+	 * SError exception routing does not require a translation regime
+	 * change; let hardware deliver the vSError.
+	 */
+	if (is_hyp_ctxt(vcpu) == el2) {
+		__kvm_inject_serror_esr(vcpu, esr);
+		return 1;
+	}
+
+	/*
+	 * SError exception routing requires a regime change but is not subject
+	 * to masking.
+	 */
+	if (!is_hyp_ctxt(vcpu) && el2)
+		return kvm_inject_nested(vcpu, esr, except_type_serror);
+
+	/*
+	 * SError exception remains pending. Stash the ESR and attempt injection
+	 * when the routing / masking changes.
+	 */
+	vcpu_set_vsesr(vcpu, esr);
+	vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
+	return 1;
+}
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd5cce0006f3..5af09373daa0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -818,8 +818,9 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
-	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
 	events->exception.serror_has_esr = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
+	events->exception.serror_pending = (vcpu->arch.hcr_el2 & HCR_VSE) ||
+					   vcpu_get_flag(vcpu, NESTED_SERROR_PENDING);
 
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
@@ -839,27 +840,30 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
+	u64 esr = events->exception.serror_esr;
 	int ret;
 
-	if (serror_pending && has_esr) {
-		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
-			return -EINVAL;
-
-		if (!((events->exception.serror_esr) & ~ESR_ELx_ISS_MASK))
-			kvm_set_sei_esr(vcpu, events->exception.serror_esr);
-		else
-			return -EINVAL;
-	} else if (serror_pending) {
-		kvm_inject_vabt(vcpu);
-	}
-
 	if (ext_dabt_pending) {
 		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 		if (ret < 0)
 			return ret;
 	}
 
-	return 0;
+	if (!serror_pending)
+		return 0;
+
+	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && has_esr)
+		return -EINVAL;
+
+	if (has_esr && (esr & ~ESR_ELx_ISS_MASK))
+		return -EINVAL;
+
+	if (has_esr)
+		ret = kvm_inject_serror_esr(vcpu, esr);
+	else
+		ret = kvm_inject_serror(vcpu);
+
+	return (ret < 0) ? ret : 0;
 }
 
 u32 __attribute_const__ kvm_target_cpu(void)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 453266c96481..145ea1f3aa16 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -32,7 +32,7 @@ typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 {
 	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(NULL, esr))
-		kvm_inject_vabt(vcpu);
+		kvm_inject_serror(vcpu);
 }
 
 static int handle_hvc(struct kvm_vcpu *vcpu)
@@ -496,7 +496,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 
 			kvm_handle_guest_serror(vcpu, disr_to_esr(disr));
 		} else {
-			kvm_inject_vabt(vcpu);
+			kvm_inject_serror(vcpu);
 		}
 
 		return;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d45424e3e0ff..46c0d2a91160 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -221,25 +221,19 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
-void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 esr)
+void __kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
 	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
 	*vcpu_hcr(vcpu) |= HCR_VSE;
 }
 
-/**
- * kvm_inject_vabt - inject an async abort / SError into the guest
- * @vcpu: The VCPU to receive the exception
- *
- * It is assumed that this code is called from the VCPU thread and that the
- * VCPU therefore is not currently executing guest code.
- *
- * Systems with the RAS Extensions specify an imp-def ESR (ISV/IDS = 1) with
- * the remaining ISS all-zeros so that this error is not interpreted as an
- * uncategorized RAS error. Without the RAS Extensions we can't specify an ESR
- * value, so the CPU generates an imp-def value.
- */
-void kvm_inject_vabt(struct kvm_vcpu *vcpu)
+int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 {
-	kvm_set_sei_esr(vcpu, ESR_ELx_ISV);
+	lockdep_assert_held(&vcpu->mutex);
+
+	if (vcpu_has_nv(vcpu))
+		return kvm_inject_nested_serror(vcpu, esr);
+
+	__kvm_inject_serror_esr(vcpu, esr);
+	return 1;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0e0d51d7ab85..ec58c5a82377 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1805,7 +1805,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * There is no need to pass the error into the guest.
 		 */
 		if (kvm_handle_guest_sea())
-			kvm_inject_vabt(vcpu);
+			return kvm_inject_serror(vcpu);
 
 		return 1;
 	}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 291dbe38eb5c..67741da8353a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1780,3 +1780,39 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu))
 		kvm_inject_nested_irq(vcpu);
 }
+
+/*
+ * One of the many architectural bugs in FEAT_NV2 is that the guest hypervisor
+ * can write to HCR_EL2 behind our back, potentially changing the exception
+ * routing / masking for even the host context.
+ *
+ * What follows is some slop to (1) react to exception routing / masking and (2)
+ * preserve the pending SError state across translation regimes.
+ */
+void kvm_nested_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_has_nv(vcpu))
+		return;
+
+	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
+		kvm_inject_nested_serror(vcpu, vcpu_get_vsesr(vcpu));
+}
+
+void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	unsigned long *hcr = vcpu_hcr(vcpu);
+
+	if (!vcpu_has_nv(vcpu))
+		return;
+
+	/*
+	 * We previously decided that an SError was deliverable to the guest.
+	 * Reap the pending state from HCR_EL2 and...
+	 */
+	if (unlikely(__test_and_clear_bit(__ffs(HCR_VSE), hcr)))
+		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
+
+	/* Re-attempt SError injection in case the deliverability has changed */
+	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
+		kvm_inject_nested_serror(vcpu, vcpu_get_vsesr(vcpu));
+}
-- 
2.39.5

