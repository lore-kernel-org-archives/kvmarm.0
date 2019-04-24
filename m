From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 11/27] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Wed, 24 Apr 2019 14:47:18 +0100
Message-ID: <20190424134717.GY3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-12-git-send-email-Dave.Martin@arm.com>
 <87h8anwxm4.fsf@zen.linaroharston>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB574A48D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cGCnO43QDNHd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 09:47:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D414A4B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 09:47:23 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <87h8anwxm4.fsf@zen.linaroharston>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 09:39:31AM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > Some optional features of the Arm architecture add new system
> > registers that are not present in the base architecture.
> >
> > Where these features are optional for the guest, the visibility of
> > these registers may need to depend on some runtime configuration,
> > such as a flag passed to KVM_ARM_VCPU_INIT.
> =

> This combined with...
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -64,8 +64,15 @@ struct sys_reg_desc {
> >  			const struct kvm_one_reg *reg, void __user *uaddr);
> >  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  			const struct kvm_one_reg *reg, void __user *uaddr);
> > +
> > +	/* Return mask of REG_* runtime visibility overrides */
> > +	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
> > +				   const struct sys_reg_desc *rd);
> >  };
> =

> this makes me wonder what sort of machines will see different register
> visibility depending on which vcpu you are running on?

Userspace can consciously set KVM_ARM_VCPU_SVE in vcpu_init.features[0]
for some vcpus and not for others.

For one thing, this is useful for testing how the guest responds to that
configuration.

This will for example allow Linux's handling of these weird
configurations to be tested directly rather than by hacking the
guest kernel to fake it up -- which is what I've had to do up to now.

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks!

(Note, Marc already picked the patches into kvmarm/next, so new tags
won't be applied.  But the review is still appreciated, and if you spot
any issues I'd certainly like to know :)

Cheers
---Dave
