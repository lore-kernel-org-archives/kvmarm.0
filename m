From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 17/33] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Mon, 19 Jun 2017 15:52:57 +0100
Message-ID: <6355cf70-dd8d-f8b0-7861-a32bc6007647@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
 <a5783b6c-8276-0bc3-227d-7bf74465dae8@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a5783b6c-8276-0bc3-227d-7bf74465dae8@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shankerd@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 13/02/17 23:07, Shanker Donthineni wrote:
> 
> 
> On 01/17/2017 04:20 AM, Marc Zyngier wrote:
>> Add the skeleton irq_set_vcpu_affinity method that will be used
>> to configure VLPIs.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c | 33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 0dbc8b0..1bd78ca 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -36,6 +36,7 @@
>>   
>>   #include <linux/irqchip.h>
>>   #include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/irqchip/arm-gic-v4.h>
>>   
>>   #include <asm/cputype.h>
>>   #include <asm/exception.h>
>> @@ -771,6 +772,37 @@ static int its_irq_set_irqchip_state(struct irq_data
>> *d,
>>   	return 0;
>>   }
>>   
>> +static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>> +{
>> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_info *info = vcpu_info;
>> +	u32 event = its_get_event_id(d);
>> +
>> +	/* Need a v4 ITS */
>> +	if (!its_dev->its->is_v4 || !info)
>> +		return -EINVAL;
>> +
>> +	switch (info->cmd_type) {
>> +	case MAP_VLPI:
>> +	{
>> +		return 0;
>> +	}
>> +
>> +	case UNMAP_VLPI:
>> +	{
>> +		return 0;
>> +	}
>> +
>> +	case PROP_UPDATE_VLPI:
>> +	{
>> +		return 0;
>> +	}
>> +
>> +	default:
>> +		return -EINVAL;
>> +	}
> Missing a return statement.

What's wrong with this default: statement?

	M.
-- 
Jazz is not dead. It just smells funny...
