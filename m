Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C54ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 09:38:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6A804CA03;
	Fri,  9 Sep 2022 05:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GqUvPoo35oTz; Fri,  9 Sep 2022 05:38:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 886804CA1B;
	Fri,  9 Sep 2022 05:38:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15BD04CA05
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 05:38:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N6C0B9jgW2vn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 05:38:33 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C2174CA03
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 05:38:33 -0400 (EDT)
Date: Fri, 9 Sep 2022 10:38:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662716312;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sbjsJsmK8eNNPB1/qbrlalcNvip2GURuJ8l1XpwCdtA=;
 b=w5aYW3X82xa4eYEqN9xPSlbdWVdlzhVTNhVkxtP9f3wiaVyoildIroHN4Zy7CmcTTPA9wN
 SoANTcLFct9zHRFs4lgnTLNq94CjWzDWlcEX4gscm56lXU4biERICyRPbokXJYe5ydUMBs
 el+dRzkfzb1LVpFUKALFGbST86619Q8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 06/14] KVM: arm64: Return next table from map callbacks
Message-ID: <YxsJj3ojGyhNw5Jn@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-7-oliver.upton@linux.dev>
 <YxkN7XmHiU3ddknR@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YxkN7XmHiU3ddknR@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi David,

On Wed, Sep 07, 2022 at 02:32:29PM -0700, David Matlack wrote:
> On Tue, Aug 30, 2022 at 07:41:24PM +0000, Oliver Upton wrote:
> > The map walkers install new page tables during their traversal. Return
> > the newly-installed table PTE from the map callbacks to point the walker
> > at the new table w/o rereading the ptep.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 331f6e3b2c20..f911509e6512 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -202,13 +202,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> >  	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
> >  		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
> >  					     KVM_PGTABLE_WALK_LEAF);
> > -		pte = *ptep;
> > -		table = kvm_pte_table(pte, level);
> >  	}
> >  
> >  	if (ret)
> >  		goto out;
> 
> Rather than passing a pointer to the local variable pte and requiring
> all downstream code to update it (and deal with dereferencing to read
> the old pte), wouldn't it be simpler to just re-read the PTE here?

Yeah, you're right. I had some odd rationalization about this, but
there's no need to force a walker to descend into the new table level as
it is wasted work if another thread unlinks it.

[...]

> >  
> > +	table = kvm_pte_table(pte, level);
> >  	if (!table) {
> 
> nit: Technically there's no reason to set @table again. e.g. This could
> just be:
> 
>         if (!kvm_pte_table(pte, level)) {

Sure, I'll squish these lines together.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
