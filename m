Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F9E2D8DB7
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682058; cv=none; b=j042gCoTIXJ1ytver3ltY2kv91hLhS30bX2k6HVKz6NPBf3fbXT4OcfCKiAw98rOp4OXhU9uywIGKLjKgCy3g/KX8K7gu96Udcu03wHqwXbR/cb5HYkF34jTpzf5h1baVe3LwE9gXJW6VtE0dv4/92U+jyZ1LyuVgtWMQrmsJ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682058; c=relaxed/simple;
	bh=0j9rjncNIqA99xT7ntd8FNb/aJpNqCnKYRV513GAehY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qxnK2SvRKFXhSHXaNsZHuuQyFl7CYH0lbUPz+Vw8QzW3YPi4Jxw88jgWph6dJExJSfFsaKnT3euxAM+Km8UtZJLHy2MHR4mh3KLt+1CkE7wo3iNJb6rm2ItMjcXusUBbohVsBYVCM2c/BxwKv6bBormy95m+OExItVDLo4NqYQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H9S3hZqr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H9S3hZqr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a59538b17so291391a91.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682055; x=1750286855; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Lz6FPWK+2KaUOt8OyhBi1B9mdgWpelrW27yDhfYYvM0=;
        b=H9S3hZqrDGS4gYfc8HHMqyNcKz6j7OqweIjM0TZKFEMHX0NBETgeaZoZAS0ljHzGYu
         v5NAvYAQwuX37DD5qFzWunpcS/eECZXBRrcYhjFu+kWdf9awZVMIvWQsx4aeaAe8XN3C
         lkKYervKyy3f+OTyixbPb7Sp72a4X2rfWHGFcRVndVp6SqHO+j62Fgz45N9IIA/zH6FF
         HvZmF9Batiqnv0X4zh7aWxIJTOC+T3mV/vUQ3GoDR/fOG7CyFZ0jpVe2qcH8IJ5ftLsq
         C154JqI6HmVPrIvnI/RSF4mcogTBufUuJVdFbf0JLPaGRhHEoOirwIrI3wA2dkpr+n/a
         Ku3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682055; x=1750286855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lz6FPWK+2KaUOt8OyhBi1B9mdgWpelrW27yDhfYYvM0=;
        b=hfdfNHrRLI/YjbaUADfTY0cdIxGt91A3oTdBqQamnjvoBTdTFfGS05aMVP5gODMUll
         gu7q0aAzk3NETKpZaGwcGhZYLclVwLUBFXVjEb/9cbiFak5dYWnsFNO8EGW3L+KFVLQt
         K0Et7AYwYxbAikbkrMZFat03g9pGkXfI42ETormU3gHKfKUscXn51IF2uG95yU/i9WYw
         NThkh+sqxD/jKLcYUEwPT2JwlKFzALebFVKVaT8CI83OjmnFp4VcNbF3NlQyospXWDkY
         Jbn71apxxycwmsJwDVQeYZj5vNvxpAzd0W5h42JNF6488Hfh9etfhTY5d0ggvliCdEJY
         vPBA==
X-Forwarded-Encrypted: i=1; AJvYcCVrWTwjCZyLzamELI3ZdKVWYK/tvFx7HRN0UfjUuK3TASYULnzIN/kWtAU7G7Wl3ZVI0EvpBPI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHUwphB1eOSxwVNq6eJnXBuTCxdLo0dpQIo/TWi1FLItmzLRgc
	P8LzAz/9yUosl7FBnA9WqYNwkMvk/6rfqdY180vPaDZQZ7xNaQJZUcsWplrTKuasjlBna4CeJk4
	9XXK/Bg==
X-Google-Smtp-Source: AGHT+IHo1u0Z7FhSnHxyOYsMun3zcxJWYCXnnXBCwZMuIkgbN7vyWFArERANVwiRl4h7mR2M/XSqyhw5t/4=
X-Received: from pjbsm18.prod.google.com ([2002:a17:90b:2e52:b0:311:c7f9:ca1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3944:b0:311:b5ac:6f5d
 with SMTP id 98e67ed59e1d1-313af204368mr7511964a91.29.1749682055441; Wed, 11
 Jun 2025 15:47:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:26 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-25-seanjc@google.com>
Subject: [PATCH v3 23/62] KVM: SVM: Stop walking list of routing table entries
 when updating IRTE
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

Now that KVM explicitly passes the new/current GSI routing to
pi_update_irte(), simply use the provided routing entry and stop walking
the routing table to find that entry.  KVM, via setup_routing_entry() and
sanity checked by kvm_get_msi_route(), disallows having a GSI configured
to trigger multiple MSIs.

I.e. this is subtly a glorified nop, as KVM allows at most one MSI per
GSI, the for-loop can only ever process one entry, and that entry is the
new/current entry (see the WARN_ON_ONCE() added by "KVM: x86: Pass new
routing entries and irqfd when updating IRTEs" to ensure @new matches the
entry found in the routing table).

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 109 ++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6260bf3697ba..a83769bb8123 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -843,11 +843,10 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_kernel_irq_routing_entry *new)
 {
-	struct kvm_kernel_irq_routing_entry *e;
-	struct kvm_irq_routing_table *irq_rt;
 	bool enable_remapped_mode = true;
-	bool set = !!new;
-	int idx, ret = 0;
+	struct vcpu_data vcpu_info;
+	struct vcpu_svm *svm = NULL;
+	int ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
@@ -859,72 +858,53 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	svm_ir_list_del(irqfd);
 
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
-		 __func__, host_irq, guest_irq, set);
+		 __func__, host_irq, guest_irq, !!new);
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	/**
+	 * Here, we setup with legacy mode in the following cases:
+	 * 1. When cannot target interrupt to a specific vcpu.
+	 * 2. Unsetting posted interrupt.
+	 * 3. APIC virtualization is disabled for the vcpu.
+	 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
+	 */
+	if (new && new->type == KVM_IRQ_ROUTING_MSI &&
+	    !get_pi_vcpu_info(kvm, new, &vcpu_info, &svm) &&
+	    kvm_vcpu_apicv_active(&svm->vcpu)) {
+		struct amd_iommu_pi_data pi;
 
-	if (guest_irq >= irq_rt->nr_rt_entries ||
-		hlist_empty(&irq_rt->map[guest_irq])) {
-		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
-			     guest_irq, irq_rt->nr_rt_entries);
-		goto out;
-	}
+		enable_remapped_mode = false;
 
-	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
-		struct vcpu_data vcpu_info;
-		struct vcpu_svm *svm = NULL;
-
-		if (e->type != KVM_IRQ_ROUTING_MSI)
-			continue;
-
-		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
+		/*
+		 * Try to enable guest_mode in IRTE.  Note, the address
+		 * of the vCPU's AVIC backing page is passed to the
+		 * IOMMU via vcpu_info->pi_desc_addr.
+		 */
+		pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
+					     svm->vcpu.vcpu_id);
+		pi.is_guest_mode = true;
+		pi.vcpu_data = &vcpu_info;
+		ret = irq_set_vcpu_affinity(host_irq, &pi);
 
 		/**
-		 * Here, we setup with legacy mode in the following cases:
-		 * 1. When cannot target interrupt to a specific vcpu.
-		 * 2. Unsetting posted interrupt.
-		 * 3. APIC virtualization is disabled for the vcpu.
-		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
+		 * Here, we successfully setting up vcpu affinity in
+		 * IOMMU guest mode. Now, we need to store the posted
+		 * interrupt information in a per-vcpu ir_list so that
+		 * we can reference to them directly when we update vcpu
+		 * scheduling information in IOMMU irte.
 		 */
-		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
-		    kvm_vcpu_apicv_active(&svm->vcpu)) {
-			struct amd_iommu_pi_data pi;
-
-			enable_remapped_mode = false;
-
-			/*
-			 * Try to enable guest_mode in IRTE.  Note, the address
-			 * of the vCPU's AVIC backing page is passed to the
-			 * IOMMU via vcpu_info->pi_desc_addr.
-			 */
-			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-						     svm->vcpu.vcpu_id);
-			pi.is_guest_mode = true;
-			pi.vcpu_data = &vcpu_info;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Here, we successfully setting up vcpu affinity in
-			 * IOMMU guest mode. Now, we need to store the posted
-			 * interrupt information in a per-vcpu ir_list so that
-			 * we can reference to them directly when we update vcpu
-			 * scheduling information in IOMMU irte.
-			 */
-			if (!ret && pi.is_guest_mode)
-				svm_ir_list_add(svm, irqfd, &pi);
-		}
-
-		if (!ret && svm) {
-			trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
-						 e->gsi, vcpu_info.vector,
-						 vcpu_info.pi_desc_addr, set);
-		}
-
-		if (ret < 0) {
-			pr_err("%s: failed to update PI IRTE\n", __func__);
-			goto out;
-		}
+		if (!ret)
+			ret = svm_ir_list_add(svm, irqfd, &pi);
+	}
+
+	if (!ret && svm) {
+		trace_kvm_pi_irte_update(host_irq, svm->vcpu.vcpu_id,
+					 guest_irq, vcpu_info.vector,
+					 vcpu_info.pi_desc_addr, !!new);
+	}
+
+	if (ret < 0) {
+		pr_err("%s: failed to update PI IRTE\n", __func__);
+		goto out;
 	}
 
 	if (enable_remapped_mode)
@@ -932,7 +912,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	else
 		ret = 0;
 out:
-	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

