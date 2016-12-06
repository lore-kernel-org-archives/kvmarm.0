From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm/arm64: KVM: Check for properly initialized timer on
 init
Date: Tue, 6 Dec 2016 20:56:52 +0100
Message-ID: <20161206195652.GF4816@cbox>
References: <20161205093211.11870-1-christoffer.dall@linaro.org>
 <1ed187ba-965b-6087-f74f-68627f0d0504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ed187ba-965b-6087-f74f-68627f0d0504@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 06, 2016 at 11:25:42AM +0000, Marc Zyngier wrote:
> On 05/12/16 09:32, Christoffer Dall wrote:
> > When the arch timer code fails to initialize (for example because the
> > memory mapped timer doesn't work, which is currently seen with the AEM
> > model), then KVM just continues happily with a final result that KVM
> > eventually does a NULL pointer dereference of the uninitialized cycle
> > counter.
> > 
> > Check directly for this in the init path and give the user a reasonable
> > error in this case.
> > 
> > Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/arch_timer.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index 27a1f63..5c12f53 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -425,6 +425,11 @@ int kvm_timer_hyp_init(void)
> >  	info = arch_timer_get_kvm_info();
> >  	timecounter = &info->timecounter;
> >  
> > +	if (!timecounter->cc) {
> > +		kvm_err("arch_timer: uninitialized timecounter\n");
> 
> For consistency, I'll change the error message to say "kvm_arch_timer",
> just like the below case.
> 

No objections, only problem is that the patch you queued uses
kcm_arch_timer ;)

> > +		return -ENODEV;
> > +	}
> > +
> >  	if (info->virtual_irq <= 0) {
> >  		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
> >  			info->virtual_irq);
> > 
> 
> Otherwise looks good to me. I'll queue it now.
> 

Thanks,
-Christoffer
