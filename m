Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEABD3A1CF
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 22:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741151; cv=none; b=EuwT30PAmpM98ThxBc43iGKGvo2Gny5lSW2BBbBuJq14Pb2lZe4btJh+XntSa8QLhQEUbW80tcOk9VMkw17GZO/bmrrvmKf1WI29OyjCPEVEGYWJloWUcBzsH7uRo/QaFDImwDB2ok1keJi2z6GzMdxd7GnSK5xiqyrTZOdzbD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741151; c=relaxed/simple;
	bh=AmunZczr7Dfx6/pExPG2SuXfqHdgyF1ugeSr+E7O7go=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rie5b4QN4QvvQyFk4ucFnjG+0PEUIfP+xl/hWIOKAe7OtUJRA2b5XZdHFd1OHa6/r0oAUeiYwuFlkoeWwLIN0QhQhC43z3UEu8bYd8i5B2spWIdnN+x95TB9pKSiGApYF0l7zgbKTgynibVqnptftRO8PC1/Aj+Ev9SyEqhS8EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r9HZbi8V; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r9HZbi8V"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so476875276.1
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706741149; x=1707345949; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LFZR+caDlnxynR006W8r06MBUXUFwhkI/G9N83P84WQ=;
        b=r9HZbi8V6CyirJarmbpR8fSqB5HNz3UyAj7jU0pfCEOerH1EjhNpSexrcfAyU/yzs7
         Z4LtEAlzjCdrCTCoHMNq1SjPhp61YroUzG0OCWW0NVYfjX7pJ9S++AUdlDJm7baDgXiU
         FM+dKGrWd0aOF8M+H7/BHf21zvw1YGQQA+e/cBuASMi1VANgNcVu/FXs2IKmpkbMN+f+
         qWiNDuYSvGmzpxFZvzAy3r/CgmpRQScLpZHBZw+uUKt0DhY/BiCeXsyAO9TTYga3Qil5
         YacagLF99gFSPbJcQPsjTZc6VMV67VWIt0asBGoq7RA8LrG+eC/sp3nAQSoW0mhy7pim
         BzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706741149; x=1707345949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LFZR+caDlnxynR006W8r06MBUXUFwhkI/G9N83P84WQ=;
        b=ksqf4J0UXmEKUv3AqZOo2cH/CTPY07pbZlRwu///jjrtwe+ldjLlT5hgOXZ8BFIyAH
         YAEOxvza1y1aMgfLJ/Y+57p8ZS2FS/uRyk4yoiDC4G5gfHf2OWQZRtZ4S3N+/1s7LbC+
         5vhFUIEpG9wyPHBCOCh48OYyz/X+8kewCAfSRS19I7VlVB6ZkxMkG0vDvp8Nfjg4pgCM
         m63Wx/ucYCatwFBonYzLtQ/dYUfzV8wuiTfNInuIwq75tP7zEAKYvXGq/AmrA2Fzk4Gu
         uBJ7pV4EqHWL14xN3PNEmiOGbwl8JwkzczGoEPVRkCeLC04DovHDKltB2Mbu+UaqdDsI
         4LZg==
X-Gm-Message-State: AOJu0Yylvr7aLmR+PElzUVSbmREf1Oke6VP01NZ6kcfIcwrWq7JQysd+
	mzJRnhpcTy7wWMglCftvp6vKxfzbPJTbY3hshQ4K+gkb+/XqO46GJqQ+OJ+IM0yepvpTNA59Mpy
	Tlg==
X-Google-Smtp-Source: AGHT+IHbj+iyys3ihZ/6xbW07HHtto50GCqd6T2uQS3vYWtVgZ/I/uUSlscC69aVq4ekwAFGEgKUUC6N6OE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11c3:b0:dc2:398d:a671 with SMTP id
 n3-20020a05690211c300b00dc2398da671mr827981ybu.10.1706741148737; Wed, 31 Jan
 2024 14:45:48 -0800 (PST)
Date: Wed, 31 Jan 2024 14:45:46 -0800
In-Reply-To: <20231102155111.28821-2-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231102155111.28821-1-guang.zeng@intel.com> <20231102155111.28821-2-guang.zeng@intel.com>
Message-ID: <ZbrNmoSiufn4RM9K@google.com>
Subject: Re: [RFC PATCH v1 1/8] KVM: selftests: x86: Fix bug in addr_arch_gva2gpa()
From: Sean Christopherson <seanjc@google.com>
To: Zeng Guang <guang.zeng@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Zeng Guang wrote:
> Fix the approach to get page map from gva to gpa.
> 
> If gva maps a 4-KByte page, current implementation of addr_arch_gva2gpa()
> will obtain wrong page size and cannot derive correct offset from the guest
> virtual address.
> 
> Meanwhile using HUGEPAGE_MASK(x) to calculate the offset within page
> (1G/2M/4K) mistakenly incorporates the upper part of 64-bit canonical
> linear address. That will work out improper guest physical address if
> translating guest virtual address in supervisor-mode address space.

The "Meanwhile ..." is a huge clue that this should be two separate patches.

> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index d8288374078e..9f4b8c47edce 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -293,6 +293,7 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
>  	if (vm_is_target_pte(pde, level, PG_LEVEL_2M))
>  		return pde;
>  
> +	*level = PG_LEVEL_4K;
>  	return virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
>  }
>  
> @@ -496,7 +497,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
>  	 * address bits to be zero.
>  	 */
> -	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
> +	return PTE_GET_PA(*pte) | (gva & (HUGEPAGE_SIZE(level) - 1));

I think I would prefer to "fix" HUGEPAGE_MASK() and drop its incorporation of
PHYSICAL_PAGE_MASK.  Regardless of anyone's personal views on whether or not
PAGE_MASK and HUGEPAGE_MASK should only cover physical address bits, (a) the
_one_ usage of HUGEPAGE_MASK is broken and (b) diverging from the kernel for
something like is a terrible idea, and the kernel does:

	#define PAGE_MASK		(~(PAGE_SIZE-1))
	#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
	#define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))

Luckily, there are barely any users in x86, so I think the entirety of the
conversion is this?

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0f4792083d01..ef895038c87f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -352,11 +352,12 @@ static inline unsigned int x86_model(unsigned int eax)
 
 #define PAGE_SHIFT             12
 #define PAGE_SIZE              (1ULL << PAGE_SHIFT)
-#define PAGE_MASK              (~(PAGE_SIZE-1) & PHYSICAL_PAGE_MASK)
+#define PAGE_MASK              (~(PAGE_SIZE-1))
+kvm_static_assert((PHYSICAL_PAGE_MASK & PAGE_MASK) == PHYSICAL_PAGE_MASK);
 
 #define HUGEPAGE_SHIFT(x)      (PAGE_SHIFT + (((x) - 1) * 9))
 #define HUGEPAGE_SIZE(x)       (1UL << HUGEPAGE_SHIFT(x))
-#define HUGEPAGE_MASK(x)       (~(HUGEPAGE_SIZE(x) - 1) & PHYSICAL_PAGE_MASK)
+#define HUGEPAGE_MASK(x)       (~(HUGEPAGE_SIZE(x) - 1))
 
 #define PTE_GET_PA(pte)                ((pte) & PHYSICAL_PAGE_MASK)
 #define PTE_GET_PFN(pte)        (PTE_GET_PA(pte) >> PAGE_SHIFT)
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
index 05b56095cf76..cc5730322072 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_tlb_flush.c
@@ -623,7 +623,7 @@ int main(int argc, char *argv[])
        for (i = 0; i < NTEST_PAGES; i++) {
                pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
                gpa = addr_hva2gpa(vm, pte);
-               __virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK, PG_LEVEL_4K);
+               __virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PHYSICAL_PAGE_MASK, PG_LEVEL_4K);
                data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
        }
 

