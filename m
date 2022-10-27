Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65059ECAAA1
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 22:31:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CA64B121;
	Thu, 27 Oct 2022 18:31:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nmF06OELV7HY; Thu, 27 Oct 2022 18:31:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4F24B0B4;
	Thu, 27 Oct 2022 18:31:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 389554965C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 18:31:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFL55jqBWcU9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 18:31:20 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E946548F99
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 18:31:19 -0400 (EDT)
Date: Thu, 27 Oct 2022 22:31:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666909879;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GW5NB8+RTKGpYs1izwEP9mB0IXmkchEi4A58SakMWcs=;
 b=SAz+URbCjnmNMltTgdDWAqtUOSNXXWz0wbOUwMMuaQN4L38TjZjE0neZdisQyK57xfF25S
 Wc9HAGblbg7HKZiAP06j3kdCX8Z5pdQz5BAxfmPsIpVK6QJBDPU6VSL1hUt3Ra48mpCJbV
 8a96aNnjz+U/wf6s+DmSBbhMLYzWvck=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 07/15] KVM: arm64: Use an opaque type for pteps
Message-ID: <Y1sGs6TFh6P20ymH@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007232818.459650-8-oliver.upton@linux.dev>
 <Y1CFl8sLllXm4seK@google.com> <Y1EHnFN2Goj2eLkE@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y1EHnFN2Goj2eLkE@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Ben Gardon <bgardon@google.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
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

On Thu, Oct 20, 2022 at 11:32:28AM +0300, Oliver Upton wrote:
> On Wed, Oct 19, 2022 at 11:17:43PM +0000, Sean Christopherson wrote:
> > On Fri, Oct 07, 2022, Oliver Upton wrote:

[...]

> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index 02c33fccb178..6b6e1ed7ee2f 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
> > >  }
> > >  
> > >  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> > > -			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
> > > +			      struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
> > >  
> > >  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> > >  				      struct kvm_pgtable_mm_ops *mm_ops,
> > > -				      kvm_pte_t *ptep, u32 level)
> > > +				      kvm_pteref_t pteref, u32 level)
> > >  {
> > >  	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> > > +	kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
> > >  	struct kvm_pgtable_visit_ctx ctx = {
> > >  		.ptep	= ptep,
> > >  		.old	= READ_ONCE(*ptep),
> > 
> > This is where you want the protection to kick in, e.g. 
> > 
> >   typedef kvm_pte_t __rcu *kvm_ptep_t;
> > 
> >   static inline kvm_pte_t kvm_read_pte(kvm_ptep_t ptep)
> >   {
> > 	return READ_ONCE(*rcu_dereference(ptep));
> >   }
> > 
> > 		.old	= kvm_read_pte(ptep),
> > 
> > In other words, the pointer itself isn't that's protected, it's PTE that the
> > pointer points at that's protected.
> 
> Right, but practically speaking it is the boundary at which we assert
> that protection.
> 
> Anyhow, I'll look at abstracting the actual memory accesses in the
> visitors without too much mess.

Took this in a slightly different direction after playing with it for a
while. Abstracting all PTE accesses adds a lot of churn to the series.
Adding in an assertion before invoking a visitor callback (i.e. when the
raw pointer is about to be used) provides a similar degree of assurance
that we are indeed RCU-safe.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
