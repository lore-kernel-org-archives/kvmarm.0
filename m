Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC22025CC57
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682031; cv=none; b=aA5WScYd4+U5fOHpgiKGw5S57OO+rAtZJh66WO2K/Ao5Q02sJ3qGuCt8jkTJz2FQRe4o3K6ipNwNIqJGj7jL4pPtB0ibZWmrl2+eqT6SRl35NJkNq/ZKPMYDHhPmhPyJ60GG0AVl12l9I0iX3iW+QtqnoSqyPWctHo87wSyqXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682031; c=relaxed/simple;
	bh=veIQi8e0iCtzXQM8NcdDzO8ccwAXQEovrCAVSPv1kJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BRQyfEw3nMiwfGJqU3dSJIw8NzKYQ31281GMKLNeYH/aJOE35VbMksSA7rC43hNrD6d2yAzLXydLtAoihwixnyXpjD0MhxUqbvOjiC3fMsk4gPuRw1pGZpaNHb7mw1EGbnnlQnZancuqBH1o2EVFT0XGfx5Emy2ewvMwAm6rNuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RGnMYgIs; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RGnMYgIs"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747ddba7c90so265233b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682028; x=1750286828; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tDZohEtmrHKYD6EovcSC8/ZzfIWWO2Pel/+WswkGVp8=;
        b=RGnMYgIsYcLJeWFRDupQnKVgAghwr80ddxfp2cbe3rRfHNZRgK7P9BUfmhqE6mwC8E
         4fwU5sPzTudRushXhgTznz5XfCbEy45iQVAMv16OqHVMygC8xcWbYv7uVT7YFbFKc2ZO
         Y6mGNW009RvdS+v8CxpI1ti3wCJQItAyi1TDihUxsJ7h93aqO9bpcfp6aL+8eKbXWfY9
         K34mbrysnCE6gUcr218CJUcQ8CCWKHT2ZHqxMrdE/GcV1vH/mT1bTWETDGFlq1Kdw62U
         R2GlaTuL2b0aMeq4Z9DJ2SNCYBUNt3AXtqf7IIkHHWBKZcnpnmMgXbNLE/P9Odcp4fuU
         idaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682028; x=1750286828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDZohEtmrHKYD6EovcSC8/ZzfIWWO2Pel/+WswkGVp8=;
        b=O8imIRBl0kbILy2SAqB7R4McM38TGUKscRQRMIJsPjdCGnQWu/af99jWeg1lz7duVH
         z8JRbM2YN7jU25nN5EGmsa2esnAZC+2FR0Imr4A6ujbHr24tP8kWQLv1/zpWqtn/eGGQ
         liqcURhV4XJhHExwTV+dqegA2I4Dp3AGVIFx+hQDa6eSsSTXwIgY/Q/zAL0BafC0cwxN
         lFUS9i3JDK2QU6nV0ShTdCecmstet8J8mcI1Pcw2tC7F3uZqy/actCvoVywUGXjS74Bn
         uAn2/9MQK9EyNWkKYrFgJbW/1PIW+EvR8gUbdrCBnJPY7/Et9HJcokJzPzylycg5nLOu
         5Bpw==
X-Forwarded-Encrypted: i=1; AJvYcCX0UeaHXw3Ny5l3eySXoooD+DF/zHirk2g+k/57QpYv5z7qtE1s2ylLOJobWXtGI438k+YpDZ8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/T8gWeik2xzZDVHSAk7J0uzPat3PeTAKtBNaFGIhrEJFGqLuj
	dhPDJ642ZRZ0H8jbHM+407xZnH8JAvAH1jfkh9kmqudWD6NGJ54jeahk0JCQTz1dz26tcucrmIU
	fejJgvw==
X-Google-Smtp-Source: AGHT+IHgXSfJU2sxyG9OW4VojMH2BSFfhS8bYIS64Jcg4Y6OGr2dvtrGuU93NG67KzexoKMXwohALrIyyio=
X-Received: from pfic6.prod.google.com ([2002:a62:e806:0:b0:746:2117:6f55])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2294:b0:742:a111:ee6f
 with SMTP id d2e1a72fcca58-7487c21ba8bmr1432295b3a.10.1749682028151; Wed, 11
 Jun 2025 15:47:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:10 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-9-seanjc@google.com>
Subject: [PATCH v3 07/62] KVM: SVM: Delete IRTE link from previous vCPU
 irrespective of new routing
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

Delete the IRTE link from the previous vCPU irrespective of the new
routing state, i.e. even if the IRTE won't be configured to post IRQs to a
vCPU.  Whether or not the new route is postable as no bearing on the *old*
route.  Failure to delete the link can result in KVM incorrectly updating
the IRTE, e.g. if the "old" vCPU is scheduled in/out.

Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4e8380d2f017..c981ce764b45 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -861,6 +861,12 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	if (!kvm_arch_has_assigned_device(kvm) || !kvm_arch_has_irq_bypass())
 		return 0;
 
+	/*
+	 * If the IRQ was affined to a different vCPU, remove the IRTE metadata
+	 * from the *previous* vCPU's list.
+	 */
+	svm_ir_list_del(irqfd);
+
 	pr_debug("SVM: %s: host_irq=%#x, guest_irq=%#x, set=%#x\n",
 		 __func__, host_irq, guest_irq, set);
 
@@ -883,8 +889,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 
 		WARN_ON_ONCE(new && memcmp(e, new, sizeof(*new)));
 
-		svm_ir_list_del(irqfd);
-
 		/**
 		 * Here, we setup with legacy mode in the following cases:
 		 * 1. When cannot target interrupt to a specific vcpu.
-- 
2.50.0.rc1.591.g9c95f17f64-goog

