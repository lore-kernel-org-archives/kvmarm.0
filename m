Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05C2E62BA
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682064; cv=none; b=VxPFfguNzoO8WWJqs1wyfLWX5CsbPV1Uonf1ZYt0CQbWkV1WD7hkUonhIrsEThxougiMktzlbRRRIW/sw1sMZ4YLaAX/31rT/Gi1v+V4LV/IJEuBgP2cge21FEsNYP3uKsqDlaxYZKH/zD3l7uyc+gURLSkMhBUHJCGb1RpGX08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682064; c=relaxed/simple;
	bh=uXv1JJhJ7y+b5ncL0qkl5w2p8YdTPS1EEOU//fa5q8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jTzUW+xnQ67LboTBSadEK4BwpOcAP0mXtg+Ym2SjWfqQXjd1oykfFMPhPSgQMRcWCjg6C1tQBIj2b14zCy0smnkq1GbPay16JNKD55qLmGLqlT9l2YN0/eifUXrc85U8yfBIeVld3lXHZ2S9sT91pT2BuMW75AvUXItrtk7iSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ro/PEbXx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ro/PEbXx"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74880a02689so83962b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682062; x=1750286862; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hWHk4g1Vwy67+s92oAAb3P4JIkRwWseZejUTZj9H+ss=;
        b=ro/PEbXx4A4Q367SpjLS/VXZXE2CRnblhPJEadrNNPBDBOT4sv+fDOD1MtVrkWFIdC
         CIPT8D279Getzx5oKDHbUyJpqR8qln7DPHzv4JPuAGbSOaJC1+5PMBxbB2bE9j0IOGkW
         6gsZX4pqmFKewrIEijJhCVoIEum2m9KXG6XquvTKk2SW83aagjqSEFKxaalMqWJCUFsg
         kp8avUttAyD5DPWt0VHXqJBOL5FoNX6hP7jDyPJcY1oYjMBYxc8pjyQgY5VCWiG5sUJu
         T1+B+JhS3IuJeukOLK9bMEFZNKWcQP7hj43MyvV/2B5Z2axcH44QYXMjFv4Z9cNjgU30
         zWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682062; x=1750286862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hWHk4g1Vwy67+s92oAAb3P4JIkRwWseZejUTZj9H+ss=;
        b=ElxfYVdg7iM1QFOgsZ9Rg2oRYc6y0nKp/f/O+Z4VvKocnxKx/szpM+17hNOSV+7qHZ
         QTkcpgUji3L8UlULfwY2xmewou20oXhcnzgT/TsA1yyzf3D0CyCnIPIljhSQ0xdXjZ1B
         E95GYkMBOcZItQ33ktIL1jW3CBFj7T3rT241Vn/wImopc4kMvjFbEmst6iwcGMBODtky
         qVmVXVONVz+/1GDE95tkXByS/L0FdMyxeOvKWa3l4f/Lc7JvRQL6txmidI7YLPvGWnR9
         RFHA81OGSZK6+8ReCyOhwUQES3yCyP6mUedBAalKTvyUMaelSDjb6/UKt8CkH8iOMVtj
         JvjA==
X-Forwarded-Encrypted: i=1; AJvYcCXV3oT8Umhr52oSwhwhYVGElYjb2Wnj0kFQ3kY9ufe8CcGPRWw5GdtIkv6a6r/lp0QHHQS95Gw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTxwMZ4vVEIM8mwbxR6Nccp0gKFRgJFvJgFUxeguPTiqZUkRWm
	PBpSjZiZ/hOdQn0y1zCOKIGx9EbMxbN47UQI7Jl/OlOcl9qvRP00mM1HqjHdmW1dAXZXKicNUt4
	k8UXPgw==
X-Google-Smtp-Source: AGHT+IFmVhbjucYXuzMglz700r5SKDcVNbLOfHQ/SQsr3MFTg4okaXCI4Ylw5BtYSrn3coqW+U0cp+uUzfA=
X-Received: from pfbhe19.prod.google.com ([2002:a05:6a00:6613:b0:747:a305:836a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a89:b0:748:2e1a:84e3
 with SMTP id d2e1a72fcca58-7486cb4a9famr8199641b3a.8.1749682062215; Wed, 11
 Jun 2025 15:47:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:30 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-29-seanjc@google.com>
Subject: [PATCH v3 27/62] KVM: x86: Nullify irqfd->producer after updating IRTEs
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

Nullify irqfd->producer (when it's going away) _after_ updating IRTEs so
that the producer can be queried during the update.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b9d3ec72037c..09f7a5cdca7d 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -549,7 +549,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * KVM must relinquish control of the IRTE.
 	 */
 	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = NULL;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
@@ -558,10 +557,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
 	}
+	irqfd->producer = NULL;
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-
 	kvm_arch_end_assignment(irqfd->kvm);
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog

