Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DD4AD2C
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 06:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742366043; cv=none; b=sxE0iC+4cA0mgrY8psAgHwGPy7fQGBmQSsJJ3Ffka70bx5oz6RH65SCAfsfp4CZrVZhTMPujAsPa8XPp814rzL3qy7fmU394XzNwxn3tnkb/+qUlUlHfzU4uyt8J1o9hG0NZ4LVY9J1rjZQIq6AYKx7CZLF0Q/NPDajyOYI5qq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742366043; c=relaxed/simple;
	bh=ifHkpP2WZ8K5cknfakDsV4NApxD3iMErcfDu+TJ7124=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZO3Zh9appbqUL7SOlOD91scYRoNOquN6Bb6vhJitVdKFBq0c8QrI5KiI+84Hph8bWou9OHUQ0Nwip/F2KfFOfg782bLbZ0I14BdcRBtRPZh4j8Lq5RGXfMNgnwH/yynKevW4z8p4ZWjFR3xSVM0ZkBMKnkWUN6GS5cTlhhDyV34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=LzKAdbA9; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="LzKAdbA9"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2240b4de12bso32530995ad.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Mar 2025 23:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742366039; x=1742970839; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KD/jiMtiI3iCORUpOPLBFTItxVjNUTOinbbfiO0+DVo=;
        b=LzKAdbA9idi+ipvK8qKzEBgWaFUIFwn87DfL3hPRx4XNSxRiPFL+bgwf6OVWrF0cNz
         11ImCVrXfQVjD0II0SgZTukxt45hsnX1OlMh1X2sMGJtjRbb10dPwDdiGKt61kIv9nfe
         dnzyNRns7vMfg3ICNijQB2Sn3n1+f2eznEMAX0aCpxMYhmOLDYxNESWwKko9N/XehTnQ
         IDUWlOiSZP6mADjSHscCSz14RzHbX0xN/dUwCn9jMv91pTbnfTBuBQiz2oDPCSlKfFPC
         xh9TEPje7xYCzZt6qppWyWkw7muUO9ZPls+YO/5t+CSSCSWtIbTl7jcxnU3cnkFCHQUX
         Q5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742366039; x=1742970839;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KD/jiMtiI3iCORUpOPLBFTItxVjNUTOinbbfiO0+DVo=;
        b=TUXXnQJ2AvRuK4ZyE6+hgp8uBDDk4Gj+gKYysUMmTgZurjW2wEGcn1ffl/vu4njfLw
         X+AZMZppaV7KziSPPIPmTC3850WptF8rGXCQ5187KLlJ4h4gCY9SAbnLpybdvDWba+wM
         oCoC7pQgxKyLYmaHIIhhpPXM7fY9y+j0BEfolpUPifln2v9hkyojC8mO1xE6JtvTjp6P
         JvDWP6Coq3Zw73oknKfj13/wl9H03V9l/2f3GmiSEuKV2cvXsvbOOWcSjR7Br2kYm1bh
         zxDmiYoMDIV2weXoXKJrCnxp/e1uJ9eIWCxT0ITjqOXPhjWI6tsUYS7LBA9nyCgg3G8G
         fJQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzMGyKI/QHZcMqi9cEny/kzoT+ygJgEY0Yyw3OCHs0YK+L8YMZievvsY9J6f0Rm7gAs5f2trc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTHAjt4jOuPVA/G0JNklIJJ1C10qWt1zDQmVb3efgwwHEbmk9m
	3SS8CjA4JAo+1VcJQqLqRttEmCN7psmdvXd7PZrVS1Evt0JIjpTJtJu1PsVmgQM=
X-Gm-Gg: ASbGncu08C2ioX6mh6uztk6cD0dwxY9GJPIF5GqtJVVYAGjDsUyq6BGXQ9DW92ezdwI
	//MZwZVPS9SxMmai66j9OMk5EQAVxJZJfi/tbFyljlmgBk6YaNXEq6CjqS95tW5R3sWJ0EIqiWy
	0VnSKSJw9IPfw2DfHGNFlzxAx48oeDlRarFXFKWcVJ/q39FsaUZzKrKqY0pai2l3o+G+Zqo/Ikl
	HeYgtgm/f7Wndc8C4J2g8g1q8BIc/jjwK2JQeng+MxYCCazKhHnJj2jX1UbK/LNPO1KoxvPpJlx
	F/ZQdDtCzz/4yN3fSTRpJT8WLdCZSief75RT1nR4qCtHk822OnozUsv46Tw=
X-Google-Smtp-Source: AGHT+IG80M9b0KPlXdCWmTBF94JR4NzaXsvNcx1oAidN8nUCfjHsEgDfEN49bb6aV7L+mUyZss2bIA==
X-Received: by 2002:a17:902:f693:b0:224:7a4:b32 with SMTP id d9443c01a7336-22649928490mr15085405ad.20.1742366038266;
        Tue, 18 Mar 2025 23:33:58 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c68a7188sm106104035ad.73.2025.03.18.23.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 23:33:57 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 19 Mar 2025 15:33:46 +0900
Subject: [PATCH RFC] KVM: arm64: PMU: Use multiple host PMUs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250319-hybrid-v1-1-4d1ada10e705@daynix.com>
X-B4-Tracking: v=1; b=H4sIAEtl2mcC/z3MSw7CIBAG4KuQWTuGIlRla+IB3JouKAyWRR9Cb
 TRN7y5W4/J/5JshUQyUQLMZIk0hhb7LodgwsI3pboTB5QyCC8WFkNi86hgc8sIp7+WenBOQz0M
 kH54rdIXL+QTVt4x0f2R0/C1/U7NV3HGBQ2uxPnJzKI0/SmX1pD5ibRKh7ds2jJpN5baQGG0J1
 bK8ASGXXZW1AAAA
X-Change-ID: 20250224-hybrid-01d5ff47edd2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Problem
-------

arch/arm64/kvm/pmu-emul.c used to have a comment saying the follows:
> The observant among you will notice that the supported_cpus
> mask does not get updated for the default PMU even though it
> is quite possible the selected instance supports only a
> subset of cores in the system. This is intentional, and
> upholds the preexisting behavior on heterogeneous systems
> where vCPUs can be scheduled on any core but the guest
> counters could stop working.

Despite the reference manual says counters may not continuously
incrementing, Windows is not robust enough to handle stopped PMCCNTR_EL0
and crashes with a division-by-zero error and it also crashes when the
PMU is not present.

To avoid such a problem, the userspace should pin the vCPU threads to
pCPUs supported by one host PMU when initializing the vCPUs or specify
the host PMU to use with KVM_ARM_VCPU_PMU_V3_SET_PMU after the
initialization. However, QEMU/libvirt can pin vCPU threads only after the
vCPUs are initialized. It also limits the pCPUs the guest can use even
for VMMs that support proper pinning.

Solution
--------

Ideally, Windows should fix the division-by-zero error and QEMU/libvirt
should support pinning better, but neither of them are going to happen
anytime soon.

To allow running Windows on QEMU/libvirt or with heterogeneous cores,
combine all host PMUs necessary to cover the cores vCPUs can run and
keep PMCCNTR_EL0 working.

This approach is already adopted by the perf program. VMMs that support
pinning can pin vCPUs to pCPUs supported by different host PMUs to get
more cores and accurate measurements with the emulated PMU. Even VMMs
without pinning can get approximate metrics and run Windows without
crashes.

A system that has only one PMU or a VMM that supports pinning better
should have no visible changes.

Limitations
-----------

Below are limitations of the current implementation; they are not
fundamental and can be resolved by additional code.

Counter overflows with multiple host PMUs are not handled and left for
future work.

KVM still advertises the feature set of the host PMU captured when
initializing the first vCPU and that feature set may not be covered by
all the host PMUs in use.

The emulated PMU still stops counting if the affinity of the vCPU thread
expands after the perf events are created. Creating a perf event on
demand is complicated as perf events cannot be created while the
preemption is disabled. It is not a practical limitation as there is no
real reason to expand the vCPU thread affinity.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
This patch depends on:
https://lore.kernel.org/r/20250315-pmc-v5-0-ecee87dab216@daynix.com
("[PATCH v5 0/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs")
---
 arch/arm64/kvm/arm.c      |   2 -
 arch/arm64/kvm/pmu-emul.c | 351 ++++++++++++++++++++++++++--------------------
 include/kvm/arm_pmu.h     |   7 +-
 3 files changed, 205 insertions(+), 155 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index caa1357fa367..06292a4ccdc8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -449,8 +449,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
-	kvm_pmu_vcpu_init(vcpu);
-
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index aae5713d8993..631752f5327f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -22,16 +22,16 @@ DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
 static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
-static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
-static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
-static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
+static void kvm_pmu_create_pmc(struct kvm_vcpu *vcpu, u8 idx);
+static void kvm_pmu_release_pmc(struct kvm_vcpu *vcpu, u8 idx);
+static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u8 idx);
 
-static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
+static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc * const *pmc)
 {
-	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
+	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[(*pmc)->idx]);
 }
 
-static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
+static struct kvm_pmc **kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 {
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
@@ -80,30 +80,27 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
  */
-static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
+static bool kvm_pmc_is_64bit(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-
-	return (pmc->idx == ARMV8_PMU_CYCLE_IDX ||
+	return (idx == ARMV8_PMU_CYCLE_IDX ||
 		kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5));
 }
 
-static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
+static bool kvm_pmc_has_64bit_overflow(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 val = kvm_vcpu_read_pmcr(vcpu);
 
-	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
+	if (kvm_pmu_counter_is_hyp(vcpu, idx))
 		return __vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HLP;
 
-	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
-	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
+	return (idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
+	       (idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
 }
 
-static bool kvm_pmu_counter_can_chain(struct kvm_pmc *pmc)
+static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u8 idx)
 {
-	return (!(pmc->idx & 1) && (pmc->idx + 1) < ARMV8_PMU_CYCLE_IDX &&
-		!kvm_pmc_has_64bit_overflow(pmc));
+	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
+		!kvm_pmc_has_64bit_overflow(vcpu, idx));
 }
 
 static u32 counter_index_to_reg(u64 idx)
@@ -116,28 +113,30 @@ static u32 counter_index_to_evtreg(u64 idx)
 	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
 }
 
-static u64 kvm_pmc_read_evtreg(const struct kvm_pmc *pmc)
+static u64 kvm_pmc_read_evtreg(const struct kvm_vcpu *vcpu, u8 idx)
 {
-	return __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), counter_index_to_evtreg(pmc->idx));
+	return __vcpu_sys_reg(vcpu, counter_index_to_evtreg(idx));
 }
 
-static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
+static u64 kvm_pmu_get_pmc_value(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	struct kvm_pmc *pmc = *kvm_vcpu_idx_to_pmc(vcpu, idx);
 	u64 counter, reg, enabled, running;
+	unsigned int i;
 
-	reg = counter_index_to_reg(pmc->idx);
+	reg = counter_index_to_reg(idx);
 	counter = __vcpu_sys_reg(vcpu, reg);
 
 	/*
 	 * The real counter value is equal to the value of counter register plus
 	 * the value perf event counts.
 	 */
-	if (pmc->perf_event)
-		counter += perf_event_read_value(pmc->perf_event, &enabled,
-						 &running);
+	if (pmc)
+		for (i = 0; i < pmc->nr_perf_events; i++)
+			counter += perf_event_read_value(pmc->perf_events[i],
+							 &enabled, &running);
 
-	if (!kvm_pmc_is_64bit(pmc))
+	if (!kvm_pmc_is_64bit(vcpu, idx))
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -150,20 +149,18 @@ static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
  */
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	return kvm_pmu_get_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
+	return kvm_pmu_get_pmc_value(vcpu, select_idx);
 }
 
-static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
+static void kvm_pmu_set_pmc_value(struct kvm_vcpu *vcpu, u8 idx, u64 val, bool force)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 reg;
 
-	kvm_pmu_release_perf_event(pmc);
+	kvm_pmu_release_pmc(vcpu, idx);
 
-	reg = counter_index_to_reg(pmc->idx);
+	reg = counter_index_to_reg(idx);
 
-	if (vcpu_mode_is_32bit(vcpu) && pmc->idx != ARMV8_PMU_CYCLE_IDX &&
-	    !force) {
+	if (vcpu_mode_is_32bit(vcpu) && idx != ARMV8_PMU_CYCLE_IDX && !force) {
 		/*
 		 * Even with PMUv3p5, AArch32 cannot write to the top
 		 * 32bit of the counters. The only possible course of
@@ -176,8 +173,8 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
-	/* Recreate the perf event to reflect the updated sample_period */
-	kvm_pmu_create_perf_event(pmc);
+	/* Recreate the pmc to reflect the updated sample_period */
+	kvm_pmu_create_pmc(vcpu, idx);
 }
 
 /**
@@ -188,7 +185,7 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
  */
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx), val, false);
+	kvm_pmu_set_pmc_value(vcpu, select_idx, val, false);
 }
 
 /**
@@ -199,21 +196,28 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
  */
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
+	kvm_pmu_release_pmc(vcpu, select_idx);
 	__vcpu_sys_reg(vcpu, counter_index_to_reg(select_idx)) = val;
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
 /**
- * kvm_pmu_release_perf_event - remove the perf event
+ * kvm_pmu_release_pmc - remove the pmc
  * @pmc: The PMU counter pointer
  */
-static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
+static void kvm_pmu_release_pmc(struct kvm_vcpu *vcpu, u8 idx)
 {
-	if (pmc->perf_event) {
-		perf_event_disable(pmc->perf_event);
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
+	struct kvm_pmc **pmc = kvm_vcpu_idx_to_pmc(vcpu, idx);
+	unsigned int i;
+
+	if (*pmc) {
+		for (i = 0; i < (*pmc)->nr_perf_events; i++) {
+			perf_event_disable((*pmc)->perf_events[i]);
+			perf_event_release_kernel((*pmc)->perf_events[i]);
+		}
+
+		kfree(*pmc);
+		*pmc = NULL;
 	}
 }
 
@@ -223,35 +227,17 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
  *
  * If this counter has been configured to monitor some event, release it here.
  */
-static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
+static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 reg, val;
 
-	if (!pmc->perf_event)
-		return;
-
-	val = kvm_pmu_get_pmc_value(pmc);
+	val = kvm_pmu_get_pmc_value(vcpu, idx);
 
-	reg = counter_index_to_reg(pmc->idx);
+	reg = counter_index_to_reg(idx);
 
 	__vcpu_sys_reg(vcpu, reg) = val;
 
-	kvm_pmu_release_perf_event(pmc);
-}
-
-/**
- * kvm_pmu_vcpu_init - assign pmu counter idx for cpu
- * @vcpu: The vcpu pointer
- *
- */
-void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	int i;
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-
-	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
-		pmu->pmc[i].idx = i;
+	kvm_pmu_release_pmc(vcpu, idx);
 }
 
 /**
@@ -264,7 +250,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	int i;
 
 	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
-		kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, i));
+		kvm_pmu_release_pmc(vcpu, i);
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
@@ -321,22 +307,31 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
 }
 
-static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
+static void kvm_pmc_enable_perf_event(struct kvm_vcpu *vcpu, u8 idx)
 {
-	if (!pmc->perf_event) {
-		kvm_pmu_create_perf_event(pmc);
+	struct kvm_pmc *pmc = *kvm_vcpu_idx_to_pmc(vcpu, idx);
+	unsigned int i;
+
+	if (!pmc) {
+		kvm_pmu_create_pmc(vcpu, idx);
 		return;
 	}
 
-	perf_event_enable(pmc->perf_event);
-	if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
-		kvm_debug("fail to enable perf event\n");
+	for (i = 0; i < pmc->nr_perf_events; i++) {
+		perf_event_enable(pmc->perf_events[i]);
+		if (pmc->perf_events[i]->state != PERF_EVENT_STATE_ACTIVE)
+			kvm_debug("fail to enable perf event\n");
+	}
 }
 
-static void kvm_pmc_disable_perf_event(struct kvm_pmc *pmc)
+static void kvm_pmc_disable_perf_event(struct kvm_vcpu *vcpu, u8 idx)
 {
-	if (pmc->perf_event)
-		perf_event_disable(pmc->perf_event);
+	struct kvm_pmc *pmc = *kvm_vcpu_idx_to_pmc(vcpu, idx);
+	unsigned int i;
+
+	if (pmc)
+		for (i = 0; i < pmc->nr_perf_events; i++)
+			perf_event_disable(pmc->perf_events[i]);
 }
 
 void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
@@ -347,15 +342,13 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		return;
 
 	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
-		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
-
 		if (!(val & BIT(i)))
 			continue;
 
-		if (kvm_pmu_counter_is_enabled(pmc))
-			kvm_pmc_enable_perf_event(pmc);
+		if (kvm_pmu_counter_is_enabled(vcpu, i))
+			kvm_pmc_enable_perf_event(vcpu, i);
 		else
-			kvm_pmc_disable_perf_event(pmc);
+			kvm_pmc_disable_perf_event(vcpu, i);
 	}
 
 	kvm_vcpu_pmu_restore_guest(vcpu);
@@ -486,7 +479,6 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 	mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 
 	for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
-		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
 		u64 type, reg;
 
 		/* Filter on event type */
@@ -497,29 +489,30 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 
 		/* Increment this counter */
 		reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
-		if (!kvm_pmc_is_64bit(pmc))
+		if (!kvm_pmc_is_64bit(vcpu, i))
 			reg = lower_32_bits(reg);
 		__vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
 
 		/* No overflow? move on */
-		if (kvm_pmc_has_64bit_overflow(pmc) ? reg : lower_32_bits(reg))
+		if (kvm_pmc_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
 			continue;
 
 		/* Mark overflow */
 		__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 
-		if (kvm_pmu_counter_can_chain(pmc))
+		if (kvm_pmu_counter_can_chain(vcpu, i))
 			kvm_pmu_counter_increment(vcpu, BIT(i + 1),
 						  ARMV8_PMUV3_PERFCTR_CHAIN);
 	}
 }
 
 /* Compute the sample period for a given counter value */
-static u64 compute_period(struct kvm_pmc *pmc, u64 counter)
+static u64 compute_period(struct kvm_pmc **pmc, u64 counter)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 val;
 
-	if (kvm_pmc_is_64bit(pmc) && kvm_pmc_has_64bit_overflow(pmc))
+	if (kvm_pmc_is_64bit(vcpu, (*pmc)->idx) && kvm_pmc_has_64bit_overflow(vcpu, (*pmc)->idx))
 		val = (-counter) & GENMASK(63, 0);
 	else
 		val = (-counter) & GENMASK(31, 0);
@@ -534,10 +527,10 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 				  struct perf_sample_data *data,
 				  struct pt_regs *regs)
 {
-	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	struct kvm_pmc **pmc = perf_event->overflow_handler_context;
 	struct arm_pmu *cpu_pmu = to_arm_pmu(perf_event->pmu);
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	int idx = pmc->idx;
+	int idx = (*pmc)->idx;
 	u64 period;
 
 	cpu_pmu->pmu.stop(perf_event, PERF_EF_UPDATE);
@@ -554,7 +547,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
-	if (kvm_pmu_counter_can_chain(pmc))
+	if (kvm_pmu_counter_can_chain(vcpu, idx))
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
@@ -613,95 +606,74 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 				     ~BIT(ARMV8_PMU_CYCLE_IDX);
 
 		for_each_set_bit(i, &mask, 32)
-			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
+			kvm_pmu_set_pmc_value(vcpu, i, 0, true);
 	}
 }
 
-static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
+static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	unsigned int mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
 
-	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx)))
+	if (!(__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(idx)))
 		return false;
 
-	if (kvm_pmu_counter_is_hyp(vcpu, pmc->idx))
+	if (kvm_pmu_counter_is_hyp(vcpu, idx))
 		return mdcr & MDCR_EL2_HPME;
 
 	return kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E;
 }
 
-static bool kvm_pmc_counts_at_el0(struct kvm_pmc *pmc)
+static bool kvm_pmc_counts_at_el0(struct kvm_vcpu *vcpu, u8 idx)
 {
-	u64 evtreg = kvm_pmc_read_evtreg(pmc);
+	u64 evtreg = kvm_pmc_read_evtreg(vcpu, idx);
 	bool nsu = evtreg & ARMV8_PMU_EXCLUDE_NS_EL0;
 	bool u = evtreg & ARMV8_PMU_EXCLUDE_EL0;
 
 	return u == nsu;
 }
 
-static bool kvm_pmc_counts_at_el1(struct kvm_pmc *pmc)
+static bool kvm_pmc_counts_at_el1(struct kvm_vcpu *vcpu, u8 idx)
 {
-	u64 evtreg = kvm_pmc_read_evtreg(pmc);
+	u64 evtreg = kvm_pmc_read_evtreg(vcpu, idx);
 	bool nsk = evtreg & ARMV8_PMU_EXCLUDE_NS_EL1;
 	bool p = evtreg & ARMV8_PMU_EXCLUDE_EL1;
 
 	return p == nsk;
 }
 
-static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
+static bool kvm_pmc_counts_at_el2(struct kvm_vcpu *vcpu, u8 idx)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	u64 mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
 
-	if (!kvm_pmu_counter_is_hyp(vcpu, pmc->idx) && (mdcr & MDCR_EL2_HPMD))
+	if (!kvm_pmu_counter_is_hyp(vcpu, idx) && (mdcr & MDCR_EL2_HPMD))
 		return false;
 
-	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
+	return kvm_pmc_read_evtreg(vcpu, idx) & ARMV8_PMU_INCLUDE_EL2;
 }
 
-/**
- * kvm_pmu_create_perf_event - create a perf event for a counter
- * @pmc: Counter context
- */
-static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
+static struct kvm_pmc *kvm_pmu_alloc_pmc(u8 idx, unsigned int capacity)
 {
-	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
-	struct perf_event *event;
-	struct perf_event_attr attr;
-	u64 eventsel, evtreg;
+	struct kvm_pmc *pmc = kzalloc(struct_size(pmc, perf_events, capacity), GFP_KERNEL_ACCOUNT);
 
-	evtreg = kvm_pmc_read_evtreg(pmc);
-
-	kvm_pmu_stop_counter(pmc);
-	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
-		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
-	else
-		eventsel = evtreg & kvm_pmu_event_mask(vcpu->kvm);
+	if (pmc)
+		pmc->idx = idx;
 
-	/*
-	 * Neither SW increment nor chained events need to be backed
-	 * by a perf event.
-	 */
-	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR ||
-	    eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
-		return;
+	return pmc;
+}
 
-	/*
-	 * If we have a filter in place and that the event isn't allowed, do
-	 * not install a perf event either.
-	 */
-	if (vcpu->kvm->arch.pmu_filter &&
-	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
-		return;
+static void kvm_pmu_create_perf_event(struct kvm_pmc **pmc,
+				      struct arm_pmu *arm_pmu, u64 eventsel)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	struct perf_event *event;
+	struct perf_event_attr attr;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
-	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
-	attr.exclude_user = !kvm_pmc_counts_at_el0(pmc);
+	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, (*pmc)->idx);
+	attr.exclude_user = !kvm_pmc_counts_at_el0(vcpu, (*pmc)->idx);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
@@ -711,19 +683,19 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * guest's EL2 filter.
 	 */
 	if (unlikely(is_hyp_ctxt(vcpu)))
-		attr.exclude_kernel = !kvm_pmc_counts_at_el2(pmc);
+		attr.exclude_kernel = !kvm_pmc_counts_at_el2(vcpu, (*pmc)->idx);
 	else
-		attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
+		attr.exclude_kernel = !kvm_pmc_counts_at_el1(vcpu, (*pmc)->idx);
 
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
 	 * code, carefully dealing with the initial sample period
 	 * which also depends on the overflow.
 	 */
-	if (kvm_pmc_is_64bit(pmc))
+	if (kvm_pmc_is_64bit(vcpu, (*pmc)->idx))
 		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
 
-	attr.sample_period = compute_period(pmc, kvm_pmu_get_pmc_value(pmc));
+	attr.sample_period = compute_period(pmc, kvm_pmu_get_pmc_value(vcpu, (*pmc)->idx));
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
@@ -731,10 +703,93 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	if (IS_ERR(event)) {
 		pr_err_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
+	}
+
+	(*pmc)->perf_events[(*pmc)->nr_perf_events] = event;
+	(*pmc)->nr_perf_events++;
+}
+
+/**
+ * kvm_pmu_create_pmc - create a pmc
+ * @pmc: Counter context
+ */
+static void kvm_pmu_create_pmc(struct kvm_vcpu *vcpu, u8 idx)
+{
+	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
+	struct arm_pmu_entry *entry;
+	struct kvm_pmc **pmc = kvm_vcpu_idx_to_pmc(vcpu, idx);
+	u64 eventsel, evtreg;
+	cpumask_t cpus;
+	size_t n;
+
+
+	evtreg = kvm_pmc_read_evtreg(vcpu, idx);
+
+	kvm_pmu_stop_counter(vcpu, idx);
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+	else
+		eventsel = evtreg & kvm_pmu_event_mask(vcpu->kvm);
+
+	/*
+	 * Neither SW increment nor chained events need to be backed
+	 * by a perf event.
+	 */
+	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR ||
+	    eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
 		return;
+
+	/*
+	 * If we have a filter in place and that the event isn't allowed, do
+	 * not install a perf event either.
+	 */
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
+		return;
+
+	if (cpumask_subset(current->cpus_ptr, &arm_pmu->supported_cpus)) {
+		*pmc = kvm_pmu_alloc_pmc(idx, 1);
+		if (!*pmc)
+			goto err;
+
+		kvm_pmu_create_perf_event(pmc, arm_pmu, eventsel);
+	} else {
+		guard(mutex)(&arm_pmus_lock);
+
+		n = 0;
+		cpumask_clear(&cpus);
+		list_for_each_entry(entry, &arm_pmus, entry) {
+			arm_pmu = entry->arm_pmu;
+
+			if (!cpumask_intersects(current->cpus_ptr, &arm_pmu->supported_cpus) ||
+			    cpumask_intersects(&cpus, &arm_pmu->supported_cpus))
+				continue;
+
+			cpumask_or(&cpus, &cpus, &arm_pmu->supported_cpus);
+			n++;
+		}
+
+		*pmc = kvm_pmu_alloc_pmc(idx, n);
+		if (!*pmc)
+			goto err;
+
+		cpumask_clear(&cpus);
+		list_for_each_entry(entry, &arm_pmus, entry) {
+			arm_pmu = entry->arm_pmu;
+
+			if (!cpumask_intersects(current->cpus_ptr, &arm_pmu->supported_cpus) ||
+			    cpumask_intersects(&cpus, &arm_pmu->supported_cpus))
+				continue;
+
+			cpumask_or(&cpus, &cpus, &arm_pmu->supported_cpus);
+			kvm_pmu_create_perf_event(pmc, arm_pmu, eventsel);
+		}
 	}
 
-	pmc->perf_event = event;
+	return;
+
+err:
+	pr_err_once("kvm: pmc allocation failed\n");
 }
 
 /**
@@ -750,13 +805,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx)
 {
-	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
 	u64 reg;
 
-	reg = counter_index_to_evtreg(pmc->idx);
+	reg = counter_index_to_evtreg(select_idx);
 	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
 
-	kvm_pmu_create_perf_event(pmc);
+	kvm_pmu_create_pmc(vcpu, select_idx);
 }
 
 void kvm_host_pmu_init(struct arm_pmu *pmu)
@@ -994,7 +1048,8 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  * subset of cores in the system. This is intentional, and
  * upholds the preexisting behavior on heterogeneous systems
  * where vCPUs can be scheduled on any core but the guest
- * counters could stop working.
+ * may see features not supported on some cores being advertised
+ * via PMCR_EL0, PMCEID0_EL0, and PMCEID1_EL0.
  */
 int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
@@ -1208,17 +1263,15 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 
 	mask = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for_each_set_bit(i, &mask, 32) {
-		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
-
 		/*
 		 * We only need to reconfigure events where the filter is
 		 * different at EL1 vs. EL2, as we're multiplexing the true EL1
 		 * event filter bit for nested.
 		 */
-		if (kvm_pmc_counts_at_el1(pmc) == kvm_pmc_counts_at_el2(pmc))
+		if (kvm_pmc_counts_at_el1(vcpu, i) == kvm_pmc_counts_at_el2(vcpu, i))
 			continue;
 
-		kvm_pmu_create_perf_event(pmc);
+		kvm_pmu_create_pmc(vcpu, i);
 		reprogrammed = true;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index d6ad13925978..79ab5ff203eb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -15,7 +15,8 @@
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
-	struct perf_event *perf_event;
+	unsigned int nr_perf_events;
+	struct perf_event *perf_events[] __counted_by(nr_perf_events);
 };
 
 struct kvm_pmu_events {
@@ -26,7 +27,7 @@ struct kvm_pmu_events {
 struct kvm_pmu {
 	struct irq_work overflow_work;
 	struct kvm_pmu_events events;
-	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
+	struct kvm_pmc *pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
 	int irq_num;
 	bool created;
 	bool irq_level;
@@ -52,7 +53,6 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
-void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
@@ -124,7 +124,6 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
-static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}

---
base-commit: 8098cf067a7aae92a4f293df03964bf8474faca1
change-id: 20250224-hybrid-01d5ff47edd2
prerequisite-change-id: 20250302-pmc-b90a86af945c:v5
prerequisite-patch-id: 3ad91b60da556a3e1d599882a12288f397c6b4e7
prerequisite-patch-id: 1be00eb7a63e8546dbb159beae3ca464e29e3e96
prerequisite-patch-id: 63d32a008656195057c7bd215423656b1e206d3c
prerequisite-patch-id: 8b7aab52cb84c781012ab8adf468bbb5c4ccfd7d
prerequisite-patch-id: a9aa801b5624bcd5ebd80ec9ab5d727ddf6b1242
prerequisite-patch-id: e65d864dbb379dc01882e74e2608b1fad51b50e7
prerequisite-patch-id: 4fecf0e86792a8e5101a173bfa6f3c9bf7473e41
prerequisite-patch-id: 4d6787214a8d3e13eda61cf8f43fdf3e4e6f2b33
prerequisite-patch-id: c2df211b631f9c0d56ec778446ab4b37088c137a
prerequisite-patch-id: 9d9092dcb5669787179c98b4d026ca6fcddf43b9
prerequisite-patch-id: 817bded5bedc86b2659c9446cde2450b85d46624
prerequisite-patch-id: 1c54041ec06ed3cbb7b7d5b1eda64af615f1a94d
prerequisite-patch-id: 9c528724ae0e1291087992b1cef2448584c03f1b
prerequisite-patch-id: 02fffd6814bd121c8ce0af75b7bc32b0dd8260d2
prerequisite-patch-id: 7a86d80c7918f0ba88a509dce30831adff7562a7
prerequisite-patch-id: eafdea1a57ccd213bb7dbc58a3eacb0ff75b9d87
prerequisite-patch-id: b40661f81df728ae9fbd2ef97414bdf101fcd4b2
prerequisite-patch-id: be4b96bead5212147b2c841fa4aca2e39d48e34d
prerequisite-patch-id: 48f1725c6e7794b180de0e2d1c7fd061d37089fe
prerequisite-patch-id: 87b62eb9889d885ed179e53efbba8e4e31c9de4c
prerequisite-patch-id: 4604f02e892cb8a9c4704520b6372cd4fcadb0a2
prerequisite-patch-id: d377c33ec6bb4dd756ddb5a7e550a387513d65f0
prerequisite-patch-id: 2d4d416cf592845c85f320ac98d6ac25931ff057
prerequisite-patch-id: 88a998d505fef1f541e29bbfab4b7ac24be18fc2
prerequisite-patch-id: a9f9f4adfe152df7edd5ed11906d69eaacdc8c67
prerequisite-patch-id: baab1efc93f5d60a369bd21f60cb34f1831615ae
prerequisite-patch-id: 3cfcf5bd6b6a4ac67463951846b566b3b75c0a99
prerequisite-patch-id: 59a0d40227f4cf85d4946ab173a7d4870e07c78d
prerequisite-patch-id: 113bdd109be34ee9da663d194e8b4aedf02180c5
prerequisite-patch-id: 0f75bac966d96f4f7273152267a84ad33701ca06
prerequisite-patch-id: 0947ba9625edd95b88f1117f7ac71596089815cd
prerequisite-patch-id: a929dcbd57229a02012454f55e6f197d6535e15e
prerequisite-patch-id: 9923900be884b6b66bde9db818697311618c7e96
prerequisite-patch-id: fcaba98777b403c2c762f0e402339b173ef50598
prerequisite-patch-id: cbab40b40cddfbac5a03187f742a1c86855b6c44
prerequisite-patch-id: 6e52a0bbf0d8ab82675e531e35701570ca69b487
prerequisite-patch-id: afd676b03ef9f08b9b1e6cdd550682af6ed97846
prerequisite-patch-id: 3082c60677ac286c4b7c0eb9379075dffb8b4b17
prerequisite-patch-id: 90fd1af7585680c9278bb306af9142b07f954a67
prerequisite-patch-id: 9027f2d4b6fea899090915a3f05e36a96809deb9
prerequisite-patch-id: e387ecd2afb85036aef864e68c5b48889228f4bf
prerequisite-patch-id: cbe3ea4b6588b26230e54cc491757bdd8f7b2a93
prerequisite-patch-id: a7e5d1a4e223f5b3d6b62819b5f9e137ad099844
prerequisite-patch-id: d91500215e3ac9d42674ac8535d6c250a8ab9773
prerequisite-patch-id: 820352aad0f9a1e7be48e33cd0926f52c0b496c8
prerequisite-patch-id: 7ecf99a1889f92b76421c779c8ad654aaee10375
prerequisite-patch-id: 826a5c996141385dc3c2807d1177d9704de6051b
prerequisite-patch-id: e684a92d65eda3bfbb050fad182bd5238f8b9427
prerequisite-patch-id: 1723969d360d0bdcc50d60f6dd8827a5696b65a1
prerequisite-patch-id: 4cfc11997e7a2e3eb5c97d6cccbe4c48bd61348d
prerequisite-patch-id: 0653690229352095ec92eb2e6e47d3f06ccccd7b
prerequisite-patch-id: 864cc661749846cc237e9496f06948fde567c335
prerequisite-patch-id: 0afa3791265ba660562266c1d410121a1acfcce7
prerequisite-patch-id: b4eb9e4cb8ed286bd30e57863384bad1f560e937
prerequisite-patch-id: 3c2b301c5c479174a09f71397579b32283a83979
prerequisite-patch-id: ccaee0a5dee13d875b268378c357e62bd42084bd
prerequisite-patch-id: 4e0f2b2ffdffaa099257ead992b819bb4d809351
prerequisite-patch-id: f5722ae339169e127b1e99852b931fbbe1efd748
prerequisite-patch-id: 9853d4ceca03be817a8dd09f966b94e78097827f
prerequisite-patch-id: 32ba9afcad03f7daec660e73b370a436a8214076
prerequisite-patch-id: 991d2a7eebbd01d1bd081a904dbf0f333da33928
prerequisite-patch-id: e2e9634e2bf36bffa9a88abdccc5801d71c43a61
prerequisite-patch-id: 6f0a9c4198f0df422a579f876b2f7fecdabbceab
prerequisite-patch-id: 76d52907dcce2c5c590e0f832ca7ced7a885feb8
prerequisite-patch-id: 414578ffe40ff395bc35b49e3eebf236a988a602
prerequisite-patch-id: 73d0b87fe9deb70428998ceef0efbc5bbbfc6b44
prerequisite-patch-id: 237625c1544c921925aaae0508b170ca3a7ab4cb
prerequisite-patch-id: 77738ec0c4dc3148ada391f1c70420ed0ebd257a
prerequisite-patch-id: 68a94a1d9a2d0e78c60e845193917a59a81391bc
prerequisite-patch-id: 9c5202a6319aeead827551a014adc46a535e3939
prerequisite-patch-id: 687455d69ebcd60af5be3b6a6e7a3def362e8d21
prerequisite-patch-id: 9d01feac1577e0a680295ce0e447226dd566a599
prerequisite-patch-id: 582613278901f1846e87104fe61f8aa823d73fbe
prerequisite-patch-id: ef9e51f54a813ed7fb24d9959dacafd471957813
prerequisite-patch-id: 528391ed13c7d8c3d7b071df716461b90e351393
prerequisite-patch-id: 427380cc73731a17fed4e366e1c1d9c9912b4d56
prerequisite-patch-id: 0738e1561a723be0d148c3fbe70dcc71791b760b
prerequisite-patch-id: 67d4137f71f254a3b3d92046de2b3eea846108c1
prerequisite-patch-id: 1cc6dbf313bff99bad69b7647dd6306f6ae96863
prerequisite-patch-id: 508501eb00942f9c6652880703289bd85be9fed4
prerequisite-patch-id: e2757ae3a94b3bc64f6ae9e1a98dbbbd23abb127
prerequisite-patch-id: 5921298136d3669b3ca0f3036f24b3843a696e15
prerequisite-patch-id: 1ccaccf6215b4363c111ef0e06ca0ecab552df29
prerequisite-patch-id: 1f1a8e68685abc50b1b4d445d9b08356f16dc28c
prerequisite-patch-id: 2b6ca0f577975f7c04d5606e36b53e014c7c3877
prerequisite-patch-id: 0f0234e2bea5e3345bf65330884f9958c7a89e18
prerequisite-patch-id: b02cacfb40f350d1c6d00850d1cb1f3f079bcc05
prerequisite-patch-id: 992620c80608c0c85afa0f2889d8c2f9a1e8c96e
prerequisite-patch-id: f2b7064182e99cf35aef728a4256ed4559f2c1e3
prerequisite-patch-id: 243e74119ab19928c6c8ee0a6b81162ef8c22228
prerequisite-patch-id: 84a3ddfcc8c8204bc4458f94af0c516e372d5172
prerequisite-patch-id: 4812137266da6e3426cd7e2d3b414de49e9095ee
prerequisite-patch-id: ac17ad31222d4c02271670d5eb192cc25ef665d7
prerequisite-patch-id: 2c91820315e60dd49f363bb797b9cef53822f31f
prerequisite-patch-id: 6ace5a1604e1ec77419af8d95e833cd282689fa8
prerequisite-patch-id: 7d56e47edcc30e479d76d5ffad02c6275e346413
prerequisite-patch-id: 160e82e0a149ab44bedd3c8c9b96a95dd1baa96f
prerequisite-patch-id: a7cf66c22b099e1c9c75c0700c6ca0df102b4c52
prerequisite-patch-id: 3f776dc69cbfa252d5fef9522978a358a1c82531
prerequisite-patch-id: 8c0a03030212fe4bbf5f1207fc744c5f85f55a46
prerequisite-patch-id: 014852e77de3411df1cb10fa3d71b4b579d2514b
prerequisite-patch-id: 0790043a1ff0c64837d7fec887521006ae8552d7
prerequisite-patch-id: ac91783d5fdac90aa068eab1310ed6d462589b71
prerequisite-patch-id: baf8b4b761a5dfcf1db25cefbc253bf901413fa2
prerequisite-patch-id: 9f635f9e0901a8a4d2a98db2455e2255782a1df9
prerequisite-patch-id: 4e91c279f98bf5627c1405847c9d2ee16ad3cdaa
prerequisite-patch-id: fd52cc146ca09cece69e897b697971ba2609a31a
prerequisite-patch-id: b9b438ed2a39e4e21874ddb9653c1026d5ad84ff
prerequisite-patch-id: 84aee72393d42cef7fa33f7787d7efc0973c1c14
prerequisite-patch-id: c685a1bba21ec01978c4c8a4d3e3f6cf56e68d3e
prerequisite-patch-id: a09e204e5b5c32b4a7cb605c086a285d3ab69283
prerequisite-patch-id: e8361b0ab5d0917f1cd780c1e94b9be7a17004ee
prerequisite-patch-id: 36dae7626f3657d5e083948b8ed7bda2d89ed0a7
prerequisite-patch-id: ea1c797acd9653c538d05b23c309c2a822d1cdb3
prerequisite-patch-id: 57fd583a033873db42af45e5965e13100330d68f
prerequisite-patch-id: 09fb5cac310e0a4b0718932daa043a8ec776919d
prerequisite-patch-id: d81fb77386a4ea1711ddccc4c79818dc809dd7fa
prerequisite-patch-id: c1bd6d04019af14a039ddf783948eafffe930118
prerequisite-patch-id: 49394ffa8d826cfb81fc08ed88f9cf77b685c0fa
prerequisite-patch-id: f23c099774651da18b44aa299127f6d07a8e6c9d
prerequisite-patch-id: fc52c27adb7a008167780de6cbb9511bea653d31
prerequisite-patch-id: 1cc63161557c851485ebf55105e1af9b626bcfcd
prerequisite-patch-id: bc00834d08adf70ded280ed004fa13274c1a7167
prerequisite-patch-id: 3a16138a8260da2853282e94f070d2e220e9311d
prerequisite-patch-id: e8284ff3059502d875a95fcef7403249f5070fc5
prerequisite-patch-id: bb14b4b351f98e2c249a87f65bd4674e129c56a9
prerequisite-patch-id: 267e7ec1b5cf09a7259e280f098a2a6ddf10258a
prerequisite-patch-id: fb4e533971866f36552fb264b90700396e527198
prerequisite-patch-id: 9d13b8a5269805338984ba442a2211912c7b1e10
prerequisite-patch-id: c186df04042662fbd3ec3acc3c3a80c71b66e533
prerequisite-patch-id: 63707bf52e1ee91a3cffb34c4fc7726417ae18d3
prerequisite-patch-id: e08588c06386deb67d100fc161502fc3d5976bf4
prerequisite-patch-id: 002b44529b32ff81a68829d59467b7b4ea426dc8
prerequisite-patch-id: fd2c055ab4965c0dfdf3ff23d2a1d66beacfed8e
prerequisite-patch-id: 73b66c84c9fdc0b9acc8a66105fc62ca41c313a9
prerequisite-patch-id: 474c6c3437682d50da1cef36e2b90609622f02f0
prerequisite-patch-id: 16595ddb9b99419c2470e6db313cb380bd5167b7
prerequisite-patch-id: b7a95879bbec84b503fc0a0ab71e9dfecc5be3f2
prerequisite-patch-id: fa878a3a218889b6ed248224cc10ab03cd43d11e
prerequisite-patch-id: c4790779fae92911fcbfad95d3fe93720bc25842
prerequisite-patch-id: c44f8670e0d4f72603b3561e55078fa0fb3e1977
prerequisite-patch-id: f3aaa5e4e73029b6b680a7f7d317dc08a8175cf7
prerequisite-patch-id: 12fc867df0c684ca3d91e6171a2b5100cb93b81a
prerequisite-patch-id: e0254c4842bded3be11957f1dff564254f28d8e9
prerequisite-patch-id: dedc5951f52bf6b57ac56c969f08b5d52107d0bf
prerequisite-patch-id: 0e60bb1e67ee3217df2997d32b9ced1da1833239
prerequisite-patch-id: 8c6ddc2a1d2d561bb1e2b1cc2396a47f551f610f
prerequisite-patch-id: 1b14360ef13ec6d1d91c488d1aba36d4da007935
prerequisite-patch-id: 336fab68fe736e8083144cc858b634d195eb3b3a
prerequisite-patch-id: 94fa7d6f1cc7510f501d3aa3d47e5cc89a9188b9
prerequisite-patch-id: 9f653ab8c436c1ca641d6288a33d49cc04281027
prerequisite-patch-id: 5573f2b3705d46f54223440a674b67cad482f807
prerequisite-patch-id: 1d1422970df81399872490ea9c1ebc1c643635c0
prerequisite-patch-id: fc925d9235ed000ba17b903871a9525f933b912f
prerequisite-patch-id: 0ba6835463ff611d6945231a0c83c2ab02e9785d
prerequisite-patch-id: b95ccd72b69e2cf329d4342e918510c5edf8d701
prerequisite-patch-id: 9c3c59b4af2fdd549029cc870750a81c1b794659
prerequisite-patch-id: ac630b4826b80e0c49618f9b3399a6a3d1c0c77c
prerequisite-patch-id: c72ec2e0a4256288f9d4e291060c28c9716b18ea
prerequisite-patch-id: 786b50179d8543f7c9ba2defce6f9eaff11a35bd
prerequisite-patch-id: 3b6895ac656902427500b75d280775cf28be335c
prerequisite-patch-id: 5e6819a641f7dce4feb201445e024e9a10d56949
prerequisite-patch-id: 9a99286b6feedc4a62d314eff229a397837ad9b9
prerequisite-patch-id: 3477b52acf854cdf964608a4f23e840301378b6f
prerequisite-patch-id: dc40c0cdaad940ba04da12f23c599dfa0e8d4ce5
prerequisite-patch-id: 3b4c8e0628e2917ac2a6d12fc341bb59d9acc3e6
prerequisite-patch-id: aaf8c0f1c9c6876e4fbcf583717f8019253054bc
prerequisite-patch-id: ad87ec2fc754f44e54641d073b258018fa4e88c2
prerequisite-patch-id: 585bc34ead1177a97544cf5d6561491c61df253e
prerequisite-patch-id: 75c518f0d2042195c937a5816bcf54ad77e62b99
prerequisite-patch-id: 0ceb4baf4e6a918b118cb698393b40545a363ae4
prerequisite-patch-id: 624b07e44a85cc4125ddbb4a6f22733be8a412bf
prerequisite-patch-id: 762c9bfa8ad9e8055b4b409a56ed1475803c9a9a
prerequisite-patch-id: 7d73294d78e58a31ac5d61bab6ba29e8e241f34d
prerequisite-patch-id: 0198a123807ad6092869bc9b526fd4d7ab973e01
prerequisite-patch-id: 2002985a8160e98c5f2cf41923c2c978b6ba7fbf
prerequisite-patch-id: 9b8082332c625eec6795903bfe021ac7255e51d1
prerequisite-patch-id: 5e4fe280f36543e66ffd0d8092693ac86fd6dfb0
prerequisite-patch-id: 1fcd6c7add50710303de26540ec3a4c81a46b34d
prerequisite-patch-id: 6f3a9165a8410d6ee933a921538da36abeaa7d1d
prerequisite-patch-id: f57009e493c574d328503f69cdffb2f59d95e776
prerequisite-patch-id: 26125efe660fff28296bf1bdf64b88fb7ecd3fcd
prerequisite-patch-id: 895db4d227b1574b372a409a6e88d1136b0f8c3e
prerequisite-patch-id: fcd1b5cfb668f72f8a3bda919c90e96a35fa4c9e
prerequisite-patch-id: 4417778bf942905f6c06f2e65c82cfb4c3b530de
prerequisite-patch-id: 306768fbb26ddd866575c6247e41cefd2883d3ad
prerequisite-patch-id: ab56a6d75aca9b24479ee6004284b7d5bb386468
prerequisite-patch-id: 2c726747bce5b0bb50a6a7cdddda27e086a6314b
prerequisite-patch-id: 41e90f1a4a57c82d79291367e691de5dda426401
prerequisite-patch-id: 7682ad57a1b8d284f919cc1c1c582f97cfdb87f9
prerequisite-patch-id: 38fc889b0635d25cdf563d98d6177a8998b9cb24
prerequisite-patch-id: 7bfa210214eeceada83339821e8da795dca755fc
prerequisite-patch-id: 2761d2ea11f1469de7bcd7fb34146903b29ae57c
prerequisite-patch-id: 16d29bce080ae9f8150dd47aab67e156dc20fafb
prerequisite-patch-id: 6e3b583db810aeac9afa80b40027d1ca4b1fcf78
prerequisite-patch-id: 5b47f85b2f7e51137e3c3f0eb822f9d5adaef20a
prerequisite-patch-id: 15f8ead5b84787039a24de8a580bf460bf02cf5d
prerequisite-patch-id: a8291c4f5e3118165362aeb3d436ae1a0e2bc0b5
prerequisite-patch-id: f2a67cf7c7010e96f228cccb72ab6ab7171a4562
prerequisite-patch-id: 2bdcf4269674da080c837102f0f1baf5e5699e30
prerequisite-patch-id: 2963d5634caca58815f5954f3ac38862c0761925
prerequisite-patch-id: b649de93b5cf069305cf1ec541a8b140caa97992
prerequisite-patch-id: 72e5eda7d15935f15a67569dacef1c3d397d7600
prerequisite-patch-id: 8634951bb66ef258834c0ecdb2739a3ac155858e
prerequisite-patch-id: adea1618a1432b8902a73b0a706033d6ecd006b9
prerequisite-patch-id: 2a83ce1d0f5fa300c524d43f9a2f0b2376a9b686
prerequisite-patch-id: e1522fda4d999087becef78cc2d275f4c96676b7
prerequisite-patch-id: 0d1e4ac438db54dc324cbca2486fcb1094b22e84
prerequisite-patch-id: 44212f9d04e563364da143b7e777c9e5478b6c8b
prerequisite-patch-id: 04fa11f69c36914825165ec6bc4d67c059033a3c
prerequisite-patch-id: 15497d23098170f60b18d4f4c7c19bd711359e12
prerequisite-patch-id: 8f7a0f1d5ec7c8b71beedf9313051f5d1d06a1bf
prerequisite-patch-id: 5d071c175bae7b68f4ec76c1b03e8e3e949056b1
prerequisite-patch-id: feb6d749f6e3b9f4fd113b6ec66f8b67cb63ebdb
prerequisite-patch-id: 6f953005e51f7dac874104d13bdbfb1252469afc
prerequisite-patch-id: 3677a9e5472f14522d0095829bba22366dae9198
prerequisite-patch-id: 973f1f3244f7e4f0aab190a03beae20be6346fe6
prerequisite-patch-id: 040d656240f4472341051a3d8c73322a5495f651
prerequisite-patch-id: a5ce40e4ba24af6ba0ff16a0942123f88365bb0f
prerequisite-patch-id: ca2ce900eac784330551b6329256905aaeceb439
prerequisite-patch-id: ca9369e0079264c05fa5733a8ceae59aff0c9b62
prerequisite-patch-id: 033295484ca32b2f54a913d7ac2b74b9c1c3322d
prerequisite-patch-id: e1c0a14a0dcc6527e420dcdaacc2bfb358a34f8b
prerequisite-patch-id: 1d3d22321c13c2646da09638e4869f8672600a23
prerequisite-patch-id: 8f80091e3c883de876d06ba6e1b331eb99b90cb3
prerequisite-patch-id: 8d35d40bbfe34ae825d1cc5cce189d3aa82de156
prerequisite-patch-id: 3b8c0f636f008f7c06713cc2c7bbfd23e7f8b5e7
prerequisite-patch-id: a295bc38b7e96cad655d04421fa6f73976697e8e
prerequisite-patch-id: 7ade259d372ac7e087e5a4531d6518642d1e779d
prerequisite-patch-id: d1f57fb0b89c64544a323ab0d6eaac361c740416
prerequisite-patch-id: c10a45af9d47e1e4ea26148c12f7a046f7054a18
prerequisite-patch-id: fddb719312d6852d0d48ee45a6d0a5f9250efc82
prerequisite-patch-id: cecd63b709fd46ae6c422edd1cc5401864c87891
prerequisite-patch-id: 150ae8720a847604bc2c39a46b7b2df727e2876a
prerequisite-patch-id: fac9518e1d60dcf3da2faf56aae3ae384ca3bc95
prerequisite-patch-id: 832691297497cde3cc85c5959b8de1f4049f0d1e
prerequisite-patch-id: f21e249e583c4c893584b84e97a88a77e477b445
prerequisite-patch-id: dc216c6e832b6fe089d98f855e9bde1933b7fcc9
prerequisite-patch-id: 63985942576401f33379841a7a479c0d0785e0c9
prerequisite-patch-id: 9e6444c4e9e70d6b5e3a6d184adb27c98e9363b4
prerequisite-patch-id: 53fc16017b20e668b99c5681cef030b009534ffd
prerequisite-patch-id: 3182587fd4a1515111c020f92a17647a89e4bf50
prerequisite-patch-id: f47272efe246fa988e58c9476d3ccbc1f5a64234
prerequisite-patch-id: 0926d980333fdc5d7d5d5535f0f92645df691fb2
prerequisite-patch-id: 8117cb7135de3527a76a618299a7883002517597
prerequisite-patch-id: 1119bba4ef5fde04dd0e485527c72e168b045c22
prerequisite-patch-id: 45003166fd8698deda34d9ed23a200f4519d1788
prerequisite-patch-id: cb8bd0d492978e59094a4677024fbf0676c42347
prerequisite-patch-id: 6213d7c2cd350213a6a51fac1b952469c5e39ee3
prerequisite-patch-id: 47856ba76b9ba33ebbb6c9a1210961bfce23cc6d
prerequisite-patch-id: 04dfc436f75f4d258c7851c93d95e2363ca26843
prerequisite-patch-id: b75a63e5c59c004458258bb944f9be21c2543a60
prerequisite-patch-id: fa2e54b5306ff45896fbdeb47996627f7501f882
prerequisite-patch-id: 3a8ef7b24a87288483226357bf4149d1ecc80550
prerequisite-patch-id: b68d0d2fee3d84d24eb033a04025c9846b569b51
prerequisite-patch-id: a579bd78fb5c4e841456d0faf026dd6151d22fc7
prerequisite-patch-id: 45e3135deff29990d6048334b230861c707f3a20
prerequisite-patch-id: 5926f2e475baa63315dc3ba306ecbbdca95a98fb
prerequisite-patch-id: 4694455e7823dde9ea38d4f1686abc9756c5f7f6
prerequisite-patch-id: 7d8d8973f796e68fd80a7f62f3bcc52e1c30396d
prerequisite-patch-id: 54314baf3f2b3b16d4983e1de4e3b52d69883529
prerequisite-patch-id: 33847c2db7509a594706eea93c4c42732e6b9549
prerequisite-patch-id: 5b3aed3de30030b299a85b1e0e88cf1d344b211c
prerequisite-patch-id: 045ddb683740bbe9786ce716d58320f1e5767dfd
prerequisite-patch-id: e0352391bb506af334f14dce49dd68416af98917
prerequisite-patch-id: 857ac927e95b128e57e99dfb28ad6a3a4c4c6fb0
prerequisite-patch-id: cca60390b03d02c521ae6f63f068a7c99cda24be
prerequisite-patch-id: f576a42d00dc084991882cea6d06fa44706ad178
prerequisite-patch-id: edb411ce9d031e942a5e543b04a0a42edbfd0d02
prerequisite-patch-id: 61b1a2f483f14ff0bdf3886d287c89b0ef42a086
prerequisite-patch-id: 8d57b599fc2b2ed3681b5b3b7efb8b9b0417f51d
prerequisite-patch-id: 64ed7fa64272c2866d3b81142f9cd321cb76a37c
prerequisite-patch-id: a0bc3b82b2c90c72ddbd8dd115a56e16d4cac469
prerequisite-patch-id: c2d0fcd7bca2ab18ebc7fb54db120889ae6d08fb
prerequisite-patch-id: 65164d9d8833fe61620695eb3d45785598494a9a
prerequisite-patch-id: 9fd1db7ba39d66c92592c7f22eb33604df018004
prerequisite-patch-id: 3e8babc53751c8b34a09809aa8617fcc55648b01
prerequisite-patch-id: 92ff008efdcf7cbd39e8dccfc0517c6f6c5b6a25
prerequisite-patch-id: 9c70e32d6c9918e59fab34b791990a2a666535ca
prerequisite-patch-id: b892f4f194714d502572d2cf28b0157f8610f6d7
prerequisite-patch-id: 7101d7c3a2aab470ecfedeb300c85b6477b62552
prerequisite-patch-id: 8fa7a2384ae82b8ccef76ce37f7cbce163bac309
prerequisite-patch-id: 8fedce4d136f8b6cea6077946b1822908445a39e
prerequisite-patch-id: b8920c0abfc72783f4ef218b55ddbe9222a15319
prerequisite-patch-id: 61282bd2766fb4935f851c9fd630d8d0f2891cfe
prerequisite-patch-id: 1deca844492c24736188d94468206fd10054c371
prerequisite-patch-id: 022e4390afb3b31f890bb7d6bb1492dea5d76179
prerequisite-patch-id: 2055614272e6a7a8cf67a78c6c63f73e35390d67
prerequisite-patch-id: f09d0fac16db52162f7fbbab82c1a7f405aec957
prerequisite-patch-id: 7c70f31ef28696c9875931cb316a7343368f9527
prerequisite-patch-id: 48b124c9ca64a263e15a4ec6786261d7e34794e4
prerequisite-patch-id: 044a3c3bd7ca396e71896ee31f55f3b15931f205
prerequisite-patch-id: bd9d532b932cbe4ad5e68ba2027c02f81138ff2a
prerequisite-patch-id: 7948521e7678662ef69ae9806d4bafa99c3bfb83
prerequisite-patch-id: 15a43b5ae46c7e0fd885c461d2ed30d160a2c169
prerequisite-patch-id: 659e687545aa6498ce31ca973d1721429a195060
prerequisite-patch-id: a2afe906f9eeea4d1d1623cbb6459426dd20a0d4
prerequisite-patch-id: c18762364783b89aef76098f1b2b74d3a2ef079b
prerequisite-patch-id: 9393946e363ada6f14e5aca292515a9598e37112
prerequisite-patch-id: f78efee71866139b424e27b803bee565742f8a59
prerequisite-patch-id: 6d8555d8f2e9a7d0700979d69e0e037c69585c01
prerequisite-patch-id: 263895d259db042587f00ca6963ca82416804373
prerequisite-patch-id: 35124c953047b8e47ebb8d027a3d0179adaff347
prerequisite-patch-id: 815011e65f95944ec317ad0e95586cadbe8e7314
prerequisite-patch-id: 7448bd5669e9b78c2a745bff2ae8a0d27527c720
prerequisite-patch-id: b30e011017f9ff9c0d1411089a77eedff7003573
prerequisite-patch-id: b30bf656b167e20776076dcedbae348cfdb11b45
prerequisite-patch-id: 47052688b79ff10339fbc4a36684e094f5b7e501
prerequisite-patch-id: 70ebc770d9d0c3d36f945d77d07b90383246d6d5
prerequisite-patch-id: 40b847f228570992cfbbba8f23b15172df9ab52e
prerequisite-patch-id: d14125a8ff6fe93d428de62eb10fe0d357ba5621
prerequisite-patch-id: 7f16342e34e51875b16706b5f44909bcb7fed8e1
prerequisite-patch-id: d6cb4e69f7f34c39cd831a27115d9555624cff3a
prerequisite-patch-id: cda7b586a4ddbbe74bb4c4fc009d8abad8d4d8c8
prerequisite-patch-id: a6160f3a56107ab8f60a909a56c107b3d415a2b2
prerequisite-patch-id: 226b3f5969ad48e261d8c4b6b2290b615e4248c0
prerequisite-patch-id: 4a80e82bd4d0fa45f99e7ef64f27fb4372f7098d
prerequisite-patch-id: 343ec305fe3cfc25f838bc2403c0cbee4ef231d4
prerequisite-patch-id: 0cf6e92e4b54da57c182b7b1c75c2885b80d3625
prerequisite-patch-id: 563204fa63c2f3817813833a8225aefee4830b89
prerequisite-patch-id: e06389031f40b9281347af3c333392c5771cf8dd
prerequisite-patch-id: a2f066e544fad08fd4eacf418d0e0ddb8a5824bc
prerequisite-patch-id: 89f5877a59242b0aa6639a56a76786d81a31fd12
prerequisite-patch-id: eb0082470384181e2130572801c0603e482659e5
prerequisite-patch-id: a0f166d8fa37fcecb6a5715fe5a9251f264b6138
prerequisite-patch-id: ac6b204146bc1bd9adbd17d4b4b6b94086efc94d
prerequisite-patch-id: 4b7e016967819dec90211a45b7c8108cb5183c8c
prerequisite-patch-id: d4668537fbec4151431559896709edc89a568d66
prerequisite-patch-id: 1ab4069259ba9b2b7268c1adacf01b3d279072cc
prerequisite-patch-id: 353d9ef33d3578d7bce5bebd6e75f90fd34bf074
prerequisite-patch-id: cf0459efd975d369395303af0cf32fa11928fc12
prerequisite-patch-id: 80ae4bee6e8845b78abb8aafd2c7e1ebc9b65a2a
prerequisite-patch-id: 215cf62d492b20ead116832c777225475016bd56
prerequisite-patch-id: bb603532ef61c78b8da48d4b01d2e33638823792
prerequisite-patch-id: 1d3947887302f62bec2290bcff455d64d2f9cd2b
prerequisite-patch-id: 80221c8bbebdd43d405d0dd74f0f0ce908ad0a64
prerequisite-patch-id: 45195dda6f397648bde6326a214d38b24fc62260
prerequisite-patch-id: c316914e8322c2158abc8314448c8606455be3d3
prerequisite-patch-id: 78ab02a24bda5817aa2bd350ca7addc05cc1b9e5
prerequisite-patch-id: dc651cfeafa388b64e813ed167844f545bedfe67
prerequisite-patch-id: 84654c84cf34c228bbe0298d2646a014a0c86d5c
prerequisite-patch-id: e4883cbf3decded286b35b73d5875d38f53d92b4
prerequisite-patch-id: 42522e48cb9678e40037f93573569ca741852e32
prerequisite-patch-id: 289e0cb785aec51623d2e477824f7b0610af3247
prerequisite-patch-id: beaf589f2fad05f33763d485e60bbc9c657023d6
prerequisite-patch-id: 91320847959a6c77f36b226468906884a77d8ce4
prerequisite-patch-id: b645be536e6a1bf764c33de98fa7f125d1658f6c
prerequisite-patch-id: bc6dce8e2dc3f982daa58995b57b21c5d2a9b062
prerequisite-patch-id: 64f2941c1c07082db0b22296cd82249b1f80e20a
prerequisite-patch-id: 4a0305a86a7de3a10617d91281bf01a958deba36
prerequisite-patch-id: 8560eb6bb8a3ecf9879a2af5319dac884fec247d
prerequisite-patch-id: c6b1a4dd8857cae512e864ba5c4250965edc3081
prerequisite-patch-id: f023cea0776dc6410a46fa378ee177989af49ba7
prerequisite-patch-id: a09825b59eda893ea4e300bd489329072cf7fb3f
prerequisite-patch-id: d65a308395cc0e696bad627110f97d0799c1a7a6
prerequisite-patch-id: 1f0803cf6816970449745cc5bcfe175ec7399e12
prerequisite-patch-id: 744097e56bdbb907dab4291f6c7b19979a7a4306
prerequisite-patch-id: 0f8f9a6daa1917ddb2145a754a8476db263ce529
prerequisite-patch-id: 110cd5ef402e87b87fc21ace4863b58ff8724ac6
prerequisite-patch-id: 2b8373bbca5155acbd78fdc82d251b650398a55b
prerequisite-patch-id: 3e52220aecf6f7125a5e46502fe3c541161ad8ef
prerequisite-patch-id: f755e8d6302012e03c5707ca50905a652a1e7c5c
prerequisite-patch-id: c98250c473ce2a36cfeee9d6e5174c335d8d2556
prerequisite-patch-id: 5f5514a96a0f8d93a1aaea6a9675d307859f0613
prerequisite-patch-id: 6a97495f22f994aa12c1f04c27969c6feefe1f17
prerequisite-patch-id: d8066c801b7e329526cd8acee6d26bededcc76c9
prerequisite-patch-id: ee4959731689961bcbd9bca63c71287e26e87827
prerequisite-patch-id: 52da141be6ca6bd5c80979392e7f0100ee977ce0
prerequisite-patch-id: 7b5047edfd7cd3123e619c2d4d4f181f540fae2f
prerequisite-patch-id: c6a55394d3c375e9bc3c4292369b5895ddc59f86
prerequisite-patch-id: f10c2b2ba00790b03b529dc1d53827cbadfed00c
prerequisite-patch-id: 95b127cc1d511ea8294833987364af2cee7a7bb6
prerequisite-patch-id: 4e6881cb545c0651e1cefac099222008c5968a1c
prerequisite-patch-id: 3629d181497765e133a9937e3bf9ab2115b29d7f
prerequisite-patch-id: 808efdf345e2c2e9348825056792b9ebd7df569b
prerequisite-patch-id: 5c083492e95d31876d4fd37fb9bc71e9ab476678
prerequisite-patch-id: 52880749a3f50f34e375e6c85edb47214a2db507
prerequisite-patch-id: 70da7ee7d8053f6e276b32539e1bed798cb32c16
prerequisite-patch-id: 4257e6500bb74574b175dab9e1d0747c22f496a1
prerequisite-patch-id: 2ce90fb9c9463ae0c8431ef9d716d2b0209f4ba9
prerequisite-patch-id: 56ad46fdd2d74bb17f5a3e26738c1037a0a1670f
prerequisite-patch-id: c44191d1a65ca26ef376969e02b17f63d0d9c323
prerequisite-patch-id: da304def18e67d3c76f313320c1a0ee26dce7dc6
prerequisite-patch-id: 258c64e7b8a816b8514703fa3e6f5cc0d654fe9d
prerequisite-patch-id: 54cc0917cb997057bfc5647265b40eb44b336d0a
prerequisite-patch-id: 0207eb3c22a80599325494e61af83ca645b0fc29
prerequisite-patch-id: ece560be87bc959ec4ca3a1885ee055e49901a10
prerequisite-patch-id: 26c616d39e2e374d28a603c40167c4b0752c8143
prerequisite-patch-id: 3626efcb60b67ee70bb82a6500a4639700b6b04d
prerequisite-patch-id: e26dcbc1ccb8d5c03f501de53a85a484f882f949
prerequisite-patch-id: 7d5d296bb61199e940f0252ae60abbb3abbcd95b
prerequisite-patch-id: 5f04cf5823a647065cfc98bb222576db5b11bb47
prerequisite-patch-id: 1a9306b73086a8ea746cb48fc859bc8079dbd5da
prerequisite-patch-id: 186eacd51ca3d33a64844085fe9d1b5790d0a1e2
prerequisite-patch-id: 0e5078d7d65f800bebad5dd1ba8aa160d1d1d430
prerequisite-patch-id: 6ef0875cbb97bcdcf14249b7c15f96510c965242
prerequisite-patch-id: 49a4b72da2824e22105e741e48da8b430a7c04c0
prerequisite-patch-id: dfe5e1a51be03628b1620f9fb1807100c251f949
prerequisite-patch-id: dbd16a808427a8fd8f6f554ea3a3cfdbe148eb7e
prerequisite-patch-id: 06a40ba9a71f7625b5427ab12acbf55ca5321e49
prerequisite-patch-id: c7579c5eabbfcfe6d087ab77c408cf7e38046d1c
prerequisite-patch-id: eb5c09d47a2c1fea64808cb7eaf8e1cbb799c609
prerequisite-patch-id: 7bcf806c61bd1341f44dc856c2ed2d95e8ccaaa8
prerequisite-patch-id: 38873a4b0dc0f6fad4a32abc7715ab89350bda24
prerequisite-patch-id: d1be1acfe075d4dedb792f271e50cc18f27224c6
prerequisite-patch-id: 33e7bfe8838bca1f7c890f6fd81318ffa024a776
prerequisite-patch-id: b7c60c9e566e2283c497c67e39dc2419ec607bb0
prerequisite-patch-id: d0e11ca1dcb7b011d327163a50bd8e0a960e6b0d
prerequisite-patch-id: 231d20732e5d04d8c8f3a1157bd78e504afae44d
prerequisite-patch-id: fe1b4f13f8c16018e08d79d958c573367bed84ce
prerequisite-patch-id: 37be15216ed829861a0cea31db2ba860d3f55083
prerequisite-patch-id: 8e896e22f3b16d02064364c40f786c0bf6977871
prerequisite-patch-id: f99eab853b8dc14491d90afafc7a3c3652c50a9a
prerequisite-patch-id: 9c9c0822330e6b437b201c0c549fdc7d966dfaa3
prerequisite-patch-id: 3eb43015756b6396004c533c4d802c188ee65520
prerequisite-patch-id: 1bd961fa9b86de4ac0cde21975e7faa2ce8073f9
prerequisite-patch-id: c15578279e6f2e2b54b6798be1c22c16d34ab634
prerequisite-patch-id: dfc8f401c28e95e955d57e0e94f4a7b379830c6e
prerequisite-patch-id: bc8bb4a341771e0446a5c2bdfc005907b83c65c6
prerequisite-patch-id: 4a39e2f925bd9f2a6b7fbb0e6ff8c5fb58543fca
prerequisite-patch-id: 635feb3938bf23e9c4de5fd91478019cc1222600
prerequisite-patch-id: 1988e49e1b74a0cd3c66ff2e34243c1a9e62de61
prerequisite-patch-id: da3d59e7e3c482e921e5b907c1b955d1d44852ab
prerequisite-patch-id: 4bb69ddb5fe9bc833e1353d91f6adcf28c3e238d
prerequisite-patch-id: 6ad8a6be52c1db0522db94c470aae3c8f8b8e4aa
prerequisite-patch-id: 967f03199eb21ff4c6c088d2c6d39a9925f87c81
prerequisite-patch-id: 82bc77e9415e8fdaf2333c2b56df82286702414e
prerequisite-patch-id: c86342d002dc1076359e81b6aedd90ec5a9e378a
prerequisite-patch-id: 0ae51fab4abff566ea3f3ba6f33b1923030fb08b
prerequisite-patch-id: 5a587ab40f8b4d3e31f38f9795f639dccc9dd31e
prerequisite-patch-id: 34e270872fb90cd6db2b8e6d60d8e9e7bcfd42e9
prerequisite-patch-id: db18756ab2a6fd5838469154495b7a8b7f5edfbe
prerequisite-patch-id: 94990f61fa42211116247d2e109d75eaababaf6f
prerequisite-patch-id: 48d6b255c072b11293d7793b7f27cef52bf98ae7
prerequisite-patch-id: 772b565df0fd413a8d8c3b14eaf4a5103dee61f8
prerequisite-patch-id: 69ec86be151a329e261e57def85374a692ac7f10
prerequisite-patch-id: e4fc22921228ceaad3854c6e21a9451113c781ad
prerequisite-patch-id: 2a73f1aa2e8af14900a114795328079f49b050d8
prerequisite-patch-id: 068f5960eccfbf57c016d512e644a5417d3de61d
prerequisite-patch-id: b9a49884113095b234a5e2a2e4c07afe40ad705b
prerequisite-patch-id: 1a71fe2ee32005fcc7e558b0fa0e385f89f15da9
prerequisite-patch-id: 368da9d5593dc4400a1e1c706c33bb02d142f964
prerequisite-patch-id: dc1470cd9745de64ce0bda1cbbb53e713bab699d
prerequisite-patch-id: 456c92b9c32317114c4182fab04426993a8b6d76
prerequisite-patch-id: 64d00e62fa6c6a3991020b3f7448ce3c17799bc8
prerequisite-patch-id: 256fe9a91ac7436449e451d7c6ebb0743e9fcdd5
prerequisite-patch-id: 908715555dcaed256b51998e61e72ad003271016
prerequisite-patch-id: a18bfa1916549a7c8572315cb46924bdf911913d
prerequisite-patch-id: 4c59688d574e6661689f9574f717b70f43770311
prerequisite-patch-id: 0d9d1406095ba144da2dd41bbb5c3eed9233bf03
prerequisite-patch-id: 79c22da5a20d67cab349486549c096147e7b3b2f
prerequisite-patch-id: 3716d2b4fd58e4db672690e47659ab5cc5e03150
prerequisite-patch-id: 64e808f6a830534c54f9ca143c91198c6c7c0066
prerequisite-patch-id: 0f145e51c806a5a6ca12ce8f2b107829d0657a64
prerequisite-patch-id: d0185272ffecf89bb3f455b8656cde91616aa262
prerequisite-patch-id: fd49afde7ff732254e826f7c2080a5536f213fe1
prerequisite-patch-id: f61c3e289fb57efdba6e3ded6d3d52c012653fbe
prerequisite-patch-id: 5c93ae8186de5d285fb20e30578e37875cebd8e4
prerequisite-patch-id: e1e70da2210edb0f442df55b849559349de783e5
prerequisite-patch-id: c9c016ad03a0833c36c3e97b62d946b636d20566
prerequisite-patch-id: 54b7455b92cce0ec81c080b64729273c3ee37c6c
prerequisite-patch-id: 61cdbd1b73934576f870728c4de2168fbf2f070d
prerequisite-patch-id: 1264eef4586a975ee437ca7e18eebebee3e76181
prerequisite-patch-id: 39bf5f221647ca7fb5f650b82bdda9936672e7d3
prerequisite-patch-id: 4ac11d1dd1c13ddcdab054d76ba998ddd19bf3ba
prerequisite-patch-id: 5e53924569be95445dfb6e08fa37b75194515194
prerequisite-patch-id: 2b4edf6acd351d77502ddc6c3d2b2f577bb3ff80
prerequisite-patch-id: 1f142e4a92fd1215b7aa3e9332ac94e62c83023c
prerequisite-patch-id: 02dd17b5e79f217c98e7c285c0d317f336b950cf
prerequisite-patch-id: d5cfbca6c735c1624d217358e18ef0daec68d878
prerequisite-patch-id: 1a1f575066e1d4e8952601fe8713c5cc5f3a55fe
prerequisite-patch-id: 47ccd4c5b5e48b58883151c11fccb8d306f48981
prerequisite-patch-id: 272cc1b6a3955978c0ff0105e65bedefb8f32969
prerequisite-patch-id: 2d2cadc5c4bf6c9024be505f0e86138ee53768ff
prerequisite-patch-id: 3ac36395b22c57406ea22ee79d63e520c754dc5f
prerequisite-patch-id: abf1b936b8b8424152aa7584c437529aa0cc1fb9
prerequisite-patch-id: 75272b5661f28bdcd43a0bc5f47814db8dffee16
prerequisite-patch-id: f9de331dc4eb1fbea6107bf09acca296b074f076
prerequisite-patch-id: 52e159b7690931f4fa559c009a3d46f53f4970ed
prerequisite-patch-id: dc6f0271ec6b456a83b41ae0fb8f2def404a71cc
prerequisite-patch-id: 94cf00b99d77885f67c7a0ff09cd8340c58eb93d
prerequisite-patch-id: 0bfcc47b69dff593739f568fb1e4faea29bb3c65
prerequisite-patch-id: cc1bdccfea7ef6c0c824b6d638483f6388d00103
prerequisite-patch-id: ef29ed952f1794c72ad83214c4500948a28d8d4a
prerequisite-patch-id: 7f48d05a818e6e27b7265da0b6506bbfd4dcbcf7
prerequisite-patch-id: 046797094a5160fce717052283837866498de197
prerequisite-patch-id: f398f0da4cb15469a41f8e2e4ceb00e2bc84dfa8
prerequisite-patch-id: 369df977dcf9bd21deac2b3cb5e3e39ced9fd67c
prerequisite-patch-id: e5204558f65384cf5d8d5d8bdfc03c2044b55da7
prerequisite-patch-id: 1564b62bd189c64e49d817a498dd8bb4d12108e3
prerequisite-patch-id: d4350b0342f878e0d64e63adb056096bb13a8a99
prerequisite-patch-id: 7e4b10af07b60ea5c15e2680484f4bf215929564
prerequisite-patch-id: 3f6e689898d0ed1a3ead4d39d38dfc9c69b753fb
prerequisite-patch-id: 0fdd7f3ae396245781d4ae78c69ff52391aaa4ee
prerequisite-patch-id: 3b9e408672861b275f6a8648b308e1cfeb034758
prerequisite-patch-id: 3cec868e45b1041dff11a8e900694160627f2419
prerequisite-patch-id: e4ecc3221475fa2e0c8c286aefa22f6c3d39ff3d
prerequisite-patch-id: 249cae2ba018c0234d5366626e37d212dfac1293
prerequisite-patch-id: feeffbc048facb2cd81081ad99230c98a8521e58
prerequisite-patch-id: 2a307e1353ae67d1ecf55d7d70da10304bc28506
prerequisite-patch-id: 53d9c0283ecbe385ded6dd1e3dd4c7a2425a6550
prerequisite-patch-id: 29df8ce1d251b78e248b36aee536494e35c59e1c
prerequisite-patch-id: 5a654be46f1bf63e927d5638479adcd504db4fb0
prerequisite-patch-id: e80f97b5e12287341abf3b3dc8cdbda6c4d74605
prerequisite-patch-id: c86c568c9400699a3836b2c41cc621a54eeed9ef
prerequisite-patch-id: e29570d9e33d3487510b345a74b073123f5da3b2
prerequisite-patch-id: 5a20e3fcd8b7744ab65925b3a41adb46f44280ca
prerequisite-patch-id: 677e94f583c68be11e7ee02cca38dacc4e63f38c
prerequisite-patch-id: 89670164d58c60374c2198922636f8e56daa55dd
prerequisite-patch-id: 156e248b41ceca167a9144d55f0c004848cac472
prerequisite-patch-id: 3bea24f60b9ae48b0e006adc2fdc6f20e9eeed50
prerequisite-patch-id: 7104afe86fa6f723fb0926373a43fe87d6231d96
prerequisite-patch-id: 5d100d83277dda72b9fa838b70c287c9483e106c
prerequisite-patch-id: d87f9672212fefae5ee62a08e96c0f0cc6a234f5
prerequisite-patch-id: 389f89091b9a4b72af227f1cfa48deb3702130bc
prerequisite-patch-id: a792cc4ddd9ed2ddce25e54cd00b456fa550ec40
prerequisite-patch-id: 6c3425158924ba27dc4bf5f1cc2232a6ccbfcbb7
prerequisite-patch-id: 2a2c63e9ee6e3f4050517891727ad8b37d87d1bd
prerequisite-patch-id: f50aca0aac66b918885cabf1cac0a068a5f378e0
prerequisite-patch-id: c4a882be24d173f87d2adf5997803dae9f523acf
prerequisite-patch-id: fd852e79b93c5cc8722ba7738775d2380355fbdb
prerequisite-patch-id: 7ccf4291026b9a829a1169a1aec97884b9552d89
prerequisite-patch-id: be7555fdca1c0e86a4f8f3c764c4c7a017f7abb4
prerequisite-patch-id: f14ac614f8fb47e0ab48d8d12ae27c2c7b1e59ac
prerequisite-patch-id: 674f2207a2bc68eddd45d1a53f09bf233f02d67e
prerequisite-patch-id: c2b6682870606e6bd85c0f9abee5142927c52646
prerequisite-patch-id: 82495a86f23714f33a028387d216e6392af1540d
prerequisite-patch-id: 9d93195954be79a1a20509de864a5b073eb3ce41
prerequisite-patch-id: c8bd4da6601c2bca416c0e4ed3486792ab4498a0
prerequisite-patch-id: f3df35aedc3f9f10844d785a48313c77816433a2
prerequisite-patch-id: 97d37f851724f13de4406210ffe3785a5123ce6f
prerequisite-patch-id: b064d96e661fb886cc1e75dc793cadc34dca1c29
prerequisite-patch-id: 823ae0d18c59a737a2733bfcea3d3c5c6f99e366
prerequisite-patch-id: dc790a2cfbf8d6ece082b5bf5a971ef4f1bfc49c
prerequisite-patch-id: cb36edf11e41b7987824cd7b546560bf1f3e877b
prerequisite-patch-id: cb55cf16a8baa3799403348fb9260f55809040d6
prerequisite-patch-id: 7a6dd6e747d49f67cfd1475f28253d8b253c8fd1
prerequisite-patch-id: a827e3c63d7082e11352cfa44d98c407a0ad3460
prerequisite-patch-id: d9661ace72394feff069245920a1b290d7343b8f
prerequisite-patch-id: b4fd66a12ed592ee574de4b2b47165b7c0f8c7f0
prerequisite-patch-id: 3e4fd2d54c2b2d192eecaaa7dd8a124b6cb1b150
prerequisite-patch-id: 7c9631df4f1fee4c8a19dcd71ad080ef918c29a2
prerequisite-patch-id: b3654f5d17ee0611fd0afb204cf4d1385fcaac8b
prerequisite-patch-id: 7dee8d17b5bc7703ac94ec12e7b8f75df2bea495
prerequisite-patch-id: 0f227d3ee83bc1a7ac23d08339163d5d413e79da
prerequisite-patch-id: 93804e22d88027afd9e56f68b064a544804fceed
prerequisite-patch-id: 283adb283c287a4cfa091972d483bbeac3a1de4b
prerequisite-patch-id: f2774f45e32d951fd98aa02e63594f0061eaca66
prerequisite-patch-id: 67243001e8876ccce16fc95ff4b23cbdb44f5e2e
prerequisite-patch-id: ace6a1955c436888e634014b2334d5ac30d7aede
prerequisite-patch-id: 3287035808a4e27393769f437b1dbaf6df9d046a
prerequisite-patch-id: 1a2d6fddc1abab2643d86689a31d8812a749299e
prerequisite-patch-id: 167505944834139cf3f7091679dd0663d20357bf
prerequisite-patch-id: a6027fa23f4ed0641e79739220ed843d732abca0
prerequisite-patch-id: 89de1ddbb692fe0e6664800cb43ed20af8d2c918
prerequisite-patch-id: 903fa4f4a223a548cc6cc33b1817e39501d70bca
prerequisite-patch-id: 0fe2cdd29953fc364031e2e0b3cd872ea9145571
prerequisite-patch-id: d1c03c3deaf3f31cb1d60b0d1bbed6069fafb156
prerequisite-patch-id: 4d873375ee04d825b4d94d7e01667f7c96e84e50
prerequisite-patch-id: 628d854e3414c0e7082cae9f6d0008d290df87b3

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>

