From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 3/6] irqchip: GICv3: Skip LPI deactivation
Date: Wed, 12 Aug 2015 16:28:59 +0200
Message-ID: <55CB582B.50007@linaro.org>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com> <1436447951-22357-4-git-send-email-marc.zyngier@arm.com> <55C9C39A.3060208@linaro.org> <55CB4B82.9060601@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55CB4B82.9060601@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Jiang Liu <jiang.liu@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/2015 03:34 PM, Marc Zyngier wrote:
> On 11/08/15 10:42, Eric Auger wrote:
>> On 07/09/2015 03:19 PM, Marc Zyngier wrote:
>>> Contrary to other GICv3 interrupts, LPIs do not have an active state
>>> by virtue of being edge-triggered only (they only have a pending state).
>>>
>>> Given this, there is no point trying to deactivate them, and we can
>>> skip the ICC_DIR_EL1 entierely.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  drivers/irqchip/irq-gic-v3.c | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>> index 49768fc..e02592b 100644
>>> --- a/drivers/irqchip/irq-gic-v3.c
>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>> @@ -295,10 +295,14 @@ static int gic_irq_get_irqchip_state(struct irq_data *d,
>>>  
>>>  static void gic_eoi_irq(struct irq_data *d)
>>>  {
>>> -	if (static_key_true(&supports_deactivate))
>>> +	if (static_key_true(&supports_deactivate)) {
>>> +		/* No need to deactivate an LPI */
>>> +		if (gic_irq(d) >= 8192)
>> In case of EOIMode == 0, we do not call EOI. I can't understand whether
>> it is an issue.
> 
> What do you mean? We definitely perform an EOI in both EOImodes...
> 
>> In 4.8.3 Properties of LPI, in 2d note it is written:
>>
>> "SW must issue a write to EOI to clear the active priorities register,
>> hence the CPU interface still requires an active state for LPIs, even
>> through this is not necessary within the redistributor"
>>
>> Eric
>>> +			return;
>>>  		gic_write_dir(gic_irq(d));
>>> -	else
>>> +	} else {
>>>  		gic_write_eoir(gic_irq(d));
> 
> ... right here.
> 
> Of am I missing something completely obvious?
yes sorry please forget this. I think I meant EOImode == 1 instead and
anyway the EOI is done in gic_handle_irq.

Apologies

Eric
> 
> Thanks,
> 
> 	M.
> 

