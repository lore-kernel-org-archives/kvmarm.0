Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114359;
	b=BRx2ddUOHJj+9nugJbwirtWOF+HHlk7JjBl2/O4gHyb/2I5+hMHoZ1FlGBrN4RIh0wzN
	 VwwwR/S8LFCEyrRvaFNU6ZwbM+MlUhFqNW8LifmSlRrfMLHJNpqtGKbFEJDgt8ZUIJglC
	 fW0X6Hr35DZfPap+Zkl0cu9yt+oseaqgqRFMsn+GOEAQ7p0Hh3kuux/Dx48Jr3paEn6Q0
	 XEV8ymifpLc8p5zhAj+W44LMIXbRA6xd7N6eCTFTdpV2wZuVbc2nYeI9BQZ0LdnGcqfov
	 P34Ebrve3X3qyLerILN9AKSlgpUTNYuzvij5J5A9ChfjhPlZOOWyGi+c780F1VWNiow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ou5XHXMFjy2tsHMgHvL3l0HkkEqCUhvCxjE9vqvsRzg=;
	b=urTtcmNRhEITpOVU3mLQioXdYPL8Cgaj3ji4Vl9RHMAhb7oZeIGxC58anQBJ8luiCWg6
	 Cp1DcLA7tR6Kxv08NfshYpUm3Kg8epBHpgNXdvFXKgLzltmajz4SLDXC0fa4fJUJJjNBN
	 NBuPIPOmbV0ecOsmyOSUgzAyPIROdve9zQXL+Dw/SCc3aewbh/73Hj9xpV0muZR/q1Ep3
	 hVL8eGgNrZtmLF+G09mWDJxsnjA+EmFWLIlF1e28hTB2Hu4YUT/Ac7O/QGfEYic6WmCXt
	 oWOUCoiYGmKQrMAGPHNAdSJ1lk29bqr5OF15qkJnPT27murOOsXmuR4Lmrcne/PhhJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LKEa0L9S;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55B9606E8CE
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E55B9606E8CE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LKEa0L9S
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-571bc0b66d7so152177b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114358; x=1795719158; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ou5XHXMFjy2tsHMgHvL3l0HkkEqCUhvCxjE9vqvsRzg=;
        b=LKEa0L9SZEUNuZImAWtwCLD6Nhs2QFjEnrp97zbACEJTzAZZZkWxBzeh/Dxa8v9RgB
         +X+GFNWHEgX1tq7+GmbArR1N0tTRDeuWe97F1tZ5mlO6ruSGiFp8njh4ImeALENxXnt2
         jVSeTRwaa8LcqSAsOP/Y9v3MUEL+BF9dUZy/vNEGWIn7JMgl+NtHwhyK2lQN/undOjbg
         PkXn//+QDPvGL6DMN0Qdof4A4tC+z8oKYk4+QwcmKWr2ggrDl0rtHS86/7ozDKlG9Y8k
         MUTQ1gXXnCu3iBLoHH8+KRE64Hjz6JeX5Ej+YwVVU9ahG2UYHk5S0dDuHOnhpX5gCGsh
         O1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114358; x=1795719158;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ou5XHXMFjy2tsHMgHvL3l0HkkEqCUhvCxjE9vqvsRzg=;
        b=frFzyoFns3QtJU3jn82lqXPTnIsXgGbyLOVIF9WRcUAa7kwsM8SoE6m73cjcq63c5+
         0RafXvZDCJUR6dHsoLBKJCuNv/9Z0krYHtQzDvqFAnCJWtwhSae4Zjnzqe89znoA0o/2
         +gZMBWkadfFIDm+vKTEttka4V1X+VXvgQU76N7ykwe//RieA/qnqFSK/p5ZYH1/mzJMO
         kkM8P5xtjVOehS2ZTZExwwhJ2KVqMdsvJjySVFd1yWyG9uABaqIopU7Kw1rNsf0QBF+2
         g5xBDGXjzNXcKOMwJwW0M6bC4UvS0D07a4wt550y4u7cHUnVH3wg5R9SoXQdNpGbWfYa
         vDxw==
X-Forwarded-Encrypted: i=1; AL+hErHTHAlkzOVxieJWagj6sLSB2HDNumd7I6HIWUK16vPTPz3s4bQisPqHC12yispj/SWU5lE3SgE=@lists.linux.dev
X-Gm-Message-State: APuU4Z9WxG1S4L4M9RO4fC9damgnoAGEQ7DHFW68LVGhsNtjlZPo6fte
	ZthTYgdWLYLXHUKy/J93CbZAtzrFVAt4hFlOjSip1AZQuvH68Xb8mhjDl6o4wWGu9ZKpMhViOjr
	dJKGFBpJxQLlchUHn4bnX6RQCag==
X-Received: from iljv13.prod.google.com ([2002:a05:6e02:13cd:b0:54e:ab26:add9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6711:b0:568:1cc2:96ec with SMTP id 5614622812f47-57a0c29f7dcmr862785b6e.46.1795114357559;
 Thu, 19 Nov 2026 10:52:37 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:04 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-23-coltonlewis@google.com>
Subject: [PATCH v10 22/33] KVM: arm64: Apply dynamic guest counter reservations
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reserve and release guest PMU counters dynamically during vCPU load and
put rather than statically at VM creation.

Add kvm_pmu_set_guest_counters() in arch/arm64/kvm/pmu-direct.c, called
from __kvm_pmu_load() and __kvm_pmu_put() with local interrupts
disabled. When the requested guest counter mask collides with active
host events in cpuc->used_mask (or when releasing counters after
squeezing a host event), invoke perf_pmu_resched_update() with
kvm_pmu_update_mask() to update per-CPU cpuc->cntr_mask between
scheduling host events out and back in; otherwise update cpuc->cntr_mask
directly. Warn once in armpmu_add() if a pinned host event fails counter
allocation while guest counters are reserved.

Skip releasing and re-reserving host counters across nested ERET and
nested exception transitions (IN_NESTED_ERET and IN_NESTED_EXCEPTION)
since the vCPU remains on the same physical CPU.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c  | 118 ++++++++++++++++++++++++++++++-----
 drivers/perf/arm_pmu.c       |   9 ++-
 include/linux/perf/arm_pmu.h |   1 +
 3 files changed, 113 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index ace3e8e781538..cc4ff00d6f41e 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -154,6 +154,70 @@ static u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
 
+/* Callback to update counter mask between perf scheduling */
+static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
+{
+	struct arm_pmu *arm_pmu = to_arm_pmu(pmu);
+	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
+	unsigned long *new_mask = data;
+
+	bitmap_copy(cpuc->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
+}
+
+/**
+ * kvm_pmu_set_guest_counters() - Handle dynamic counter reservations
+ * @cpu_pmu: struct arm_pmu to potentially modify
+ * @guest_mask: new guest mask for the pmu
+ *
+ * Check if guest counters will interfere with current host events and
+ * call into perf_pmu_resched_update if a reschedule is required.
+ */
+static void kvm_pmu_set_guest_counters(struct arm_pmu *cpu_pmu, u64 guest_mask)
+{
+	struct pmu_hw_events *cpuc;
+	DECLARE_BITMAP(guest_bitmap, ARMPMU_MAX_HWEVENTS);
+	DECLARE_BITMAP(new_mask, ARMPMU_MAX_HWEVENTS);
+	unsigned long flags;
+	bool need_resched = false;
+
+	if (!cpu_pmu)
+		return;
+
+	local_irq_save(flags);
+	cpuc = this_cpu_ptr(cpu_pmu->hw_events);
+
+	bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
+	bitmap_copy(new_mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
+
+	if (guest_mask) {
+		/* Subtract guest counters from available host mask */
+		bitmap_andnot(new_mask, new_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS);
+
+		/* Did we collide with an active host event? */
+		if (bitmap_intersects(cpuc->used_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS)) {
+			need_resched = true;
+			cpuc->host_squeezed = true;
+		}
+	} else {
+		/*
+		 * Restoring to full mask.
+		 * Only resched if we previously squeezed an event.
+		 */
+		if (cpuc->host_squeezed) {
+			need_resched = true;
+			cpuc->host_squeezed = false;
+		}
+	}
+
+	if (need_resched)
+		/* Collision: run full perf reschedule */
+		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
+	else
+		/* Host was never using guest counters anyway */
+		bitmap_copy(cpuc->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
+	local_irq_restore(flags);
+}
+
 static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
 {
 	lockdep_assert_preemption_disabled();
@@ -422,15 +486,7 @@ static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
 		kvm_pmu_apply_single_event_filter(vcpu, i);
 }
 
-/**
- * kvm_pmu_load() - Load untrapped PMU registers
- * @vcpu: Pointer to struct kvm_vcpu
- *
- * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
- * to only bits belonging to guest-reserved counters and leave
- * host-reserved counters alone in bitmask registers.
- */
-void kvm_pmu_load(struct kvm_vcpu *vcpu)
+static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 {
 	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long guest_counters;
@@ -446,13 +502,18 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	if (!kvm_pmu_is_partitioned(vcpu->kvm) || !vcpu->wants_to_run || !pmu)
 		return;
 
+	preempt_disable();
 	local_irq_save(flags);
 	if (!cpumask_test_cpu(smp_processor_id(), &pmu->supported_cpus)) {
 		local_irq_restore(flags);
+		preempt_enable();
 		return;
 	}
 
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	if (reserve_counters)
+		kvm_pmu_set_guest_counters(pmu, guest_counters);
+
 	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
@@ -505,17 +566,26 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	write_sysreg(~val & mask, pmintenclr_el1);
 
 	local_irq_restore(flags);
+	preempt_enable();
 }
 
 /**
- * kvm_pmu_put() - Put untrapped PMU registers
+ * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
  *
- * Put all untrapped PMU registers from the PCPU into the VCPU. Mask
+ * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
  * to only bits belonging to guest-reserved counters and leave
  * host-reserved counters alone in bitmask registers.
  */
-void kvm_pmu_put(struct kvm_vcpu *vcpu)
+void kvm_pmu_load(struct kvm_vcpu *vcpu)
+{
+	bool reserve = !vcpu_get_flag(vcpu, IN_NESTED_ERET) &&
+		       !vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION);
+
+	__kvm_pmu_load(vcpu, reserve);
+}
+
+static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 {
 	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long guest_counters;
@@ -533,12 +603,13 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	if (!kvm_pmu_is_partitioned(vcpu->kvm) || !vcpu->wants_to_run || !pmu)
 		return;
 
-	local_irq_save(flags);
+	preempt_disable();
 	if (!cpumask_test_cpu(smp_processor_id(), &pmu->supported_cpus)) {
-		local_irq_restore(flags);
+		preempt_enable();
 		return;
 	}
 
+	local_irq_save(flags);
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
 	mask = guest_counters;
 
@@ -595,5 +666,24 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
 	write_sysreg(val & mask, pmovsclr_el0);
 
+	if (release_counters)
+		kvm_pmu_set_guest_counters(pmu, 0);
 	local_irq_restore(flags);
+	preempt_enable();
+}
+
+/**
+ * kvm_pmu_put() - Put untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Put all untrapped PMU registers from the PCPU into the VCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_put(struct kvm_vcpu *vcpu)
+{
+	bool release = !vcpu_get_flag(vcpu, IN_NESTED_ERET) &&
+		       !vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION);
+
+	__kvm_pmu_put(vcpu, release);
 }
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index b1851d1c594b1..2b5bbbd801af8 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -349,8 +349,15 @@ armpmu_add(struct perf_event *event, int flags)
 
 	/* If we don't have a space for the counter then finish early. */
 	idx = armpmu->get_event_idx(hw_events, event);
-	if (idx < 0)
+	if (idx < 0) {
+		if (!bitmap_equal(hw_events->cntr_mask, armpmu->cntr_mask,
+				  ARMPMU_MAX_HWEVENTS)) {
+			hw_events->host_squeezed = true;
+			if (event->group_leader->attr.pinned)
+				pr_warn_once("perf: Pinned host event squeezed out by KVM guest PMU partition\n");
+		}
 		return idx;
+	}
 
 	/* The newly-allocated counter should be empty */
 	WARN_ON_ONCE(hw_events->events[idx]);
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index be1e345e99a77..45658273ffa86 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -76,6 +76,7 @@ struct pmu_hw_events {
 
 	/* Active events requesting branch records */
 	unsigned int		branch_users;
+	bool host_squeezed;
 };
 
 enum armpmu_attr_groups {
-- 
2.56.1.708.g77570a6a1d-goog

