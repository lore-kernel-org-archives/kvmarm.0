Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B03603E9;
	Thu, 10 Sep 2026 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036199; cv=none; b=LfctM9NvMU9i62m8urUWPCz1aYB/vxaDwgbiA43r/t9xkzXoUU9QW2jvBYRahGLj93zfYtozcRg2eDaA5w+zOwtpDucJAAbrSQtsPw0X/ShVl+L57f7P1gWwIg1dayebXeRVCSBTigvGrQNI/Y/eDMHlVWimApjBvV36u8Fmr+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036199; c=relaxed/simple;
	bh=nMikz4YNyY74FhKkPbaB0M6vAd7E6UR9CkOxWodXgl0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Viz4T5/vNcUVwLSHU7ONQ8C8KLD0AOvue51/ejZFzbEF9wTx7jb2ZtSqQVbvUGLMe/o7/33HkDu1dFGJMVUibyb/KvDMTsk9q1+3Jzw0adZ2ICLln/cFRQhaQymEyp+K28BZ3gY3UttFJtxfFjv8pLITXLz9csC2OhesVp+09MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P7+8GjmT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P7+8GjmT"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A91a2x2483650;
	Thu, 10 Sep 2026 10:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OYWX0R
	H8DOHLOCtrZgD5LV0gPTaI8JZ9RGIDCbaQ4cw=; b=P7+8GjmTmfO9IbkbHyUtT3
	yj4tolE9XvbWiX0nAuk4RwkVuWrJGFN8lpjaL/3/dSmKmkGiML3tFomu/CpR5vUj
	KxK7yrP1509pfoNhiR3kEb9I9KbYy5R1PyKn6knRYVWis6FnXbe5dETElkEe3kYx
	g46FRrfzavQ8mx5/VrxBjwygZPWgaxG1NwJLC3VHAh9CMjcqMKCUTFdOoIZjV1jA
	xVtYDmBTVzuepXootKCPXoigtAz6evR4JYn/P4x75g1on7OPCqscgfDTduenVq2O
	+ViKXfg10Q6F8v4xLz7Ut5aq29bVX2Rc7HKWOcGzXe5jbgBp9N8pGv8AAxmrD65Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8suw2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68AAQGVM004811;
	Thu, 10 Sep 2026 10:29:31 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkcr33uhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 10:29:31 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68AATR4D47776036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 10:29:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F43820043;
	Thu, 10 Sep 2026 10:29:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCBF52004D;
	Thu, 10 Sep 2026 10:29:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.48.108])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 10 Sep 2026 10:29:24 +0000 (GMT)
Date: Thu, 10 Sep 2026 12:23:04 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Paolo
 Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>,
        Bibo
 Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
        Anup Patel
 <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt
 <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly
 <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K
 Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Atish
 Patra <atish.patra@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
        David
 Hildenbrand <david@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Itaru Kitayama <itaru.kitayama@fujitsu.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2 10/20] KVM: selftests: Add a wrapper API to allocate
 multiple page table pages
Message-ID: <20260910122304.6d40fef8@p-imbrenda>
In-Reply-To: <20260902164123.2546762-11-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
	<20260902164123.2546762-11-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX08DVpiXgVUnP
 7wkmCcOivwBSbL6mAcR9h5OtqylZU+wRO7T/0OhkHu3k0F9M2m1PhsQsol+Dsr04QAaYbO9LWTA
 AcjtqJBo2ASCE02L2mnZK6R/G5B/GPY=
X-Proofpoint-ORIG-GUID: IvVTL6gKWZTqBFbywVNu-ekREucvQ5cN
X-Proofpoint-GUID: fv7SiSZpmApWyfA9kW2K8yKbFXky4vLj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX71qI+xHvh4bf
 ctcdWFcJsOpJVKJKIQSGHLkEqRx1ddggdES8ewtJQlfsbA8+JJBYfa5Ed9Ai4+nC8dmntCvvHoN
 loH9eVanahQx/KrTBtVW97tp5nLXdlH9X1zKiu+F8EBFS5YEZpx/lCqiwFTQlKQ5EhWuR3+52BM
 KAGKWMe1qlLPIkt/mbepxWRJfLQMGo4bAJFx2+7TpBKNMNZq6tdhILKXOZJVMz+tb/hVzBDk23J
 mx2lJv2a8fmsh2JeDO1QEQP/r2BGsSNv0F3H6OB3RFK3xBg/w8/vzy5SG+13gLTSpRh4zxdyPsg
 jEeNNMzUAw2/TD7JJDzGIbd+MTxliXTEsQrjVEKmCHWQykj5fSik5DIpSyqe32vLFIKRg33zmhR
 iy/bWzzggvGElTnykzoWsMzxhZ8nIzNZ4wFqF7tmS1nNABKjQShuwgqXBlwXKvUTvu4FXmiYM6C
 VAKXRDsAX7yg7LCXDUQ==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa2868d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=1XWaLZrsAAAA:8
 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=o3jzi3dQArLouIYA8mYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100115

On Wed,  2 Sep 2026 09:41:13 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Add vm_alloc_page_table_pages() and use it throughout arch code to replace
> open coded equivalents.
> 
> No functional change intended.
> 
> Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h    | 9 +++++++--
>  tools/testing/selftests/kvm/lib/arm64/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 4 +---
>  tools/testing/selftests/kvm/lib/s390/processor.c  | 8 ++------
>  4 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d9d39a8894e2..c56f342b16fd 100644
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

