Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86238C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 10:42:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E50E4B21A;
	Thu, 14 Apr 2022 06:42:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kal8G2nqgSr2; Thu, 14 Apr 2022 06:42:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5604B26D;
	Thu, 14 Apr 2022 06:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 156D44A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:58:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1H41BDNj46VM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 13:57:58 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D349349F1C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:57:58 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id s8so2639649pfk.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=lKms+iLPtRUk5y/Weofi/PdQuKMWfU/nQ1UEwvdazkA=;
 b=VI7NuhMtE5n6hcf5o1lr6t8ZOQB244gh3vPkDR8/4kX00bX5l/+t/BORMexz0C9Bes
 3/+VhI2JSDj1pSNs/rZcBt0kNZ98jay4OW7PQUswSDsPYsmnplbhDAHnhd9ccPcL6HA2
 bmQOUc2THBOrC9SUGbSR2lqw2odxZDJZBefY1TRssGH1I4LZ8vvR6ruCc7lvPL5RlvII
 LTAGGfs1JLlpoJv12ISZimfV9ZbLvQbvTrNZ4H1zfbHsUo8c/G1DqsWrHyTwkajk0J0G
 iIIowf/+Gcy5EtdtVbGaFH9naZWCoETckHHj0fmkmEmVfd0vxoBEUQ+/kc+iYioZP19n
 /ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lKms+iLPtRUk5y/Weofi/PdQuKMWfU/nQ1UEwvdazkA=;
 b=t488ne/4NLm8zFiNmTcjhzuPYBcjP+Lm7BdotjKPhbLplfpX7AN7I82EUu5a1O45GU
 DUjXiBrYzSaN4jyXZJCFUJlkiIXEG46Kjk0lv0A5kZKO9iX8zcQQP5uXQkORIKH5ut3O
 qJt7KsI99fN1L78YwJBGOOMv7/AEmdGyT5YtcaCO9OoVk7zO0UyVPRLYeCNzZJ/PRcbS
 mApg4wWR/uKvF0aiAYN2se9YNLxF6fFDGmmX+MOiUDfe3Uu7JdXDxWuFYUoTG4jhOg78
 xFWQdCK1rGa3l8rt+Z6RtPhFHLURt1vafydt5ZaBlsc/P/1awvLEvbts4xiXuF/DWjx7
 gbMQ==
X-Gm-Message-State: AOAM5312seSQvdrBn/rbiEZlc9A0Xt2m09NG1VO/HdaOZxl/iaQQpXSj
 WwU4ORCpP9R/8amy3X1sgN1k2A==
X-Google-Smtp-Source: ABdhPJzRyu8tHffHYzAcQVAnebPL6Cv2V5j7/xAO3BnBL9wlRay5v7Pxg+Hg4uOSbzo7Xo6auY8Wfg==
X-Received: by 2002:a63:4862:0:b0:385:fb1d:fc54 with SMTP id
 x34-20020a634862000000b00385fb1dfc54mr36295792pgk.57.1649872677704; 
 Wed, 13 Apr 2022 10:57:57 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254]) by smtp.gmail.com with ESMTPSA id
 br10-20020a17090b0f0a00b001cd4fb89d38sm3170813pjb.9.2022.04.13.10.57.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Apr 2022 10:57:56 -0700 (PDT)
Date: Wed, 13 Apr 2022 17:57:53 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlcPIYJ0CB2qnfpT@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
 <YlYhO7GvjKY1cwHr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YlYhO7GvjKY1cwHr@google.com>
X-Mailman-Approved-At: Thu, 14 Apr 2022 06:42:33 -0400
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

On Wed, Apr 13, 2022 at 01:02:51AM +0000, Sean Christopherson wrote:
> On Tue, Apr 12, 2022, David Matlack wrote:
> > On Mon, Apr 11, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Apr 11, 2022, David Matlack wrote:
> > > >
> > > > One thing that would be helpful is if you can explain in a bit more
> > > > specifically what you'd like to see. Part of the reason why I prefer
> > > > to sequence your proposal after eager page splitting is that I do not
> > > > fully understand what you're proposing, and how complex it would be.
> > > > e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> > > > for nested MMUs does not sound like less churn.
> > >
> > > Oh, it's most definitely not less code, and probably more churn.  But, it's churn
> > > that pushes us in a more favorable direction and that is desirable long term.  I
> > > don't mind churning code, but I want the churn to make future life easier, not
> > > harder.  Details below.
> > 
> > Of course. Let's make sure we're on the same page about what churn
> > introduced by this series will make future life harder that we hope to
> > avoid. If I understand you correctly, it's the following 2 changes:
> > 
> >  (a.) Using separate functions to allocate SPs and initialize SPs.
> >  (b.) Separating kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page().
> > 
> > (a.) stems from the fact that SP allocation during eager page
> > splitting is made directly rather than through kvm_mmu_memory_caches,
> > which was what you pushed for in the TDP MMU implementation. We could
> > instead use kvm_mmu_memory_caches for the shadow MMU eager page
> 
> ...
> 
> > So even if we did everything you proposed (which seems like an awful
> > lot just to avoid __kvm_mmu_find_shadow_page()), there's a chance we
> > would still end up with the exact same code. i.e.
> > kvm_mmu_nested_tdp_find_sp() would be implemented by calling
> > __kvm_mmu_find_shadow_page(), because it would be a waste to
> > re-implement an almost identical function?
> 
> I went far enough down this path to know that my idea isn't completely awful,
> and wouldn't actually need to fork FNAME(page_fault) at this time, but sadly I
> still dislike the end result.

Thanks for looking into it so quickly so we could figure out a path
forward.

> 
> Your assessment that the we'd still end up with very similar (if not quite exact)
> code is spot on.  Ditto for your other assertion in (a) about using the caches.
> 
> My vote for this series is to go the cache route, e.g. wrap kvm_mmu_memory_caches
> in a struct and pass that into kvm_mmu_get_page().  I still think it was the right
> call to ignore the caches for the TDP MMU, it gives the TDP MMU more flexibility
> and it was trivial to bypass the caches since the TDP MMU was doing its own thing
> anyways.
> 
> But for the shadow MMU, IMO the cons outweigh the pros.  E.g. in addition to
> ending up with two similar but subtly different "get page" flows, passing around
> "struct kvm_mmu_page **spp" is a bit unpleasant.  Ditto for having a partially
> initialized kvm_mmu_page.  The split code also ends up in a wierd state where it
> uses the caches for the pte_list, but not the other allocations.

Sounds good. I will rework the series to use kvm_mmu_memory_cache
structs for the SP allocation during eager page splitting. That will
eliminate the separate allocation and initialization which will be a
nice cleanup. And it will be great to get rid of the spp crud.

And per your earlier feedback, I will also limit eager page splitting to
nested MMUs.

> 
> There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
> for the split case and assert that @vcpu is non-null since all of the children
> should be direct.

The NULL vcpu check will be a little gross, but it should never trigger
in practice since eager page splitting always requests direct SPs. My
preference has been to enforce that in code by splitting out
__kvm_mmu_find_shadow_page(), but I can see the advantage of your
proposal is that eager page splitting and faults will go through the
exact same code path to get a kvm_mmu_page.

> 
> 		if (sp->unsync) {
> 			if (WARN_ON_ONCE(!vcpu)) {
> 				kvm_mmu_prepare_zap_page(kvm, sp,
> 							 &invalid_list);
> 				continue;
> 			}
> 
> 			/*
> 			 * The page is good, but is stale.  kvm_sync_page does
> 			 * get the latest guest state, but (unlike mmu_unsync_children)
> 			 * it doesn't write-protect the page or mark it synchronized!
> 			 * This way the validity of the mapping is ensured, but the
> 			 * overhead of write protection is not incurred until the
> 			 * guest invalidates the TLB mapping.  This allows multiple
> 			 * SPs for a single gfn to be unsync.
> 			 *
> 			 * If the sync fails, the page is zapped.  If so, break
> 			 * in order to rebuild it.
> 			 */
> 			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> 				break;
> 
> 			WARN_ON(!list_empty(&invalid_list));
> 			kvm_flush_remote_tlbs(kvm);
> 		}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
