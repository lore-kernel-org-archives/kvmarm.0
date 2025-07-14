Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35027A46E
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533991; cv=none; b=iIzrCySO6Ja1+JeBBpLzK7ZaUAiOsJlX0L43wK8CpSlYwYPS6HqRMXh9syGPoIFd9K9aKwMpcnEQe+dLTABOO0CoNXmOukVIdp9XT55pEIsSW6sGlW1iCDK8iYqGeCU55FqOmUVM+IEChxWKq7ZQy6KYaHmPSpA33BeJ0mKCXZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533991; c=relaxed/simple;
	bh=HSC+7tbbygYOYGRXPyJFXJYTAG9wurlO2Yyv46F0TVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Io7dcxahWnhOZ13u7Ekk9Kp7GxHBX8Gt+bGkLck+xGzunb7MI3O2+DR8PTm6JoiHuyYrv4KyTwLG7GZPXPWo6WLy4Un7bzJ9VIYlRqahdxuIVY1yQXZdKGDDiuFrgFKeG3NSLA0jANvYV07H9ZMy/zdiQpTtmXG1F+jGaVI5EL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLgyvy6D; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLgyvy6D"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86f4e2434b6so557480939f.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533987; x=1753138787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3xq61Ak0c1ca5gbgp53wDmnmDBLKzZR4Y7JN/f5xOU=;
        b=ZLgyvy6DXVqGV1EnzwjVCsKNq9t7hFkeaBjD6cF6Dz6GE5+h2UjTpKaSKV6B+Rk3RS
         +OF/Lcv8ixXpekgEtF4zF10eWwBAGjqwhxaC375G7GGphEoll8DG2v04mcV3GNZwkF+T
         Jm1uqzuqsHVLY3atbKwugtEJVhvZWU8ejkX+NHLPFB7KUU7seF20yopaElwaTAsYHPTj
         sMUqT5hlpXYtWbnAJhtTxLrirNFSIC9OAN3p1OVlihLc6XN8uyv0Vnwwva1VogslykYR
         QqAne+xXJNfCl0q9y7Lg4sAoAYfCIc1zf1LhQo9TxTZ2ncx59Vhzs5024JVzIuwKdKQk
         +P5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533987; x=1753138787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3xq61Ak0c1ca5gbgp53wDmnmDBLKzZR4Y7JN/f5xOU=;
        b=FftIaA/38Uiq/g7zuV3P6spUQnvVpISM6//GNKc7KAOL6QVHGHw1OTniXngWAEZwtJ
         ehIoTOs4aPgEdCDmiVicls+UggQJ5qmyZR4i0xFUDBsHigeuSoQZRobMoEk5OZUKda/g
         bf5hgElWXGGOpS46Lypp7gshKwKTusEc8sIu0Vg7ynnOsTCtPIy5nkOoDMBxpIYSYtvx
         TPbUIhrAix75rkLjVGXwonnFwpUIeJ4sytorEUqjyLEL3jtccgIa/2vG+lc80zI82RXi
         qqOchEqiEqhU2+gLybdYDSCRiJ8rj7kg4M2C592ox+uHdcTwcomNjrf4Bq60IAmeLTm2
         xQ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVn3mjZKajIbC6EyfaKiKy96QuExNjC1R3qo5vr49lQg3OG3pq3gznq21aOQMSMv/6OCHkddoo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyob9kTrrCo48ra5z3yzH1NKwJLnnHuBdCD0/6l2WVaZ0vyGfOG
	5zSiqnx9wRY67dHxUlROSDgUMy25MoGQp0ET2PRRSTd5pjzovG4pY2ISv18hjyph5RPhD9DwLeK
	Ilo+OJSdeav7LrbeO8Hgy5KyH/A==
X-Google-Smtp-Source: AGHT+IGGNXzJ6MClaCHEDVsCSHTe4Mc4/qt4oPTSISuzvsle4ctKRqVs+0zuaGbv1rchsoKRxFJJDAgeqhZ1oRbZOQ==
X-Received: from ilbbz8.prod.google.com ([2002:a05:6e02:2688:b0:3e2:5969:18b5])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1544:b0:3dc:8b29:30b1 with SMTP id e9e14a558f8ab-3e2533103e1mr154939995ab.14.1752533986898;
 Mon, 14 Jul 2025 15:59:46 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:10 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-17-coltonlewis@google.com>
Subject: [PATCH v4 16/23] KVM: arm64: Context swap Partitioned PMU guest registers
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

If we know we are not using FGT (that is, trapping everything), then
return immediately. Either the PMU is not partitioned, or it is but
all register writes are being written through the VCPU fields to
hardware, so all values are fresh.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |   4 ++
 arch/arm64/kvm/arm.c             |   2 +
 arch/arm64/kvm/pmu-direct.c      | 101 +++++++++++++++++++++++++++++++
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
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 0fac82b152ca..16b01320ca77 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -9,6 +9,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_pmu.h>
 
 /**
@@ -193,3 +194,103 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 
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
+	 * If we aren't using FGT then we are trapping everything
+	 * anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
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
+	 * If we aren't using FGT then we are trapping everything
+	 * anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
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

