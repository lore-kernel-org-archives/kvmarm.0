From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 05/19] KVM: arm/arm64: Check that system supports
 split eoi/deactivate
Date: Tue, 1 Aug 2017 14:26:11 +0200
Message-ID: <20170801122611.GE5176@cbox>
References: <20170717142718.13853-1-cdall@linaro.org>
 <20170717142718.13853-6-cdall@linaro.org>
 <3ca8bc15-b5e7-abf7-78cc-9bbc5332c267@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ca8bc15-b5e7-abf7-78cc-9bbc5332c267@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 01, 2017 at 12:35:23PM +0100, Marc Zyngier wrote:
> On 17/07/17 15:27, Christoffer Dall wrote:
> > Some systems without proper firmware and/or hardware description data
> > don't support the split EOI and deactivate operation.
> > 
> > On such systems, we cannot leave the physical interrupt active after the
> > timer handler on the host has run, so we cannot support KVM with an
> > in-kernel GIC with the timer changes we about to introduce.
> > 
> > This patch makes sure that trying to initialize the KVM GIC code will
> > fail on such systems.
> > 
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  drivers/irqchip/irq-gic.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> > index 090991f..b7e4fed 100644
> > --- a/drivers/irqchip/irq-gic.c
> > +++ b/drivers/irqchip/irq-gic.c
> > @@ -1391,7 +1391,8 @@ int gic_of_init_child(struct device *dev, struct gic_chip_data **gic, int irq)
> >  	return 0;
> >  }
> >  
> > -static void __init gic_of_setup_kvm_info(struct device_node *node)
> > +static void __init gic_of_setup_kvm_info(struct device_node *node,
> > +					 bool supports_deactivate)
> 
> Ouch, nasty. This shadows the static key which is also called
> supports_deactivate...
> 

oh, yeah, that's a trap waiting to happen.

> >  {
> >  	int ret;
> >  	struct resource *vctrl_res = &gic_v2_kvm_info.vctrl;
> > @@ -1411,6 +1412,9 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
> >  	if (ret)
> >  		return;
> >  
> > +	if (!supports_deactivate)
> > +		return;
> > +
> >  	gic_set_kvm_info(&gic_v2_kvm_info);
> 
> Speaking of which, the static key should already be initialized, so this
> could actually read:
> 
> 	if (static_key_true(&supports_deactivate))
> 		gic_set_kvm_info(&gic_v2_kvm_info);
> 
> >  }
> >  
> > @@ -1419,6 +1423,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
> >  {
> >  	struct gic_chip_data *gic;
> >  	int irq, ret;
> > +	bool has_eoimode;
> >  
> >  	if (WARN_ON(!node))
> >  		return -ENODEV;
> > @@ -1436,7 +1441,8 @@ gic_of_init(struct device_node *node, struct device_node *parent)
> >  	 * Disable split EOI/Deactivate if either HYP is not available
> >  	 * or the CPU interface is too small.
> >  	 */
> > -	if (gic_cnt == 0 && !gic_check_eoimode(node, &gic->raw_cpu_base))
> > +	has_eoimode = gic_check_eoimode(node, &gic->raw_cpu_base);
> > +	if (gic_cnt == 0 && !has_eoimode)
> >  		static_key_slow_dec(&supports_deactivate);
> >  
> >  	ret = __gic_init_bases(gic, -1, &node->fwnode);
> > @@ -1447,7 +1453,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
> >  
> >  	if (!gic_cnt) {
> >  		gic_init_physaddr(node);
> > -		gic_of_setup_kvm_info(node);
> > +		gic_of_setup_kvm_info(node, has_eoimode);
> >  	}
> >  
> >  	if (parent) {
> > 
> 
> and we shouldn't need any of this. What do you think?
> 

I wasn't exactly sure if gic_cnt > 0 && !gic_check_eiomode() could then
end up registering the KVM info when we shouldn't.

If that's not a concern, I'm happy to rework this.

Thanks,
-Christoffer
