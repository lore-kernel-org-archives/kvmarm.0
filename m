Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC5B3FFAD8
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929522; cv=none; b=J1ufit91OqfciHme6/BINBZFWbCeFoSS5JhX43l+v0kDZ7Ip6GNLrdAJbMXT9QEYBK2e7Gen5uHyYD5EBTe2OF6Nkmv8aWxvJP2fa9KKJf05SSz5yoiGfLjxJ63V4kf8K7k4+6L/L690caw+V7LKqHmx2WJuo5mQoKf2gL7NP0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929522; c=relaxed/simple;
	bh=hs64zUVCH3HRa7wBllJ5k0yO+WABy4vlJLCxV5B6Fvw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ah7XwDMK6hWEaXTv6BKAPtmHtF9LfxlExhnzKfrmM6BEzXt/m6wyVptyC9fwdSX2JuAgbjyR3WtNyf/s/34b63106NQuRA4mwhj09f3nmBNOd3uho21GKsDxREyaC5HCCedOr7I465UDwNwr/vdABpD9JGF43NhLz3AJxtcv0DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pjSj9FmF; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pjSj9FmF"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-463a018f61bso3674643b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929517; x=1778534317; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=De6V46xDNQ/iwK8PV/vjnlYK6ThYLeVSMRlk50aLYFQ=;
        b=pjSj9FmFjLq0F2xsvpFnBEr4Ycbw0f4RnxmqdL9Xp6nk5rr1KGYfNY0WLdHbMSsnYl
         pbTXvqhWsUrJGNDWtxgLQW8eNZTR4vMfris6NTUX6x4Riy1lk4K1J85ndB56nWymZbFd
         rVFiBEQ4svd+BDbfAp/UkhHK3SvH4YccA/AvWvsHfS4CUPxxT0S65Mx0AABhLXLKK7Aq
         aL8Mqs4Cn+C5P53m40MNH52Ze5ij8Zo8YmHw+DoQsCITzpXXLfCXE2NdJR9Ytmx8ndMP
         QRedBUFevE4PP7u97vX6lv6/HaAbUJYsLBKAKrdnuzE+NcZ9ajscXHkbe+ssrT6HWlJn
         hXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929517; x=1778534317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=De6V46xDNQ/iwK8PV/vjnlYK6ThYLeVSMRlk50aLYFQ=;
        b=FyQ/2qu6y47Mwwxb/2oCrzOL/n0KXQdguNRWirEWZlNunMLd/sRDmFfA2D2WQIE3cL
         i9beRt//C+kVnsGPZdUJJkV7UjiomT65Ol0RcPPMoWt+0gP+8657IJkRiFgA3Dkqqm7S
         xmnrVURwYyTq98IGQmGXcJTPgfYSb9b19BzH4ccdtYzWqTV1mql0RQ0ibF/KoQOOsjtq
         R+axIag35y73GjQVwdG8hbQ2lL0/EXMMBQNKDRIZ5WLEU46d5LLYbUlvCu8MgFvQn0Lw
         dAgiLOE6Sr3b0pTjed2Y5/8EOCl/h3U3wVsw4gU5uOYT2oDb2VEiXjYlQDyVkcAh/ryO
         40bQ==
X-Forwarded-Encrypted: i=1; AFNElJ+X+CErlm3dLs89LGqaGsdlZs6/YApxG5S2b/0yFhyHpkbxDovKbJcJ5VDPggel+/hcupuIfPk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsMDUAhSvdR4//C6eo29gOg1pL1Y1K7A28oHt8qEO05cz8A3pX
	5kzXjUjqq6db9rPjZD7g0s6WqgWHKHSY+CJ6AXZ8Oi+nafoxFHLBJQTw2f2dk0EZskn15g586y4
	HNvaM+wVIzC+b5Q0vaIgXmQIlIw==
X-Received: from japu20.prod.google.com ([2002:a02:cb94:0:b0:5d6:6508:34a5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:f013:b0:67d:e85d:b5dc with SMTP id 006d021491bc7-6998dc3602cmr165172eaf.56.1777929516927;
 Mon, 04 May 2026 14:18:36 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:00 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-8-coltonlewis@google.com>
Subject: [PATCH v7 07/20] KVM: arm64: Set up FGT for Partitioned PMU
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

NOTE: This patch temporarily forces kvm_vcpu_pmu_is_partitioned() to
be false to prevent partial feature activation for easier debugging.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h |  4 +++
 arch/arm64/kvm/config.c          | 41 ++++++++++++++++++++++--
 arch/arm64/kvm/pmu-direct.c      | 54 ++++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h            | 30 ++++++++++++++++++
 4 files changed, 126 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 154503f054886..42d62aa48d0a6 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -231,6 +231,10 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
+static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	return false;
+}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d9f553cbf9dfd..3b5f028f5bf11 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1598,12 +1598,47 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
 
+static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR_EL2);
+
+	*vcpu_fgt(vcpu, HDFGRTR_EL2) |=
+		HDFGRTR_EL2_PMOVS
+		| HDFGRTR_EL2_PMCCFILTR_EL0
+		| HDFGRTR_EL2_PMEVTYPERn_EL0
+		| HDFGRTR_EL2_PMCEIDn_EL0
+		| HDFGRTR_EL2_PMMIR_EL1;
+}
+
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 {
 	__compute_fgt(vcpu, HDFGWTR_EL2);
 
 	if (is_hyp_ctxt(vcpu))
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
+
+	*vcpu_fgt(vcpu, HDFGWTR_EL2) |=
+		HDFGWTR_EL2_PMOVS
+		| HDFGWTR_EL2_PMCCFILTR_EL0
+		| HDFGWTR_EL2_PMEVTYPERn_EL0;
+}
+
+static void __compute_hdfgrtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR2_EL2);
+
+	*vcpu_fgt(vcpu, HDFGRTR2_EL2) &=
+		~(HDFGRTR2_EL2_nPMICFILTR_EL0
+		  | HDFGRTR2_EL2_nPMICNTR_EL0);
+}
+
+static void __compute_hdfgwtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGWTR2_EL2);
+
+	*vcpu_fgt(vcpu, HDFGWTR2_EL2) &=
+		~(HDFGWTR2_EL2_nPMICFILTR_EL0
+		  | HDFGWTR2_EL2_nPMICNTR_EL0);
 }
 
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
@@ -1614,7 +1649,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HFGRTR_EL2);
 	__compute_hfgwtr(vcpu);
 	__compute_fgt(vcpu, HFGITR_EL2);
-	__compute_fgt(vcpu, HDFGRTR_EL2);
+	__compute_hdfgrtr(vcpu);
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
 
@@ -1624,6 +1659,6 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HFGRTR2_EL2);
 	__compute_fgt(vcpu, HFGWTR2_EL2);
 	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	__compute_hdfgrtr2(vcpu);
+	__compute_hdfgwtr2(vcpu);
 }
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 74e40e4915416..2148bc46079c4 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
 
@@ -20,3 +22,55 @@ bool has_host_pmu_partition_support(void)
 	return has_vhe() &&
 		system_supports_pmuv3();
 }
+
+/**
+ * kvm_pmu_is_partitioned() - Determine if given PMU is partitioned
+ * @pmu: Pointer to arm_pmu struct
+ *
+ * Determine if given PMU is partitioned by looking at hpmn field. The
+ * PMU is partitioned if this field is less than the number of
+ * counters in the system.
+ *
+ * Return: True if the PMU is partitioned, false otherwise
+ */
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	if (!pmu)
+		return false;
+
+	return pmu->max_guest_counters >= 0 &&
+		pmu->max_guest_counters <= *host_data_ptr(nr_event_counters);
+}
+
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
+	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu) &&
+		false;
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
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 95f404cdcb2df..c3987e0c01775 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,6 +92,23 @@ void kvm_vcpu_pmu_resync_el0(void);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
+
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
@@ -131,6 +148,14 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
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
@@ -228,6 +253,11 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
 static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
 
+static inline bool kvm_pmu_is_partitioned(void *pmu)
+{
+	return false;
+}
+
 #endif
 
 #endif
-- 
2.54.0.545.g6539524ca2-goog

