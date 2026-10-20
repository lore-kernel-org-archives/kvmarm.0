Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497182;
	b=w4lS/iplSZ4fY+bqFeFJ8xHbQNen6KDlQq261uZgUg7tLp7RKoHz33Nm6bFRgROha62C
	 kNwdI8HI0/xKY/xcAp2zFEUptzEz6tPWbXKWiPpSR5Qy635VsKtFn++gALUKQkPFPh/se
	 wdrdEIocsg4pohn3nvGUBIV3nIXIGt1Sv7EPVtb5sSuIWJIBKKvn0kBNbspWXr19ZrAxb
	 hvoqZr9RIbyKd4S5vrwk7AmQfLWF90yJT2silMqWDqYnHRmEtHl5ovviWuwH15ba+FfGp
	 wanU4OEi+3Gror7gaIpLeutamFB06Xf4Dhk6tTJWNnGNzJ12pruMxhMtve/vNMaSVAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497182;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RUALFoCPuP4ag/Wm4Tjk9NReNJDOBGhLi2LnL7PxTOU=;
	b=xQulQl+7tJtARLua0pY5+XSMtt6FLMlBpPnoA01YYE7Y69bOXMxzkVsR300AxMpQau5D
	 FBpNdeuxADChGfrp4qBINDwmw9iXi8TSPlHy22f6+Gqo7h9g/aP+Dg606maNZ7GlZ84be
	 aq6iPGHadqTRxQloHFvFtKHinFn6BknKGGNs41PXCga+z6JIuhj0x3qNotdcaLY6goh2j
	 wvBOvLpyyV2pR6jLaPMcvmGHzCQyXEkRPYxVhQwjy/XMESSm7V7rM1mzOSdwUiC3U9l87
	 /Q6s4rilnOwgbG4WrAHNTST3yCmNoiqOTM7CIW09s5idsyN4xk0hz1ibIzklzinVzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd+Vs3ar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAE606A31F;
	Tue, 20 Oct 2026 11:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zd+Vs3ar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B9F1F000C5;
	Tue, 20 Oct 2026 11:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792497182;
	bh=RUALFoCPuP4ag/Wm4Tjk9NReNJDOBGhLi2LnL7PxTOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zd+Vs3arajwy5+WYD3opiB8R/t/y46x74me9H0tC1BGifbOJmn88NfzmfaqKDZUd4
	 j26wSB6R1aWrD3VYYBKd5/jmlYe7tCEDsTxnmkzRnq8QRw31nuxmU/4SFX912KrfId
	 9ih5O9VeW7igCxlpsg6/Ll4WWo2hzVj4FonYaRvAQODRnyPJHCp3+xrq83sllTOWXI
	 IDzmDheO2Yyve6GD2lwlMOaAWdQ8UF3fbkNnCqccUvfnT47+T7CCsys3P79oCwyhJw
	 JsaJ3GsV1i3NXaSOLRH6Z7hSsHNWKgJNKtJgbGXNtLf5bdYhlWJPrCcVzyKFD7xjmI
	 OeKsHNeVVcB+A==
Date: Tue, 20 Oct 2026 12:52:54 +0100
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
Subject: Re: [PATCH 1/3] KVM: arm64: Clear the whole hugetlb folio when
 sanitising MTE tags
Message-ID: <atdUzfOA1Obd7Mir@gremlin>
References: <20261019132103.3836646-1-fuad.tabba@linux.dev>
 <20261019132103.3836646-2-fuad.tabba@linux.dev>
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
In-Reply-To: <20261019132103.3836646-2-fuad.tabba@linux.dev>

hugetlb strikes again... :) the mm part of me apologises ;)

On Mon, Oct 19, 2026 at 02:21:01PM +0100, Fuad Tabba wrote:
> sanitise_mte_tags() clears the tags of the pages about to be mapped at
> stage-2 before marking them tagged. For a hugetlb folio the flag covers
> every page in the folio, but the loop only covers the mapping being
> installed. Stage-2 maps a folio in pieces for the contiguous hugetlb
> sizes, and for any size under dirty logging. The first fault then marks
> the whole folio after clearing only its own piece, and the rest keeps
> its previous owner's tags for the guest to read.

I'm guessing the folio size is always >= size here?

>
> Clear the whole folio, as mte_sync_tags() does.
>
> Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Some nits below but generally looks sensible to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..48a08b608ea72 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1514,7 +1514,8 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  	if (folio_test_hugetlb(folio)) {
>  		/* Hugetlb has MTE flags set on head page only */

Is this comment redundant now?

>  		if (folio_try_hugetlb_mte_tagging(folio)) {
> -			for (i = 0; i < nr_pages; i++, page++)
> +			page = folio_page(folio, 0);
> +			for (i = 0; i < folio_nr_pages(folio); i++, page++)

I know it's a stable fix, but the fact that this pattern exists in multiple
places really argues for a mte_clear_folio_tags(), which would make this
trivially:

	mte_clear_folio_tags(folio);

And avoid the re-use of page etc.

It's not a huge change and makes the next patch in the series simpler too so
arguably could be part of the series?

>  				mte_clear_page_tags(page_address(page));
>  			folio_set_hugetlb_mte_tagged(folio);
>  		}
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
