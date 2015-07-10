From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 4/6] irqchip: GIC: Use chip_data instead of handler_data
 for cascaded interrupts
Date: Fri, 10 Jul 2015 16:17:16 +0800
Message-ID: <559F7F8C.8080701@linux.intel.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com> <1436447951-22357-5-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1507092331130.5134@nanos> <559F79C6.8020107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <559F79C6.8020107@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2015/7/10 15:52, Marc Zyngier wrote:
> On 09/07/15 22:33, Thomas Gleixner wrote:
>> On Thu, 9 Jul 2015, Marc Zyngier wrote:
>>
>>> When used as a primary interrupt controller, the GIC driver uses
>>> irq_data->chip_data to extract controller-specific information.
>>>
>>> When used as a secondary interrupt controller, it uses handler_data
>>> instead. As this difference is relatively pointless and only creates
>>> confusion, change the secondary path to match what the rest of the
>>> driver does.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  drivers/irqchip/irq-gic.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index e264675..3c7f3a4 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -298,7 +298,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>>>  
>>>  static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>>>  {
>>> -	struct gic_chip_data *chip_data = irq_get_handler_data(irq);
>>> +	struct gic_chip_data *chip_data = irq_get_chip_data(irq);
>>>  	struct irq_chip *chip = irq_get_chip(irq);
>>
>> You should make that
>>
>>     chip_data = irq_desc_get_chip_data(desc);
>>     chip = irq_desc_get_chip(desc);
>>
>> That avoids two pointless lookups of irqdesc ....
> 
> Ah, very good point.
> 
> And it turns out that these constructs (use of irq_get_* when the
> irq_desc is readily available) is actually fairly common in a number of
> irqchip implementations used as secondary interrupt controllers.
> 
> Time for another cleanup series, I believe... ;-)
Hi Marc,
	I'm ahead of your request and expect an reviewed-by from
you then:). Please refer to http://lkml.org/lkml/2015/6/4/743 for
what we have done to clear up this interfaces.
Thanks!
Gerry
