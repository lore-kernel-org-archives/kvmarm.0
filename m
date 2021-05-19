Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3433AC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 17:48:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CDEA61244
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 17:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CDEA61244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25DE14B883;
	Wed, 19 May 2021 13:48:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uDKv2Mm-grjv; Wed, 19 May 2021 13:48:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94654B850;
	Wed, 19 May 2021 13:48:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E28A04B83E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 13:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M+MIN+Nbl-aD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 13:48:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA7B64B832
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 13:48:16 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 232EC611BF;
 Wed, 19 May 2021 17:48:11 +0000 (UTC)
Date: Wed, 19 May 2021 18:48:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 3/8] arm64: mte: Sync tags for pages where PTE is
 untagged
Message-ID: <20210519174808.GD21619@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-4-steven.price@arm.com>
 <87y2cdtk09.wl-maz@kernel.org>
 <f3a3f560-4d2b-9cd3-bbf4-ea8135ab4d17@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f3a3f560-4d2b-9cd3-bbf4-ea8135ab4d17@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, May 19, 2021 at 10:32:01AM +0100, Steven Price wrote:
> On 17/05/2021 17:14, Marc Zyngier wrote:
> > On Mon, 17 May 2021 13:32:34 +0100,
> > Steven Price <steven.price@arm.com> wrote:
> >>
> >> A KVM guest could store tags in a page even if the VMM hasn't mapped
> >> the page with PROT_MTE. So when restoring pages from swap we will
> >> need to check to see if there are any saved tags even if !pte_tagged().
> >>
> >> However don't check pages for which pte_access_permitted() returns false
> >> as these will not have been swapped out.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/include/asm/pgtable.h |  9 +++++++--
> >>  arch/arm64/kernel/mte.c          | 16 ++++++++++++++--
> >>  2 files changed, 21 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> >> index 0b10204e72fc..275178a810c1 100644
> >> --- a/arch/arm64/include/asm/pgtable.h
> >> +++ b/arch/arm64/include/asm/pgtable.h
> >> @@ -314,8 +314,13 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
> >>  	if (pte_present(pte) && pte_user_exec(pte) && !pte_special(pte))
> >>  		__sync_icache_dcache(pte);
> >>  
> >> -	if (system_supports_mte() &&
> >> -	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
> >> +	/*
> >> +	 * If the PTE would provide user space access to the tags associated
> >> +	 * with it then ensure that the MTE tags are synchronised.  Exec-only
> >> +	 * mappings don't expose tags (instruction fetches don't check tags).
> > 
> > I'm not sure I understand this comment. Of course, execution doesn't
> > match tags. But the memory could still have tags associated with
> > it. Does this mean such a page would lose its tags is swapped out?
> 
> Hmm, I probably should have reread that - the context of the comment is
> lost.
> 
> I added the comment when changing to pte_access_permitted(), and the
> comment on pte_access_permitted() explains a potential gotcha:
> 
>  * p??_access_permitted() is true for valid user mappings (PTE_USER
>  * bit set, subject to the write permission check). For execute-only
>  * mappings, like PROT_EXEC with EPAN (both PTE_USER and PTE_UXN bits
>  * not set) must return false. PROT_NONE mappings do not have the
>  * PTE_VALID bit set.
> 
> So execute-only mappings return false even though that is effectively a
> type of user access. However, because MTE checks are not performed by
> the PE for instruction fetches this doesn't matter. I'll update the
> comment, how about:
> 
> /*
>  * If the PTE would provide user space access to the tags associated
>  * with it then ensure that the MTE tags are synchronised.  Although
>  * pte_access_permitted() returns false for exec only mappings, they
>  * don't expose tags (instruction fetches don't check tags).
>  */

This looks fine to me. We basically want to check the PTE_VALID and
PTE_USER bits and pte_access_permitted() does this (we could come up
with a new macro name like pte_valid_user() but since we don't care
about execute-only, it gets unnecessarily complicated).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
