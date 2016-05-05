From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 16/54] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Thu, 5 May 2016 10:44:26 -0600
Message-ID: <572B786A.7040705@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-17-git-send-email-andre.przywara@arm.com>
 <572B7384.2050405@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <572B7384.2050405@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/05/2016 10:23 AM, Tom Hanson wrote:
> On 04/28/2016 10:45 AM, Andre Przywara wrote:
>
> ...
>
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 4fb20fd..a656a12e5 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>
> ...
>> +static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>> +{
>
> ...
>
>> +        /* This interrupt looks like it has to be migrated. */
>> +
>> +        spin_unlock(&irq->irq_lock);
>> +        spin_unlock(&vgic_cpu->ap_list_lock);
>
> If using the suggested (but not provided) higher level function from patch 14 this could be:
>                  vgic_unlock_aplist_irq(, spinlock_t irq);

Oh, bother.  That should be:
             vgic_unlock_aplist_irq(vgic_cpu->ap_list_lock, irq->irq_lock);
