Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBF34AEDE
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513656; cv=none; b=fFVvlZobBYuR3yNH1Rbs1+5Dx3klOen/+TcURh9CErEgUum6mTqvCP0mAqAIfmQQMQNNMra82C+kGpOuEB9xJRxnkNoGJvP5oP8LQV42Jwf8k1JdUC+2jnGoDDRUXmam5VtC35idgH+fxbZJ2jxAZza4Da4ENLeHpwxDa9yjut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513656; c=relaxed/simple;
	bh=8rD9wBUo/5snYSuoYPelNQd9vwyGo/bcQLo1bUQyRrc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jyvbu91xak2T5N67x28wHbb2v3GVxlqOwGWE2lCpVyzCHIXtfda9T21u7LmTiov4JM3wetk1mRI4gNfri/mSzsSdfOU0aeTQya53QPNKvONUJzaOztJj4qc1BQe//6qaS8Pcf840HyFKeH7yrSyW2OS9CpvsyiZzgLlMobbiA/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mvxtOBw8; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mvxtOBw8"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61afae89be3so35184447b3.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513654; x=1714118454; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7c+YIi/ETVXIkqMQI843I4DVlJrHzSbRKUvXWHzl1E8=;
        b=mvxtOBw8DflVSMr8qZCUBjUNGS8KFLMxQWNCPRpeUxse0S5GETcD0WS0emLD0e1MEu
         RYi/uw6BSvqk8/L+F1DfEEGCa4nrPsl4/5HHTK3aM04OLJ8zCGlm5B5kD1EvNOhSVwmz
         gT6Ck6rrFKbacLt6JSnSCQus6tjmz6tm4Sv3ksXC2TBFWXsvtfJftP1RfmqmqA4t+J8l
         WpxwpvYdQja3P/ClgNi+ybfAnGHPBd4kLMiZ0t+l5JluvjJlRjRInWDFteYJCqPqgeHF
         h2fOnCxsd39XcDfzoQtiis15/GIqZ40nuADYrJhCMOWxpgSRgaCh7rkF1LCKA5nTG+zD
         bsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513654; x=1714118454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7c+YIi/ETVXIkqMQI843I4DVlJrHzSbRKUvXWHzl1E8=;
        b=O8gj4FYKrJ5XUYqSdzCDpBe5oX5jZnO9wYTk+3o/g8yogxwpp6qrLJ+oRy3ICwmj/X
         k2dr8UnMyq5mFZ9v1+FZNNbKj2J++BlaplamkKcsOsRnrn4YC6SzKK40rpZBynJRvvil
         0MyQmtMKIdW0fk8hoCBgmmyY+nIJNbyUisJ5xWKVgCg9OOI/LKlEkGfSfd5dHQdTsQyf
         4awQI+UD/q8qIty9lZ6pTW84hq9tMM8KiSJzh+ADLX3cZW5sLPjVekTNeNzwDd4Hb1O5
         VCnf7s+0hqYVui3Vb4NlTg01GKEz6kBoNSxClHfvatqq0GEM5wrhr2h44MysHZ3c7fzN
         eXgw==
X-Gm-Message-State: AOJu0Yye8IkdIgykIeSEtte/dz0h7orchrfvgknsd0GECxULFohJrpbC
	XoflMj3jn0GmT8SlhQIL6TZQWFowOhdzES9NPtD+Fa+RXfCG51bndRSdKNuDVx1idx1hnNHk8Lw
	kXZles2dkxbt7VQ+N/DvCjY1BawNhH0nS/72iWaUMHPRPp7clmrsOy2ITCg2gZlKzfGl5HzfAZf
	RGOI0smJFBz6VHKXWcyPlfkUuqxCA=
X-Google-Smtp-Source: AGHT+IGYhiau1UKFEZ5/M20QuWxPHIxibjCp5lBTZKkzigC6x4QMcKC2VeEk8atKuKD4ojnU9n08FqMh0g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:eb4f:0:b0:618:832a:8155 with SMTP id
 u76-20020a0deb4f000000b00618832a8155mr328415ywe.8.1713513654311; Fri, 19 Apr
 2024 01:00:54 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:41 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-32-tabba@google.com>
Subject: [PATCH v3 31/31] KVM: arm64: Force injection of a data abort on NISV
 MMIO exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

If a vcpu exits for a data abort with an invalid syndrome, the
expectations are that userspace has a chance to save the day if
it has requested to see such exits.

However, this is completely futile in the case of a protected VM,
as none of the state is available. In this particular case, inject
a data abort directly into the vcpu, consistent with what userspace
could do.

This also helps with pKVM, which discards all syndrome information when
forwarding data aborts that are not known to be MMIO.

Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
protected VMs, and document this tweak to the API.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 arch/arm64/kvm/arm.c           | 14 ++++++++++----
 arch/arm64/kvm/mmio.c          |  8 ++++++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..b11b70ae137e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6894,6 +6894,13 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+This feature isn't available to protected VMs, as userspace does not
+have access to the state that is required to perform the emulation.
+Instead, a data abort exception is directly injected in the guest.
+Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
+queried outside of a protected VM context, the feature will not be
+exposed if queried on a protected VM file descriptor.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66301131d5a9..750386a84968 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,9 +80,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
-		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
-			&kvm->arch.flags);
+		if (kvm_vm_is_protected(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+				&kvm->arch.flags);
+		}
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -237,7 +241,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
@@ -247,6 +250,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = !kvm || !kvm_vm_is_protected(kvm);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 5e1ffb0d5363..75e1072948cd 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,11 +133,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
+	 *
+	 * In the protected VM case, there isn't much userspace can do
+	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
+		if (is_protected_kvm_enabled() && vcpu_is_protected(vcpu)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.44.0.769.g3c40516874-goog

