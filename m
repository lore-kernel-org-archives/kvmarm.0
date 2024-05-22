Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC021CAAE
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342024; cv=none; b=JO1kJOysdWw+dNPafE382hYuF/HTjQeoZf4uYpKNAbtbjsS+wpX9/G2aLrfhnOTvhze6YLNbrtmT7zdQQtIRB93haByTUPXz/uVkkWvDYpQqkkH4t5FpBq3h8l0TlwXbR3lgcJedEZ6fN8zBxeYdEqNGzJJNSOjPvGPdls+lY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342024; c=relaxed/simple;
	bh=SZyLjBDPVAa/D0KwpeqI+MBejZ+xXEeWM4HL4osCdxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bmWjoBHFLeyjK7hyugbI5Ndw+72CbbHOUpZXzg8I0VZiWA4cozyEaElKeeWc3Uz2lQZDqE88EEQvhQG89ZoxQHRuVc5gvtxc4lvQCMh1Civ0XmvuL5CIC7erhRGi28V7idf+gGT3+S2aq63zJfMIiaKCiIn/ZiUOFKUox9hUXTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h2tkEdCc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h2tkEdCc"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627956be166so90209057b3.0
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 18:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342022; x=1716946822; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ky0OyQodlYj1lBm/FQov7vVQOSf0t15DeKBOaNpreRc=;
        b=h2tkEdCcLV4oefi0eVh7VOPpSLRM1JRpSz/Wkhsbbc1ZnzgLKHz27Ce9g7gfl0yw0d
         v/7cAel0cjF/mpNLtLUqdwqyVjrtQeXDodxYUgp1eEMr3OBp/lr8d7zgB3C6RydMGbfw
         ltvfWanh0DZ1o4vmv7VSlvJWdnCcbv75VxME8c76w5lNG3D5o+8kjAyoRTAPRh80DXQ+
         fmjk8iXy1Hkm1j6S4OZfOOWavqfA6kXHHz8PCun8b3LdHSoS3TtLUNJ4C62S37ZVvWHB
         15w0IyJHXzUbbHQ8+vDxRqdRRmkVOUx4pqaPIfsG1hb7yfZWpife847neJJBsfwVfm4A
         bftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342022; x=1716946822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ky0OyQodlYj1lBm/FQov7vVQOSf0t15DeKBOaNpreRc=;
        b=TKtWqNIbTu31G4gsiFs2dXWH+BabYFxVn/k4d0SnBCbsBHbEqgigJOyXuMF8/tkv7Y
         HtyQsYO0c4AfHK2enmvFTGgJO7cSfQtV1F8bL/hEzoh7D8JmzTryaddFxzqeMsfsL1Wb
         a1PyUxMTd4J4oCrmL1UfZj7XUOyeCXxbhAmZLA8xrIL+BE8m31eD26ShT9loFU6aRVeh
         9sFlLTqgCcCMknejIkkm4aXo3mIyTbUOmb+571IvCYlyPHC32ko4TLB9nGwa9YtzaV68
         8aPcyf/RPilxa/3gEVKZdDsiaKkp0SNin4ClXW4DukonxIVX/5ciUz+9xrPUhYZWvUrT
         XZGg==
X-Forwarded-Encrypted: i=1; AJvYcCW1GnZ9WoPypZrEyn6NpaPKMCTwuIQKUR8uU7UqjFqZHnLHrkQXyqNM2hpDsQ4TBh8XkikDuLa68SJ3r1nEzyXZtwQwSxyq
X-Gm-Message-State: AOJu0YzupSub29AfpOLWF/cbOXfH0GB5WsO6/LF7MzNQnMOOLfeyD+40
	kNiKLTkKOf3CvMa9bU6BCptqP+wovQamFGIus/TT5VMxzGXbXdS7PMQP3d8Env7F/tKKtP5VhsM
	IRA==
X-Google-Smtp-Source: AGHT+IH3ylTQdVbQjZOc6EesCmA9Xrxy9wlcjQn2SMB7bi30ktsJ//ZvCxppwijf1/jMZuHd3SCyhhC4bqo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:251:b0:61b:1dbf:e3f with SMTP id
 00721157ae682-627e46d457amr2201297b3.4.1716342021752; Tue, 21 May 2024
 18:40:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:10 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-4-seanjc@google.com>
Subject: [PATCH v2 3/6] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fold the guts of kvm_arch_sched_in() into kvm_arch_vcpu_load(), keying
off the recently added kvm_vcpu.scheduled_out as appropriate.

Note, there is a very slight functional change, as PLE shrink updates will
now happen after blasting WBINVD, but that is quite uninteresting as the
two operations do not interact in any way.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 --
 arch/x86/kvm/svm/svm.c             | 11 +++--------
 arch/x86/kvm/vmx/main.c            |  2 --
 arch/x86/kvm/vmx/vmx.c             |  9 +++------
 arch/x86/kvm/vmx/x86_ops.h         |  1 -
 arch/x86/kvm/x86.c                 | 17 ++++++++++-------
 7 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 566d19b02483..5a8b74c2e6c4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -103,7 +103,6 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP(sched_in)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aabf1648a56a..0df4d14db896 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1750,8 +1750,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
-
 	/*
 	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer.  A zero
 	 * value indicates CPU dirty logging is unsupported or disabled.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d0549ca246f..51a5eb31aee5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1548,6 +1548,9 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
+	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
+		shrink_ple_window(vcpu);
+
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
 
@@ -4572,12 +4575,6 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		vcpu->arch.at_instruction_boundary = true;
 }
 
-static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-	if (!kvm_pause_in_guest(vcpu->kvm))
-		shrink_ple_window(vcpu);
-}
-
 static void svm_setup_mce(struct kvm_vcpu *vcpu)
 {
 	/* [63:9] are reserved. */
@@ -5046,8 +5043,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.sched_in = svm_sched_in,
-
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c546ad3e4c9..4fee9a8cc5a1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -121,8 +121,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.sched_in = vmx_sched_in,
-
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07a4d6a3a43e..da2f95385a12 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1517,6 +1517,9 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
+		shrink_ple_window(vcpu);
+
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
@@ -8171,12 +8174,6 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
-void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-	if (!kvm_pause_in_guest(vcpu->kvm))
-		shrink_ple_window(vcpu);
-}
-
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 502704596c83..3cb0be94e779 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -112,7 +112,6 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_request_immediate_exit(struct kvm_vcpu *vcpu);
-void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_X86_64
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d750546ec934..e924d1c51e31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5004,6 +5004,16 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (vcpu->scheduled_out) {
+		vcpu->arch.l1tf_flush_l1d = true;
+		if (pmu->version && unlikely(pmu->event_count)) {
+			pmu->need_cleanup = true;
+			kvm_make_request(KVM_REQ_PMU, vcpu);
+		}
+	}
+
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
 		if (static_call(kvm_x86_has_wbinvd_exit)())
@@ -12578,14 +12588,7 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
-	if (pmu->version && unlikely(pmu->event_count)) {
-		pmu->need_cleanup = true;
-		kvm_make_request(KVM_REQ_PMU, vcpu);
-	}
-	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
-- 
2.45.0.215.g3402c0e53f-goog

