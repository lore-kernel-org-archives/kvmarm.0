Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAFD155327
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767815; cv=none; b=hQBhVl/NQcpHGuxk1icC/jDZX3iN9hYzeSz8fehXFVuqtRZxUjtDBOAY2UsRrs6omYYQaxFWgq5f5ms6Vm9aBUPtyF3VV8zwld8SPmY1/sYpklE8lfKT+FfLplFtKrSO1Y6biccVpmFqobaTXmXiMxOtS2+OxAhuRS5aR5BM5qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767815; c=relaxed/simple;
	bh=fQ2CpckdIeJ/insGsJ+BHZB+lSqWtjNs4x7TDGrhUKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jbcx8PdEdB7VUF4k5tqfyKBiz78hYNdcOrSvUI+f7U/+ZjKiJ9OcWhI6R1ZSbtT5DAPhSy/g/9+5A3kOujd2o7ElsJrtY8QY7U0r+iGNRIru48LkIZHek6CR7EJU8KAIhoIxxgvkZo/9Q8hdl7Bmo8xyy23FKy2CUN6rghN5cLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=baZ1P7+1; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="baZ1P7+1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOLoKkLf/DBB3/dCiMKHPtAmslDFPaU2tSx/yOGy1oQ=;
	b=baZ1P7+1TRSN4E0vMPDlCcxNG1llic9GjOmdb29p5KY9/q8thLcRYnYuRman2FtlSENZVZ
	E4gk7KDE69c2Q7wpUmlMWzoXAoEx7DnwSQxm2xFOij1VIqefmjaqy3HoingROxICxee381
	9FU5UrbDO324ADC5Om0M3KdHyrCptKk=
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
Subject: [PATCH v3 12/16] KVM: arm64: Compute MDCR_EL2 at vcpu_load()
Date: Mon,  9 Dec 2024 10:09:22 -0800
Message-Id: <20241209180926.2161373-13-oliver.upton@linux.dev>
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

KVM has picked up several hacks to cope with vcpu->arch.mdcr_el2 needing
to be prepared before vcpu_load(), which is when it gets programmed
into hardware on VHE.

Now that the flows for reprogramming MDCR_EL2 have been simplified, move
that computation to vcpu_load().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  2 --
 arch/arm64/kvm/debug.c            | 30 +++++++++---------------------
 3 files changed, 9 insertions(+), 24 deletions(-)

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
index 91f484a566e4..eb645ede2053 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -90,20 +90,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
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
@@ -121,12 +107,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
 
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
@@ -196,10 +180,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
-
-	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
-	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
@@ -273,6 +253,8 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 		else
 			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
 	}
+
+	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
 /*
@@ -288,6 +270,12 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
 	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+
+	preempt_disable();
+	kvm_arm_setup_mdcr_el2(vcpu);
+	if (has_vhe())
+		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	preempt_enable();
 }
 
 void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
-- 
2.39.5

