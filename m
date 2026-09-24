Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5CC41D20C
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270995; cv=none; b=q5Jm6Y8HP818B63FZqIM9AAv53ZyzMptkY6SC0J7vvxjTpSf1kkpMgzMhGRnSNQAQRzyQ0Ya3lmIVRs2MwI2yj5QclswlExIOFmQZP31QFzA0Azb8zZQ5ZIiGdg5kHvQ6+QDhImqDFvdtQDEE+d/rQpJcN3PqU2XOvcVM+KyG6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270995; c=relaxed/simple;
	bh=J1S6FEEKd34DbJBXOFNqtKtIyY9vvgRodUCualT/iKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gfZ/HieXMGtj6T4DY//5i1MZkzgxgYtPAFwQthRGZtFC5CgoMF2ZRu3nNfQbgNUjkSOY0NA73ibR6fu56ULap2bGweYxa/keGzM6qQCMt+EDnc90kH660cNOmlfxBHCCBbimmw8qPexnf6X+2gYA0Q6cm7kbpmncGozwOwkPHVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YYTTHhFC; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YYTTHhFC"
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cc89e86e4dso173734b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270990; x=1790875790; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pic1jTngVzAQRpfdVenOHmbI8TlKBDo3bPHOvRzPxSI=;
        b=YYTTHhFCmwIZOvElIcAddRcaPPpE5/ibF4X+udgtt1nQvnYWJYS+ELAgIDbdrXiRAF
         /OdzGDBa/3sIz7WK/Gkyb+4RtMIJvVfXEREVhYneYOQ1N3M01F+a47NW7VvwVGs6KIsX
         hs1/QK/dfPfuOWdKeNpt2xj0Nm9M1IN0HET1TxacYOqNb7orh5CLEDS3MEN5G8VSz5q4
         UjUiCdutFPXM/PMzWEuo17zpLsJh+8T7s8jUv7qVysmlridI369/9zxIcuAozul+/zSf
         6JSAiSsNBfh966A0Cc2krw+W8DTcp+Y19EPwcv0jPPorM+PmQLDicsDmWv74qqfO4gh5
         u8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270990; x=1790875790;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pic1jTngVzAQRpfdVenOHmbI8TlKBDo3bPHOvRzPxSI=;
        b=HHhcvVF55ZnlQ2Nu/0JUm8rE6a2aeGYglaVxrhGRWjX63hMoOweXKtl49aJtNZC5rK
         CUZ1Izxf8UdTQeAI0RXrV+cdRzWW4ditXw9QGclm1TUpbDG41sJT2KkWxznEPAw3KIcG
         YaOZbmwKBRy+sSg8Iwv9+2kvM7o9WtZIlELZLQoyzyMamaO35Rk/4W1IFiLol5aMCyud
         fvJRX3jc22NIIETuzzg5ejR7YmhjSlRDAK8v7lHsNNR3eIJCtLdv54Q4UFyX/ysnM4aY
         qECFVXarIBNEu9l34x9ZOooRDdkun0uCH/hPK4jMYW6y5ZfnKxm+q/cl7dq0DVakc0HO
         3OvA==
X-Forwarded-Encrypted: i=1; AKwUvByvc4MZQb1G7HceIk6P9TnvRYoMWR19Pdwran5hHkzY2VAr4Bvat/bB+Vn+VBt99PQmWsP8NMI=@lists.linux.dev
X-Gm-Message-State: AFuF++kYQhrAE/qjW3dOOJDG9AcWWuQ10nffTRA/QOH1Zllowv1dj10H
	0s9MOD9pyHK8oYyjiQSwtv1SebSdZU30t4LYYWwZ/WvYGc8I+6pIjm/H9vOSQhSB1vJ2izoLqGQ
	cdaz9DpFC+rlXnvu7E0pgTWBApQ==
X-Received: from jabgl11.prod.google.com ([2002:a05:6638:6acb:b0:5f4:25c4:a67f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:238e:b0:4b2:5529:ed3c with SMTP id 5614622812f47-4d72e1663d0mr3044551b6e.7.1790270989852;
 Thu, 24 Sep 2026 10:29:49 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:19 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-14-coltonlewis@google.com>
Subject: [PATCH v9 13/22] KVM: arm64: Enforce PMU event filter at vcpu_load()
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

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 77 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c   |  1 +
 include/kvm/arm_pmu.h       |  3 ++
 3 files changed, 81 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 92eec0fa33867..a22c9258c2452 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -169,6 +169,82 @@ u64 kvm_pmu_guest_counter_mask(void)
 	return kvm_vcpu_pmu_guest_counter_mask(kvm_get_running_vcpu());
 }
 
+/**
+ * kvm_pmu_apply_single_event_filter() - Apply event filter to a single counter
+ * @vcpu: Pointer to vcpu struct
+ * @idx: Counter index
+ *
+ * Compute the filtered event value and write it directly to the hardware register.
+ */
+void kvm_pmu_apply_single_event_filter(struct kvm_vcpu *vcpu, u8 idx)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 guest_counters;
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	bool guest_include_el2;
+	u64 val;
+	u64 evsel;
+
+	if (!pmu || vcpu != kvm_get_running_vcpu())
+		return;
+
+	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	if (!test_bit(idx, (unsigned long *)&guest_counters))
+		return;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX) {
+		val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+		evsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	} else {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx);
+		evsel = val & kvm_pmu_event_mask(vcpu->kvm);
+	}
+
+	guest_include_el2 = (val & ARMV8_PMU_INCLUDE_EL2);
+	val &= ~evtyper_clr;
+
+	if (unlikely(is_hyp_ctxt(vcpu))) {
+		if (guest_include_el2)
+			val &= ~ARMV8_PMU_EXCLUDE_EL1;
+		else
+			val |= ARMV8_PMU_EXCLUDE_EL1;
+	}
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
+		val |= evtyper_set;
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		write_pmccfiltr(val);
+	else
+		write_pmevtypern(idx, val);
+}
+
+/**
+ * kvm_pmu_apply_event_filter() - Apply event filter to all guest counters
+ * @vcpu: Pointer to vcpu struct
+ *
+ * To uphold the guarantee of the KVM PMU event filter, we must ensure
+ * no counter counts if the event is filtered. Accomplish this by
+ * filtering all exception levels if the event is filtered.
+ */
+static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	unsigned long guest_counters;
+	u8 i;
+
+	if (!pmu)
+		return;
+
+	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS)
+		kvm_pmu_apply_single_event_filter(vcpu, i);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -194,6 +270,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ebcf52261df65..c4aa6a448b6ca 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1137,6 +1137,7 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
 			mask = kvm_pmu_evtyper_mask(vcpu->kvm);
 			__vcpu_assign_sys_reg(vcpu, reg, val & mask);
+			kvm_pmu_apply_single_event_filter(vcpu, idx);
 		} else {
 			kvm_pmu_set_counter_event_type(vcpu, val, idx);
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 2604a6a46d5f3..ddbbbb050b9de 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -104,6 +104,7 @@ u64 kvm_pmu_host_counter_mask(void);
 u64 kvm_pmu_guest_counter_mask(void);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
+void kvm_pmu_apply_single_event_filter(struct kvm_vcpu *vcpu, u8 idx);
 
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
@@ -263,6 +264,8 @@ static inline u64 kvm_pmu_guest_counter_mask(void)
 	return 0;
 }
 
+static inline void kvm_pmu_apply_single_event_filter(struct kvm_vcpu *vcpu, u8 idx) {}
+
 static inline bool has_kvm_pmu_partition_support(void)
 {
 	return false;
-- 
2.56.0.rc1.310.g51773c2048-goog

