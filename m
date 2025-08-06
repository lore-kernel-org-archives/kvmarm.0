Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE472D660F
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510307; cv=none; b=EP/6z3up+67DgyEL+bofS5gldKfYFOh5I6UgJ5NOyDAjfnbZlE108Yj4D3j6/ymw5GQLOzqFx8ZPcyX4WKu/k6m6vh2p+/Kc+2ibn4CKrVvUedBtwqvLcJrIuaBEcRvRpU5OOkXeLvwhiyf69ShzfCEIfOh1x+oFmxN8oWYlzSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510307; c=relaxed/simple;
	bh=meRueoJoecSOLM6U35RVopVJ4WkffubPgWqswgDoiXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lj82jX7WLnHTKgmGkErP8pxQCEjWELOPGnWPmKT0h+s6MKer2BlhLZ09VRFJQnBX5fS7JRqwpuYUSQvICw8MUMdHlD0JsrOpTGEbGfnNoJNoFXe8FFQwElLWo1DjplkPveqwbRvUS/c3xRLpbUS6M7nJhOaGGDRN1lSF0ytXa/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UQg1wTmO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UQg1wTmO"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f32271a1fso373197a91.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510299; x=1755115099; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YQRjFPIG4PmR+HjiezlmfcX2mvV34MtTdW3Bam7UEwE=;
        b=UQg1wTmOp2xicS9bRaIHCVUBzKF2bljp0ejSlZntFnPwIepJMhitHp+d1Ioi8oq3cd
         Gm+bH7MqLXA0eX57uDh8WXoL17EA2Mzb2VN88XOh9L1DVLgwZTzVNe6NS9KX87I33M1+
         kbGEUKHIDDdMR2n5SvCg2NBs6p+qRkkoYzbUj6nKHdVpSxR/qzudVoigesT500FVrprJ
         XFOMDENCmM+YuVWxonAEGMpBrNu7orVPM0uIdflOKUoroUNlXI0jJkeHz5qzqMvG3Iz0
         O1+XuSwCdKh8fEx35LO1sN8V+FIMBUjEx8iO69POnt31uzLExBpIgUs/84GsOEqq+8NW
         I+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510299; x=1755115099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQRjFPIG4PmR+HjiezlmfcX2mvV34MtTdW3Bam7UEwE=;
        b=Zf/Xxn5pM3BmZwzWXclgbhJMLp++re0CLAzKCE7j7clwV58m2Y5Em/ULbWNLoBsGEk
         7hYnyYV5RS4f4xQ44z0CZs1hg5FdHrkUvf3fyHj5DURfg9hsdKs2fNmGt9OTf+fQi4n7
         Ipy/G0MRZYBz+R7wYx45Wo1UsmpwiY9JlVIIIXP1Vskul7bmvGJ+y2/cYA5FFZNEKQiM
         wDJGDhWgwr0Gl7IOtRDo7NHmTdEl7sLxwA9G9qus75zPpZi6J3NaoH2LbqLtonUzIUce
         cEspvLqwnlYE7lTlZRWpNqwDGK95mRA71ytkUGwylBO7+HYZ5JTQ/7JcuNT+3WOH+rzr
         +VZA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/sReyJY65r80PHhy6myFitZc690GmSBLo6Ybww0CXprZK+roJcW4Bg+pZG1VdiXS+6cfxL4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXCuQRhD4oL4WSLxWFhWO/3qe7aTLTtHAkgCkkKaRD8eVDq57d
	wJfcwEN6N4Wm/DLt2derJ04uppfRRTRJhHymUTnx0UO20ZL89nTjop0gn5ro3MVOP09n8vH8QUE
	+NUgsyA==
X-Google-Smtp-Source: AGHT+IEEL8MMMXuPjd0UTQ7B+xCdzayxBbFfQWod4bTn8hh+ljNhk+I3PdaJAFaKAxfSi5B+qkz2qkDbG+c=
X-Received: from pjbqb13.prod.google.com ([2002:a17:90b:280d:b0:31f:61fc:b283])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390f:b0:314:2cd2:595d
 with SMTP id 98e67ed59e1d1-321755de480mr997552a91.8.1754510298596; Wed, 06
 Aug 2025 12:58:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:49 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-28-seanjc@google.com>
Subject: [PATCH v5 27/44] KVM: x86/pmu: Disable RDPMC interception for
 compatible mediated vPMU
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

Disable RDPMC interception for vCPUs with a mediated vPMU that is
compatible with the host PMU, i.e. that doesn't require KVM emulation of
RDPMC to honor the guest's vCPU model.  With a mediated vPMU, all guest
state accessible via RDPMC is loaded into hardware while the guest is
running.

Adust RDPMC interception only for non-TDX guests, as the TDX module is
responsible for managing RDPMC intercepts based on the TD configuration.

Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c     | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/pmu.h     |  1 +
 arch/x86/kvm/svm/svm.c |  5 +++++
 arch/x86/kvm/vmx/vmx.c |  7 +++++++
 arch/x86/kvm/x86.c     |  1 +
 5 files changed, 40 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 680523e9d11e..674f42d083a9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -712,6 +712,32 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	return 0;
 }
 
+bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!kvm_vcpu_has_mediated_pmu(vcpu))
+		return true;
+
+	/*
+	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
+	 * in Ring3 when CR4.PCE=0.
+	 */
+	if (enable_vmware_backdoor)
+		return true;
+
+	/*
+	 * Note!  Check *host* PMU capabilities, not KVM's PMU capabilities, as
+	 * KVM's capabilities are constrained based on KVM support, i.e. KVM's
+	 * capabilities themselves may be a subset of hardware capabilities.
+	 */
+	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
+	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
+	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
+	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
+}
+EXPORT_SYMBOL_GPL(kvm_need_rdpmc_intercept);
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e038bce76b9e..6b95e81c078c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -238,6 +238,7 @@ void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
 void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
+bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ef7dffc54dca..2d42962b47aa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1075,6 +1075,11 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
+
+	if (kvm_need_rdpmc_intercept(vcpu))
+		svm_set_intercept(svm, INTERCEPT_RDPMC);
+	else
+		svm_clr_intercept(svm, INTERCEPT_RDPMC);
 }
 
 static void svm_recalc_intercepts(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index baea4a9cf74f..2f7db32710e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4121,8 +4121,15 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 */
 }
 
+static void vmx_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
+{
+	exec_controls_changebit(to_vmx(vcpu), CPU_BASED_RDPMC_EXITING,
+				kvm_need_rdpmc_intercept(vcpu));
+}
+
 void vmx_recalc_intercepts(struct kvm_vcpu *vcpu)
 {
+	vmx_recalc_instruction_intercepts(vcpu);
 	vmx_recalc_msr_intercepts(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69f5d9deb75f..b8014435c988 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3793,6 +3793,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.perf_capabilities = data;
 		kvm_pmu_refresh(vcpu);
+		kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 		break;
 	case MSR_IA32_PRED_CMD: {
 		u64 reserved_bits = ~(PRED_CMD_IBPB | PRED_CMD_SBPB);
-- 
2.50.1.565.gc32cd1483b-goog

