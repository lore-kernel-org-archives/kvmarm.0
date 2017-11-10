From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 16/26] KVM: arm/arm64: GICv4: Propagate property
 updates to VLPIs
Date: Fri, 10 Nov 2017 08:58:18 +0000
Message-ID: <ad882c6d-8a7b-3291-ef5d-9e6889d39038@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-17-marc.zyngier@arm.com>
 <6763d90f-93bf-ddbb-d456-5979b8870aa2@redhat.com>
 <49bff080-0908-cc7a-7036-543f963180a5@arm.com> <20171110083755.GI14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4FFA49D09
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:56:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EYKL1Pzhrw2M for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Nov 2017 03:56:19 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CEA740FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Nov 2017 03:56:19 -0500 (EST)
In-Reply-To: <20171110083755.GI14144@cbox>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/11/17 08:37, Christoffer Dall wrote:
> On Wed, Nov 08, 2017 at 03:08:36PM +0000, Marc Zyngier wrote:
>> On 07/11/17 21:28, Auger Eric wrote:
>>> Hi Marc,
>>>
>>> On 27/10/2017 16:28, Marc Zyngier wrote:
>>>> Upon updating a property, we propagate it all the way to the physical
>>>> ITS, and ask for an INV command to be executed there.
>>>>
>>>> Acked-by: Christoffer Dall <cdall@linaro.org>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-its.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>> index 0b7e648e7a0c..2e77c7c83942 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>> @@ -296,6 +296,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>>>  		spin_unlock(&irq->irq_lock);
>>>>  	}
>>>>  
>>>> +	if (irq->hw)
>>>> +		return its_prop_update_vlpi(irq->host_irq, prop, true);
>>>> +
>>>>  	return 0;
>>>>  }
>>> I am confused by the vgic_queue_irq_unlock() on the "hw" path. Why is it
>>> needed in hw mode?
>>
>> It's not. I guess we could bypass this altogether and take a short cut
>> after having updated the priority and enabled fields.
>>
> 
> I can apply this on top of the series as well if you're happy with it:
> 
> commit b54fba93b1330803a59ca75f3a5102e22cadc871 (HEAD -> next-gicv4)
> Author: Christoffer Dall <christoffer.dall@linaro.org>
> Date:   Fri Nov 10 09:34:54 2017 +0100
> 
>     KVM: arm/arm64: Don't queue VLPIs on INV/INVALL
>     
>     Since VLPIs are injected directly by the hardware there's no need to
>     mark these as pending in software and queue them on the AP list.
>     
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index c93ecd4a903b..a3754ec719c4 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -292,11 +292,14 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  		irq->priority = LPI_PROP_PRIORITY(prop);
>  		irq->enabled = LPI_PROP_ENABLE_BIT(prop);
>  
> -		vgic_queue_irq_unlock(kvm, irq, flags);
> -	} else {
> -		spin_unlock_irqrestore(&irq->irq_lock, flags);
> +		if (!irq->hw) {
> +			vgic_queue_irq_unlock(kvm, irq, flags);
> +			return 0;
> +		}
>  	}
>  
> +	spin_unlock_irqrestore(&irq->irq_lock, flags);
> +
>  	if (irq->hw)
>  		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
>  

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
