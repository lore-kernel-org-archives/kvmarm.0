Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A569B28DF00
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682040; cv=none; b=tHA1ZPa0TErKzMcwagr8/AZ2hzI90skysTPIgx2rKS2OyBjwn6lmXj01E6mbVni+MIrQSHvNJpMuaIfny2c2b8recNEb6R/XmYfox4J02ZyGrWu2o4f1bAX+InHtmEugqlzgZOUeSThITyefRUCrwkBKWZCsEp5k2EB1sUhMyxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682040; c=relaxed/simple;
	bh=BWLasIdcw5f8vbjvTCVYvqRanf2FcgiZB1H2kqLovb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tw3eMxH/keUKMRpLdFBj67RRYebetMrnYDXbmeE9V+j9ScCKKB1huVQ5FBHdI9nB5fH0VY+XiZvYHJXLSY81iMKKxzEIp967RvDWBSycD37c+SHnOpT2gz6nerM4zbawvVsdtJRCp95rTX1G35eBQS+f03DIYTi6AXIORqDt1ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lGQRjdgs; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lGQRjdgs"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74880a02689so83592b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682037; x=1750286837; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JgCcXi1lmHYVbCUjIr5w9EjZ1G5EUAljNN15QlkwBdI=;
        b=lGQRjdgsPGTRN7l519yLqTb9g2hvlfVjfMG1bCBGhQsszlUjNAZdSlMESio9WGq15y
         0VWUrZXaimyAR7MivlwT7hKPlY79vsW4+l0LWbkn7zbbPvvdW7JZrQWAzDhU6R6aVQ4U
         4CQr9+HtbTXDu5fUnKaZnahgBHYy3eeWmFS5MMdr4zwAy0ESTmsMKThj++Ys7IejSt5w
         lIky6F14BLhEEHsAx3m3Sim0scGRux/GAQRLa3MiKo512inZ0ggvundPdKhMQlFR3LBa
         1/+Opk9lUQtI1CerjJagd0Imf4gBQTozcOcWByw1+3XL51fokeGMuG9k6FCPdiRecIvA
         1n2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682037; x=1750286837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgCcXi1lmHYVbCUjIr5w9EjZ1G5EUAljNN15QlkwBdI=;
        b=fThN2OzVvq3+c/HqcPh60Md1BPzKZUIUedlFD3stBs+sow+5NH/VvMFI2A1HTeOzct
         DK6xrpvVN882YSAk9zOTCPJtIceiW6vEJss6rveZPCLR2upf4NCIkqQGYd8UOCzZ+FBE
         Juc8rMiftlz90MG89jRFyMiwKIYwwh9RZtnJeww8fYVbr5WAz9dX15fsUpQwIQ9GqJbS
         +VDIarUfNPIKKwszyVzOmZsaMml5ngrxSXGbZVhbgh7y+FQZcJ3ICQzVXBtqmuYIL8ji
         UvMjPIs3Lmlnb5I2rktnlzzX5/Aqj8vuE7HQJ+fOFTdNSM8TCU76Kvtd3iApAAeEpn2s
         Cptw==
X-Forwarded-Encrypted: i=1; AJvYcCVTPfr0WlmzZPce9KY58yYnrEV9mQefVFFmMuOAegTp/M8pZgueJrzrj73YdoMrmqCl5PRq/GE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5wVy9Ce9z8M6aebtdjT+cMYPrhlg+QtGKeUSPCodpdziIBM9G
	ExFILQi+CP7cRQGxvcGGcilXQQhwPzWix/JMpw1iRKVzmJH3eIFJxpsW+J9N9dC3KH6qA6eY+oE
	2aDag+Q==
X-Google-Smtp-Source: AGHT+IF4EOTklxmbKRQMt1i+V76Dzg8HGe7ggrexZxq1G9OoEFFOTzeyCP2Mfh9kf82SvgKjm1r87uoXRu8=
X-Received: from pfbna4.prod.google.com ([2002:a05:6a00:3e04:b0:746:2ae9:24a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8882:0:b0:73d:ff02:8d83
 with SMTP id d2e1a72fcca58-7486cb21c08mr7745118b3a.3.1749682037122; Wed, 11
 Jun 2025 15:47:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:15 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-14-seanjc@google.com>
Subject: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead of
 rejecting vCPU creation
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

Inhibit AVIC with a new "ID too big" flag if userspace creates a vCPU with
an ID that is too big, but otherwise allow vCPU creation to succeed.
Rejecting KVM_CREATE_VCPU with EINVAL violates KVM's ABI as KVM advertises
that the max vCPU ID is 4095, but disallows creating vCPUs with IDs bigger
than 254 (AVIC) or 511 (x2AVIC).

Alternatively, KVM could advertise an accurate value depending on which
AVIC mode is in use, but that wouldn't really solve the underlying problem,
e.g. would be a breaking change if KVM were to ever try and enable AVIC or
x2AVIC by default.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++++++-
 arch/x86/kvm/svm/avic.c         | 14 ++++++++++++--
 arch/x86/kvm/svm/svm.h          |  3 ++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2a6ef1398da7..a9b709db7c59 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1314,6 +1314,12 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
 
+	/*
+	 * AVIC is disabled because the vCPU's APIC ID is beyond the max
+	 * supported by AVIC/x2AVIC, i.e. the vCPU is unaddressable.
+	 */
+	APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG,
+
 	NR_APICV_INHIBIT_REASONS,
 };
 
@@ -1332,7 +1338,8 @@ enum kvm_apicv_inhibit {
 	__APICV_INHIBIT_REASON(IRQWIN),			\
 	__APICV_INHIBIT_REASON(PIT_REINJ),		\
 	__APICV_INHIBIT_REASON(SEV),			\
-	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
+	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED),	\
+	__APICV_INHIBIT_REASON(PHYSICAL_ID_TOO_BIG)
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ab228872a19b..f0a74b102c57 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -277,9 +277,19 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	int id = vcpu->vcpu_id;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
+	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
+	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
+	 * avic_vcpu_load() expects to be called if and only if the vCPU has
+	 * fully initialized AVIC.
+	 */
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
-	    (id > X2AVIC_MAX_PHYSICAL_ID))
-		return -EINVAL;
+	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
+		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
+		vcpu->arch.apic->apicv_active = false;
+		return 0;
+	}
 
 	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1585288200f4..71e3c003580e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -722,7 +722,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
 	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
-	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
+	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
+	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG)	\
 )
 
 bool avic_hardware_setup(void);
-- 
2.50.0.rc1.591.g9c95f17f64-goog

