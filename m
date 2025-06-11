Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F319623ABAD
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682125; cv=none; b=NfrfaUO9IfhVPswOQ6V4qbBIp1XEUFQKowIgciIXrZZuLFrKomTMzj9SYXsmA5zULMrfx9RpkV2S7EQPk9bGRoPyWHvu2nzW71//2kheZ3Pa3zNJ1CxVCa2+j5IQHl18LHijaR6FX7nTdDvBjVv7h4JoODyNAd8gi0MBWfkctTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682125; c=relaxed/simple;
	bh=01/TeXAv+/ld+0h+0i5gKdPXqo5VXKxKWxynJL1IDDI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LXId+xsp2ONirkzDOBeQcRJuQn1Fbeyswi6w8+/pR2sAWjCQxhu6DY7P15PRjEebwrVaLeFIuSnCfOsp+9M5flwfO5CHdKBMBVI9HBaS7ZUbzCKONny91+SYnHPyJgc+msRmI73lAQYvfvS+UBC476hPTAaXNDtRgofd72uh2yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGbhrEx7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGbhrEx7"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235c897d378so2224725ad.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682123; x=1750286923; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A2H6mQAi3X2cVhbsLup4QR14EBoE/FmvQ1a87TN4T2w=;
        b=jGbhrEx7rM3CX7Y9rQtP5fAFTXCZknmeDswqDAdbGNtwDK+y5eOhjS8cKzK2vuz1m0
         TEToKwKbPsGPu5P00/Lty9EBTdKmGOMlU7XbGVQOdhwsgxJGUNBwtF83K+n9chMNrT0G
         PSrvsgpQwooEhUpVk2OOGKBBizJp+ttV98/5HrtvpDb5qa6/RZ3455csFWkfM3Mqpw2B
         hdH+aSzRcZu1Jo5HLTQXnWpzUlzIGZGq0H5vytmJ0z/eI6Dih1XRw9IcFXqprpTP6z6b
         u4a1YJUgVn6Ko8zGz2zu3P14nlGY3u7r4O4idWDfJ0jPuz9qAcFWJuFWovmLok8J/OgW
         P2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682123; x=1750286923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2H6mQAi3X2cVhbsLup4QR14EBoE/FmvQ1a87TN4T2w=;
        b=DroMgDOZDAm/Ex0Zl2ES+s2nUeYzaFxBKYx/2IfQDNw2K9F0lrIFoqWzqknx3VL1Sf
         TbDaiA6CQ2E7QbH6HtY4wojAKFWhohAkvz7Qbke3Q10zjS6YPYdE/KBSoDQ8wufIKr5F
         ihWI/vSBBJsRNO2MNymMfxLfUbV4P0szHy7716Iw9Urb4PBWEAxkc/i6Taq4sGLuMZ8Z
         +7c/227GjyvmsHaSy2nsFXjQypoQMoJc5yhcdN3qKpHkUuyRFvo60MdUfQnvWDfe9siu
         VoeGLCbzEvzyExRDTwUCLTWqSzb0WR9k8r3JMt14Ffl4DhvAgfZa4P+qUem/pGP2IyXg
         ECZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT4WSQLm4qT6C3JpIlqe73wB0qaT0g3J44KmnpMb2JGwlx1XiZ9SgRshCZ4pUJ8ngBUrFOHUI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh/4y6vLP0IgVsNCdYJcoJ4t3NcQOgiWW+ZwIIW4y1RjcAwIhR
	blG7D/ANt4GJIcirYT/PrMn80xxiCRF1XQbt/zdaiwusAj6W5w3gFWSq6ADXnngjE0J7UHVybfP
	g90H1Zg==
X-Google-Smtp-Source: AGHT+IEmj8Wn93vyxOZ20/CzQNxDRl4F7IoOM7uRFd48VrtVcKzRebVp/cgdBntFE1vN9k4o1Eln3ZwGSvs=
X-Received: from plhl7.prod.google.com ([2002:a17:903:1207:b0:21f:4f0a:c7e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54f:b0:234:ba37:87a5
 with SMTP id d9443c01a7336-23641b1aab7mr72956825ad.25.1749682123415; Wed, 11
 Jun 2025 15:48:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:05 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-64-seanjc@google.com>
Subject: [PATCH v3 62/62] KVM: x86: Rename kvm_set_msi_irq() => kvm_msi_to_lapic_irq()
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

Rename kvm_set_msi_irq() to kvm_msi_to_lapic_irq() to better capture what
it actually does, e.g. it's _really_ easy to conflate kvm_set_msi_irq()
with kvm_set_msi().

Opportunistically delete the public declaration and export, as they are
no longer used/needed.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/irq.c              | 14 +++++++-------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01edcefbd937..af08b1acba04 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2381,9 +2381,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			     struct kvm_vcpu **dest_vcpu);
 
-void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		     struct kvm_lapic_irq *irq);
-
 static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 {
 	/* We can only post Fixed and LowPrio IRQs */
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 3e4338c6a712..83c91845389c 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -252,8 +252,9 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	return r;
 }
 
-void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
-		     struct kvm_lapic_irq *irq)
+static void kvm_msi_to_lapic_irq(struct kvm *kvm,
+				 struct kvm_kernel_irq_routing_entry *e,
+				 struct kvm_lapic_irq *irq)
 {
 	struct msi_msg msg = { .address_lo = e->msi.address_lo,
 			       .address_hi = e->msi.address_hi,
@@ -271,7 +272,6 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	irq->level = 1;
 	irq->shorthand = APIC_DEST_NOSHORT;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		struct kvm_kernel_irq_routing_entry *e)
@@ -290,7 +290,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	if (!level)
 		return -1;
 
-	kvm_set_msi_irq(kvm, e, &irq);
+	kvm_msi_to_lapic_irq(kvm, e, &irq);
 
 	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
 }
@@ -313,7 +313,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		if (kvm_msi_route_invalid(kvm, e))
 			return -EINVAL;
 
-		kvm_set_msi_irq(kvm, e, &irq);
+		kvm_msi_to_lapic_irq(kvm, e, &irq);
 
 		if (kvm_irq_delivery_to_apic_fast(kvm, NULL, &irq, &r, NULL))
 			return r;
@@ -486,7 +486,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 			if (entry->type != KVM_IRQ_ROUTING_MSI)
 				continue;
 
-			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
+			kvm_msi_to_lapic_irq(vcpu->kvm, entry, &irq);
 
 			if (!irq.trig_mode)
 				continue;
@@ -521,7 +521,7 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 		return -EINVAL;
 
 	if (entry && entry->type == KVM_IRQ_ROUTING_MSI) {
-		kvm_set_msi_irq(kvm, entry, &irq);
+		kvm_msi_to_lapic_irq(kvm, entry, &irq);
 
 		/*
 		 * Force remapped mode if hardware doesn't support posting the
-- 
2.50.0.rc1.591.g9c95f17f64-goog

