Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E088F306D2A;
	Wed,  2 Sep 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371535; cv=none; b=jS37HgZBD1PUOeFhbJgc24OIycTa89LyXvoR/nfr9SnbNFJdfm62Ttq5ahPaPIea2EIZ0qStXf2b32EufZdWPuy9HTDOV5GWdt+cdx9gV6cfBIP6gEpG9vOzQu587zvbIGCnJMnOefu6WXQsqAIkalGK28zyB4RHQYBqLrHVbBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371535; c=relaxed/simple;
	bh=1yFTXr3FakOW4n307MMxxE6owyWUX9ZHF4bTdcczcDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8K9hxAPqd7mYud8gI6GaqhbybJi8YiOz8SiqUKnaZRwujIPxtS7O8YdtCeyuG3T5P34MerYk7QpvRsxjnA7yHJh1ZUwXfxWGGY/3NaPzE8QMHaiCiNAcDb5pfnvuiYBOzuampJFMM8fhpr5wJI5Ee+9sL+BrT3PxOd0Gl+++tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hv/Gdkwl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hv/Gdkwl"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682HVTgF657513;
	Wed, 2 Sep 2026 17:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=1Kt38hV6jAEseIGwgVdNa4BQtAC3iD
	yKZSvGEA9UtZg=; b=hv/GdkwlGGl3+b8PAWu2F21+/nmJWroT7uO+aZ8TeKl0cw
	slAufum0QsXAGipp554vBhibz54eKVl9RL/1Oczg5x6djLsPslvisr7tCDDK5zKL
	WytPj3iFh9iS39v9RjfhCRHDykNmBOe79QJ8w/mxWpQnT+MiYS+5BPdhSnoaYBem
	nJMKM/us898hyBoHAa4siz9YJT7XxRGlurGjbQyvhLb3I1Hy2WQsFOuSi5vcCa0b
	p+AE7KgIPscNnplp/4wyK5Qj3TtjZZmvEpHX1/X14b2zkKyWMJ7dG4IMtB7Z2Nkx
	Bc/S1hyZWvZAEEiXNtqtSPIlsrvCtLCIrq1uoVZg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq550f1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 17:51:52 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 682HfGGG022064;
	Wed, 2 Sep 2026 17:51:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gcceyb733-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 17:51:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 682HplTK46924124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 17:51:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85A352004B;
	Wed,  2 Sep 2026 17:51:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9D4120040;
	Wed,  2 Sep 2026 17:51:40 +0000 (GMT)
Received: from Gautams-MacBook-Pro.local (unknown [9.124.221.176])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  2 Sep 2026 17:51:40 +0000 (GMT)
Date: Wed, 2 Sep 2026 23:21:37 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>,
        Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 10/20] KVM: selftests: Add a wrapper API to allocate
 multiple page table pages
Message-ID: <aphiKWCg25KlTzBr@Gautams-MacBook-Pro.local>
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
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE1NCBTYWx0ZWRfXyf1u6IYc2hOD
 HmvfNvAyUk95t5QTH2cMxetu/We6j+kPbhupTrnpN32bTFIE9LgzFFaTqGwbW8i+M91ngy0nf3T
 d75TcerHu0AX5C9USa638XqEHCorDcrGEPPQxuZAt/FYpdMWkjZ53+U8QM7+w3FnwAQubENDHc3
 v0mZHr/vE0g3P42g0/9II1CycQdeeYpkmm9nNOaK/WCI6lOsZtoUhuH7AA1H+0/3+Bo6/ePVNZI
 hnJ7qsHHVR+SlZkd5HztYKPGKolBj1xd9KF6mSiTyWibiskSw91y4choFbT+a+tWybaumA9wZCz
 oPlh1XKOrGMaBcIPG7OD7VJyUB582XrkFb+X+DPBPSTmr41DmgEOxTTzhVKU1bORhfdVnKTlrDW
 uWTE1YpRqfIOMMh27rgNouUkQofz2UcHJOOFO0h5lNr7cv8NaBEz3K9YavAPODXYewFPHNByGQa
 FM7K7D+YsgzvTitVx8g==
X-Proofpoint-ORIG-GUID: zFVgvT-7CoBEOwdyuohz2ScoLGnGrE_2
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a986238 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=HrPU0JxBsmNSCajw4d0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: zyQFxHNURnBKOCDEgr-_aVglRkwxlL0R
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE1NCBTYWx0ZWRfX18/ZgHaO/yHW
 tvDoCM6AE6SUBlOus0tkis5Bm8dqXWffNvgvrRTgTV01YaqcdBOmhtG6aaevlcZ9BlakhmOR8y2
 YYc12JqwwsAW5Wg/eMTZjZjFz0M+7wA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_04,2026-09-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020154

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

Acked-by: Gautam Menghani <gautam@linux.ibm.com>
