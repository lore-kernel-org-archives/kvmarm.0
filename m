Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897568;
	b=cZTW0ABGINgLquTdXu3SVdGClBxq2620oxSN/eFHZOGy8ckWt9M8DeZdSUsMlCitvJRG
	 yVZJkwqE5xrFRmGmAR0TpDWaxMALy5xv9+Dck4DvflUvmjod/L3f+nSAM6oo4C/RHx6I7
	 Xhf0yatN0Jq+TuxzlfnSf0TxzR6k4xj42XHjzuma3XmBsoeCkPb1a0Df9Hzzd8A6dMJlx
	 zaV0EFo5B2BzDEb9+K/vGIkMhzAnXKOFrUb+dpGzrVo0QT8J/6xNaG0rKxjtF/Twk5dNu
	 Jn1R/4wxk2AWk9TZdozyCbrf/v3zWCEZHyyyM/80m6UV6E877zBpz/FYTUYX37XtVOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897568;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=93Jjsh5uP1bJuXaCFxDECc/bZWbVcYpxvdFTfNjDZUY=;
	b=U1gpbVttaih3L9Scdn9FucAnOQvYVNh9S7QooXHaHo7QYXaCr+0izKInzIJQZ2y6kPNa
	 hCrOlPHUl5atm2QSU2psEmxQFkbVPWJeeZv0ch3fTdK4TST0hPKh60IoHE/RQtFyWIlnd
	 yJyMxhULvvMlnI/i+qQ9/rOyUDVoB8kIFddykH5+l2pVEQaFGchfYxb+YvXGmeD4mxatG
	 TDvNfLU5Q0XBCDqfPhqVWyf2jT1JHn6mJcNBaQOIKmPX6blC3yc2A4UEINv6MsmpuT3Te
	 IHyQG09+hcYB0J7vqljRS0UGjCi81O1zTm1w+UIK6GTX81FyidsdlpNdnz0KgZ+QfbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0ECtycT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C86606A334
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0ECtycT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AA51F000C1;
	Thu,  5 Nov 2026 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897568;
	bh=93Jjsh5uP1bJuXaCFxDECc/bZWbVcYpxvdFTfNjDZUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0ECtycT0ID6uIHdj/OpmBK2gU3FHjDn3/gApTFyDgc91RQtJ4WgWm+RL2HwAhVdt
	 nWsuBuZYAr0GwetQrft6qOL+ZG0OfKdSu4K1WmEtRjthoSmuVPdG98l1Kpwf6aQG0W
	 TxNu9lDTAXW6iF8+9OnH1JOR16vW2uC3ZObWq9SKfkU8PZEFIoJyiVJFzz4xz4fKVG
	 zzPcRa9glxwjIFDFcSrYw1yFqUAO0Hkna49kQLb0fVCLIYNVQjfbRuGEiahNsBkEYN
	 wkqeuLitvZXCR+Sp14k3ZHYCWxqNnyon64Q4EWpYZKeW/u8085i4PiD3HSrj4uKiaF
	 h72LTbmmT/bkA==
Message-ID: <sashiko-outbox-199544@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using
 CoCo shared memory allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>, "Marc Zyngier" <maz@kernel.org>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Robin Murphy" <robin.murphy@arm.com>, "Steven
 Price" <steven.price@arm.com>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Russell King" <linux@armlinux.org.uk>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "John
 Stultz" <jstultz@google.com>, "Mark Rutland" <mark.rutland@arm.com>, "Radu
 Rendec" <radu@rendec.net>, "T.J. Mercier" <tjmercier@google.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H
 . Peter Anvin" <hpa@zytor.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Long Li" <longli@microsoft.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Vitaly Kuznetsov" <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, media-ci@linuxtv.org
In-Reply-To: <20261104164555.3555725-7-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-7-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:45 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dma-pool: cc_make_shared() runs after arch_dma_prep_coherent()
--

commit daae4fcc15a00bc83c4081ef4b27786a7f224537
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator

This commit updates atomic_pool_expand() to allocate confidential computing
shared atomic DMA pools using the cc_shared layout and transition helpers
(cc_shared_calc_layout(), cc_make_shared(), and cc_make_private()), enforci=
ng
shared granule size alignment and minimum allocation order.

> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 70b7f64b17ab5..da487c3f9dc61 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c

[ ... ]

> @@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dm=
a_pool, size_t pool_size,
>  	 * shrink so no re-encryption occurs in dma_direct_free().
>  	 */
>  	if (dma_pool->cc_shared) {
> -		ret =3D set_memory_decrypted((unsigned long)page_to_virt(page),
> -					   1 << order);
> +		ret =3D cc_make_shared(page_to_virt(page), pool_size);

[Severity: High]
Does calling cc_make_shared(page_to_virt(page), pool_size) after
arch_dma_prep_coherent() and dma_common_contiguous_remap() leave dirty cache
lines on the cacheable linear mapping alias when CONFIG_DMA_DIRECT_REMAP is
enabled?

In atomic_pool_expand(), arch_dma_prep_coherent() and the vmap remapping run
first:

kernel/dma/pool.c:atomic_pool_expand() {
	...
	arch_dma_prep_coherent(page, pool_size);

#ifdef CONFIG_DMA_DIRECT_REMAP
	if (dma_pool->cc_shared)
		prot =3D pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL));
	else
		prot =3D pgprot_dmacoherent(PAGE_KERNEL);

	addr =3D dma_common_contiguous_remap(page, pool_size, prot,
			__builtin_return_address(0));
	if (!addr)
		goto free_page;
#else
	addr =3D page_to_virt(page);
#endif
	if (dma_pool->cc_shared) {
		ret =3D cc_make_shared(page_to_virt(page), pool_size);
	...
}

Because set_memory_decrypted() (in commit 0a47431deefc ("mm: Zero memory
during shared memory transitions")) zeroes the range through the cacheable
linear map address passed to it:

cc_make_shared()
  -> set_memory_decrypted()
       -> realm_set_memory_decrypted() / pkvm_set_memory_decrypted()
            -> memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);

performing this transition after arch_dma_prep_coherent() has already clean=
ed
the linear map alias dirties the CPU data cache for page_to_virt(page) with
zeros without a subsequent cache clean (and on Arm CCA, cleans the protected
physical address alias before the RIPAS transition rather than the shared
physical address alias after zeroing). Those dirty cache lines on the linear
mapping can later be evicted to the Point of Coherency and overwrite live D=
MA
buffers accessed via the non-cacheable vmap alias at addr.

In contrast, dma_direct_alloc() transitions the pages before calling
arch_dma_prep_coherent() and dma_common_contiguous_remap(). Should
atomic_pool_expand() similarly call cc_make_shared() before
arch_dma_prep_coherent() and dma_common_contiguous_remap()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D6
