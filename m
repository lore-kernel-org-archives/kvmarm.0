From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 04/10] VFIO: platform: add vfio_platform_set_automasked
Date: Mon, 17 Aug 2015 17:38:16 +0200
Message-ID: <55D1FFE8.9050104@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>	
 <1439212864-12954-5-git-send-email-eric.auger@linaro.org>
 <1439405794.4023.528.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 778A35C6B7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 11:25:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ahywNLiUeS2T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2015 11:25:45 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 455D75C6B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 11:25:43 -0400 (EDT)
Received: by wijp15 with SMTP id p15so78221406wij.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 08:39:02 -0700 (PDT)
In-Reply-To: <1439405794.4023.528.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/2015 08:56 PM, Alex Williamson wrote:
> On Mon, 2015-08-10 at 15:20 +0200, Eric Auger wrote:
>> This function makes possible to change the automasked mode.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v1 -> v2:
>> - set forwarded flag
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index b31b1f0..a285384 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -186,6 +186,25 @@ static irqreturn_t vfio_handler(int irq, void *dev_id)
>>  	return ret;
>>  }
>>  
>> +static int vfio_platform_set_automasked(struct vfio_platform_irq *irq,
>> +					   bool automasked)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&irq->lock, flags);
>> +	if (automasked) {
>> +		irq->forwarded = true;
>> +		irq->flags |= VFIO_IRQ_INFO_AUTOMASKED;
>> +		irq->handler = vfio_automasked_irq_handler;
>> +	} else {
>> +		irq->forwarded = false;
>> +		irq->flags &= ~VFIO_IRQ_INFO_AUTOMASKED;
>> +		irq->handler = vfio_irq_handler;
>> +	}
>> +	spin_unlock_irqrestore(&irq->lock, flags);
>> +	return 0;
> 
> In vfio-speak, automasked means level and we're not magically changing
> the IRQ from level to edge, we're simply able to handle level
> differently based on a hardware optimization.  Should the user visible
> flags therefore change based on this?  Aren't we really setting the
> forwarded state rather than the automasked state?

Well actually this was following the discussion we had a long time ago
about that topic:

http://lkml.iu.edu/hypermail/linux/kernel/1409.1/03659.html

I did not really know how to conclude ...

If it is preferred I can hide this to the userspace, no problem.

Eric


> 
>> +}
>> +
>>  static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
>>  {
>>  }
> 
> 
> 
