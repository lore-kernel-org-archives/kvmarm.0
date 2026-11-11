Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410471;
	b=3mhWGVciuFgIT/oqLSFM+AASFgmeeo8jsTouQk3fm3KEWzI6y5y05DRUrcOwZBzWL02r
	 3p29sH5WVTpBOexTk3AVVW2IaRgB1ghBktJN9AFFlgvrPzheIeSJ84EZo+wb3Oz4/p0Js
	 gE/Iluu29f4naL0XddCozTOQ0B0HL2OPEB+j4hGuzESIQe6qZggE/gC5zKx0FdH3+TgWT
	 XJ/7hiRCbt07oo1BndTgm1tUFmG5usTT3QuXMSPLa4e0ckQ0QzfbCIp9S9RyyZoAHLIcI
	 vPmedhuahSttWX9S6q03f9NQl9BFj1wCnnqu6lx1xPXqCFOOyNhs1KQ4VFF2wgCTjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410471;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=LS22Ygw4td6cYP7DxbERi9ddUHoq6vQVTmOxe4Gax9E=;
	b=ttqSgkTLfMbpvh7GA3Z7Fu8mF5373J9YQCx/JyB8+j6RAplQ6sed5cjf8XnlfQk8reTt
	 GGEaJ5OORFId5M9tHphR5JGe1X5ai96NF4MfBIPyzsVCyA0rYXaqpOx8VSBEI41Cail4V
	 ivtz4k68wpmTcKkz8AM+OmWZOT3UDfwU9E5HXnGgS3rFwYh6g1ZsMGnq+JndL2QdgL3NB
	 Rhys1OfaCsITYDQc353k+XGmPYj4rYVqMBUUaCsGDM6T+OVHphuj6mVM3OmelnS5gPPT+
	 NZeSxvfgSKkfm8iYu27xJAN+6hIPQQTxeG8Qc0dKv1LkG0T67TNfCJJlD9h3gOBpsNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B1KyA7Kg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ECC606A32A;
	Wed, 11 Nov 2026 15:21:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24ECC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B1KyA7Kg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A1831576;
	Wed, 11 Nov 2026 07:21:07 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EAA83F632;
	Wed, 11 Nov 2026 07:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794410470; bh=DmAs+HkipAZuaZn8YrcV1VGdsx0DsSHBMvKZ5WRURDE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B1KyA7Kgss5vCsVOUwiYdwJToTKixvHpOMmrCnzlwf8ErGjQhgtBbGyav0GClivkZ
	 lp//gb99/8oKdkwlD95FPXsCE80n++pFolGayiV6aRyTe92skXFv/ZLH0ilvIkCfQ4
	 M6OOgcFofaLnBKsdKA4qQ/dtT8uB26RdhGQ8SVMw=
Message-ID: <fbc33983-cb8a-48e4-854f-ce009cc5668f@arm.com>
Date: Wed, 11 Nov 2026 15:21:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-3-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261111145758.217946-3-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2026 14:57, Steven Price wrote:
> Check the guest_memfd backing file when deciding whether an arm64
> memslot has mappable memory rather than checking whether the slot is
> gmem only. A public helper function is added to be able to reuse the
> static kvm_gmem_supports_mmap() function.
> 

Please could you explain why we need this ? Why not rely on
kvm_memslot_is_gmem_only(), which already tells kvm_gmem_supports_mmap() 
? With inplace conversion support gmem supports mmap.



> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> ---
> Changes since v1:
> - New patch in v2. Check the guest_memfd backing file rather than the
>    memslot flag when deciding whether arm64 can map the backing memory.
> ---
>   arch/arm64/kvm/mmu.c     | 7 ++++---
>   include/linux/kvm_host.h | 1 +
>   virt/kvm/guest_memfd.c   | 6 ++++++
>   3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db7..a146f6cde3d0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2839,10 +2839,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>   		return -EFAULT;
>   
>   	/*
> -	 * Only support guest_memfd backed memslots with mappable memory, since
> -	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 * Protected VMs currently require guest_memfd backed memslots with
> +	 * mappable memory to support shared mappings.
>   	 */
> -	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +	if (kvm_arch_has_private_mem(kvm) && kvm_slot_has_gmem(new) &&
> +	    !kvm_gmem_slot_supports_mmap(new))
>   		return -EINVAL;
>   
>   	/* guest_memfd is incompatible with MTE. */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7fc94e2910a..f65728a713ec 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2614,6 +2614,7 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
>   
>   #ifdef CONFIG_KVM_GUEST_MEMFD
>   bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
> +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot);
>   bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
>   
>   static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 8c97a69b16dc..3dd8d227bebb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -442,6 +442,12 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
>   	return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
>   }
>   
> +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot)
> +{
> +	/* The guest_memfd file is pinned while preparing a new memslot. */

We should gate this on kvm_slot_has_gmem() and how do we ensure that the
call comes after it is prepared ?

> +	return kvm_gmem_supports_mmap(file_inode(slot->gmem.file));
> +}
> +
>   static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   {
>   	struct inode *inode = file_inode(vmf->vma->vm_file);


Cheers
Suzuki
