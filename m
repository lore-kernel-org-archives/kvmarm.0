From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 01/45] KVM: arm/arm64: add missing MMIO data
 write-back
Date: Tue, 5 Apr 2016 14:58:30 +0200
Message-ID: <20160405125830.GA16004@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-2-git-send-email-andre.przywara@arm.com>
 <20160329123308.GC4126@cbox>
 <5703AB94.1080206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5703AB94.1080206@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@st.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 05, 2016 at 01:12:04PM +0100, Andre Przywara wrote:
> On 29/03/16 13:33, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:24AM +0000, Andre Przywara wrote:
> >> When the kernel was handling a guest MMIO access internally, we need
> >> to copy the emulation result into the run->mmio structure in order
> >> for the kvm_handle_mmio_return() function to pick it up and inject
> >> the result back into the guest.
> >> Currently the only user of kvm_io_bus for ARM is the VGIC, which did
> >> this copying itself, so this was not causing issues so far.
> >> But with upcoming kvm_io_bus users we need to do the copying here.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  arch/arm/kvm/mmio.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> >> index 0f6600f..d5c2727 100644
> >> --- a/arch/arm/kvm/mmio.c
> >> +++ b/arch/arm/kvm/mmio.c
> >> @@ -206,7 +206,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >>  	run->mmio.is_write	= is_write;
> >>  	run->mmio.phys_addr	= fault_ipa;
> >>  	run->mmio.len		= len;
> >> -	if (is_write)
> >> +	if (is_write || !ret)
> >>  		memcpy(run->mmio.data, data_buf, len);
> > 
> > I had a really hard time understanding this, how about this instead:
> 
> Admittedly this is the shortest possible fix. I also had a rework closer
> to your version, which also avoided copying the arguments in some cases,
> but I thought a smaller diff would be more suitable, since this is
> actually a fix.
> 
> Shall I add a comment here or post my version of the fix instead?
> 
Let me test what I have below more thoroughly and send that as a patch.

-Christoffer

> 
> > diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
> > index 0f6600f..0158e9e 100644
> > --- a/arch/arm/kvm/mmio.c
> > +++ b/arch/arm/kvm/mmio.c
> > @@ -87,11 +87,10 @@ static unsigned long mmio_read_buf(char *buf, unsigned int len)
> >  
> >  /**
> >   * kvm_handle_mmio_return -- Handle MMIO loads after user space emulation
> > + *			     or in-kernel IO emulation
> > + *
> >   * @vcpu: The VCPU pointer
> >   * @run:  The VCPU run struct containing the mmio data
> > - *
> > - * This should only be called after returning from userspace for MMIO load
> > - * emulation.
> >   */
> >  int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  {
> > @@ -206,18 +205,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  	run->mmio.is_write	= is_write;
> >  	run->mmio.phys_addr	= fault_ipa;
> >  	run->mmio.len		= len;
> > -	if (is_write)
> > -		memcpy(run->mmio.data, data_buf, len);
> >  
> >  	if (!ret) {
> >  		/* We handled the access successfully in the kernel. */
> > +		if (!is_write)
> > +			memcpy(run->mmio.data, data_buf, len);
> >  		vcpu->stat.mmio_exit_kernel++;
> >  		kvm_handle_mmio_return(vcpu, run);
> >  		return 1;
> > -	} else {
> > -		vcpu->stat.mmio_exit_user++;
> >  	}
> >  
> > +	if (is_write)
> > +		memcpy(run->mmio.data, data_buf, len);
> > +	vcpu->stat.mmio_exit_user++;
> >  	run->exit_reason	= KVM_EXIT_MMIO;
> >  	return 0;
> >  }
> > diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> > index 00429b3..63e99cb 100644
> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -850,12 +850,6 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
> >  		updated_state = false;
> >  	}
> >  	spin_unlock(&dist->lock);
> > -	run->mmio.is_write	= is_write;
> > -	run->mmio.len		= len;
> > -	run->mmio.phys_addr	= addr;
> > -	memcpy(run->mmio.data, val, len);
> > -
> > -	kvm_handle_mmio_return(vcpu, run);
> >  
> >  	if (updated_state)
> >  		vgic_kick_vcpus(vcpu->kvm);
> > 
> 
