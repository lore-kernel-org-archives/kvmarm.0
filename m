Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6117185E6A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038069; cv=none; b=m6IfiYnoHeW2wzQYkftcXuy54BPMIRdXSyw6kK1L7oJR5mbS6DdswO4IntDJ4bsdLUgLyhjeGA0I+7FczcGwyGzohk5IMnfHQGRKyliYTX+GVlXl9UjFS1EB7nyNias1MhuNWomVEDWzRQvxLqFTJ9pA4En0dpjqZqW3sr3nS1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038069; c=relaxed/simple;
	bh=5OcQ4yMNFCHP+jiDtiAE4Jxg5Z1H9MhX9ShMIrwVrSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h4QDkXV1D67ZnY/mm/c8WOYrK2BnfXL1RQPcWQVSRdYz3c5oBaIJcHnS0CBKQRsBTX1m62/UBFSaQZ+Cx4kordJn0fvAAg/pr8NmXYcBjWjPZf3jx3LJNTls0G3TOY7ocHopV5tEYOYT/jEu1mMpQcmJtON0jByd6N8ihkexFyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W+dkWPMT; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W+dkWPMT"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70e9e3dd963so1395954b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038067; x=1722642867; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zSr/S7cQW+jg6+5Yur5d69GSxQ0D+3E/XB18qDPP3eA=;
        b=W+dkWPMThgCyZBoQ6BDKrQUjFCZXUOnFl/spebMxU0U3yEmTqP2sZCCNqOWfOjLEoL
         QMypBJn84VKOjQHhPqeVaE5/3uDCtXxyn8JLfMogismfENCjpw4+Nmwawif4fpVSF0BR
         t1brdylZ7EmNf8iV3pSm4a45LLBLt2w2Aq5TFLZdH2ttUb0B6sLiILQx8YNpNXrd+jbq
         yR0fMdfo0bmAD8CiNqhQD/AoWyWDHkGmJpZo9z1bsX4g1yzxC7RGPSzjw7SHt6XPKnYz
         FNtV2jy8i81Ssz+1y8Q+qksnm1U/mhCdazRa0GO7sATEc7B6pjHKKAukbFyhxBmQNQUg
         05Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038067; x=1722642867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSr/S7cQW+jg6+5Yur5d69GSxQ0D+3E/XB18qDPP3eA=;
        b=kpcALiIychC6/lJLapKt4EOq/FGxgZs3NJuihXZn5huZtBq2lLOJbGgGq8QPxeXKiL
         T282dT2mmHfo/s8A9tmevUfsJthxTGdwPyx98QB4DWKrUGeJkb+n7A94kG4DMVty+7qC
         vMwpvZt/uH2yJSPCl+1bjQxLuQD8fj0pmf5zQRyQRIJPbzzkKQ14BYp/qs/Pm2EpI7QH
         LgXPeDaGLZtJ/Rp6yoB1iO4w5CwZvCxZEbAOxyKsIVCWtweb85EaVRyzGjxWdH2uAiCz
         pc8ukzA+OinWByJTfJ/nPWON3X6qH+xQVnKWiftqjhqahSHdyVlcyQTYAaR/E2A2/Dr5
         ZuQg==
X-Forwarded-Encrypted: i=1; AJvYcCUPY3OmpcFoPVKIY65Ji/zr7Mq2K1NafIz8U2cYS/Nh+wDBxeaGD0Qrr1Ws32esvehD2xa4WYljP+3KGIJ5FnUHUyX1SLZ7
X-Gm-Message-State: AOJu0YzCRJKn0DYMzd34/IHf9+PCsde3AAn+Rn8KOnOx1JjTiD8nN+Zh
	Ilnx2bWFE/T3PoIJ+41u5kIerZQ5eukNtN5DZcCT+zKu6z1VWJBoc9OMkSn8qKUPoeoeCUqow/Q
	F2A==
X-Google-Smtp-Source: AGHT+IEvvOLEi17q5BnKGFU80vyNCkxL+K4ME2VW/zA0UgmW3Jn60esm+Gg/1wQhRB2++SmF9ZjJ4yJ/TXU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:238d:b0:70e:98e2:fdae with SMTP id
 d2e1a72fcca58-70ecee6db73mr19809b3a.0.1722038066705; Fri, 26 Jul 2024
 16:54:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:02 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-54-seanjc@google.com>
Subject: [PATCH v12 53/84] KVM: PPC: e500: Use __kvm_faultin_pfn() to handle
 page faults
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

Convert PPC e500 to use __kvm_faultin_pfn()+kvm_release_faultin_page(),
and continue the inexorable march towards the demise of
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 334dd96f8081..e5a145b578a4 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -322,6 +322,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 {
 	struct kvm_memory_slot *slot;
 	unsigned long pfn = 0; /* silence GCC warning */
+	struct page *page = NULL;
 	unsigned long hva;
 	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
@@ -443,7 +444,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -488,8 +489,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-	if (writable)
-		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
@@ -498,8 +497,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	/* Drop refcount on page, so that mmu notifiers can clear it */
-	kvm_release_pfn_clean(pfn);
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog

