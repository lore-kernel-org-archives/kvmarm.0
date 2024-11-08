Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569F81E22E0
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104707; cv=none; b=kKsBt7Bj/SpAR5NbTkfYqF8HNQD0nWeznPQznMTgigZclXIi/EDdRha+pNlDgg/OevgiihVArG2yH582vffXU0wgt5i/kyDw5PmUgoIbUVT03JwXzZB832Y38rU1WsLT0O50MUFVOVwYQwMP3B0OFOEtB3RufD6GX+XxIAWM0PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104707; c=relaxed/simple;
	bh=zgvURwPUy7gScWoAyAdw52hY14fDZj1tbCXRCrmsrFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BPM8DPMbZfesnqdzrY2zdX1bvwsYI8pztVOJ1Zsuk5as07ssyCkH9m902BsK2cJvDcOfeEaoFeep88yh7wYnlll5y6Pznn3CtpjQmRXrnyava/LZ8QGCe7WeSTYzNddBL1i7ViRs//MSpEHL3F6FsSIVuTUZA0u3RgaK9J17KWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NT2Ki2Lq; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NT2Ki2Lq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYdGY9tns6HP6fUaDqxaI97G6l9R2R48DQms6B+SLo4=;
	b=NT2Ki2LqRunpTadRIE37RrEyJg3CeEgn+ZZwYwnE73xC/Sd4Xq4iSUpu37rDsCAtCki/qd
	b2Gsw1tEBD2izHRjjZ3BP9njt97C7OKYDPtZN6Gt4hwGfzodk297vOd3xHx3L4SFRPyQqO
	o9NNTNiBfxamLcwQA//W+fQ0NDVNLOc=
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
Subject: [PATCH 10/15] KVM: arm64: Remove vestiges of debug_ptr
Date: Fri,  8 Nov 2024 14:24:14 -0800
Message-Id: <20241108222418.1677420-11-oliver.upton@linux.dev>
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

Delete the remnants of debug_ptr now that debug registers are selected
based on the debug owner instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  |  5 -----
 arch/arm64/kvm/arm.c               |  2 --
 arch/arm64/kvm/debug.c             | 30 +-----------------------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 --
 4 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2d9aee66d5d4..e0189a78d6e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -748,11 +748,7 @@ struct kvm_vcpu_arch {
 	 *
 	 * external_debug_state contains the debug values we want to debug the
 	 * guest. This is set via the KVM_SET_GUEST_DEBUG ioctl.
-	 *
-	 * debug_ptr points to the set of debug registers that should be loaded
-	 * onto the hardware when running the guest.
 	 */
-	struct kvm_guest_debug_arch *debug_ptr;
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
@@ -1350,7 +1346,6 @@ void kvm_init_host_debug_data(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
-void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
 void kvm_handle_debug_access(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a068337da52a..44a6093b0d9e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -476,8 +476,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_pmu_vcpu_init(vcpu);
 
-	kvm_arm_reset_debug_ptr(vcpu);
-
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 66cf4e843b47..075c340fc594 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -111,16 +111,6 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-/**
- * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
- * @vcpu:	the vcpu pointer
- */
-
-void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.debug_ptr = &vcpu->arch.vcpu_debug_state;
-}
-
 /**
  * kvm_arm_setup_debug - set up debug related stuff
  *
@@ -193,20 +183,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		}
 
 		/*
-		 * HW Breakpoints and watchpoints
-		 *
-		 * We simply switch the debug_ptr to point to our new
-		 * external_debug_state which has been populated by the
-		 * debug ioctl. The existing DEBUG_DIRTY mechanism ensures
-		 * the registers are updated on the world switch.
+		 * Enable breakpoints and watchpoints if userspace wants them.
 		 */
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
-			/* Enable breakpoints/watchpoints */
 			mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
 			mdscr |= DBG_MDSCR_MDE;
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 
-			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
 			vcpu_set_flag(vcpu, DEBUG_DIRTY);
 
 		/*
@@ -224,9 +207,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	BUG_ON(!vcpu->guest_debug &&
-		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
@@ -254,14 +234,6 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 		}
 
 		restore_guest_debug_regs(vcpu);
-
-		/*
-		 * If we were using HW debug we need to restore the
-		 * debug_ptr to the guest debug state.
-		 */
-		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW) {
-			kvm_arm_reset_debug_ptr(vcpu);
-		}
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 16f5da3a884a..f98ef98af183 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -112,8 +112,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
-	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
-
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
-- 
2.39.5

