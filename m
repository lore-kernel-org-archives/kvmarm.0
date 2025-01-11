Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BA140C03
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 01:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558698; cv=none; b=GNNIqBOOWnvca0+PHLKDrM05SBraOo2FHbhIDttLk792KmJwhnFWTlbGbMXZHP/JGLd10ayrO0qp6Ju7qNGNDIvAUsVbn+vMe60G55ztNY4avfl+tG2lA9wKVVMNYWpJoYZtY3nlOnuXwfXsI5qtcHxALAtZKLEmmlCYXWINzl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558698; c=relaxed/simple;
	bh=AVYzQUQrTSkLUbewlYjOO2i8641BAIJsb+Od5cW5JHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s1FK3fmMWgcCJLBUATobofzraHiBukVqURD7T9rm5X7eyzc4LKqljCPO1gRxccc4f7zzRgxSelSEK+eWKqJ9hvP9V9HatzPYT8ar7yXPxAGkKGO2+QTz+FsSde8SArbho0lf8JZM59M3TqtldvjJCz1C1/geQ192+IqNDVh99Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lc5Xn3bJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lc5Xn3bJ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2162f80040aso43083795ad.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 17:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558696; x=1737163496; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yPMtRfEi+Y38oJbaqxUUwsgL1BiiO9TX2S4BZFXkjhs=;
        b=lc5Xn3bJIl9zYWVa+LEoLWgUYHOMFXFdEDCWLfQP9jg3uC1/AWIZQmZWB2/tkwSTfu
         BCd6WVHiN7qCr73qXTdqPEPNfb0x1HJsPAado/iAQjNgMW/lTkeCAjfCvKrUf8JG4vFa
         EsxMfGtL46mspLCx+ek+i4JIrHXrTrBscNgBo8sMGaVQFdMDbRFMihiPfoQn69YuVEAy
         jgCTZi3aY1C+G0gRGt9sqJRbRNFiQFqm1AS0cRYD5KNcyFzdnXOTIapQw1aFGlf0qOcc
         NehS1dnRE/n7Hiv6ypZaYWlrfKfjCAHMDz257aHAVyFE+7g0/R5OrvjlgXb6XFcfQ+oL
         JnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558696; x=1737163496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPMtRfEi+Y38oJbaqxUUwsgL1BiiO9TX2S4BZFXkjhs=;
        b=bg2+VHN5G5wVJxBcsWLWXHHphq+RCE/BzySeGjQ4bR4MhwNF/jbpKNDRpgdLIYq4nO
         5O4L7KgiPV4tSwTGsE5bNHSckevkav4jTgC+YM00ykE7W3qe5BsJ3KADHYvvuNwfG7+z
         zGgyVmiN4nOLeCOjQOyNcBF4tFmbWv2lSiL8wt12PFTM3F0SH57OOvMaSESjDptUh8t9
         JrSQOOx9FkI2ybN7JDykAn0gjxo61IKczFjeyPAIeEouxnZPIx3p7xEl32FeB6Iv6H5C
         0NPWLjqAWjPwtZUwjjuRMpdibStFYXC2ScAdAl1Q09LDtyBvOQHJTHJpo83LSgRfi+df
         eUgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWseKZkyv2G01hZWKjjhkrIveIFefvnY+gIGe+ZMrpMa8M7MZntpUZ27Wcy29OwxX89qd5X9kY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwdWda3x56U7gvv+MoHeZtXDd4IJuojyfYe1KpD5Ps8hKptC8rl
	I8IwWbM8QpY3DC6Mxdx6TRH7gaKSxP0A8AQcgHIaxsVr8MmTB5zPudppHNk1igBhYxRq06Rx+Xv
	6Dg==
X-Google-Smtp-Source: AGHT+IFD3f0YjwZz/pTHPUxUy4yfVqFt92VRSC3L2LvrexSYRapcV9Xo2L4A2CKFVBcFdjD8/mn4jkTqU/U=
X-Received: from pgkp11.prod.google.com ([2002:a63:f44b:0:b0:7fc:fac3:7df6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4325:b0:1e1:b062:f3fa
 with SMTP id adf61e73a8af0-1e88d1dba97mr25121737637.34.1736558695870; Fri, 10
 Jan 2025 17:24:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:47 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: Clear vcpu->run->flags at start of KVM_RUN for all architectures
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Clear kvm_run.flags at the start of KVM_RUN for all architectures to
minimize the probability of leaving a stale flag set.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c         | 1 -
 arch/arm64/kvm/handle_exit.c | 2 +-
 arch/powerpc/kvm/book3s_hv.c | 4 +---
 arch/x86/kvm/x86.c           | 1 -
 virt/kvm/kvm_main.c          | 3 +++
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..925fa010bb7b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1128,7 +1128,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
-	run->flags = 0;
 	while (ret > 0) {
 		/*
 		 * Check conditions before entering the guest
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9e..63692c254a07 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -186,7 +186,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = lower_32_bits(esr);
 	run->debug.arch.hsr_high = upper_32_bits(esr);
-	run->flags = KVM_DEBUG_ARCH_HSR_HIGH_VALID;
+	run->flags |= KVM_DEBUG_ARCH_HSR_HIGH_VALID;
 
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_WATCHPT_LOW:
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 25429905ae90..b253f7372774 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1704,9 +1704,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		/* Exit to guest with KVM_EXIT_NMI as exit reason */
 		run->exit_reason = KVM_EXIT_NMI;
 		run->hw.hardware_exit_reason = vcpu->arch.trap;
-		/* Clear out the old NMI status from run->flags */
-		run->flags &= ~KVM_RUN_PPC_NMI_DISP_MASK;
-		/* Now set the NMI status */
+		/* Note, run->flags is cleared at the start of KVM_RUN. */
 		if (vcpu->arch.mce_evt.disposition == MCE_DISPOSITION_RECOVERED)
 			run->flags |= KVM_RUN_PPC_NMI_DISP_FULLY_RECOV;
 		else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b04092ec76a..a8aa12e0911d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11465,7 +11465,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
-	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
 	kvm_vcpu_srcu_read_lock(vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..7d2076439081 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4336,6 +4336,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 
 			put_pid(oldpid);
 		}
+
+		vcpu->run->flags = 0;
+
 		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit__unsafe);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		vcpu->wants_to_run = false;
-- 
2.47.1.613.gc27f4b7a9f-goog

