From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 15/17] kvm: arm64: Get rid of fake page table levels
Date: Tue, 12 Apr 2016 15:11:56 +0200
Message-ID: <20160412131156.GH3039@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-16-git-send-email-suzuki.poulose@arm.com>
 <20160408150523.GX8961@cbox> <570BB5C9.8040509@arm.com>
 <20160412121414.GA3039@cbox> <570CF21D.8000600@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C1240402
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 09:10:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ciRKJasetynd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 09:10:00 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62F8F400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 09:10:00 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id v188so126558676wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 06:11:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570CF21D.8000600@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 12, 2016 at 02:03:25PM +0100, Suzuki K Poulose wrote:
> On 12/04/16 13:14, Christoffer Dall wrote:
> >On Mon, Apr 11, 2016 at 03:33:45PM +0100, Suzuki K Poulose wrote:
> >>On 08/04/16 16:05, Christoffer Dall wrote:
> >>>On Mon, Apr 04, 2016 at 05:26:15PM +0100, Suzuki K Poulose wrote:
> >>
> 
> >>>>-#if PGDIR_SHIFT > KVM_PHYS_SHIFT
> >>>>-#define PTRS_PER_S2_PGD_SHIFT	0
> >>>>-#else
> >>>>-#define PTRS_PER_S2_PGD_SHIFT	(KVM_PHYS_SHIFT - PGDIR_SHIFT)
> >>>>-#endif
> >>>>-#define PTRS_PER_S2_PGD		(1 << PTRS_PER_S2_PGD_SHIFT)
> >>>>+#define STAGE2_PGTABLE_LEVELS		ARM64_HW_PGTABLE_LEVELS(KVM_PHYS_SHIFT - 4)
> >>>>
> >>>>  /*
> >>>>- * If we are concatenating first level stage-2 page tables, we would have less
> >>>>- * than or equal to 16 pointers in the fake PGD, because that's what the
> >>>>- * architecture allows.  In this case, (4 - CONFIG_PGTABLE_LEVELS)
> >>>>- * represents the first level for the host, and we add 1 to go to the next
> >>>>- * level (which uses contatenation) for the stage-2 tables.
> >
> >just noticed: s/contatenation/concatenation/
> 
> Thanks for catching that. Will fix it.
> 
> >>>which case this should be reworded to just state the assumptions and why
> >>>this is a good assumption.
> >>>
> >>>(If my assumptions are wrong here, then there are also weird cases where
> >>>the host does huge pages at the PMD level and we don't.  Not sure I can
> >>>see the full ramifications of that.)
> >>
> >>I am sorry, I didn't get your point about the PMD level.
> >>
> >
> >Right, I expressed that terribly, and I may have gotten myself confused
> >when writing that.
> >
> >My concern is this: if the number of levels between the host and stage-2
> >are different, and the host uses huge pmd mappings (either THP or huge
> >tlb fs), then do we always do the right thing for stage-2 tables, even
> >if we support the case with more levels in Stage-2 than on the host?
> 
> Yes. We are safe with PMD (level 2). In the worst case we will have a 2level
> page table at host and say 4 at stage2. In either case, we have a PMD level
> (which in host is folded to PGD) and both will use section mapping at level 2
> for huge pmd. Also pmd_huge() doesn't care if the PMD is folded or not. So,
> we are fine with that. I hope that answers your question.
> 

It does, thanks for enumerating the cases for me.

> >
> >Thanks for trying to parse my crytptic and potentially nonsensical
> >questions.
> 
> No no, they make absolute sense. I had gone through these questions myself initially
> when I wrote the series, so its good to share them :-).
> 
> Btw, I have rebased my series to kvmarm and have addressed the comments. I will post
> them after a round of testing.
> 

Great, thanks!

-Christoffer
