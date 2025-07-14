Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFAD2376F8
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533984; cv=none; b=mYbV1gNnPHnPMNWjvxaxsLPw2seoMjD4G8DmsK1+hRbhIv5WkQnjIOZ8Ya0KZA+b5CYAmpuzN/+zXgAYh1+mOkshJKEeWxLsN2h1LXDD0YPuM+TWp1zuBkDldaYih6/JkQ+UNkmM1icxshFofubz9GMr8TAOmtXKi73jxm4qw9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533984; c=relaxed/simple;
	bh=CDjTj8cWCX5w5VetZUMx8OnPfitI8X2G7iAMJ7bz63E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lE0EZ1wHrdNhZej+evWV9KbG6LfMa/Yg0czLkDVKSd91fLXmSQ54XKb48fr227jqDJVIoQ1nzJEn0AWrk65kj1IsYD14U0/l7c+IyAwpRVClkkKHhvyg3a+rxGYtF14+C3iVlRGFe+KulqL4ZeRhpqEzC4kysiCWPzws5A7vSns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSyAmM3u; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSyAmM3u"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-869e9667f58so1104130639f.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533979; x=1753138779; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ruhxYZHp5lLB8yelcchT9klIB68L+DKTdiF6okoujCY=;
        b=dSyAmM3u6b84hVH7l8qk6xS5UBvduJQ+DL8nYEp8qFoCQ+vJNDbLiJzShsRhmkwTJg
         pPeO/Qzipuabandw1Dd8zIykhGpbk1JSmn0Cxdx5wFWTl0ao030lCaIs99G2ii2tevdZ
         CMfD44MHS70k+GtChUSEBazm7+obg7hevpkNxoM+GTv6ptZnWESpQ7kiDlu8NGjAvtva
         kI6AtRsE/c+eF5xwRVoJ3yovekxBjPWm/23ByCskUeFoTaJyqv19eHapCZK9+cJRKisy
         CcrSWgP0ChDg4tyPIlpqBfVZe1I9zlXrbTgmq4RhYoIyBDwkNHGNFMU8XxlNiQbxVWQ5
         p64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533979; x=1753138779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ruhxYZHp5lLB8yelcchT9klIB68L+DKTdiF6okoujCY=;
        b=JSQv6LEv+rj8AsXpV7PNe2f0kGv4+M7e4OU1nCpar863HTZs6qy4zRBrMIFAIICzfJ
         dduJEnBNUQ2wU/3tX0Abnk9Gb7/gjDo3BeZEJybGCm6Ym7upNExw7qimtnAQggvDhTMZ
         tpe6q4EQy46cEtq7HugSDihI4ZN8ECw1e69RvJ+8Oa85iFD/tJCTdlAirYN1PJFklA4h
         Z2RTj65wlW1/XmtVwb+SuOYCNginkRwQ8zHdAJ8JBVMGATcAHWLneHYPdtOZyg64/YF1
         QXLkALNsfJ1akI6DSuXS/iQflKah+/ZtrxZDttfN7Kr9puVlc8EMm6z5qVRfhU92pb5n
         nwhw==
X-Forwarded-Encrypted: i=1; AJvYcCWkNU7M/r4fL0Kl4lMchYNCBEJPqDXPqHQDb/doKCYruGt8VUBOTQWfBhiF12LB7jcs7kUve6c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzD/gve+kymiLRr0gxY3LV6b1/TCt4fMKc5xRK7/42BSNeqf+aP
	r6yYI5a4GkTRyvgDl0R1hbTevZJhxJFdXqwLGQTt7emoVeLd6291JZyUcryS770HBM51sT7fWD7
	Ph4ohF1Jg8J+IE+BLP+iXy/yO8g==
X-Google-Smtp-Source: AGHT+IHR2ZhdLDHriP6gMQRHpCn5DY2/9jV0IQOfUZpsLR5icoK2dSXpYkQ3aztL0DPxSOPRUiuKqvoDOj4y5jOVPw==
X-Received: from iov28.prod.google.com ([2002:a05:6602:751c:b0:875:b927:6c0a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:27c1:b0:86d:1218:de96 with SMTP id ca18e2360f4ac-8797886bf8fmr1673502139f.12.1752533979057;
 Mon, 14 Jul 2025 15:59:39 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:03 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-10-coltonlewis@google.com>
Subject: [PATCH v4 09/23] KVM: arm64: Set up FGT for Partitioned PMU
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

In order to gain the best performance benefit from partitioning the
PMU, utilize fine grain traps (FEAT_FGT and FEAT_FGT2) to avoid
trapping common PMU register accesses by the guest to remove that
overhead.

Untrapped:
* PMCR_EL0
* PMUSERENR_EL0
* PMSELR_EL0
* PMCCNTR_EL0
* PMCNTEN_EL0
* PMINTEN_EL1
* PMEVCNTRn_EL0

These are safe to untrap because writing MDCR_EL2.HPMN as this series
will do limits the effect of writes to any of these registers to the
partition of counters 0..HPMN-1. Reads from these registers will not
leak information from between guests as all these registers are
context swapped by a later patch in this series. Reads from these
registers also do not leak any information about the host's hardware
beyond what is promised by PMUv3.

Trapped:
* PMOVS_EL0
* PMEVTYPERn_EL0
* PMCCFILTR_EL0
* PMICNTR_EL0
* PMICFILTR_EL0
* PMCEIDn_EL0
* PMMIR_EL1

PMOVS remains trapped so KVM can track overflow IRQs that will need to
be injected into the guest.

PMICNTR and PMIFILTR remain trapped because KVM is not handling them
yet.

PMEVTYPERn remains trapped so KVM can limit which events guests can
count, such as disallowing counting at EL2. PMCCFILTR and PMCIFILTR
are special cases of the same.

PMCEIDn and PMMIR remain trapped because they can leak information
specific to the host hardware implementation.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_pmu.h  | 23 ++++++++++++++++++
 arch/arm64/kvm/pmu-direct.c       | 32 +++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 39 +++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f705eb4538c3..463dbf7f0821 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1347,6 +1347,7 @@ int __init populate_sysreg_config(const struct sys_reg_desc *sr,
 				  unsigned int idx);
 int __init populate_nv_trap_config(void);
 
+void kvm_calculate_pmu_traps(struct kvm_vcpu *vcpu);
 void kvm_calculate_traps(struct kvm_vcpu *vcpu);
 
 /* MMIO helpers */
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 6328e90952ba..73b7161e3f4e 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -94,6 +94,21 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+#if !defined(__KVM_NVHE_HYPERVISOR__)
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
+#else
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -133,6 +148,14 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 22e9b2f9e7b6..2eef77e8340d 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -40,6 +40,38 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
 		pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
 }
 
+/**
+ * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
+ * @vcpu: Pointer to kvm_vcpu struct
+ *
+ * Determine if given VCPU has a partitioned PMU by extracting that
+ * field and passing it to :c:func:`kvm_pmu_is_partitioned`
+ *
+ * Return: True if the VCPU PMU is partitioned, false otherwise
+ */
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu);
+}
+
+/**
+ * kvm_vcpu_pmu_use_fgt() - Determine if we can use FGT
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Determine if we can use FGT for direct access to registers. We can
+ * if capabilities permit the number of guest counters requested.
+ *
+ * Return: True if we can use FGT, false otherwise
+ */
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	u8 hpmn = vcpu->kvm->arch.nr_pmu_counters;
+
+	return kvm_vcpu_pmu_is_partitioned(vcpu) &&
+		cpus_have_final_cap(ARM64_HAS_FGT) &&
+		(hpmn != 0 || cpus_have_final_cap(ARM64_HAS_HPMN0));
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  * @pmu: Pointer to arm_pmu struct
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..b3f97980b11f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5212,6 +5212,43 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
 }
 
+
+/**
+ * kvm_calculate_pmu_traps() - Calculate fine grain traps for partitioned PMU
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate which registers still need to be trapped when the
+ * partitioned PMU is available, leaving others untrapped.
+ *
+ * Because this is only recalculated when the VCPU runs on a new
+ * thread, the trap bits should be set iff the partitioned PMU is
+ * supported whether or not it is currently enabled. If it is not
+ * enabled, this doesn't matter because every PMU access is trapped by
+ * MDCR_EL2.TPM anyway.
+ */
+void kvm_calculate_pmu_traps(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm_pmu_partition_supported() ||
+	    !cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
+
+	kvm->arch.fgt[HDFGRTR_GROUP] |=
+		HDFGRTR_EL2_PMOVS
+		| HDFGRTR_EL2_PMCCFILTR_EL0
+		| HDFGRTR_EL2_PMEVTYPERn_EL0
+		| HDFGRTR_EL2_PMCEIDn_EL0
+		| HDFGRTR_EL2_PMMIR_EL1;
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
+		return;
+
+	kvm->arch.fgt[HDFGRTR2_GROUP] |=
+		HDFGRTR2_EL2_nPMICFILTR_EL0
+		| HDFGRTR2_EL2_nPMICNTR_EL0;
+}
+
 void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -5232,6 +5269,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
 
+	kvm_calculate_pmu_traps(vcpu);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.50.0.727.gbf7dc18ff4-goog

