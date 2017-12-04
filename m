From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 23/37] KVM: arm64: Prepare to handle traps on deferred VM
 sysregs
Date: Mon, 4 Dec 2017 11:05:47 +0100
Message-ID: <20171204100547.xe6yetr73luw356z@hawk.localdomain>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-24-christoffer.dall@linaro.org>
 <20171113175402.rw3on4vps2o24q4d@hawk.localdomain>
 <20171203195026.GI4218@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171203195026.GI4218@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Dec 03, 2017 at 08:50:26PM +0100, Christoffer Dall wrote:
> On Mon, Nov 13, 2017 at 06:54:02PM +0100, Andrew Jones wrote:
...
> > > +	}
> > > +
> > > +	vcpu_sys_reg(vcpu, reg) = val;
> > > +}
> > > +
> > >  /*
> > >   * Generic accessor for VM registers. Only called as long as HCR_TVM
> > > + *

just noticed this stray blank line added here

> > >   * is set. If the guest enables the MMU, we stop trapping the VM
> > >   * sys_regs and leave it in complete control of the caches.
> > >   */
> > > @@ -132,14 +182,14 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
> > >  	if (!p->is_aarch32 || !p->is_32bit) {
> > >  		val = p->regval;
> > >  	} else {
> > > -		val = vcpu_sys_reg(vcpu, reg);
> > > +		val = read_deferrable_vm_reg(vcpu, reg);
> > >  		if (r->reg % 2)
> > >  			val = (p->regval << 32) | (u64)lower_32_bits(val);
> > >  		else
> > >  			val = ((u64)upper_32_bits(val) << 32) |
> > >  				(u64)lower_32_bits(p->regval);
> > >  	}
> > > -	vcpu_sys_reg(vcpu, reg) = val;
> > > +	write_deferrable_vm_reg(vcpu, reg, val);
> > >  
> > >  	kvm_toggle_cache(vcpu, was_enabled);
> > >  	return true;
> > > -- 
> > > 2.9.0
> > >
> > 
> > I read ahead and see other wrappers that check sysregs_loaded_on_cpu are
> > added, but only write_deferrable_vm_reg() has 'deferrable' in its name.
> > Should it just be named read/write_vm_reg?
> > 
> 
> I chose this name to avoid implying that this function was universally
> supported for all (current and future) VM registers.

OK

Thanks,
drew
