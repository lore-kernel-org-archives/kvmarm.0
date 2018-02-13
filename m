From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64/kvm: Prohibit guest LOR accesses
Date: Tue, 13 Feb 2018 12:39:37 +0000
Message-ID: <20180213123022.zidr5oztavixe2p5@lakrids.cambridge.arm.com>
References: <20180212111424.39248-1-mark.rutland@arm.com>
 <20180213102742.GG23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180213102742.GG23189@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 13, 2018 at 11:27:42AM +0100, Christoffer Dall wrote:
> Hi Mark,

Hi Christoffer,

> On Mon, Feb 12, 2018 at 11:14:24AM +0000, Mark Rutland wrote:
> > We don't currently limit guest accesses to the LOR registers, which we
> > neither virtualize nor context-switch. As such, guests are provided with
> > unusable information/controls, and are not isolated from each other (or
> > the host).
> > 
> > To prevent these issues, we can trap register accesses and present the
> > illusion that no LORegions are implemented.
> 
> Shouldn't we then also hide this from the ID register similar to what we
> do for SVE at the moment, using something like this (untested):
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a828a209716f..b7ee414aee67 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1064,6 +1064,12 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  				    task_pid_nr(current));
>  
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> +	} else if (id == SYS_ID_AA64MMFR1_EL) {
> +		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
> +			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
> +				    task_pid_nr(current));
> +
> +		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
>  	}
>  
>  	return val;

Sure. With that, it would make sense for the trapped LOR* register
accesses to UNDEF, as they logically shouldn't exist.

[...]

> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 50a43c7b97ca..67b10b7a07bf 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -175,6 +175,17 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >  		return read_zero(vcpu, p);
> >  }
> >  
> > +static bool trap_raz_ro(struct kvm_vcpu *vcpu,
> > +			struct sys_reg_params *p,
> > +			const struct sys_reg_desc *r)
> > +{
> > +	if (!p->is_write)
> > +		return read_zero(vcpu, p);
> > +
> > +	kvm_inject_undefined(vcpu);
> > +	return false;
> > +}
> > +
> 
> I'm a little unclear if this is stricly the right thing to do.  I can't
> seem to find anything specific about writes to this register (which has
> some text about RW fields but only specifies it can be *read* with an
> MRS instruction), so it seems to me that this should either be
> trap_raz_wi(), or call write_to_read_only() if we expect a write to
> undef at EL1 rather than trap to EL2.  On the other hand, if the
> architecture is unclear, then we're at least enforcing one
> interpretation here I suppose.

Having looked at the ARM ARM, I think write_to_read_only() is the right
thing to do.

It's not clear to me whether HCR_EL2.TLOR traps writes to LORID_EL1, or
leaves these UNDEFINED at EL1. In the description of traps and enables
it's stated that HCR_EL2.TLOR traps "Non-secure accesses to this
register from EL1", which could be read to mean either. I'll see if I
can get to the bottom of that.

I don't think trap_raz_wi(), as LORID_EL1 is never RW at EL1, and a
write wound UNDEF were HCR_EL2.TLOR clear.

Thanks,
Mark.
