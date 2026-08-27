Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605E03385A7;
	Thu, 27 Aug 2026 05:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808454; cv=none; b=F6BX0QcVCofrgf0llA9UdCWwiiWIMXAW7133N5fysYHf0nBLHwI7r2NQn5ByKzdD9RnC3gJminDj+IRt/daPd8VSagCMJ6EsEYY6cMpftLOwwnfuVDkl0KzbjsBCQFYO9dZVBy9AXpFPxo8PhY3x890VHyLceWY4dHg6ha0rJz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808454; c=relaxed/simple;
	bh=LNguTLWe0jdKgr+r/c43BTP0XhTiTX9J59hPN8fgAWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rl6Td6wKL3qdUxpZftBw0OCvHbeoy+sQdRFrszge7Ew09Eig1uziE76EJ/HbzizO8tz/4tatQayrE1lOEU+qYUWilLmtF4EymjjY+xxLwwqlB10ue9XFUTrNgfOO72/wNhh1mGa2fCDIGuhyxX5ki6T/W7c1q95uvDAbXNzbn+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=TAIQbKyX; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="TAIQbKyX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787808453; x=1819344453;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LNguTLWe0jdKgr+r/c43BTP0XhTiTX9J59hPN8fgAWE=;
  b=TAIQbKyX0A8MjHJveDGSpGEG4eMvG4DTcJl05TfJNCcGGv/9V80m6DO1
   Cr7i9bUdTjd3QTRIPQVqCfMkAAPyOqP0saQmHnIwgiutvGFRj/z3P+ecl
   XgyXd/inzrPEF4Y/5F4mnCNtok6t536UNnb/V7qnBjY1NW0pKvRhlYdrg
   j7LP+3Knh81ye61OXIJL3x17KSXdGg52GCIld08niAK2ENpziL+V6eWfE
   0alIx+/ENVckCSMSG7YRUHRHq17mpSBHJ+7z/e09w4blvYf/LAJVjE0eg
   /hIiwAQr59uG0qd/2BnmVzWyQBZSsOhp1DZzKQoJQcgPiaaBOskEX9GDg
   Q==;
X-CSE-ConnectionGUID: bjoZoxCiSCyl4z0vCXO74A==
X-CSE-MsgGUID: VcrRs6E/QlyVqn2Lu/ge5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="252825889"
X-IronPort-AV: E=Sophos;i="6.25,246,1779116400"; 
   d="scan'208";a="252825889"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 14:27:25 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id A1C1E8203FB;
	Thu, 27 Aug 2026 05:27:24 +0000 (UTC)
Received: from az2nlsmom3.fujitsu.com (unknown [10.150.26.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 18E3D14003EA;
	Thu, 27 Aug 2026 05:27:24 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom3.fujitsu.com (Postfix) with ESMTPS id C2002101732E;
	Thu, 27 Aug 2026 05:27:14 +0000 (UTC)
Date: Thu, 27 Aug 2026 14:27:11 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Atish Patra <atish.patra@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 10/20] KVM: selftests: Add a wrapper API to allocate
 multiple page table pages
Message-ID: <ao_KrzUvfrpYGZVV@sm-arm-grace07>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826230511.972824-11-seanjc@google.com>

On Wed, Aug 26, 2026 at 04:05:01PM -0700, Sean Christopherson wrote:
> Add vm_alloc_page_table_pages() and use it throughout arch code to replace
> open coded equivalents.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 9 +++++++--
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/s390/processor.c  | 8 ++------
>  4 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2525c2cacc22..21354434de0a 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1013,10 +1013,15 @@ static inline gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa,
>  	return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
>  }
>  
> +static inline gpa_t vm_alloc_page_table_pages(struct kvm_vm *vm, size_t nr_pages)
> +{
> +	return vm_phy_pages_alloc(vm, nr_pages, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +				  vm->memslots[MEM_REGION_PT]);
> +}
> +
>  static inline gpa_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -				 vm->memslots[MEM_REGION_PT]);
> +	return vm_alloc_page_table_pages(vm, 1);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 01325bf4d36f..2dcaa2c4a038 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -115,9 +115,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	if (vm->mmu.pgd_created)
>  		return;
>  
> -	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
> -					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -					 vm->memslots[MEM_REGION_PT]);
> +	vm->mmu.pgd = vm_alloc_page_table_pages(vm, nr_pages);
>  	vm->mmu.pgd_created = true;
>  }

Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

>  
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index ded5429f3448..c175dcd14114 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -69,9 +69,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	if (vm->mmu.pgd_created)
>  		return;
>  
> -	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
> -					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -					 vm->memslots[MEM_REGION_PT]);
> +	vm->mmu.pgd = vm_alloc_page_table_pages(vm, nr_pages);
>  	vm->mmu.pgd_created = true;
>  }
>  
> diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
> index fb9dab92d4d1..33f49d743b5f 100644
> --- a/tools/testing/selftests/kvm/lib/s390/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390/processor.c
> @@ -20,9 +20,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	if (vm->mmu.pgd_created)
>  		return;
>  
> -	gpa = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
> -				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -				   vm->memslots[MEM_REGION_PT]);
> +	gpa = vm_alloc_page_table_pages(vm, PAGES_PER_REGION);
>  	memset(addr_gpa2hva(vm, gpa), 0xff, PAGES_PER_REGION * vm->page_size);
>  
>  	vm->mmu.pgd = gpa;
> @@ -38,9 +36,7 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
>  {
>  	u64 taddr;
>  
> -	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
> -				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -				   vm->memslots[MEM_REGION_PT]);
> +	taddr = vm_alloc_page_table_pages(vm, ri < 4 ? PAGES_PER_REGION : 1);
>  	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
>  
>  	return (taddr & REGION_ENTRY_ORIGIN)
> -- 
> 2.55.0.887.g758fc8c411-goog
> 
