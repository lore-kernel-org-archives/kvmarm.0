Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9502F28EA
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 08:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536512; cv=none; b=tOX690lt4dl9OPc470G4F6g8yigapw7SkFoudYxc4zilYDslHtamOmCPNzF2LiW/wAsMOWPSczSJBGtJ74SuiG4oAGrsiHmWphhv1AH/kZJ37WWfaHVAWE3m+ZpL1XbRltuANlmG9Szl5hPxRcNYek1M+Vz94Uxw44mYUIx2S1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536512; c=relaxed/simple;
	bh=Zd1wpy6j5eslq7JRXhCnn94i7JTqW6/xMDM1ttvsk3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFoJw1z9Wjbos7DtIJgoBz4GAj2TE6dbVwFx4FiSqji2YAnx1jTxWXx7/9OWG7qUUWsu1Iv+kkqg2DvBMG+e/C4BHmHiEEyuxkizN4g1CceC45OygYspoIZ2sTt6DjnNvWG0m5ARwJvvZDQ5BIIpkPiyc2x2VOtM5b3DD2gxggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VUn7VLZz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VUn7VLZz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABA102B;
	Mon, 20 Jul 2026 01:35:05 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F01EE3F66F;
	Mon, 20 Jul 2026 01:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784536509; bh=Zd1wpy6j5eslq7JRXhCnn94i7JTqW6/xMDM1ttvsk3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VUn7VLZzdIMhGN3GGLPkKrxXQfjuWBcPIW477yxizdTHNbmLa/OZf+x0wuxuItp02
	 QNyX7iMqH/Pn3VO1oTNTKDwZgmsnJilYT38hOOR/cYKWtWg/Q1CVC2D8Jrx3xhmDak
	 Btdy42sgXTdxHVr1o7vv5WzoU0Ldc0ZrIxc07c8A=
Date: Mon, 20 Jul 2026 09:35:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH] KVM: arm64: ptdump: Flush the last region
Message-ID: <al3dtUVPxBXY0AJP@J2N7QTR9R3.cambridge.arm.com>
References: <20260717231233.2299068-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717231233.2299068-1-weilin.chang@arm.com>

On Sat, Jul 18, 2026 at 12:12:33AM +0100, Wei-Lin Chang wrote:
> Currently the stage-2 ptdump calls note_page() at each leaf entry visit.
> This simply misses the output of the last region, because note_page()
> only dumps output when it detects a change in level/prot, or when the
> walk enters a next marker section. The last region in the guest IPA
> space with the same level/prot is not dumped since there is no change
> after it.
> 
> To dump the final region, manually issue a note_page() call with address
> BIT(ia_bits) (end of guest IPA space) and level == -1 to trigger a level
> change after the last region. Additionally treat level == -1 as a last
> flushing note_page() call and avoid dumping the name of the next marker
> for this case.

I think you can use note_page_flush() rather than doing that manually.

> Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
> Reported-by: Sashiko AI <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/kvmarm/20260630122758.891011F00A3A@smtp.kernel.org/
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/kvm/ptdump.c | 8 +++++---
>  arch/arm64/mm/ptdump.c  | 5 +++--
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index c9140e22abcf..4096e4a92fae 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -155,11 +155,13 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
>  		.seq		= m,
>  	};
>  
> -	write_lock(&kvm->mmu_lock);
> +	guard(write_lock)(&kvm->mmu_lock);
>  	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
> -	write_unlock(&kvm->mmu_lock);
> +	if (ret)
> +		return ret;
> +	note_page(&st->parser_state.ptdump, BIT(mmu->pgt->ia_bits), -1, 0);

This can be:

	note_page_flush(&st->parser_state.ptdump);

The level change alone should trigger the dump, so the address doesn't
need to be at the end of the guest IPA space.

Importantly, note_page_flush() will pass 0 as the address, which won't
trigger the checks you try to suppress below.

Please use note_page_flush() here, and drop the changes to
arch/arm64/mm/ptdump.c.

>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index ab9899ca1e5f..fed4e4407e0e 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -194,6 +194,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
>  	struct ptdump_pg_level *pg_level = st->pg_level;
>  	static const char units[] = "KMGTPE";
> +	bool flush = level == -1;
>  	ptdesc_t prot = 0;
>  
>  	/* check if the current level has been folded dynamically */
> @@ -234,7 +235,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  				  pg_level[st->level].num);
>  		pt_dump_seq_puts(st->seq, "\n");
>  
> -		if (addr >= st->marker[1].start_address) {
> +		if (addr >= st->marker[1].start_address && !flush) {
>  			st->marker++;
>  			pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>  		}

If you use note_page_flush(), addr will be 0. As the final marker is at
BIT(pgtable->ia_bits), this condition cannot fire.

> @@ -244,7 +245,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  		st->level = level;
>  	}
>  
> -	if (addr >= st->marker[1].start_address) {
> +	if (addr >= st->marker[1].start_address && !flush) {
>  		st->marker++;
>  		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>  	}

Likewise here.

Mark.
