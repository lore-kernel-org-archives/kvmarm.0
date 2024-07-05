Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA81482F2;
	Fri,  5 Jul 2024 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720177957; cv=none; b=IbNTSiPwTO64ESbe+l8HTkmuwM5PuzyJa0XpfgYl7CTsJRWLHDxIPuctgdMhc2HHsrBbILLCnd/u62Y7PD7WpNW0Y+Dkj6u5ub6Yv3hrAfC9OAgSDezxsfQuN4EPG5cpJfpo49nVFrzFAUVAcK2bu463kGWLDGJL9uDlPkyXmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720177957; c=relaxed/simple;
	bh=PvXeRJAzFscDm61pr6mja1ORi6ukE0DpHM53EQ0/1go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W71yV8YxJwKaTwDIiWkOiXGyLuJVo1W2fftxCRoimGtkvQnrPYb47yfpkkAC8NY/x/CrAPIKDi7DrmfjlM4rKJykIqAZsi+tTDH9Ll8Z7WglV7WywwH5W95fYQdKt3UZYp5pVntrvYSp6wTKTNUGY1/I2fxflxoIylyvUy2zcJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAMUAPpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAMUAPpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2578C32781;
	Fri,  5 Jul 2024 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720177956;
	bh=PvXeRJAzFscDm61pr6mja1ORi6ukE0DpHM53EQ0/1go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pAMUAPpt5ZXABefd1bahPf5t5OZq7JxZlqiIX0tal9xkVnUIg40icDzQTAGpMMRCS
	 rpFP61eDJM58V+0yPeLfLzqExxxAxswPCqWe69R1xWxbRgHDoSrPGd9GGNiNB+Sh0d
	 Kmwm7x+h3kPm09Wtfe4lc9fQUBgyPFftYQAs6MbMe5195KoydXq6CXpTVsSudWGWg8
	 9sF/RGSzXN0b3jM56JtnGsvc8874jhp185vhREgMPHQ+jVIZrLvc76LA0RntZs4lGZ
	 2cf1lMbbNN3yI5+i9kKeyB/oadOqnFJ9B4h2D0Pzf9zTMl654poUI0H/KUMKJdmE+h
	 LHabESNWTJMuA==
Date: Fri, 5 Jul 2024 12:12:29 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, rananta@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 3/6] arm64: ptdump: Use the mask from the state
 structure
Message-ID: <20240705111229.GB9231@willie-the-truck>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621123230.1085265-4-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jun 21, 2024 at 12:32:27PM +0000, Sebastian Ene wrote:
> Printing the descriptor attributes requires accessing a mask which has a
> different set of attributes for stage-2. In preparation for adding support
> for the stage-2 pagetables dumping, use the mask from the local context
> and not from the globally defined pg_level array. Store a pointer to
> the pg_level array in the ptdump state structure. This will allow us to
> extract the mask which is wrapped in the pg_level array and use it for
> descriptor parsing in the note_page.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/ptdump.h |  1 +
>  arch/arm64/mm/ptdump.c          | 13 ++++++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index c550b2afcab7..a4125d8d5a32 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -44,6 +44,7 @@ struct pg_level {
>   */
>  struct pg_state {
>  	struct ptdump_state ptdump;
> +	struct pg_level *pg_level;
>  	struct seq_file *seq;
>  	const struct addr_marker *marker;
>  	const struct mm_struct *mm;
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index e370b7a945de..9637a6415ea7 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  	       u64 val)
>  {
>  	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
> +	struct pg_level *pg_info = st->pg_level;
>  	static const char units[] = "KMGTPE";
>  	u64 prot = 0;
>  
> @@ -201,7 +202,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  		level = 0;
>  
>  	if (level >= 0)
> -		prot = val & pg_level[level].mask;
> +		prot = val & pg_info[level].mask;

If you rename the existing 'pg_level' array to something like
'kernel_pg_levels' then I think your local 'pg_info' variable can be
called 'pg_level' and this line doesn't need to change.

>  
>  	if (st->level == -1) {
>  		st->level = level;
> @@ -227,10 +228,10 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  			unit++;
>  		}
>  		pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
> -				   pg_level[st->level].name);
> -		if (st->current_prot && pg_level[st->level].bits)
> -			dump_prot(st, pg_level[st->level].bits,
> -				  pg_level[st->level].num);
> +				   pg_info[st->level].name);
> +		if (st->current_prot && pg_info[st->level].bits)
> +			dump_prot(st, pg_info[st->level].bits,
> +				  pg_info[st->level].num);

I think this could then stay as-is too.

>  		pt_dump_seq_puts(st->seq, "\n");
>  
>  		if (addr >= st->marker[1].start_address) {
> @@ -262,6 +263,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
>  		.seq = s,
>  		.marker = info->markers,
>  		.mm = info->mm,
> +		.pg_level = &pg_level[0],

Can't this just be '.pg_level = kernel_pg_levels'?

Will
