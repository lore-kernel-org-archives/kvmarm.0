Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57C18AE7
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000018.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SDbLx3RYYzVlNJ;
	Mon, 23 Oct 2023 21:16:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000018.china.huawei.com (7.193.23.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 23 Oct 2023 21:20:44 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 23 Oct 2023 14:20:42 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "vsethi@nvidia.com"
	<vsethi@nvidia.com>, "acurrid@nvidia.com" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tiantao (H)" <tiantao6@hisilicon.com>,
	"linyufeng (A)" <linyufeng3@huawei.com>
Subject: RE: [PATCH v1 1/2] KVM: arm64: determine memory type from VMA
Thread-Topic: [PATCH v1 1/2] KVM: arm64: determine memory type from VMA
Thread-Index: AQHZ4bdLehyCbll0tE+E3EeoI9km/7BXohtA
Date: Mon, 23 Oct 2023 13:20:42 +0000
Message-ID: <af13ed63dc9a4f26a6c958ebfa77d78a@huawei.com>
References: <20230907181459.18145-1-ankita@nvidia.com>
 <20230907181459.18145-2-ankita@nvidia.com>
In-Reply-To: <20230907181459.18145-2-ankita@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.151.228]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

Hi,

> -----Original Message-----
> From: ankita@nvidia.com [mailto:ankita@nvidia.com]
> Sent: 07 September 2023 19:15
> To: ankita@nvidia.com; jgg@nvidia.com; maz@kernel.org;
> oliver.upton@linux.dev; catalin.marinas@arm.com; will@kernel.org
> Cc: aniketa@nvidia.com; cjia@nvidia.com; kwankhede@nvidia.com;
> targupta@nvidia.com; vsethi@nvidia.com; acurrid@nvidia.com;
> apopple@nvidia.com; jhubbard@nvidia.com; danw@nvidia.com;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.linux.dev;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v1 1/2] KVM: arm64: determine memory type from VMA
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Currently KVM determines if a VMA is pointing at IO memory by checking
> pfn_is_map_memory(). However, the MM already gives us a way to tell what
> kind of memory it is by inspecting the VMA.
>=20
> Replace pfn_is_map_memory() with a check on the VMA pgprot to
> determine if
> the memory is IO and thus needs stage-2 device mapping.
>=20
> The VMA's pgprot is tested to determine the memory type with the
> following mapping:
>=20
>  pgprot_noncached    MT_DEVICE_nGnRnE   device
>  pgprot_writecombine MT_NORMAL_NC       device
>  pgprot_device       MT_DEVICE_nGnRE    device
>  pgprot_tagged       MT_NORMAL_TAGGED   RAM
>=20
> This patch solves a problems where it is possible for the kernel to
> have VMAs pointing at cachable memory without causing
> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
> devices. This memory is now properly marked as cachable in KVM.
>=20
> Unfortunately when FWB is not enabled, the kernel expects to naively do
> cache management by flushing the memory using an address in the
> kernel's map. This does not work in several of the newly allowed
> cases such as dcache_clean_inval_poc(). Check whether the targeted pfn
> and its mapping KVA is valid in case the FWB is absent before continuing.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
>  arch/arm64/kvm/hyp/pgtable.c         |  2 +-
>  arch/arm64/kvm/mmu.c                 | 40
> +++++++++++++++++++++++++---
>  3 files changed, 45 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> index d3e354bb8351..0579dbe958b9 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -430,6 +430,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable
> *pgt, u64 addr, u64 size);
>   */
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
>=20
> +/**
> + * stage2_has_fwb() - Determine whether FWB is supported
> + * @pgt:    Page-table structure initialised by kvm_pgtable_stage2_init*=
()
> + *
> + * Return: True if FWB is supported.
> + */
> +bool stage2_has_fwb(struct kvm_pgtable *pgt);
> +
>  /**
>   * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2
> PGD
>   * @vtcr:	Content of the VTCR register.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c
> b/arch/arm64/kvm/hyp/pgtable.c
> index f155b8c9e98c..ccd291b6893d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -662,7 +662,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32
> phys_shift)
>  	return vtcr;
>  }
>=20
> -static bool stage2_has_fwb(struct kvm_pgtable *pgt)
> +bool stage2_has_fwb(struct kvm_pgtable *pgt)
>  {
>  	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>  		return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 482280fe22d7..79f1caaa08a0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1391,6 +1391,15 @@ static bool kvm_vma_mte_allowed(struct
> vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>=20
> +/*
> + * Determine the memory region cacheability from VMA's pgprot. This
> + * is used to set the stage 2 PTEs.
> + */
> +static unsigned long mapping_type(pgprot_t page_prot)
> +{
> +	return FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(page_prot));
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
> @@ -1490,6 +1499,18 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>  	gfn =3D fault_ipa >> PAGE_SHIFT;
>  	mte_allowed =3D kvm_vma_mte_allowed(vma);
>=20
> +	/*
> +	 * Figure out the memory type based on the user va mapping properties
> +	 * Only MT_DEVICE_nGnRE and MT_DEVICE_nGnRnE will be set using
> +	 * pgprot_device() and pgprot_noncached() respectively.
> +	 */
> +	if ((mapping_type(vma->vm_page_prot) =3D=3D MT_DEVICE_nGnRE) ||
> +	    (mapping_type(vma->vm_page_prot) =3D=3D MT_DEVICE_nGnRnE) ||
> +	    (mapping_type(vma->vm_page_prot) =3D=3D MT_NORMAL_NC))
> +		prot |=3D KVM_PGTABLE_PROT_DEVICE;
> +	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
> +		prot |=3D KVM_PGTABLE_PROT_X;
> +
>  	/* Don't use the VMA after the unlock -- it may have vanished */
>  	vma =3D NULL;
>=20
> @@ -1576,10 +1597,21 @@ static int user_mem_abort(struct kvm_vcpu
> *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault)
>  		prot |=3D KVM_PGTABLE_PROT_X;
>=20
> -	if (device)
> -		prot |=3D KVM_PGTABLE_PROT_DEVICE;
> -	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
> -		prot |=3D KVM_PGTABLE_PROT_X;
> +	/*
> +	 *  When FWB is unsupported KVM needs to do cache flushes
> +	 *  (via dcache_clean_inval_poc()) of the underlying memory. This is
> +	 *  only possible if the memory is already mapped into the kernel map
> +	 *  at the usual spot.
> +	 *
> +	 *  Validate that there is a struct page for the PFN which maps
> +	 *  to the KVA that the flushing code expects.
> +	 */
> +	if (!stage2_has_fwb(pgt) &&
> +	    !(pfn_valid(pfn) &&
> +	      page_to_virt(pfn_to_page(pfn)) =3D=3D
> kvm_host_va(PFN_PHYS(pfn)))) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}

I don't quite follow the above check. Does no FWB matters for
Non-cacheable/device memory as well?

From a quick check, it breaks a n/w dev assignment on a platform that doesn=
't=20
have FWB.

Qemu reports,

error: kvm run failed Invalid argument
 PC=3Dffff800080a95ed0 X00=3Dffff0000c7ff8090 X01=3Dffff0000c7ff80a0
X02=3D00000000fe180000 X03=3Dffff800085327000 X04=3D0000000000000001
X05=3D0000000000000040 X06=3D000000000000003f X07=3D0000000000000000
X08=3Dffff0000be190000 X09=3D0000000000000000 X10=3D0000000000000040

Please let me know.

Thanks,
Shameer

>=20
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax
> --
> 2.17.1
>=20

