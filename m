Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13AB421F12;
	Tue, 28 Apr 2026 12:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777378861; cv=none; b=R8JaJv4c6FFrM3raqIKRUAwUZMzRPT43btJgqsLPLgKL+N/MvLKnHCn0kByT4zTKeYLmD6KsG4ulWhBOfZAXfdXuwo8J8itv0kfmhexrG+DzJM9udxRohP0E3y4kNgCe9Q/Tr1IBhVvMkc/MEHoZn2M3WyFf17p3i1gRCBzuv8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777378861; c=relaxed/simple;
	bh=ozDwDKFBNLeKOoHjc5hWY9l162eEyHdYA7CmB9NiJYg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QBKXkvQl2AxfUtsZQrIrtYzIae1mdf9LQpLLn2yw1Erimv+5aiLQS4m2/3vfiAQUxCHC6q7YHFDtGrViGz0DpfgSuLOzOpUJaDf78HPVktTkLjanSJqKFOEhYiULqiER4/aJBwEHPJNAnbfxsf5OLzRbCQ6u1MwKnrAB0eiLFwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKVlW/RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKVlW/RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA51BC2BCAF;
	Tue, 28 Apr 2026 12:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777378861;
	bh=ozDwDKFBNLeKOoHjc5hWY9l162eEyHdYA7CmB9NiJYg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NKVlW/RZIJXZ/+Lqz4nVTwZJlREV2Us6G1yThG8jvCQ68JOyZpUe/xDmG1iGsW641
	 0ahsYHTAKNXkSIqO6Chnh5M31aymxlcUp7nvO5lf6K4ztvjBJkUqyJxbTPcMFhBVCf
	 8IuB1kRVOCBYwQhIhCCtbI1cyNnpvu8SdTp0voxT5cXrflwjvt6ZiGKdx0YPwAcnoS
	 IwLA3z7iOcYcY8VieSrOPYbGQftxj4WxM0xI+hxhtOjTzt8Zox82N17htviU3gAQze
	 eNpxGxD0p4DlG/48ckOGHyzJl0CM/zrj8DEtaia0JHX35B42hu/Q6i7tLVsl6TkmBd
	 AzCAwGKKwGgIg==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 2/3] swiotlb: dma: its: Enforce host page-size
 alignment for shared buffers
In-Reply-To: <86zf2ozrb8.wl-maz@kernel.org>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-3-aneesh.kumar@kernel.org>
 <86zf2ozrb8.wl-maz@kernel.org>
Date: Tue, 28 Apr 2026 17:50:53 +0530
Message-ID: <yq5aa4un1dju.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 27 Apr 2026 07:31:07 +0100,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>>=20
>> When running private-memory guests, the guest kernel must apply addition=
al
>> constraints when allocating buffers that are shared with the hypervisor.
>>=20
>> These shared buffers are also accessed by the host kernel and therefore
>> must be aligned to the host=E2=80=99s page size, and have a size that is=
 a multiple
>> of the host page size.
>>=20
>> On non-secure hosts, set_guest_memory_attributes() tracks memory at the
>> host PAGE_SIZE granularity. This creates a mismatch when the guest appli=
es
>> attributes at 4K boundaries while the host uses 64K pages. In such cases,
>> set_guest_memory_attributes() call returns -EINVAL, preventing the
>> conversion of memory regions from private to shared.
>>=20
>> Architectures such as Arm can tolerate realm physical address space
>> (protected memory) PFNs being mapped as shared memory, as incorrect
>> accesses are detected and reported as GPC faults. However, relying on th=
is
>> mechanism is unsafe and can still lead to kernel crashes.
>>=20
>> This is particularly likely when guest_memfd allocations are mmapped and
>> accessed from userspace. Once exposed to userspace, we cannot guarantee
>> that applications will only access the intended 4K shared region rather
>> than the full 64K page mapped into their address space. Such userspace
>> addresses may also be passed back into the kernel and accessed via the
>> linear map, resulting in a GPC fault and a kernel crash.
>>=20
>> With CCA, although Stage-2 mappings managed by the RMM still operate at a
>> 4K granularity, shared pages must nonetheless be aligned to the
>> host-managed page size and sized as whole host pages to avoid the issues
>> described above.
>
> I thought that was being fixed, and that there was now a strong
> guarantee that RMM and host are aligned on the page size. Even more,
> S2 is totally irrelevant here. The only thing that matters is the host
> page size vs the guest page size. Nothing else.
>

Yes, the latest RMM update includes the ability to change the granule
size.

The section above in the commit message was intended to explain that the
S2 mapping size is irrelevant. I agree it is not clear as written, so I
will reword it to improve clarity.

>
>>=20
>> Introduce a new helper, mem_decrypt_align(), to allow callers to enforce
>> the required alignment and size constraints for shared buffers.
>>=20
>> The architecture-specific implementation of mem_decrypt_align() will be
>> provided in a follow-up patch.
>>=20
>> Note on restricted-dma-pool:
>> rmem_swiotlb_device_init() uses reserved-memory regions described by
>> firmware. Those regions are not changed in-kernel to satisfy host granule
>> alignment. This is intentional: we do not expect restricted-dma-pool
>> allocations to be used with CCA. If restricted-dma-pool is intended for =
CCA
>> shared use, firmware must provide base/size aligned to the host IPA-chan=
ge
>> granule.
>>=20
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  arch/arm64/mm/mem_encrypt.c      | 19 +++++++++++++++----
>>  drivers/irqchip/irq-gic-v3-its.c | 20 +++++++++++++-------
>>  include/linux/mem_encrypt.h      | 14 ++++++++++++++
>>  kernel/dma/contiguous.c          | 10 ++++++++++
>>  kernel/dma/direct.c              | 16 ++++++++++++++--
>>  kernel/dma/pool.c                |  4 +++-
>>  kernel/dma/swiotlb.c             | 21 +++++++++++++--------
>>  7 files changed, 82 insertions(+), 22 deletions(-)
>>=20
>
> [...]
>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-=
v3-its.c
>> index 291d7668cc8d..239d7e3bc16f 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -213,16 +213,17 @@ static gfp_t gfp_flags_quirk;
>>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>>  					 unsigned int order)
>>  {
>> +	unsigned int new_order;
>>  	struct page *page;
>>  	int ret =3D 0;
>>=20=20
>> -	page =3D alloc_pages_node(node, gfp | gfp_flags_quirk, order);
>> -
>> +	new_order =3D get_order(mem_decrypt_align((PAGE_SIZE << order)));
>> +	page =3D alloc_pages_node(node, gfp | gfp_flags_quirk, new_order);
>>  	if (!page)
>>  		return NULL;
>>=20=20
>>  	ret =3D set_memory_decrypted((unsigned long)page_address(page),
>> -				   1 << order);
>> +				   1 << new_order);
>>  	/*
>>  	 * If set_memory_decrypted() fails then we don't know what state the
>>  	 * page is in, so we can't free it. Instead we leak it.
>> @@ -241,13 +242,16 @@ static struct page *its_alloc_pages(gfp_t gfp, uns=
igned int order)
>>=20=20
>>  static void its_free_pages(void *addr, unsigned int order)
>>  {
>> +	int new_order;
>> +
>> +	new_order =3D get_order(mem_decrypt_align((PAGE_SIZE << order)));
>>  	/*
>>  	 * If the memory cannot be encrypted again then we must leak the pages.
>>  	 * set_memory_encrypted() will already have WARNed.
>>  	 */
>> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
>> +	if (set_memory_encrypted((unsigned long)addr, 1 << new_order))
>>  		return;
>> -	free_pages((unsigned long)addr, order);
>> +	free_pages((unsigned long)addr, new_order);
>>  }
>>
>
> Here's the non-obfuscated version of the two hunks above (and let it
> be on the record that New Order is a terrible, overrated band):
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v=
3-its.c
> index 291d7668cc8da..a4d555aaee241 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -216,6 +216,7 @@ static struct page *its_alloc_pages_node(int node, gf=
p_t gfp,
>  	struct page *page;
>  	int ret =3D 0;
>=20=20
> +	order =3D get_order(mem_decrypt_align(PAGE_SIZE << order));
>  	page =3D alloc_pages_node(node, gfp | gfp_flags_quirk, order);
>=20=20
>  	if (!page)
> @@ -245,6 +246,7 @@ static void its_free_pages(void *addr, unsigned int o=
rder)
>  	 * If the memory cannot be encrypted again then we must leak the pages.
>  	 * set_memory_encrypted() will already have WARNed.
>  	 */
> +	order =3D get_order(mem_decrypt_align(PAGE_SIZE << order));
>  	if (set_memory_encrypted((unsigned long)addr, 1 << order))
>  		return;
>  	free_pages((unsigned long)addr, order);
>

I will include this in the next revision.


>>  static struct gen_pool *itt_pool;
>> @@ -268,11 +272,13 @@ static void *itt_alloc_pool(int node, int size)
>>  		if (addr)
>>  			break;
>>=20=20
>> -		page =3D its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
>> +		page =3D its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO,
>> +					    get_order(mem_decrypt_granule_size()));
>
> You already taught its_alloc_pages_node() about the decrypt granule
> size stuff. I don't think we need to see more of it (and you don't
> mess with the call that is just above it).
>
>>  		if (!page)
>>  			break;
>>=20=20
>> -		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, =
node);
>> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
>> +			     mem_decrypt_granule_size(), node);
>
> I'd rather see something like mem_decrypt_align(PAGE_SIZE), which
> keeps the intent clear.
>

The helper was added based on feedback from a previous version. I assume
you are suggesting that only this caller should switch?


-aneesh
