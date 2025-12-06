Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364972F7AD2
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980311; cv=none; b=eGFd4Mx4SFDt8J3+6wIDiBKxzHMLLBzRFRrEngqrS7n6/UH6+dwuWkdplJb+3XRI756NgWLU6zZN4NFpGSSW/KmFdagVlAj0PyPeAk83yoovbSd6CVT40UmQoZ49812d/6g6a1q6v+q+f0mCaQiZEKWJ4+pBiOSjfI29/ZKFkEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980311; c=relaxed/simple;
	bh=jnmh0698KpE63YRCvIEZAjn7c1Lr7TEaV4sjEsIEpYo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qmaxf1tWcSeSXvShqyVNVKzKAgZrcr/NS2xqEHIqpvfUOd1AoIWX3LBvWoGqgFsVHZ/tTmk3DZzQ8MH90DvEMeA6DwbkLMPvIKrv+q1hTDcbQchiCa65MVFgzmRWaOTcpkLm+8BiMW48DP+epqDI1o1oe4Rn/8qmbk5N05/iGJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eXcA+L8C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eXcA+L8C"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f11bso4920366a91.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980308; x=1765585108; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4OfoQfKEgZFjrirIuizJ077/M4GdZrVaenba/hcoG9w=;
        b=eXcA+L8CDvuY1U60yD4TmTrCNGZGD3f8yPjme+Zp43bVUy4s540dq27k0Lkvor4+ik
         RpQg9n+NsKLGNLLI4IXADvefQziA1h8GGxI0CqW6YpIcssPNWCU14F9ElKS/YGZYYev0
         afdSZczzPOgfBLY1QKyZllV9NM+rdCz+zTb5PvM3JCm2iGDDKYy3zUQrwDpYV2FRT0z3
         QvIouVEnkYRsJEBXsC6buHY1heT8c0fM4y5JxBn/mehQwycZIVEVqOX0DS6D8gw4MzFP
         JJaJZ4O683QViQiP3JWwxvSj7mDyNNw/PZ57U0tJVY5gvwnO7ft+fWPwEOAG25U/Omqj
         pwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980308; x=1765585108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OfoQfKEgZFjrirIuizJ077/M4GdZrVaenba/hcoG9w=;
        b=FpCJLdnqqMkrhxAHip4gWt0lHV0glRadjTM/G6v6109wouCYWsJPb/3xNC/SC7sE0e
         N5GNgbvhCK/FO1fzRT4Y0z4+Zu35oUmqML3be0DoDYGtDZVK6bDxY3wU0Ud44NUeuIDT
         kOoAbTGTLq232CeDbDZ2aOL95R0iA8kzqJfv+UL2IjrB7Ok5DKEEZZfC/2z+D3yVmiGT
         MqzxNmkZZdhCfGCLLSLlRHV+Lrqr+GNeQNc9vtjPeR3pWZogiR+yQ812io5Cfl5kI3kR
         v5ltu1ukzYqYqUemvtvifMpw+7I/i+SxTKRwPAu5WabYIAQEhh9j/SvmUkEnQLblm2S/
         F8Zg==
X-Forwarded-Encrypted: i=1; AJvYcCVilsyGB0c9S6FM4vM8pOrKJW7LZKMVYVLQS4IorYEsHYVhoijeuqvEzA7mrBLn3eHXEogxqXo=@lists.linux.dev
X-Gm-Message-State: AOJu0YybFv3u9+sSzA6CF3mz4hnEVxaWeTh255z3HpaEkaK5abBEN3g+
	7+VrF+9jyqbE9Qr0k+FUX4Jlf2bmfqSApEFLs89H1iW0fILL1YV15318CGCothcVOmr2tLDksxZ
	dHBhJlQ==
X-Google-Smtp-Source: AGHT+IHbD7B9YeGH7Tmr7JOXchgVNBxwJK8eblPXJXnk4Y9Y/l53ndcM8z2+XQN6T6Xmq93leyEKMn8mhtA=
X-Received: from pjbcc9.prod.google.com ([2002:a17:90a:f109:b0:340:3e18:b5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec7:b0:32e:528c:60ee
 with SMTP id 98e67ed59e1d1-349a25b9531mr659960a91.24.1764980308336; Fri, 05
 Dec 2025 16:18:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:07 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-32-seanjc@google.com>
Subject: [PATCH v6 31/44] KVM: nVMX: Disable PMU MSR interception as
 appropriate while running L2
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

Merge KVM's PMU MSR interception bitmaps with those of L1, i.e. merge the
bitmaps of vmcs01 and vmcs12, e.g. so that KVM doesn't interpose on MSR
accesses unnecessarily if L1 exposes a mediated PMU (or equivalent) to L2.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: rewrite changelog and comment, omit MSRs that are always intercepted]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b56ed2b1ac67..729cc1f05ac8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -630,6 +630,34 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 #define nested_vmx_merge_msr_bitmaps_rw(msr) \
 	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW)
 
+static void nested_vmx_merge_pmu_msr_bitmaps(struct kvm_vcpu *vcpu,
+					     unsigned long *msr_bitmap_l1,
+					     unsigned long *msr_bitmap_l0)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int i;
+
+	/*
+	 * Skip the merges if the vCPU doesn't have a mediated PMU MSR, i.e. if
+	 * none of the MSRs can possibly be passed through to L1.
+	 */
+	if (!kvm_vcpu_has_mediated_pmu(vcpu))
+		return;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PERFCTR0 + i);
+		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PMC0 + i);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR0 + i);
+
+	nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_GLOBAL_CTRL);
+	nested_vmx_merge_msr_bitmaps_read(MSR_CORE_PERF_GLOBAL_STATUS);
+	nested_vmx_merge_msr_bitmaps_write(MSR_CORE_PERF_GLOBAL_OVF_CTRL);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -745,6 +773,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
+	nested_vmx_merge_pmu_msr_bitmaps(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.52.0.223.gf5cc29aaa4-goog

