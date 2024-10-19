Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399B210A12
	for <kvmarm@lists.linux.dev>; Sat, 19 Oct 2024 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729347418; cv=none; b=XCdBKMyVOFek+TIvweGBof8265NOUirwhhMcsDSK1YvRLTGq028IRfADCDNscJfct4d1f4Ab5ywnzbyUlEII5ijFGqrZIPt8ChjuN20zxR53e+fftELQwfzPv8+y9hdF+rvXzhorf+OAZb1lK7gg8U9cLe1D5wEBSGIr499cB0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729347418; c=relaxed/simple;
	bh=qfeFyKWSeWg05vNifWelioEjA0kkQ+RAGToocF3RQXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nixHKXvstrAntQQQM27pa6M7qZzEzdD5tn+qcqL0+Zq6dFJMQUwQjohWVexKsBRuSqcJ/93s9BszNcUuyB0pVhgISFuaP+BqCDDCHvjPvWCOed1h82uKVfqfNZOrOiNXRLo0Mioid4ThM3BvJzm6MXyyb/SfWZGEjdq1ZzqWJoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=oiEWqF7s; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="oiEWqF7s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1729347405;
	bh=qfeFyKWSeWg05vNifWelioEjA0kkQ+RAGToocF3RQXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oiEWqF7sTLXrz7do2I45MU3h9GnxoASkakIBLXLfO8QPbyFcjud2WS7a4OHr+O/j6
	 mSZXAZ+gLrbHF+5i8CqYp+heOCBk0HRmg9xEfocwgikxIkEKz10dFDgcvhPeShqBpA
	 GBeauy9gbC60noyWg48dH5RYqqm+DI5v5PyxTYX4=
Date: Sat, 19 Oct 2024 14:16:42 +0000
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Hildenbrand <david@redhat.com>, 
	Greg Marsden <greg.marsden@oracle.com>, Ivan Ivanov <ivan.ivanov@suse.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Marc Zyngier <maz@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Matthias Brugger <mbrugger@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Oliver Upton <oliver.upton@linux.dev>, 
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 44/57] arm64: Align sections to PAGE_SIZE_MAX
Message-ID: <69533deb-dc77-49c3-a256-49efee308905@t-8ch.de>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
 <20241014105912.3207374-44-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014105912.3207374-44-ryan.roberts@arm.com>

On 2024-10-14 11:58:51+0100, Ryan Roberts wrote:
> Increase alignment of sections in nvhe hyp, vdso and final vmlinux image
> from PAGE_SIZE to PAGE_SIZE_MAX. For compile-time PAGE_SIZE,
> PAGE_SIZE_MAX == PAGE_SIZE so there is no change. For boot-time
> PAGE_SIZE, PAGE_SIZE_MAX is the largest selectable page size.
> 
> For a boot-time page size build, image size is comparable to a 64K page
> size compile-time build. In future, it may be desirable to optimize
> run-time memory consumption by freeing unused padding pages when the
> boot-time selected page size is less than PAGE_SIZE_MAX.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
> 
> ***NOTE***
> Any confused maintainers may want to read the cover note here for context:
> https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/
> 
>  arch/arm64/include/asm/memory.h     |  4 +--
>  arch/arm64/kernel/vdso-wrap.S       |  4 +--
>  arch/arm64/kernel/vdso.c            |  7 +++---
>  arch/arm64/kernel/vdso/vdso.lds.S   |  4 +--
>  arch/arm64/kernel/vdso32-wrap.S     |  4 +--
>  arch/arm64/kernel/vdso32/vdso.lds.S |  4 +--
>  arch/arm64/kernel/vmlinux.lds.S     | 38 ++++++++++++++---------------
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S   |  2 +-
>  8 files changed, 34 insertions(+), 33 deletions(-)

> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index 89b6e78400023..1efe98909a2e0 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -195,7 +195,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
>  
>  	vdso_text_len = vdso_info[abi].vdso_pages << PAGE_SHIFT;
>  	/* Be sure to map the data page */
> -	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE;
> +	vdso_mapping_len = vdso_text_len + VVAR_NR_PAGES * PAGE_SIZE_MAX;
>  
>  	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
>  	if (IS_ERR_VALUE(vdso_base)) {
> @@ -203,7 +203,8 @@ static int __setup_additional_pages(enum vdso_abi abi,
>  		goto up_fail;
>  	}
>  
> -	ret = _install_special_mapping(mm, vdso_base, VVAR_NR_PAGES * PAGE_SIZE,
> +	ret = _install_special_mapping(mm, vdso_base,
> +				       VVAR_NR_PAGES * PAGE_SIZE_MAX,
>  				       VM_READ|VM_MAYREAD|VM_PFNMAP,
>  				       vdso_info[abi].dm);
>  	if (IS_ERR(ret))
> @@ -212,7 +213,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
>  	if (system_supports_bti_kernel())
>  		gp_flags = VM_ARM64_BTI;
>  
> -	vdso_base += VVAR_NR_PAGES * PAGE_SIZE;
> +	vdso_base += VVAR_NR_PAGES * PAGE_SIZE_MAX;
>  	mm->context.vdso = (void *)vdso_base;
>  	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
>  				       VM_READ|VM_EXEC|gp_flags|

> diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/vdso.lds.S
> index 45354f2ddf706..f7d1537a689e8 100644
> --- a/arch/arm64/kernel/vdso/vdso.lds.S
> +++ b/arch/arm64/kernel/vdso/vdso.lds.S
> @@ -18,9 +18,9 @@ OUTPUT_ARCH(aarch64)
>  
>  SECTIONS
>  {
> -	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
> +	PROVIDE(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
>  #ifdef CONFIG_TIME_NS
> -	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE);
> +	PROVIDE(_timens_data = _vdso_data + PAGE_SIZE_MAX);

This looks like it also needs a change to vvar_fault() in vdso.c.
The symbols are now always PAGE_SIZE_MAX apart, while vvar_fault() works
in page offsets (vmf->pgoff) that are based on the runtime PAGE_SIZE and
it expects hardcoded offsets.

As test you can use tools/testing/selftests/timens/timens.

(I can't test this right now, so it's only a suspicion)

>  #endif
>  	. = VDSO_LBASE + SIZEOF_HEADERS;

> diff --git a/arch/arm64/kernel/vdso32/vdso.lds.S b/arch/arm64/kernel/vdso32/vdso.lds.S
> index 8d95d7d35057d..c46d18a69d1ce 100644
> --- a/arch/arm64/kernel/vdso32/vdso.lds.S
> +++ b/arch/arm64/kernel/vdso32/vdso.lds.S
> @@ -18,9 +18,9 @@ OUTPUT_ARCH(arm)
>  
>  SECTIONS
>  {
> -	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE);
> +	PROVIDE_HIDDEN(_vdso_data = . - __VVAR_PAGES * PAGE_SIZE_MAX);
>  #ifdef CONFIG_TIME_NS
> -	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE);
> +	PROVIDE_HIDDEN(_timens_data = _vdso_data + PAGE_SIZE_MAX);
>  #endif
>  	. = VDSO_LBASE + SIZEOF_HEADERS;
