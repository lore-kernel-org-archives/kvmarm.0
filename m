Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749EA3043AD
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313576; cv=none; b=WNkTGkEEfKMVGaePVF/eeNrfsV/WZn1Vi10nY2s9zn2zqls2ry952RrjmhsId9s/oQoPO2koR+NJ4ZeT/Xo/1dPX71ST/ESrMeeqKZzMylaaKMyubvHMaVKw8HAvQRVddyShIxj1M42XaHAY60i3T5Vquhf5MhtxO4qkCpV6CB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313576; c=relaxed/simple;
	bh=0i/XVALUfLVfonlnN8cOfbbK0RivHhuamyQe6SmIzEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLR7Z12gjumeLlocwmvtF7wZokcFMaB4alqytd6O8P6Q7nJYMSUDCazoO0JYQK8Xwe6mosSNbl3V/PEkD6+nIcoERX+Qdc3pu7p6ofq12+dGUy3I/1jdQfBlcTDPsDh4HJ1O5CS6N6akLK4VDjxyiH3n1OsJU7VnDjLjBjjDamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7SufPyL; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7SufPyL"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-3f4bc7318aeso3928663fac.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313564; x=1765918364; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihXpQp4YbEFBpuWRcFtm84jVRjsgBgDbq/Ms0l8x8e0=;
        b=s7SufPyLyPfprEPFdBjjONhQ7pLC0j7CUnx83Ge7LX3hDBx2pEAxvOFw3yGAENhgTf
         7CI6Akf+4i1EJcZZHHAish7+ngs+6abDr5+AnNweXgrOxH4AweBiosdAg34rqcqAISZn
         I0xV8+6HeyyfjlIDOAeE2T49LlnA8XuyzdSX+4ltXwfci5AAgnxhveIp7npksykzzUUM
         5MzQy/47SagqKYibRwKC0zP+Szmfum3kh27Vr1FySA3efZjNoKedU+Hfb0sqfas1BKwd
         nIL5w4Z55PpXl6fxeneStKdnEzCnnLcXtDikC5iABdwfRuyOO7PT7Z22C9VCrnTsMOG2
         GZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313564; x=1765918364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihXpQp4YbEFBpuWRcFtm84jVRjsgBgDbq/Ms0l8x8e0=;
        b=mZQmScMfsKr2EUMx3AM0kfq/wc4hqT0pyIJwZZgLSG1uLHNZsJEvKgGGlHigP/EMOc
         Sselg/eO69QwA2IHGJv0NoXqBwr1+CeZD/gBV2fqknQTRuvJnPeYVedvHXk57Bq2VohO
         pNIEcFccPhPO5SESyVUR5QDpbskFoKH3tO70E2MKmKgYtKlSUx8Pt3ly4WCecI4Y+AvE
         iNQ2jYymToDF+AU2wcxiH94wv59Umr/SCSTElZW1ioRWPOEmDs3Fwv+xhgPkWwKwUN6q
         +qQVqCF+YfjDkqPRX7dSq45JDnGZcXqRq0FH1jWACOhQzRDlIwmu+SDsCGSdMsEaScvk
         4fUA==
X-Forwarded-Encrypted: i=1; AJvYcCUlHbDs3Mx1g5DaFxJXBoEEMH2cJgE6V61aewGJ6QmNqj4SiWl9uznUJPUGrCaehRaFzvtSEY0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcSjV5WoNAGJBTKhbdc826DpiL5EP9ExQ/EdYfcQSPweIcMJ+G
	cqCY58509MZstj0wGjfjO4OWZ3LMeZWbHuN/aNqtCc5v5uA+c9TSzcSqZSrXY5CMuRyBvgtjT98
	95n4GiVh/UO2ynxjUqawm4QONZw==
X-Google-Smtp-Source: AGHT+IHxM7HDFMt11Fktl9vAFCiqioFJsGX2hMXvHLM0Q/bfIgLNdr5sCpLbQ+drd5Dfesj8Rx6njSPwYNcP8RB94g==
X-Received: from ilbck7.prod.google.com ([2002:a05:6e02:3707:b0:430:c858:3dd3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:20e:b0:657:64ce:b40f with SMTP id 006d021491bc7-65b2ac06416mr132080eaf.4.1765313564200;
 Tue, 09 Dec 2025 12:52:44 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:15 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-19-coltonlewis@google.com>
Subject: [PATCH v5 18/24] KVM: arm64: Enforce PMU event filter at vcpu_load()
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

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 44 +++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 71977d24f489a..8d0d6d1a0d851 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -221,6 +221,49 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return nr_host_cnt_max;
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
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	u8 i;
+	u64 val;
+	u64 evsel;
+
+	if (!pmu)
+		return;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		evsel = val & kvm_pmu_event_mask(vcpu->kvm);
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
+			val |= evtyper_set;
+
+		val &= ~evtyper_clr;
+		write_pmevtypern(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, vcpu->kvm->arch.pmu_filter))
+		val |= evtyper_set;
+
+	val &= ~evtyper_clr;
+	write_pmccfiltr(val);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -244,6 +287,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 		return;
 
 	pmu = vcpu->kvm->arch.arm_pmu;
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for (i = 0; i < pmu->hpmn_max; i++) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-- 
2.52.0.239.gd5f0c6e74e-goog

