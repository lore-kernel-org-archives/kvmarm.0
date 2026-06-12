Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAA03A9632
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292563; cv=none; b=KNSXhsabFRcoDor7jCMc1odSPF2Y5OYZD9NSFSPjmktmg0ICc+cMldRooSfv/iGyfJrO/tLKwBrtg9gsCXxpz/2g5spuaNRwygUPMAXFAZfNt7AfhMGRorW9QWojdV7vZS1ZdBY1b1PvOuRBjJcukbEaSo9OT0HfJntvNaW62mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292563; c=relaxed/simple;
	bh=X7K3zcksnhegJLsbK2b6vaKQjSZ4FXPc60G7gGsYlBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RkAcv3EciPEPBZWCgaZPh6PQUcOoLvGHAKMK43MPyarJBSUnVYbFWXnlad4dT3Mu2UKEMkQu4m5T/A9OOCelyXeNxnkhEWYfvhHNXL3GpG/B242zHob9kD2cgHJPLEFcRvSuhSo5NBK7v4v4OrN0HVJrEUWW87Ly4tApLLGNHMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WD1nHTA1; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WD1nHTA1"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-4863a55600aso1245656b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292558; x=1781897358; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VFEHA4Hh+HbXwkTEMjUJrcBC6i0Zz455koc6wHXTBjw=;
        b=WD1nHTA1F2R7sVh24RAVGJ6VoGGQZtzbx+kEJlSk/bpo32fOAzJB8cAyzqyYaN8rbf
         MLAJXELkFgg/03C/oirDv8L9a5f5PgDp3Z+UfKMJnu0hE4btguBMDKYIQ9/ktSbh6+hk
         9ZGoWY62u+eg//5M71FBAfICM+1Mpj53uLDU0M6RU+gvrufrDvsk2RMzHaFG8yfYBPhx
         S1eGsaNfQVCvoY8GHDNq1KoOpqy3F2z6gpeHQIxH/1SuxBeyhAdtcsK/JUJRbYtr8txm
         cREnFxqe98FfGK6kIkBYpZuyFQIL8+8xhw97H6GRI4GRL/khbqtKVUYO2N7qlPWpMBeF
         5NFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292558; x=1781897358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFEHA4Hh+HbXwkTEMjUJrcBC6i0Zz455koc6wHXTBjw=;
        b=iJ9MBEjsBOyNOcD/V6NlfED29L+sukdKw/1EXTHjr9yomtZcFvRBSye8a8xkRVJFe6
         ucTlWAISNEIGmEo7ms5NB6vKw6Y7y4qtC4HogvR7buy61xv38Er+v7OG0u40vFERPL40
         6UyHcSe6chG/DNsW9RIPGcPKv00koDiivKpUlE8SQJ7P6PlBJN3raki/seVvrmCLRzKQ
         ItVY/W44m4Y38cL0T6hLVqtwLZDMI1KdnsrwONKgaIkuO/k/nKkwj/rukNumga/hQX2C
         jbyyMx8JHdZhwtDbT7DsBnSnUZ7GjFG6HTT08e/Yxa5MtA9tZNZwSf+TiM5jdCrpkCXg
         bt4g==
X-Forwarded-Encrypted: i=1; AFNElJ+yKlsKiZwqVDWw+arGND+3UyFzqkbwVlu9BGmB5Q2S8LKDfUz2pS657Bpthe8znaHWRCevwqE=@lists.linux.dev
X-Gm-Message-State: AOJu0YweLnUS9/fx3TE3MAQ762sDFB/FKf7LGXPW/kbfhmjjxW8pyL+A
	pugeCFIDI172DcsACACJCN97tcuTLwKMj8HonXKALS2DD02zdmwemmUvc0XYkdFfq7k5Kt2L8wy
	gHTCuMCf706tL5f3AqiVRR5ws6g==
X-Received: from iliy12.prod.google.com ([2002:a05:6e02:118c:b0:501:c810:dcf4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:8613:b0:480:4024:3bb with SMTP id 5614622812f47-48741ab6e19mr461706b6e.24.1781292557698;
 Fri, 12 Jun 2026 12:29:17 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:28:56 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-9-coltonlewis@google.com>
Subject: [PATCH 08/21] KVM: arm64: Set up FGT for Partitioned PMU
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
 arch/arm/include/asm/arm_pmuv3.h  |  4 +++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/config.c           | 41 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/pmu-direct.c       | 36 +++++++++++++++++++++++++++
 include/kvm/arm_pmu.h             | 12 +++++++++
 5 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index fddcd6e6f76b2..eedf58ea01b10 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -231,6 +231,10 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
+static inline bool pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	return false;
+}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0d7a620c69ee2..9c7e9b92dfbd3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* Partitioned PMU Enabled */
+#define KVM_ARCH_FLAG_PARTITION_PMU_ENABLED		12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0622162b089e5..f052ec8a00309 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1685,12 +1685,47 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
 
+static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR_EL2);
+
+	*vcpu_fgt(vcpu, HDFGRTR_EL2) |=
+		HDFGRTR_EL2_PMOVS |
+		HDFGRTR_EL2_PMCCFILTR_EL0 |
+		HDFGRTR_EL2_PMEVTYPERn_EL0 |
+		HDFGRTR_EL2_PMCEIDn_EL0 |
+		HDFGRTR_EL2_PMMIR_EL1;
+}
+
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 {
 	__compute_fgt(vcpu, HDFGWTR_EL2);
 
 	if (is_hyp_ctxt(vcpu))
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
+
+	*vcpu_fgt(vcpu, HDFGWTR_EL2) |=
+		HDFGWTR_EL2_PMOVS |
+		HDFGWTR_EL2_PMCCFILTR_EL0 |
+		HDFGWTR_EL2_PMEVTYPERn_EL0;
+}
+
+static void __compute_hdfgrtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR2_EL2);
+
+	*vcpu_fgt(vcpu, HDFGRTR2_EL2) &=
+		~(HDFGRTR2_EL2_nPMICFILTR_EL0 |
+		  HDFGRTR2_EL2_nPMICNTR_EL0);
+}
+
+static void __compute_hdfgwtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGWTR2_EL2);
+
+	*vcpu_fgt(vcpu, HDFGWTR2_EL2) &=
+		~(HDFGWTR2_EL2_nPMICFILTR_EL0 |
+		  HDFGWTR2_EL2_nPMICNTR_EL0);
 }
 
 static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
@@ -1727,7 +1762,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HFGRTR_EL2);
 	__compute_hfgwtr(vcpu);
 	__compute_fgt(vcpu, HFGITR_EL2);
-	__compute_fgt(vcpu, HDFGRTR_EL2);
+	__compute_hdfgrtr(vcpu);
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
 
@@ -1735,8 +1770,8 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 		__compute_fgt(vcpu, HFGRTR2_EL2);
 		__compute_fgt(vcpu, HFGWTR2_EL2);
 		__compute_fgt(vcpu, HFGITR2_EL2);
-		__compute_fgt(vcpu, HDFGRTR2_EL2);
-		__compute_fgt(vcpu, HDFGWTR2_EL2);
+		__compute_hdfgrtr2(vcpu);
+		__compute_hdfgwtr2(vcpu);
 	}
 
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 74e40e4915416..0135989667564 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
 
@@ -20,3 +22,37 @@ bool has_host_pmu_partition_support(void)
 	return has_vhe() &&
 		system_supports_pmuv3();
 }
+
+/**
+ * pmu_is_partitioned() - Determine if given PMU is partitioned
+ * @pmu: Pointer to arm_pmu struct
+ *
+ * Determine if given PMU is partitioned by looking at hpmn field. The
+ * PMU is partitioned if this field is less than the number of
+ * counters in the system.
+ *
+ * Return: True if the PMU is partitioned, false otherwise
+ */
+bool pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	if (!pmu)
+		return false;
+
+	return pmu->max_guest_counters >= 0 &&
+		pmu->max_guest_counters <= *host_data_ptr(nr_event_counters);
+}
+
+/**
+ * kvm_pmu_is_partitioned() - Determine if KVM has a partitioned PMU
+ * @kvm: Pointer to kvm struct
+ *
+ * Determine if KVM has a partitioned PMU by extracting that field and
+ * passing it to :c:func:`pmu_is_partitioned`
+ *
+ * Return: True if the KVM PMU is partitioned, false otherwise
+ */
+bool kvm_pmu_is_partitioned(struct kvm *kvm)
+{
+	return pmu_is_partitioned(kvm->arch.arm_pmu) &&
+		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f9a0823666949..36960b9e52da2 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -95,6 +95,9 @@ void kvm_vcpu_pmu_resync_el0(void);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+bool pmu_is_partitioned(struct arm_pmu *pmu);
+bool kvm_pmu_is_partitioned(struct kvm *kvm);
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -134,6 +137,10 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+static inline bool kvm_pmu_is_partitioned(struct kvm *kvm)
+{
+	return false;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
@@ -231,6 +238,11 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
 static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
 
+static inline bool pmu_is_partitioned(void *pmu)
+{
+	return false;
+}
+
 #endif
 
 #endif
-- 
2.54.0.1136.gdb2ca164c4-goog

