Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D03D3D1C
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271329; cv=none; b=Zikihk89KaJ1ss4GGW/U0ZuqxYuxEJnRHt0G6JX3eOas0390TS0j57sAk9Ggf3YNhSjF/LSvIfhEyEIb52avqlY8Rg3aGw3uyk4/pfTweO7038bQ+39+8Hgu8WmckpzMe7BK11ZovJewIXL41KI1au2Yj4l9Wdpn1wyeQn81oaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271329; c=relaxed/simple;
	bh=Rjx6xKnyZ1jlUzGXalkgg0ya5Y1xkezh8B8Obk4/YyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHewu9AlLddo8r4VljWMaArfVZALUbGFFm0lGF9aQcV0Ym1junfupK+Rs4EMG1XBzWTNv5u2AFIZJT2Ueiunrh/FokozkQPitZDyzLCdQNCMWSvxBatJf8heRIStrNHN0SL3CJOgXo0gU4wGwWvu4CHnJcTW+7ZkiM8NQLOgy7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzdLkPJo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzdLkPJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41921F00897;
	Wed, 20 May 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271327;
	bh=hCAk3Gutgb6E1tCD18puZISwEVAMwSOtmWsm5EQivnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzdLkPJo2/P21rATMqL0btQWLV3FNlvnaPrEwlY5McgSPFCmTmp3M2PjlDLXYXzr1
	 vis34JDnHShF3RNN0cz+80dkbdaZk1H9rXuY5XW9lljPZZVi3EGf9F7wxWVe8pEXoV
	 gjbG/sdxmdCAZKXa9BpiQ9wo6maRKZoP2lYzbUyZ0YYRFqFq9FTpTMZh61NTy6aZ5F
	 Ygo1oyHp6BryAiUsG7/HffZvRQPc9uI6fIgyQiCy9MJJ8gVayf6rRL5nqHAiHWg3bI
	 /xyTfMaWx0DIIoryI8/bexzJTTyuY/C5mDMve8AG+yJ02YhvaDtU/GLPMXIQRyFZLd
	 Nsbs0x3eMzfcA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkb-00000004Jio-3Rzq;
	Wed, 20 May 2026 10:02:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 2/6] KVM: arm64: Simplify userspace notification of interrupt state
Date: Wed, 20 May 2026 11:01:56 +0100
Message-ID: <20260520100200.543845-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The userspace notification of interrupts is has a few problems:

- it is utterly pointless

- it is annoyingly split between detecting the need for notification
  and the population of the interrupts in the run structure

We can't do anything about the former (yet), but the latter can be
addressed. If we detect that we must notify userspace, we know that
we are going to exit, as we populate the exit status. Which means
we can also populate the interrupt state at this stage and be done
with it.

This simplifies the structure of the code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 49 +++++++++++++++---------------------
 arch/arm64/kvm/arm.c         | 24 ++++++++++--------
 arch/arm64/kvm/pmu-emul.c    | 18 +++++--------
 include/kvm/arm_arch_timer.h |  2 +-
 include/kvm/arm_pmu.h        |  4 +--
 5 files changed, 43 insertions(+), 54 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d8add34717f07..7236dd6a99e67 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -404,22 +404,30 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0;
 }
 
+static u64 kvm_timer_needs_notify(struct kvm_vcpu *vcpu)
+{
+	u64 v = vcpu->run->s.regs.device_irq_level;
+
+	v ^= kvm_timer_pending(vcpu_vtimer(vcpu)) ? KVM_ARM_DEV_EL1_VTIMER : 0;
+	v ^= kvm_timer_pending(vcpu_ptimer(vcpu)) ? KVM_ARM_DEV_EL1_PTIMER : 0;
+
+	return v & (KVM_ARM_DEV_EL1_VTIMER | KVM_ARM_DEV_EL1_PTIMER);
+}
+
+bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
+{
+	return !!kvm_timer_needs_notify(vcpu);
+}
+
 /*
  * Reflect the timer output level into the kvm_run structure
  */
-void kvm_timer_update_run(struct kvm_vcpu *vcpu)
+bool kvm_timer_update_run(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
-
-	/* Populate the device bitmap with the timer states */
-	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
-				    KVM_ARM_DEV_EL1_PTIMER);
-	if (kvm_timer_pending(vtimer))
-		regs->device_irq_level |= KVM_ARM_DEV_EL1_VTIMER;
-	if (kvm_timer_pending(ptimer))
-		regs->device_irq_level |= KVM_ARM_DEV_EL1_PTIMER;
+	u64 mask = kvm_timer_needs_notify(vcpu);
+	if (mask)
+		vcpu->run->s.regs.device_irq_level ^= mask;
+	return !!mask;
 }
 
 static void kvm_timer_update_status(struct arch_timer_context *ctx, bool level)
@@ -903,23 +911,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	timer_set_traps(vcpu, &map);
 }
 
-bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
-{
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
-	bool vlevel, plevel;
-
-	if (likely(irqchip_in_kernel(vcpu->kvm)))
-		return false;
-
-	vlevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_VTIMER;
-	plevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_PTIMER;
-
-	return kvm_timer_pending(vtimer) != vlevel ||
-	       kvm_timer_pending(ptimer) != plevel;
-}
-
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8bb2c7422cc8b..6e6dc17f8b606 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1163,6 +1163,15 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	return !kvm_supports_32bit_el0();
 }
 
+static bool kvm_irq_update_run(struct kvm_vcpu *vcpu)
+{
+	bool r;
+
+	r  = kvm_timer_update_run(vcpu);
+	r |= kvm_pmu_update_run(vcpu);
+	return r;
+}
+
 /**
  * kvm_vcpu_exit_request - returns true if the VCPU should *not* enter the guest
  * @vcpu:	The VCPU pointer
@@ -1184,13 +1193,11 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
 	/*
 	 * If we're using a userspace irqchip, then check if we need
 	 * to tell a userspace irqchip about timer or PMU level
-	 * changes and if so, exit to userspace (the actual level
-	 * state gets updated in kvm_timer_update_run and
-	 * kvm_pmu_update_run below).
+	 * changes and if so, exit to userspace while updating the run
+	 * state.
 	 */
 	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
-		if (kvm_timer_should_notify_user(vcpu) ||
-		    kvm_pmu_should_notify_user(vcpu)) {
+		if (unlikely(kvm_irq_update_run(vcpu))) {
 			*ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
 			return true;
@@ -1405,11 +1412,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		ret = handle_exit(vcpu, ret);
 	}
 
-	/* Tell userspace about in-kernel device output levels */
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
-		kvm_timer_update_run(vcpu);
-		kvm_pmu_update_run(vcpu);
-	}
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		kvm_irq_update_run(vcpu);
 
 	kvm_sigset_deactivate(vcpu);
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e1860acae641f..31a472a2c4881 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -413,27 +413,21 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
 	bool run_level = sregs->device_irq_level & KVM_ARM_DEV_PMU;
 
-	if (likely(irqchip_in_kernel(vcpu->kvm)))
-		return false;
-
-	return pmu->irq_level != run_level;
+	return kvm_pmu_overflow_status(vcpu) != run_level;
 }
 
 /*
  * Reflect the PMU overflow interrupt output level into the kvm_run structure
  */
-void kvm_pmu_update_run(struct kvm_vcpu *vcpu)
+bool kvm_pmu_update_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
-
-	/* Populate the timer bitmap for user space */
-	regs->device_irq_level &= ~KVM_ARM_DEV_PMU;
-	if (vcpu->arch.pmu.irq_level)
-		regs->device_irq_level |= KVM_ARM_DEV_PMU;
+	bool update = kvm_pmu_should_notify_user(vcpu);
+	if (update)
+		vcpu->run->s.regs.device_irq_level ^= KVM_ARM_DEV_PMU;
+	return update;
 }
 
 /**
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index bf8cc9589bd09..9e4076eebd29f 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -104,7 +104,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
-void kvm_timer_update_run(struct kvm_vcpu *vcpu);
+bool kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vm(struct kvm *kvm);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 0a36a3d5c8944..3e844c5ee9174 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -54,7 +54,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
-void kvm_pmu_update_run(struct kvm_vcpu *vcpu);
+bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
@@ -131,7 +131,7 @@ static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
-static inline void kvm_pmu_update_run(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_pmu_update_run(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
-- 
2.47.3

