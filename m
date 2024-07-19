Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F1C13E88C
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 13:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721395649; cv=none; b=Sw9bZsnTUu6uGsn/wr5PdydePDW3G9OAsO+XGVAd4/GC26BBCM5Ud7HE/ZOj3P8iDk7PDqtpYEAtVg8kl6Ja8UqTHx+YezV6s5zZ2TLChKkDeRPV6CtPfrGaLj1rRdeq/Oqfu+OwRIFXhgolymNqrMOY/tpUcTsngYO3r0rsXiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721395649; c=relaxed/simple;
	bh=RshbvWEB4HEbBs9aVPc2PyYWzMpcMqNWQjoOUGX448I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cexAdJ02ehcT4reDnpAzj/0K6PLm+PBphziyY1gK+w9NmcmI2F04JtOlQP/ELENfl2OL6f1Afh2MPoXNQh/DbW51dP5rqfGtEkFqzaSnfhj89O64fOYgt16NRgg8aTYIG80VGWrPOoERLepsPWNRyWNkl5Oru8LWHKY0UdX6ktA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fApIkuSe; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fApIkuSe"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42666b89057so43655e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 06:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721395646; x=1722000446; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x5Rnu8xhOiOGKULhvQEsLnF6NFu8gN2o/irl+R632WU=;
        b=fApIkuSePlXkeVbR9yuFsIkcf+pTBiLZYyPkVGOMwpouxpODwGnsgfaCxqR1u2LAhL
         QfHPxRrVTUrNPgqU0sXYhDavAZowNioa6R7dEiIQUltsDqJDAy+yFyHqk3fkRnmYT9bM
         pxJdOE3k2uqPmPBRcoORakFx0sNrywF4iJHzmh5jiwu6haYSVoqqWUF74dzBsQnk0om3
         3lds+Pna8aAaVo2J2+2vFBkRhHYJoERz8TtfFjOG/cYAHkBso3sD4D56gfUPdhogDu8o
         llbRyFdXwIc8SAxfxu4bgqbevRezMMio8Zg2d3ej/qmO+f5opnmEgaXLwrjkipvfEfMO
         tNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721395646; x=1722000446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5Rnu8xhOiOGKULhvQEsLnF6NFu8gN2o/irl+R632WU=;
        b=JStG5f3oYlgerBb8xnZYRYXkzER7l0FaPny4dxK/Q7a8ddv+kz5wXP3cJEIFMPMq9G
         KBt+QwmUqHCStJERHuJmfiFTD6Ai8YB2n9BICX7Ny6YO75J++KKG+tCW1g4bjpqMAyLn
         ScS/KH6NFTfcVcgEP+waOxv8y6QGH9R0zqVLuTTiMDf5tUJOjp800Cg1HSvW4v3bvOv8
         PU4/y4E5W8BtZfsvJVexfc9qh3CNy9h61vwdUcRijkZPxLjYwcjTWivxND0HSwUbhsRB
         L9Uo1w0leMnCxTCUzLwhI2HQqbmNPVwbhjGGuVw4plWpl08hR4Lgm4RZI8c03J9qBFwY
         D2ww==
X-Forwarded-Encrypted: i=1; AJvYcCUAyah0+1h7SLWqd0lVshH8m6nC5Njwo4Krl9+BAzfzHUUKcS3lrOcRuEPjQT5rsuqJjTwyvgXkTKa8p5ZKyULjtLiowmNW
X-Gm-Message-State: AOJu0Yw7eHR3PSmk2GyJIr7Myyi5sVwZWcEUL/I1CvRQfurYyVLBRJoH
	Sulkuj0LhFoKjDtKdbiMhdgyf15Jwm/THQRGwMIEQYaz+VWX0lB0vntWupOPgg==
X-Google-Smtp-Source: AGHT+IEbXOwh/C+c3oBafmb5O72ZdYCNr8vSQJ5zdk2fN1eXD/y2lF+GXyUY+3bMQVkSL6rtmL4cOQ==
X-Received: by 2002:a05:600c:1ca2:b0:426:66fd:5fac with SMTP id 5b1f17b1804b1-427d5b43181mr1331635e9.2.1721395645600;
        Fri, 19 Jul 2024 06:27:25 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com. [34.77.222.49])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3687868b262sm1637346f8f.30.2024.07.19.06.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 06:27:25 -0700 (PDT)
Date: Fri, 19 Jul 2024 13:27:23 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
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
Message-ID: <Zpppu5DBmb7MLDXD@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-4-sebastianene@google.com>
 <20240705111229.GB9231@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705111229.GB9231@willie-the-truck>

On Fri, Jul 05, 2024 at 12:12:29PM +0100, Will Deacon wrote:
> On Fri, Jun 21, 2024 at 12:32:27PM +0000, Sebastian Ene wrote:
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
> > index c550b2afcab7..a4125d8d5a32 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -44,6 +44,7 @@ struct pg_level {
> >   */
> >  struct pg_state {
> >  	struct ptdump_state ptdump;
> > +	struct pg_level *pg_level;
> >  	struct seq_file *seq;
> >  	const struct addr_marker *marker;
> >  	const struct mm_struct *mm;
> > diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> > index e370b7a945de..9637a6415ea7 100644
> > --- a/arch/arm64/mm/ptdump.c
> > +++ b/arch/arm64/mm/ptdump.c
> > @@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  	       u64 val)
> >  {
> >  	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
> > +	struct pg_level *pg_info = st->pg_level;
> >  	static const char units[] = "KMGTPE";
> >  	u64 prot = 0;
> >  
> > @@ -201,7 +202,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  		level = 0;
> >  
> >  	if (level >= 0)
> > -		prot = val & pg_level[level].mask;
> > +		prot = val & pg_info[level].mask;
> 
> If you rename the existing 'pg_level' array to something like
> 'kernel_pg_levels' then I think your local 'pg_info' variable can be
> called 'pg_level' and this line doesn't need to change.
> 

This is a good ideea, thanks. I applied your suggestion

> >  
> >  	if (st->level == -1) {
> >  		st->level = level;
> > @@ -227,10 +228,10 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> >  			unit++;
> >  		}
> >  		pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
> > -				   pg_level[st->level].name);
> > -		if (st->current_prot && pg_level[st->level].bits)
> > -			dump_prot(st, pg_level[st->level].bits,
> > -				  pg_level[st->level].num);
> > +				   pg_info[st->level].name);
> > +		if (st->current_prot && pg_info[st->level].bits)
> > +			dump_prot(st, pg_info[st->level].bits,
> > +				  pg_info[st->level].num);
> 
> I think this could then stay as-is too.
> 
> >  		pt_dump_seq_puts(st->seq, "\n");
> >  
> >  		if (addr >= st->marker[1].start_address) {
> > @@ -262,6 +263,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
> >  		.seq = s,
> >  		.marker = info->markers,
> >  		.mm = info->mm,
> > +		.pg_level = &pg_level[0],
> 
> Can't this just be '.pg_level = kernel_pg_levels'?
> 
> Will


Seb
