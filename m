Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD29C133
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 03:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754536228; cv=none; b=VOpd/1qHBcSTuuN1QsxksoQldoyB7uhSXa0vLMBVNKmUf8vu3WQyXXQ0zwIlVUsPew9CxYMUfBMvE7VrNdNMzPIRsXTpscEn+BSbQwPZ2uKifVGCMr+l2+tBM5bluYc/x0ziy4A6lV7SbasSwAbTQsR7thH4yDhNLkMw1IQjVr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754536228; c=relaxed/simple;
	bh=nrN/WKRHHInr2RbhcbZ9vP8u1SI12TAyiL10R/cI0GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCBsSczyRjIrEprxmQTT16L+6sEdlaLL3ItkxgbxYYPlzJaHN7WBMPFLEkXymWpJvpBbBk+4b/DDlmqUswQqof9dqDbR3PZaw1V8pzmbaqewPEFTfBk6bAd8D/Y0qGNNjqDrCP4AtnnjjQfGoMvWLllOoQHEHf8aKtgbIA/p33o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=b+IHOxAY; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="b+IHOxAY"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b34a6d0c9a3so535964a12.3
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 20:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1754536225; x=1755141025; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gDbbzO/MBfCwa9anx+czvBO5imGoZ/RyUt5Cn2glgCY=;
        b=b+IHOxAYrbI/LIQ+9O8zBxkaMNtxCCCAR53n+QoLqV/C/bGVpWgWyhhMAzVIlZHZJ4
         5YRfyOYWA7VwhJKFwse8MdPpYORzgJZ75v/y6QvxuSpdKdf5aO4hFTLAQXBR5b/dzOfY
         4of4A4aPMWgDyqRF6FqZhmNd1964rdjSKtPFfr2i0ZptRHIkLnOxvmMnCSm0xl4C9y2a
         eh02RQ9e02Pqg0fcbK055X9dKpYCZkG2nIgn4vgmjKnroeX83dB2MKI61kHmaVLvCjZR
         tcWVtEqy/GmkEqE4CdEZvXAUnr8LmrNZnwgCq3qpIzflRGRB46PbsyF7wjdSimfUokfK
         fUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754536225; x=1755141025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDbbzO/MBfCwa9anx+czvBO5imGoZ/RyUt5Cn2glgCY=;
        b=W+wqJKOxBfWMRxhjnQH8GFrE3aG1gPPO3Xvbwtz50suaulASTHgi+E9VuzBC1gPm7d
         o44gRGO80QzzHbhcKzOok5aoyBA5qR2sJNHwgfNP2Szx2n7JlbBqLAwGYpSQNQAWezuE
         e4YiJFoES99URJk+pRm5qYfXvOuGRF2zLN2p6LAYi5c6nMhYv6P4Ee6Ldc9Owea+vyjp
         sB3CyBvFC/saY1j7vr+e3z2NtAu2Os7KQ0zyzX81/O8YozEt0obR6UC0lp34j0A41WK9
         +6t1D+UK34qqfTsgxRTBnU3a8PCCQLuVFkt5ka5tZ38fG8WdBR6+r1n5DylOh1F/IbNW
         Lfig==
X-Forwarded-Encrypted: i=1; AJvYcCWVBZZxyN4490zT+pDd+qj5kEM9yUhr7qGwO5Qzay5Eq+1hohcrqQ5Dq09768JYA5pbkDFLCpE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvOuDIfiOB1aMjXUV3g0bgc4bmdrRdPT7NrH3ZLIyrNdlQ1Nta
	bdBqtx5y45TK20wPzBIcGDwhfJGlzg6iai3h1OJaZNlYTvjsVy8S+/RBf2PMDAX2A8zO4pj7FUI
	2fyZgm2oo/AvJ710RsG26eSxvi1kTnstOI+fdvMEnwOyx5cJRZv0=
X-Gm-Gg: ASbGncuT6mka+phVQEDHnq12fdKP3uSwgveIWDeXthqEDZTLOo/A/korIj8HZla9/0f
	5gxThIBPgtV7lllTRX5Svp/hBFwGQUUdnBQuQpEWRQPr05zfMbvgkLEXBfc4+FjTFRxmOkrM3XO
	E2nw0/WuVI9L3itZ6eB9/TeHz0JBKjZR16+KeUjw4UjFKis9eu9Btn/xVOFW8BhS5DqvqcFOAC6
	DNANzPzlW+e3/1Kuu+87/92LHW0nXQFxQtU/dCr2Wg+2ng2M5O4PPDxPdMuwoHRsqpnSb5LxaRe
	FjzZ6bnfe+EfCCcOkfvVwX1GlOGcioEa4IfJ4tJ7e3vzoXx3biy7soM93KH40J8uRgR7oDIWrzG
	CnI6ztoCGfxRv5EpFyJujvmm89GJGVB3b1qgmEUfJ6AmpJUFVCvOLbHmQvnjeKQoFT51IrM4=
X-Google-Smtp-Source: AGHT+IFMVcRp6VR4IdWnWexUALKIuSPhb07wbduD4zm+PjHvxwvZ6x3aGSq9zjx5g1N+kmv/0FkZ2Q==
X-Received: by 2002:a17:902:e748:b0:242:9bca:863d with SMTP id d9443c01a7336-2429f59ce44mr64630105ad.55.1754536224661;
        Wed, 06 Aug 2025 20:10:24 -0700 (PDT)
Received: from zenbook (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3216126c96esm4081982a91.22.2025.08.06.20.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 20:10:23 -0700 (PDT)
Date: Thu, 7 Aug 2025 11:12:55 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Sebastian Ene <sebastianene@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: ptdump: Fix exec attribute printing
Message-ID: <yzl5a3r3vq42kbcsetdlmmtfaafzsyhcqzpfmlbhy3fqh4eylm@hocbkksrt2nj>
References: <20250802104021.3076621-1-r09922117@csie.ntu.edu.tw>
 <d72b7928-8646-4616-a8f0-96b9d9bbaf09@arm.com>
 <z2hmwwmtgbrio2wv3sj2pc4zhxdjioorlhnm45o2arcsjahjni@xod435q26jqq>
 <aJHBf4KCUPpWbyU5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJHBf4KCUPpWbyU5@google.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi all,

On Tue, Aug 05, 2025 at 08:31:59AM +0000, Sebastian Ene wrote:
> On Mon, Aug 04, 2025 at 08:41:35PM +0800, Wei-Lin Chang wrote:
> 
> Hi Wei-Lin,
> 
> > Hi Anshuman,
> > 
> > On Sun, Aug 03, 2025 at 07:33:04PM +0530, Anshuman Khandual wrote:
> > > 
> > > 
> > > On 02/08/25 4:10 PM, Wei-Lin Chang wrote:
> > > > Currently the guest stage-2 page table dump has the executable attribute
> > > > printed in reverse, showing "X" for a non-executable region and showing
> > > > " " for an executable one. This is caused by misjudgement of which
> > > > string gets printed for the executable and non-executable case. Fix it
> > > > by swapping the two strings.
> > > > 
> > > > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > > > ---
> > > >  arch/arm64/kvm/ptdump.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > > > index 098416d7e5c25..99fc13f1c11fb 100644
> > > > --- a/arch/arm64/kvm/ptdump.c
> > > > +++ b/arch/arm64/kvm/ptdump.c
> > > > @@ -44,8 +44,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
> > > >  	}, {
> > > >  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
> > > >  		.val	= PTE_VALID,
> > > > -		.set	= " ",
> > > > -		.clear	= "X",
> > > > +		.set	= "X",
> > > > +		.clear	= " ",
> > > >  	}, {
> > > >  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > >  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
> > > 
> > > Is not KVM_PTE_LEAF_ATTR_HI_S2_XN already in the reverse semantics aka
> > > XN (Execute Never). Hence when KVM_PTE_LEAF_ATTR_HI_S2_XN macro is set
> > > that means the entry is not executable and vice versa.
> > 
> > Yes you are correct. However in dump_prot() we have:
> > 
> > if ((st->current_prot & bits->mask) == bits->val)
> > 	s = bits->set;
> > else
> > 	s = bits->clear;
> > 
> > Analysis:
> > 
> > 1. region is executable:
> >     - st->current_prot == PTE_VALID (ignore other bits)
> >     - st->current_prot & bits->mask gets PTE_VALID
> >     - if condition is true (.val is PTE_VALID)
> >     - prints bits->set
> > 
> > 2. region is not executable:
> >     - st->current_prot == KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID
> >     - st->current_prot & bits->mask gets (KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID)
> >     - if condition is false
> >     - prints bits->clear
> > 
> > Therefore we want .set = "X", and .clear = " ".
> 
> 
> This seems correct but it will produce a different output than the
> stage-1 ptdump. What if we drop the PTE_VALID from the mask & value as
> Mark and Anshuman are suggesting and print NX when the bit is set and x
> otherwise as the stage-1 ptdump does ?
> 

Thank you all for the valuable feedback!
Yes, let me follow this and send a v2.

Thanks,
Wei-Lin Chang

> > 
> > Thanks,
> > Wei-Lin Chang
> 
> Thanks,
> Sebastian
