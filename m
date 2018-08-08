From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 08/16] KVM: arm64: Support dynamically hideable
 system registers
Date: Wed, 8 Aug 2018 09:33:00 +0100
Message-ID: <20180808083300.GK9097@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-9-git-send-email-Dave.Martin@arm.com>
 <20180807192010.GG5985@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32F654A0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 04:33:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BZdBqou-b6Cz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Aug 2018 04:33:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1630640672
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 04:33:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180807192010.GG5985@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 07, 2018 at 09:20:10PM +0200, Christoffer Dall wrote:

[...]

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index a436373..31a351a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1840,7 +1840,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
> >  
> >  	r = find_reg(params, table, num);
> >  
> > -	if (r) {
> > +	if (likely(r) && sys_reg_present(vcpu, r)) {
> >  		perform_access(vcpu, params, r);
> >  		return 0;
> >  	}
> > @@ -2016,7 +2016,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
> >  	if (!r)
> >  		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> >  
> > -	if (likely(r)) {
> > +	if (likely(r) && sys_reg_present(vcpu, r)) {
> >  		perform_access(vcpu, params, r);
> >  	} else {
> >  		kvm_err("Unsupported guest sys_reg access at: %lx\n",
> 
> This looks a bit fishy, because it seems that now a guest can be
> configured in such a way that it can access non-present emulated system
> registers and get the host to tell the operator that the KVM instance
> running on the system doesn't really support the hardware...

Hmmm, looks like I just blindly adapted the if () condition without
looking at the context here.

I'll take a look at it.

[...]

Cheers
---Dave
