Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E13172BAA
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037998; cv=none; b=DxFSlSU1e+SppsRhDwc6Z8rjdgab7giHYLhWSj2e3nWVuuGmDfWSS39RfArp1uMsAaHBx+FoZqaVrGdmfBajOgKFD3B6CJrzRMxttkFugMQQGD68E0VASVqZiATEwKPAvf4ceatCJjtMeqbYtQG6cy6Vud2bEhLYMjqIfYdlw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037998; c=relaxed/simple;
	bh=RHZeaSr31fCCvyOcLLpe++oP0vx96AuhdExL9Q1bNo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GkgME6qFaHoaNz7W4O2TpWb5/K6AWrtBHtJp1jjg1i1HLZ9DdTDKgy4qGfPseHx4NxrGPcsXThOWaORLbNqmimDnRm2hEjL7Lh+BL84/OF9jeCphrIOsYviSUwIaK7hpIMqQDNDbveuptg1NIrBO0SUdl+qC2F0rRpuod/z55Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBxTcX+w; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBxTcX+w"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a30753fe30so1163408a12.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037996; x=1722642796; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oqsp5dWmLf1ceGtEyEpwn2+TSiYr9kgkgYyCIEXijOU=;
        b=NBxTcX+w8JEg+lkJ5Mx97IMEHNBOYB7+8P2Ip1u/5ZpIeSdaMnuYFOISZQWbILVbe4
         bzDkIvqGVYTumflTjb2Bt/oy7ozzTolWIZGOZkK1EEeu+GB7ZJp/LFr94z0M1J9iAs57
         ImfkfrMedyFFZiSISwguc1K6EZiDG7otlBzVkwtGG7GZSq4pvhmeV4QxPtx6lBb1UZjR
         7dTqN0C3pYSg3k4RpeBr4fMDf+eDTrh8/Mbopq5CoPD9eBnNsbQPxRqX8gNgDEIPKf7r
         v3ia0Sr5+4aRDlIEozn8QZm0N02q57aub5lpPs9ZWSACaCDbkAU+yUN1/ykxJct4yeoH
         IqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037996; x=1722642796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oqsp5dWmLf1ceGtEyEpwn2+TSiYr9kgkgYyCIEXijOU=;
        b=GMW110xQhu5sBAx8WHyB/lkV3a39Cdh3sdODddKklN3ZyO9s9RpgiKZj2WIk+RlgyF
         SUB1wRImBph84g5cXV8lnn8dXQe/3YrIZOhmU+9mcurG+XQOgFTd7qb7wgd71m9t187u
         PvvHloNpWflOXVOHn/zWRCzVlMsO/HVEx8Sr3zknXK0A/ShPUAON1DgJlgT9RxwBlVoT
         NRO5h45E9G/JFoyi6MrL2wxCzQpE6eik88xtjCypVdaVE3jWrW9mii9pPHem8dLWeFB7
         PakHIvxs+2bLCsKNs3KiUUEZbuGXqDTHJ6Yn7kYHydaf8tKRMBPj1hGcPvRJ01L04tEO
         xf9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnqmxe6+gE9iN0B7J4Voctas4wZdfymbsTAp91dmaW4njERcbzaffvNRySNMdORDpzQzQGw+xBGjSliw5IV0H5wlt4fVBH
X-Gm-Message-State: AOJu0Yz+0+B8GrJwbizuynjdHCZVZ9JkYjFuvw6fYj28nlxAHTdcu9TA
	eC5QNEU05cqc/5VgzAeA/6X2Fr0ZV8Bcgf6j2DtHuu4u/mPB1RW6XncCa7gRdIviACe4/B2kHyi
	Nhw==
X-Google-Smtp-Source: AGHT+IGPnVvSSR8GC4je1DUQj4K0eIO0wDIdrfABFjI4ae5Nt/lU6oCOfX0avnzwArksU/NKeR8FWd7ZKxM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a9:b0:6be:8aa5:bffb with SMTP id
 41be03b00d2f7-7ac8e0bb8cdmr3560a12.4.1722037995764; Fri, 26 Jul 2024 16:53:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:28 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-20-seanjc@google.com>
Subject: [PATCH v12 19/84] KVM: Explicitly initialize all fields at the start
 of kvm_vcpu_map()
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

Explicitly initialize the entire kvm_host_map structure when mapping a
pfn, as some callers declare their struct on the stack, i.e. don't
zero-initialize the struct, which makes the map->hva in kvm_vcpu_unmap()
*very* suspect.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 21ff0f4fa02c..67a50b87bb87 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3088,32 +3088,24 @@ void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
 
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
-	kvm_pfn_t pfn;
-	void *hva = NULL;
-	struct page *page = KVM_UNMAPPED_PAGE;
-
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-	if (is_error_noslot_pfn(pfn))
-		return -EINVAL;
-
-	if (pfn_valid(pfn)) {
-		page = pfn_to_page(pfn);
-		hva = kmap(page);
-#ifdef CONFIG_HAS_IOMEM
-	} else {
-		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
-#endif
-	}
-
-	if (!hva)
-		return -EFAULT;
-
-	map->page = page;
-	map->hva = hva;
-	map->pfn = pfn;
+	map->page = KVM_UNMAPPED_PAGE;
+	map->hva = NULL;
 	map->gfn = gfn;
 
-	return 0;
+	map->pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	if (is_error_noslot_pfn(map->pfn))
+		return -EINVAL;
+
+	if (pfn_valid(map->pfn)) {
+		map->page = pfn_to_page(map->pfn);
+		map->hva = kmap(map->page);
+#ifdef CONFIG_HAS_IOMEM
+	} else {
+		map->hva = memremap(pfn_to_hpa(map->pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+	}
+
+	return map->hva ? 0 : -EFAULT;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_map);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

