Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC02737E5
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682120; cv=none; b=NEGgJWESiap0x3xslP74GpZfpp9xhIyqjtxPC+x1HxBa4itQlaWob5tiALfYYWM2sJvv/fSEIzLJqc4/aCbSgw0ly7mvu70ls4DbGokAw4TdY4vQA/DQXHp25tEHcmUZcUCOLpyPln5URMM7BHA/06q1iN3aqvGo0ys2AEQpf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682120; c=relaxed/simple;
	bh=lIvMjX372TaEo1sG+VK0inIicUVhbjbjHr7g88Ou/Xs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CDGfR1WwSL4VL4omU22ii/P+GNqhp0o79sqDR2h/5OlfrnNIHxP+7AnspZYPinBipls6O5oaCZY1W9lL7XkmRLkzGDLYcMrvHBZ92LqgFzja35oJxVDfQnZTAN+MKjN/c62W41H5BvB2A9dp5gWDYP5nQPy7/86hjwttVuBL/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KZ+dlZtq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KZ+dlZtq"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73bfc657aefso225261b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682118; x=1750286918; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbXp9fY7meDnEME0LsYBGX1Fint2Pz95NNyIdmrjoGE=;
        b=KZ+dlZtqSdPyDhyn8dGae0m10qo3m6BJL5vuvn3ufS2GmGP9yXq7YzZuS8sLaqkNI+
         lTQXVH8rpRhAKTrtfG0W4RCoIzVIhQ0++z++37AemGC2G+kiIHsfX5B1Of87WCX0B8EY
         69Zfqj3WO9I0RlgNAJRoyOdJkLofqfVuGzZuRst6npEq8xFuW9cUF43hrX1Jd9Jd8ovq
         cOEv33qsVTJR0kHJG0gzM1AOGTFjgM0XVTVxd84970C3DQfFkebk4J/v8sxEXPG7o+ev
         CBGKVqlG4n6a+gh1g1wTtB38eV7hCtGti8S87L0qihxgEDB8RRmBmqddhLg9+RaYl/qY
         xHNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682118; x=1750286918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZbXp9fY7meDnEME0LsYBGX1Fint2Pz95NNyIdmrjoGE=;
        b=WiY+KQkAHi2LmxVNxqnHjpxebK7WPsVWY/arYFTtQWyRMQ0DbFz8CjbzsyJ6YzL51r
         F2474pR/S3023BaDPIVcAqUcSu+QdN1KYNMhsmtxGy89LI726/aJv6KBTFVs4beJ8Jck
         lfD5tkixNTug4HGD2bO1jyJi7ZWGI95adnnXZzYXEJS+rVlQWb2D1o+QmBwjU8BEqCoI
         mQrV7eIrTTJYomODUnsjsfhrDbfv9qBGhci5GYbGIg1Q9Yc7ic42Z5eO5SNsphWIq66U
         yfqnv2Odk0EJc0QZkFGeiz3cui9rfMMfSv6RV7inlAEqkI6599270PxJSeyFTGb7o7CO
         5EbA==
X-Forwarded-Encrypted: i=1; AJvYcCWpyYerzcJLpPEZtHxqTYfl5x1CJ8Fk4fjFxM27wcFrHHLlikAWUJqJlPuqxeDq9npe//iS65I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxJC8yBvz6UQa/djXnm6morLpkAli4tnPIyxxyQ3d1xhanIFlT
	QRfLnprRxbHSIqqQW6cge1WmMKrehROF/fXiPLXk2UDVtVs0ae7U/VMKVPrs6VmFVMIXVYpUAXw
	yxv6QRw==
X-Google-Smtp-Source: AGHT+IHvf3odZF8McDLukwtR+c5Ts/RiD+Gr/igRa+Gy+FZyAPIiyl4mAfkupeFQ3doXLOpmODAbezE5sRM=
X-Received: from pfblu14.prod.google.com ([2002:a05:6a00:748e:b0:747:aac7:7c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748c:b0:21d:375a:ee33
 with SMTP id adf61e73a8af0-21f9b6a21bbmr686227637.9.1749682117969; Wed, 11
 Jun 2025 15:48:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:46:02 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-61-seanjc@google.com>
Subject: [PATCH v3 59/62] KVM: SVM: Consolidate IRTE update when toggling AVIC on/off
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

Fold the IRTE modification logic in avic_refresh_apicv_exec_ctrl() into
__avic_vcpu_{load,put}(), and add a param to the helpers to communicate
whether or not AVIC is being toggled, i.e. if IRTE needs a "full" update,
or just a quick update to set the CPU and IsRun.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 85 ++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1e6e5d1f6b4e..2e47559a4134 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -810,7 +810,28 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+enum avic_vcpu_action {
+	/*
+	 * There is no need to differentiate between activate and deactivate,
+	 * as KVM only refreshes AVIC state when the vCPU is scheduled in and
+	 * isn't blocking, i.e. the pCPU must always be (in)valid when AVIC is
+	 * being (de)activated.
+	 */
+	AVIC_TOGGLE_ON_OFF	= BIT(0),
+	AVIC_ACTIVATE		= AVIC_TOGGLE_ON_OFF,
+	AVIC_DEACTIVATE		= AVIC_TOGGLE_ON_OFF,
+
+	/*
+	 * No unique action is required to deal with a vCPU that stops/starts
+	 * running, as IRTEs are configured to generate GALog interrupts at all
+	 * times.
+	 */
+	AVIC_START_RUNNING	= 0,
+	AVIC_STOP_RUNNING	= 0,
+};
+
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu,
+					    enum avic_vcpu_action action)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
@@ -824,11 +845,20 @@ static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 	if (list_empty(&svm->ir_list))
 		return;
 
-	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list)
-		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
+	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
+		void *data = irqfd->irq_bypass_data;
+
+		if (!(action & AVIC_TOGGLE_ON_OFF))
+			WARN_ON_ONCE(amd_iommu_update_ga(cpu, data));
+		else if (cpu >= 0)
+			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, cpu));
+		else
+			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
+	}
 }
 
-static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu,
+			     enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -873,7 +903,7 @@ static void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, action);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -890,10 +920,10 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
-	__avic_vcpu_load(vcpu, cpu);
+	__avic_vcpu_load(vcpu, cpu, AVIC_START_RUNNING);
 }
 
-static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
+static void __avic_vcpu_put(struct kvm_vcpu *vcpu, enum avic_vcpu_action action)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -915,7 +945,7 @@ static void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1);
+	avic_update_iommu_vcpu_affinity(vcpu, -1, action);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	svm->avic_physical_id_entry = entry;
@@ -941,7 +971,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
-	__avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
@@ -970,41 +1000,18 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
-	bool activated = kvm_vcpu_apicv_active(vcpu);
-	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_kernel_irqfd *irqfd;
-	unsigned long flags;
-
 	if (!enable_apicv)
 		return;
 
+	/* APICv should only be toggled on/off while the vCPU is running. */
+	WARN_ON_ONCE(kvm_vcpu_is_blocking(vcpu));
+
 	avic_refresh_virtual_apic_mode(vcpu);
 
-	if (activated)
-		__avic_vcpu_load(vcpu, vcpu->cpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		__avic_vcpu_load(vcpu, vcpu->cpu, AVIC_ACTIVATE);
 	else
-		__avic_vcpu_put(vcpu);
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
-		if (activated)
-			WARN_ON_ONCE(amd_iommu_activate_guest_mode(data, apic_id));
-		else
-			WARN_ON_ONCE(amd_iommu_deactivate_guest_mode(data));
-	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+		__avic_vcpu_put(vcpu, AVIC_DEACTIVATE);
 }
 
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -1030,7 +1037,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
 	 * to the vCPU while it's scheduled out.
 	 */
-	avic_vcpu_put(vcpu);
+	__avic_vcpu_put(vcpu, AVIC_STOP_RUNNING);
 }
 
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
-- 
2.50.0.rc1.591.g9c95f17f64-goog

