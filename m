Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB1E2DCF5C
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510315; cv=none; b=pJJ5+hsubOHcqxNKUpqeXnx+vMD8le+PUzCOlFPoj3EpesXdBXko0F8oJT2z4/ciQwmOsfBWfA/3uMW6yr2ZTiUULGkZnLmIJs5lFr4Wane9Vb7AFifxOFPFbucgbKsDl329sI3BjUsj1byZePHrE0K0kpWwD57i/wurndGn0j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510315; c=relaxed/simple;
	bh=4kQYudPfi5zx6gImzIgwc5QaKlQ7/lxrNTieFP93BO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vAbWcjGF5QXEFJ/p2kPGQBwVxuDToyPCmo8sqAsT8XJK5Xk3JzPOLDrOb65Ld/XDAXE6AFxtUsf1a3t9S8oQht4k4eJR76IiAh25iUfTsrfQLqqxvrrGrVmqwy+8YGcCIGHst3gAdk8YoaHRN7n2CJdalZe0F66l34tglfukKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3zGucY37; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3zGucY37"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31eb41391f3so293882a91.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510312; x=1755115112; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xm7g2YivXo6aQ0SA/h1DnHmIX017hVekqEmykFx3Fp8=;
        b=3zGucY37TPRqaYrKpvuVRrOax/JQU73/LMTDNkEsjXvM7KUjR/KiFRnTH2hlqXoFY2
         0Dv4RqQh7drBV0nklWFJMM2HhViCXDL+TPOrEWbMsmBFg28f98UD5EpzPSIaxWQATcKl
         djwQuqj9kc6xZIALaFohQLaide+VxeMGVaG+huvTdHDjQ+zHfxr0w6QaRcjZcUzywGPi
         AXta4VUYGKrFUxMLaEIc/2n/L0DMrcxiR8xtctiZuMG6Q9P/2WLoFumBPyXbzpQeHfmE
         UA6XwwhjxzgpINqSE8Ik55sb/cVw9kV0xXPjXjtxbHjU/N+ni2D9Pon/GYbJs0qtPsey
         1wAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510312; x=1755115112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xm7g2YivXo6aQ0SA/h1DnHmIX017hVekqEmykFx3Fp8=;
        b=bSAcBsvBPlbH6Mj91YM1SACsiqLYGwO9n861FkwwMIeuSs9InyoF+Lr4Czr92cXhjF
         YEgVVEjZSr2Dq7J0QO7xZhS3GeKm93OldCveCe89EP40JoS355HB7WOqzD5qNlikFFZk
         YUlSto6Vv02lUMrFrwAHO149haYpoCTSsRajAm2wgSGTcDcbRdKhZjCP0baVvzSGpLf8
         tqzRMa64tZ0eSlGsijVTvIAd7atILVUl20g7EsUu+tqMs6t/c0srw+7IIpRg7A7YUTpi
         Vp3HQFn6XTLS4NVAs7wpCVpBd2ndKkd+QTfvmbAUz34N51e+C/5w+6Z88WhZ/T9wPhD1
         YMjA==
X-Forwarded-Encrypted: i=1; AJvYcCWv4BFFO7Ohu1A8qJaAw94NRoqJZ6oY56yitB9xdMK4AROIqUolsGc5xreCPVn5CfBbvtzuqcc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJ0gMx+Mso/uCoxauMawbHlEgYVnwgRPajGkXSzsfNkysHDf5q
	Msf0IuirlklDiKa+XkSSLKjYYbS8Sj7y2R8lsFil9S3/6yFXnBuAlN3bO24vrBX18ipDB6j6Ze4
	0c2i9yw==
X-Google-Smtp-Source: AGHT+IEYZIIJpt/ZXd2reg+ZYe1ccOM3EaPSbjMXbuV7EDQKePHF+PpZ3A2kJS4xCp7zKjQzYF60hKA/y+o=
X-Received: from pjbok13.prod.google.com ([2002:a17:90b:1d4d:b0:31c:2fe4:33bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc4:b0:31f:867:d6b4
 with SMTP id 98e67ed59e1d1-321694b7c0dmr5279932a91.10.1754510312321; Wed, 06
 Aug 2025 12:58:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:57 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-36-seanjc@google.com>
Subject: [PATCH v5 35/44] KVM: x86/pmu: Reprogram mediated PMU event selectors
 on event filter updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Refresh the event selectors that are programmed into hardware when a PMC
is "reprogrammed" for a mediated PMU, i.e. if userspace changes the PMU
event filters

Note, KVM doesn't utilize the reprogramming infrastructure to handle
counter overflow for mediated PMUs, as there's no need to reprogram a
non-existent perf event.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add a helper to document behavior, split patch and rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e39ae37f0280..b4c6a7704a01 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -518,6 +518,25 @@ static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
+static void kvm_mediated_pmu_refresh_event_filter(struct kvm_pmc *pmc)
+{
+	bool allowed = pmc_is_event_allowed(pmc);
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_gp(pmc)) {
+		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+		if (allowed)
+			pmc->eventsel_hw |= pmc->eventsel &
+					    ARCH_PERFMON_EVENTSEL_ENABLE;
+	} else {
+		u64 mask = intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0xf);
+
+		pmu->fixed_ctr_ctrl_hw &= ~mask;
+		if (allowed)
+			pmu->fixed_ctr_ctrl_hw |= pmu->fixed_ctr_ctrl & mask;
+	}
+}
+
 static int reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -526,6 +545,11 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	bool emulate_overflow;
 	u8 fixed_ctr_ctrl;
 
+	if (kvm_vcpu_has_mediated_pmu(pmu_to_vcpu(pmu))) {
+		kvm_mediated_pmu_refresh_event_filter(pmc);
+		return 0;
+	}
+
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
-- 
2.50.1.565.gc32cd1483b-goog

