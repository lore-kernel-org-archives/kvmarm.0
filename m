Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B763457E6D
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245334; cv=none; b=uct/cmgLVi3X2Ygd4WkxaIjQ8CBV0qPaTZZoVF0S3p9wkUvrZWOQ8sV37yyPNnNGRi18jhPyojmUGx43SVo3PZngu50Lrh68pP33a/mzf4QBtdMuzhXFEqHJbjxOvaePH900RWbY7xnyRbEhtza4ashnaiubckqkS/x7i2z9UsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245334; c=relaxed/simple;
	bh=vXefGUv5PqK3RYCDK4oZNQUPoju384n9r7GEy10XmD0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dw2PSOSwbxDxEHMGCorJ0dkN9TPeXB2BL2krg4w+5+IjVPnNnzVEIslPOmI/c/bYmraGzEDnMzDCD0QTRyV1Uj56aburXBPp+KlZhS+5C+f5wMhruia8cOpu5I/8MyLXODJQzcA9KjttSxR0zJBNMjpQnsACUooZNg2ZN41o82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtnUwN3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtnUwN3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429C41F00893;
	Thu, 24 Sep 2026 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245332;
	bh=zKYx3kDRPb7Z8P9stq2bQ3C8P/z3NFTA0Vy7a1Abkrk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VtnUwN3hmlGtKm7aUuxUL0lihyN2yKK9BFg7UhHR0If8SGHk+6zFkxE2VsPR/unrS
	 IVHVwv+c5Roz6HVtWGq+tXo7EcpThrSRndnF7cbgZhtKuh1mPOizDN5xamnLkME33O
	 iWm7ptSXtxDiI+KYnWfx1dHn8CROqItmUwYT6aL+QkIdPRetCumMSlvtxImySq7h6a
	 kLg43kTBDKVjpvll0/beXX3rlkOwGI17fEZu9CGt4rcU1wdanH7PiiRMk2HdWa5ag4
	 1ATsqQK102l/HhxLpJRMcA5qjfHXL43W8G9oShYHVvS+R5YAl7n1PYfYBhULBZioRe
	 pnjZjP4Uc5qPg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v8 02/14] mm: Zero memory during shared memory
 transitions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, media-ci@linuxtv.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260924100529.1398790-3-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-3-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:22:11 +0000
Message-Id: <20260924102212.429C41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm: ciphertext garbage in shared mappings due to zeroing in pr=
epare callback
- [High] hv: uninitialized kernel memory leaked on non-confidential VMs
--

commit 0b9cafc26c64a65c124d5f6d15281e2bb9c41b6e
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

mm: Zero memory during shared memory transitions

This commit makes zeroing an implicit property of set_memory_decrypted().
Each architecture clears memory at a safe point in its transition, and
redundant post-transition memset() calls are removed from standard allocato=
rs.

> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> --- a/arch/x86/coco/tdx/tdx.c
> +++ b/arch/x86/coco/tdx/tdx.c
> @@ -978,6 +978,9 @@ static int tdx_enc_status_change_prepare(unsigned lon=
g vaddr, int numpages,
>  					 bool enc)
>  {
> +	if (!enc)
> +		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
> +

[Severity: Critical]
Does this write encrypted zeroes into RAM? Because this memset() in
tdx_enc_status_change_prepare() happens before the PTE encryption bit is
cleared, writing zeroes through the encrypted mapping results in ciphertext
being stored. When the mapping later transitions to shared, reading this
memory will yield that raw ciphertext.

[ ... ]

> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -285,6 +286,9 @@ static void enc_dec_hypercall(unsigned long vaddr, un=
signed long size, bool enc)
> =20
>  static int amd_enc_status_change_prepare(unsigned long vaddr, int npages=
, bool enc)
>  {
> +	if (!enc)
> +		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
> +

[Severity: Critical]
Could amd_enc_status_change_prepare() suffer from the same ciphertext issue?
Writing zeroes to the private encrypted mapping before the transition leaves
ciphertext in RAM, which will appear as garbage once the page is mapped as
decrypted and shared.

[ ... ]

> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -123,12 +123,13 @@ static int hv_alloc_page(void **page, bool decrypt,=
 const char *note)
>  	if (!*page)
>  		return -ENOMEM;
> =20
> -	if (decrypt)
> +	if (decrypt) {
>  		ret =3D set_memory_decrypted((unsigned long)*page, 1);
> -	if (ret)
> -		goto failed;
> -
> -	memset(*page, 0, PAGE_SIZE);
> +		if (ret)
> +			goto failed;
> +	} else {
> +		memset(*page, 0, PAGE_SIZE);
> +	}
>  	return 0;

[Severity: High]
Does hv_alloc_page() bypass memset() on non-confidential VMs? On standard
VMs, decrypt can evaluate to true. set_memory_decrypted() is a no-op that
returns 0 there, and since __get_free_page() doesn't use __GFP_ZERO, this
path could return completely uninitialized kernel memory to the hypervisor.

[ ... ]

> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -505,8 +505,6 @@ int hv_common_cpu_init(unsigned int cpu)
>  				/* It may be unsafe to free 'mem' */
>  				return ret;
>  			}
> -
> -			memset(mem, 0x00, pgcount * HV_HYP_PAGE_SIZE);
>  		}

[Severity: High]
Could hv_common_cpu_init() leak uninitialized memory here? The
kmalloc_array() allocation above doesn't use __GFP_ZERO, so removing this
memset() leaves the hypercall input/output page uninitialized on standard
VMs.

[ ... ]

> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -324,7 +324,9 @@ void *dma_direct_alloc(struct device *dev, size_t siz=
e,
>  		cpu_addr =3D page_address(page);
>  	}
> =20
> -	memset(cpu_addr, 0, size);
> +	/* Zero after remapping because the page may be in HighMem. */
> +	if (!mark_mem_decrypt)
> +		memset(cpu_addr, 0, size);
> =20
>  	if (set_uncached) {

[Severity: Critical]
Is it safe to bypass this memset() for shared CC memory in
dma_direct_alloc()? Since the memset() inside the x86 prepare callbacks
leaves ciphertext in memory, skipping the post-transition zeroing here means
we will return garbage-filled memory to callers expecting clean DMA buffers.

[ ... ]

> @@ -457,11 +463,13 @@ struct page *dma_direct_alloc_pages(struct device *=
dev, size_t size,
>  		return NULL;
> =20
>  	cpu_addr =3D page_address(page);
> -	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) &&
> -	    dma_set_decrypted(dev, cpu_addr, size))
> -		goto out_leak_pages;
>  setup_page:
> -	memset(cpu_addr, 0, size);
> +	if (mark_mem_decrypt) {
> +		if (dma_set_decrypted(dev, cpu_addr, size))
> +			goto out_leak_pages;
> +	} else {
> +		memset(cpu_addr, 0, size);
> +	}
>  	*dma_handle =3D phys_to_dma_direct(dev, page_to_phys(page),
>  					 attrs & __DMA_ATTR_ALLOC_CC_SHARED);

[Severity: Critical]
Does skipping the zeroing here in dma_direct_alloc_pages() for
mark_mem_decrypt also expose callers to raw ciphertext in the returned
buffer?

[ ... ]

> diff --git a/mm/cc_shared.c b/mm/cc_shared.c
> --- a/mm/cc_shared.c
> +++ b/mm/cc_shared.c
> @@ -137,9 +137,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_=
t gfp,
>  		return ret;
>  	}
> =20
> -	if (zero)
> -		memset(page_address(page), 0, layout.shared_size);
> -
>  	mem->page =3D page;
>  	mem->shared_size =3D layout.shared_size;

[Severity: Critical]
Can removing this memset() cause __alloc_cc_shared_pages_node() to return
memory containing ciphertext? Callers expecting zeroed memory will receive
garbage instead.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924100529.1398=
790-1-aneesh.kumar@kernel.org?part=3D2
