Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B042E11B3
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510326; cv=none; b=o76ov3ljbC5ODk7+zuVGkPJ07LZ5f7wCDLUDx+u6jINIgJPYTFwubTBLr4Dy0zSsCdW/wNdSNYtD4pumjZbENY//5wikuEpHLijDVG7X3AyAxAqzBTZbWNH4rbWUFr+5nuOfDWWsBFTb0Vuh7eVcbILuoKvWzkcnEEyEyXa8C+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510326; c=relaxed/simple;
	bh=xxEMYMafoH1hCuYfyuUxc0eXfBZ4HMKS++5sGsaBrpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJgpU5t+5p8Emrlvf20LL0ci7OOeMypJnC1zDD9E+AAw6x79pwSjVHKp9dQFMg5mXptpGDsRi36h5GKG9qWc6axvbPxSXIt7fs3k9mBBn4Jg30EhL6DZ87ZOoJSNmVFCVGGTE6e3y/dWZcUTvyvlNtkYE5rWpaoDfXLj7wtcd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQC3Fks1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQC3Fks1"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31366819969so380754a91.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510323; x=1755115123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AqSoz/ys0/nDwriVLA2HvcSasFXIo2nt11bZwmhw7W4=;
        b=aQC3Fks1GIQFmCJACRIe2fTk5//LbEJZF5ZNGbgQNizH7mgmEwsj7WXt9IdKoJZBiM
         dnim8ORhZmewD4dFBLuxUxELCufQFJBdh8uDBA6fM41qpvyjJJDxN0DWQH03UISkH8pw
         +ioo20p9aFNKHWsCjxPDdQhusEPNB7/3AL0nqgzy6WNQ9kGZGFIhXv50iGlXEQ1RnY1z
         hqWUpgcXgvxQUsXEjtbKppEdCrbP6r2kcMEXG3ILHaU72Nv5ULbReVGgneqEbNOjm/S8
         uhQ0cyHRRGJ55JHcKLASG0mu3vZgdGtxVqnRqHxGrImjblrYF+2WiqKUSrcsTurS7S7v
         Sy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510323; x=1755115123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqSoz/ys0/nDwriVLA2HvcSasFXIo2nt11bZwmhw7W4=;
        b=RBTve/104SmZOAJMpWs1wo8BIf6lkkKOFAccy9UmRoRr60T7HBzYCMdZnJ6R6bJh+L
         G/oDSrhRz0rugHtR2lInSmaj6Qe8t60SOYkiZYFVC9vSvO5v+Vl8N+akWdK1WGZlygXP
         8IhTWLQpmx9MCWf3P3wRu8Y/tB/2R7Rj7rUBFJPDNw8Xu1S9g8NqcMx3kNzcwxfE9US/
         RcXl27FPMWbNTPw61wJ5EdgvktGNwt4CC2+/EOcIm9RgoemwUAaaRPKaDP4GtJebuEV8
         EVd+gCuPHsSzqHaCnrCHVTZ8HWj2BlxqnW5veGZh5aKGO60wu2JtpGhw8xEJLwLydiE5
         IHbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXx7OpfZQgRNfLlitqxzI/9NJ9B1VReqySBa899ApIJwEqUqVFZPs9rwdp+oxxfpbECV1UWR+0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvMGY7Za5t68QikGowpmTJBZOfELsNpYJQGPxPRkSQGpiE0QIH
	IyPq8Y3I04hjcsBOujYFDEK/twcwBD7bq7EQySz99iP6iWHBIltL2BOBrIAZ1CFf09sCZ1XDAGO
	cY59WEw==
X-Google-Smtp-Source: AGHT+IFhegW1gGR7UHrSJevPOd3ITDk2k4F1jYjU8AgzTqj6JmCrtpCZa2eEdv34H9OVmz6MG3yGyWC8HfY=
X-Received: from pjbsx14.prod.google.com ([2002:a17:90b:2cce:b0:311:c197:70a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c09:b0:31e:3bbc:e9e6
 with SMTP id 98e67ed59e1d1-3217638fd88mr438488a91.19.1754510322909; Wed, 06
 Aug 2025 12:58:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:57:03 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-42-seanjc@google.com>
Subject: [PATCH v5 41/44] KVM: nVMX: Disable PMU MSR interception as
 appropriate while running L2
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

From: Mingwei Zhang <mizhang@google.com>

Merge KVM's PMU MSR interception bitmaps with those of L1, i.e. merge the
bitmaps of vmcs01 and vmcs12, e.g. so that KVM doesn't interpose on MSR
accesses unnecessarily if L1 exposes a mediated PMU (or equivalent) to L2.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: rewrite changelog and comment, omit MSRs that are always intercepted]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47f1f0c7d3a7..b986a6fb684c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -627,6 +627,34 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
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
@@ -724,6 +752,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_MPERF, MSR_TYPE_R);
 
+	nested_vmx_merge_pmu_msr_bitmaps(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.50.1.565.gc32cd1483b-goog

