From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] KVM: arm64: Implement accessors for vGIC CPU
 interface registers
Date: Mon, 31 Aug 2015 11:03:21 +0200
Message-ID: <20150831090321.GK24113@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
 <2857f7cad7c17109dfa3028f79af28893c0171ce.1440766141.git.p.fedin@samsung.com>
 <20150830165015.GE24113@cbox>
 <CAFEAcA_+Q+byqn4=ByRZ_EtJ2LzF8dj1ac52R_MPbmJkDLSjhA@mail.gmail.com>
 <014001d0e3c0$b9d6ea40$2d84bec0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <014001d0e3c0$b9d6ea40$2d84bec0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, 'kvm-devel' <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 31, 2015 at 10:43:27AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > > I had imagined we would encode the GICv3 register accesses through the
> > > device API and not through the system register API, since I'm not crazy
> > > about polluting the general system register handling logic with GIC
> > > registers solely for the purposes of migration.
> > 
> > There's an interesting design question lurking under this
> > about the extent to which you expose the h/w design split
> > between the CPU interface and the GIC proper as part of the
> > KVM APIs.
> 
>  I could split up handling logic from access logic. So that in sys_regs.c we would have something like:
> 
> static bool access_gic_ctlr(struct kvm_vcpu *vcpu,
> 			    const struct sys_reg_params *p,
> 			    const struct sys_reg_desc *r)
> {
> 	return vgicv3_access_ctlr(vcpu, vcpu_reg(vcpu, p->Rt), p->is_write);
> }
> 
>  And in vgic-v3-emul.c we would have the handler itself with the prototype:
> 
> bool vgicv3_access_ctlr(struct kvm_vcpu *vcpu, u64 *val, bool write);
> 
>  Would this be OK?
>  In my personal opinion system register access API fits perfectly well for this task, because after all these are system registers. And implementing this as device attribute would, i guess, give no difference from code's point of view. We would have to encode system register numbers into attribute, then perform table lookup, actually duplicating our system register access code. Does it worth that?
> 
I think it's worth moving the thing to device attributes, yes,
especially given that I never expect us to trap and emulate GICv3 system
register accesses from a guest in KVM.  Is that correct?

However, if there's a strong argument that this is really CPU state and
not state associated with the GIC device, I'd be willing to reconsider.

-Christoffer
