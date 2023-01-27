Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFAD28EF;
	Fri, 27 Jan 2023 11:30:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 292B31688;
	Fri, 27 Jan 2023 03:30:56 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DC773F64C;
	Fri, 27 Jan 2023 03:30:12 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev
Subject: [RFC PATCH 12/28] KVM: arm64: Support timers in realm RECs
Date: Fri, 27 Jan 2023 11:29:16 +0000
Message-Id: <20230127112932.38045-13-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM keeps track of the timer while the realm REC is running, but on
exit to the normal world KVM is responsible for handling the timers.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arch_timer.c  | 53 ++++++++++++++++++++++++++++++++----
 include/kvm/arm_arch_timer.h |  2 ++
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index bb24a76b4224..d4af9ee58550 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -130,6 +130,11 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
+	if (kvm_is_realm(vcpu->kvm)) {
+		WARN_ON(offset);
+		return;
+	}
+
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
 		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
@@ -411,6 +416,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	}
 }
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
+	int i;
+
+	for (i = 0; i < NR_KVM_TIMERS; i++) {
+		struct arch_timer_context *timer = &arch_timer->timers[i];
+		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
+		bool level = kvm_timer_irq_can_fire(timer) && status;
+
+		if (level != timer->irq.level)
+			kvm_timer_update_irq(vcpu, level, timer);
+	}
+}
+
 /* Only called for a fully emulated timer */
 static void timer_emulate(struct arch_timer_context *ctx)
 {
@@ -621,6 +641,11 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	if (unlikely(!timer->enabled))
 		return;
 
+	kvm_timer_unblocking(vcpu);
+
+	if (vcpu_is_rec(vcpu))
+		return;
+
 	get_timer_map(vcpu, &map);
 
 	if (static_branch_likely(&has_gic_active_state)) {
@@ -633,8 +658,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	set_cntvoff(timer_get_offset(map.direct_vtimer));
 
-	kvm_timer_unblocking(vcpu);
-
 	timer_restore_state(map.direct_vtimer);
 	if (map.direct_ptimer)
 		timer_restore_state(map.direct_ptimer);
@@ -668,6 +691,9 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (unlikely(!timer->enabled))
 		return;
 
+	if (vcpu_is_rec(vcpu))
+		goto out;
+
 	get_timer_map(vcpu, &map);
 
 	timer_save_state(map.direct_vtimer);
@@ -686,9 +712,6 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
-	if (kvm_vcpu_is_blocking(vcpu))
-		kvm_timer_blocking(vcpu);
-
 	/*
 	 * The kernel may decide to run userspace after calling vcpu_put, so
 	 * we reset cntvoff to 0 to ensure a consistent read between user
@@ -697,6 +720,11 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * virtual offset of zero, so no need to zero CNTVOFF_EL2 register.
 	 */
 	set_cntvoff(0);
+
+out:
+	if (kvm_vcpu_is_blocking(vcpu))
+		kvm_timer_blocking(vcpu);
+
 }
 
 /*
@@ -785,12 +813,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	u64 cntvoff;
 
 	vtimer->vcpu = vcpu;
 	ptimer->vcpu = vcpu;
 
+	if (kvm_is_realm(vcpu->kvm))
+		cntvoff = 0;
+	else
+		cntvoff = kvm_phys_timer_read();
+
 	/* Synchronize cntvoff across all vtimers of a VM. */
-	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
+	update_vtimer_cntvoff(vcpu, cntvoff);
 	timer_set_offset(ptimer, 0);
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
@@ -1265,6 +1299,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
+	/*
+	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
+	 * us setting the LR.HW bit in the VGIC.
+	 */
+	if (vcpu_is_rec(vcpu))
+		return 0;
+
 	get_timer_map(vcpu, &map);
 
 	ret = kvm_vgic_map_phys_irq(vcpu,
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index cd6d8f260eab..158280e15a33 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,6 +76,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
+
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
-- 
2.34.1

