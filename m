Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D67C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 13:02:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D085C611AD
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 13:02:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D085C611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFAA4B373;
	Thu, 20 May 2021 09:02:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iy6UYjZJ93Ug; Thu, 20 May 2021 09:02:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BBB4B35E;
	Thu, 20 May 2021 09:02:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8B54B354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 09:02:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dNU5Oq76G0lK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 09:02:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51E374B2F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 09:02:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 686BB61184;
 Thu, 20 May 2021 13:02:27 +0000 (UTC)
Date: Thu, 20 May 2021 14:02:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 3/8] arm64: mte: Sync tags for pages where PTE is
 untagged
Message-ID: <20210520130224.GE12251@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-4-steven.price@arm.com>
 <20210519180610.GE21619@arm.com>
 <3bac3a47-9f96-c7bf-e401-fdef60dcc9d8@arm.com>
 <20210520122550.GD12251@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210520122550.GD12251@arm.com>
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

On Thu, May 20, 2021 at 01:25:50PM +0100, Catalin Marinas wrote:
> On Thu, May 20, 2021 at 12:55:21PM +0100, Steven Price wrote:
> > The problem I hit is one of include dependencies:
> > 
> > is_swap_pte() is defined (as a static inline) in
> > include/linux/swapops.h. However the definition depends on
> > pte_none()/pte_present() which are defined in pgtable.h - so there's a
> > circular dependency.
> > 
> > Open coding is_swap_pte() in set_pte_at() works, but it's a bit ugly.
> > Any ideas on how to improve on the below?
> > 
> > 	if (system_supports_mte() && pte_present(pte) &&
> > 	    pte_access_permitted(pte, false) && !pte_special(pte)) {
> > 		pte_t old_pte = READ_ONCE(*ptep);
> > 		/*
> > 		 * We only need to synchronise if the new PTE has tags enabled
> > 		 * or if swapping in (in which case another mapping may have
> > 		 * set tags in the past even if this PTE isn't tagged).
> > 		 * (!pte_none() && !pte_present()) is an open coded version of
> > 		 * is_swap_pte()
> > 		 */
> > 		if (pte_tagged(pte) || (!pte_none(pte) && !pte_present(pte)))
> > 			mte_sync_tags(old_pte, pte);
> > 	}
> 
> That's why I avoided testing my suggestion ;). I think we should just
> add !pte_none() in there with a comment that it may be a swap pte and
> use the is_swap_pte() again on the mte_sync_tags() path. We already have
> the pte_present() check.

Correction - pte_present() checks the new pte only, we need another for
the old pte. So it looks like we'll open-code is_swap_pte().

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
