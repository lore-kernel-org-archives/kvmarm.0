Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E7F1E1C2B
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104704; cv=none; b=GT5rrqJOMSCC87yX9IJ3wfKMARruOk5OcIKOYLMK4XQmsiTZ8eMmg7rFVZdS/WjQ61PMZ8KhFAOqNmFfxfP9AHx8n7UceH3pccw8hZRxG9gPpFYnKKllAPmcGLZvBv+Ep9MNWU6jCb7z65iJe9HRZvpsmRyot8WSz2xP9fc/aao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104704; c=relaxed/simple;
	bh=Nfr0tsR2q24jOETZd5tYD68a3Sz5opWS2TVY67NKhNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VcKxS8ZtlL+1SZAOnqo72RPwf7IMg/BJr62W+46/lukAFvXJiXrsRGyzE5V9vgZNxxWPW2XqwFMCoIqq/6h6YUXL7IfXzbRvOFPWjDDPQIMTkit1wQZSyEYn55H6JEryaBeEUtoLUU2m0dC7KrHhpqm3JnhuSvF+JpD0psa70xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dpW7Iaut; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dpW7Iaut"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fc9/MCzQc6TI+WWpeK0GBQ7Nz1yx+GMiVJhSWZGRfvI=;
	b=dpW7Iaut9uIz5DLHwW04o2+QoyHH965h4mxfPjbemc3iou7GP7RpeKoLjiK5WCI6lgo3bH
	khqFXaFP1n9aRF2I+rQ2ofCAyJkhIeNiMFzW2UuXntVQWyV9xy3vx8vJa1uEwUQFIb4gRK
	Z6aEhBo5AiB7b0HkIHz6HjEVIazbXo8=
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
Subject: [PATCH 09/15] KVM: arm64: Remove debug tracepoints
Date: Fri,  8 Nov 2024 14:24:13 -0800
Message-Id: <20241108222418.1677420-10-oliver.upton@linux.dev>
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

The debug tracepoints are a useless firehose of information that track
implementation detail rather than well-defined events. These are going
to be rather difficult to uphold now that the implementation is getting
redone, so throw them out instead of bending over backwards.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/debug.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index c2bf1b296b14..66cf4e843b47 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -35,10 +35,6 @@ static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
 	u64 val = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 
 	vcpu->arch.guest_debug_preserved.mdscr_el1 = val;
-
-	trace_kvm_arm_set_dreg32("Saved MDSCR_EL1",
-				vcpu->arch.guest_debug_preserved.mdscr_el1);
-
 	vcpu->arch.guest_debug_preserved.pstate_ss =
 					(*vcpu_cpsr(vcpu) & DBG_SPSR_SS);
 }
@@ -49,9 +45,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
 
 	vcpu_write_sys_reg(vcpu, val, MDSCR_EL1);
 
-	trace_kvm_arm_set_dreg32("Restored MDSCR_EL1",
-				vcpu_read_sys_reg(vcpu, MDSCR_EL1));
-
 	if (vcpu->arch.guest_debug_preserved.pstate_ss)
 		*vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
 	else
@@ -102,8 +95,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	    !vcpu_get_flag(vcpu, DEBUG_DIRTY) ||
 	    kvm_vcpu_os_lock_enabled(vcpu))
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
-
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 }
 
 /**
@@ -201,8 +192,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 
-		trace_kvm_arm_set_dreg32("SPSR_EL2", *vcpu_cpsr(vcpu));
-
 		/*
 		 * HW Breakpoints and watchpoints
 		 *
@@ -220,14 +209,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
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
@@ -253,8 +234,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
 	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
 		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
-
-	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
@@ -282,14 +261,6 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
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
-- 
2.39.5

