From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 43/59] KVM: arm/arm64: GICv4: Unmap VLPI when freeing
 an LPI
Date: Wed, 30 Aug 2017 12:03:51 +0100
Message-ID: <c02319d5-cd05-634f-60ce-e4570ebed770@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-44-marc.zyngier@arm.com> <20170828181808.GC24649@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170828181808.GC24649@cbox>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 28/08/17 19:18, Christoffer Dall wrote:
> On Mon, Jul 31, 2017 at 06:26:21PM +0100, Marc Zyngier wrote:
>> When freeing an LPI (on a DISCARD command, for example), we need
>> to unmap the VLPI down to the physical ITS level.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 40aeadef33fe..79bac93d3e7d 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -623,8 +623,12 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
>>  	list_del(&ite->ite_list);
>>  
>>  	/* This put matches the get in vgic_add_lpi. */
>> -	if (ite->irq)
>> +	if (ite->irq) {
>> +		if (ite->irq->hw)
>> +			its_unmap_vlpi(ite->irq->host_irq);
> 
> nit: should we raise a warning on a bad return value?

I guess we could. Getting an error here is am indication that something
has gone wrong...

> Otherwise:
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>
Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
