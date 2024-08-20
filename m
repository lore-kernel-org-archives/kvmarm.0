Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CCD1922EE
	for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164762; cv=none; b=p50bASOvSMNb8DjKFQ1nRhmalTMzqGTMnONkGyVKseIiEFeSkQI3dkP4fbeXWgxGFRX/aJEGugERsqIKJ+KHwUkFMgwxhDmRyWLiTckGwJe0wSLNeunVRX5DEzjdskHe4tX3e0psEsIMqcyrH4UuAJyS/vwh7k8v/gMbYG1sj8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164762; c=relaxed/simple;
	bh=6K/5oa3KeOCD8BeLjlcTBvqfRBS/79+0n2Kq0SJWKq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oP9IkriuhKrdqvgDG097kJ2/8BuTTnP0ToZN3scnawq8Qg/DzZHVjw46ps5vvfHBzRGZXnhnpkR5ZVdAV9JtqjU+vx+MXl6nPogf6yXxERkUcq5/+J/AQJSrDF9D4+/11CG/qNrgtm7yFzl2Do0Z995EH+sE+GkSA6JmI0uDIBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAQr8Kfb; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAQr8Kfb"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-427fc9834deso38605e9.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Aug 2024 07:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724164758; x=1724769558; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cqVmNf36unFHBK+FfoUHfv7AMu5TB9aKm0xHrMHZXeI=;
        b=oAQr8KfbK78UawWsKPrrRcZne9Qw28mzJyWe4bi/+MmHjqJFSuHDkMzw2TUPVoUPD+
         8qZvqpjx3CMpz91sLjvLBoE/s4/oXGSE2kNUyPI62wQXGXIb5kwpJflbRi2RCpshz453
         C1zoGgr30vVez9bSeQweVUPbyWHvnrNLc5UPmuIIwSUJAEB6FMz08T0EYbjeM+At2gmm
         Z2pFh4Z6emllRfI89jpQ7MYAg9Q/Y4FZguPU00Ufj4r8bDO/lBvbXgcZtrp2sWl3ezya
         U/Km7LbaW4KzhlSDk1iTv7In1Ohb47MnJwK5VsSyRz/Vn6GNruZIhQ3RWY0cuTI5ahq1
         Ps1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724164758; x=1724769558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqVmNf36unFHBK+FfoUHfv7AMu5TB9aKm0xHrMHZXeI=;
        b=V5D1RvkShqwZSdWfkIywRQ/WrTAyJ5e2a3IRAqSDI0SteQm3FmmoeWey7OEbW9nnHw
         Gagx6rKxkDbwdPepsKDTXSLAC7ntfz8B90rKxiKwWnOAKgCHeH2SeuOGVfOLnKi3j/Ns
         kFE31cdRoHm3Dn5gDq3PDr1/pgqTJ+LUrbXbTFqNkgcmGQh5TDkUE1WoD2+boucpMpn7
         bnNr+XxcACuhj3MMQ043hRLDZX2eYu1QwYaXCUQXOzDYiiihEJscWfHty9tN2sEgJf+x
         nM6TllPD36uEGzrHIBzRUfJhp5KxFDPwwCdlZ+JGIb7U4+2Fwalnqk7b07T++57B7TkO
         klHA==
X-Forwarded-Encrypted: i=1; AJvYcCVUr/e64Z8Lb/FGCdnKieLHwfbQ3fbRaUjyJsh+9iEwFV1eMBv5pQUNjXi1oCnWo78UlnlNdOwJ8thUdkzeg+xO6+VlQXUd
X-Gm-Message-State: AOJu0Yz5EgbhMrM4+pSwnAvTO5tG7rQm8G1jd5NhzOz7rv/lJAV3rgrd
	BK/ZITyAsdLekn6M6SA9VjDAtM9lVg+RtIY5Aa/1y2d1k1n8znO9v+z3IdON6Q==
X-Google-Smtp-Source: AGHT+IGIk3MuqZdFNT/V7eQCmxiAfwHKBaInvEhxBOOQ8nVu90AHYeozvhTj6iSXtj9NeYtV9xajCA==
X-Received: by 2002:a05:600c:3d8d:b0:426:5d89:896d with SMTP id 5b1f17b1804b1-42ab78c2de8mr553675e9.1.1724164758048;
        Tue, 20 Aug 2024 07:39:18 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded29303sm196157775e9.15.2024.08.20.07.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 07:39:17 -0700 (PDT)
Date: Tue, 20 Aug 2024 14:39:16 +0000
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
Message-ID: <ZsSqlIVsSylHaGaW@google.com>
References: <20240816123906.3683425-1-sebastianene@google.com>
 <20240816123906.3683425-4-sebastianene@google.com>
 <86seuzxq27.wl-maz@kernel.org>
 <ZsSkh2iw8s5Oa5xb@google.com>
 <86o75nxody.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o75nxody.wl-maz@kernel.org>

On Tue, Aug 20, 2024 at 03:25:13PM +0100, Marc Zyngier wrote:
> On Tue, 20 Aug 2024 15:13:27 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > On Tue, Aug 20, 2024 at 02:49:04PM +0100, Marc Zyngier wrote:
> > > On Fri, 16 Aug 2024 13:39:03 +0100,
> > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > 
> > > > Printing the descriptor attributes requires accessing a mask which has a
> > > > different set of attributes for stage-2. In preparation for adding support
> > > > for the stage-2 pagetables dumping, use the mask from the local context
> > > > and not from the globally defined pg_level array. Store a pointer to
> > > > the pg_level array in the ptdump state structure. This will allow us to
> > > > extract the mask which is wrapped in the pg_level array and use it for
> > > > descriptor parsing in the note_page.
> > > > 
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/ptdump.h |  1 +
> > > >  arch/arm64/mm/ptdump.c          | 13 ++++++++-----
> > > >  2 files changed, 9 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > > > index bd5d3ee3e8dc..71a7ed01153a 100644
> > > > --- a/arch/arm64/include/asm/ptdump.h
> > > > +++ b/arch/arm64/include/asm/ptdump.h
> > > > @@ -44,6 +44,7 @@ struct ptdump_pg_level {
> > > >   */
> > > >  struct ptdump_pg_state {
> > > >  	struct ptdump_state ptdump;
> > > > +	struct ptdump_pg_level *pg_level;
> > > >  	struct seq_file *seq;
> > > >  	const struct addr_marker *marker;
> > > >  	const struct mm_struct *mm;
> > > > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > > > index 404751fd30fe..ca53ef274a8b 100644
> > > > --- a/arch/arm64/mm/ptdump.c
> > > > +++ b/arch/arm64/mm/ptdump.c
> > > > @@ -117,7 +117,7 @@ static const struct ptdump_prot_bits pte_bits[] = {
> > > >  	}
> > > >  };
> > > >  
> > > > -static struct ptdump_pg_level pg_level[] __ro_after_init = {
> > > > +static struct ptdump_pg_level kernel_pg_levels[] __ro_after_init = {
> > 
> > Hi Marc,
> > 
> >  
> > > Do you actually need this sort of renaming? Given that it is static,
> > > this looks like some slightly abusive repainting which isn't warranted
> > > here.
> > 
> > I applied Will's suggestion from
> > https://lore.kernel.org/all/20240705111229.GB9231@willie-the-truck/
> > >
> > > 
> > > I also didn't understand the commit message: you're not tracking any
> > > mask here, but a page table level. You are also not using it for
> > > anything yet, see below.
> > 
> > and I missed updating the commit message.
> > 
> > > 
> > > 
> > > >  	{ /* pgd */
> > > >  		.name	= "PGD",
> > > >  		.bits	= pte_bits,
> > > > @@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> > > >  	       u64 val)
> > > >  {
> > > >  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
> > > > +	struct ptdump_pg_level *pg_level = st->pg_level;
> > > 
> > > This is what I mean. What is this pg_level used for?
> > 
> > I make use of it to extract the name based on the level. The suggestion
> > that Will made allowed me to keep the code with less changes.
> 
> Err, I see that now. It'd be good if you described what actually
> happens, because it is almost impossible to understand it from reading
> the patch.

Yes, let me re-write the commit message in the next version,

Thanks,
Seb

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
