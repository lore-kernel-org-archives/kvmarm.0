Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5DB28BA88
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682036; cv=none; b=SqvkTTexAepRvF6ynrGhaXJn7EUyEIBxZtYCuJIOEqOe+6u7dpqU2UDG5a6sblAzXsNjrx/Z4QH2ADdKMPSeTO//tynF4+qrWSrBQ4dBY7Z2kiJMbjfGffP32vMvQbM37Qd0Ey6oaN7mQ9EMlQbWr+yQy4YFlQ9AaiLqJnrMuNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682036; c=relaxed/simple;
	bh=Mb6/KTIeYaghJm2wWX89bXOimRdi1XnUBORRm/tOA7c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GTP+ypni2z7dXGRZrWp1JGd//U3+1QAjzvpEf6Yu0Lf9vrAoqZ60H1kQ+fei/Y1QkoMLgLhb75V2s7uxXq6JLpCbQZwfePYsv5aizZPrEggyp6DBGugNu3t7n1rXBRpLYP5TphT/GngYT7UpMiC5F+boPgSkzMomsadlt6C2L58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u+8J+hzu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u+8J+hzu"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so339869a91.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682034; x=1750286834; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vBV8ONm1woYvPckJRib1WYeJ0sSeMlwaWEnLKoaPZXQ=;
        b=u+8J+hzum83P0kT+35ho7nI5AJBXQxr0mnqmifGYsN1nTrCAO1t/byjoFAJJCx79Lh
         n1effT3rl9p4NClhiMEKWsiwBuxv5QedwPMBhKUQmo6++g4ETS6Hp9FXei+wchTBWTpO
         k162HVw4v9Y+t9M9NgdMSb56siaEzfkjHG2/2mEdOcejeipw53xX4xGWt8R1romnxCQE
         myoqsSeo78Zl+jbZG7XDYRdK3MzTU4/c9X/b239zcqz7XMM8snPFqrujyizZe1f4SsMq
         OaBD0aM0RAVHPlCnMo5KVZZB0IohOPM6lrhazhidRJVGXa0csxHGpdYOrBX0TlRjZb72
         i4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682034; x=1750286834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBV8ONm1woYvPckJRib1WYeJ0sSeMlwaWEnLKoaPZXQ=;
        b=hybAO6pqe5qTQugAlWswTXNZDx+x5dMC1k8M5EwMf/SbQI3i/7Kv1QwlrEAiq0EVxF
         cPnoVvlrTNta0b+heUP/iP11zhAykRju0yICoOGslVLbmnA0QeRKZRnp1/ghUmAFSLwR
         R+ZN2AYjcdgtLcJp22S+Ze+J1KW7fOQwmUSgET6wNvP6ReFp8r8aAGOo2+ZSzglZYgyd
         p3/kqFlm8+Ya2zG2NeCL0EBkVkoUPZxjfHaaiiFsF1mgLyIVnPECJYV2SwT7hSTSrBZo
         kVnVCOSy5SNLjdvWcYTv/O6y20dExwkB5N8AdIBpJ6OvA3NJNWFkyszYZjzWeY4LKqjN
         hZug==
X-Forwarded-Encrypted: i=1; AJvYcCVABb5YwkRxr8reHIIvuumQ1WZEx05BjQbcA7HvbXwSLhS3GeJW8+HV0imQhQLQGTnU9HB0I7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUh4fGxaaiY+Y82NkpPgkFKoW6XNB0ytwSEItHbFA2r4TXppMO
	One69T5lGSrmdh092upE4xZ3eA/WPZSADSIaOKja5LYnUk3Bh211O/8t3gmUFJyfi6m3NB3wSm7
	ha678fQ==
X-Google-Smtp-Source: AGHT+IEPFYmZzXUCGlwdowyqWkn5bPnHZM+aDnI6sRBuhesrGFICkRbpeSKEZTLooo10gbnXC/Ab4llRnXs=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4e:b0:311:c1ec:7d0a
 with SMTP id 98e67ed59e1d1-313c08d253fmr1028886a91.25.1749682033852; Wed, 11
 Jun 2025 15:47:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:13 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-12-seanjc@google.com>
Subject: [PATCH v3 10/62] KVM: SVM: Add helper to deduplicate code for getting
 AVIC backing page
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

Add a helper to get the physical address of the AVIC backing page, both
to deduplicate code and to prepare for getting the address directly from
apic->regs, at which point it won't be all that obvious that the address
in question is what SVM calls the AVIC backing page.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4b882148f2c0..c36f7db9252e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -234,14 +234,18 @@ int avic_vm_init(struct kvm *kvm)
 	return err;
 }
 
+static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
+{
+	return __sme_set(page_to_phys(svm->avic_backing_page));
+}
+
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
-	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
 	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
 	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
 
-	vmcb->control.avic_backing_page = bpa;
+	vmcb->control.avic_backing_page = avic_get_backing_page_address(svm);
 	vmcb->control.avic_logical_id = lpa;
 	vmcb->control.avic_physical_id = ppa;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
@@ -305,7 +309,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
 		     fls64(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK));
 
-	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
+	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
 
@@ -845,7 +849,7 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 	pr_debug("SVM: %s: use GA mode for irq %u\n", __func__,
 		 irq.vector);
 	*svm = to_svm(vcpu);
-	vcpu_info->pi_desc_addr = __sme_set(page_to_phys((*svm)->avic_backing_page));
+	vcpu_info->pi_desc_addr = avic_get_backing_page_address(*svm);
 	vcpu_info->vector = irq.vector;
 
 	return 0;
@@ -906,7 +910,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			enable_remapped_mode = false;
 
 			/* Try to enable guest_mode in IRTE */
-			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
+			pi.base = avic_get_backing_page_address(svm);
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
-- 
2.50.0.rc1.591.g9c95f17f64-goog

