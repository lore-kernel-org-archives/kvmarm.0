Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF506C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 17:53:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7A74B268;
	Mon, 16 May 2022 13:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ZiXV7llu552; Mon, 16 May 2022 13:53:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155C74B242;
	Mon, 16 May 2022 13:53:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA1C4B225
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 13:53:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9sE4fEWm-8m for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 13:53:28 -0400 (EDT)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA2404B1FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 13:53:28 -0400 (EDT)
Received: by mail-pf1-f177.google.com with SMTP id bo5so14703469pfb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 10:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xLnsVtH4IZZzftneP0mNRPOYa6ozJDfyL03w/I93FrE=;
 b=UmOjKYmNbbv2ZgPZOnanqKT3eODwwjPFhlGVD2Fl62+7VYXsBsL1kDTCNFsAnfIiif
 74EPi85SE0XeXotOMQ65be7GEzHKtmvZ7ZPf8eo4nZIO+U4QdY3O06aFDL2hGu8GVB/b
 hnwgkIJ2mp0Ex0P7BTkkgqFihDJ30MSFa5iuz+szd+++x0Fq8A/754L0B3EVRcQzfekw
 d0zMtehFrx7JiV/53hZXtrQq3nB0aMD/W5OjbzWzcYAL6vUfR7PIxpgiBY2x3CKdqXFv
 OithX7c4YgzfHCZySNbi9o33X1iIDUA0Y/IuLsXiRFGOYzWpjjgpmDnDTr7LY8ttlTvs
 rUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xLnsVtH4IZZzftneP0mNRPOYa6ozJDfyL03w/I93FrE=;
 b=ttdMI6QAG2/8OknmN5sGq0L9rOeW4ANun0XAx8XjqdLU65x8wbv84qz78Mu3axYR0H
 jHlr02q6ad02pksNQEraiSJGkL3IKBNH2etIDSZzetMYYeQynKsZlhMgfENJoDrSMmG9
 juNl/vhMQGXvzUm7BUozkf5woIc4ye8DVIGoaQCLklJFRIvimbB07MNJNkIxTyFPChpg
 IJ/KSgJ58iXN27sTFwvoSStm1vdUKxt/GIkFxeGy8cxkvfggyMAh7ulvFVcgXpr7VUCh
 hc0Jw9aI4ssHBfn1sCBi3vhFRwR5LgGWIA4c9PC5xcw3DUC9KgsRnqzQWCcqHCLIeqN0
 Swqg==
X-Gm-Message-State: AOAM530T8QmFYDqxRNuuskgugANgJAAVQuHZOHs9THMtiazUmOlELgGZ
 7ZiQ16ELJX/ZhIID/eH/PnrcLw==
X-Google-Smtp-Source: ABdhPJz+yvMx9liLrlz0QvwDhwSjd9tJARB/+WSjj0oadYZP/ffLyfTHTcZm4wo51GQdKL9Zfl9FbQ==
X-Received: by 2002:a62:1613:0:b0:510:82a9:e3bf with SMTP id
 19-20020a621613000000b0051082a9e3bfmr18551283pfw.23.1652723607193; 
 Mon, 16 May 2022 10:53:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 h3-20020a170902b94300b0016178a7375csm2727975pls.197.2022.05.16.10.53.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 May 2022 10:53:26 -0700 (PDT)
Date: Mon, 16 May 2022 17:53:23 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YoKPk0HBl/7rXmNS@google.com>
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
 <YoJkb7oMEz0v1dnp@google.com>
 <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> On Mon, May 16, 2022 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, May 13, 2022, David Matlack wrote:
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 53ae2c0640bc..2f2ef6b60ff4 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > >  {
> > >       phys_addr_t addr;
> > >       int ret = 0;
> > > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > > +     struct kvm_mmu_memory_cache cache = {
> > > +             .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > > +             .gfp_zero = __GFP_ZERO,
> >
> > I dislike requiring all users to specificy the capacity.  It largely defeats the
> > purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
> > really doesn't care all that much about the details.
> >
> > Rather than force the capacity to be set before topup, what about adding a custom
> > capacity topup helper?  That allows keeping a default capacity, better documents
> > the caches that are special, and provides an opportunity to sanity check that the
> > capacity isn't incorrectly changed by the user.
> 
> Even simpler: If mc->capacity is 0 in topup, set it to
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.

I slightly prefer the explicit "custom" approach as it guards against topup being
called before the capacity is initialized, and against the capacity being changed
after the first topup call.  It's a somewhat contrived reason since we obviously
rely on gfp_zero to be initialized before topup, but I like being more explicit
nonetheless.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
