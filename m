Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539553;
	b=4HqFOQh3tyA/zot0O6UDjogaWVypqbdo9ZQa3K2p1LQguZla6p70M42ojxfYoAc45F4F
	 xdj+3rZS9eYazKra6ECKaUDD4T3JH0LtO/iRD1GmETvTZkMsEApQyR2PJv+IEPsX8sgkQ
	 UREgtECOc1SGKDwjDnNKWjt4UbGx96oFBBZDS6mMrencCweZB4HGbNfDtcQ5artY4LuZm
	 oJFRWi/Rjr9Q+Qz+pXuIolkPOxALBAwjm0jNApEj7uYFm6RHbnE8uouZc+Plo3iOVD7R3
	 Ccu9vSXlP3UgVOFKZfIDuXEolrqtRIK+B4fKBWvH5eDNJ+6XicJAsXfD8ncPHF4Eecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539553;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=OsTrCOvBFWxn4axo5RZn2nb5R4o7XckDXTyC7dJ8tr4=;
	b=HP7HSMvI9MyyygWNip3LJU2X7CzvqAjAqKjptb66fDz16H+15YfKrZDVQBr6bFKJF6SB
	 /g6azu22Bi9HVp28NOutgutwpIxG7Gmt9TTRxAebQWPBxHm+XoERlA+H0onItIDkRWf7e
	 Ye/11p06zoKjAhaJOGQJ1dMgyXQEqf3WvbYsgVTqoa1MFKIYCsAe4ABBlIReA4O6Nm4W3
	 8EIjPTyH2y68tNFkmjl67KQteA2q2rAdhmFGxChWZWCriCcV2CfE4IvhZVQYhJYd3Zc2g
	 TydfVfrYVCTQG78XSu/K0+QlmlEO6HF+HQDuLfAqdRY+pYzsOVY3b91cpcrmTbS4EBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBTNmNHO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D26606A31C;
	Fri, 13 Nov 2026 03:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VBTNmNHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EA21F000C4;
	Fri, 13 Nov 2026 03:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539553;
	bh=OsTrCOvBFWxn4axo5RZn2nb5R4o7XckDXTyC7dJ8tr4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VBTNmNHOV2NCySGEhL4lt7Zm/2MSpOfxDQE/jEAxoMxO7N6+ovffiyo7YxD3k03W1
	 /VOXAv8B0lHM/gdfXd5cPnbE5LuHWQbFdU4WzMKVCjThec8hmkOetbyDIpqnB5CEpC
	 FE7FznFYkMgrXZqiTrod+75QWnHgld0efwHFQnUawpERdtj2MYdzLFzXsW1sDS3QBf
	 cAvwrKaSDd+MVXcH4YxcT5YLy5Faon8BI1A2BJ8QZU0F3n9NPjQ8kJ+V54TcgFW490
	 RLFqWodLIe4mEXN61GnNjX8mvC0Lq1d51IpDU+k2S3eJ9kAFDvRpJwUf6ySLDfL28E
	 hCW+/9Cz85YNA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	media-ci@linuxtv.org
Subject: Re: [PATCH v9 06/14] dma-pool: Allocate CoCo atomic pools using
 CoCo shared memory allocator
In-Reply-To: <sashiko-outbox-199544@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-7-aneesh.kumar@kernel.org>
 <sashiko-outbox-199544@kernel.org>
Date: Fri, 13 Nov 2026 08:42:10 +0530
Message-ID: <yq5amrrdmnlh.fsf@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] dma-pool: cc_make_shared() runs after arch_dma_prep_coherent()
> --
>
> commit daae4fcc15a00bc83c4081ef4b27786a7f224537
> Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>
> dma-pool: Allocate CoCo atomic pools using CoCo shared memory allocator
>
> This commit updates atomic_pool_expand() to allocate confidential computing
> shared atomic DMA pools using the cc_shared layout and transition helpers
> (cc_shared_calc_layout(), cc_make_shared(), and cc_make_private()), enforcing
> shared granule size alignment and minimum allocation order.
>
>> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
>> index 70b7f64b17ab5..da487c3f9dc61 100644
>> --- a/kernel/dma/pool.c
>> +++ b/kernel/dma/pool.c
>
> [ ... ]
>
>> @@ -126,8 +142,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
>>  	 * shrink so no re-encryption occurs in dma_direct_free().
>>  	 */
>>  	if (dma_pool->cc_shared) {
>> -		ret = set_memory_decrypted((unsigned long)page_to_virt(page),
>> -					   1 << order);
>> +		ret = cc_make_shared(page_to_virt(page), pool_size);
>
> [Severity: High]
> Does calling cc_make_shared(page_to_virt(page), pool_size) after
> arch_dma_prep_coherent() and dma_common_contiguous_remap() leave dirty cache
> lines on the cacheable linear mapping alias when CONFIG_DMA_DIRECT_REMAP is
> enabled?
>

This is getting fixed by 

https://lore.kernel.org/all/20261109230830.1707975-1-m.szyprowski@samsung.com

-aneesh
