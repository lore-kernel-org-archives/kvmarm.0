Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8A6191493
	for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 22:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731711004; cv=none; b=jH/26KFGSOO1lp378ClJmN8xOD3MaqyomoFNSp/iKTtmeQNng2ybYMV1VkP0/VMLoHqwSDcLEHnU4asi9YQZGUbw2bXA59Kr9jIp4GyS/9yfAmO5IgHN5wVflmBYaeLrcRRq667Gr8Eab53RMpnZrQKwdRzsq7VMQ9rp6+HdCjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731711004; c=relaxed/simple;
	bh=vWBGah0MOgx+C+1LxrzCG2VBSx3ZisgQJkrOg+Oxe/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=caIQkk3QnVKNsC32v0sPNGfVPRy/a8IXyT6Gs1l6MB50veqJ+slh6/nqkA2iO3AVLMt4Jb+uktEJ4V76HDj33Mz3pUrynjPiSQ4pCrN099FeFYRVp29YyOpLiYcL8+eWQyLEV7x9NbM6jBjWwJ44RQ794CBe+kgwrBoAR4iib9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wKYUaVKo; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wKYUaVKo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731711000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAjsKohddLfkMX3uqLipv454DFnLvV/dTEj37HPWztU=;
	b=wKYUaVKoN74wuUgdVV+vZ7qFQkSWllmguLu052daWuF61a8xV41zn5S45mM/ONJOHPFVsl
	C5JEixDp1fxukn9ZW5mCTD0jWyByN0Nrlw5DEs+bKZMjbaeIpin2Vh5eSWt5EjaywsNPpK
	gyrBH56UEvijJ9crGt7+Ef0eIYnb4Kw=
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
Subject: [PATCH v2 08/16] KVM: arm64: Remove debug tracepoints
Date: Fri, 15 Nov 2024 14:49:16 -0800
Message-Id: <20241115224924.2132364-9-oliver.upton@linux.dev>
In-Reply-To: <20241115224924.2132364-1-oliver.upton@linux.dev>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The debug tracepoints are a useless firehose of information that track
implementation detail rather than well-defined events. These are going
to be rather difficult to uphold now that the implementation is getting
redone, so throw them out instead of bending over backwards.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/debug.c             | 30 ------------
 arch/arm64/kvm/sys_regs.c          | 11 -----
 arch/arm64/kvm/trace_handle_exit.h | 75 ------------------------------
 3 files changed, 116 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index da297cc92ed5..0993fc02647c 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -14,7 +14,6 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 
-#include "trace.h"
 
 /*
  * save/restore_guest_debug_regs
@@ -35,10 +34,6 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 	u64 val = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 
 	vcpu->arch.guest_debug_preserved.mdscr_el1 = val;
-
-	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
-				vcpu->arch.guest_debug_preserved.mdscr_el1);
-
 	vcpu->arch.guest_debug_preserved.pstate_ss =
 					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
 }
@@ -49,9 +44,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	vcpu_write_sys_reg(vcpu, val, MDSCR_EL1);
 
-	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
-				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
-
 	if (vcpu->arch.guest_debug_preserved.pstate_ss)
 		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
 	else
@@ -102,8 +94,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	    !vcpu_get_flag(vcpu, DEBUG_DIRTY) ||
 	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 }
 
 /**
@@ -201,8 +191,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 
-		trace_kvm_arm_set_dreg32("SPSR_EL2", *vcpu_cpsr(vcpu));
-
 		/*
 		 * HW Breakpoints and watchpoints
 		 *
@@ -220,14 +208,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
-			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
-						&vcpu->arch.debug_ptr->dbg_bcr[0],
-						&vcpu->arch.debug_ptr->dbg_bvr[0]);
-
-			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
-						&vcpu->arch.debug_ptr->dbg_wcr[0],
-						&vcpu->arch.debug_ptr->dbg_wvr[0]);
-
 		/*
 		 * The OS Lock blocks debug exceptions in all ELs when it is
 		 * enabled. If the guest has enabled the OS Lock, constrain its
@@ -253,8 +233,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-
-	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
@@ -282,14 +260,6 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
 			kvm_arm_reset_debug_ptr(vcpu);
-
-			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
-						&vcpu->arch.debug_ptr->dbg_bcr[0],
-						&vcpu->arch.debug_ptr->dbg_bvr[0]);
-
-			trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
-						&vcpu->arch.debug_ptr->dbg_wcr[0],
-						&vcpu->arch.debug_ptr->dbg_wvr[0]);
 		}
 	}
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b17cd93c1c8d..f84306b11261 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -657,8 +657,6 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
 	kvm_debug_set_guest_ownership(vcpu);
-	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
-
 	return true;
 }
 
@@ -711,8 +709,6 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
 	kvm_debug_set_guest_ownership(vcpu);
-	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
-
 	return true;
 }
 
@@ -748,8 +744,6 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
-
 	return true;
 }
 
@@ -785,9 +779,6 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->CRm, p->is_write,
-		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm]);
-
 	return true;
 }
 
@@ -823,8 +814,6 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
-
 	return true;
 }
 
diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index 064a58c19f48..f85415db7713 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -46,38 +46,6 @@ TRACE_EVENT(kvm_hvc_arm64,
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
 
-TRACE_EVENT(kvm_arm_setup_debug,
-	TP_PROTO(struct kvm_vcpu *vcpu, __u32 guest_debug),
-	TP_ARGS(vcpu, guest_debug),
-
-	TP_STRUCT__entry(
-		__field(struct kvm_vcpu *, vcpu)
-		__field(__u32, guest_debug)
-	),
-
-	TP_fast_assign(
-		__entry->vcpu = vcpu;
-		__entry->guest_debug = guest_debug;
-	),
-
-	TP_printk("vcpu: %p, flags: 0x%08x", __entry->vcpu, __entry->guest_debug)
-);
-
-TRACE_EVENT(kvm_arm_clear_debug,
-	TP_PROTO(__u32 guest_debug),
-	TP_ARGS(guest_debug),
-
-	TP_STRUCT__entry(
-		__field(__u32, guest_debug)
-	),
-
-	TP_fast_assign(
-		__entry->guest_debug = guest_debug;
-	),
-
-	TP_printk("flags: 0x%08x", __entry->guest_debug)
-);
-
 /*
  * The dreg32 name is a leftover from a distant past. This will really
  * output a 64bit value...
@@ -99,49 +67,6 @@ TRACE_EVENT(kvm_arm_set_dreg32,
 	TP_printk("%s: 0x%llx", __entry->name, __entry->value)
 );
 
-TRACE_DEFINE_SIZEOF(__u64);
-
-TRACE_EVENT(kvm_arm_set_regset,
-	TP_PROTO(const char *type, int len, __u64 *control, __u64 *value),
-	TP_ARGS(type, len, control, value),
-	TP_STRUCT__entry(
-		__field(const char *, name)
-		__field(int, len)
-		__array(u64, ctrls, 16)
-		__array(u64, values, 16)
-	),
-	TP_fast_assign(
-		__entry->name = type;
-		__entry->len = len;
-		memcpy(__entry->ctrls, control, len << 3);
-		memcpy(__entry->values, value, len << 3);
-	),
-	TP_printk("%d %s CTRL:%s VALUE:%s", __entry->len, __entry->name,
-		__print_array(__entry->ctrls, __entry->len, sizeof(__u64)),
-		__print_array(__entry->values, __entry->len, sizeof(__u64)))
-);
-
-TRACE_EVENT(trap_reg,
-	TP_PROTO(const char *fn, int reg, bool is_write, u64 write_value),
-	TP_ARGS(fn, reg, is_write, write_value),
-
-	TP_STRUCT__entry(
-		__field(const char *, fn)
-		__field(int, reg)
-		__field(bool, is_write)
-		__field(u64, write_value)
-	),
-
-	TP_fast_assign(
-		__entry->fn = fn;
-		__entry->reg = reg;
-		__entry->is_write = is_write;
-		__entry->write_value = write_value;
-	),
-
-	TP_printk("%s %s reg %d (0x%016llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
-);
-
 TRACE_EVENT(kvm_handle_sys_reg,
 	TP_PROTO(unsigned long hsr),
 	TP_ARGS(hsr),
-- 
2.39.5

