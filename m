Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1760B189F3F
	for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724163215; cv=none; b=oqUyBgJIHugQ+WEANysfacVXE60KsMlW+yTPAJM0tlKRqusDgLJEyWv4I/PdIG1r7DMLj/XTbZ80MiThjQKdojybE6eASo3Pkena/8c9k52xl/BUgiYQ829sIX8b5HNR6HjDHQfCzOjx0t6qup+gnz0i1HmAnxvOq6oiVL0S1wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724163215; c=relaxed/simple;
	bh=yGCtgCorSiOAoryOCIgqexjc0t7ggJz8lR+Bfk0R4+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ejeex07afJ7cUBUvsVoeDWNKtMT3q8VTcWfoIcBEkemnjI03UDHHSqkgSPzK4OUiMIkwvopCjsNtIfP8EZpKc4Fhw7RukfZ6kelbsAA1W9GBT6AMjkHcKNDXxloCzExCmx/JoMtq0Nry5KOAc21K26pPof+W0ZKJmPsrFzJhIqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Hf6qRYa; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Hf6qRYa"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bec7c5af2aso7094a12.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 07:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724163212; x=1724768012; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e23Hu8+Z1sCUC2nCZq+qZMQygcSEW/P8er1otbAoihc=;
        b=2Hf6qRYa6YzcnKEVXf2rRO4UKzqttlrQBUFLqgRi949hXRvHTzsTKtMeTbz6ipyOjr
         +5O5p1PuFoX1piiWKYar9lL7mm9cNkL7qr0Wmv4wX8INQaiQb1hCit9dXcHKkm2W4Ltv
         EbgJiKjM2w5xUdXZ79ZNSD+XYgzM1dNxvUaHkXsiyK1KfBSyQ7gLxv23cydPIardbeIJ
         6WuNBFvbM5YoO4PD+zu0VKpmzTzH7S40J9sFR8+BGMZ0xl0YWbLU26uJx2B0myyx/w6Q
         xLTjvokwd1hSpCHbC6RHf7zroJk63rymRWs3wIJ4c/yvUkrwrl0iNTAcxfsLxTYNdOC0
         INYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724163212; x=1724768012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e23Hu8+Z1sCUC2nCZq+qZMQygcSEW/P8er1otbAoihc=;
        b=q57bx2l5dgaffhpC2ciEwHRpepP1CLCf3fxF8OUqmS+zqBlOp95Q3KUerE7sq71qrJ
         hOyi0mBmaODw5UvKYxk8jB07jXc3TutRZklaGVVa3M5PDXUNI/JFb5NRqsKh1YPyQCyo
         tasWHDM0kTEMquhwBVG9C7wI/RQ53k7ea2QV8CEswqMGd73V7H95sk6ay1h+dIsaTg65
         GxvXALEAf1UHiTbSJEOiQ+VIPJ58cxru93P8ds6lsUNr5eHAZ7L67P4saur2LxmPIrKM
         4TMOBhRK24Nfee17LGUOIwI3c+aEEsFj8X8uSMTkwhI71W9isQLMlxnrajRrznOlQpuW
         b0zw==
X-Forwarded-Encrypted: i=1; AJvYcCUAv9QxoNtWWMBaNOtZp4Ba6NbT4wJYjM8or0hT8LCCrnzJa4ykQtElVGv4nRiXSIG+5MfeNoc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8ZCUCkcmILpJRbJ1yBK63Rq2sENdRpxX02HTOdc6STB5pzhVk
	ByR9QD1G7HBAki9qw2d5aYSe+1iIrbUQpsaHhLvgJWIfyriZkB6PFU3AQ0/7cg==
X-Google-Smtp-Source: AGHT+IH6v5g16+oGR8+nvA7bQYPp8gwjKoUxL4x3NW45RWOQa0iz4Xar7ykgmKpu8OpJ6xRVSzRb1A==
X-Received: by 2002:a05:6402:3546:b0:5be:c28a:97cf with SMTP id 4fb4d7f45d1cf-5bf0e5a28eemr65188a12.5.1724163212081;
        Tue, 20 Aug 2024 07:13:32 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded364fesm195663365e9.27.2024.08.20.07.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 07:13:31 -0700 (PDT)
Date: Tue, 20 Aug 2024 14:13:27 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v8 3/6] arm64: ptdump: Use the mask from the state
 structure
Message-ID: <ZsSkh2iw8s5Oa5xb@google.com>
References: <20240816123906.3683425-1-sebastianene@google.com>
 <20240816123906.3683425-4-sebastianene@google.com>
 <86seuzxq27.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86seuzxq27.wl-maz@kernel.org>

On Tue, Aug 20, 2024 at 02:49:04PM +0100, Marc Zyngier wrote:
> On Fri, 16 Aug 2024 13:39:03 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Printing the descriptor attributes requires accessing a mask which has a
> > different set of attributes for stage-2. In preparation for adding support
> > for the stage-2 pagetables dumping, use the mask from the local context
> > and not from the globally defined pg_level array. Store a pointer to
> > the pg_level array in the ptdump state structure. This will allow us to
> > extract the mask which is wrapped in the pg_level array and use it for
> > descriptor parsing in the note_page.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/ptdump.h |  1 +
> >  arch/arm64/mm/ptdump.c          | 13 ++++++++-----
> >  2 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > index bd5d3ee3e8dc..71a7ed01153a 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -44,6 +44,7 @@ struct ptdump_pg_level {
> >   */
> >  struct ptdump_pg_state {
> >  	struct ptdump_state ptdump;
> > +	struct ptdump_pg_level *pg_level;
> >  	struct seq_file *seq;
> >  	const struct addr_marker *marker;
> >  	const struct mm_struct *mm;
> > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > index 404751fd30fe..ca53ef274a8b 100644
> > --- a/arch/arm64/mm/ptdump.c
> > +++ b/arch/arm64/mm/ptdump.c
> > @@ -117,7 +117,7 @@ static const struct ptdump_prot_bits pte_bits[] = {
> >  	}
> >  };
> >  
> > -static struct ptdump_pg_level pg_level[] __ro_after_init = {
> > +static struct ptdump_pg_level kernel_pg_levels[] __ro_after_init = {

Hi Marc,

 
> Do you actually need this sort of renaming? Given that it is static,
> this looks like some slightly abusive repainting which isn't warranted
> here.

I applied Will's suggestion from
https://lore.kernel.org/all/20240705111229.GB9231@willie-the-truck/
>
> 
> I also didn't understand the commit message: you're not tracking any
> mask here, but a page table level. You are also not using it for
> anything yet, see below.

and I missed updating the commit message.

> 
> 
> >  	{ /* pgd */
> >  		.name	= "PGD",
> >  		.bits	= pte_bits,
> > @@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  	       u64 val)
> >  {
> >  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
> > +	struct ptdump_pg_level *pg_level = st->pg_level;
> 
> This is what I mean. What is this pg_level used for?

I make use of it to extract the name based on the level. The suggestion
that Will made allowed me to keep the code with less changes.

Thanks,
Seb

> 
> >  	static const char units[] = "KMGTPE";
> >  	u64 prot = 0;
> >  
> > @@ -262,6 +263,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
> >  		.seq = s,
> >  		.marker = info->markers,
> >  		.mm = info->mm,
> > +		.pg_level = &kernel_pg_levels[0],
> >  		.level = -1,
> >  		.ptdump = {
> >  			.note_page = note_page,
> > @@ -279,10 +281,10 @@ static void __init ptdump_initialize(void)
> >  {
> >  	unsigned i, j;
> >  
> > -	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
> > -		if (pg_level[i].bits)
> > -			for (j = 0; j < pg_level[i].num; j++)
> > -				pg_level[i].mask |= pg_level[i].bits[j].mask;
> > +	for (i = 0; i < ARRAY_SIZE(kernel_pg_levels); i++)
> > +		if (kernel_pg_levels[i].bits)
> > +			for (j = 0; j < kernel_pg_levels[i].num; j++)
> > +				kernel_pg_levels[i].mask |= kernel_pg_levels[i].bits[j].mask;
> >  }
> >  
> >  static struct ptdump_info kernel_ptdump_info __ro_after_init = {
> > @@ -297,6 +299,7 @@ bool ptdump_check_wx(void)
> >  			{ 0, NULL},
> >  			{ -1, NULL},
> >  		},
> > +		.pg_level = &kernel_pg_levels[0],
> >  		.level = -1,
> >  		.check_wx = true,
> >  		.ptdump = {
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
