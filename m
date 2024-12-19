Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A4D86337
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648115; cv=none; b=ID1nK8GAJTWGdhnkXgNBYumIVhb2QGyKR61P9/vW8IByuz878Y8Tc9UFyBPI+het1n3JlV/HRvWxYLFeHYOR/73XuTXGgkZPQw59As0yQgFgCX7rKrexsGMvJnv0r9n6v4qOLhUT736kP3jdwKFq0AgkIip0W5BalDxoL/9Xues=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648115; c=relaxed/simple;
	bh=jJja2LqDsLDb8G+v6YYrHKYu/5VJm8sOMbaBqKk7eTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lc/k4C8WRSE/jFhmwzPCgmg7O5h+8CbxOo2KVYGZ+ZA9ksRnMLaZwc+qEAv7/CkTCiHxBGGd670DWFHc7BMTmwlTC0/GDkWdfSWCqyQLjaU3qYvkKRxliaZfo8/DFK2UjTzTWUXQ+EIY3DShmzWEDttd981wsQ1hIXCg+WDpPbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qMjRtwIS; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qMjRtwIS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJiQKcNs7a1BkLPIrKyjmoLaKBkZARgEE757h03DCcI=;
	b=qMjRtwISplt0WL+1M6M0dtH1z1VmeTHrEpAVNW7rYxVTeAnvubH1pLGcyRiqhxh9zbC8M6
	U/IaUHrkcS8Dc2sb7JlDP+xsFjVrLUCJSLDUPFR9oO//UotTM5hNazvnx3pVwxPHkYgVal
	wyD+DVCP+oDPOJ7o2MU14KakI8vWoq0=
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
Subject: [PATCH v4 10/19] KVM: arm64: Remove vestiges of debug_ptr
Date: Thu, 19 Dec 2024 14:41:07 -0800
Message-Id: <20241219224116.3941496-11-oliver.upton@linux.dev>
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

Delete the remnants of debug_ptr now that debug registers are selected
based on the debug owner instead.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  |  5 -----
 arch/arm64/kvm/arm.c               |  2 --
 arch/arm64/kvm/debug.c             | 30 +-----------------------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  2 --
 4 files changed, 1 insertion(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5ef1b2f69e89..905b84e59c24 100644
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
 void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu);
 
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
index 62d7e4041814..c75874435157 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -118,16 +118,6 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
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
@@ -200,20 +190,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
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
@@ -231,9 +214,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	BUG_ON(!vcpu->guest_debug &&
-		vcpu->arch.debug_ptr != &vcpu->arch.vcpu_debug_state);
-
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
 		vcpu_set_flag(vcpu, DEBUG_DIRTY);
@@ -257,14 +237,6 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
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

