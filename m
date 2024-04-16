Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E7E82D82
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261501; cv=none; b=vF3pIG8dcW/blGSC4BgHePrWgzIj0rdE+euTJLoMWbOdhdC/NymvuuPxZ0wk5ciPuruw8KK7hesypNpRPD8xo2t7BdJNQOgoJ4LNONy9ao245bB3e6d/olmwkS+IuumWmX/GB8tvVrH8WBgJVv6mW9FvfDxWhLHLXhY09wK/98Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261501; c=relaxed/simple;
	bh=GhYIbm4cX1n4ox/5CsEE9+JIELQNT5X+xB8qhY2QRKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZvI7zrfI2Fs/b3dHbw6M7U/WNVPkr+2UN3OEKEYtQmuQW+e49LT1OZuC22ye48X+GeZE+/DzkhPdYNbpeI96XJkH84Q/LLihuwlnAIPBfDAYFH41FwEoo5JltFCefzcN+CybPXey4KpYOE91XTn0ya/7rGzZs4z/D2MiLHGWQqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3PSV/HY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3PSV/HY"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61814249649so70176147b3.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261499; x=1713866299; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MOBd5Z7KCj/kCpPtLl6MQ+Mcjjs3q6/M4oyw1j84Sn0=;
        b=c3PSV/HYQoLXcVZiqap4Q4K13TRLs4xRjn3D9naSklitB21yxmM0NoUM4zW5nMv46w
         diNa7OiTanygCj7Zwf+ifwpsdmo679fmucgncqpUNQAuQ+gRePzNI913e8w8sFgS0Ygv
         DIO8+gN5UlMp5EKFXPS7VtF4FGoO85M5ZNB/CS3zvrR3HKyh/IeK7ijFFmV9V6FyBr4R
         bsTe+Vt9djI4xTOWi57xrh1uL4P/GP5iV3w43XDoBf/9JYYkyLIoiG/f1hflryQ4h8JG
         ameAtDDrZ9g6EuKIAd4ixQ3d1Gjq3v+cWKC5J95XTZc1iBqWRcQVwMu3UquRRgciiFap
         dp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261499; x=1713866299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOBd5Z7KCj/kCpPtLl6MQ+Mcjjs3q6/M4oyw1j84Sn0=;
        b=eifhw+0ayI0N1lO5wb5G9bEczt28ZIldKLPxFsjgRCJJBl4CldeEPRXFUyI55wVqZp
         oidUkcwPkr35kr5cXjr7at10A5cqkiUCWB/mbua1LwmfZn+N32ErlrHxZpVXYUPYyQM1
         PbT8xw9vuah5ZxoCFXVukfKqlY3Madh3YEjsfD795TEM/WgLkAEwwK4XBT1XuLv935J+
         M/vI7/Snc6I1r/rVpwIKYkrK0hbJ2BjzITnxyzZiwjOn+nYXUKVncamZQGqyE41clHjQ
         Kho+zmd9sC1OIgppJZy5XBKmw19c+OM/fBBw7vmFwQhXZauY4AY/Vptn+bohdEDr9mLq
         fKNg==
X-Gm-Message-State: AOJu0YxDmgXuJk8uNg6+LN4AyzTJ6UqnPSQMc8TW5PIcvuatf0sJuo2+
	J1Ve1hz9MYKJVf+7S5mxOlN1TjPgmFwhrbRSGPPF85z9whLhW0aPhyusqq1GWHgDHUW/F5ZW3Sv
	5MV5qAH7dG2fS4QvH97Wh4asIh7hsVlwz+Y+MpackEG8kiOzWRsE5rkeakrDEJ2EMrhtmkRPvnm
	4/dc4U37A5+QGDPtNIyNEhIuy8pxs=
X-Google-Smtp-Source: AGHT+IFUJAS3FGWarT+m3p8sQN2T69n/g4mvftfjRWUxWRDnLpT0CQH9knE9GqK80QOmfgp8YUsTy/ZrsQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:6f89:0:b0:dd1:38ec:905d with SMTP id
 k131-20020a256f89000000b00dd138ec905dmr1298507ybc.11.1713261498963; Tue, 16
 Apr 2024 02:58:18 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:34 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-44-tabba@google.com>
Subject: [PATCH v2 43/47] KVM: arm64: Force injection of a data abort on NISV
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
 arch/arm64/kvm/mmio.c          |  9 +++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

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
index 293a830d7c28..edf6b6a9632d 100644
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
@@ -240,7 +244,6 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
@@ -250,6 +253,9 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
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
index 5e1ffb0d5363..87fd8faf2b62 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,11 +133,20 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
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
 
+		if (is_protected_kvm_enabled() &&
+		    kvm_vm_is_protected(vcpu->kvm)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.44.0.683.g7961c838ac-goog

