From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/6] irqchip: GIC: Convert to EOImode == 1
Date: Wed, 12 Aug 2015 18:40:14 +0100
Message-ID: <20150812174014.GG5393@e104818-lin.cambridge.arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-3-git-send-email-marc.zyngier@arm.com>
 <55C9BD24.10708@linaro.org>
 <55CB4AC3.6040400@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55CB4AC3.6040400@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 12, 2015 at 02:31:47PM +0100, Marc Zyngier wrote:
> On 11/08/15 10:15, Eric Auger wrote:
> > On 07/09/2015 03:19 PM, Marc Zyngier wrote:
> >>  static int gic_irq_set_irqchip_state(struct irq_data *d,
> >> @@ -272,11 +278,15 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
> >>  		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
> >>  
> >>  		if (likely(irqnr > 15 && irqnr < 1021)) {
> > shouldn't we have < 1020?
> 
> Looks like you have unearthed a very long standing (though not fatal)
> bug - I can trace it back to 2005 and the inclusion of the Realview
> support (see include/asm-arm/arch-realview/entry-macro.S in 8ad68bbf for
> the details).
> 
> It may be that the original GIC didn't make number 1020 a special one,
> though the earliest spec I have access to (GICv1) is already making 1020
> a reserved interrupt number. And looking at the pre-existing code
> (arch/arm/common/gic.c), 1020 seems to already be considered an invalid
> number.
> 
> CC-ing Catalin, as he was the one who introduced it... ;-) Unless he
> says otherwise, I'll cook a patch for that.

I really have no idea where it came from. The code probably pre-dates
the existence of a GIC architecture spec (the GIC spec used to be part
of the board or CPU TRM).

I don't see any problem with using 1020 here.

-- 
Catalin
