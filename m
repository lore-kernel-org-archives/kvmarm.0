Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792585730;
	b=gQNLlRNAzrz62Y82HH1TblVqb8efdGnBbKsVhfOM2vLLjZKmfw09viWjMKmP68wDYGPy
	 PXmNGKNd46Oo8jgss8hsvdXFNQN1XSG8WQA5Mc7c2EkcpkahANCjyppqHJjiKalDR1P89
	 5Q9uBUbV9qV3YmTDATDhhcGvchsJv2R6v64goYswApTWn+qwSkEeq/BjgSP8WfOoJv/Sa
	 DxbXq7Y3qj+JLk3wsVvo5MPZh5F9e6avwvMltKWgxJ9BDKAvPqHvCjPy11y+9x7IT+p47
	 TsbqIhFMsMjlT39MCzMDnQzeNtoV9/VcEXa6FvzqW6qPAAMBJRhC7LIiwhGcw0qHxDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792585730;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x7YCZmHpFRCHFyGPTyhGucE8A4eYFXcryDMfwgdgRZc=;
	b=leRExGcUaLLi677z9WFYZyUvuKUJGI8/NrkjRTu/ENd2zBQlLreJFflgUz+w2vkOfY9j
	 0tsCjOeauDkZo7LNy9k+NDX07yHK/uTfdUkoZ+Bd13PFKhRlZYGnh4elUCMEHWWvXvpDQ
	 0QK4hlyUd9VPS6RbIGviLgDlacpSgadLYNOM9ZWDbIKUZHf3Kufw7F0KrKyNTfoF2sOa7
	 +hIfVupasqikOacikuLHScX8QHU0B+77sBi6aaIw1VI9CM4gxp1+SgL9OiSK4vfK1y4F3
	 JE0MoxrboAGJoTBrvpwdQtyEcFkYWvCTFQTYJITgpIYQ0yx878VzxkE8xZq2FmUnvZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hm22FjB9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37B606A319;
	Wed, 21 Oct 2026 12:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hm22FjB9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DE21F000C4;
	Wed, 21 Oct 2026 12:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792585729;
	bh=x7YCZmHpFRCHFyGPTyhGucE8A4eYFXcryDMfwgdgRZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hm22FjB98pQQqDEUKzhBwrhVIvZRBkT9Uo5aEGJEM9c1lNfcoEvpHGBEGnblB5GQv
	 NHiub28gA6QMTNzNCefGTjrfOoccMxUQ4R79JsznGZvZ/V2BDI7CA2iT+hq+Zn2FaE
	 waw4hVMX3VITTXm5347EF70HjF9l+WNqRfQfLI5FIKUb59SlugRL98f8qWFCdsJaNr
	 r72i0ZV7YAX4/DKecqUMhHfOscT8fKpLFi0oFHBubU1JmDVzmPK60bCKmCdftc9NSm
	 wLRBqzORgHDGCTp/FgTETDkGK7HcIQDVpNx6SLEGgpcx1ikViAvR8WPWGjovOV07pB
	 5cPW0d+FrRvFQ==
Date: Wed, 21 Oct 2026 13:28:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Price <steven.price@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, David Hildenbrand <david@kernel.org>, 
	Fuad Tabba <tabba@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm64: mte: Add mte_clear_folio_tags()
Message-ID: <ativTPb95ZxK2_ho@gremlin>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
 <20261021110700.493315-5-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021110700.493315-5-fuad.tabba@linux.dev>

On Wed, Oct 21, 2026 at 12:07:00PM +0100, Fuad Tabba wrote:
> mte_sync_tags(), sanitise_mte_tags() and kvm_vm_ioctl_mte_copy_tags()
> each open-code the loop that clears the tags of every page in a hugetlb
> folio. Add mte_clear_folio_tags() and use it in all three.
> kvm_vm_ioctl_mte_copy_tags() then tests for hugetlb first, as it does
> where it sets the tagged flag below.
>
> No functional change intended.
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Great LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/include/asm/mte.h |  4 ++++
>  arch/arm64/kernel/mte.c      | 15 ++++++++++-----
>  arch/arm64/kvm/guest.c       | 10 +++++-----
>  arch/arm64/kvm/mmu.c         |  3 +--
>  4 files changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
> index 7f7b97e099968..5a2d2814c0416 100644
> --- a/arch/arm64/include/asm/mte.h
> +++ b/arch/arm64/include/asm/mte.h
> @@ -96,6 +96,7 @@ static inline bool try_page_mte_tagging(struct page *page)
>  }
>
>  void mte_zero_clear_page_tags(void *addr);
> +void mte_clear_folio_tags(struct folio *folio);
>  void mte_sync_tags(pte_t pte, unsigned int nr_pages);
>  void mte_copy_page_tags(void *kto, const void *kfrom);
>  void mte_thread_init_user(void);
> @@ -128,6 +129,9 @@ static inline bool try_page_mte_tagging(struct page *page)
>  static inline void mte_zero_clear_page_tags(void *addr)
>  {
>  }
> +static inline void mte_clear_folio_tags(struct folio *folio)
> +{
> +}
>  static inline void mte_sync_tags(pte_t pte, unsigned int nr_pages)
>  {
>  }
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 1a9aad6ef22a0..fb2598f8c0ccd 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -36,6 +36,14 @@ DEFINE_STATIC_KEY_FALSE(mte_async_or_asymm_mode);
>  EXPORT_SYMBOL_GPL(mte_async_or_asymm_mode);
>  #endif
>
> +void mte_clear_folio_tags(struct folio *folio)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < folio_nr_pages(folio); i++)
> +		mte_clear_page_tags(page_address(folio_page(folio, i)));
> +}
> +
>  void mte_sync_tags(pte_t pte, unsigned int nr_pages)
>  {
>  	struct page *page = pte_page(pte);
> @@ -43,12 +51,9 @@ void mte_sync_tags(pte_t pte, unsigned int nr_pages)
>  	unsigned long i;
>
>  	if (folio_test_hugetlb(folio)) {
> -		unsigned long nr = folio_nr_pages(folio);
> -
> -		/* Hugetlb MTE flags are set for head page only */
> +		/* A hugetlb folio is marked tagged as a whole, so clear every page */
>  		if (folio_try_hugetlb_mte_tagging(folio)) {
> -			for (i = 0; i < nr; i++, page++)
> -				mte_clear_page_tags(page_address(page));
> +			mte_clear_folio_tags(folio);
>  			folio_set_hugetlb_mte_tagged(folio);
>  		}
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cda655fbff657..c75466384f8ac 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1012,7 +1012,6 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  		void *maddr;
>  		unsigned long num_tags;
>  		struct folio *folio;
> -		unsigned long i;
>
>  		if (!page) {
>  			ret = -EFAULT;
> @@ -1046,11 +1045,12 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  			 * tags. A hugetlb folio is marked tagged as a whole,
>  			 * so its first tagging clears every page.
>  			 */
> -			if (!folio_test_hugetlb(folio))
> +			if (folio_test_hugetlb(folio)) {
> +				if (folio_try_hugetlb_mte_tagging(folio))
> +					mte_clear_folio_tags(folio);
> +			} else {
>  				try_page_mte_tagging(page);
> -			else if (folio_try_hugetlb_mte_tagging(folio))
> -				for (i = 0; i < folio_nr_pages(folio); i++)
> -					mte_clear_page_tags(page_address(folio_page(folio, i)));
> +			}
>  			num_tags = mte_copy_tags_from_user(maddr, tags,
>  							MTE_GRANULES_PER_PAGE);
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6e10aa9913d71..f8139c0a54deb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1514,8 +1514,7 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  	if (folio_test_hugetlb(folio)) {
>  		/* A hugetlb folio is marked tagged as a whole, so clear every page */
>  		if (folio_try_hugetlb_mte_tagging(folio)) {
> -			for (i = 0; i < folio_nr_pages(folio); i++)
> -				mte_clear_page_tags(page_address(folio_page(folio, i)));
> +			mte_clear_folio_tags(folio);
>  			folio_set_hugetlb_mte_tagged(folio);
>  		}
>  		return;
> --
> 2.47.3
>

--
Cheers, Lorenzo
