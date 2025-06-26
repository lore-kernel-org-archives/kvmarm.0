Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4592F3C19
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968373; cv=none; b=c2hrbInBrWybaGHwv8wCpD75mNiMmqj7EqvWHW7QZGmsJOfrat+UhVkgGuxqDgXixNjMSPOslTj82lo8t1zqIDT92c9pnvCd9Auz5TjFRnBqJvrEec9OaOOge9jtZ5FMO8mJd6RQ3DWYbN973QjPqQZ5k2f1eAycj188pzR9kXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968373; c=relaxed/simple;
	bh=r9ks6Gk9YbqV8jpdii7wfr1xMzIClUFml1wYw6+d3fA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PxcxchGTiNmOKC2i4ac+yQVDW82rupDzJlU5eNtU5PCTyoVLrwOSi0jtbJ7BVWjK84ESS3fNgrC4wTHZzXcVKu7gwsfYU6O7CxP9/jk2qRiEQ6HiZti/twvyyHsx47gf+0j0uEIbyHojqrDDamZmYc3ohB3zFaIMuViE48J+C7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNLrcy7e; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNLrcy7e"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-875b64cccd6so187933039f.3
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968369; x=1751573169; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRlId8j6LCdYrirtMZ0W4g5cwi8ZnWeFsohFg4IJ6SY=;
        b=jNLrcy7eWlX+zG5z9/cRnQvAM924jeQvLSpYyNwvR5LsysXbhtyqYQK2IBbtIrUyVE
         YgQUoJFJ4jU4LohJOmRAWsQjJgPrQ44XD6eohun8Qc//F/lv0ZdS0aqCaR+UJDmyHoz1
         nyb0Fe10NbBFL1gLuQrTSQKVd8EdNTlERxunmmnWWWMYZ96ZbiGogy2NFpADFxiKgN/w
         X3areIL/8QaQ17LCEYTbTmIWa1bP5HoE2R09lUStjVl5inlefklN8qxTGA6N60WrUwPs
         iwk0qJGa9DRp1pq2Vur0x871Xa7hccc7qocx865g8HgVjoH052zgoBsnp1KMOSuO0L1c
         zfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968369; x=1751573169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aRlId8j6LCdYrirtMZ0W4g5cwi8ZnWeFsohFg4IJ6SY=;
        b=HKIW0m9zlbzQ443aJNFQWCY4w91fUMiHHkwvRyGHZv9AiEO74CkaTCkv4eUNgcsC2f
         cIKBMH+LxnsIzrw0bLGeiV4W3R65Hfwxh5qOoUMMeqE25LrFAo7mkDwcQNgJHF2oaDxS
         ZHgsFcQDCDiMgsoY5G47j/V26D7JncIEKWhc2vmYsB02ZuzZiruFKFYYMiKHv4kGdEVc
         a9bOw5Y+GH4L5uNJPOik1YCjjuNPifoYyuuGtz5oyM6VoEdx3FpYu/OKNOtGTzDeyZxN
         zsM7eyMRQiwuOpBZZVCGM9DcdAMxPuAw5QstipkUhWVT7jrkMPAYQHPawuDgsqcr3Kft
         rWzw==
X-Forwarded-Encrypted: i=1; AJvYcCW0Y4067RKP42X4mBXAum/vvLvnnZH/hAx6ihg/KELRW6JC62qcjtyrxyB5ycXQbb3JLMBtzOw=@lists.linux.dev
X-Gm-Message-State: AOJu0YziHrQLISm5XOLhpAAK6LtP9wQJciAKtnFR1/rjTjRL/ukHWxIp
	sMRRMNCW/zFxA1JIfe+JLeZYVikk2RhFpGWZK0qODKocdc9Fayeke4FE0iEUS+vAZ4VzT73x9qD
	n4Zz+5cZOqAK2ckq1WNcf1OG4PA==
X-Google-Smtp-Source: AGHT+IFQs2Wwdg/fSES5A58gFSJxMknzSDLNOp4k85bx8hXhl1wyXlz+jCSjhcviMYqna778nTCFvIvjB3UkqOM8qQ==
X-Received: from ilbbm19.prod.google.com ([2002:a05:6e02:3313:b0:3df:3a5e:9ba8])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2589:b0:3df:460a:ec3c with SMTP id e9e14a558f8ab-3df4acc520fmr11509085ab.22.1750968369104;
 Thu, 26 Jun 2025 13:06:09 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:53 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-18-coltonlewis@google.com>
Subject: [PATCH v3 17/22] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Save and restore newly untrapped registers that can be directly
accessed by the guest when the PMU is partitioned.

* PMEVCNTRn_EL0
* PMCCNTR_EL0
* PMICNTR_EL0
* PMUSERENR_EL0
* PMSELR_EL0
* PMCR_EL0
* PMCNTEN_EL0
* PMINTEN_EL1

If the PMU is not partitioned or MDCR_EL2.TPM is set, all PMU
registers are trapped so return immediately.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |   4 ++
 arch/arm64/kvm/arm.c             |   2 +
 arch/arm64/kvm/pmu-part.c        | 101 +++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 35674879aae0..4f0741bf6779 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -98,6 +98,8 @@ void kvm_pmu_host_counters_disable(void);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+void kvm_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
@@ -169,6 +171,8 @@ static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e452aba1a3b2..7c007ee44ecb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -616,6 +616,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_pmu_load(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -658,6 +659,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	kvm_pmu_put(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index f954d2d29314..5eb53c6409e7 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -9,6 +9,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_pmu.h>
 
 /**
@@ -194,3 +195,103 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 
 	return hpmn;
 }
+
+/**
+ * kvm_pmu_load() - Load untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_load(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u8 i;
+	u64 val;
+
+	/*
+	 * If the PMU is not partitioned or we have MDCR_EL2_TPM,
+	 * every PMU access is trapped so don't bother with the swap.
+	 */
+	if (!kvm_pmu_is_partitioned(pmu) || (vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
+		return;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
+		write_pmevcntrn(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCNTR_EL0);
+	write_pmccntr(val);
+
+	val = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	write_pmuserenr(val);
+
+	val = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+	write_pmselr(val);
+
+	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	write_pmcr(val);
+
+	/*
+	 * Loading these registers is tricky because of
+	 * 1. Applying only the bits for guest counters (indicated by mask)
+	 * 2. Setting and clearing are different registers
+	 */
+	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	write_pmcntenset(val & mask);
+	write_pmcntenclr(~val & mask);
+
+	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	write_pmintenset(val & mask);
+	write_pmintenclr(~val & mask);
+}
+
+/**
+ * kvm_pmu_put() - Put untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Put all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_put(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u8 i;
+	u64 val;
+
+	/*
+	 * If the PMU is not partitioned or we have MDCR_EL2_TPM,
+	 * every PMU access is trapped so don't bother with the swap.
+	 */
+	if (!kvm_pmu_is_partitioned(pmu) || (vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
+		return;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = read_pmevcntrn(i);
+		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
+	}
+
+	val = read_pmccntr();
+	__vcpu_assign_sys_reg(vcpu, PMCCNTR_EL0, val);
+
+	val = read_pmuserenr();
+	__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0, val);
+
+	val = read_pmselr();
+	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
+
+	val = read_pmcr();
+	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
+
+	/* Mask these to only save the guest relevant bits. */
+	val = read_pmcntenset();
+	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+
+	val = read_pmintenset();
+	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
+}
-- 
2.50.0.727.gbf7dc18ff4-goog

