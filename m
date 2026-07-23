Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BF40DB55
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 09:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784797951; cv=none; b=Bna4hAq4HkU/VA97/hf/4oi/d01teGs87YbYRCz+IYmpY+69SHQ4A7Do5RHgESQMOg5gI9al6S1dELYqqMPXR/ernyJOwgRvt5KKc7dmKZt9HSFVq2ALqJYov86ORqRf4YPjw74nMtH3Y4WWGXdLomv3G6RkGuaril9A3v7p4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784797951; c=relaxed/simple;
	bh=SeySzopu6zMdMFdr8ib7wTjP/BqXY8mZxlRcXGTOvNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vv5+mca0NIE5X2ZXtz9ucSoNnMNU9kz9xOLeFZiUtfQrcb5b4PXUclEjZGRhMwodFuUOI/OLwIBeo21KLxVCgTBGqSjlQ6EB+7SSNMrLoai971NKkePovoU3PchAtwwDVoaoag9OsIUZWjVBJ6+7RYAF3fwmzaZvBez2cghSZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LVeMXjEs; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LVeMXjEs"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so40635e9.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 02:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784797948; x=1785402748; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L/eQ6xVtZwAc2g+MA5ARGSiX1QKgpSyLscWz0B+I2Ks=;
        b=LVeMXjEsEu8LCzkifqkX0yeFX5OByxS1fS7G80HNx5UrxuT4vFhMOWF8N/VytIAMRK
         fWt/5oQ6LuJ4iqd/hrNpfw4XoSDJ/v3L3/E2CbhCMTP1BvWBWwu7y4a6JsTW3QnKB9E9
         NAQbEr2DpDo4gvBK+5WZc66ouNaTio1bKJdT4gCjdL6CCQ0WclsObQWs+fgCFOYe9H9G
         QZ7Zp8YxnPx5ZvV7L5Yl6eexklCH69M2zSAmTDbifDGJuMq9B57ccltrxwKra3iypqkp
         GeEVpQp+THyXePdUPMoghW/BTkS5OKYfTUeqHFNGDBkf9ixFKV/qnO1oNtpuVlsxe0aW
         BhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784797948; x=1785402748;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/eQ6xVtZwAc2g+MA5ARGSiX1QKgpSyLscWz0B+I2Ks=;
        b=McbikSDnoGHDAgGH0u1VsUKjOL/4ufuiX0ygqiEbXKC8fSQ4PqKoQPGmrFnlsGeQvK
         8ywPPktcyKGTVaB601kY9vn3Mh65ITz1mXfXtyLntVLTaStdXVZeRI4Sae7CMvjPtlCq
         wk2K+Ofy+orlxvu18JS5rdFue+tjSK63aLuEqbykIXFJ6Hl+LWW+ocvRyA1b+NG2GTib
         fkEZ1O81kr0SxfL7/G/3DB3ToOFYTzgMrOMsRTfi6/qBnYFDMaivLZuYwFPYnVW2iMO5
         bCxnDZihP8IM2/XzZYqeDbYmKZydSJJ31ya7LrOBs5sm6TQfhNtYQTjV9S1+3hHswsUu
         SKug==
X-Forwarded-Encrypted: i=1; AHgh+RpLg5Gtt3n9TONghXtUa6SsKus2C/2Oi7XwVp8MRRxq+ibhKT8HuVBrdZPNxSs4FRgRt0ZtetA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx53iT1UrMmpT0+Kl810ne3eYPvjEcnRRH8tsT5gEb16hm2RTIp
	TxZGa1UDektjUlM0vNwQQXZeE84i1tJmLGy3sM5lRYt+iZl7qSQ063zhsfxdUT657wh3OgMDGh6
	YixnwYw==
X-Gm-Gg: AR+sD11zBcxzG9x6zj4EY8kvi1eCkyp5a8wxmN1zUK+t6UcwriascxnVTF1DyKA+ykl
	hAaK+lpaZfAqqGulmmhzDaixgBtEMHDXm26ox32vYd+pHOZxnrV/Xvvq1nGrztvZJzsKqNhjRbc
	Cv4PJ6v4e2uNnxXwdhSvgiSldRRd0BTP4BjU/MOU/ME9yAVBfkBFGdtRCwMHJDX+FuA8Bixi8PM
	B5oYfZ3jY5e54Vo8qplsxW4OI7NxN7YZDes6euWRQgiCNLviI/FCpuGjfwszQuHfRG8K1bWmRlM
	zPTeaqc+d0RBR8JLJa+uYQz10hoCg3GOofFoNVtkzFitBNeSKQMJez6XSD9EQeZFR4MFkcX6R4l
	qMpHHejydwYPbWDl/WyNBUxn26T9zKYgA73Te9Ip8A5+QIQMvy7Zbqssx1A5ZJ/JhxdwMeLnvJ3
	7jOx8kxCEIC56uvz9j7NIM3HsW2PxW6VI5VyoypQ==
X-Received: by 2002:a7b:cc96:0:b0:493:aca0:32e2 with SMTP id 5b1f17b1804b1-49573865b4dmr866465e9.4.1784797947324;
        Thu, 23 Jul 2026 02:12:27 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a5d9sm13122369f8f.5.2026.07.23.02.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:12:25 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:12:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com,
	sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v2] KVM: arm64: Optimize protected mode and FWB
Message-ID: <amHa9P8FwqTqVgs4@google.com>
References: <20260721085646.1660673-1-smostafa@google.com>
 <86y0f4ejr4.wl-maz@kernel.org>
 <al9HqhO6sp3FFbtQ@google.com>
 <CA+EHjTwp6gQDjL5uE+aAJ04yRnPgvABgBaBWe44hyVSMXGQP9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwp6gQDjL5uE+aAJ04yRnPgvABgBaBWe44hyVSMXGQP9w@mail.gmail.com>

On Wed, Jul 22, 2026 at 12:51:35PM +0100, Fuad Tabba wrote:
> On Tue, 21 Jul 2026 at 11:19, Mostafa Saleh <smostafa@google.com> wrote:
> >
> > On Tue, Jul 21, 2026 at 11:10:07AM +0100, Marc Zyngier wrote:
> > > On Tue, 21 Jul 2026 09:56:45 +0100,
> > > Mostafa Saleh <smostafa@google.com> wrote:
> > > >
> > > > KVM opportunistically enables FWB if supported by the system for guest
> > > > VMs, which allows it to elude cache maintenance for data as they are
> > > > forced to be cacheable from stage-2.
> > > > In that case, __clean_dcache_guest_page() will immediately return.
> > > > However in protected mode, before calling __clean_dcache_guest_page()
> > > > it loops over the range and fix_map/unmap it, issuing TLB
> > > > invalidations, dsb() and isb() unnecessarily.
> > > >
> > > > This can be optimized by returning early if FWB is supported,
> > > > kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
> > > > functions issue dsb() for the unmap path.
> > > >
> > > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > index 4e329e39a695..049a09be2bbf 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > > @@ -261,6 +261,13 @@ static void __apply_guest_page(void *va, size_t size,
> > > >
> > > >  static void clean_dcache_guest_page(void *va, size_t size)
> > > >  {
> > > > +   /*
> > > > +    * Guest stage-2 uses FWB if available, making it safe to elide CMOs.
> > > > +    * In contrast, the host stage-2 never has FWB enabled.
> > >
> > > Beeeeeeep!!! Since a373930ec9406 ("KVM: arm64: Switch pKVM host S2
> > > over to KVM_PGTABLE_S2_AS_S1"), FWB is enabled everywhere when
> > > available.
> > >
> > > Not sure that changes anything, but the comment is factually wrong.
> >
> > Ah, I see it uses KVM_PGTABLE_S2_AS_S1 in that case, that should not
> > change the patch, I will need to update the comment.
> 
> Sorry, this confusing is partially my fault. The original comment in v1
> 
> >  /* See __clean_dcache_guest_page() */
> 
> wasn't very clear to me, since I wasn't sure what I was looking for in
> __clean_dcache_guest_page(). Talking to Mostafa in person, he's
> referring to the comment _inside_ __clean_dcache_guest_page. I think
> the best fix is to rephase as
> 
> +  /* See comment in __clean_dcache_guest_page() */
> 
> This would save duplication and having to repeat the comment.
> 

Makes sense, also thinking about this, I think we should do the
same for invalidate_icache_guest_page() and ARM64_HAS_CACHE_DIC.

I can include that in the same patch.

Thanks,
Mostafa

