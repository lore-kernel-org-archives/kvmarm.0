Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957D72DFA42
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682060; cv=none; b=fyL/A/LqM5e7s0sEdSP2RSuJGEgza3qM6QSxz6yGcSWP22tPwEyWCaz2COVz53IAo4wkF/rg8u+exWyhfoyI6Vq7EsUp7VUp98fNxQfYSaOQsE1M65hzEYSM1ttv+/Q9gtwS6jiAwlqF+3w0IcXsdDxxYjHuMpyHC4G2AmQhRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682060; c=relaxed/simple;
	bh=kDWWk5Cm8hFBiObudWZIfYHjqEvfY5WfyYyH2K/VN5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EfKHwHVMFk6DqHyVTze9KgjHrEtwz4I0ghyziUTEbSQtIX3uR4lR2dFsja/7fl8JiDM5KaXp5bqGw3z6LpT6xLzs9okqvzMkAcnW54MS5h+2aS75+3mBWY/mRmzWml/0q682KXlqJoyeFLb4tezb7y+qWFy43VDCCQxy/nMhyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LBPjSt9/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LBPjSt9/"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2362e130be8so2405185ad.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682057; x=1750286857; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nC93RHTPJR0hYLcAds88MrDeKfUjJXJiIT9n5WyFK68=;
        b=LBPjSt9/b3rZmXRJnv2xZGz0HFKNuBBw4QVucn1C8pqmEyfQwx0sSeXb+4Kayy8/Ox
         ZNy49yeUkTVNibXh0/oHHgTd7zFicDkgu//gVtV2QwAhJYiny/3gi9h4bqHqcEIfPeBW
         VOsc6Pm0832WvDjEvUL9hb1zVuO0p02rloYa6r9w7N+QBjLEm4PkKFrss03C70V9lJV5
         th3/BHaxZ3YX51ADs/8T+GXQOXKyywV94SbBz5gRF4vXOlpnsqQ5jmprHqyK/d/e+GiY
         oE+ycihrfykoPWxAI4ddh4Qgk+Jz6VHZE/dWa8RLgvuOdytPUwDnYB83iwURn8UZlajI
         hLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682057; x=1750286857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nC93RHTPJR0hYLcAds88MrDeKfUjJXJiIT9n5WyFK68=;
        b=nnBsUjx2GuiU+fIRYvD9rhOcZAHRWJnyEdbxppwATVGO5xfyEtockwvdEYlJDS17db
         sfeGyOGNs9+QExfc2TaQYPxbDgL9qYbf2lGIQDiSQ9tuQWNxWRJCNiTITakoDkOLM8Vm
         xM9CPHWF6o9fTvU5Zg7lqjBGD2ayrvyEmr3GX2+at9Qxs2G71zA09yupAkhqbszRbjpB
         5nvCoIMEIhkoE1i9QRXvURybbwiMeyhHt4NDGZPv/DkYFZeoFdvbA/n4FGjJzEVbcqga
         Wf9dD95J5FhF5ug1gs8MgmS2jj9da7RVAWouuKRqw//A+g7w8H+NDVQSN8eI45ZJfrjr
         81qA==
X-Forwarded-Encrypted: i=1; AJvYcCV+JO7mseF9JioCvls12HBh7tONRfPo+UPS8aQgxXbeMLxXZGqDlhhzDjVA420aDlbOvUDjKjs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOtbM2PWfPcORQQyYvoe/lbQVzYV1W95xXoDP18PwXyPng8hwd
	rMq1Pg7KfNZXTqRwiEX4SUB5KSoppZ21pIOFSUN0DHCJQqxTyRhrBbkn+nnmZfTIKuZUPtnBqFy
	iTkCg/g==
X-Google-Smtp-Source: AGHT+IHC+tL/ohPatgcKOK+9NRFx6tDroVAP77vbD+LWVMPFcp/p0UPjT16l7BqZ0WY1gMWbfEU6vC1Hc9s=
X-Received: from plhb13.prod.google.com ([2002:a17:903:228d:b0:235:eb8d:8024])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c94f:b0:234:bc4e:4eb8
 with SMTP id d9443c01a7336-2364caba922mr14235635ad.46.1749682056865; Wed, 11
 Jun 2025 15:47:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:27 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-26-seanjc@google.com>
Subject: [PATCH v3 24/62] KVM: VMX: Stop walking list of routing table entries
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

Now that KVM provides the to-be-updated routing entry, stop walking the
routing table to find that entry.  KVM, via setup_routing_entry() and
sanity checked by kvm_get_msi_route(), disallows having a GSI configured
to trigger multiple MSIs, i.e. the for-loop can only process one entry.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 100 +++++++++++----------------------
 1 file changed, 33 insertions(+), 67 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index d4826a6b674f..e59eae11f476 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -302,78 +302,44 @@ int vmx_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		       unsigned int host_irq, uint32_t guest_irq,
 		       struct kvm_kernel_irq_routing_entry *new)
 {
-	struct kvm_kernel_irq_routing_entry *e;
-	struct kvm_irq_routing_table *irq_rt;
-	bool enable_remapped_mode = true;
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
-	bool set = !!new;
-	int idx, ret = 0;
 
 	if (!vmx_can_use_vtd_pi(kvm))
 		return 0;
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
-	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
-	if (guest_irq >= irq_rt->nr_rt_entries ||
-	    hlist_empty(&irq_rt->map[guest_irq])) {
-		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
-			     guest_irq, irq_rt->nr_rt_entries);
-		goto out;
-	}
-
-	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
-		if (e->type != KVM_IRQ_ROUTING_MSI)
-			continue;
-
-		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
-
-		/*
-		 * VT-d PI cannot support posting multicast/broadcast
-		 * interrupts to a vCPU, we still use interrupt remapping
-		 * for these kind of interrupts.
-		 *
-		 * For lowest-priority interrupts, we only support
-		 * those with single CPU as the destination, e.g. user
-		 * configures the interrupts via /proc/irq or uses
-		 * irqbalance to make the interrupts single-CPU.
-		 *
-		 * We will support full lowest-priority interrupt later.
-		 *
-		 * In addition, we can only inject generic interrupts using
-		 * the PI mechanism, refuse to route others through it.
-		 */
-
-		kvm_set_msi_irq(kvm, e, &irq);
-		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-		    !kvm_irq_is_postable(&irq))
-			continue;
-
-		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
-		vcpu_info.vector = irq.vector;
-
-		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
-				vcpu_info.vector, vcpu_info.pi_desc_addr, set);
-
-		if (!set)
-			continue;
-
-		enable_remapped_mode = false;
-
-		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
-		if (ret < 0) {
-			printk(KERN_INFO "%s: failed to update PI IRTE\n",
-					__func__);
-			goto out;
-		}
-	}
-
-	if (enable_remapped_mode)
-		ret = irq_set_vcpu_affinity(host_irq, NULL);
-
-	ret = 0;
-out:
-	srcu_read_unlock(&kvm->irq_srcu, idx);
-	return ret;
+	/*
+	 * VT-d PI cannot support posting multicast/broadcast
+	 * interrupts to a vCPU, we still use interrupt remapping
+	 * for these kind of interrupts.
+	 *
+	 * For lowest-priority interrupts, we only support
+	 * those with single CPU as the destination, e.g. user
+	 * configures the interrupts via /proc/irq or uses
+	 * irqbalance to make the interrupts single-CPU.
+	 *
+	 * We will support full lowest-priority interrupt later.
+	 *
+	 * In addition, we can only inject generic interrupts using
+	 * the PI mechanism, refuse to route others through it.
+	 */
+	if (!new || new->type != KVM_IRQ_ROUTING_MSI)
+		goto do_remapping;
+
+	kvm_set_msi_irq(kvm, new, &irq);
+
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq))
+		goto do_remapping;
+
+	vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
+	vcpu_info.vector = irq.vector;
+
+	trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, guest_irq,
+				 vcpu_info.vector, vcpu_info.pi_desc_addr, true);
+
+	return irq_set_vcpu_affinity(host_irq, &vcpu_info);
+do_remapping:
+	return irq_set_vcpu_affinity(host_irq, NULL);
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog

