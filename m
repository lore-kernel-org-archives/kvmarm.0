From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 16/27] KVM: arm64: Factor out core register ID
 enumeration
Date: Tue, 2 Apr 2019 09:59:19 +0100
Message-ID: <20190402085917.GF3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-17-git-send-email-Dave.Martin@arm.com>
 <86ftr15dsb.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <86ftr15dsb.wl-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 03:41:56AM +0100, Marc Zyngier wrote:
> On Fri, 29 Mar 2019 13:00:41 +0000,
> Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > In preparation for adding logic to filter out some KVM_REG_ARM_CORE
> > registers from the KVM_GET_REG_LIST output, this patch factors out
> > the core register enumeration into a separate function and rebuilds
> > num_core_regs() on top of it.
> > 
> > This may be a little more expensive (depending on how good a job
> > the compiler does of specialising the code), but KVM_GET_REG_LIST
> > is not a hot path.
> > 
> > This will make it easier to consolidate ID filtering code in one
> > place.
> > 
> > No functional change.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> > Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> > 
> > ---
> > 
> > Changes since v5:
> > 
> >  * New patch.
> > 
> >    This reimplements part of the separately-posted patch "KVM: arm64:
> >    Factor out KVM_GET_REG_LIST core register enumeration", minus aspects
> >    that potentially break the ABI.
> > 
> >    As a result, the opportunity to truly consolidate all the ID reg
> >    filtering in one place is deliberately left on the floor, for now.
> >    This will be addressed in a separate series later on.
> > ---
> >  arch/arm64/kvm/guest.c | 33 +++++++++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 3e38eb2..a391a61 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c

[...]

> > @@ -276,15 +296,12 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
> >   */
> >  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >  {
> > -	unsigned int i;
> > -	const u64 core_reg = KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE;
> >  	int ret;
> >  
> > -	for (i = 0; i < sizeof(struct kvm_regs) / sizeof(__u32); i++) {
> > -		if (put_user(core_reg | i, uindices))
> > -			return -EFAULT;
> > -		uindices++;
> > -	}
> > +	ret = kvm_arm_copy_core_reg_indices(uindices);
> > +	if (ret)
> > +		return ret;
> > +	uindices += ret;
> 
> Interesting snippet. Given that most implementations have at least one
> register, this can hardly work. Please do test things with QEMU, and
> not only kvmtool which obviously doesn't exercise this path.

My bad: this used to work to do the right thing, but I broke it when
splitting up [1] for v6 to avoid the dependency.

kvm_arm_copy_core_reg_indices() used to take &uindices and update it
directly, returning 0 on success instead of the number of registers.
But this seemed less consistent with the way the other functions are
called.

> For the sake of getting -next back to a vaguely usable state, I've now
> queued the following patch on top.
> 
> 	M.
> 
> From 832401c8912680ee56dc5cb6ab101266b3db416a Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <marc.zyngier@arm.com>
> Date: Tue, 2 Apr 2019 03:28:39 +0100
> Subject: [PATCH] arm64: KVM: Fix system register enumeration
> 
> The introduction of the SVE registers to userspace started with a
> refactoring of the way we expose any register via the ONE_REG
> interface.
> 
> Unfortunately, this change doesn't exactly behave as expected
> if the number of registers is non-zero and consider everything
> to be an error. The visible result is that QEMU barfs very early
> when creating vcpus.
> 
> Make sure we only exit early in case there is an actual error, rather
> than a positive number of registers...
> 
> be25bbb392fa ("KVM: arm64: Factor out core register ID enumeration")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/guest.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 086ab0508d69..4f7b26bbf671 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -604,22 +604,22 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	int ret;
>  
>  	ret = copy_core_reg_indices(vcpu, uindices);
> -	if (ret)
> +	if (ret < 0)
>  		return ret;
>  	uindices += ret;
>  
>  	ret = copy_sve_reg_indices(vcpu, uindices);
> -	if (ret)
> +	if (ret < 0)
>  		return ret;
>  	uindices += ret;

^ Ack

>  	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
> -	if (ret)
> +	if (ret < 0)
>  		return ret;
>  	uindices += kvm_arm_get_fw_num_regs(vcpu);
>  
>  	ret = copy_timer_indices(vcpu, uindices);
> -	if (ret)
> +	if (ret < 0)
>  		return ret;
>  	uindices += NUM_TIMER_REGS;

For these two, the interface is not really the same.  These don't
return the number of registers, so return 0 on success.  "< 0" here
could be a trap for the future, though the risk looks low.

I can have a go at some rework on top to make this more consistent,
but I'd rather not muddy the water further for the moment.

Any view on that?

Cheers
---Dave
