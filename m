Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F885C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 01:03:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82F8C4B24F;
	Tue, 12 Apr 2022 21:03:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gFvDI5Ot-LVt; Tue, 12 Apr 2022 21:02:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E96AC4B1F2;
	Tue, 12 Apr 2022 21:02:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 050194B1C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 21:02:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GdIPaWxe5XhA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 21:02:56 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A54374B19D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 21:02:56 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id 12so547813pll.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 18:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KpI1kD5PS40ibZjM0D35TPH/+b7l2YUJ66VT/gr7+3I=;
 b=WvEr5jNVtGCO3BZPBqZt3WRaH+qJWPUJ+rs93IIEG+K2bJ3Wt/blAxXxD+jg+m5RUd
 TKEh9acGqoMAwNFo/iZwvIT5HN4JBY8N+7CjG7PADEvLKuwA8OkFZizB3FEZf7bSUB9c
 pDy6TeJW1lmjYQVuQgzprHZjF33F23Uxgf7eet+9mnWnnNU+07ay7Xt0N2XugKQicXBn
 0oRF6f4P7vgwCQUFUaISNiAsixKYit0+u3RnL3LPTCuqshubEKBTALKRCw1KW2xXv6q5
 MOcm9G3pHpI14zHTQSGUsvZX7EdvBv3Jtt+s0+q/WG6iUlZy5LWzj1/478x87JFi9F3b
 S0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KpI1kD5PS40ibZjM0D35TPH/+b7l2YUJ66VT/gr7+3I=;
 b=24ntEG2pMR1lyODua+Mm/nbdx4xTrD7i49SkdEbK15wO3cWNpAM649HiFXnAikpnp8
 ZAB4BCwo6SlnjXB8swlqCSI69lgcgcoYCrRSQC14CJIXDsUxAI+YdrzdDbqNE0JQhqic
 3IhghXtXGK2KA1SqRafyTEE4/E6Mf+JncfNJBDz+JrD03KShPV30e0O/l5sR/GCqwE1o
 FGGG7QXJwPutKt2QD+Ko7uhvMCRlfV9vFStHW3mSpbxtk/Z1MfGFTipX9k7jef6jKkVK
 aWPHJVMQy2TVrJE92b+tSPBw6JDJk6m/IyOsaTnwTELiGapxCW4AOMz1aqo1kNmNi36+
 cGCw==
X-Gm-Message-State: AOAM533BJgEnuEbZtlc9GYDw2wgyN+qAloRN6cyHodt74v80TDpsiSt+
 1gaCAhiP9IvVX7HHHfClMxrIMA==
X-Google-Smtp-Source: ABdhPJxqWTBWdRVUHoEHytrydpTb+wgHLkf9yECQ7JPXA9VzNZCYKDHBFO/AL7hpNzLdXs6Wd+6Akw==
X-Received: by 2002:a17:90a:a509:b0:1ca:c48e:a795 with SMTP id
 a9-20020a17090aa50900b001cac48ea795mr7872866pjq.165.1649811775498; 
 Tue, 12 Apr 2022 18:02:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 h19-20020a632113000000b0039d9c5be7c8sm3135296pgh.21.2022.04.12.18.02.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 18:02:54 -0700 (PDT)
Date: Wed, 13 Apr 2022 01:02:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlYhO7GvjKY1cwHr@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Tue, Apr 12, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Apr 11, 2022, David Matlack wrote:
> > >
> > > One thing that would be helpful is if you can explain in a bit more
> > > specifically what you'd like to see. Part of the reason why I prefer
> > > to sequence your proposal after eager page splitting is that I do not
> > > fully understand what you're proposing, and how complex it would be.
> > > e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> > > for nested MMUs does not sound like less churn.
> >
> > Oh, it's most definitely not less code, and probably more churn.  But, it's churn
> > that pushes us in a more favorable direction and that is desirable long term.  I
> > don't mind churning code, but I want the churn to make future life easier, not
> > harder.  Details below.
> 
> Of course. Let's make sure we're on the same page about what churn
> introduced by this series will make future life harder that we hope to
> avoid. If I understand you correctly, it's the following 2 changes:
> 
>  (a.) Using separate functions to allocate SPs and initialize SPs.
>  (b.) Separating kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page().
> 
> (a.) stems from the fact that SP allocation during eager page
> splitting is made directly rather than through kvm_mmu_memory_caches,
> which was what you pushed for in the TDP MMU implementation. We could
> instead use kvm_mmu_memory_caches for the shadow MMU eager page

...

> So even if we did everything you proposed (which seems like an awful
> lot just to avoid __kvm_mmu_find_shadow_page()), there's a chance we
> would still end up with the exact same code. i.e.
> kvm_mmu_nested_tdp_find_sp() would be implemented by calling
> __kvm_mmu_find_shadow_page(), because it would be a waste to
> re-implement an almost identical function?

I went far enough down this path to know that my idea isn't completely awful,
and wouldn't actually need to fork FNAME(page_fault) at this time, but sadly I
still dislike the end result.

Your assessment that the we'd still end up with very similar (if not quite exact)
code is spot on.  Ditto for your other assertion in (a) about using the caches.

My vote for this series is to go the cache route, e.g. wrap kvm_mmu_memory_caches
in a struct and pass that into kvm_mmu_get_page().  I still think it was the right
call to ignore the caches for the TDP MMU, it gives the TDP MMU more flexibility
and it was trivial to bypass the caches since the TDP MMU was doing its own thing
anyways.

But for the shadow MMU, IMO the cons outweigh the pros.  E.g. in addition to
ending up with two similar but subtly different "get page" flows, passing around
"struct kvm_mmu_page **spp" is a bit unpleasant.  Ditto for having a partially
initialized kvm_mmu_page.  The split code also ends up in a wierd state where it
uses the caches for the pte_list, but not the other allocations.

There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
for the split case and assert that @vcpu is non-null since all of the children
should be direct.

		if (sp->unsync) {
			if (WARN_ON_ONCE(!vcpu)) {
				kvm_mmu_prepare_zap_page(kvm, sp,
							 &invalid_list);
				continue;
			}

			/*
			 * The page is good, but is stale.  kvm_sync_page does
			 * get the latest guest state, but (unlike mmu_unsync_children)
			 * it doesn't write-protect the page or mark it synchronized!
			 * This way the validity of the mapping is ensured, but the
			 * overhead of write protection is not incurred until the
			 * guest invalidates the TLB mapping.  This allows multiple
			 * SPs for a single gfn to be unsync.
			 *
			 * If the sync fails, the page is zapped.  If so, break
			 * in order to rebuild it.
			 */
			if (!kvm_sync_page(vcpu, sp, &invalid_list))
				break;

			WARN_ON(!list_empty(&invalid_list));
			kvm_flush_remote_tlbs(kvm);
		}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
