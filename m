Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA07309EEA
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313579; cv=none; b=XQ9hAat/DbNIpGJOf8KvmxdRgGUoNG8NoiJyOQHhXJl+pPuEfxxiZ312oyQJjRAwwoeMuQTe9qlGkJbQ3iJRozd4m0X0teLf/EMcw0suurLVwtgLOs0HhMrLcHmrZIjte7FWnSTLuPk0i3S63fHYb7quP6AlkmVOHvG0zqOqfFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313579; c=relaxed/simple;
	bh=B0rHT03/ykxaZJBQkB+M/HLVKmH/k1hRDjrVKkpI4FE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VDmZ2Sfymh66d5RS831zeTRIcelw87GlVwdYKzq0ayE4FD0b/oC/KEo9eeh02esU41C9rc+BcCw7ew+IfUrr2cJt+/yJFQ9cNq1ci9SjBzJmVWKh5mQhhdcA6ZQ9Ff3sM7DlwCTs6St4UCCLtRZ/OSALkOLM9gHdHGHOJH6inqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFyvvEoJ; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFyvvEoJ"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c982b11ccbso4210862a34.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313567; x=1765918367; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OtKUAKNDvUk1bFrFUkDSMLUOkfepy8OH/MA9DzHIeSk=;
        b=zFyvvEoJ2/LX1hn6TrYR4WCG5RY/lYayjcbv3RcSDoBXX71urdip3dQ5+KpGcwXsnX
         LcB5MfPbhR7K8g+vwGY9DLhfS98CM/AmVxa6iJ0vRc/uwXqoI6fCtPw54uh6XuFrTpxC
         WLpbya4zfh++ETIIOWfsrg2C370j1DJOPMAB1aL6E7mk4soZhGNiKiH8+dEYmye28bQ1
         GrIPls0ipeJ7drNR3la2dAEkG6hNvBnbrhc3jzW065j3ozzTTfzhowZpAaLDJZPgn1pk
         fLxB92NL5uXHJoSQWtWnZ69roVm3vTodIZTeNyPK6YaO802nhE096mgmQXK/b+ylCo0r
         gKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313567; x=1765918367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OtKUAKNDvUk1bFrFUkDSMLUOkfepy8OH/MA9DzHIeSk=;
        b=RlW1LWj71E8XYqYCOfhPy08KXcO3eMPEC1/BJf9cAA3j2YYSEH9bceA6bExbadZPwu
         vUfdSZikhcwNyN/CXwFXCD7IwPvPsqu7I6bPunJF8yd1HPCjp7Ikml9K+fvm3Wl7feQ6
         h1MYz2tL68mdH1FwS57vwG62IVFkjf3HYWitqGcCEOyn0s4HyOFUNfBYlQgskTUJOB4U
         uHxjjmbgRm85zA74RwtlILxjVwqC0j6MMDl4cp2y1grjZe27Y05VAbRCKHxhbCPMpU4d
         LWJGfO1echDuXW8D3LuK8Ap0dvmENmzbJUel16PQiKzd6nRzyHH0+kyP66vHa3MMji+L
         dFzA==
X-Forwarded-Encrypted: i=1; AJvYcCVo6I/GtJ+lrbsKbQvti8nYr8z/YmcF8PYH9EgYY3Alc9iLlDS2O3hTFF0mUNTLY8wvCgRYwTk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzR+6Y4TqxO7vrG+cazn0Hn+Zqwy6EKy7T3Kpv0DfAfY9u6UIH5
	rlg0VAK2w1iT3WZFLWZBy9kg/8acnPRFS6ngzrwBoOAuMQJY1cqytJlr1iWRrevlUnXtfO7x2r7
	qYWcHARlI4A/agUcUby7acs+Q8g==
X-Google-Smtp-Source: AGHT+IElus7zwyOd6GpcWSRDylwpIxEDMWdFHeMbdxYXsYAzEkLnXoWZD854plNF0r3PILxeHcsu/DPU8yH50AgLyg==
X-Received: from jabfa16.prod.google.com ([2002:a05:6638:6190:b0:5b7:56fc:a47f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:c92:b0:659:9a49:8f68 with SMTP id 006d021491bc7-65b2aca3bc6mr107540eaf.45.1765313567368;
 Tue, 09 Dec 2025 12:52:47 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:18 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-22-coltonlewis@google.com>
Subject: [PATCH v5 21/24] KVM: arm64: Inject recorded guest interrupts
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-direct.c      | 20 ++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c        |  4 ++--
 arch/arm64/kvm/pmu.c             |  6 +++++-
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index e4cbab0fd09cf..47e6f2a14e381 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -92,6 +92,8 @@ bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 76d8ed24c8646..2ee99d6d2b6c1 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -413,3 +413,23 @@ void kvm_pmu_handle_guest_irq(u64 govf)
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
 }
+
+/**
+ * kvm_pmu_part_overflow_status() - Determine if any guest counters have overflowed
+ * @vcpu: Ponter to struct kvm_vcpu
+ *
+ * Determine if any guest counters have overflowed and therefore an
+ * IRQ needs to be injected into the guest.
+ *
+ * Return: True if there was an overflow, false otherwise
+ */
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u64 pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	u64 pmint = read_pmintenset();
+	u64 pmcr = read_pmcr();
+
+	return (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
+}
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bcaa9f7a8ca28..6f41fc3e3f74b 100644
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
 
@@ -405,7 +405,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
-	if (kvm_pmu_overflow_status(vcpu)) {
+	if (kvm_pmu_emul_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 
 		if (!in_nmi())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index c9862e55a4049..e1332a158dfc8 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -407,7 +407,11 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	overflow = kvm_pmu_overflow_status(vcpu);
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		overflow = kvm_pmu_part_overflow_status(vcpu);
+	else
+		overflow = kvm_pmu_emul_overflow_status(vcpu);
+
 	if (pmu->irq_level == overflow)
 		return;
 
-- 
2.52.0.239.gd5f0c6e74e-goog

