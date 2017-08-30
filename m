From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 46/59] KVM: arm/arm64: GICv4: Handle MOVALL applied to
 a vPE
Date: Wed, 30 Aug 2017 15:46:12 +0100
Message-ID: <e4c02bf0-3852-2e3d-25a1-0fbac11f966a@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-47-marc.zyngier@arm.com> <20170828181827.GG24649@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170828181827.GG24649@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 28/08/17 19:18, Christoffer Dall wrote:
> On Mon, Jul 31, 2017 at 06:26:24PM +0100, Marc Zyngier wrote:
>> The current implementation of MOVALL doesn't allow us to call
>> into the core ITS code as we hold a number of spinlocks.
>>
>> Let's try a method used in other parts of the code, were we copy
>> the intids of the candicate interrupts, and then do whatever
>> we need to do with them outside of the critical section.
>>
>> This allows us to move the interrupts one by one, at the expense
>> of a bit of CPU time. Who cares? MOVALL is such a stupid command
>> anyway...
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 27 ++++++++++++++++++++-------
>>  1 file changed, 20 insertions(+), 7 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 2c065c970ba0..65cc77fde609 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1147,11 +1147,12 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>>  static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>  				      u64 *its_cmd)
>>  {
>> -	struct vgic_dist *dist = &kvm->arch.vgic;
>>  	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
>>  	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
>>  	struct kvm_vcpu *vcpu1, *vcpu2;
>>  	struct vgic_irq *irq;
>> +	u32 *intids;
>> +	int irq_count, i;
>>  
>>  	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
>>  	    target2_addr >= atomic_read(&kvm->online_vcpus))
>> @@ -1163,19 +1164,31 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>  	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
>>  	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
>>  
>> -	spin_lock(&dist->lpi_list_lock);
>> +	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
>> +	if (irq_count < 0)
>> +		return irq_count;
>>  
>> -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>> -		spin_lock(&irq->irq_lock);
>> +	for (i = 0; i < irq_count; i++) {
>> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
>> +		if (!irq)
>> +			continue;
> 
> Getting irq == NULL means that we've removed this LPI since
> vgic_copy_lpi_list, right?  Can this really happen while we hold the its
> mutex?

A disappearing LPI can only be the result of a DISCARD, which cannot
happen, as we indeed hold the ITS lock.

> Also, we don't check this in its_sync_lpi_pending_table which would
> indicate that we either have a bug there or are being overly careful
> here (or should change the continue to BUG).

Let's aim for consistency. I'll drop this test.

> 
> 
>>  
>>  		if (irq->target_vcpu == vcpu1)
>>  			irq->target_vcpu = vcpu2;
>>  
>> -		spin_unlock(&irq->irq_lock);
> 
> Is it safe to modify target_vcpu without holding the irq_lock?

Unintentional regression. I'll fix that. But I wonder if there is an
actual point in testing testing the target_vcpu here. Since we hold the
ITS lock, we're damn sure that the affinity can't be changed, right?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
