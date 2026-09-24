Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE014BD34E
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270999; cv=none; b=G0V4dLg5ff/4OE5+Y7fdYYrD2HnEqNOIyKeK4PFxXHCUnNvt3QWIqe7FlPfrWL9okBOaaZua9XmMMYL6Zm6trtIcCJeSH7Cu+d1fpy0x1YNbNFPgs4g7YTLqr6TClQfCIgUSnO8gGYFOcqBjr0HMgeKLQvmCQ9LtCagMoFjIpLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270999; c=relaxed/simple;
	bh=IN31WrfS1s8qFktZQMlnwARlViS4koxlqeS4XeefkuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JytQNnqsfm5LJYk+f2YlUW9rg86Zgtql9+3hLs0SrxER3kuqTAwqyZATvzcl58ku31WeyhbNwSVLNjnijaP/3FUxWwy6Zehgxa6C/3IOuhEqC7bvuM9YaGgbQ8QAVppEoong0DuZBnEyPnQ+LJrRc4ACaWo9t1ai8uQaPWfFBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=de9MfeGD; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="de9MfeGD"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a41f46d629so215462b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270994; x=1790875794; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ly1RhTg1DzFLFPcD4bZskzHIIlqyteQE9EzO1zay/Fc=;
        b=de9MfeGDKXclj5elezkSecqBLclqu1qDCCQGWCSYDZXI+Iiy+FkLa2qtIaHNPS2/5t
         vFAz7l5pAyMSrlJ0Wc/7o7R/565tV9UWo+cvBRcbEeUfrcM6yUVXQkcW/nDMfcBgVsMt
         ocMBTN6S0SnRke6+Cq7D96xekaI/ZcFpt2El60VQgR+C/S36GXeP00++U9i6vwvxYjlx
         irF+da9Y7dEwkP0i2n2rsWieZWyAUUXJQZcTheYPI2IsS5Uyz6HHLaZTR3ywdvJO+yn3
         CHOL9APR0uZTF9zZvfnJJDuyk27ghZP93AxNpWZJ1/zs4ZDTM46qMtJsC6sD1AE57Hun
         UtFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270994; x=1790875794;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ly1RhTg1DzFLFPcD4bZskzHIIlqyteQE9EzO1zay/Fc=;
        b=vjlBU60VSHPElk3/Xm6athxDePGX1x4NxICP3D2r/EYmTcx9OBUvX6dJj8Kio/nl+F
         BjsyHH62quvexnuDb261C7AmpnMIS7Uab2mItpw1kl5jcPh+UoAwSLR+FB9xmPD1W2wx
         uoXAMLGJ3njjjxLKGpzAe5PLUSPPeQrCNi9u30t525JZ67Eb3Sa7yqE8jviBLt7xcDsh
         pPz5UFVIjD8nm8vxjEPmHwIYusX1TEiQe7GdUoFPUbEnluDEpkbRhRDgD8V0kETCLxcX
         Ui5EQdLxil+/5Y3OlbHe/mIiNCyoUXb05WR5HC8uXLFnWOQnMgKK0N8D1bTP/v5aMi8x
         Mrpg==
X-Forwarded-Encrypted: i=1; AKwUvBw+C6llI76o6XRaGi92T7m42wk1gX05RNnWTlN4YqiIDKN39wR3TP+EyAIlekSvrMAiUfiL4bs=@lists.linux.dev
X-Gm-Message-State: AFuF++myBJu0NP1F0ALMHEbKBiWctbTz8+veX4pyBBq/CXK0H3sW8yop
	5BGxZJstLKDgNZCn4RhAabIcAGPDN5unbuE6lck/+zsi556dmkva456hYoDpVi0ZNuNPnQ4/zNm
	LMaMhxHvZ+sN/QzY5Fz2rdTZAGg==
X-Received: from iofj3.prod.google.com ([2002:a05:6602:7083:b0:9af:289c:476c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:80b1:b0:4b9:e65b:8c2b with SMTP id 5614622812f47-4d72931dd72mr3225441b6e.25.1790270994011;
 Thu, 24 Sep 2026 10:29:54 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:22 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-17-coltonlewis@google.com>
Subject: [PATCH v9 16/22] KVM: arm64: Apply dynamic guest counter reservations
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve and release guest PMU counters dynamically during vCPU load and
put rather than statically at VM creation.

Add kvm_pmu_set_guest_counters() in arch/arm64/kvm/pmu-direct.c, called
from kvm_pmu_load() and kvm_pmu_put(). When the requested guest counter
mask collides with active host events in cpuc->used_mask (or when
releasing counters after squeezing a host event), invoke
perf_pmu_resched_update() with kvm_pmu_update_mask() to update the
per-CPU cpuc->cntr_mask between scheduling host events out and back in;
otherwise update cpuc->cntr_mask directly with interrupts disabled.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c  | 77 ++++++++++++++++++++++++++++++++++++
 include/linux/perf/arm_pmu.h |  1 +
 2 files changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index a22c9258c2452..31d5afc44f36e 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -115,6 +115,77 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 		ARMV8_PMU_PMCR_N);
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
+	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
+	DECLARE_BITMAP(guest_bitmap, ARMPMU_MAX_HWEVENTS);
+	DECLARE_BITMAP(new_mask, ARMPMU_MAX_HWEVENTS);
+	unsigned long flags;
+	bool need_resched = false;
+
+	bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
+	bitmap_copy(new_mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
+
+	local_irq_save(flags);
+	if (guest_mask) {
+		/* Subtract guest counters from available host mask */
+		bitmap_andnot(new_mask, new_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS);
+
+		/* Did we collide with an active host event? */
+		if (bitmap_intersects(cpuc->used_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS)) {
+			int idx;
+
+			need_resched = true;
+			cpuc->host_squeezed = true;
+
+			/* Look for pinned events that are about to be preempted */
+			for_each_set_bit(idx, guest_bitmap, ARMPMU_MAX_HWEVENTS) {
+				if (test_bit(idx, cpuc->used_mask) && cpuc->events[idx] &&
+				    cpuc->events[idx]->attr.pinned) {
+					pr_warn_once("perf: Pinned host event squeezed out by KVM guest PMU partition\n");
+					break;
+				}
+			}
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
+	if (!need_resched)
+		/* Host was never using guest counters anyway */
+		bitmap_copy(cpuc->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
+	local_irq_restore(flags);
+
+	if (need_resched) {
+		/* Collision: run full perf reschedule */
+		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
+	}
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  *
@@ -255,6 +326,7 @@ static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_load(struct kvm_vcpu *vcpu)
 {
+	struct arm_pmu *pmu;
 	unsigned long guest_counters;
 	u64 mask;
 	u8 i;
@@ -269,7 +341,9 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	kvm_pmu_set_guest_counters(pmu, guest_counters);
 	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
@@ -329,6 +403,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_put(struct kvm_vcpu *vcpu)
 {
+	struct arm_pmu *pmu;
 	unsigned long guest_counters;
 	unsigned long flags;
 	u64 mask;
@@ -345,6 +420,7 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
 	mask = guest_counters;
 
@@ -395,5 +471,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	write_sysreg(val & mask, pmovsclr_el0);
 	local_irq_restore(flags);
 
+	kvm_pmu_set_guest_counters(pmu, 0);
 	preempt_enable();
 }
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
2.56.0.rc1.310.g51773c2048-goog

