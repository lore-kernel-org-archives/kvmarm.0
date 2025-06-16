Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F5A217709
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115014; cv=none; b=NWzlfRPeHTx+lTbyHMfF1I3kkjHVATi8HtFW5E+vH0rZzRJNnxBEaFv/6dDbCKZJ8vs/wU+kxlI7HxPv3WbSzIOBqxDYKC074LDTqsRkkGgv4KEnv31NkGB9I126Zi6rx6ocb81PoZ3kzbbm6aCiUmJPhVRnZhD8L8I2PN12/7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115014; c=relaxed/simple;
	bh=H7xTzd6dbOHP2DGTF7tuqj6XnBMbzlPrWC8EgrmFDMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KI4DaPkpfHjiAHp16lWIdxtvEm47INyG8ZV2IteYph6pftNX4UpY5GQ43agXWky0xepu8wJTL3GDcESNd1jHDqtavsoJL8sWlBaIvsTIfZ8SpVVRIZcKMMOaXmfAT00J7ev6pEYXXHhbBFRiun8Fn/PLcdouAafGoNKRutwRezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nJh/1qsJ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nJh/1qsJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnptBuwFmDcnvAjMRn9uwdhKKONPvr3CxtSOt2qjZko=;
	b=nJh/1qsJoXrnfaLDBIinOTaue7OOcrH9fwyVA+yDsgwRbdVqF0etbN0PQ49KVga0BHjjdj
	wKmPyeFU9xKFQG+EFxKoDCM5bylfYGtmvPVkIBZ9sfEzclpc1YvnL6ZkUyLvTau5HF8nSR
	dk2GOM8UByUfdzZNXqoZ49NASt18OaI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/27] KVM: arm64: nv: Honor SError exception routing / masking
Date: Mon, 16 Jun 2025 16:02:47 -0700
Message-Id: <20250616230308.1192565-7-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
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
 arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++-
 arch/arm64/include/asm/kvm_host.h    | 20 +++++++++++---
 arch/arm64/include/asm/kvm_nested.h  |  2 ++
 arch/arm64/kvm/arm.c                 |  4 +++
 arch/arm64/kvm/emulate-nested.c      |  8 ++++++
 arch/arm64/kvm/guest.c               | 32 +++++++++++++----------
 arch/arm64/kvm/handle_exit.c         |  4 +--
 arch/arm64/kvm/hyp/exception.c       |  6 ++++-
 arch/arm64/kvm/inject_fault.c        | 39 ++++++++++++++++------------
 arch/arm64/kvm/mmu.c                 |  2 +-
 arch/arm64/kvm/nested.c              | 36 +++++++++++++++++++++++++
 11 files changed, 134 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1a0d51c74b42..45029dd5e9c7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -45,7 +45,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
-void kvm_inject_vabt(struct kvm_vcpu *vcpu);
+int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
 
@@ -59,12 +59,25 @@ static inline int kvm_inject_sea_iabt(struct kvm_vcpu *vcpu, u64 addr)
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
@@ -205,6 +218,11 @@ static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
 	return ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2) & HCR_TGE;
 }
 
+static inline bool vcpu_el2_amo_is_set(const struct kvm_vcpu *vcpu)
+{
+	return ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2) & HCR_AMO;
+}
+
 static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 {
 	bool e2h, tge;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5ccca509dff1..dd7405d676b3 100644
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
@@ -1389,8 +1405,6 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
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
index e99b2535cf51..437bd920f1d0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1188,6 +1188,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
+		kvm_nested_flush_hwstate(vcpu);
+
 		if (kvm_vcpu_has_pmu(vcpu))
 			kvm_pmu_flush_hwstate(vcpu);
 
@@ -1287,6 +1289,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
 
+		kvm_nested_sync_hwstate(vcpu);
+
 		preempt_enable();
 
 		/*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index aa5527ddf506..c2873f6f980d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2714,6 +2714,9 @@ static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 	case except_type_irq:
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_IRQ);
 		break;
+	case except_type_serror:
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
+		break;
 	default:
 		WARN_ONCE(1, "Unsupported EL2 exception injection %d\n", type);
 	}
@@ -2820,3 +2823,8 @@ int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr)
 
 	return kvm_inject_s2_fault(vcpu, esr);
 }
+
+int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr)
+{
+	return kvm_inject_nested(vcpu, esr, except_type_serror);
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
index c37c58d9d25d..a598072f36d2 100644
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
@@ -490,7 +490,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 
 			kvm_handle_guest_serror(vcpu, disr_to_esr(disr));
 		} else {
-			kvm_inject_vabt(vcpu);
+			kvm_inject_serror(vcpu);
 		}
 
 		return;
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 6a2a899a344e..592adc78b149 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -347,9 +347,13 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_irq);
 			break;
 
+		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SERR):
+			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_serror);
+			break;
+
 		default:
 			/*
-			 * Only EL1_SYNC and EL2_{SYNC,IRQ} makes
+			 * Only EL1_SYNC and EL2_{SYNC,IRQ,SERR} makes
 			 * sense so far. Everything else gets silently
 			 * ignored.
 			 */
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d9fa4046b602..10773a8ef4cb 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -219,25 +219,30 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 		inject_undef64(vcpu);
 }
 
-void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 esr)
+static bool kvm_serror_target_is_el2(struct kvm_vcpu *vcpu)
 {
-	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
-	*vcpu_hcr(vcpu) |= HCR_VSE;
+	return is_hyp_ctxt(vcpu) || vcpu_el2_amo_is_set(vcpu);
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
+static bool kvm_serror_undeliverable_at_el2(struct kvm_vcpu *vcpu)
 {
-	kvm_set_sei_esr(vcpu, ESR_ELx_ISV);
+	return !(vcpu_el2_tge_is_set(vcpu) || vcpu_el2_amo_is_set(vcpu));
+}
+
+int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
+{
+	lockdep_assert_held(&vcpu->mutex);
+
+	if (is_nested_ctxt(vcpu) && kvm_serror_target_is_el2(vcpu))
+		return kvm_inject_nested_serror(vcpu, esr);
+
+	if (vcpu_is_el2(vcpu) && kvm_serror_undeliverable_at_el2(vcpu)) {
+		vcpu_set_vsesr(vcpu, esr);
+		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
+		return 1;
+	}
+
+	vcpu_set_vsesr(vcpu, esr & ESR_ELx_ISS_MASK);
+	*vcpu_hcr(vcpu) |= HCR_VSE;
+	return 1;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f05d70dd6d51..2c3094181f9c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1808,7 +1808,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * There is no need to pass the error into the guest.
 		 */
 		if (kvm_handle_guest_sea())
-			kvm_inject_vabt(vcpu);
+			return kvm_inject_serror(vcpu);
 
 		return 1;
 	}
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5b191f4dc566..54de7a712251 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1782,3 +1782,39 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
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
+		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
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
+		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
+}
-- 
2.39.5

