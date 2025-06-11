Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199632E2EFF
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682074; cv=none; b=OI93j34vQy+7kcevWdOQunTtV85cw9Mz4w14ygz7aEnkRU6UB/+zvKCoiFEWh7prHF2mDA46xTb2vieyFnAYioFzLg6ThfFfO78xvJ4EJCJtHTaSYEyMdcF4CeW4C24ttQs+tufQv2/1vuNW1B0TZgMb3sUrpLPO/7fgreYrrm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682074; c=relaxed/simple;
	bh=wHrhMmAPxECbumBhisr6CeJaFww9/hh84HS6HonITio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=svFogEg4yqwnAegmm/ALtMgNhVEmZNocCKVn4UIBKR7nsiUVI4o5Kn+JdkYcQ+H2QAnegeGUyTvaHDx8Ay0O0c2Hzt+GT50Q219U8h4Qh6mSoyIRNA3G6hsTgQFvP2VVjS0TQGWPflfDFlmSapIMBn3pgxhlfuXxkqiX3y3OI58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QppHp0Va; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QppHp0Va"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747cebffd4eso233353b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682072; x=1750286872; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eWPqxy/EcaIBVD9x6tvhc+E9e7T+tuW/T8x9vMu/aCc=;
        b=QppHp0Vak0Tw8ozmeO8/rEpVDtcSYXksmp1VC043WH8YW8uVYNl8uvIKRJ+HV7laqE
         zCDF6M4K6SDc1n9srRAzhCVa0i/DHET0RjkYgrU0h6JPUjvq2xLWXjdWiktKM3pA5HQ8
         WVJxvEIkCSIqnb+530mF0BAhvIqsFlUruB5XvXmZ9ECR1dDf9kHZC9/yYTyzjPejkzTS
         bIpvZLh1tpRKOQJcdOBlzuapggQwmPGX33rsUAE+nq/XpAkkRsAiX1IvAtnx9eOHiGv0
         GlzRBBhjLmMJaemz0pYfQAiAS8hY1Jw3JuIIR/pzVRGyxbc3xVD3V9YLlA+oYfvZmmb+
         deXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682072; x=1750286872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWPqxy/EcaIBVD9x6tvhc+E9e7T+tuW/T8x9vMu/aCc=;
        b=fXRyU9GzM4HdpqbPB3Fal9TQIW+087Yy8NpbgVTsozfUfH9BWK6pxRdP/NNTHOOlBa
         xoYD8nmuTEn6gDv4rIenM+MK7ik0qe1SsIAfrBeSMla/wjVqgQ90JGWX23UrQB0OLOlN
         OgacyjsEFVuLO79urTVSgR84tj+iH7vCM7z19PQho0tza4TRkNnwFPbex6P5N+2mDCK2
         hm3jTo5kiEMabdzNMqi8Bczl0TEFuJ9kXwCQW6TnvrB3bUmLwi6EEWvzJY7RhA41jTUm
         mmGHA1x4j0QJa7XssW/X+AcLkb7quYU8AaqLLcgp+pE0IC2TCjnrvpSjqR/Dbz5w+Ckm
         n8wg==
X-Forwarded-Encrypted: i=1; AJvYcCWOf02sowiThy2oWLroBTeWuoALhJAWSV59qTn3NLFyyvTcOjxvXOKLv6TAfu4EZGCmc7B/PT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCBbe9zBwRgYMQwYUlPULIW4sKpX53DOINaTDpM8FSJtRCa0JV
	QscAm+Q5IbWoZsCaYFgdcmUyIOPHv+mxSw2ahJ0kBQfahUWCmWQRiQkbo4ja54CQQIrzYCuqMuE
	lGefcfA==
X-Google-Smtp-Source: AGHT+IGEG5h+XdvBZsfOP4WIVoU6EIbIQoZeJBB+YTLPLiy+efdbc+9aZGANnnVVnd62MBQByP1coVKnSpY=
X-Received: from pfbhj8.prod.google.com ([2002:a05:6a00:8708:b0:746:2747:e782])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22cf:b0:748:2ebf:7418
 with SMTP id d2e1a72fcca58-7487e2dc74dmr987606b3a.24.1749682072521; Wed, 11
 Jun 2025 15:47:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:36 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-35-seanjc@google.com>
Subject: [PATCH v3 33/62] KVM: Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing()
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

Fold kvm_arch_irqfd_route_changed() into kvm_arch_update_irqfd_routing().
Calling arch code to know whether or not to call arch code is absurd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c     | 15 +++++----------
 arch/x86/kvm/irq.c       | 15 +++++----------
 include/linux/kvm_host.h |  2 --
 virt/kvm/eventfd.c       | 10 +---------
 4 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94fb2f096a20..04f2116927b1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2761,20 +2761,15 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
 }
 
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
-
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	/*
 	 * Remapping the vLPI requires taking the its_lock mutex to resolve
 	 * the new translation. We're in spinlock land at this point, so no
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index adc250ca1171..48134aebb541 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -610,19 +610,14 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new)
 {
+	if (old->type == KVM_IRQ_ROUTING_MSI &&
+	    new->type == KVM_IRQ_ROUTING_MSI &&
+	    !memcmp(&old->msi, &new->msi, sizeof(new->msi)))
+		return;
+
 	kvm_pi_update_irte(irqfd, new);
 }
 
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-				  struct kvm_kernel_irq_routing_entry *new)
-{
-	if (old->type != KVM_IRQ_ROUTING_MSI ||
-	    new->type != KVM_IRQ_ROUTING_MSI)
-		return true;
-
-	return !!memcmp(&old->msi, &new->msi, sizeof(new->msi));
-}
-
 #ifdef CONFIG_KVM_IOAPIC
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8e74ac0f90b1..fb9ec06aa807 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2413,8 +2413,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *);
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 				   struct kvm_kernel_irq_routing_entry *old,
 				   struct kvm_kernel_irq_routing_entry *new);
-bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *,
-				  struct kvm_kernel_irq_routing_entry *);
 #endif /* CONFIG_HAVE_KVM_IRQ_BYPASS */
 
 #ifdef CONFIG_HAVE_KVM_INVALID_WAKEUPS
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index a4f80fe8a5f3..defc2c04d241 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -291,13 +291,6 @@ void __weak kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 {
 
 }
-
-bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
-				struct kvm_kernel_irq_routing_entry *old,
-				struct kvm_kernel_irq_routing_entry *new)
-{
-	return true;
-}
 #endif
 
 static int
@@ -617,8 +610,7 @@ void kvm_irq_routing_update(struct kvm *kvm)
 		irqfd_update(kvm, irqfd);
 
 #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
-		if (irqfd->producer &&
-		    kvm_arch_irqfd_route_changed(&old, &irqfd->irq_entry))
+		if (irqfd->producer)
 			kvm_arch_update_irqfd_routing(irqfd, &old, &irqfd->irq_entry);
 #endif
 	}
-- 
2.50.0.rc1.591.g9c95f17f64-goog

