Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62196207A19
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584809; cv=none; b=g4+Rf/SmrBQsoB0hXqg9RJteZTLxX8J3QKmVmF8MUw/v8tH60F4fzfPD+oQhM0JvMm8InjW8TNp5ml5tAqCuYrWjEJau3KdPzhXWBhX6A9GC7DO6QBUk+KOX37p7dLgE9AQaMGmOz3KcClnknA/2UlS42PmDXZprVFZ8iUAJ2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584809; c=relaxed/simple;
	bh=ZWIlv2h6Cx1yrF7GGy3UqCKI1dfxdLpdeKJSlsj4QNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YEvnY1cL196FEtnk+0oyy3DFLHrABxQQ0BspvkuV47+fuiMBhcLqWVeX3iIC0cWFkNlUoSF75hyMZdRNjucdxNP219l/42kH1kR2joynrYDMK6JoMYyKWjrkpkj9yNf098zW0fmuquwkJZDmKX8XD2SbQjLYTTcDJnoMwRZWAHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z310ZfL1; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z310ZfL1"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e29097b84c8so1995618276.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584807; x=1729189607; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nHP38EtPz8K1+ebGaPqvgAKvgaQP36cKGSrn8JpxRdw=;
        b=Z310ZfL1Qt3W4euk/WF4BwNUHdvXBgaKUfpM1iOcP0Pd8RQ+any7BarcUcci2WPAoa
         n3F6CLZHpEjJmSmcU5ur1Ddorv+6JaIHTOq+xFsphaJ0ArAT+ELdsAeot9YzcBCpYDiF
         tCXyp2JjYK3UF4dwwr4V6V7sPt3FZ/rgGVACJfi7sFLu5hob3FgPEy8wzJDpHoz0jeow
         qfHsj0AB9kzQn58erN1dhJiCQgqq1by7jzdvTmBZw7FvfAhtZJQCKeOyBGD7A2flGJ8A
         HdmJjly1VdS+1rZ+fKfReEIsdiaynbU5d7QVn8e6NmUphTH3mQZJZ6JbGmH8WVh3Tad4
         1rcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584807; x=1729189607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHP38EtPz8K1+ebGaPqvgAKvgaQP36cKGSrn8JpxRdw=;
        b=aPN2esVWpcvnApNbA7+nQOxQ4AbbWQqWV9+Bc+SIR+pbT8XVgsLxWx4JJNx9z47U2g
         dBsN0KQ3eVSSXv1amLMvgyIzkDq7umXlP6oyuMtzssqzwe705Et1s0DprAyuKPg/Ur2O
         8pDO6ldctMvcWHkUTvcKtd5a+m4cKCGoh/uIJj5LLeQsxRWqaQVSE565JH4xpORxCJ/S
         f4AwI26t/xMG12K/IrlhCv2UWHIa2Y8/+2q+wgB598Qwu8sTgrygNrCl9ixbtf53mocx
         Vr1ElfmpNdqRVzqV5lWC86bS5k1xVEj/peRnkxSZWWFeWRcoUZfR/calXecFxyibC/3K
         TS+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLpmRhXgFpOR2OqvOndvge3Rvw0ZRuimh0+JTv4pIcYWFHkiqfNvs3xZ5WXCejokVuI41s/do=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRiuglWuByjpuZ91sqLqoTLd279bKB6vUOObPkVyTX8m9sgjad
	80qiVb8BGNRRJz7Ak0UrdKjmiHenxLo+HIHJmgvXr2lkgDhC2x5mirlwfNzCem/fbrPuWStR+vt
	hvg==
X-Google-Smtp-Source: AGHT+IHQvsj0FcPHwm2v4Ks73fb0XY1uO3QmFFCKoUyfp7OKRYByAKtc8uXQ4anZ8QaSR/IH5oavOTtruEI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:b86:0:b0:e0e:8b26:484e with SMTP id
 3f1490d57ef6-e28fe516b5amr5188276.8.1728584807403; Thu, 10 Oct 2024 11:26:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:56 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-55-seanjc@google.com>
Subject: [PATCH v13 54/85] KVM: PPC: e500: Use __kvm_faultin_pfn() to handle
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
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.rc1.288.g06298d1525-goog

