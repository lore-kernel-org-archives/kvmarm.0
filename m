From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 06/20] KVM: arm/arm64: Check that system supports split eoi/deactivate
Date: Wed, 18 Oct 2017 17:03:40 +0100
Message-ID: <874lqwjvdv.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-7-cdall@linaro.org>
        <edc875ee-335c-56c1-0cbc-9e45f7915529@arm.com>
        <20171018134145.GH8900@cbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171018134145.GH8900@cbox> (Christoffer Dall's message of "Wed,
        18 Oct 2017 15:41:45 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18 2017 at  3:41:45 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Oct 09, 2017 at 05:47:18PM +0100, Marc Zyngier wrote:
>> On 23/09/17 01:41, Christoffer Dall wrote:
>> > Some systems without proper firmware and/or hardware description data
>> > don't support the split EOI and deactivate operation.
>> > 
>> > On such systems, we cannot leave the physical interrupt active after the
>> > timer handler on the host has run, so we cannot support KVM with an
>> > in-kernel GIC with the timer changes we are about to introduce.
>> > 
>> > This patch makes sure that trying to initialize the KVM GIC code will
>> > fail on such systems.
>> > 
>> > Cc: Marc Zyngier <marc.zyngier@arm.com>
>> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
>> > ---
>> >  drivers/irqchip/irq-gic.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> > index f641e8e..ab12bf4 100644
>> > --- a/drivers/irqchip/irq-gic.c
>> > +++ b/drivers/irqchip/irq-gic.c
>> > @@ -1420,7 +1420,8 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
>> >  	if (ret)
>> >  		return;
>> >  
>> > -	gic_set_kvm_info(&gic_v2_kvm_info);
>> > +	if (static_key_true(&supports_deactivate))
>> > +		gic_set_kvm_info(&gic_v2_kvm_info);
>> >  }
>> >  
>> >  int __init
>> > 
>> 
>> Should we add the same level of checking on the ACPI path, just for the
>> sake symmetry?
>
> Yes, we should, if anyone is crazy enough to use ACPI :)

Sadly, the madness is becoming commonplace.

>> 
>> Also, do we need to add the same thing for GICv3?
>> 
>
> Why would split EOI/deactivate not be available on GICv3, actually?  It
> looks like this is not supported unless you have EL2, but I can't seem
> to find anything in the spec for this, and KVM should support
> EOI/deactivate for GICv3 guests I think.  Am I missing something?

No, you're not. This is just a Linux choice (or rather mine) not to use
EOImode=1 in guests (or anything booted at EL1), as we don't really need
the two-stage deactivate in that situation (it is pure overhead).

I'm just worried of potentially broken HW, and would like to make sure
that when we force EOImode=0 on these systems, we truly tell KVM about
it.

> Assuming I'm wrong about GICv3, which I probably am, how does this look
> (on top of the posted patch):
>
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 519149e..aed524c 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -1228,7 +1228,9 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
>  		goto out_unmap_rdist;
>  
>  	gic_populate_ppi_partitions(node);
> -	gic_of_setup_kvm_info(node);
> +
> +	if (static_key_true(&supports_deactivate))
> +		gic_of_setup_kvm_info(node);
>  	return 0;
>  
>  out_unmap_rdist:
> @@ -1517,7 +1519,9 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
>  		goto out_fwhandle_free;
>  
>  	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC, domain_handle);
> -	gic_acpi_setup_kvm_info();
> +
> +	if (static_key_true(&supports_deactivate))
> +		gic_acpi_setup_kvm_info();
>  
>  	return 0;
>  
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index ab12bf4..121af5c 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -1653,7 +1653,8 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>  	if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
>  		gicv2m_init(NULL, gic_data[0].domain);
>  
> -	gic_acpi_setup_kvm_info();
> +	if (static_key_true(&supports_deactivate))
> +		gic_acpi_setup_kvm_info();
>  
>  	return 0;
>  }

Yup, looks good to me!

	M.
-- 
Jazz is not dead, it just smell funny.
