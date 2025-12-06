Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2202DF138
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980307; cv=none; b=jriaDUiVWoONvbrVGedPeSnIZk4FBJ39cnotqxBihuJU5RpJKThfDEIY86qGQKXmc4mBSshPygeQ1AF8GJvpNU8xztywUtP4RbwPiJCCMEVO3AV/10I9nGxQANX1oT4MMMAjF7yNnQmoRdjdJMspJSmwUsHtlXdVo58aDnFHE5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980307; c=relaxed/simple;
	bh=Yx2occF+Cc2oLfxL/Kkyww9HN7cAnhXtGyaYNERA9Ks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6C6mHZHFQcEW4gfCcCs2QPSPNUjkZKapwf9I3n1vwvRCBlWFc6en2mKVBscutt4/VznBJOWqeE4l69uqzwK1OOcFXjLG5+3dqCbuOV+DDX1Sra71feKXk9XHBWaD1alO9mP/ThW5m1uSz6iRjDI6PoacQe+DEwkRFxG+rFwHNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4n6g6v6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4n6g6v6"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4734945a91.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980305; x=1765585105; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VDZ6qvbhnxeB/xicU22NIlKKbEtAofiGZXasyTcZTcc=;
        b=W4n6g6v6Rat11fGOl1PJaABMBvoMk4Mytc/et1gW8NhfOf7HW9OU10EwhFKGkp1nNO
         iSzYv3pRhdw8kH9eL0YEzbT0UCE7MO79A3G7qUOdnzPlb8apKOIBL9GY7oL0Ek3+lSc1
         06Q/YzHmW6PuCHjoICJCF+bJP7sFWRHq+rX7aUbnL6iTc3EaJPLc6hZYNjbaHcjGPBdD
         hwgBt/d29T3IcDdIxXF+DiS3V8PRrIzFw4nO56+gSZU29ivYth3ivTKs2/sRqUs4YTxr
         WXElqmQS2ewcD4Loy/B34WRFvEREO1cpkBcsBLT1pQU+YXUOoh13wuBcHAgZTkZtMlLa
         Mujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980305; x=1765585105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDZ6qvbhnxeB/xicU22NIlKKbEtAofiGZXasyTcZTcc=;
        b=go+S86NM3I9wTQbbBwcmuYx9glKkTQCTHbIKUrrkuoBaUqVy3ye8kZ3NRKzqgyHTCq
         QLlf/dtnjScrxXX1isLDqtXwh50sVmvzOOmzrU1FXlOMXJKJh+/h+3R8bh5Y3rSHvs6+
         O40Jt4UXrLN8oPKWBf2RATxI5pdcSAfpRuowvh4p2hKIaMWgMF4uqO3ATexhM8rn9mBr
         4bQ9kMoN5ZQKGsMhjJbLupAQ0PRJ83M6XD9rcnx+E1xWK4LHoJtgAihBX1Y9O67zAuda
         hIE3gI5LueeuUylsnGSsz0QvP1zTH0cb45Bu4Jjot+KnNy6+6V+8sqlB7935LPzs/IAT
         +htQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjoIpacbl6rxCGDWBOK0/LFdg6pmmwMjiv+vIT8hU635ohNjDjI1/BqEH2RQGUvKWlKjiWaTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbiCA/I6xB8wukl2OixPEqoxnVEOEcQhnESntpeVDwITJPWb1A
	b/Q+SytcZ0Kbz6tvLeRDXRLSk3me2AXestGzrfS5Kl3Cgozmrl4f7Hp7r0wzn/HJ/ubsMU2yllF
	PUcERHg==
X-Google-Smtp-Source: AGHT+IF4RzpEBka8aK0ucRE2Cm9e095W8Dm56/F1owL7T0nm81v+pRoWT+IrKx6iUc4yDzdsBycmMqAWYnk=
X-Received: from pjuy11.prod.google.com ([2002:a17:90a:d70b:b0:340:3ea9:30bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5905:b0:341:761c:3330
 with SMTP id 98e67ed59e1d1-349a25bd8e0mr687187a91.23.1764980304689; Fri, 05
 Dec 2025 16:18:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:05 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-30-seanjc@google.com>
Subject: [PATCH v6 29/44] KVM: x86/pmu: Handle emulated instruction for
 mediated vPMU
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Mediated vPMU needs to accumulate the emulated instructions into counter
and load the counter into HW at vm-entry.

Moreover, if the accumulation leads to counter overflow, KVM needs to
update GLOBAL_STATUS and inject PMI into guest as well.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 578bf996bda2..cb07d9b62bee 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1033,10 +1033,45 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+static bool pmc_is_pmi_enabled(struct kvm_pmc *pmc)
+{
+	u8 fixed_ctr_ctrl;
+
+	if (pmc_is_gp(pmc))
+		return pmc->eventsel & ARCH_PERFMON_EVENTSEL_INT;
+
+	fixed_ctr_ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
+					  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
+	return fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI;
+}
+
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	pmc->emulated_counter++;
-	kvm_pmu_request_counter_reprogram(pmc);
+	struct kvm_vcpu *vcpu = pmc->vcpu;
+
+	/*
+	 * For perf-based PMUs, accumulate software-emulated events separately
+	 * from pmc->counter, as pmc->counter is offset by the count of the
+	 * associated perf event. Request reprogramming, which will consult
+	 * both emulated and hardware-generated events to detect overflow.
+	 */
+	if (!kvm_vcpu_has_mediated_pmu(vcpu)) {
+		pmc->emulated_counter++;
+		kvm_pmu_request_counter_reprogram(pmc);
+		return;
+	}
+
+	/*
+	 * For mediated PMUs, pmc->counter is updated when the vCPU's PMU is
+	 * put, and will be loaded into hardware when the PMU is loaded. Simply
+	 * increment the counter and signal overflow if it wraps to zero.
+	 */
+	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+	if (!pmc->counter) {
+		pmc_to_pmu(pmc)->global_status |= BIT_ULL(pmc->idx);
+		if (pmc_is_pmi_enabled(pmc))
+			kvm_make_request(KVM_REQ_PMI, vcpu);
+	}
 }
 
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
-- 
2.52.0.223.gf5cc29aaa4-goog

