Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F542FCFCD
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968374; cv=none; b=rhP+s+TO3+RQIdo2NYI3/ZyRd6DiX+9hSurHU/NerGfWc4x1FZipNnvCNTWLhBU8Ms6pu3EMFs78cL5XjP/7LPYxEgJuk9NhKMN/P3K4p53Aa7rfGMRPvVFVL+onQUOqRGrx9ZCTnY/VQG93xiaFzBLiwg4JNdplldFLNe7UlqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968374; c=relaxed/simple;
	bh=JNAet3NELvRm4pw1yj+KmlMpWNsI1wPDPWHykWoXnxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKnXETv0hQbmZXpfs0dnx/8wtTuQUcIhDsr0z/GHMu0jyb6+UJwxmQMOHoG27nviGjtiQeRddQGxqH4tr3Cud5Q0u650KTBHmYQWiK+nID+3HeE27v/qhn8V81/ftkq49oDxheMx2HnIxiI40SLnaiVRproaUTU7InZr41GzxWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kTbYgyAi; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kTbYgyAi"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-4067aeea8c0so509171b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968370; x=1751573170; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fsln9Cluh/lr4G6zFvH7bpJ9BvK8mJLYYPmhFGobydY=;
        b=kTbYgyAiKCmghNmZylp1BoZyTYmZJI/w+z7kg85/8BHj0OHfxQMMEVZxts9VmZFFl0
         C27j6KQhd1fawM23bHW7AxtFyJRBYvbWAF6JX96lNZInPLoEaEr5YKwVNGG3DI8UVBwP
         2c6irZ2b4xCeIrubWAQHyeNRVEAEbGyEmb4Yfnqq8b8lx6sDOaQPDfqgjCvN2k5BbUMw
         /lekxf6gfeiP2extgRNmR5KcFGiesminQRdNnDV4nkDmVJb8fK722LryoX6HAA9dJh2F
         3Yqsw1ZPEhvnEEMCBI07mtXvxc+p0TESYoaUzqCDMJiFwxe8PUtcAyJYjA3BDbUaTS1H
         aXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968370; x=1751573170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsln9Cluh/lr4G6zFvH7bpJ9BvK8mJLYYPmhFGobydY=;
        b=DtINCu/DZyuEY3JK0vKgtf11yyUKlWsKWHowowtZHYhRf+WOsL3aNztVcsQkAvEOwt
         w6F83EhORk0F5vlTh+d2A5tGIOz6wTBZ46b/H0ZVpBYSFJGGgTIO0aZ8v8SX0o1lwKBi
         VZ1FBKQ6haqz4ISq5S1prk19z6/Aaf+dP7iNokWriUvF262eft3ebnNfasOhH2BG7UMD
         WsUZgqHgBdw7pWwe9KUovVUQdrUTw5npqft539vZVHXVuwJAtnQYxgmjBFC+kC9A77qw
         HX5hWKpxZReFqd1GJCZHRJTP+ZrA7zU0MCYJowLShgExlGhs2umvGi39M7I9CH+ijqmm
         Acpw==
X-Forwarded-Encrypted: i=1; AJvYcCVOlKsTzxlP/Bq5VLKy4fJgDfm7y/BY6Hjx0UBHqDfvUiShLRhPlEeu3jYwdWSoiqjI7dRF7gA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRkwm0U+XHP1DMQpGHEHhLBEbMHjqAV9D/sh30WadKNIa/QCRU
	J2NojjbsUrL8dY9HN2Pcd4xmZGdLgYRhJjIEaW6VCy1GbfB5CmFobbfuQHsLZ/VkANviXoXdxuU
	8Yob+KHe5NQz/XraKt9NQvW4leQ==
X-Google-Smtp-Source: AGHT+IGFAFvDi2PbexbAqauL7y5C7K4PGkXLqZnIMKzQ7KnS/pNLTbsU7lTkZfS0TlivdMxg6dS5ZH5rez4yi9e+5w==
X-Received: from oobbq3.prod.google.com ([2002:a05:6820:1a03:b0:60e:fcff:daa1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:151f:b0:404:2960:9b4d with SMTP id 5614622812f47-40b33e133bfmr396970b6e.25.1750968370241;
 Thu, 26 Jun 2025 13:06:10 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:54 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-19-coltonlewis@google.com>
Subject: [PATCH v3 18/22] KVM: arm64: Enforce PMU event filter at vcpu_load()
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

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load. If the event is filtered, exclude counting at
all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-part.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 5eb53c6409e7..1451870757e1 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -196,6 +196,47 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return hpmn;
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
+	u64 evtyper_set = kvm_pmu_evtyper_mask(vcpu->kvm)
+		& ~kvm_pmu_event_mask(vcpu->kvm)
+		& ~ARMV8_PMU_INCLUDE_EL2;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	u8 i;
+	u64 val;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(val, vcpu->kvm->arch.pmu_filter)) {
+			val |= evtyper_set;
+			val &= ~evtyper_clr;
+		}
+
+		write_pmevtypern(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, vcpu->kvm->arch.pmu_filter)) {
+		val |= evtyper_set;
+		val &= ~evtyper_clr;
+	}
+
+	write_pmccfiltr(val);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -218,6 +259,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	if (!kvm_pmu_is_partitioned(pmu) || (vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
 		return;
 
+	kvm_pmu_apply_event_filter(vcpu);
+
 	for (i = 0; i < pmu->hpmn_max; i++) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
 		write_pmevcntrn(i, val);
-- 
2.50.0.727.gbf7dc18ff4-goog

