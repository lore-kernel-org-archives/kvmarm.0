From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: VGIC: limit ITARGETSR bits to number of
 VCPUs
Date: Tue, 15 Nov 2016 15:34:37 +0000
Message-ID: <06bef5c6-1a12-ed13-3bc6-3e9d98a71bee@arm.com>
References: <20161115142749.19955-1-andre.przywara@arm.com>
 <061bf473-4597-22fe-664a-b83dbe6b39e1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAAE40190
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2016 10:33:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qSCSrFdWbBVZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2016 10:33:30 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CBD74011D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2016 10:33:29 -0500 (EST)
In-Reply-To: <061bf473-4597-22fe-664a-b83dbe6b39e1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 15/11/16 14:41, Marc Zyngier wrote:
> Hi Andre,
> 
> On 15/11/16 14:27, Andre Przywara wrote:
>> The GICv2 spec says in section 4.3.12 that a "CPU targets field bit that
>> corresponds to an unimplemented CPU interface is RAZ/WI."
>> Currently we allow the guest to write any value in there and it can
>> read that back.
>> Mask the written value with the proper CPU mask to be spec compliant.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index b44b359..e59d4c7 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -129,6 +129,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>>  				   unsigned long val)
>>  {
>>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
>> +	u8 cpu_mask = (1 << atomic_read(&vcpu->kvm->online_vcpus)) - 1;
> 
> For the sake of avoiding open-coding things, how about using GENMASK?

Yes.

> 
>>  	int i;
>>  
>>  	/* GICD_ITARGETSR[0-7] are read-only */
>> @@ -141,7 +142,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>>  
>>  		spin_lock(&irq->irq_lock);
>>  
>> -		irq->targets = (val >> (i * 8)) & 0xff;
>> +		irq->targets = ((val >> (i * 8)) & 0xff) & cpu_mask;
> 
> Can't you just drop the '& 0xff' part, since cpu_mask is guaranteed to
> be more restrictive?

Well, and also irq->targets is an u8 ...

Fixed both.

Thanks!
Andre.

>>  		target = irq->targets ? __ffs(irq->targets) : 0;
>>  		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
>>  
>>
> 
> Thanks,
> 
> 	M.
> 
