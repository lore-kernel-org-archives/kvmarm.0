Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A71E86337
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648121; cv=none; b=O8+Me+ABQClBvUzYgu+jgeSuX5pwMgBCiTDw2suZCZMx/0rHDTp3h57UEmeG/1p9LWcG1HGypzr/R9Z2O1+Hw+izNIxd69fEAW4Ww8hHGOqWCBZ+WtnLeMJPsEWZt/Cvtb4tOvd7ZZ5glHhYviNMkuUW+yG/YxQlx4lkB4ooi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648121; c=relaxed/simple;
	bh=FpNobRWMPqvpFqCnE5CzLRYTJ6pvwNMH5nfgbvYnZgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDddwjuoCRLQ9pyOgYJYK7WVjYzZslwKZW866bNjwseBv3Bwvg/9Hty/U+I+rhgUWx9nHMqT4Wv4La0EZBOzfT/uXmL1DTWXkA0UUxJ+lpalXf4wKRh7MrqD1tUBTBwiqOhHq0kVwqSorav3dRgzjvN30RQw/zqFD7o6SVH/xso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hI8/bkvX; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hI8/bkvX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvtVF1Yo8eKpsyvNuiK86Q0iPchTcr170g6Yjxg/T5g=;
	b=hI8/bkvXlOYp2X4/aobUuffB9xLyvFVP4AJYhtzkdXx+v3Q7/giTvBUN7zZhWjWt/ec+TL
	tzPtWQKn8h+EvVC5r+T9Vkguh+YybA6rxBmPkaH+2rxmOsjloMOmSu4AQTxlcdw6vGhG7c
	GTlo13igS/m+FUe0bkIPmYs3l3cbQR0=
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
Subject: [PATCH v4 13/19] KVM: arm64: Compute MDCR_EL2 at vcpu_load()
Date: Thu, 19 Dec 2024 14:41:10 -0800
Message-Id: <20241219224116.3941496-14-oliver.upton@linux.dev>
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

KVM has picked up several hacks to cope with vcpu->arch.mdcr_el2 needing
to be prepared before vcpu_load(), which is when it gets programmed
into hardware on VHE.

Now that the flows for reprogramming MDCR_EL2 have been simplified, move
that computation to vcpu_load().

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  2 --
 arch/arm64/kvm/debug.c            | 21 ++++-----------------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d61b8ed32a21..c630d59e7f4c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1341,7 +1341,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 
 void kvm_init_host_debug_data(void);
-void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 44a6093b0d9e..ec581aeb41f9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -804,8 +804,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 
 	kvm_init_mpidr_data(kvm);
 
-	kvm_arm_vcpu_init_debug(vcpu);
-
 	if (likely(irqchip_in_kernel(kvm))) {
 		/*
 		 * Map the VGIC hardware resources before running a vcpu the
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index bf348c86758f..900a63030fda 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -98,20 +98,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-/**
- * kvm_arm_vcpu_init_debug - setup vcpu debug traps
- *
- * @vcpu:	the vcpu pointer
- *
- * Set vcpu initial mdcr_el2 value.
- */
-void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
-{
-	preempt_disable();
-	kvm_arm_setup_mdcr_el2(vcpu);
-	preempt_enable();
-}
-
 /**
  * kvm_arm_setup_debug - set up debug related stuff
  *
@@ -129,12 +115,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
+	unsigned long mdscr;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
-	kvm_arm_setup_mdcr_el2(vcpu);
-
 	/* Check if we need to use the debug registers. */
 	if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
 		/* Save guest debug state */
@@ -277,6 +261,8 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 		else
 			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
 	}
+
+	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
 /*
@@ -291,6 +277,7 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
 void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
-- 
2.39.5

