From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 06/10] VFIO: platform: add irq bypass producer
 management
Date: Mon, 17 Aug 2015 17:51:49 +0200
Message-ID: <55D20315.9000008@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>	
 <1439212864-12954-7-git-send-email-eric.auger@linaro.org>
 <1439405812.4023.530.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6235C683
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 11:39:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FK-b6q6D75Y3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2015 11:39:15 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1295C5C67E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 11:39:14 -0400 (EDT)
Received: by wibhh20 with SMTP id hh20so84973715wib.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 08:52:34 -0700 (PDT)
In-Reply-To: <1439405812.4023.530.camel@redhat.com>
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

Hi Alex,
On 08/12/2015 08:56 PM, Alex Williamson wrote:
> On Mon, 2015-08-10 at 15:21 +0200, Eric Auger wrote:
>> This patch populates the IRQ bypass callacks:
>> - stop/start producer simply consist in disabling/enabling the host irq
>> - add/del consumer: basically set the automasked flag to false/true
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>> v2 -> v3:
>> - vfio_platform_irq_bypass_add_consumer now returns an error in case
>>   the IRQ is recognized as active
>> - active boolean not set anymore
>> - do not VFIO mask the IRQ anymore on unforward
>>
>> v1 -> v2:
>> - device handle caching in vfio_platform_device is introduced in a
>>   separate patch
>> - use container_of
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c | 23 ++++++++++++++++++++++-
>>  1 file changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index efaee58..400a188 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -224,23 +224,44 @@ static int vfio_platform_is_active(struct vfio_platform_irq *irq)
>>  
>>  static void vfio_platform_irq_bypass_stop(struct irq_bypass_producer *prod)
>>  {
>> +	disable_irq(prod->irq);
>>  }
>>  
>>  static void vfio_platform_irq_bypass_start(struct irq_bypass_producer *prod)
>>  {
>> +	enable_irq(prod->irq);
>>  }
>>  
>>  static int vfio_platform_irq_bypass_add_consumer(
>>  			struct irq_bypass_producer *prod,
>>  			struct irq_bypass_consumer *cons)
>>  {
>> -	return 0;
>> +	struct vfio_platform_irq *irq =
>> +		container_of(prod, struct vfio_platform_irq, producer);
>> +
>> +	/*
>> +	 * if the IRQ is active at irqchip level or VFIO (auto)masked
>> +	 * this means the host IRQ is already under injection in the
>> +	 * guest and this not safe to change the forwarding state at
>> +	 * that stage.
>> +	 * It is not possible to differentiate user-space masking
>> +	 * from auto-masking, leading to possible false detection of
>> +	 * active state.
>> +	 */
>> +	if (vfio_platform_is_active(irq))
>> +		return -EAGAIN;
> 
> Here's an example of why we don't want WARN_ON if a registration fails,
> this is effectively random.  When and how is a re-try going to happen?
To be honest I did not intend to implement any retry mechanism. I rather
intended to change the user-side which currently is not adapted to that
start-up. Typically with current QEMU code we have this 2 phase IRQ
signal startup, first set up eventfd signaling, then VFIO mask, then
turn irqfd on. With such sequence forwarding setup will fail because the
IRQ is seen as masked (false detection of activity).

Do you mandate such a retry mechanism? If forwarding fails we resort on
standard irqfd ...

I think forwarding setup should be as much static as possible (I think
this opinion also is shared by Marc?).

Please let me know your opinion on this.

Best Regards

Eric

> 
>> +
>> +	return vfio_platform_set_automasked(irq, false);
> 
> set_forwarded just seems so much more logical here.
> 
>>  }
>>  
>>  static void vfio_platform_irq_bypass_del_consumer(
>>  			struct irq_bypass_producer *prod,
>>  			struct irq_bypass_consumer *cons)
>>  {
>> +	struct vfio_platform_irq *irq =
>> +		container_of(prod, struct vfio_platform_irq, producer);
>> +
>> +	vfio_platform_set_automasked(irq, true);
>>  }
>>  
>>  static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
> 
> 
> 
