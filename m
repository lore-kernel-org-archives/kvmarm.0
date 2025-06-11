Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB822EACE1
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682100; cv=none; b=gBeQxbpOipstlanoZzdxuDLSzSa2RcRM+6hnBDcc8PWrz0C/JAulLClW88zhjmSbiIB7SAGymXO35zhkxYn6TH/WMyNbz8O3okk6uP7yVGPpYSXf7bqaYoUG0nspBoGRiGjrZ4/iOzI75KfCvclwXZaXAMpH4DIoJBQwhFhCCWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682100; c=relaxed/simple;
	bh=CDdmw6dFL6wn+8FcljdzaGx8a8PnN2FcUrIylCf+kXA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dygU6hzNXcJsD7C8DdwhCnYimKGhvWudFPZt8dQZswgoixKeAQc+mJDseaFCzZbMdiqob7BD+ODie5K1Igjj6fHsQfN8MPDH5r/rYBSW2/fkC5LqX/iaNhcynRs1ZxIYD27OR/B7l/OFgANauP5UtocqVcmVFkDKTNxbC4fGE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HN6rAomq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HN6rAomq"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7398d70abbfso375791b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682099; x=1750286899; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PBmMQxjdJ9cFQvfjWX4n11ei39HpxV6UN/bk9QZ1bLc=;
        b=HN6rAomqBoJOnmK7bo1qh74XARh65hAY4zv2qMOsbx5IU3lnR3v9a9xpCQCaTeyRoO
         73giR5z8NIXkW5e8FPhChKsTTlbE3SG+NjQXT4tv5Z5ovyOUbqYm6ByLaFeECCPWR8hf
         yYoiFc8uBsAPvhgXWJyl0SGqyNs9YHw10gCHJ2VixS/92pjBWLF1cwockqo89nV6CScX
         NfrcPGzhwb9DLN4339qxBFP6ptuqVhTi0qI/NxlYr7V1f86jlRwiwIb9i8Np7RiH1862
         ASmazr0cNxrhEmJtBOJQamFnj0S0dbh0S9ihlF1jaFEA02MH6/cxRS8KiaK/aHQmLZnw
         /+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682099; x=1750286899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PBmMQxjdJ9cFQvfjWX4n11ei39HpxV6UN/bk9QZ1bLc=;
        b=NUIzWRuYwC30umas0+7rTWT0q3OrNe5whxm8FyBz3Z0RUGMWShykE55vdgBJZPr9eP
         wnNW4Mhz1R2ekfyZHuOdfUaYHPo80dw1MFkO+6YW+PUURcr3950Ws1ExDFAE6Umtw82c
         pF15fE4U/e67VzM2E4J3ON6pWqHEwnNFM0lN0XC3u4OnJ4Hl+Lop3NRHW13AMysbB645
         CMeJwP6sJJf4JJ7qUQ6YROAxwu3MF1ZfyKZ8yqaBeOK8HG8H/vYCu1OfWPS3Sqp1gcVz
         Vnb4qVon6uBqUip+BuHeAFBxDf2aLG6+hfO1gOt19El02Fxm8U96N48z6ePrvk7RTtio
         vb7g==
X-Forwarded-Encrypted: i=1; AJvYcCVxYZkfqkrQE0tRJ98xXGNeixLelpIc86qB0/C1TsKqdolnd3jrME8ayuYpWrzv4DO13iAmkgM=@lists.linux.dev
X-Gm-Message-State: AOJu0YztI2NlqMW9Df+ig4mTBNGHWommV6k0JU6P6MdBe1CVIxvbqzhN
	awST59T/Oyh+UBcfu8OnFqKgjB5W5leEotVVlvFB1Pki5X31XcNpbQLLVjY0fbeGOS3nn2nXE5d
	jI1xIig==
X-Google-Smtp-Source: AGHT+IEBM47Uz2X6xS0CCAIos8ahR8hfvX5maaZpinfB8zlXBAyKSgRG4LiJD4Zyz26rgc00CLciKxSYoFk=
X-Received: from pfbk13.prod.google.com ([2002:a05:6a00:b00d:b0:746:21fd:3f7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1387:b0:73e:30dc:bb9b
 with SMTP id d2e1a72fcca58-7486cb721aemr6046845b3a.2.1749682098847; Wed, 11
 Jun 2025 15:48:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:51 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-50-seanjc@google.com>
Subject: [PATCH v3 48/62] KVM: SVM: WARN if updating IRTE GA fields in IOMMU fails
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

WARN if updating GA information for an IRTE entry fails as modifying an
IRTE should only fail if KVM is buggy, e.g. has stale metadata, and
because returning an error that is always ignored is pointless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 24e07f075646..d1f7b35c1b02 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -834,9 +834,8 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
+static void avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
-	int ret = 0;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_kernel_irqfd *irqfd;
 
@@ -847,12 +846,10 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
 	if (list_empty(&svm->ir_list))
-		return 0;
+		return;
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list)
-		ret = amd_iommu_update_ga(cpu, irqfd->irq_bypass_data);
-
-	return ret;
+		WARN_ON_ONCE(amd_iommu_update_ga(cpu, irqfd->irq_bypass_data));
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.50.0.rc1.591.g9c95f17f64-goog

