Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06443BC680
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292568; cv=none; b=mDmuV6DXSX+XoisCkm5vWq/fPwObxJ8fQASi+uDypUVBoZbUMS9B+PE/VNt7+HNnAR3AGNlWZ2aFgFQjQ6kb7YgCtq+eXypvm43J28WtKIbfbRdNU6Zd3vNxEaNaL9SBsJLU5FRFA/fSwGi7vddZXaKBJjUId83lqOfSh+9jyZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292568; c=relaxed/simple;
	bh=F2dYKN9UBGMoSrmGufMBvGUIdNx8DNh3XLEYdWtgWFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ElJW04trbLcGovQcbYDP9G5iDUPlLvq9DwqHCJNySZdrsOYpedr+sI0DXye2ss6S2k1SiAOaOyGFfKzBDSzal+sjcBy0I7Ns8/yLKfFzs6C7STvJarPjq3EtGaVlmksWyhcgJSjAVG+6dWNUQTxd++krx2feJXp+N0roObd8uMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qND49orZ; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qND49orZ"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-4863abb79b0so3524902b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292562; x=1781897362; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0u2rhf2u+9BtP4X7BxzDJO2DJ1V1hUQCf9r3VcGxcNw=;
        b=qND49orZrLSEPxGoiyJby4Hl20uSH/YC6izRe18dZ/odfZ75z802rndv4A4IMWJjqs
         nMIYKs3fkTWPKbhVIS5z5Guo5M/n4MJrHeRvY9Unz5inbefUSsov63qdqoNU4XANOfFX
         A34jlGq4NGvH+sXWcXsT4dDDVALl2Zpu4/HFSUGeW+61zw3QMFutUL+qJGlk6ILAHCwx
         WF4VZbnt/cCxuXx03A8gsFo5pHA0+KGdqCkG+RDYuKO2j+2PNXfJ9FD92wQVd5nwuuHh
         JWQCGB0znc1OjPliJRdkehzFwCj4L+beSUI1FUgm8alybPA3mAi7x4HD6h+qP5eudzvF
         zcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292562; x=1781897362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0u2rhf2u+9BtP4X7BxzDJO2DJ1V1hUQCf9r3VcGxcNw=;
        b=H1lE7IqbAxTuokE1W27/qq2tm7W/AKB5wHy2EJvAXf7RjaGo4wfZ1X/bP2nQX92zg6
         2j0DQexNfey401tgW/1e+153rsRZDAdHAsPVG6koX3w8z8y12eXy/vDGxMAFLr3K6F/d
         3sqOvAHjOiBpkM8e6kkyKWRejc9hZQbaxlU4IiqV1h3UCHWwLKpf4NrVUGp9/l7hPnzC
         LvOKTJZlv0ziNrCGhV0qBdt+tWiQWHDzd2oCKq+NAiUpWBlmnSm/e7cTF7y3kCwAnoln
         C9cUofxn4UA+H4v57UyE/UMllzNkoxlHjmjsXtswtPMBI7y73pYSLAZdZJ9wN4z36l46
         DsyA==
X-Forwarded-Encrypted: i=1; AFNElJ/6yFormDRlQ6iLMquYdviGboBr8Xjnqf+pr2AbOMB8fh3lv6yKr8pSFq8fhrzDfD3SwDQoGIk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIfhQr933i/Zh+KiJyhbfYP6TEgdPDCktYCcyi7XwPLVLgcd70
	7gNqXDWDnASZsckvvhM9zh8rlv96MBds9E8fgeSfyY0GPku69fhUZwNXYpERnS4SPjmK9RA7lc2
	Lb2tSSi29CCeLylcw17/hYkbLcw==
X-Received: from jabkc1.prod.google.com ([2002:a05:6638:a501:b0:5e2:942b:e3dd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1a07:b0:485:6029:90e7 with SMTP id 5614622812f47-4872ddea116mr2184822b6e.10.1781292561509;
 Fri, 12 Jun 2026 12:29:21 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:00 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-13-coltonlewis@google.com>
Subject: [PATCH 12/21] KVM: arm64: Enforce PMU event filter at vcpu_load()
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

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 79022447cfb9a..49f1feb5d280c 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -131,6 +131,57 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 	return 0;
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
+	unsigned long guest_counters;
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
+	guest_counters = kvm_pmu_guest_counter_mask(pmu);
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
+		if (i == ARMV8_PMU_CYCLE_IDX)
+			write_pmccfiltr(val);
+		else
+			write_pmevtypern(i, val);
+	}
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -158,6 +209,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 
 	pmu = vcpu->kvm->arch.arm_pmu;
 	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-- 
2.54.0.1136.gdb2ca164c4-goog

