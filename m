Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF46324B1D
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676860; cv=none; b=QWWyiK+VhV903HxGDGUKleWQtIN/KUvsuBxVUyWqSD4eJwRqyuA6DTzkhFpm2lX8niP9J9PUIZqMrIeot4S2GtWYGAOD5Q7kSc3x/0seaCGafIErhupV2VbTy+GrHNBNrZcaeQHalrZUOzSGlm/R1wenFCD3sYe7Ot4vHHBUpW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676860; c=relaxed/simple;
	bh=0yHFaL4kFduvDWHMbB5SGQV3aeiI1+OaatDNUsMBH/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rhPSx57GSR7CEgeLYHtUuZwdyy11VbRsyzWTrApKOGeELyugswA2Pu5MdnqZOHtV4RPRX3ovkCNLJKQT7P/vkSc61zvlEq6jkSxUQ8H5EThN2mKEvYwxWHqM14z8eETS3b6jRtuUZyHlgEdspELgrfdmrGg0I2YbX68cEW4bbTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aTIO0JIh; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aTIO0JIh"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-663019e3e05so7106414eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676857; x=1771281657; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EEaHOE5nznf9+zz/kBeN5l5G1L0iV5xIIbwKx1lv3GQ=;
        b=aTIO0JIhBgLXRZHkCmME/lEL6yl3odsHBzmija+ds6GwzDMep+S316RhpKw1fqIjDe
         0muoC2svuUinSNcwM6/e+clfDG+UdxZ3CUEpL7a0P5Vfa2Fhkyw6Ioh7LJMAESCq2eL9
         RJURAK2ERMqKXgP0sHojNcY+YAN88ZxOUhcZF6J5kV5agh7mI/g3zH5gJKSBC7UQSCxS
         YPTI7HuRet7sZ6ZaVXuMwxveXUSfxjrC72Y0oxf1NqWSkdGiU9G1A8RxBg0ndiGSdrb8
         ZnAiTc+rSkMuZXwT24xxJ0z0HqAPisBw0oTrUJMSIeLKv3gDoF3viiD7T0b/xk+acLWA
         OUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676857; x=1771281657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EEaHOE5nznf9+zz/kBeN5l5G1L0iV5xIIbwKx1lv3GQ=;
        b=WJVnOv+uBVKRu7QGiVlL0v1+vJUFm9ce2tn17w7OhzNWyKGJtWzpe2D6zt2SY1yW9v
         0Y7OTFUVL2rkMQOR7+5gAMbZ3zmNepPZR1QvOG7qxC1CW5zicjjkeI2+H368Yw4TpXx1
         0vHhUncDVLz8fVHkawl/Z9lYa/yz5fQrt08pnnOmR3dO2wVI8K+dmecCdPK6usJ3LbUo
         l9qIK/MX/gASYzEmIanLKggPOqDUj9eaTWCQ7p/k9eTvGpOVeZdVG/Y5mIjb8Jk+q09m
         oca+vqQJYlZePaIJ3VEKO/P2d6ki0PNBizxxthlcIkli5lkqtWFFjq9OkZtRfmTwLX/i
         BQdA==
X-Forwarded-Encrypted: i=1; AJvYcCW8eYmvTHtuy+EdaCMYlEVQHOb87loD7vzZZ8wmr2xhirWyf6j7hHxqD7LQMwuZiqExd56U9bc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIS7oxfrlpgE+Wa1Z/nuFeqN0R+pbQOYDMN25C0TbE3oZ0W+hk
	df9IZPstRikVAnUqCmScoW+sivdjxjb/cVD1g9IALb20Sr5iypM+xFgb44dlQAhkSnNqHLyabrN
	yFIQPTPhURc/lAQnSGKz13zF8Cw==
X-Received: from iojv23.prod.google.com ([2002:a5d:9497:0:b0:95a:608d:8cf9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:6ec6:b0:66e:10ca:fcd5 with SMTP id 006d021491bc7-66e10cafdcfmr3750272eaf.12.1770676856769;
 Mon, 09 Feb 2026 14:40:56 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:07 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-13-coltonlewis@google.com>
Subject: [PATCH v6 12/19] KVM: arm64: Enforce PMU event filter at vcpu_load()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index b07b521543478..4bcacc55c507f 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -165,6 +165,53 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return *host_data_ptr(nr_event_counters);
 }
 
+/**
+ * kvm_pmu_apply_event_filter()
+ * @vcpu: Pointer to vcpu struct
+ *
+ * To uphold the guarantee of the KVM PMU event filter, we must ensure
+ * no counter counts if the event is filtered. Accomplish this by
+ * filtering all exception levels if the event is filtered.
+ */
+static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	unsigned long guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	bool guest_include_el2;
+	u8 i;
+	u64 val;
+	u64 evsel;
+
+	if (!pmu)
+		return;
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		if (i == ARMV8_PMU_CYCLE_IDX) {
+			val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+			evsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
+		} else {
+			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+			evsel = val & kvm_pmu_event_mask(vcpu->kvm);
+		}
+
+		guest_include_el2 = (val & ARMV8_PMU_INCLUDE_EL2);
+		val &= ~evtyper_clr;
+
+		if (unlikely(is_hyp_ctxt(vcpu)) && guest_include_el2)
+			val &= ~ARMV8_PMU_EXCLUDE_EL1;
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
+			val |= evtyper_set;
+
+		write_sysreg(i, pmselr_el0);
+		write_sysreg(val, pmxevtyper_el0);
+	}
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -192,6 +239,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 
 	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-- 
2.53.0.rc2.204.g2597b5adb4-goog

