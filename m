Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78644C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 08:34:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BECFE4B93E;
	Thu, 20 Oct 2022 04:34:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VzkxDBTVYP+C; Thu, 20 Oct 2022 04:34:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88F324B945;
	Thu, 20 Oct 2022 04:34:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE3A4B93B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 04:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyzQyd6QKFYT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 04:34:33 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73B684B8F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 04:34:33 -0400 (EDT)
Date: Thu, 20 Oct 2022 11:34:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666254872;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qzX6SzV6RdnXytSM2ouehoSyV7++gCHengCJvmVIT7s=;
 b=ha7Agfr0EZ1HqBNwRgfdeT84BnPAGCdqCmWxiw8zIoxjGznrHHmeb8r2ZOT6kEIhjttnjI
 JvxjjwysVU/zudV3hs35G+nF2vyB/lOZmRkFRbJiEHOWfZ3PgsVHrBtc/g4SKQQcQZBtBN
 V/iHop8+q44+UHjRL4hZo422bZj8pPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1EIEOoelp+ZG3+I@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-9-oliver.upton@linux.dev>
 <Y1CIdN5kcJPaZdqv@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y1CIdN5kcJPaZdqv@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Oct 19, 2022 at 11:29:56PM +0000, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Oliver Upton wrote:
> > The use of RCU is necessary to safely change the stage-2 page tables in
> > parallel. Acquire and release the RCU read lock when traversing the page
> > tables.
> > 
> > Use the _raw() flavor of rcu_dereference when changes to the page tables
> > are otherwise protected from parallel software walkers (e.g. holding the
> > write lock).
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> 
> ...
> 
> > @@ -32,6 +39,33 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
> >  	return pteref;
> >  }
> >  
> > +static inline void kvm_pgtable_walk_begin(void) {}
> > +static inline void kvm_pgtable_walk_end(void) {}
> > +
> > +#else
> > +
> > +typedef kvm_pte_t __rcu *kvm_pteref_t;
> > +
> > +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> > +{
> > +	if (shared)
> > +		return rcu_dereference(pteref);
> > +
> > +	return rcu_dereference_raw(pteref);
> 
> Rather than use raw, use rcu_dereference_check().  If you can plumb down @kvm or
> @mmu_lock, the ideal check would be (apparently there's no lockdep_is_held_write()
> wrapper?)
> 
> 	return READ_ONCE(*rcu_dereference_check(ptep, lockdep_is_held_type(mmu_lock, 0)));
> 
> If getting at mmu_lock is too difficult, this can still be
> 
> 	return READ_ONCE(*rcu_dereference_check(ptep, !shared);
> 
> Doubt it matters for code generation, but IMO it's cleaner overall.

As the page table walkers can be used outside of the context of a VM
(such as hyp stage-1), I think option #2 is probably a bit easier.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
