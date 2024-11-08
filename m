Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4EB1DE896
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104715; cv=none; b=GwQLKm7DsQAb2w4xE+NpcyA5aeS+Wd0ec9yHKCYgrKX8aQqW0er7332XAgYuMPXLWSSczZHx+Ach6BykoH5A1Gj/5n+epUwHuu6Lxu22QxCJxUUX1LLgc3i0y7P61aciTMTiu9dCph3awQv4OarkNdmMJhfBGbUxRAg43rJ50Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104715; c=relaxed/simple;
	bh=AEOX1Ttl+JoHQe78FvH4AES18pIiBfh7XQUGGTEEdpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iJfqsRFP2zyv+UQiyvwOQTRe3eo8crpSBGOlftU7kDMNXT4hXgA2skkpXbCNAycJjTbZ8pFXjDEbv7tnWPnxRvJGRTr8Jx1BPF18DOaBPK0GSd5ISMjPRwy0PbScC2uR/A8Kg8pkgloeJh7VbP3BoGLrpiTcr5t3A+oPZXgGAr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fHrv5Lo9; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fHrv5Lo9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xA/Eqk2W5UzEtMCjQHw3xhROPDxtq9Wi/HfI1TFNZks=;
	b=fHrv5Lo9vfokKECFn/ZQ02/gHNp4kJIr/VFlEWBdz9ImYW2KmfUrKFetC/LfFDVW9KH3Vx
	wjfbhKvjDRecDvAFN1+luIkrnxi7QMsSWA+IFlzXl3K2CESU1mSRAefGTrn5qOyZs2KjMn
	DwQ+i2lW6ZVXXFUjvm2eqXqZyISyckw=
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
Subject: [PATCH 13/15] KVM: arm64: Compute MDCR_EL2 at vcpu_load()
Date: Fri,  8 Nov 2024 14:24:17 -0800
Message-Id: <20241108222418.1677420-14-oliver.upton@linux.dev>
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

KVM has picked up several hacks to cope with vcpu->arch.mdcr_el2 needing
to be prepared before vcpu_load(), which is when it gets programmed
into hardware on VHE.

Now that the flows for reprogramming MDCR_EL2 have been simplified, move
that computation to vcpu_load().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  2 --
 arch/arm64/kvm/debug.c            | 28 +++++++---------------------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 91341fb3405d..f8c7e37180ab 100644
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
index 04a62660ca5b..9ac237c3ae0c 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -91,20 +91,6 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
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
@@ -122,12 +108,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu)
 
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
@@ -197,10 +181,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 		}
 	}
-
-	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
-	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
@@ -265,6 +245,8 @@ void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu)
 		else
 			vcpu->arch.debug_owner = VCPU_DEBUG_FREE;
 	}
+
+	kvm_arm_setup_mdcr_el2(vcpu);
 }
 
 void kvm_handle_debug_access(struct kvm_vcpu *vcpu)
@@ -274,6 +256,10 @@ void kvm_handle_debug_access(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
 	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
+	kvm_arm_setup_mdcr_el2(vcpu);
+
+	if (has_vhe())
+		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
-- 
2.39.5

