Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636CA1BDABE
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648113; cv=none; b=lOV8OsDN2CFNs1uAnix2fPIqN9EZVgKAQFsDvA2Y+19pOMW50x99uvRiPAJT/OeSeYTU+mLYhpNfghXO6qVyMRV+mzFEer+kDmz7Z4jT4DAp/Idz8BoLQq/KzkBqkqe0g3YzYA2ZrSFTawHSZgoQ1wE4+WdgR+NqRz7cNWS9dbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648113; c=relaxed/simple;
	bh=VASs9vmIyPmZtYv7J18TGpiqUS/I9/shhfYToRFqyiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nG6/xJ0Ri3FmH7/mkbmBnMnCyNte25VhZGNkEma0gtKlpjmVUXehAZbHbKi4aoEdzg8I9WiTyEDQdrzmMdxt/UxG3JmzarDQ0s0l+VfiPnrGaN4+qMFvFoKdmV0Jzn70bR6xPTLJXcoutrhja+j2gcPqeYHKK1J5628jsOpuCXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zf+rs/QK; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zf+rs/QK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnII9ddphTYBdXc5LJLgATEcwov/kpS6sLvniZwhZso=;
	b=Zf+rs/QKcPPdU33jPISgI7KB0fTcREg3WIOSrSY1CTx2Z85srxJqvF6WtmLP4CWejufNui
	Az6imEi+wuqD63v1i4p8X7iNkoPUvlmMNTctSIW16stIrPr6wXLVvr8pRmllT8vu7VYrwP
	4ISZZd6bzqxNYiuoiIBRvC1KuWkBN2w=
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
Subject: [PATCH v4 09/19] KVM: arm64: Remove debug tracepoints
Date: Thu, 19 Dec 2024 14:41:06 -0800
Message-Id: <20241219224116.3941496-10-oliver.upton@linux.dev>
In-Reply-To: <20241219224116.3941496-1-oliver.upton@linux.dev>
References: <20241219224116.3941496-1-oliver.upton@linux.dev>
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

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/debug.c             | 30 ------------
 arch/arm64/kvm/sys_regs.c          | 11 -----
 arch/arm64/kvm/trace_handle_exit.h | 75 ------------------------------
 3 files changed, 116 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3222729a559d..62d7e4041814 100644
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
@@ -110,8 +102,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
 	preempt_enable();
-
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 }
 
 /**
@@ -209,8 +199,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 
-		trace_kvm_arm_set_dreg32("SPSR_EL2", *vcpu_cpsr(vcpu));
-
 		/*
 		 * HW Breakpoints and watchpoints
 		 *
@@ -228,14 +216,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
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
@@ -257,8 +237,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
-
-	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
@@ -286,14 +264,6 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
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
index e45a096be669..8c5771572133 100644
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
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
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

