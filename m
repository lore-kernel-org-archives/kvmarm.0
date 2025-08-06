Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948E02C324E
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510275; cv=none; b=bOicuL44B28k3TOL9KVbzE/ksNh971q0iFgH1qNgG5C5wth7Wo8Y7RwbX4+A2151dO1Tbij8b8p6HMdDwRIMT/EPaG1pKkzkpIurRwGty+TjwQpaB5bJ+oM8F4SSpniVJtFfkNEvVLSXTILupKTThKH7m4OLj4NZGlzaDpfOwyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510275; c=relaxed/simple;
	bh=Bb1MCKlidS4HUVTcCu642tswWStbNqiXpa6NcxDtYbk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1DtcuNBAubEhYh69VQnnMmV6ydtsMbL2KwLMPV6081xB8Bq3moDWyGPABjy6jr9xbVrl+xAzujitpn3ToQN/hmBckQd2GMgExPdxIvMqAzI6HdR14W1IIAPQUH5xYU1tpa9mAm7D8U5ELXX+3+qeA4cj/Xqllw6DcJJM0RJ2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kc6wZitx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kc6wZitx"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ed9a17f22so517958a91.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510270; x=1755115070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P+6kUSR5aBTgNcunERrWOcQMCZiG0moZeRQ0turCJ94=;
        b=kc6wZitxTVa9BT7av903Hc4FobiyezwTS3tUoAHl61WNZUgdQOkrs+p2aK3ufeyLAA
         G0n8F9dLueUoDSqXh3I/wqJk6m0nMEwOPSMJbj7Iwj0W1EG+J81OxqobnQNq7wBjcWiw
         UdjuJAbjVMxaFaA+leJ6Cw6WOBTKcP6iaHHJ/x9sZCFUHVceb8fS8uLtLo6ewF7Ip9DH
         G+WmiNEOldRPxzfZxEAfBtd+0mFJR8fXGcyjeHkyGMERQKAaKtkBS158MykEl5B02eeJ
         i0V9fTuW0Iei2aQkrpeBohTS3CqqtyiRIABzZjATZOcPi2xTWgdKz5FEAhuNINw2Udog
         jEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510270; x=1755115070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P+6kUSR5aBTgNcunERrWOcQMCZiG0moZeRQ0turCJ94=;
        b=WH0V5nJDGvxaU476LQODFHIxQquKzbmirDZccPOSBe3UXejQbrHgi6K1mwYrbBJqBv
         FlANdavacSTNR/cC5XEAncNRr3zTVwhcnb/V37793z8OZyjI+XZnyrYHUhI1Sr7Zmphy
         0MgZfkhsaSnpk/b3jiZS93uNNH0xIO2D1BBs8vRQDHTuOfldxelvh0N+cL3xx3X/D84r
         m8sGF7mg0+KiRBcJD1N3djWE6jWXH0Z6bppZtfLniY2Xd04K9EVAo3/y/RjP5hNnfwei
         zmiiQ9qWlODho70uaaX0OLl7pbf+CY+SEVyI7/c0wWlXH8FPPLA40nY7L+0GzKqurmBQ
         oEMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7WzOt0NMql49ASJ8kQmFVrj/m5mZjK3m//xXjujZqd+VlTpVkrheZVp2fT2sfT4AWvRjNbZE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ8tsYa5rtRfkf92iK4yki73PD55JV45UVuOINuvo9jJff7/Q9
	l+06nKxUP8q2XHWTF8iIKawAxl3fqi1+jryMhAlOD4Ehx3bVsMAsxolCyzBYiilVYmZqAC9vSNd
	ceSccOg==
X-Google-Smtp-Source: AGHT+IF3NS6j+zPTC7HBpb/PhEo054/sULoDCrTNDdSbB3JBoD67HO9NJP/SyaYTvqhMXFbG0IGQUgBSmnM=
X-Received: from pjbeu16.prod.google.com ([2002:a17:90a:f950:b0:31f:28cf:d340])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7d0:b0:312:ea46:3e66
 with SMTP id 98e67ed59e1d1-32166ca3f0bmr5365514a91.21.1754510270478; Wed, 06
 Aug 2025 12:57:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:34 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-13-seanjc@google.com>
Subject: [PATCH v5 12/44] perf/x86/intel: Support PERF_PMU_CAP_MEDIATED_VPMU
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

From: Kan Liang <kan.liang@linux.intel.com>

Apply the PERF_PMU_CAP_MEDIATED_VPMU for Intel core PMU. It only indicates
that the perf side of core PMU is ready to support the mediated vPMU.
Besides the capability, the hypervisor, a.k.a. KVM, still needs to check
the PMU version and other PMU features/capabilities to decide whether to
enable support mediated vPMUs.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c2fb729c270e..3d93fcf8b650 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5322,6 +5322,8 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 	else
 		pmu->intel_ctrl &= ~(1ULL << GLOBAL_CTRL_EN_PERF_METRICS);
 
+	pmu->pmu.capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->cntr_mask64,
 					  pmu->fixed_cntr_mask64,
@@ -6939,6 +6941,9 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
+	/* The perf side of core PMU is ready to support the mediated vPMU. */
+	x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_MEDIATED_VPMU;
+
 	/*
 	 * Many features on and after V6 require dynamic constraint,
 	 * e.g., Arch PEBS, ACR.
-- 
2.50.1.565.gc32cd1483b-goog

