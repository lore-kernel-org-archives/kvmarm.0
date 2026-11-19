Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114362;
	b=ZHWiQDiSIoQMHfcNe3TXsRUgSQdxMx3wiIJ2nmOCmHZspg9G8vF+8JupUrzOO5kZ0wOD
	 GYGmD7rC7UijGz8IRmfB76xCCiyhpSucbTzuSfRol/Qz5WYKNwCyoGNlFeePEj4lCShFz
	 HqHJjKQG19U1dN51yCRCfw3iWircxgfWnnw+yfgG2ioFE643ifSUrrJFLL0pbZXQh3DYM
	 04gBO3+tZD+nFkQKvMt40MVssH/OvlscKRArhbcgqJaP5tChJMDjITaauC6ODGbicCOoc
	 qTkmsnKY1FVJD4IiRPJNmTL5dj+4hgBJyAyKY8EMqwWlSv2Vd/5RkR6QN7hq29h9oNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114362;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=FFPgXiiazla35XDoHe2VRdMYq0SrMDfs5EMKUnqJLEg=;
	b=VkFO701fkCn9+REzkihl5kVDon+jaPw6Dd72Y0L0jtCZeThFR5QCGWfZJQ0BgGVv+7JG
	 lTva6/WzuG10Yx/tX1LDArEpOg4C8sXkdjxq6Eb94x1hVI22ZkfUMyrM6dXwAkl28rjfV
	 cWtUTReEx7tAGxkMvBvnXy5PQ1hfjsfu1YktUAYvDwbD0MqLN+XAZnur87b2POOza/nRp
	 XfKeDwyeAHhkq1swbTWS8njxq+eEy/PDWt1JlyqbusUc751eWNQhYLgyVTsmSJhg8Tp52
	 vDpmS8c+m/VQsPfw4oL6Q6UNYDswvfmxALrerO33Kd6pt3ZBqe9ANXkCUQDtfsTYUCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NP0VSoUr;
	arc=none smtp.remote-ip=209.85.160.69
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5559606F43F
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5559606F43F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NP0VSoUr
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4ab90cdf747so1637489fac.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114361; x=1795719161; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FFPgXiiazla35XDoHe2VRdMYq0SrMDfs5EMKUnqJLEg=;
        b=NP0VSoUrsEMBY5khAsV4mQrwsS44QY46jPpgnJ74QxqcEqD20/m9tBeiWFQRUgW4OS
         KZG3WWEBbEKwzJRhoTaEeWKUTI/b7ZuyaA6juLmBbjDCghh8yPezsKi6CTG+H+sauHo3
         Jisg02ugsv+3ulT3czh+ldKfWa2h+jfP/lL6kkqHn+zogANV/d/ZMzgQ6E6LTu1LjFoR
         ywhf+shC4pzMKRKOegqpSx/I1gCo9t9IDKv0bJlWsgmFeFu1KWS2neGZ9z3dAaZRgrXK
         AKPoIFV5nLMYdOivFDFbB8NCqVwE3uQLrwLVE7twSOy57iXl8+YLKr1dleMpFT3Q5pQT
         0d/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114361; x=1795719161;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FFPgXiiazla35XDoHe2VRdMYq0SrMDfs5EMKUnqJLEg=;
        b=AUagi1567HumNhLQJN1TydFDU2Sor9NJ1TXGyA3bwis7pEkBF3kExWsRfgsMIM68Wf
         LN8QyZhPtuQ1rmTDhJArbIB/odrcSGVy6de1m20ZaCrT181ovm6X+fXPoFhAiDS6ja84
         K0HKHtW3Q7zH7z65cqJq79H/aemRM7UPx/eKPiCFoUwlc9wOT8FNTkNHhfXrSMIKG+n0
         RcykYu9EuwQWzdTYActhOE37BA6N9VZe2g7TBCzjgNcmP3cBnwGe5aZo2P2kXIBWVJTz
         5NF/nPq16B/+/2nhN9mzB2ZCWZg5UXaCfCc3TiC5GfYWnO8klZpFlvyAKyaft/yzuKkL
         zkjA==
X-Forwarded-Encrypted: i=1; AL+hErFJGme0J5EMFSifrxh7EgPnZGCvt/+QeXD+ERIwWLNxS8W9I5wRjAvIVB5pvaor4cdiyhZiHss=@lists.linux.dev
X-Gm-Message-State: APuU4Z8VjSyw3wX3agKYVTu2CZEC+G919Qm7FjKjKysaKgAazrbQB+B/
	2lFmQlQKo0/DztiMtRI0YLwijh0RDyiv1Hik8Py3bHpETPdFRSFURWpiDacnFBASO3ScR2w7GuF
	LOkPH4jqauzzYZUJqE2pLde1NRw==
X-Received: from ilbeb1.prod.google.com ([2002:a05:6e02:4601:b0:54f:8d15:4dbc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2383:b0:572:f8ec:5340 with SMTP id 5614622812f47-5797dd97e12mr1488800b6e.40.1795114360210;
 Thu, 19 Nov 2026 10:52:40 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:07 +0000
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
Message-ID: <20261119185215.632334-26-coltonlewis@google.com>
Subject: [PATCH v10 25/33] KVM: arm64: Detect overflows for the Partitioned PMU
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

Evaluate whether any enabled and unmasked guest counter has overflowed
in kvm_pmu_part_overflow_status() so KVM updates the virtual PMU
interrupt level in the vGIC (or userspace IRQ state) across VM entries
and host PMU overflow interrupts:
- Harvest any live guest overflow bits from physical pmovsset_el0 into
  shadow PMOVSSET_EL0 and clear them in hardware when the partitioned
  PMU is loaded on the local CPU.
- Check (PMOVSSET_EL0 & PMINTENSET_EL1) against PMCR_EL0.E for guest
  counters 0..HPMN-1 and PMCCNTR_EL0, and against MDCR_EL2.HPME for
  nested hypervisor counters HPMN..N-1.
- In kvm_pmu_handle_guest_irq(), raise KVM_REQ_IRQ_PENDING and kick the
  vCPU (or queue overflow_work when running in NMI context) when an
  unmasked guest overflow occurs.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 65 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c   |  4 +--
 arch/arm64/kvm/pmu.c        |  8 +++++
 include/kvm/arm_pmu.h       |  2 ++
 4 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 21357decce214..b0491d32b5d7b 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -823,6 +823,71 @@ void kvm_pmu_handle_guest_irq(u64 pmovsr)
 		return;
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+
+	if (kvm_pmu_part_overflow_status(vcpu)) {
+		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (!in_nmi())
+			kvm_vcpu_kick(vcpu);
+		else
+			irq_work_queue(&vcpu->arch.pmu.overflow_work);
+	}
+}
+
+/**
+ * kvm_pmu_part_overflow_status() - Determine if any guest counters have overflowed
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Determine if any guest counters have overflowed and therefore an
+ * IRQ needs to be injected into the guest. If an overflow is detected
+ * while access is VCPU_PMU_ACCESS_FREE (for example, after state
+ * restoration via KVM_SET_ONE_REG), transition the vCPU to
+ * VCPU_PMU_ACCESS_GUEST_OWNED.
+ *
+ * Return: True if there was an overflow, false otherwise
+ */
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	u64 hyp_mask = kvm_pmu_hyp_counter_mask(vcpu);
+	u64 pmovs, pmint, pmcr, reg;
+	unsigned long flags;
+	bool overflow;
+
+	local_irq_save(flags);
+	if (vcpu->arch.pmu.loaded_on_cpu &&
+	    vcpu == kvm_get_running_vcpu()) {
+		u64 hw_ovf = read_sysreg(pmovsset_el0) & mask;
+
+		if (hw_ovf) {
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, hw_ovf);
+			write_sysreg(hw_ovf, pmovsclr_el0);
+		}
+		pmint = read_pmintenset();
+		pmcr = read_pmcr();
+	} else {
+		pmint = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	}
+
+	pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	local_irq_restore(flags);
+
+	reg = pmovs & pmint & mask;
+	if (!(pmcr & ARMV8_PMU_PMCR_E))
+		reg &= hyp_mask;
+	if (hyp_mask && !(__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME))
+		reg &= ~hyp_mask;
+
+	overflow = !!reg;
+
+	if (overflow && !in_interrupt() &&
+	    kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_FREE) {
+		scoped_guard(preempt)
+			kvm_pmu_set_guest_owned(vcpu);
+	}
+
+	return overflow;
 }
 
 /**
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index da66162c68042..a72bdc5a0b3ea 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -268,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -400,7 +400,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
-	if (kvm_pmu_overflow_status(vcpu)) {
+	if (kvm_pmu_emul_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 
 		if (!in_nmi())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 7389d61957fa9..9d4ad4b7bd8d5 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -409,6 +409,14 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 	return mask;
 }
 
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+{
+	if (kvm_pmu_is_partitioned(vcpu->kvm))
+		return kvm_pmu_part_overflow_status(vcpu);
+
+	return kvm_pmu_emul_overflow_status(vcpu);
+}
+
 static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 9800514019630..fcd8e6331943e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -91,6 +91,8 @@ bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
-- 
2.56.1.708.g77570a6a1d-goog

