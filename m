Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3E2D8767
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682110; cv=none; b=BFEyVDg074GG5hoW69p74dcX5IS/iDyrJMqlnxKAAmCMblwHJay/iOTClW9URONqpnkUUO9thqVlSEKTBRLhZMYYQEm9h3YSOz2ix6mVAleGnbbXD/nQ/6N+LbMqHi7vPCmUltqGJCVoppCFSlxlnQJ1UmoDaIx0u8bM6qu/q+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682110; c=relaxed/simple;
	bh=/ey+g23JZ4r8B8+r5GYs9olbwesZBfZIxsH4DlOVxs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ju2HY2WArYrXAvkcJeqix0D4U0GFw3hc0pKIy8Why6yeVcySorwyLqXXON0F7+Ih8xdsrhpJWQGM3nufIIcvoRm7GKtV9hPiQRIYB/KTK/0BFzIe21zd1BTMbQR/GfrEdn9CV9huxPG6hgI5Wn13G8jRXrjOUG+emU4l+K2Sxp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FVoLXFOj; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FVoLXFOj"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26cdc70befso148952a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682107; x=1750286907; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jzJ9Bn8YxIfcgCuBy+GrCINZysE0563FpKJOCV/SIJ8=;
        b=FVoLXFOjSY29k0uiCQ+N3dBYFMAXPaA3VJrS2FNC2XmaOfqcjp/DZ+3WF2Ne7j/i37
         owBPln+33z4qMbi2YY4nZBnrIzTEhz+/ykAuboafa38rWuVT592t4NLJsVsysIAQ9gKA
         BqHJgqUFPCUcYvy5oSoYqAF1byLYVfUIx39fXVa77rjiWcWmh2QDLz/0p4NzKJtfK9UC
         mlwnd3AYKNfStAcIV2b0cjdIgR0LLp12Jjy05k4wbhipPR3AST9ch0y+niGcw55OvuP1
         ZHpG2hOSu4/3eHskrCGtdtNOSvfT8rnEb1Es1aZR41PcWBewaO0DUjMAKDUPZTC1xQot
         k8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682107; x=1750286907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzJ9Bn8YxIfcgCuBy+GrCINZysE0563FpKJOCV/SIJ8=;
        b=tvyVfJ8WLLULuzFL/B2ZsO8Uag4p2GrK81vH65+sDDlQvplO+mkOzRsdB4Lmw2tD7k
         aSULRiERGuJ+hwLEKWaItQeOA8KqLvo9dc0gkL2Ncmtul9/pNvF3Ii9aTfehvNE0ZJks
         GoYv9j2kbf8mHNcKq0jcFnlPkAKm16VEm6uL38/VNe422bAIpgnNzQobX4aAMSOCV6Ug
         kbKj3zFBlW+NGRmGMH71P/jYgby3UEmoozPEt7sjJBzq7/P3K29tItADlS8Zdw3icL02
         sF+6eZv7KCEgr/znEcuV9k15v6jP4JkjYI6/usD/Ioz4JUF2MKAomYFEtrIOhsDxa8V2
         JWDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGWyjLwpl0QWU0IB0B8bMXBJdX/7tT2HzZXCTEOrd/E3b2Aw9dT23W6L+FsaH2jYzzIImInA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGR7BAXU24FgbhvZNpSQibROVhU+f/qhmh8LmhNUvYA4LUxc4f
	/zzel+XkkPsigEaTXx8C3cxQ8p/rnw2QfSCQhZArOnzOZTkHsNHZ8QFNOfy69n5fsd4G2Y0g87h
	MuqcH0g==
X-Google-Smtp-Source: AGHT+IEhj+n1Ly+6wKwDC3zINzGL129P3f8d7JO7+GDAMIMqFYx6vPUDUegFQHCgddVNbCyKFm33V0a671c=
X-Received: from pjbsu16.prod.google.com ([2002:a17:90b:5350:b0:312:1af5:98c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f05:b0:311:f99e:7f57
 with SMTP id 98e67ed59e1d1-313c08d24d6mr948262a91.23.1749682107613; Wed, 11
 Jun 2025 15:48:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:56 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-55-seanjc@google.com>
Subject: [PATCH v3 53/62] KVM: x86: Decouple device assignment from IRQ bypass
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a dedicated counter to track the number of IRQs that can utilize IRQ
bypass instead of piggybacking the assigned device count.  As evidenced by
commit 2edd9cb79fb3 ("kvm: detect assigned device via irqbypass manager"),
it's possible for a device to be able to post IRQs to a vCPU without said
device being assigned to a VM.

Leave the calls to kvm_arch_{start,end}_assignment() alone for the moment
to avoid regressing the MMIO stale data mitigation.  KVM is abusing the
assigned device count when applying mmio_stale_data_clear, and it's not at
all clear if vDPA devices rely on this behavior.  This will hopefully be
cleaned up in the future, as the number of assigned devices is a terrible
heuristic for detecting if a VM has access to host MMIO.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  4 +++-
 arch/x86/kvm/irq.c                 |  9 ++++++++-
 arch/x86/kvm/vmx/main.c            |  2 +-
 arch/x86/kvm/vmx/posted_intr.c     | 16 ++++++++++------
 arch/x86/kvm/vmx/posted_intr.h     |  2 +-
 arch/x86/kvm/x86.c                 |  3 +--
 7 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..8897f509860c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -112,7 +112,7 @@ KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
 KVM_X86_OP_OPTIONAL(pi_update_irte)
-KVM_X86_OP_OPTIONAL(pi_start_assignment)
+KVM_X86_OP_OPTIONAL(pi_start_bypass)
 KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c722adfedd96..01edcefbd937 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1382,6 +1382,8 @@ struct kvm_arch {
 	atomic_t noncoherent_dma_count;
 #define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
 	atomic_t assigned_device_count;
+	unsigned long nr_possible_bypass_irqs;
+
 #ifdef CONFIG_KVM_IOAPIC
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
@@ -1855,7 +1857,7 @@ struct kvm_x86_ops {
 	int (*pi_update_irte)(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			      unsigned int host_irq, uint32_t guest_irq,
 			      struct kvm_vcpu *vcpu, u32 vector);
-	void (*pi_start_assignment)(struct kvm *kvm);
+	void (*pi_start_bypass)(struct kvm *kvm);
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 02efa7162252..3e4338c6a712 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -570,10 +570,15 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	spin_lock_irq(&kvm->irqfds.lock);
 	irqfd->producer = prod;
 
+	if (!kvm->arch.nr_possible_bypass_irqs++)
+		kvm_x86_call(pi_start_bypass)(kvm);
+
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_pi_update_irte(irqfd, &irqfd->irq_entry);
-		if (ret)
+		if (ret) {
+			kvm->arch.nr_possible_bypass_irqs--;
 			kvm_arch_end_assignment(irqfd->kvm);
+		}
 	}
 	spin_unlock_irq(&kvm->irqfds.lock);
 
@@ -606,6 +611,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	}
 	irqfd->producer = NULL;
 
+	kvm->arch.nr_possible_bypass_irqs--;
+
 	spin_unlock_irq(&kvm->irqfds.lock);
 
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..a986fc45145e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1014,7 +1014,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.nested_ops = &vmx_nested_ops,
 
 	.pi_update_irte = vmx_pi_update_irte,
-	.pi_start_assignment = vmx_pi_start_assignment,
+	.pi_start_bypass = vmx_pi_start_bypass,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vt_op(set_hv_timer),
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 3a23c30f73cb..5671d59a6b6d 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -146,8 +146,13 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 static bool vmx_can_use_vtd_pi(struct kvm *kvm)
 {
+	/*
+	 * Note, reading the number of possible bypass IRQs can race with a
+	 * bypass IRQ being attached to the VM.  vmx_pi_start_bypass() ensures
+	 * blockng vCPUs will see an elevated count or get KVM_REQ_UNBLOCK.
+	 */
 	return irqchip_in_kernel(kvm) && kvm_arch_has_irq_bypass() &&
-	       kvm_arch_has_assigned_device(kvm);
+	       READ_ONCE(kvm->arch.nr_possible_bypass_irqs);
 }
 
 /*
@@ -285,12 +290,11 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
 
 
 /*
- * Bail out of the block loop if the VM has an assigned
- * device, but the blocking vCPU didn't reconfigure the
- * PI.NV to the wakeup vector, i.e. the assigned device
- * came along after the initial check in vmx_vcpu_pi_put().
+ * Kick all vCPUs when the first possible bypass IRQ is attached to a VM, as
+ * blocking vCPUs may scheduled out without reconfiguring PID.NV to the wakeup
+ * vector, i.e. if the bypass IRQ came along after vmx_vcpu_pi_put().
  */
-void vmx_pi_start_assignment(struct kvm *kvm)
+void vmx_pi_start_bypass(struct kvm *kvm)
 {
 	if (!kvm_arch_has_irq_bypass())
 		return;
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 94ed66ea6249..a4af39948cf0 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -17,7 +17,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
 		       struct kvm_vcpu *vcpu, u32 vector);
-void vmx_pi_start_assignment(struct kvm *kvm);
+void vmx_pi_start_bypass(struct kvm *kvm);
 
 static inline int pi_find_highest_vector(struct pi_desc *pi_desc)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3571c484790..59391cb56674 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13440,8 +13440,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
-	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
-		kvm_x86_call(pi_start_assignment)(kvm);
+	atomic_inc(&kvm->arch.assigned_device_count);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

