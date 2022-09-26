Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C164C32771
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 11:00:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DFC4B822;
	Mon, 26 Sep 2022 07:00:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EmZxVOm+XAi7; Mon, 26 Sep 2022 07:00:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27FC24B824;
	Mon, 26 Sep 2022 07:00:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CE04B822
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 07:00:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id prOFt1rSomi7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 07:00:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04ACF4B813
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 07:00:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A961ED1;
 Mon, 26 Sep 2022 04:00:40 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC7BC3F66F;
 Mon, 26 Sep 2022 04:00:32 -0700 (PDT)
Date: Mon, 26 Sep 2022 12:01:28 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end
 parameter as unused in setup_mmu()
Message-ID: <YzGGiDBtJ4z/sLS7@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-8-alexandru.elisei@arm.com>
 <20220920085815.qk6js67qjvken2kt@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220920085815.qk6js67qjvken2kt@kamzik>
Cc: nikos.nikoleris@arm.com, pbonzini@redhat.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi,

On Tue, Sep 20, 2022 at 10:58:15AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:46AM +0100, Alexandru Elisei wrote:
> > phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
> > room for the vmalloc area to grown down. This was made useless in commit
> > c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
> > setup_mmu() was changed to map all the detected memory regions without
> > changing their limits.
> 
> c1cd1a2bed69 was a start, but as that commit says, the 3G-4G region was
> still necessary due to assumptions in the virtual memory allocator. This
> patch needs to point out a vmalloc commit which removes that assumption
> as well for its justification.

By "made useless" I mean that after that commit phys_end has no influence
on the way setup_mmu() creates the translation tables.

Yes, it's a problem because on real hardware or with kvmtool, which allows
the user to specify where RAM starts, the test can be loaded at the same
address from where vmalloc() will start allocating memory. But I think that
should be fixed separately from this series, maybe as part of the main
UEFI series, or as a separate patch(es).

I'll drop this patch, and leave any cleanups for when the vmalloc area
change is implemented.

Thanks,
Alex

> 
> Thanks,
> drew
> 
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/arm/mmu.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index e1a72fe4941f..8f936acafe8b 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
> >  	}
> >  }
> >  
> > -void *setup_mmu(phys_addr_t phys_end, void *unused)
> > +void *setup_mmu(phys_addr_t unused0, void *unused1)
> >  {
> >  	struct mem_region *r;
> >  
> > -	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
> > -	if (phys_end > (3ul << 30))
> > -		phys_end = 3ul << 30;
> > -
> >  #ifdef __aarch64__
> >  	init_alloc_vpage((void*)(4ul << 30));
> >  
> > -- 
> > 2.37.1
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
