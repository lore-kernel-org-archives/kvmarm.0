Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FF418A93F
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038094; cv=none; b=NCilbNVK/3483V1/lVRj7fo7U9AX0bcyRlCQ+cYsJIBBVqqwM5c7d+WOwxZmgDbrCr9a3yBZ6CQ6QbetKuqenpnu+G/HBlmFXWIGPs+0e+pPWETAaYfoSc1j2ZC/pMDb01vG0cGLpsqIAfm2Mag6H7VBlhqh1QmFHAochDORxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038094; c=relaxed/simple;
	bh=+UZ8VYtUvtsljZmzMl/1tyQmxGJndr+FFAuTaMIEbgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V9W3EsLMkQtxqdOf2fjpj66r45mQgikAohIDHsUHg3rJDMZcOwWlej6+RVq/LtCtIVsajWgEWN3vZfBSb4W17wRO4XI4IAkGD+uNuaPkPzM1Ru2UYfOg4H5OMO69+G1aUAb0acp9jyI5NqCPdziDW5vpRewBryurowdofVrhcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YUtaUK7J; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YUtaUK7J"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0872023b7dso463252276.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038090; x=1722642890; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XEv6FisOGr6vpV2eziQMsIEoEavMf3RHPa1v90mbDdU=;
        b=YUtaUK7J+zkmHP9+RfEBBD4ity/Zdl4pCQbzevtUy2vhSVqX5gdpjqlAEGpVd8MuiU
         AByVnIgdThgcsTg0ZiiqefiJ1sS98RfU/rRByAIQS9PweHX3HGce1UDChFIY8kB9RnM/
         3ixyPlwaTF+KQLQCRMgCpsINYmlsYMe3snWAAK7lQXWYiPhw33AxbNSHbfw1GiW7vyYz
         GoKNiaC+i5lqfQ8MlZTdwVfEFrx3a8g4lnvWWto410uqvKFNSnaMqOQFiV32EtYvK9TY
         nxakEzYgnrqnGO68xdOzkOVjkKZckBK6Bkwoz7PM1mNeYTY1x6VVM0d7OjyNuczWBH0P
         MO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038090; x=1722642890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XEv6FisOGr6vpV2eziQMsIEoEavMf3RHPa1v90mbDdU=;
        b=mua8PB81NDNNR7BtGibKq+gUffSYP9l1ARpz71rLLhnRVw8QjWnw/NylQwFHyG1bMg
         ZPNG5/GBombmgfiih+l3qXpG/2xvGSRJsFo1CAfMGSxaJGqcGf+bD7O+c8ytscU7rxhg
         MkagquEjCWImrkOhz8lSmYABlz3DXmSE0VtTdgF76mLWlfUNEc4oREuAQ2CrtZoCr5jB
         VUefeQSQyzJuTkVYKWcKwqcY2Dr8ViAFVfuBAo36QXPQSFCUqdvbZFC1TmIsq3qNkXzY
         GjXbF0aHuCWVUOY1tTqyoSNGyK5SI9N4n6awBa9jEx82T2osYr34nq6kyWEompeRkava
         awfA==
X-Forwarded-Encrypted: i=1; AJvYcCWF8Wfg1uqhwoSYfMkJEU/fqqloQ+hSAXhpzBagauEAJ3bAbxGkTc1cCmhZf1n6y98p6nNiwzRSkjiWJyglBpBkv0Ede69T
X-Gm-Message-State: AOJu0Yxi67bHiylWX5DggNJreqPkzeQ4S+f8RnrdyCiCX2xrEDCnqdmw
	6WGo4hnkk/6VJPBMG0rRK1233Crop7y08d2oqQ7RjdjCSxISB86HkSdDaBagKufZQ5NvhBZLoLz
	DRA==
X-Google-Smtp-Source: AGHT+IEFsToK4Mtfkt/isyLtzSbxuiJaEYiedQjj5sFCo8o3/vbFtfyZ9L8therJfArRWUvkwGk/K/B8SPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:e05:6961:6db3 with SMTP id
 3f1490d57ef6-e0b54503b59mr2236276.9.1722038090539; Fri, 26 Jul 2024 16:54:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:13 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-65-seanjc@google.com>
Subject: [PATCH v12 64/84] KVM: LoongArch: Mark "struct page" pfns dirty only
 in "slow" page fault path
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

Mark pages/folios dirty only the slow page fault path, i.e. only when
mmu_lock is held and the operation is mmu_notifier-protected, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

See the link below for details.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 2634a9e8d82c..364dd35e0557 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 		if (kvm_pte_young(changed))
 			kvm_set_pfn_accessed(pfn);
 
-		if (kvm_pte_dirty(changed)) {
-			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
-		}
 		if (page)
 			put_page(page);
 	}
+
+	if (kvm_pte_dirty(changed))
+		mark_page_dirty(kvm, gfn);
+
 	return ret;
 out:
 	spin_unlock(&kvm->mmu_lock);
@@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	else
 		++kvm->stat.pages;
 	kvm_set_pte(ptep, new_pte);
-	spin_unlock(&kvm->mmu_lock);
 
-	if (prot_bits & _PAGE_DIRTY) {
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (writeable)
 		kvm_set_pfn_dirty(pfn);
-	}
+
+	spin_unlock(&kvm->mmu_lock);
+
+	if (prot_bits & _PAGE_DIRTY)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	kvm_release_pfn_clean(pfn);
 out:
-- 
2.46.0.rc1.232.g9752f9e123-goog

