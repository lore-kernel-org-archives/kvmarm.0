Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2B2E62DD
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682077; cv=none; b=jWrf4ssrkcwbXoSlMhKgZ3EqqJnHBnLJVErSVypsXcuFU/kNaiFOBaTiwOinMNHVJnlIRi9rSzIwVNKL7HRn3CCfR+NZUA9onclexuy2FgHWcsvDmnowA8X8+Liq1lFB4RqVxEVR1x81szACEw08iviSbk89DEyRWD2upRb7jy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682077; c=relaxed/simple;
	bh=kywKfKPTKKbP5xL2C71yOUcn3SiU0Y8qTPlvnXK8BT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HzFx1vFEyyrVQ9x1JkJmMq9znibJRRJvZ/5K8MmcmO/5iB7lCWwlwUUzYq2fkzSDI0kSnxJ8SPcIBfJuaNdJwsqqvXkPYIN6HIyV6vlqLrynZhprfCTXDjXOSbzEqFtV955uUeLvvQF8tg3L9I0by8t1f95aNQhgLL9lsUeV8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sMYJG2ge; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sMYJG2ge"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e1d70d67so2357755ad.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682074; x=1750286874; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t1v5tfF/UZZJDfH96jk5AIZx6aa1AacPrxrUndI2qrI=;
        b=sMYJG2ge5XQxnd9b+XmVMonFn0djWm14mnr7k6jSUXEUG02wN62WkN3dtWX6MxuTFI
         /G3tkI9q7IrY8zBR8JXoOpNX6mqyO+z63hgGcqA1ulOw+LJcN5GQEKuVsD7cE/aoHQR6
         lao+KJ9a9QdGHse2iAqc5REZLQVaEKg9cTeq1bGDIN5kkM6++NmAeKoIIBJLdCROISOH
         sujLUqmodha4ourfoQoYmU6rOU9a/tnRXrpKOuu7mYEGRBONm/EqYx4nUlVSv5xFIsiw
         11BNOeocK0H5UKkZKzUSnFAjCNG3aS8YAYCwfRA0+ARyElsq+uCP9v2z0fPl4mhHchCu
         ukPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682074; x=1750286874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t1v5tfF/UZZJDfH96jk5AIZx6aa1AacPrxrUndI2qrI=;
        b=Gr/Tbay2GSI7aZHBYdEEACXCSbPptrRI6FdhdmfkgirfZq2Fcz/jwxUxUZHHl61M84
         WpZ5ECzp8PCjfV0OTwSGio+8eUpiPflBBJkOGg9AQksqcYnvLBO+LhLm9lEGsyo0TdOg
         H2fX1a7CgDk/9O6Xz99BaBAC2fz+3Ox9NHo0PbzMKGC0IZRnIoTqqOxP24Jl8H2euEwm
         /L99OqqcypkdrIxNP0GB39nK8aWL+LuiSePmIpQ1F5y5OcRus7g3lQOh5UC+/mDc/3hE
         CkpAIGo3i3kQul/Cx9dHdwm1SoByrjq6IrKODhlerZ+4ihWg6Ta4wNvMI/QLY8Sdb1J0
         kvFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTzpMeIIzUgrfreheIEF1bldl17wN++OnyY8V5PblkbkzSZduGcp4rJljEKdJcdbzLN4glkSQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws1OTP78U3D70HAFdI6sLo/9eEIyJ7fKpByxjTcAejnHy6fgzg
	dY9SSgQvzpj5XtL5EJSFpuaSbLcf0xaB8nkGTFBdo0uGyrBNa5GuqGd2yRgpKQdTchWlmELeABS
	Fb0cb5g==
X-Google-Smtp-Source: AGHT+IHIOpTSYBslk2iwZ1Yvx7LxGgsjWNiUHu2s2XYfcpOZTsc6ZoL/od1AWVcDdNAHt+Yg97+L8Wtz5XQ=
X-Received: from pjbta5.prod.google.com ([2002:a17:90b:4ec5:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f4e:b0:234:cb4a:bc1b
 with SMTP id d9443c01a7336-2364d90f8acmr10461455ad.49.1749682074268; Wed, 11
 Jun 2025 15:47:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:37 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-36-seanjc@google.com>
Subject: [PATCH v3 34/62] KVM: x86: Track irq_bypass_vcpu in common x86 code
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

Track the vCPU that is being targeted for IRQ bypass, a.k.a. for a posted
IRQ, in common x86 code.  This will allow for additional consolidation of
the SVM and VMX code.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c      | 7 ++++++-
 arch/x86/kvm/svm/avic.c | 4 ----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 48134aebb541..6447ea518d01 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -544,8 +544,13 @@ static int kvm_pi_update_irte(struct kvm_kernel_irqfd *irqfd,
 
 	r = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, host_irq, irqfd->gsi,
 					 vcpu, irq.vector);
-	if (r)
+	if (r) {
+		WARN_ON_ONCE(irqfd->irq_bypass_vcpu && !vcpu);
+		irqfd->irq_bypass_vcpu = NULL;
 		return r;
+	}
+
+	irqfd->irq_bypass_vcpu = vcpu;
 
 	trace_kvm_pi_irte_update(host_irq, vcpu, irqfd->gsi, irq.vector, !!vcpu);
 	return 0;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6085a629c5e6..97b747e82012 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -767,22 +767,18 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_lock_irqsave(&to_svm(vcpu)->ir_list_lock, flags);
 	list_del(&irqfd->vcpu_list);
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
-
-	irqfd->irq_bypass_vcpu = NULL;
 }
 
 static int svm_ir_list_add(struct vcpu_svm *svm,
 			   struct kvm_kernel_irqfd *irqfd,
 			   struct amd_iommu_pi_data *pi)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 	unsigned long flags;
 	u64 entry;
 
 	if (WARN_ON_ONCE(!pi->ir_data))
 		return -EINVAL;
 
-	irqfd->irq_bypass_vcpu = vcpu;
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

