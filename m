Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DB1C38145
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 16:29:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 802E440BEE;
	Fri,  2 Sep 2022 12:29:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6s0CuSPPglos; Fri,  2 Sep 2022 12:29:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560FA4120D;
	Fri,  2 Sep 2022 12:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADEF4120D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 12:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jt+xzRzeY+uE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 12:28:57 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A2A740BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 12:28:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 550D8CE3028;
 Fri,  2 Sep 2022 16:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E34C433D6;
 Fri,  2 Sep 2022 16:28:50 +0000 (UTC)
Date: Fri, 2 Sep 2022 17:28:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 4/7] arm64: mte: Lock a page for MTE tag initialisation
Message-ID: <YxIvP+a2P0DGIUrA@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-5-pcc@google.com>
 <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
Cc: kvm@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Evgenii Stepanov <eugenis@google.com>,
 Marc Zyngier <maz@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 02, 2022 at 03:47:33PM +0100, Steven Price wrote:
> On 10/08/2022 20:30, Peter Collingbourne wrote:
> > diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> > index a78c1db23c68..cd5ad0936e16 100644
> > --- a/arch/arm64/mm/mteswap.c
> > +++ b/arch/arm64/mm/mteswap.c
> > @@ -53,6 +53,9 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
> >  	if (!tags)
> >  		return false;
> >  
> > +	/* racing tag restoring? */
> > +	if (!try_page_mte_tagging(page))
> > +		return false;
> >  	mte_restore_page_tags(page_address(page), tags);
> 
> I feel like adding a "set_page_mte_tagged(page);" in here would avoid
> the need for the comments about mte_restore_tags() taking the lock.

Good point. I think I blindly followed the set_bit() places but it makes
sense to move the bit setting to mte_restore_tags().

Thanks for the review.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
