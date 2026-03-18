Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828C53FD13F;
	Wed, 18 Mar 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849342; cv=none; b=WP1736Z670W5dGhDbBMAyddiU5xK51kHjJfi57fUAAO7MzsUe6/2q89L/LlwA/i8cEXFy9fdehnA/kqOQpvIk8iTF5/AixwPaOgOFhEhh6snF+SjRhQkGpgcyzwcfEZfl5Cc/1A+w1YJBY3bnYhTL59yhQlEcSYGP8K8EmB0/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849342; c=relaxed/simple;
	bh=IgxguDRZIt/vJ7+F1A73/Iq0uuGrubZAU+ESrJHOYcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVI1/s1/gs1kwR3+b9NC1fvlVSXnjLqYrvEgzFh5SlF285K6CQ/9mROtMNZZ3GS0PhJ5iMxURN+PZICRohOVul7Iz9Xkx/R67ilUYLrCYJyS4GeTxcdr/qX+4eBSc4I8e13cYbRJvL4cYqnXixGg+jSvBD4u0ACZzv+4eihLXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D9C02050;
	Wed, 18 Mar 2026 08:55:29 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 536EA3F73B;
	Wed, 18 Mar 2026 08:55:32 -0700 (PDT)
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
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 19/48] KVM: arm64: Support timers in realm RECs
Date: Wed, 18 Mar 2026 15:53:43 +0000
Message-ID: <20260318155413.793430-20-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM keeps track of the timer while the realm REC is running, but on
exit to the normal world KVM is responsible for handling the timers.

A later patch adds the support for propagating the timer values from the
exit data structure and calling kvm_realm_timers_update().

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v12:
 * Adapt to upstream changes.
Changes since v11:
 * Drop the kvm_is_realm() check from timer_set_offset(). We already
   ensure that the offset is 0 when calling the function.
Changes since v10:
 * KVM_CAP_COUNTER_OFFSET is now already hidden by a previous patch.
Changes since v9:
 * No need to move the call to kvm_timer_unblocking() in
   kvm_timer_vcpu_load().
Changes since v7:
 * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
---
 arch/arm64/kvm/arch_timer.c  | 28 +++++++++++++++++++++++++---
 include/kvm/arm_arch_timer.h |  2 ++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 600f250753b4..2f2b4befb448 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -453,6 +453,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 			    timer_ctx);
 }
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
+	int i;
+
+	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
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
@@ -1056,7 +1071,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->timer_id = timerid;
 
-	if (!kvm_vm_is_protected(vcpu->kvm)) {
+	if (!kvm_vm_is_protected(vcpu->kvm) && !kvm_is_realm(vcpu->kvm)) {
 		if (timerid == TIMER_VTIMER)
 			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
 		else
@@ -1087,7 +1102,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		timer_context_init(vcpu, i);
 
 	/* Synchronize offsets across timers of a VM if not already provided */
-	if (!vcpu_is_protected(vcpu) &&
+	if (!vcpu_is_protected(vcpu) && !kvm_is_realm(vcpu->kvm) &&
 	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
 		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
 		timer_set_offset(vcpu_ptimer(vcpu), 0);
@@ -1561,6 +1576,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
@@ -1692,7 +1714,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
-	if (kvm_vm_is_protected(kvm))
+	if (kvm_vm_is_protected(kvm) || kvm_is_realm(kvm))
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f4512..bab0daafc6b1 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -111,6 +111,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
+void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
+
 u64 kvm_phys_timer_read(void);
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
-- 
2.43.0

