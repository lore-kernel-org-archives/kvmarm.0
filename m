From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 05/10] VFIO: platform: add vfio_platform_is_active
Date: Mon, 17 Aug 2015 17:39:57 +0200
Message-ID: <55D2004D.9010401@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>	 <1439212864-12954-6-git-send-email-eric.auger@linaro.org> <1439405805.4023.529.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439405805.4023.529.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/2015 08:56 PM, Alex Williamson wrote:
> On Mon, 2015-08-10 at 15:20 +0200, Eric Auger wrote:
>> This function returns whether the IRQ is active at irqchip level or
>> VFIO masked. If either is true, it is considered the IRQ is active.
>> Currently there is no way to differentiate userspace masked IRQ from
>> automasked IRQ. There might be false detection of activity. However
>> it is currently acceptable to have false detection.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index a285384..efaee58 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -205,6 +205,23 @@ static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
>>  	return 0;
>>  }
>>  
>> +static int vfio_platform_is_active(struct vfio_platform_irq *irq)
> 
> vfio_platform_irq_is_active()?
OK
> 
>> +{
>> +	unsigned long flags;
>> +	bool active, masked, outstanding;
>> +	int ret;
>> +
>> +	spin_lock_irqsave(&irq->lock, flags);
>> +
>> +	ret = irq_get_irqchip_state(irq->hwirq, IRQCHIP_STATE_ACTIVE, &active);
>> +	BUG_ON(ret);
> 
> Why can't we propagate this error to the caller and let them decide?
sure

Eric
> 
>> +	masked = irq->masked;
>> +	outstanding = active || masked;
>> +
>> +	spin_unlock_irqrestore(&irq->lock, flags);
>> +	return outstanding;
>> +}
>> +
>>  static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
>>  {
>>  }
> 
> 
> 
