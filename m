Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3B618509D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038066; cv=none; b=XnXm1hL+lo6eAA9ish1InxnYSuNQTBWntkjIck3i9UUyuZyBtkAruOW+e1VAvsKoofaMDXnRgx8GPV02lauIfCVj7PTjA2XgdklstR/c/1p+tnixsFU3RxYPMFqUZWttChPNDqvrWzc2o/iCEyTtjFWs83+vjF39xWi03AtXYZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038066; c=relaxed/simple;
	bh=VbnqqafRlYMVLvo8/KpvTNYaOUVhm0RY4zV5HGgCgQE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G3WoUW660LVRYClTWDk0YG+Q3agz7osa5MRfo3TdmV6Se+3/V+NZmbRJO1JakoN6+gdJ1OnteBwyCbyMTwJLzgo7Ud5/FiwcA7J3D78fBvxMWpVgcKsly+1aYJEbOiVUOYK5B/sCYQg51KNjoGJammizfoZSGf0FF0ty5blU9f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MzUAcr/E; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MzUAcr/E"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-668e964ffd9so6369457b3.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038062; x=1722642862; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cHTm12hU98ihrn/4YhoQtTNxFr6qD1GrOX0sqy5dmrg=;
        b=MzUAcr/ENnFx1DJqm3gigwl6poEQsGaFLxnacGw4XBnXde3MC+8A7yVyN0FSO4RydK
         Wi/G+080xavM34zIirV7in+T+TxDFJU3ubLl/v1nqHD0DwpJrSR3Z878GgYToYk5B+hQ
         cQilcmLI7giwPb5g6Q19mHH8SaQx0S5hx8EdIrwloq3z/qs41xPscG4oi8vzQP7xmDT0
         hwCUlEaYD8shULSynnyeqU6wau04xg+RZCeEfPEIQqwmeBKSGqeOLhoPb/iXMj9NIdr+
         HiXbN2vYNRbRV1Piz7I++88G6mUMFlU/9pxfA8Vymk79pPQeY6e6AgY48ORgIc8v3PXs
         xZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038062; x=1722642862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cHTm12hU98ihrn/4YhoQtTNxFr6qD1GrOX0sqy5dmrg=;
        b=ujTlEsosTpHWrkKN5fSgcv4IhVzUa4kytEFRuhBY9bvMuvXCdfnk4E3vJSdZqcq85i
         ejbuASY5NT5JF8ob+Bl9nCIn7DqvI0gVxPPM7lveDG6YAbVrsEkWoc3UAUZCdgz59fpV
         LM3PsQZxOS2oVyWKMPhDWA1bn0tWpJ/ir/ZSnfEk0bvF/7I7WI7cwoeh6NA6gDBudc6h
         1I6jRPGl0gdH+1iU5L0Da/NigrdPQ3cD9MmyAfUrBwIyGR0DlFA3m0jcUjVJBqcN9IZu
         AhOTDMao1JS8W1H1YmycHu5CeU5ZiWMbQMfmcnvSoFSu9CuXJJmvujLMl4zMWNVnwtnp
         fcKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+kWwf2BACl9dvR20vhilWOnDi1vtLg+1X369aaA8bDrCFnd5oBbVULS4n+N72dxl1sXRCLZAFKLVDiQepD0z0bay+/dlR
X-Gm-Message-State: AOJu0Yyxx7ORMPE4HsLKQD5+EeDvO0YOgDn1dXFm1M0K0JGubSkZT3Ad
	+PpFGPXfA/TC+aOsi7tXgTfVN1TokVY5dmGwvuau92pw+CUlXN4eNzrxUKJ9grVTPy+Okq0KuJa
	WXA==
X-Google-Smtp-Source: AGHT+IE591qeJqHACb7CkRANjpP2e5907DfMapi1wU/6IAMP+NJSB5aPgL5hiS9fj7k9JDiJNu7gQfM60rI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:e0b:f93:fe8c with SMTP id
 3f1490d57ef6-e0b5427fa67mr79886276.0.1722038062601; Fri, 26 Jul 2024 16:54:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:00 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-52-seanjc@google.com>
Subject: [PATCH v12 51/84] KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
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

Mark the underlying page as dirty in kvmppc_e500_ref_setup()'s sole
caller, kvmppc_e500_shadow_map(), which will allow converting e500 to
__kvm_faultin_pfn() + kvm_release_faultin_page() without having to do
a weird dance between ref_setup() and shadow_map().

Opportunistically drop the redundant kvm_set_pfn_accessed(), as
shadow_map() puts the page via kvm_release_pfn_clean().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index c664fdec75b1..5c2adfd19e12 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -242,7 +242,7 @@ static inline int tlbe_is_writable(struct kvm_book3e_206_tlb_entry *tlbe)
 	return tlbe->mas7_3 & (MAS3_SW|MAS3_UW);
 }
 
-static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
+static inline bool kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 					 struct kvm_book3e_206_tlb_entry *gtlbe,
 					 kvm_pfn_t pfn, unsigned int wimg)
 {
@@ -252,11 +252,7 @@ static inline void kvmppc_e500_ref_setup(struct tlbe_ref *ref,
 	/* Use guest supplied MAS2_G and MAS2_E */
 	ref->flags |= (gtlbe->mas2 & MAS2_ATTRIB_MASK) | wimg;
 
-	/* Mark the page accessed */
-	kvm_set_pfn_accessed(pfn);
-
-	if (tlbe_is_writable(gtlbe))
-		kvm_set_pfn_dirty(pfn);
+	return tlbe_is_writable(gtlbe);
 }
 
 static inline void kvmppc_e500_ref_release(struct tlbe_ref *ref)
@@ -337,6 +333,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	unsigned int wimg = 0;
 	pgd_t *pgdir;
 	unsigned long flags;
+	bool writable = false;
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
@@ -490,7 +487,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	if (writable)
+		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
-- 
2.46.0.rc1.232.g9752f9e123-goog

