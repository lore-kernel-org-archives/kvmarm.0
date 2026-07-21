Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC623BB661
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784622907; cv=none; b=ePPgU0RNToyraPlrM1S6Rpx1UlpbAqPGsF5Nl+LhPGPFAYWb3ojcgWPwlPWRb9hhmm49vy3iz0pnnyybqG9UIpC+w1J04RByHwcQO1XC904w4lTUIZLzmqz9LGi/c0OtGve3XmNmZUDdKoKEZG1MD9/sjAQJqxSSXiGk8eGkZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784622907; c=relaxed/simple;
	bh=F0cfbFUsRhmHhxjCN728v5wWb0l+lu6WWGL6CA+e7AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgtgvkTISBGfwXJ0DNwbZ2fQo8rhx2EzwcgVZvMuZNcKVBA6KRi6qk1K8J0+l06vs3eAWuEapEf3G+SQhCBoNiQkmY/z4Nba5pF9Qt/WSHGFHtU8/8f4ANLzi/4m1iMJCvfz2FFv155Y4E27zRF8iA6llfnEcDDZqhbnVDqW0qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ni9G45E1; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ni9G45E1"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493be0fbcc5so204565e9.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 01:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784622904; x=1785227704; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/cuwD88UjU46NkDV8CZP70BiMvjpg3xf5O50MzNPfDY=;
        b=Ni9G45E1qKlU4T4wZ5BoFwC3tjTpJXSNa8qCpgfqFUcgyZrQunCCkKwBdEd9cybYs/
         MuNx0HvkjJu2t9KFFlzkwByFUarUNC1mFszswL57L2mfIOcXsTNvpdzj97sQEP6B9iA+
         BVm1i+1Q2MsDyxzuXSe8Jw5kGQ3TbckL5cq9TyOr9PLRmXSAK77rFZ1d0yaaZF4aL9+w
         C0JK7dywzztxhm97nQSJ9qorDHW5PJaoPpOLpvlAYhRoPobo2SBE6DoP3CsKLgWkTJ3j
         5Mc+HsZlPeMe1dKQjt4WFroHx2cAXr6ukUDue7u1aJ5eswGpmOdgLuQmYm0lRtbgvRvd
         1Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784622904; x=1785227704;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/cuwD88UjU46NkDV8CZP70BiMvjpg3xf5O50MzNPfDY=;
        b=RbMTj9rIrCh/Yco88kxqCPPBeq13ygxVQnul9eMFAg3B3PhPi5oKUsrMUzUmlVICXW
         b5zXbbNZPOFvLVSX1rq7L4cCQGQx8rG/iQvSkbrmt8pCzmbVp4nyRid6veukIXbhVkeo
         +LXMAPF259qAc8/5JqxQ6+17M9yRHz/Sv0N7KizaC0jTZXaPXIfnthm4FBTWi8N3X3Ul
         yHB2zFragKDldJ+Dzawr5mtNK3Zs+x4gw/qFAnz8xNQajV4GPAiP8n9vGuKagqlo5cxb
         tbq8L+pVJdqtdB607/Tuhj6Tm/ZxxSa8bl8LvOwCTRee9ie1SX6Z5u/NiKbQOTTgFBzy
         0kjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rol5T82C/oZouMMMkbEEv9y4vaM9MCmZz/faJL0KZAROzJ5vnE5SH0amPf1PVdOnumGmn3WKdo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyXK6dPqRXDFI3Mb9yHj9n1zkRNZJjV2ACCWA8eIgCFddN+iky
	jTs6gV0xDLSiaEE2q53tqqYqIg2DXWBFBejJOqUWGtANKHjPEroOlvrh3lK5z8eQHg==
X-Gm-Gg: AfdE7cklqI7KvC8RtsXlWw1Tq36bewZMd6kaRc/mxo37rxX1zNS5BIckeFcv4fvgf51
	ZESFgQr59QeZgI1NTX3zU1USsWBLBp7JMg/3yng8eVv7bcAuT444eWwZf2qCEKan4VWPPtvlbvA
	2L36Ehc+b04uz0itVYfbmDOWaIPUIFeOHHyDDagL1HcRmW4xtt8oxxXQtE74X4tdLvidCwkzviE
	L5UrROevF9jxi2upjtikWvHBTccmS7AIGyMyWRu2UtAqxaCaJ4XyPM8SGSKeoZyMBPrCJDKl6O/
	TjooBXg5C3+qtU+O1TOG5C9NcM2p549RQC2OGf+BZkqAH1UwEANC9N7F+RofYnqavn2gCRi5H5b
	uPF+co01/lhYeB7r2iClVwKWHDhoHIq/ApEfaPzuRwfQCrvHGTcmGsoszNnmhGaY1RGSURQ3Abq
	huzBrXpOLm3TB6OJnMeG7ZoTo0BDTa2CkXzHc4y8V7hIMManRc
X-Received: by 2002:a05:600d:8498:10b0:48a:5618:b4d4 with SMTP id 5b1f17b1804b1-4956435334cmr1374105e9.1.1784622903180;
        Tue, 21 Jul 2026 01:35:03 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49563e4573bsm59467485e9.0.2026.07.21.01.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 01:34:59 -0700 (PDT)
Date: Tue, 21 Jul 2026 08:34:52 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	vdonnefort@google.com, tabba@google.com
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Message-ID: <al8vLJfY4seh4d5n@google.com>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
 <alqW49CH7eViDpAZ@kernel.org>
 <alvaEgJFJ5DaQaac@google.com>
 <CAFgf54r0xYwUGgPMY=1aTRzcqX7jKp545Jb+p_yFW=JwAX0E4g@mail.gmail.com>
 <8633xcg87z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8633xcg87z.wl-maz@kernel.org>

On Tue, Jul 21, 2026 at 07:36:16AM +0100, Marc Zyngier wrote:
> On Mon, 20 Jul 2026 21:41:04 +0100,
> Mostafa Saleh <smostafa@google.com> wrote:
> > 
> > On Sat, Jul 18, 2026 at 8:55 PM Mostafa Saleh <smostafa@google.com> wrote:
> > >
> > > Hi Oliver,
> > >
> > > On Fri, Jul 17, 2026 at 01:56:03PM -0700, Oliver Upton wrote:
> > > > Hi Mostafa,
> > > >
> > > > On Fri, Jul 17, 2026 at 01:09:00PM +0000, Mostafa Saleh wrote:
> > > > > If the system supports hardware Break-Before-Make (BBM) level 3, use it
> > > > > to replace stage-2 PTEs directly instead of falling back to the software
> > > > > break-before-make sequence.
> > > > >
> > > > > 1) Get a reference count on the containing table for the new PTE.
> > > > > 2) Atomically update the PTE with the new valid descriptor.
> > > > > 3) Invalidate the TLB for the old PTE.
> > > > > 4) Drop the reference count holding the old PTE.
> > > > >
> > > > > One interesting case, as BBML3 will update the PTE atomically, it
> > > > > can only know it raced with another core at the point of the cmpxchg
> > > > > failing, unlike the SW implementation which locks the PTE first.
> > > > > And as we must issue CMOs to the new mapped page before the update,
> > > > > that means with BBML3 racing cores will issue redundant CMOs,
> > > >
> > > > I'd rather we just predicate BBML3-style transformations on an
> > > > implementation having FEAT_S2FWB and DIC. You can definitely come along
> > > > later and enable it when using a stage-2 in an SMMU makes this
> > > > mandatory, possibly at the expense of some extra CMOs.
> > >
> > > Makes sense, I will do that in v2.
> > >
> > 
> > Looking into this, I see some existing inefficiencies (or maybe I do
> > not understand it well)
> > - pKVM still do some work for dcache with FWB I posted a patch for that:
> > https://lore.kernel.org/all/20260720203529.1276355-1-smostafa@google.com/
> > 
> > - KVM does not elide the icache maintainence with DIC, it seems we
> > should have something similar for the FWB check in
> > __clean_dcache_guest_page() as
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 6eae7e7e2a68..d0a4ae66b069 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -247,6 +247,9 @@ static inline size_t __invalidate_icache_max_range(void)
> > 
> >  static inline void __invalidate_icache_guest_page(void *va, size_t size)
> >  {
> > +       if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> > +               return;
> > +
> >         /*
> >          * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
> >          * invalidation range exceeds our arbitrary limit on invadations by
> > 
> > or I am missing something?
> 
> The latter. The shortcuts are in the individual helpers.
> We have:
> 
> 	static __always_inline void icache_inval_all_pou(void)
> 	{
> 		if (alternative_has_cap_unlikely(ARM64_HAS_CACHE_DIC))
> 			return;
> 
> 		asm("ic	ialluis");
> 		dsb(ish);
> 	}
> 
> and
> 
> 	SYM_FUNC_START(icache_inval_pou)
> 	alternative_if ARM64_HAS_CACHE_DIC
>         	isb
>         	ret
> 	alternative_else_nop_endif
> 
>         	invalidate_icache_by_line x0, x1, x2, x3
> 	        ret
> 	SYM_FUNC_END(icache_inval_pou)
> 
> it's not completely obvious to me why we have an ISB in
> icache_inval_pou(), but at least the invalidation elision is already
> there.

Ah, sorry about the noise! That’s why I shouldn't send late emails :)

I am not sure why the isb is needed, at least for KVM it should be
OK, besides that kexec uses it.

Thanks,
Mostafa

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
