Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018FF3C5855
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292570; cv=none; b=tLXrb4+fFU1wxUcURMGr0calTL9SwvawCz9XBJ39Z0MTmt5wSGXH7WI4QQp0lNm9lfCxFABumE+ycgHy7HaruWOBCxEAyurqM7EH6mEn0EIHhS92+sBha3ITdVIq9DzIITZ5tumhNviusIWn8H+wNQIy2/Aw/kwfi94jpXESwJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292570; c=relaxed/simple;
	bh=hQtQ+lw4+n6HuW7+A+bm2V5K6NpNQJho0t6eEcDukX8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t0niCVO9k+LYqKc6O52we2p0/NGpbMkEkQhblXgjiUOYZlT8kuPrWbjBYew/ZRot6IcwMRUIGe62XoHaWEN6w9/p8XKWRc9JBf538lVizTbGeo1ODY5SjEDkAmTpD0gRNsBJxGqfJ/Fvedq+AMX7Gw/sYUV57y+/PegfumDMmnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MhXgv01C; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MhXgv01C"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-69e89d83663so1382779eaf.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292564; x=1781897364; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U3mxqdo/FWgK9hnIRW4N9gL8LSmw3WCN8Nq0npc1NKo=;
        b=MhXgv01Cyp247GXFfAOzsrqsdqBNkdzZhh2fv4v3I7nQsG7RDCg2nhVRSO8ICaJi9m
         HJWr1dMae5fxpu8VN8lNLJ/VdvKjXhjEzDeEMY8i4TqX7e/vie0gCWz9c868sW+tN0dh
         ZsNJnIvmAm7YIWVhC7sjUlIhMPpy5i90EVIUEXgDLhxRTwQRk39ILCozP62Brx/kaIoL
         hKOOhCuzgcuWsYxkyfJ4VHvVUQpMOl2f6JKE3gG5MVqbRB0ylmaLZKSKAsvZwP18suGb
         NxCGLB/PF2IlDzR0tEji4rZNsXABiIV0ekqN2fLHk95t7tHfodIeyW9tSZN/CigWAoA0
         FRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292564; x=1781897364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3mxqdo/FWgK9hnIRW4N9gL8LSmw3WCN8Nq0npc1NKo=;
        b=Ojcn22kjdjbqPMX37rirx4eWuFVNlYR0Id4hKzNL8dhAFfY49FYT9axrZ3VJveAGnC
         I13hvX1vXplj6i42zEpRZiuqQw4z3JYZVyDpMFVSW2Y/nrk9yw0LaKJ+E7ZGoXCClFey
         II8UNvDO7ny9iYlzfXeuaQd91QlR4Qz2YSM+tG847bTkLREwcfik/2VM44kkovfK3ZdR
         EbejP5aMcbTnW1MwpP7VDuTNlplwaIqCoeyH9w5GZBkBcHf/AcHbwOEgn4DIYGVIGp+X
         diJjtPm3z7o/1YWCNt27GmgZacQIXYjvxA3RdyTxFNRumwsPi3tIWaXEpc3zlSJ2W70W
         WAPw==
X-Forwarded-Encrypted: i=1; AFNElJ+XOOzq85RLR7Gt4IuSXLBNm/+Eg4733TGmNa+THng61CfMHQMuGsMFBt8SPsmsxptRaJCPqrg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9b/Omwr+tefDJH0cy9p0IqsSD/DGA+u+pv4WOR0WF+Eh1NjN0
	qfTXFaoSG4Iczd8LRaQcfULGjhTQsXKlydtCfEIG4q93BbLw6nrq8Zj6n10yeLyIv1IkQkiFLEf
	mEbLupMxw1B8lBui/yyidCvU0CQ==
X-Received: from oaqy19-n2.prod.google.com ([2002:a05:6871:2d3:20b0:440:e30e:488f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:16a7:b0:69e:2bf1:764e with SMTP id 006d021491bc7-69eec98b283mr491295eaf.44.1781292563404;
 Fri, 12 Jun 2026 12:29:23 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:02 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-15-coltonlewis@google.com>
Subject: [PATCH 14/21] KVM: arm64: Apply dynamic guest counter reservations
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Apply dynamic guest counter reservations by checking if the requested
guest mask collides with any events the host has scheduled and calling
pmu_perf_resched_update() with a hook that updates the mask of
available counters in between schedule out and schedule in.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c  | 69 +++++++++++++++++++++++++++++++++++-
 include/linux/perf/arm_pmu.h |  1 +
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 49f1feb5d280c..044f011c9c84b 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -87,6 +87,73 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 		ARMV8_PMU_PMCR_N);
 }
 
+/* Callback to update counter mask between perf scheduling */
+static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
+{
+	struct arm_pmu *arm_pmu = to_arm_pmu(pmu);
+	unsigned long *new_mask = data;
+
+	bitmap_copy(arm_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
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
+	bool need_resched = false;
+
+	bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
+	bitmap_copy(new_mask, cpu_pmu->hw_cntr_impl, ARMPMU_MAX_HWEVENTS);
+
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
+		 * Restoring to hw_cntr_impl.
+		 * Only resched if we previously squeezed an event.
+		 */
+		if (cpuc->host_squeezed) {
+			need_resched = true;
+			cpuc->host_squeezed = false;
+		}
+	}
+
+	if (need_resched) {
+		/* Collision: run full perf reschedule */
+		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
+	} else {
+		/* Host was never using guest counters anyway */
+		bitmap_copy(cpu_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
+	}
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  * @pmu: Pointer to arm_pmu struct
@@ -209,6 +276,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 
 	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	kvm_pmu_set_guest_counters(pmu, guest_counters);
 	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
@@ -317,7 +385,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	/* Stop guest counters and disable interrupts in hardware. */
 	write_sysreg(mask, pmcntenclr_el0);
 	write_sysreg(mask, pmintenclr_el1);
-
 	kvm_pmu_set_guest_counters(pmu, 0);
 	preempt_enable();
 }
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 2e1e7a48e05ff..3139f80e877f7 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -75,6 +75,7 @@ struct pmu_hw_events {
 
 	/* Active events requesting branch records */
 	unsigned int		branch_users;
+	bool host_squeezed;
 };
 
 enum armpmu_attr_groups {
-- 
2.54.0.1136.gdb2ca164c4-goog

