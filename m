Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409AF52F9E
	for <kvmarm@lists.linux.dev>; Fri, 23 Aug 2024 05:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724390524; cv=none; b=ReETOcAY98YBdwD63zqFXP72CneMArHfhI+dBAjzjHTCMSFTMqzoQBkqUesNaLkk0AVwIEyW3lPlsHFv5z9YJU5HT2TMr/do8sSb6EJULuT2H2VylksFb1TAg08aUg/d4YcI87RzZKUALfp3Qg+1RgwuqYJuw3BEYzCNvg7Ramo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724390524; c=relaxed/simple;
	bh=02oePitC1YRTMIq8qs60oNRbz/9WvpkZje6s3ZT0Kw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJxhSJGrdjWKwyv+63Jd5AYYOj8ZjtdRrVxriu7toW3dak2MIY9jX2FZDuYaqocyMm1rCzYFDHIhO6TrqsejDZHKFZRAR2Wzn5z28RDle6XzmvgSrDMrdn3NdlqFSuo4UEYnkoWVUOvrQO5ERPMAvEhgPruaSRNKRZ5TeLoeygM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SoDtT5I0; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SoDtT5I0"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5bec507f4ddso9235a12.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 22:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724390520; x=1724995320; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uet9U2HrK3DDTVPxLWw7T/TPH3t4QYpkiQ6FRu69I08=;
        b=SoDtT5I0h6W6RFU+owuGBO4PSYpguAQVdtuDpbnSXVbE8Ga7UlMxNEj4qNaLsCYqVL
         oXMkXzYa+usbt5i7HxehyJWapUGzvRSRFJO/QFPSJZsc5x0yLbM3c+GEftCFn1fV23Gn
         EM7BRCIuwdq70L99DS+i5II7OIgOiEeylvEtrvD2DNYvgpkQDT1qJvEfs40qRs69VJZ6
         UikzBYsmPI10sJJT1Otzrh/QNJdggZRF0jFT7+F7tU0HQeuM+QcopjwAniyNZ7n4kB7B
         KBsSRL4+mrnN2jABahaeMP0+yG9paUjihfrJFrsqlVeAL3nfe35+aG42+/mTuIsl272a
         hbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724390520; x=1724995320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uet9U2HrK3DDTVPxLWw7T/TPH3t4QYpkiQ6FRu69I08=;
        b=HyWWZbJw/m2zOxjntsUNU+hM6VACv5nDmLTIk+L7bZCIQ+Nkq1zN5RR6Ca9dF2NeTE
         Gh0xsntQnlUgqZROlmo2tyb1+9mJVjsE5jMfaIKC0qweulNFpOmLvyJNH92u1ACOptWg
         Hvy5izbZLVbMjtDtrIIN1sQKqvvWbPnK++38xFLHzqarqXwN1jb8jevbglNqPAlh56rF
         51RbCE20cCNJAbc9Hnt374CS3MjGJ0YGZ9uIBZFziO2GZOa39Rijv3FrIV1wEJA908Qe
         FlAFrFaUMQ7ZV5zRld4t+6qAhz2ktTzvRhhcMwyw181uqKU7wbIrRzhDZPqQXoQ8YIBc
         kgeA==
X-Forwarded-Encrypted: i=1; AJvYcCVlGoaheGENz41obzeG0PkwiWeY0qXYwPSmiQ8+BNndYkGPcFbFXyezx09jPUd2FwumIT8SpvI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5Fp8+Djc0IwP8O2+JGg8wITx04PpHU3HdUudj+4yPNuab5Yf5
	+pYL0WO8XB/HNaLo24lvODHiQfZwxLuZ8Fd+fbOkRhsyTnf9IFtv3cObcIhq3Q==
X-Google-Smtp-Source: AGHT+IHX7tl5DbRivNHSGrXaXjN7w0N7ivyfde8OdjfcE2wwK+UU5/Q3ZPbA/FFuKu71Tegra0xcDA==
X-Received: by 2002:a05:6402:51d1:b0:59f:9f59:9b07 with SMTP id 4fb4d7f45d1cf-5c0870abd46mr92310a12.4.1724390520099;
        Thu, 22 Aug 2024 22:22:00 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37308110436sm3247482f8f.11.2024.08.22.22.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2024 22:21:59 -0700 (PDT)
Date: Fri, 23 Aug 2024 05:21:58 +0000
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
Subject: Re: [PATCH v8 5/6] KVM: arm64: Initialize the ptdump parser with
 stage-2 attributes
Message-ID: <Zsgcdjh4EvqFWMlA@google.com>
References: <20240816123906.3683425-1-sebastianene@google.com>
 <20240816123906.3683425-6-sebastianene@google.com>
 <86plq3xoly.wl-maz@kernel.org>
 <8634mwy1mt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634mwy1mt.wl-maz@kernel.org>

On Thu, Aug 22, 2024 at 05:15:54PM +0100, 'Marc Zyngier' via kernel-team wrote:
> On Tue, 20 Aug 2024 15:20:25 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Fri, 16 Aug 2024 13:39:05 +0100,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > > 
> > > Define a set of attributes used by the ptdump parser to display the
> > > properties of a guest memory region covered by a pagetable descriptor.
> > > Build a description of the pagetable levels and initialize the parser
> > > with this configuration.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/ptdump.c | 135 ++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 129 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > index 52483d56be2e..79be07ec3c3c 100644
> > > --- a/arch/arm64/kvm/ptdump.c
> > > +++ b/arch/arm64/kvm/ptdump.c
> > > @@ -14,6 +14,51 @@
> > >  #include <kvm_ptdump.h>
> > >  
> > >  
> > > +#define MARKERS_LEN		(2)
> > > +#define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > > +
> > > +struct kvm_ptdump_guest_state {
> > > +	struct kvm		*kvm;
> > > +	struct ptdump_pg_state	parser_state;
> > > +	struct addr_marker	ipa_marker[MARKERS_LEN];
> > > +	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
> > > +	struct ptdump_range	range[MARKERS_LEN];
> > > +};
> > > +
> > > +static const struct ptdump_prot_bits stage2_pte_bits[] = {
> > > +	{
> > > +		.mask	= PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= " ",
> > > +		.clear	= "F",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | PTE_VALID,
> > > +		.set	= "R",
> > > +		.clear	= " ",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | PTE_VALID,
> > > +		.set	= "W",
> > > +		.clear	= " ",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= " ",
> > > +		.clear	= "X",
> > > +	}, {
> > > +		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > +		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > +		.set	= "AF",
> > > +		.clear	= "  ",
> > > +	}, {
> > > +		.mask	= PTE_TABLE_BIT | PTE_VALID,
> > > +		.val	= PTE_VALID,
> > > +		.set	= "BLK",
> > > +		.clear	= "   ",
> > > +	},
> > > +};
> > > +
> > >  static int kvm_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> > >  			      enum kvm_pgtable_walk_flags visit)
> > >  {
> > > @@ -40,15 +85,81 @@ static int kvm_ptdump_show_common(struct seq_file *m,
> > >  	return kvm_pgtable_walk(pgtable, 0, BIT(pgtable->ia_bits), &walker);
> > >  }
> > >  
> > > +static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
> > > +{
> > > +	static const char * const level_names[] = {"PGD", "PUD", "PMD", "PTE"};
> > 
> > How about 5 level page tables, which we support since v6.8? The
> > architecture uses a SL=-1 in this case, and I have the feeling this is
> > going to expose in a lovely way, given that you use a u32 for
> > start_level... :-/
> 

Hello Marc,

> Talking to Oliver, I just had an epiphany: we never have a 5th level
> with KVM, because we always use concatenated page tables at the start
> level. So the depth is still 4 levels, but we get up to 16 pages at
> level 0, and that's how we expand the IPA space from 48 to 52 bits.
> 

Thanks for letting me know. Then it should be fine keeping that as an
unisgned integer.

> So by the look of it, your code should still be OK with only 4 levels.
> 

Thanks,
Seb

> Apologies for leading you in the wrong direction.
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
