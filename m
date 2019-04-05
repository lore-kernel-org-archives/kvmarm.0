From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 21/27] KVM: arm/arm64: Add hook for arch-specific KVM
 initialisation
Date: Fri, 5 Apr 2019 10:36:24 +0100
Message-ID: <20190405093624.GP3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-22-git-send-email-Dave.Martin@arm.com>
 <20190404142528.pxo3vrnk6mfsgmyq@kamzik.brq.redhat.com>
 <20190404145354.GG3567@e103592.cambridge.arm.com>
 <20190404163308.2aaauxituh6rfffu@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66CEF4A452
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 05:36:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vQlJTAb-K-M8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 05:36:29 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61B734A429
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 05:36:29 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404163308.2aaauxituh6rfffu@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 06:33:08PM +0200, Andrew Jones wrote:
> On Thu, Apr 04, 2019 at 03:53:55PM +0100, Dave Martin wrote:
> > On Thu, Apr 04, 2019 at 04:25:28PM +0200, Andrew Jones wrote:
> > > On Fri, Mar 29, 2019 at 01:00:46PM +0000, Dave Martin wrote:

[...]

> > > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > > > index 99c3738..c69e137 100644
> > > > --- a/virt/kvm/arm/arm.c
> > > > +++ b/virt/kvm/arm/arm.c
> > > > @@ -1664,6 +1664,10 @@ int kvm_arch_init(void *opaque)
> > > >  	if (err)
> > > >  		return err;
> > > >  
> > > > +	err = kvm_arm_init_arch_resources();
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > >  	if (!in_hyp_mode) {
> > > >  		err = init_hyp_mode();
> > > >  		if (err)
> > > > -- 
> > > > 2.1.4
> > > >
> > > 
> > > It's not clear to me from the commit message why init_common_resources()
> > > won't work for this. Maybe it'll be more clear as I continue the review.
> > 
> > init_common_resources() is for stuff common to arm and arm64.
> 
> Well currently init_common_resources() only calls kvm_set_ipa_limit(),
> which isn't implemented for arm. So if there was a plan to only use
> that function for init that actually does something on both, it doesn't.

Hmmm, perhaps I was wishfully interpreting the word "common" to mean
what I would like it to mean...

> > kvm_arm_init_arch_resources() is intended for stuff specific to the
> > particular arch backend.
> 
> I'm not sure we need that yet. We just need an arm setup sve stub like
> arm's kvm_set_ipa_limit() stub. OTOH, if we have to keep adding stubs
> to arm we should probably have something like
> kvm_arm_init_arch_resources() instead, and kvm_set_ipa_limit() should
> be moved inside the arm64 one and the arm ipa limit stub can go. Then
> since init_common_resources() would no longer be used, it could just
> be deleted.

OK, for simplicity I may call the sve setup directly as you suggest, and
make an arm stub for it: that feels a bit weird, but there is precedent.

If we end up accumulating a lot of these, we can revisit it and maybe
invent something like kvm_arm_init_arch_resources() at that point.

Does that sound reasonable?

Cheers
---Dave
