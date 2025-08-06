Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD32D8395
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510299; cv=none; b=Fo0RmFfX1q6H4CfAqHxo5gkPFy8xAa6q3H+GN23qFgLgm4otFNiiXqecPFNmSpQRVwVID9ac1AMtjH2K4FM6sciV5b6UzC4/6GUM0eEEpfVTWtkbW7+BKDBF66uaDzWjpw0jODLZczNXZ+jKG3PCL7Lw8/jnsbEF8V9qJm/od3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510299; c=relaxed/simple;
	bh=wHmlJSVtwVaQD0ZM8WmfI3XDA8yD245AfBXY7EV2M10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gbO3bkmWuT8G0aA994K+jDi/EiP9/j6iQYT1LaTxTqZ1lOT2xvwFgEustFoi4OwS58dUMHl+v20HxCiEptc+Ul+rfocMHL6EZEHidoFUoQdVPeq5T0gJdKOwBQMIzAKAJEw2iSSy1dePZRbVP98kWsqepH9yb7IoXuFqQ3EdFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+/B+2MI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+/B+2MI"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b1ffc678adfso135964a12.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510295; x=1755115095; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7n78nD110ztSdGmfKKJPHep+PzR1j4ORmKnKizGjxcI=;
        b=i+/B+2MIJ6jXsqQo7AqKdrUVteUSYKn3U/x2mF9DvbSjP9r/1KQtvjR0+F9R3rIHHP
         4PkkNo6aF914yY5B4HN1nOZRYqmYzgMszbV7KIm8dZX0APkP2GgRySdwDzuX9SlpE9Ym
         mKRURdQUN/5p/sHNpHW3tQJfk8ArVFCiEZ96zgONDDWKKOHMt+LM4bXpdTV6YqCnzaJx
         FK+vbpecMBCzIt/gpn+CdIw0NkHXPIu6qhFHo3dtlNOY3opEnhtoULzEYcRX7VWCSFp3
         FRbQ14m6l6AqVXp3ojxp2eCnBUvlFe8y5H40chd2YfJc79LulRDkiAKOequNiA9beclz
         FdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510295; x=1755115095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7n78nD110ztSdGmfKKJPHep+PzR1j4ORmKnKizGjxcI=;
        b=jFUHVG5Py77BcV/FKhG2ZwiE0mM79BMJ1NrldpYFQ88Y6+UJRgZh63BitY/D2MY38C
         JmKt4NM0Tp6tAi8WlKuY+mq5jOxjbYvVC43hkDEZhE7PpJEaCweKkDOacnrt38PgK5pW
         E/NGzmAlBEvhYM9G9cPz+ZSBByQHtiP39pT0YeaC2Kyjpc3wsyw0UDKFaYDVUF0s1chJ
         KgeDRY+QPW0p/tOEDiYh8yzAb8tj5XXJOKIBeHLNKH8vkbpiL0IrsITNkPPDlQsrTLL9
         RKde7PAYi24FJfW6XNczuKKJo+zZALWH9FnTd4XIcmS1++hXXCI0CqQ6BYuxe7mxVfdP
         podw==
X-Forwarded-Encrypted: i=1; AJvYcCUawl5Xw9plhtYSnhgrl10DmbWyfWkuBtHJMz2yiaMg1ezN1Z45d1gXs4XFVmXbxvAAqnD+vCU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmyvbRxnEtmdQNFjzKhkih73roUv4YLLMh+HPCi/vslMVlvj/1
	2MagFxmf7VyV7IgFlD/+WbDJrJaAsV5Gf4DuQvMUtkHVjLEr4NUfWeOHyRTWfhb55zaEbIbA5On
	JfBDadg==
X-Google-Smtp-Source: AGHT+IFqf7ZAG29dPCj/MpatUq6hwXzWupLmSqVpNm34U7crTT1sTW/TFLrPZa6u05A4GwIlFGKGaClhUR8=
X-Received: from pjpy17.prod.google.com ([2002:a17:90a:a411:b0:321:370d:cae5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec8:b0:242:abac:30f0
 with SMTP id d9443c01a7336-242abac3c63mr29143805ad.42.1754510294999; Wed, 06
 Aug 2025 12:58:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:47 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-26-seanjc@google.com>
Subject: [PATCH v5 25/44] KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to
 CPUID updates
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

Defer recalculating MSR and instruction intercepts after a CPUID update
via RECALC_INTERCEPTS to converge on RECALC_INTERCEPTS as the "official"
mechanism for triggering recalcs.  As a bonus, because KVM does a "recalc"
during vCPU creation, and every functional VMM sets CPUID at least once,
for all intents and purposes this saves at least one recalc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 2 ++
 arch/x86/kvm/svm/svm.c | 4 +---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..cc16e28bfab2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -448,6 +448,8 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * adjustments to the reserved GPA bits.
 	 */
 	kvm_mmu_after_set_cpuid(vcpu);
+
+	kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 }
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d9dcc66a407..ef7dffc54dca 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1225,7 +1225,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	svm_hv_init_vmcb(vmcb);
 
-	svm_recalc_intercepts(vcpu);
+	kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 
 	vmcb_mark_all_dirty(vmcb);
 
@@ -4478,8 +4478,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
-
-	svm_recalc_intercepts(vcpu);
 }
 
 static bool svm_has_wbinvd_exit(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2244ca074e9d..6094de4855d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7782,9 +7782,6 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
-	/* Recalc MSR interception to account for feature changes. */
-	vmx_recalc_intercepts(vcpu);
-
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
-- 
2.50.1.565.gc32cd1483b-goog

