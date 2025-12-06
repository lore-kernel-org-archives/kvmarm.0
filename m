Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB493002CD
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980317; cv=none; b=Ix/9lYfLL0mozY1vT1HGIr+n2/jVZxmUVP+rwmHU+tJcnKf26QVFcJx8gB+Q5A7+8ACItoW4lFxWtWUtAd4WD78p+hgeZHw1EDzrc1BcwAiEZ04+VjNdAldoBKIq4o+PQ0dcnlT5qKF/NIpDv9L6FHKov2ULCuzQCwIvAnzCIfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980317; c=relaxed/simple;
	bh=bVIn0sl64UFZr8WJm9qTaFNmU6IY7pnSUpqJCc//7XM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A8nVVY+fD7WgcMM3M37rwCa6TOxz1oXIRl04gWPbfL+fBlU1Q8Qnd5tKhmXnY7RkWFrJGSyQwFaJUvPuWu+k89SKiQ26tL4LQ8g4V174zMGDDV8uDVi/KDLj1yCK4UuIEwEjVCHJV0WScjtqEGxO2+mL3Kqc7THGZqUfYaTiqwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=fail (0-bit key) header.d=google.com header.i=@google.com header.b=RXVNPN+S reason="key not found in DNS"; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=google.com header.i=@google.com header.b="RXVNPN+S"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-349aadb8ab9so104842a91.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980315; x=1765585115; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YVw2IrEv6dj1lN2Egcfs+/+7XHiKcsFRJtntJAtFFMc=;
        b=RXVNPN+SwYwy8udobzJFWBcucZUvUvkAPYW5gFxr+j760niobU9OVVxw/wFPghte6V
         HZKSUHAk0wmrWDSA1rPuu7ZJsU1BZgn29ps1xLDIMaLQZZlhsfnEE2UGaQh/rcGDKwU6
         Hbe8f+qss9pB3+ke1Q9CRIwkEku5Sr8qhmJuEjoTALFXUnyRwks/SM8YRpd2dhubiX4V
         eI0DbAmGI/ijq15airHQSL4pE0lVm+dMMCYv/7QZC56WJXq0C6tmygTHEIVgvVpyad3p
         YZKZUKQIbOTh/I6CE9zjVThtFdhmlQGx2wRc8Nsn9oJDL/7aItvb5fxGbW4xQcU4Gt4T
         hnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980315; x=1765585115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVw2IrEv6dj1lN2Egcfs+/+7XHiKcsFRJtntJAtFFMc=;
        b=FSAtGvgjvxbZs7u0MDXUjpdG0PX9bIe5SIEbRKdYdpMZVzJWBJyLQG2POVZvPKz1IP
         otgPoq33CdrMSqV1l2vbPul7UgBMw2/cLcVjewzlnbJWxqyFX4QeaR5cwpUzGWCiDlfC
         Bx03aCihHmj296wBdkhrD1XzG2TKXywhKkT77mwIbvNgBqlGeWwwiPAU+wuD2DPvIB8r
         YN+hpbs+NANEP00fPZUjNC+nvZ+7E14jYAoXnI78bBTFhoTxmltJmL4IeM80cLJf0tIh
         uVrp4UQjf35woa8NW/iEOusdOKQT3t2s8F+PC24e1jVDdpCZ1OCMgYfb80KjFkK+8nsj
         VZLw==
X-Forwarded-Encrypted: i=1; AJvYcCWMrFxrkH/AhNJT/QVyQJTebBdbcN8MbTqO/tycOlFmIInn+AZZbbEsuwpDgz8WL8QHVRnFF1E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/8hXfx8u0vAz0C7DAek2Y51ysiPUi+cj96c1kYMGZBLSSXSub
	PkHq1w8nCyXf5r7cQwweSByCM1Ct764tkXk+iTtjywTmdm0vrCT+7j4lpd3s3bw7WR/YOSY6dlX
	a3Qsw1Q==
X-Google-Smtp-Source: AGHT+IH5qbAxlC2vbzunodq4KUrEtCHMXaoxZK4q8nETSOlwObwaBJfEq5OV6dsDt0Oyzwdbj6cNRcmYmOA=
X-Received: from pjbfs2.prod.google.com ([2002:a17:90a:f282:b0:334:1843:ee45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec7:b0:349:9d63:8511
 with SMTP id 98e67ed59e1d1-349a25e3b79mr670940a91.25.1764980315199; Fri, 05
 Dec 2025 16:18:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:10 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-35-seanjc@google.com>
Subject: [PATCH v6 34/44] KVM: x86/pmu: Elide WRMSRs when loading guest PMCs
 if values already match
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

When loading a mediated PMU state, elide the WRMSRs to load PMCs with the
guest's value if the value in hardware already matches the guest's value.
For the relatively common case where neither the guest nor the host is
actively using the PMU, i.e. when all/many counters are '0', eliding the
WRMSRs reduces the latency of handling VM-Exit by a measurable amount
(WRMSR is significantly more expensive than RDPMC).

As measured by KVM-Unit-Tests' CPUID VM-Exit testcase, this provides a
a ~25% reduction in latency (4k => 3k cycles) on Intel Emerald Rapids,
and a ~13% reduction (6.2k => 5.3k cycles) on AMD Turin.

Cc: Manali Shukla <manali.shukla@amd.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cb07d9b62bee..fdf1df3100eb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1314,13 +1314,15 @@ static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 
-		wrmsrl(gp_counter_msr(i), pmc->counter);
+		if (pmc->counter != rdpmc(i))
+			wrmsrl(gp_counter_msr(i), pmc->counter);
 		wrmsrl(gp_eventsel_msr(i), pmc->eventsel_hw);
 	}
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
 
-		wrmsrl(fixed_counter_msr(i), pmc->counter);
+		if (pmc->counter != rdpmc(INTEL_PMC_FIXED_RDPMC_BASE | i))
+			wrmsrl(fixed_counter_msr(i), pmc->counter);
 	}
 }
 
-- 
2.52.0.223.gf5cc29aaa4-goog

