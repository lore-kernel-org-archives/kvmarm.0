Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795716212;
	b=DPOAndpujJCljNgrDhXccahCN6QJ/6D8odLzFXG489KhXkntmJBYif8imdnQE/r0ASog
	 Yn6uml/nCynOqmP/jGWye9d8qU5MnI2TY+nR4pGTMcMdlSLMuvr1ZnjRTz9Xghcj9np/5
	 xOoQ5ZWhC68o1OoyC8AAVIUK7uYTIIz4Tx7jo7MtiYUEGNC9F18CTGfdH+OTATFuH4TAA
	 Hv0Th45Rwjt8bfo1c+RioGKA5rh2KbOyhgp7KzFlobx2fHpdAa60YJ4aSDQxUVxhI/l5t
	 VJ1d4bGPTxQ0BB609ExdDEvLBHw/iduIY5V3n14xpkhmzEj/zTlnHng8S/SoBZ4T8sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795716212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=SRMbopjT2ZDCp3S0bduHH4K2gvQ2HvHqic8ibWdFK5o=;
	b=lIw3B1KkhNJJZUceqREmThcW7u00HidKLvvGtrkQtxWRqbq831o+vpyfrZeGayc69d5X
	 xEXmasKjRKjTQD10Sb22AfusP94L9aUfHG1vYAQVuy2SDkou+kpA0QL0M7KG0p+LrGpiF
	 OnOs6Wz9itaUQdMFkk3sWxQFVoRMz9jTdFWuhpkf30kWgbC3jMHM1aYeyVGOB/F9aIWW1
	 GkiJ6JCcSkNySIUexFQhJTxQemjmgyg3HwBG68xn1/FoWVOQeaCvw4FJHi5ez+sZxNPmk
	 Bq1IqhM9/lCk4w3TTM8RCOi0eQwgir6PP+wC8+yWvA6rCFa7wklMUgXp4XwDbwnTAfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGnBv2u0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360C7606A333;
	Thu, 26 Nov 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGnBv2u0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F3F1F00AE3;
	Thu, 26 Nov 2026 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716211;
	bh=SRMbopjT2ZDCp3S0bduHH4K2gvQ2HvHqic8ibWdFK5o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OGnBv2u03WCFZWsDn0SqFklZyJny8+Af7jkPORwbwrdfJO9Uuyh3rw7lkea/8Q6vB
	 cSIp8xQifnWtaWmwzYmEuwcFqqquwhEDZYU9qydrjf+sBZlYdV0Uh4OcohneorzOIF
	 dQPa+xbeiqQcdPDC9Oa7jdvVgs4qB+n6553AGLoeNcTPRVh325vt+HhS5HZHGL1sQs
	 OkUadX01xuDVnzUkH625JGfejnQ3/CAK3j6h3DWaPExj7QpjphDplmcLYj/MRIcgd0
	 eVototx5kDwOQb/DevkWMQPYQDKm10UmfNq6zCKguaXM2lSgE0EpwfzgMQkEYxMgnP
	 jCJ1NS7tAygTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/19] kho: vmalloc: Add the feature header
In-Reply-To: <20261110050202.529473-8-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:50 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-8-tarunsahu@google.com>
Date: Thu, 26 Nov 2026 18:03:23 +0000
Message-ID: <2vxzh5h3wjv8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
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

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Register struct kho_vmalloc with the KHO serialization feature header
> mechanism to allow future additive fields or feature extensions without
> breaking live update ABI compatibility.
>
> Add DECLARE_KHO_SER(kho_vmalloc, 16, 0, 0) to register the 16-byte
> structure with 0 required and 0 optional features. Update function
> prototypes in include/linux/kexec_handover.h to take
> DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr) parameters, documenting which
> registered structure the feature header belongs to while enforcing
> compile-time type verification.
>
> In kho_preserve_vmalloc(), initialize the feature header with
> kho_ser_init() and access the payload fields via kho_ser_payload().
> In kho_restore_vmalloc(), validate incoming required features with
> kho_ser_validate() and access payload fields via kho_ser_payload().
> In kho_unpreserve_vmalloc(), access payload fields via kho_ser_payload().
> The chunk page format and traversal remain unchanged.
>
> Update memfd_luo and test_kho to pass typed feature header pointers
> and use kho_ser_size() for allocation sizing.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
[...]
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> index 7b49dd6d7e2a..b0597c438973 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -80,9 +80,9 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
>   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
>   *             to directly use them in the ABI.
>   * @flags:     Flags for the file. Unused flag bits must be set to 0.
> - * @nr_folios: Number of folios in the folios array.
> - * @folios:    Pointer to KHO vmalloc descriptor for the array of
> - *             struct memfd_luo_folio_ser.
> + * @nr_folios:   Number of folios in the folios array.
> + * @folios_fhdr: Pointer to KHO vmalloc descriptor for the array of
> + *               struct memfd_luo_folio_ser.
>   */
>  struct memfd_luo_ser {
>  	u64 pos;
> @@ -90,7 +90,7 @@ struct memfd_luo_ser {
>  	u32 seals;
>  	u32 flags;
>  	u64 nr_folios;
> -	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
> +	DECLARE_KHOSER_PTR(folios_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));

This doesn't _only_ point to the feature header. It points to the
vmalloc buffer of of folios, conceptually. So it should be called
"folios". Reading folios_fhdr everywhere is super confusing and hard to
read. Users of KHO vmalloc should be pointing to the KHO malloc
serialization structure, not to its headers or so on.

The feature header is an implementation detail of kho_vmalloc (same for
others). It should not be visible to its callers.

>  };
>  
>  static_assert(sizeof(struct memfd_luo_ser) == 40);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 641a3b4c88fb..6e428df717cc 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1378,20 +1378,20 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
>  /**
>   * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
>   * @ptr: pointer to the area in vmalloc address space
> - * @preservation: placeholder for preservation metadata
> + * @fhdr:         placeholder for preservation metadata
>   *
>   * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
>   * physical pages mapped at @ptr will be preserved and on successful return
> - * @preservation will hold the physical address of a structure that describes
> - * the preservation.
> + * @fhdr will hold the preservation metadata.
>   *
>   * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
>   * restored on the same node
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
> +int kho_preserve_vmalloc(void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
>  {
> +	struct kho_vmalloc *vmalloc_ser;
>  	struct kho_vmalloc_chunk *chunk;
>  	struct vm_struct *vm = find_vm_area(ptr);
>  	unsigned int order, flags, nr_contig_pages;
> @@ -1404,13 +1404,18 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
>  	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
>  		return -EOPNOTSUPP;
>  
> +	kho_ser_init(fhdr, kho_vmalloc);
> +
> +	vmalloc_ser = kho_ser_payload(fhdr, kho_vmalloc);
> +
>  	flags = vmalloc_flags_to_kho(vm->flags);
>  	order = get_vm_area_page_order(vm);
> +	vmalloc_ser->order = order;

Nit: Why is this moving around? Seems like a stray change.

Also, renaming preservation to vmalloc_ser adds a lot of noise to your
diff. Perhaps keep it as-is for now?
>  
>  	chunk = new_vmalloc_chunk(NULL);
>  	if (!chunk)
>  		return -ENOMEM;
> -	KHOSER_STORE_PTR(preservation->first, chunk);
> +	KHOSER_STORE_PTR(vmalloc_ser->first, chunk);
>  
>  	nr_contig_pages = (1 << order);
>  	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
[...]

-- 
Regards,
Pratyush Yadav
