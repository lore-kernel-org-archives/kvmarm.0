Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C6AC43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 11:22:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F16022204
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 11:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="bf7Fr4Il"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F16022204
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E87D4B340;
	Fri, 11 Sep 2020 07:22:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yuN2zFEO0TWO; Fri, 11 Sep 2020 07:22:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C994B2DF;
	Fri, 11 Sep 2020 07:22:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA204B2FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 07:22:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyZwtpwGlErL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 07:22:23 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A2254B1D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 07:22:23 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id c18so11094695wrm.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 04:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=H1IxEJr/rhfpTY600x4CJzot8Ff+PdP36izF7fvGDYg=;
 b=bf7Fr4IlFvxub+wXKnZaoBFyABUBR6RMH0my+LBPBqdBNMdCug2zKPV3CWKw2K6Gtu
 6P0DScaMEqWyopqYWDHg9FR5mk7Bd+hhXMbkqI9NfsHBiAEBHPhaUKoFSrnlHJtSzaoi
 THXp77FJLnPmRg+ubt68nFivM6bLZ3UYxHREDAHpT9t7edM8mQmXhqRgiqdeKMJ7SnBu
 mGPs24KAsmJXKBYJEJ4zb8e8jdZZhmIgUmCcKL8ycE5UW5VjGMAPbqhpK05/Wr3HU7BG
 XVkVFvE4lwDt4KdsPDGaSTF5Jv0IlObSwcfx6LIOxJElUBLQNpu0rxNnl20c6SfHQLJr
 cxGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=H1IxEJr/rhfpTY600x4CJzot8Ff+PdP36izF7fvGDYg=;
 b=uHwmeKYXYbBjUqHz1UoLpkRhWUmGT3/BBgTKZapJ/x3/zlLHpU6v0hQB/V3X7HadlU
 0hIN4e/3msX4dgXEMzwivczsrqZCmJ39E2/lE/altvqhdcmt/9bTq9a+KJZskztaMxFJ
 vKZO4zf3eKAGVpCLS97/KE/FR0wcIn/lXmfKC8hQI170K/jA17V2jw5XXAe3lpPCIWrF
 JdSqGodDeR4ObbOyrySH9+Xd+9zW/zVFiEmaodP97YbngTkFZKbUfFF40hi9A3KUNs7k
 BewiiIpSYxDWJCdOmR5Gxh5R7FU7RFKa41dMOCYzOIOcHfPVr9yoS36DTfr4TvXOOpbL
 6VqQ==
X-Gm-Message-State: AOAM5332lH04Dk491948yV7w7lHto5ukhWNTclWLdmcgAftTdB19QoVH
 yePABiNft/iwIV/KxOCnLK2YxA==
X-Google-Smtp-Source: ABdhPJznIisWYKGS1y/EM33QtiXjUNu9sMZgqw0aGQm0o6A+E6apSM8xoKdLCTR9CxTJFreRN6bbEg==
X-Received: by 2002:a05:6000:1152:: with SMTP id
 d18mr1576235wrx.173.1599823342183; 
 Fri, 11 Sep 2020 04:22:22 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id d190sm3664811wmd.23.2020.09.11.04.22.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 11 Sep 2020 04:22:21 -0700 (PDT)
Date: Fri, 11 Sep 2020 12:22:16 +0100
From: Andrew Scull <ascull@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200911112216.GB2242370@google.com>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-3-will@kernel.org>
 <4ef01cff-71ac-7f3c-2404-af184f5a5cb4@arm.com>
 <20200910123712.GB18100@willie-the-truck>
 <20200910142159.GF93664@google.com>
 <20200911101504.GA19326@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200911101504.GA19326@willie-the-truck>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Sep 11, 2020 at 11:15:04AM +0100, Will Deacon wrote:
> On Thu, Sep 10, 2020 at 03:21:59PM +0100, Andrew Scull wrote:
> > On Thu, Sep 10, 2020 at 01:37:13PM +0100, Will Deacon wrote:
> > > On Wed, Sep 09, 2020 at 04:29:26PM +0100, Alexandru Elisei wrote:
> > > > On 9/7/20 4:23 PM, Will Deacon wrote:
> > > > > [..]
> > > > > +
> > > > > +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > > > +		     struct kvm_pgtable_walker *walker)
> > > > > +{
> > > > > +	struct kvm_pgtable_walk_data walk_data = {
> > > > > +		.pgt	= pgt,
> > > > > +		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> > > > > +		.end	= PAGE_ALIGN(walk_data.addr + size),
> > > > > +		.walker	= walker,
> > > > > +	};
> > > > 
> > > > If the caller wants to walk [0x500, 0x1500), for PAGE_SIZE = 0x1000 (4K), the
> > > > function walks the range [0x0, 0x1000). Is that intentional?
> > > 
> > > Yes, although the caller specifies a base and a *size*, rather than an end
> > > address. As a concrete example, much of the hypervisor stage-1 mapping
> > > is created using PAGE_SIZE mappings of random ELF symbols, which correspond
> > > to arbitrary addresses. In these cases, we really do want to round-down the
> > > address and perform a PAGE_SIZE mapping.
> > 
> > I think Alexandru has a point here. Turning his example into something
> > equivalent that maps a random ELF symbol:
> > 
> >     struct some_hyp_state s = { ... };
> >     // &s == 0x500
> >     // sizeof(s) == PAGE_SIZE
> >     kvm_pgtable_walk(&s, sizeof(s), walker);
> > 
> > Given `s` straddles the two pages, the part in the second page won't be
> > mapped.
> > 
> > Should the end address instead be calculated as:
> > 
> >    .end = PAGE_ALIGN(addr + size),
> 
> Cheers for the example, and I see what you mean about structures that
> straddle a page boundary. However, I think it's important here that the size
> parameter accurately reflects the number of pages mapped: if the caller
> passes PAGE_SIZE, we better not map more than a page, since the mmu cache
> might not have enough pre-allocated pages for that.
> 
> So the API is just that the virtual address bits corresponding to the offset
> within a page are ignored. Looking back at the code, that works out for the
> hyp mappings (it's actually the _physical_ address that is unaligned there,
> and we can just round that down), but I think I have a potential bug in the
> ioremap code if you place the GIC (v2) somewhere funky on a machine using
> 64k pages. In this case, the ioctl() handler only enforces 4k alignment,
> and so we could end up truncating the mapping in a similar case to what you
> describe above. For example, trying to place it from 60k - 68k would result
> in only the first page getting mapped.
> 
> I've fixed that in the ioremap code (diff below), and I'll update the
> kerneldoc to say that the bottom bits of the VA are ignored.

You've described kvm_pgtable_walk as taking a start page and page count
so an alternative to the comment could be defining function to reflect
that e.g.

    int kvm_pgtable_walk(struct kvm_pgtable *pgt, gfn_t start,
    			 size_t count, kvm_pgtable_walker *walker);

Up to you.

> 
> Cheers,
> 
> Will
> 
> --->8
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1041be1fafe4..21b70abf65a7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -505,6 +505,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                                      KVM_PGTABLE_PROT_R |
>                                      (writable ? KVM_PGTABLE_PROT_W : 0);
>  
> +       size += offset_in_page(guest_ipa);
> +       guest_ipa &= PAGE_MASK;
> +
>         for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
>                 ret = kvm_mmu_topup_memory_cache(&cache,
>                                                  kvm_mmu_cache_min_pages(kvm));
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
