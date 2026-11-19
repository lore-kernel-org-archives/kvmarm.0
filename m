Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114348;
	b=lCPzVV7AyE7OS9NGGr4fpQUm4Ek4VZL+7/Z07yHiNzfFwAu5GAZFJQ8vRf+IXfsfwzWw
	 9zGeOC56m+dZAr+zoBZlWECYd89fXtN5tx9/zE8RAH8SRMbyiVSBgRYeOKNrYb1zx8Xy0
	 5eoRsE857fL8mkBz2iutbgrjUhAuoOmEX2PPT0WM0FiVKrQNrhFSkLpykt7A/Q3moI0vF
	 ec+OpsdNFyiet69BqevKo13x5NhUmaxdrhjTuf+5glsu/K4HQFtVZXt0YMY07pua6k37l
	 GJ172DBElXIGiLjeusUVA4yVEdN4URVeWkm5ugBUpvGC3PhuwWjOXj55TRe3D/1oIcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114348;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=6347H7gggToJzZ+Ilw3z4KeuVm8ZnAfGsrXn9eqrzm0=;
	b=qMiJYwGuo0p/uPSOtNvtfWhGi86+7HlF0jDYuCLtZg2WqzqAlefSeHh7YKA88axm9ACH
	 bGbaWeyKAruJ6zRtaEwM1G8ZUubmEOd0q6hHhDPWemyp5WJkEYCC5H8ypHYbnw1Le3RoT
	 hcbqCmUIFjau9bsETdl4nfUqED5PuwsSkkS0Cg+/bKChWjKPqO03WwRxe9xFleAXeQeiR
	 I58ILzsMbWaJzPCG6iAeUUWSILpJRmF6W4NR8mb2NOuU+GuUbNn4ziJhPYkNs5mbS4E/F
	 Jg7OoaVHSyamxHqZLF1M94B2afHam7Ixa5//JOfutQv+G986RMt9xjJg5zNScbolbjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JyG6WJhy;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D2A60A6F7A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0D2A60A6F7A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JyG6WJhy
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab8b4887d4so145922b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114347; x=1795719147; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6347H7gggToJzZ+Ilw3z4KeuVm8ZnAfGsrXn9eqrzm0=;
        b=JyG6WJhyuz0NjKNvpEh/5Nq0Oig8GOIXgiI4W//TEjFEVazlmh7kMx/VJgVMBCk1JW
         OvhNU/D4UZsNfAiBtjoqZsPogF46M0/fo3dYlgVjYJJKjSBgFORq/2v+jjxiLRSHF3XA
         rcICV9TX5bAN8vwJ6gm6APhUilcSYnNhAj/j19/bQMto3K5RQzZaOdSSfptk3J3zxOSc
         BK3OTMvuFUOOpD47SF0wWPH/6ho0eMit0zkTe1+NCnRX8wmTmSfx5D//3u1+mn7P35Nh
         BC4hRi5M2wdlb53EhUZLClyYe7RapUQNDXwQhzAw3UqSHuf3d7FxYagSq6UNm8ke1sIe
         U60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114347; x=1795719147;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6347H7gggToJzZ+Ilw3z4KeuVm8ZnAfGsrXn9eqrzm0=;
        b=NERJNo0BRYfvBK49cF2qj+rvK9RA31LC2mN/J+aafvCEFR+MD5CY68IEw7+XMLOdHT
         3pPPMaQsdXnQluZUL5WDigqvx/HeIYceeGFwXj/jzYNomE7AoSaW1WozUt+5y2eMo5N2
         TbuN8EDLwqbeyg6zJmxNkodB37+U/UCukx9OfoYN71HoiU9L9dSNZKMKqBrzSiDnhZpK
         GPQ/dBd9al+gxRC2F0j0igll0zRMl6Jrv0FO7vzTU4X0esDNOE0KFM46y9dp5K3ZHl6m
         o3uSuj+8otv/ZBvax78nNMZe7F5zI6XqXZBi69XKDE7+o1N2oLVabjQaEy76S224oMKS
         4BTg==
X-Forwarded-Encrypted: i=1; AL+hErFOo3nwKFLfGquvRvO01FOhryN6tpR00PtUNK8W9bZbGH2/kB9GRqiaZ5hGP9cApE1MGMuTaQE=@lists.linux.dev
X-Gm-Message-State: APuU4Z/C1ECqDN7r2FLCXvJeAJF6h+8ARQYkmfRKCziQBzK9jJqvpKQR
	CI40yIvUFA7vQSrqXmFtILGs2SQjbyPAATGsPWt8SxJpaqr1+j3RhNWD1J57mv0BzyYDlBHvLG8
	t3BPj637pRnNOLxjHGQY7SGbG8A==
X-Received: from ilbeb8.prod.google.com ([2002:a05:6e02:4608:b0:544:45eb:2ab])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:660e:b0:4f4:b5ba:a241 with SMTP id 5614622812f47-57a0b048d65mr920500b6e.39.1795114346425;
 Thu, 19 Nov 2026 10:52:26 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:53 +0000
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
Message-ID: <20261119185215.632334-12-coltonlewis@google.com>
Subject: [PATCH v10 11/33] KVM: arm64: Add initial scaffolding for Partitioned PMU
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

Add the foundational helpers for Partitioned PMU support in
arch/arm64/kvm/pmu-direct.c:
- has_kvm_pmu_partition_support() to check VHE and PMUv3 availability.
- kvm_pmu_partition_enable() and kvm_pmu_is_partitioned() to track per-VM
  partitioning state via KVM_ARCH_FLAG_PARTITION_PMU_ENABLED.
- kvm_pmu_guest_counter_mask() to compute the bitmask of guest-reserved
  (0..HPMN-1 and PMCCNTR_EL0) hardware counters.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h  |  4 ++
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/pmu-direct.c       | 94 +++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h             | 20 +++++++
 5 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/pmu-direct.c

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index ecfede0c03486..71cf03ab58cbb 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -227,6 +227,10 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
+static inline u64 kvm_pmu_guest_counter_mask(void)
+{
+	return 0;
+}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4683281fcc5d4..89683a690828e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -96,6 +96,8 @@ enum {
 	KVM_ARCH_FLAG_EXIT_SEA,
 	/* No further ID register changes possible */
 	KVM_ARCH_FLAG_ID_REGS_FINAL,
+	/* Partitioned PMU Enabled */
+	KVM_ARCH_FLAG_PARTITION_PMU_ENABLED,
 };
 
 struct vcpu_reset_state {
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7aaeeb84e788e..79f1602299767 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -27,7 +27,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o \
 	 vgic-sys-reg-v5.o
 
-kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu-direct.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
new file mode 100644
index 0000000000000..b1c180ae79d9d
--- /dev/null
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Colton Lewis <coltonlewis@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
+
+#include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
+#include <asm/virt.h>
+
+/**
+ * has_host_pmu_partition_support() - Determine if partitioning is possible
+ *
+ * Partitioning is only supported in VHE mode with PMUv3
+ *
+ * Return: True if partitioning is possible, false otherwise
+ */
+static bool has_host_pmu_partition_support(void)
+{
+	return has_vhe() &&
+		system_supports_pmuv3();
+}
+
+/**
+ * has_kvm_pmu_partition_support() - If we can enable/disable partition
+ *
+ * Return: true if allowed, false otherwise.
+ */
+bool has_kvm_pmu_partition_support(void)
+{
+	return has_host_pmu_partition_support() &&
+		kvm_supports_guest_pmuv3();
+}
+
+/**
+ * kvm_pmu_partition_enable() - Enable/disable partition flag
+ * @kvm: Pointer to kvm struct
+ * @enable: Whether to enable or disable
+ *
+ * If we want to enable the partition, the guest is free to grab
+ * hardware by accessing PMU registers. Otherwise, the host maintains
+ * control.
+ */
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable)
+{
+	if (enable)
+		set_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+	else
+		clear_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+}
+
+/**
+ * kvm_pmu_is_partitioned() - Determine if KVM has a partitioned PMU
+ * @kvm: Pointer to kvm struct
+ *
+ * Return: True if the KVM PMU is partitioned, false otherwise
+ */
+bool kvm_pmu_is_partitioned(struct kvm *kvm)
+{
+	return kvm && test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+}
+
+static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
+{
+	if (vcpu && kvm_pmu_is_partitioned(vcpu->kvm)) {
+		u64 mask = ARMV8_PMU_CNT_MASK_C;
+		unsigned int guest_counters = vcpu->kvm->arch.nr_pmu_counters;
+
+		if (guest_counters > 0)
+			mask |= GENMASK_ULL(guest_counters - 1, 0);
+
+		return mask;
+	}
+
+	return 0;
+}
+
+/**
+ * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
+ *
+ * Compute the bitmask that selects the guest-reserved counters in the
+ * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the event counters
+ * in 0..HPMN-1 and the cycle counter (PMCCNTR_EL0).
+ *
+ * Return: Bitmask
+ */
+u64 kvm_pmu_guest_counter_mask(void)
+{
+	return kvm_vcpu_pmu_guest_counter_mask(kvm_get_running_vcpu());
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 8d51cf40182d6..e06255e46a4d8 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -95,6 +95,10 @@ void kvm_vcpu_pmu_resync_el0(void);
 #define kvm_vcpu_has_pmuv3_strict(vcpu)				\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3_STRICT))
 
+bool has_kvm_pmu_partition_support(void);
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);
+bool kvm_pmu_is_partitioned(struct kvm *kvm);
+u64 kvm_pmu_guest_counter_mask(void);
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -129,6 +133,10 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
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
@@ -233,6 +241,18 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
 static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
 
+static inline u64 kvm_pmu_guest_counter_mask(void)
+{
+	return 0;
+}
+
+static inline bool has_kvm_pmu_partition_support(void)
+{
+	return false;
+}
+
+static inline void kvm_pmu_partition_enable(struct kvm *kvm, bool enable) {}
+
 #endif
 
 #endif
-- 
2.56.1.708.g77570a6a1d-goog

