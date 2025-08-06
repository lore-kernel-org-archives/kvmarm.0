Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24522E0408
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510329; cv=none; b=Fxwx4EqM8v5KU6egTJJCDNsXmRUFZUaA0emJZA/tBlEkfeplFgyJ3XUehc1zAZP7A9BE7S8/jiELas4Ju2Kg3NEiJ0NA9EcPzQ6HwKQCbIioaGepQ4c5/fdqS/4vdmviQBKJffX577w65JKpakMGSPW5BOqeIHbyAkP5/Ec8Lr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510329; c=relaxed/simple;
	bh=GASA5Z6faQfJd1EfEj5uOcxIVuCY+8w72a3NGzWBljs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uU20YlzaLUfyH2ahsmjyibllH9dWkO/VjMBGMgVMvsBQLobY4m7/bP6nMLUMkwi7HxpIp8Ge0X9/iD2P3PBvxNdc0oBIn91I6kPM75g76QMqcmaP9C5E64zNzOhi8tj+YGhFOXVlwAu7sVqWwOuPoY4Reo5glkqrT+zzyDD2l7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BYIxEics; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BYIxEics"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31edd69d754so283762a91.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510326; x=1755115126; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w80ZA8rn05ntQihJcNwz1pv2hia2ecTvLpbk0Bz9WXc=;
        b=BYIxEicsAqKYE1iaH9JC6NqIGuUyrbLjbi/BTyzra4iwm+FXKTCowODRrEAAH0X249
         SzPcQND1LgOFWPRxQQRkUnPc+/A+EeQ4DqkmxGVwwxmn9jD893QaU7hz5s8FlZwEugyp
         NiIxooA9DTo8pmB7bV5OtoOOKnFmvp1TsRbVGqA0Dp+brBo4BwRYxP3t71AKnsYFk2q0
         kKBWFzzbrdeCp9WiFEWE3tE2BPdmD+FTzXy/PitzqZKBGa1k/i4J7Q0Gsw5LlBpi1hVr
         8DO/p/vkcTl0oFFXCOrr402hgl3TE8MWVu0JlmRyYGteKJbMOjROBSo6YuiqENUEg4FF
         HxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510326; x=1755115126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w80ZA8rn05ntQihJcNwz1pv2hia2ecTvLpbk0Bz9WXc=;
        b=bDmoeyEmlWOj5auSq5r63/whtGBDmHMRc6nr+hGBihc1x2lvLZshk5QzF6jsSmVJmj
         FI/yqsuWsojL0s57SxJkvDqqauYXnZFkOWsF7ddhDqfnIwRpjFHpqsfF3gQJcgNrZ281
         CaMyrWegQ5VwCi+TuGl9scCLfEDLNorhgydPRhL2ti5Y8tiMG9Ss8kn7bbOnMNzsmCOo
         T3u4Je6DQ79yaodluzui9ZyEHhr1LOBX9r3XqpzM84LMWXtZjZbUY4/AnCLz2ufqqlpl
         LSxt8j22jmvyLr2LS79h6xuEB6X1YDgSyFVgW22U5RGFuna7w8iPDAJ09JED1AB8q+p5
         Ewug==
X-Forwarded-Encrypted: i=1; AJvYcCXH6qhjrP24sW6676IcXEoKNEOvcTi3SkS2IB/d/Gv1HNUE7B2Ez9XL4Yuzfnke8TLrO9V+n5I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAL2bTJzjBC4GiUBxjvdVb22wLRhpoAtHkyxxoH2dTW6dOHjXe
	XIfe4D0JQ/jYC3yvQH0r/sEe27Avw4o+iQ6zjFAM7ccbh1vL/6IXRmgkP6Xb6EFREeVHiNe60zM
	0sjeOTQ==
X-Google-Smtp-Source: AGHT+IEfElow/kZ7u4L92aZnG23Q7FLbrDYX2HxfWcS+XU7qHvCNVpRcocJ/y0Y5Vl+7RC7W7jz29DD5/48=
X-Received: from pjbdy8.prod.google.com ([2002:a17:90b:6c8:b0:321:6ddc:33a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2750:b0:321:157a:ee73
 with SMTP id 98e67ed59e1d1-32166e27ab1mr4925727a91.6.1754510326195; Wed, 06
 Aug 2025 12:58:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:57:05 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-44-seanjc@google.com>
Subject: [PATCH v5 43/44] KVM: x86/pmu: Expose enable_mediated_pmu parameter
 to user space
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

Expose enable_mediated_pmu parameter to user space, i.e. allow userspace
to enable/disable mediated vPMU support.

Document the mediated versus perf-based behavior as part of the
kernel-parameters.txt entry, and opportunistically add an entry for the
core enable_pmu param as well.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 49 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |  2 +
 arch/x86/kvm/vmx/vmx.c                        |  2 +
 3 files changed, 53 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 07e22ba5bfe3..12a96493de9a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2840,6 +2840,26 @@
 
 			Default is Y (on).
 
+	kvm.enable_pmu=[KVM,X86]
+			If enabled, KVM will virtualize PMU functionality based
+			on the virtual CPU model defined by userspace.  This
+			can be overridden on a per-VM basis via
+			KVM_CAP_PMU_CAPABILITY.
+
+			If disabled, KVM will not virtualize PMU functionality,
+			e.g. MSRs, PMCs, PMIs, etc., even if userspace defines
+			a virtual CPU model that contains PMU assets.
+
+			Note, KVM's vPMU support implicitly requires running
+			with an in-kernel local APIC, e.g. to deliver PMIs to
+			the guest.  Running without an in-kernel local APIC is
+			not supported, though KVM will allow such a combination
+			(with severely degraded functionality).
+
+			See also enable_mediated_pmu.
+
+			Default is Y (on).
+
 	kvm.enable_virt_at_load=[KVM,ARM64,LOONGARCH,MIPS,RISCV,X86]
 			If enabled, KVM will enable virtualization in hardware
 			when KVM is loaded, and disable virtualization when KVM
@@ -2886,6 +2906,35 @@
 			If the value is 0 (the default), KVM will pick a period based
 			on the ratio, such that a page is zapped after 1 hour on average.
 
+	kvm-{amd,intel}.enable_mediated_pmu=[KVM,AMD,INTEL]
+			If enabled, KVM will provide a mediated virtual PMU,
+			instead of the default perf-based virtual PMU (if
+			kvm.enable_pmu is true and PMU is enumerated via the
+			virtual CPU model).
+
+			With a perf-based vPMU, KVM operates as a user of perf,
+			i.e. emulates guest PMU counters using perf events.
+			KVM-created perf events are managed by perf as regular
+			(guest-only) events, e.g. are scheduled in/out, contend
+			for hardware resources, etc.  Using a perf-based vPMU
+			allows guest and host usage of the PMU to co-exist, but
+			incurs non-trivial overhead and can result in silently
+			dropped guest events (due to resource contention).
+
+			With a mediated vPMU, hardware PMU state is context
+			switched around the world switch to/from the guest.
+			KVM mediates which events the guest can utilize, but
+			gives the guest direct access to all other PMU assets
+			when possible (KVM may intercept some accesses if the
+			virtual CPU model provides a subset of hardware PMU
+			functionality).  Using a mediated vPMU significantly
+			reduces PMU virtualization overhead and eliminates lost
+			guest events, but is mutually exclusive with using perf
+			to profile KVM guests and adds latency to most VM-Exits
+			(to context switch PMU state).
+
+			Default is N (off).
+
 	kvm-amd.nested=	[KVM,AMD] Control nested virtualization feature in
 			KVM/SVM. Default is 1 (enabled).
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca6f453cc160..2797c3ab7854 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -178,6 +178,8 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+module_param(enable_mediated_pmu, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85bd82d41f94..4a4691beba55 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -151,6 +151,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
+module_param(enable_mediated_pmu, bool, 0444);
+
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
-- 
2.50.1.565.gc32cd1483b-goog

