Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E69188CDA
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038087; cv=none; b=FRgyknZuXE+BAZeYRbjaZv7aorvrXUjARCuEHFwBGEYkrhNQXVZ+sTsQtbAs5GSXdy9q8gKWRubQZmDsAB7EPmoz2cS1MWtJ9NgMm6krOsnXVkIMRYQ0rOmghiuL2CELBuewC7HgrFswU6Hxjv/W+p9C+sJG+fStpeJMvGMlX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038087; c=relaxed/simple;
	bh=fhSce6+NlER4lqSnBEsOz4PUKkoojvsuOboKzHVrVQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gshFRcgkP42sjTbxt3wvKLctVZ4BGhy0sV/nTIP/dVhe7K4tsr+dkLRVhKkNsXonU743RtGne5LcjdEMsYqBo3r+Qzkm04jzGwlQPqe1BjNxpdML+18ymFxGToEFQh3+dkUhnodOV7A7AV3ZBWScrlI5Na/R3if3IPHGpOTcYIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o408oTVl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o408oTVl"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc5652f7d4so11486125ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038085; x=1722642885; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fnzANaCry6VTBaaBvIzLI2Urcy+eNpGQjPUes1ZSEvM=;
        b=o408oTVls24mFwHEKxZ9rff7ceR233WBZkC6bCd/HfGR8kNP8K1ck2tzXjBqDnxgwB
         qxWbUgNlX8jCZRdjYqG0fTxjQm4HuXAho9mlnxKQCC2zUREdRxsRwv2aSPKEfflXVLpk
         sxkOYgGIW/YTjsAff277+YOuNjdknK17lzzPy3T7WcoToiOB0cEi8K+oUXMTKEMvW/BQ
         o1vFZphsiVfsV8Nc+6J8UYjh0rYAb3VEcvD+B6GoEXUAjydGySRCJuh20up26edAhSzs
         3dX6/qdnpF+Oc5bLjTscjyXfB8BHrS0s7qZ0I+DH1QtywWclJPQTjR+RDpghUV+XpkfU
         7Uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038085; x=1722642885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnzANaCry6VTBaaBvIzLI2Urcy+eNpGQjPUes1ZSEvM=;
        b=RQFmlXyh9F+3KdN3nIvdhEAxTC9+zdv/w4Mpjt1UUUjD8clcQgRGaykpYjyeBC21T2
         iFGAdCoiIu+FkQnpLJaZr78C7E5CHEcSkSfr++/t+3Iej50LFcRzAvDWqKFJg2xjnO9e
         iYAqIIJxxk+OKlz4SWHktOrmlHEjgtR5v+cd91DzVOcFHhfOo6ZTNOIGXgXu/JbgtSQq
         VIb+LWPip11ZmRVponLphTzpi4GbE86pLcLhVCVt8yrsUcmHGksvEp8D8QDPTBTm2Hw9
         hyZuezhfKUa/O94Qq1hKQWyBxeVPJErN9zz7NGXNjjylZ0Cs3ImuTsJ4vh81f5bK2Xny
         0DFw==
X-Forwarded-Encrypted: i=1; AJvYcCVLtmjKs3btCz/5H/qY4NbCpcwx87ngKqgsFFWOg8FyYICc5xwP3r6MEpXrV64Wt7gtRgxQdUXfwwp/wsFVYFgGAo/DRcXU
X-Gm-Message-State: AOJu0YzWiaLp+D8twtcvQ9tTOrjOOR8JyWqXmey43+vfPmdytz/MLHN3
	hvum4ndaN8+jOQGUm5H1d5JSt6+o1mYK57Zo4n/LmtRAibcdbcUWXPct/5aSE5I/jPm6e3B6F0a
	r+g==
X-Google-Smtp-Source: AGHT+IHmHH2jIucYiOpERpDS4ASgx5TvMHlaOIj1nvo/BSmO2/veDdrUl5Q72dqDHu1wFellCWvE9VI+k4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:11d0:b0:1fb:6b70:8f6a with SMTP id
 d9443c01a7336-1ff04917c5dmr841815ad.11.1722038084875; Fri, 26 Jul 2024
 16:54:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:10 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-62-seanjc@google.com>
Subject: [PATCH v12 61/84] KVM: PPC: Drop unused @kvm_ro param from kvmppc_book3s_instantiate_page()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Drop @kvm_ro from kvmppc_book3s_instantiate_page() as it is now only
written, and never read.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_book3s.h  | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++----
 arch/powerpc/kvm/book3s_hv_nested.c    | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 3e1e2a698c9e..34e8f0b7b345 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -203,7 +203,7 @@ extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested,
 extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				unsigned long gpa,
 				struct kvm_memory_slot *memslot,
-				bool writing, bool kvm_ro,
+				bool writing,
 				pte_t *inserted_pte, unsigned int *levelp);
 extern int kvmppc_init_vm_radix(struct kvm *kvm);
 extern void kvmppc_free_radix(struct kvm *kvm);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 14891d0a3b73..b3e6e73d6a08 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -821,7 +821,7 @@ bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested, bool writing,
 int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				   unsigned long gpa,
 				   struct kvm_memory_slot *memslot,
-				   bool writing, bool kvm_ro,
+				   bool writing,
 				   pte_t *inserted_pte, unsigned int *levelp)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -931,7 +931,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	struct kvm_memory_slot *memslot;
 	long ret;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 
 	/* Check for unusual errors */
 	if (dsisr & DSISR_UNSUPP_MMU) {
@@ -984,7 +983,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* Failed to set the reference/change bits */
@@ -1002,7 +1000,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 
 	/* Try to insert a pte */
 	ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot, writing,
-					     kvm_ro, NULL, NULL);
+					     NULL, NULL);
 
 	if (ret == 0 || ret == -EAGAIN)
 		ret = RESUME_GUEST;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 05f5220960c6..771173509617 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1527,7 +1527,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	unsigned long n_gpa, gpa, gfn, perm = 0UL;
 	unsigned int shift, l1_shift, level;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 	long int ret;
 
 	if (!gp->l1_gr_to_hr) {
@@ -1607,7 +1606,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* 2. Find the host pte for this L1 guest real address */
@@ -1629,7 +1627,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	if (!pte_present(pte) || (writing && !(pte_val(pte) & _PAGE_WRITE))) {
 		/* No suitable pte found -> try to insert a mapping */
 		ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot,
-					writing, kvm_ro, &pte, &level);
+					writing, &pte, &level);
 		if (ret == -EAGAIN)
 			return RESUME_GUEST;
 		else if (ret)
-- 
2.46.0.rc1.232.g9752f9e123-goog

