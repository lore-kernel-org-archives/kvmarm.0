Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F61F0991
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980297; cv=none; b=OQgqv4TLExXDb2tHe+rBB6ejthiSAh43njYHJDvaiK3Ydt59ovnW6zjFJlrxV7YNwuW7Jsm6q1zKsRfP893sce5Qta91ktqTcr27pmHSXZKDDGOvvQep/kquflSVqbGcE0fKQKgbMWWsoRyM0jGO4j/KVICdY0SW2A9bA8bZ+C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980297; c=relaxed/simple;
	bh=Pzy06uwQwl662SZzAhKp4ZgGhpYEW/xfdtfXTkdDh0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YRaFBY9I/u2di0WvxyuA1lkY3AtC1l7eEXROXfgY24srpRpOWN+Xyu++oTQLWG6Vka9FlkxvLca2FZPNTmBRAgU7+aIOAjEZgeM1jr+EkvXEAMU89RU8snzbzCM7INSeSS2l7kK2WgYbDgnn7QWmfXMadKKyGbMjSBabckz6Pjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kEYnZJPa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kEYnZJPa"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34176460924so2633969a91.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980295; x=1765585095; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0NKuhyI73DcmRDf6dJr4Yp2dlSnDCvKYnr68Tztb6CI=;
        b=kEYnZJPaeaAPXh6XtTyh8iuMxkXeIl6jHoZtwOsnpXwcu/dwPJ4s/xwo1byE8QUapn
         smcIIjJD3xQDrq+5SrC3T8YSX/hu4Yl222F+MrHHOmAfqPRWVdeblxT+hk0mdptLPYhY
         G3FtDs3mAx6nlVZ4IyEc4ki8t9meIFTW8AYBff+Tlk38ovKEuO3TkgcnZjvUTh1mXhUU
         sBWulWlHbgWztORuUWUPDFKSGMLV6m/6SIRPV6NfWgFuL4aXmpOs8WQN1GNSEXOyAPfN
         yheuSvJpK/UHyVJzu42KWVndzAFYXQBpu8hKJXGbkE5rvXhZ4zwoxRFDEEPdAt48T0t6
         504Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980295; x=1765585095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NKuhyI73DcmRDf6dJr4Yp2dlSnDCvKYnr68Tztb6CI=;
        b=OzmW0Xgs1D6TiYYJpYu3qwarl6y1QQK+GmwyiSskhWq39FjCbe6W3EZbbWjfUIaJXP
         9n7fCraj1S7Esph028RLDs96W/kLLgPPKvxEZCeJiUmtuc0wl427BnVvBQWeN1idZXAi
         4gXwLH9ufAopkSvnOqI1XV9wwZ5i81Xku4OklEZlOESC1sLGPrBZDEgDIjX+3nWIpQpu
         PeavlsK6Yqy4WW7Vs9fBfl/kg+MgduPC//Vmt8loxESoKfZMRYV6rMtfad7hSs/Cm3tV
         5WKETex6t9kPnk256IRtrI17XjTpKOCEndA7NCtwkcvvjsO+SKY4SDMwwq0+eDQCjVxd
         q04g==
X-Forwarded-Encrypted: i=1; AJvYcCU59hog7rIxEJ1DUKNzD6lL+oo/tPUyrAXej8C1zqxVlgmEbSbAvUg3ND0GSJpAEeqC0T+HZjc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVRCeNgbpDgwkbAtPkFvp4shbruX0M4xdXz2ljF5pAjrNooz4a
	cXW8ObTPv8o7sHoDl06FFsZpOEFfWPpH74/XiX5ixi/riaKAyx+EuPA1LFKxIua0xtzluBq7WOn
	VwtBajA==
X-Google-Smtp-Source: AGHT+IEu368Ymit6Wf714y2QoU1WaQ4whiXftg8ijTgUsFOrrwNXh1LyvlB+ZwNskFSucsIG3f0JlRtM2cA=
X-Received: from pjoa4.prod.google.com ([2002:a17:90a:8c04:b0:349:6296:2bb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc7:b0:340:d578:f2a2
 with SMTP id 98e67ed59e1d1-349a252b381mr638790a91.6.1764980295195; Fri, 05
 Dec 2025 16:18:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:00 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-25-seanjc@google.com>
Subject: [PATCH v6 24/44] KVM: x86/pmu: Introduce eventsel_hw to prepare for
 pmu event filtering
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

From: Mingwei Zhang <mizhang@google.com>

Introduce eventsel_hw and fixed_ctr_ctrl_hw to store the actual HW value in
PMU event selector MSRs. In mediated PMU checks events before allowing the
event values written to the PMU MSRs. However, to match the HW behavior,
when PMU event checks fails, KVM should allow guest to read the value back.

This essentially requires an extra variable to separate the guest requested
value from actual PMU MSR value. Note this only applies to event selectors.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/pmu.c              | 7 +++++--
 arch/x86/kvm/svm/pmu.c          | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index defd979003be..e72357f64b19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -529,6 +529,7 @@ struct kvm_pmc {
 	 */
 	u64 emulated_counter;
 	u64 eventsel;
+	u64 eventsel_hw;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
@@ -557,6 +558,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_hw;
 	u64 fixed_ctr_ctrl_rsvd;
 	u64 global_ctrl;
 	u64 global_status;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 621722e8cc7e..36eebc1c7e70 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -902,11 +902,14 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 		pmc->emulated_counter = 0;
 
-		if (pmc_is_gp(pmc))
+		if (pmc_is_gp(pmc)) {
 			pmc->eventsel = 0;
+			pmc->eventsel_hw = 0;
+		}
 	}
 
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
+	pmu->fixed_ctr_ctrl = pmu->fixed_ctr_ctrl_hw = 0;
+	pmu->global_ctrl = pmu->global_status = 0;
 
 	kvm_pmu_call(reset)(vcpu);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 16c88b2a2eb8..c1ec1962314e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -166,6 +166,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
+			pmc->eventsel_hw = data;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820da47454d7..855240678300 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -61,6 +61,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;
+	pmu->fixed_ctr_ctrl_hw = data;
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		u8 new_ctrl = fixed_ctrl_field(data, i);
 		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
@@ -430,6 +431,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 			if (data != pmc->eventsel) {
 				pmc->eventsel = data;
+				pmc->eventsel_hw = data;
 				kvm_pmu_request_counter_reprogram(pmc);
 			}
 			break;
-- 
2.52.0.223.gf5cc29aaa4-goog

