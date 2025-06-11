Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815742ED856
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682117; cv=none; b=LVdVmOP1mjP0/mFbY781LteYqyyLJLm/Scu8ugT5nTDNP+0JAc0w4rOlGNWjD0MOBSUSE9+z3Dgec8jDRYtH6ztVjFDUhq/kkEtk7u2Nv47kcKMjLuW41O1BOQjOTWn0aDVDkWXuaFPAiQ16nekz1A+0ojv/wh+TUamFAANOZ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682117; c=relaxed/simple;
	bh=j5HZ30o1gx8s74E/i+Mz5x9+bIQZioDRwMF5in66Quo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r+vJjlyUoJ1TQe491s2MI9X0Uft9JsV1pn7MDMqtL0RbHG0SPk0869HCRzJ7XQK6FjRGBNLT4VebzHJY9/tK6NvVof9YmGUQbFtlaelRjkmLtVL02c4Dytr1VudYn4W3ZPgYYCM9ZPdLdrVqcX7qW9+myfiTIWn6WUPFv9Y9sO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PQ7ZD+W0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PQ7ZD+W0"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so311616a91.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682115; x=1750286915; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EDp2MAm1ts1xFlPsVR9eKX3SKPzdTZ7kBVeXKS2SKzA=;
        b=PQ7ZD+W0uUrBwPBxRN0fhlS10inA84G3YYqADfIGA2etBhJblEKwmXN26E1L53txq4
         vqooG98+gAD6H2At2vrkPhVgMurQjjbvsAC8zF1OQE7aL8aOR65iSe3UHYl4B/0cMOZu
         kP3UHZWCPIGaW87KhZ0RfSmM27u9sQeFsiDKDi6ANNj2ZvlYo5uekG7PEGeiOyx089N6
         q4+aD2KFe6KjkOFFVezs2rdVcguWWN7FoNta48yonZCBc+3O2R6zAedrO0aILB6snwWw
         f44EZQHqhXfedOYirUUhVhLqja3SRA42AI4mdaXmRFY4k6epy1qp++Nd1nDt+n05Hjge
         8/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682115; x=1750286915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EDp2MAm1ts1xFlPsVR9eKX3SKPzdTZ7kBVeXKS2SKzA=;
        b=Xmpk3c0kWM8fLw1xqJuzzPQvHXohjnbHOrLYPO2pI8TzZV7kxKp38rGLzunluDGlAJ
         9AKZd3bNRQOSQdait7niN4X6s2bTbey4A8dn1Zg3/U5AbdzCaSBhFzUcFfExScULu+cD
         +myutnACTZ9cOW9cvwuTytBx6ouE23BwSpgYXLo6EqbT7BYdXO1B2dLm0Cg0f7g1/TUv
         FsZFb4YBJHTQfVGrzH47pGojMjQl04tasD7Ad/Yxg0NGjDslxv5OZxK1ECuv5OiZMqrO
         7/kMsOwBsN82qd9zD3pXI40A39WitQJ0T026c7NgjkQVWpNOmEXMDPh403A/qJZTo/mm
         bcvA==
X-Forwarded-Encrypted: i=1; AJvYcCWkEKFVyMJe5ovjJ52JORvVhRM8xVFCs1j9Yz5xir/1TTnpV/xh/p42bM6lll/aenbHX2seEBg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYsy2A0UBEPx3peonPxSgy8AB28xfsHDqGpaX7/kwSMsepAjIy
	t4DcoBtg41354QzI/UGlJ4FH/23MN+2Vp8UAeD1eb2DCK63sxLjrB1CKO6RP9JsW1zsyh7h2WkK
	QIpIABA==
X-Google-Smtp-Source: AGHT+IEbfo0mMPt12ljEjE30pCWmP1qbKv/AIuMxYG67rAiSNKYcSiWLenrS7AYH9QEP9z44f7kSaVHJGlo=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:311:d264:6f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c6:b0:312:f650:c795
 with SMTP id 98e67ed59e1d1-313c08b05afmr1045053a91.21.1749682114717; Wed, 11
 Jun 2025 15:48:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:00 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-59-seanjc@google.com>
Subject: [PATCH v3 57/62] KVM: SVM: Fold avic_set_pi_irte_mode() into its sole caller
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

Fold avic_set_pi_irte_mode() into avic_refresh_apicv_exec_ctrl() in
anticipation of moving the __avic_vcpu_{load,put}() calls into the
critical section, and because having a one-off helper with a name that's
easily confused with avic_pi_update_irte() is unnecessary.

No functional change intended.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 52 ++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bb74705d6cfd..9ddec6f3ad41 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -728,34 +728,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-static void avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
-{
-	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	unsigned long flags;
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_kernel_irqfd *irqfd;
-
-	/*
-	 * Here, we go through the per-vcpu ir_list to update all existing
-	 * interrupt remapping table entry targeting this vcpu.
-	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
-	if (list_empty(&svm->ir_list))
-		goto out;
-
-	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
-		void *data = irqfd->irq_bypass_data;
-
-		if (activate)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
-		else
-			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-}
-
 static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 {
 	struct kvm_vcpu *vcpu = irqfd->irq_bypass_vcpu;
@@ -990,6 +962,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	bool activated = kvm_vcpu_apicv_active(vcpu);
+	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_kernel_irqfd *irqfd;
+	unsigned long flags;
 
 	if (!enable_apicv)
 		return;
@@ -1001,7 +977,25 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	else
 		avic_vcpu_put(vcpu);
 
-	avic_set_pi_irte_mode(vcpu, activated);
+	/*
+	 * Here, we go through the per-vcpu ir_list to update all existing
+	 * interrupt remapping table entry targeting this vcpu.
+	 */
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
+	if (list_empty(&svm->ir_list))
+		goto out;
+
+	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		void *data = irqfd->irq_bypass_data;
+
+		if (activated)
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
+		else
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
+	}
+out:
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.50.0.rc1.591.g9c95f17f64-goog

