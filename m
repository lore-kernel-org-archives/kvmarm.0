Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497501;
	b=rNkqCLBLgtfWbB3FCGIoMfusJwc97V5E3xMQPxHqg5knJgdJNLmk5oGiiKQIyesj8862
	 GXec96Ny4pIZWyJKpE0G2ZtUHiA1TtWaqVKcRtcL7r58LpMqdBHztkD+ylbmlwbarcrn3
	 dulj1J1EpCX/N2yaerzumPx/sNCyeSiRHyHeMOZcHviyo+3pQJOlAR6S0UbJPJLN4Nn2V
	 A7jchAObQz6hXpTMhUwB7eLJSaG/IGj0dpS8H1u14yAQ/1A8iZnRP+H1xxS1ScaIEMpIX
	 lkSDYlHkrwKWyP3tUR0jRw4NIxMPXHqK3rMqVrHUkHvsyAF65zCap5v4s34nXRrKbow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497501;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wUDDCCeo/xzsRa4qQI+rhPZ7oVj1XJXfhtbwBRYdfes=;
	b=EcO1eGkNchMOoQ8uFZiOkkqGa1eGvGmXnCb6Ow/Q93OHdvSWDrBuHO32XS6Fz1VZslTT
	 LaisBiKLUZThm5vhgLb7xnU1+yrolCbG3lbNIV9OCjDd/dmRO3P2e7mCpFxQ2Rn792yZz
	 /1YCHUFBp2098BCLQ0sNxFEUrjXsHnhTFnayGw/OJAg8mKrDP8YT3p3xd+uND2LxmqRFK
	 2WUIcsNUevV3zy8L+z3l75GRUbqLxXP6neyE7bNxgz1xuaXEIV1FxVMMw1Xn69W5aleIY
	 Xu2FrlCFmp8Y66USw2EdDz00L7h5OBFTKR3asxdhs45VbyJ1/DiB1QUjconbeDd2XoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=muxb5d4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51DF606A329;
	Tue, 20 Oct 2026 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=muxb5d4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA76E1F000C6;
	Tue, 20 Oct 2026 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792497500;
	bh=wUDDCCeo/xzsRa4qQI+rhPZ7oVj1XJXfhtbwBRYdfes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=muxb5d4o2qlr8O9BcDWx2nvGEWrRVgRounbDRnVYUFFXnBbWIu0Zy7ynHugFphuVm
	 yqzEEN5rGnb95iZxl5u0HHDmktwC89C/65jsjdSb52v0EKM2qFi+7rfvF8VSmixm7m
	 gi6pqYU2wLrZkIZTqpa8flBZdL8niOugsTzf0981BAbrWy370EE42BXQ9kOdN3BOxu
	 Wqm86rZBgDQ97v0cXOApZyKN3VSfXikRPc7orwxUbx2GtjDS98ayOWkHciHhz045gt
	 iK9RU9kpusVv/lWplJtJBwxFrK6CuOdZ5tv237FMsknk+qYaCHOpdLNJtL3ngR0Idb
	 xgu8N5g7I052Q==
Date: Tue, 20 Oct 2026 12:58:13 +0100
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
Subject: Re: [PATCH 2/3] KVM: arm64: Clear the whole hugetlb folio when
 storing MTE tags
Message-ID: <atdWIpk9Qh8ngs-Y@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-3-fuad.tabba@linux.dev>
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
In-Reply-To: <20261019132103.3836646-3-fuad.tabba@linux.dev>

On Mon, Oct 19, 2026 at 02:21:02PM +0100, Fuad Tabba wrote:
> When KVM_ARM_MTE_COPY_TAGS copies tags into a page, it marks the page as
> tagged. For a hugetlb folio the flag covers every page in the folio. If
> the folio wasn't tagged yet, its other pages are marked as tagged with
> their previous owner's tags still in place. The stage-2 fault path then
> maps them into the guest without clearing them. The ioctl's read side
> also copies them out to the VMM.
>
> Clear the whole folio on its first tagging, before copying in this
> page's tags.
>
> Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Logic LGTM, with some nits below:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/guest.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index b01d6622b8720..cda655fbff657 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1012,6 +1012,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  		void *maddr;
>  		unsigned long num_tags;
>  		struct folio *folio;
> +		unsigned long i;
>
>  		if (!page) {
>  			ret = -EFAULT;
> @@ -1042,12 +1043,14 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  			/*
>  			 * Only locking to serialise with a concurrent
>  			 * __set_ptes() in the VMM but still overriding the
> -			 * tags, hence ignoring the return value.
> +			 * tags. A hugetlb folio is marked tagged as a whole,
> +			 * so its first tagging clears every page.
>  			 */
> -			if (folio_test_hugetlb(folio))
> -				folio_try_hugetlb_mte_tagging(folio);
> -			else
> +			if (!folio_test_hugetlb(folio))
>  				try_page_mte_tagging(page);
> +			else if (folio_try_hugetlb_mte_tagging(folio))

Slightly awkward logic, testing a negative then the negative of the negative
(i.e. else) plus folio_try_hugetlb_mte_tagging(), makes it a little harder to
understand.

With mte_clear_folio_tags() you can make life simpler:

	if (folio_test_hugetlb(folio)) {
		if (folio_try_hugetlb_mte_tagging(folio))
			mte_clear_folio_tags(folio);
	} else {
		try_page_mte_tagging(page);
	}

> +				for (i = 0; i < folio_nr_pages(folio); i++)
> +					mte_clear_page_tags(page_address(folio_page(folio, i)));

As above, similar comment to 1/3 re: mte_clear_folio_tags(). Would be less churn also.

>  			num_tags = mte_copy_tags_from_user(maddr, tags,
>  							MTE_GRANULES_PER_PAGE);
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
