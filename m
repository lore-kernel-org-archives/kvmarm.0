Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF81A44236A;
	Fri,  7 Aug 2026 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786103221; cv=none; b=LGFMl6D4wxj2QOohh7hJ8hmWU8Cr90A/T4gJHbMBhx69lgIJpKO004g94+paSjyaB5RWKEQVKsk2g9L4sttuadsZRL2PBzB2p3pvUWISQAEe09T+mADoLI8Kay4mI9gRI5yws0sn9bFEO4XtqrqUoibr30Q3UorIDTZF4PnWvI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786103221; c=relaxed/simple;
	bh=gYHQ1vqRp6GzsMk1pxtMlI0BKNOIVmb/uSOwWa1dFlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI+TowYPq/bdjdUhPZOWpr7Pf0vzDl5un2PWvAajxRyjmRyKiw9nfpIKWNc5g7IU8UWzng3eY0GWcr9WGPvAHwA02lBFo/jjCk8O6L5dwMCJl/4YKbU7F5DrCnWQCnpeGeG5YQoYqlcHd0XZoyZKr7kPr2X6pVf+QtHVuPJuIv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HCpugcR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HCpugcR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA001F000E9;
	Fri,  7 Aug 2026 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786103211;
	bh=bilPv4vNqhyKLaddPOoCIRutSih88yAAt4BHUIGsS9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HCpugcR71onLMkdJPcNHQOu2krRWgO3cP7bphLbb7RUaCjLYeuggKDL65YAKZUbfZ
	 0m4JUJvfeIJIpGGPawUAeBGR/k75nPjU4UnrMcO27BvuPHulSgHuMDc75thTrx6sTh
	 b/A9s75dmzOL250NVrU9QqLQiW1mfNWijUH7GbwzpkQ15MFJrPfGFd4U03W/KUEHWg
	 L1PTAliQLZd7fOZnG4Qadiffmdiw8nJnxpbxZgNwv/rx4VSDMtAY4V4S8dMircmVbQ
	 T3GZHWr3d2XDuf4FkC6WOcEKPHqNXxVvluL2JJp14pAsOvlbELX92u8sOQrCDVzv0l
	 +ZaIEryqJat8g==
Date: Fri, 7 Aug 2026 12:46:43 +0100
From: Will Deacon <will@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v2 1/2] arm64: ptdump: Make note_page_flush() range aware
Message-ID: <anXFo-igVdqrCogQ@willie-the-truck>
References: <20260724185431.2990395-1-weilin.chang@arm.com>
 <20260724185431.2990395-2-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724185431.2990395-2-weilin.chang@arm.com>

On Fri, Jul 24, 2026 at 07:54:30PM +0100, Wei-Lin Chang wrote:
> note_page_flush() calls note_page() with addr == 0 and level == -1 to
> dump the last row of a ptdump. addr == 0 (1 << 64 wrapped around)
> renders a huge region with enormous size for address spaces with
> IA bits < 64. For example the stage-2 page tables and the EFI runtime
> page table.
> 
> More importantly, the last region of the address space and everything
> after the address space up to 1 << 64 are merged into one row of
> output. If the last region within the address space is valid, it will
> appear to remain valid up to 1 << 64 with the same attributes.
> 
> Currently only the EFI runtime ptdump is affected by this, but KVM will
> soon fix its stage-2 ptdump by using note_page_flush(). Here is an
> example of an EFI runtime ptdump (last row):
> 
> 0x0000008000000000-0x0000000000000000   17179868672G PGD
> 
> With this patch:
> 
> 0x0000008000000000-0x0001000000000000      261632G PGD
> 
> To fix this, use ptdump_state.range[] to figure out where the address
> space ends, and call note_page() with that.
> 
> Fixes: 9d80448ac92b ("efi/arm64: Add debugfs node to dump UEFI runtime page tables")
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/mm/ptdump.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index 1c20144700d7..5b34060ceb96 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -278,9 +278,24 @@ void note_page_pgd(struct ptdump_state *pt_st, unsigned long addr, pgd_t pgd)
>  
>  void note_page_flush(struct ptdump_state *pt_st)
>  {
> +	const struct ptdump_range *range = pt_st->range;
> +	unsigned long end = 0;
>  	pte_t pte_zero = {0};
>  
> -	note_page(pt_st, 0, -1, pte_val(pte_zero));
> +	while (range->start != range->end) {
> +		end = range->end;
> +		range++;
> +	}

This seems to be duplicating some of what the core code does already in
ptdump_walk_pgd(). Can we retrieve the information we need from the
containing 'struct ptdump_pg_state' structure instead of recomputing
the address?

Will
