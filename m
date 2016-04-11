From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH 20/45] KVM: arm/arm64: vgic-new: Add TARGET registers
 handlers
Date: Mon, 11 Apr 2016 13:10:24 +0100
Message-ID: <570B9430.2040305@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-21-git-send-email-andre.przywara@arm.com>
 <20160331113126.GZ4126@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABD3F4053F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:08:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9MIH3UK6a6fD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 08:08:36 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12E34011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:08:35 -0400 (EDT)
In-Reply-To: <20160331113126.GZ4126@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 31/03/16 12:31, Christoffer Dall wrote:
> On Fri, Mar 25, 2016 at 02:04:43AM +0000, Andre Przywara wrote:
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic_mmio.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 42 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
>> index 76657ce..cde153f 100644
>> --- a/virt/kvm/arm/vgic/vgic_mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
>> @@ -471,6 +471,47 @@ static int vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>>  	return 0;
>>  }
>>  
>> +static int vgic_mmio_read_target(struct kvm_vcpu *vcpu,
>> +				 struct kvm_io_device *this,
>> +				 gpa_t addr, int len, void *val)
>> +{
>> +	struct vgic_io_device *iodev = container_of(this,
>> +						    struct vgic_io_device, dev);
>> +	u32 intid = (addr - iodev->base_addr);
>> +	int i;
>> +
>> +	if (iodev->redist_vcpu)
>> +		vcpu = iodev->redist_vcpu;
>> +
>> +	for (i = 0; i < len; i++) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		((u8 *)val)[i] = irq->targets;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>> +				  struct kvm_io_device *this,
>> +				  gpa_t addr, int len, const void *val)
>> +{
>> +	struct vgic_io_device *iodev = container_of(this,
>> +						    struct vgic_io_device, dev);
>> +	u32 intid = (addr - iodev->base_addr);
>> +	int i;
>> +
>> +	/* GICD_ITARGETSR[0-7] are read-only */
>> +	if (intid < VGIC_NR_PRIVATE_IRQS)
>> +		return 0;
>> +
>> +	for (i = 0; i < len; i++)
>> +		vgic_v2_irq_change_affinity(vcpu->kvm, intid + i,
>> +					    ((u8 *)val)[i]);
>> +
>> +	return 0;
>> +}
>> +
> 
> these functions are v2 specific but are in a generic file and are not
> named anything specific to v2?

Well, technically the target register is still defined for the GICv3
distributor, but just RES0 if affinity routing is enabled.
But I can of course easily add a _v2_ in here.

While I look at the function, it makes me wonder if the abstraction for
the affinity change call is actually correct at all. In contrast to the
other vgic_v<n>_* functions this one is about the _emulated_ VGIC model,
not the hardware GIC version.
Also we actually only have this one user here, the other call is about
initializing the affinity setting, for which this function is really
overkill.
So what about we move the content of the change_affinity function in
here (same for the v3 case later), and tackle the init case separately
(which is trivial)?

Cheers,
Andre.

> 
>>  struct vgic_register_region vgic_v2_dist_registers[] = {
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
>> @@ -491,7 +532,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>>  		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
>> +		vgic_mmio_read_target, vgic_mmio_write_target, 8),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
>>  		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
>> -- 
>> 2.7.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
