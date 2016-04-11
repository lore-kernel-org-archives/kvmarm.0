From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [RFC PATCH 24/45] KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR,
 TYPER handlers
Date: Mon, 11 Apr 2016 14:00:02 +0100
Message-ID: <570B9FD2.80907@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-25-git-send-email-andre.przywara@arm.com>
 <20160331115319.GD4126@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6877A40402
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7LFofz6h0dH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 08:58:14 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E6E4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:58:13 -0400 (EDT)
In-Reply-To: <20160331115319.GD4126@cbox>
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

Hi,

On 31/03/16 12:53, Christoffer Dall wrote:
> On Fri, Mar 25, 2016 at 02:04:47AM +0000, Andre Przywara wrote:
>> As in the GICv2 emulation we handle those three registers in one
>> function.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>>  virt/kvm/arm/vgic/vgic_mmio.c | 38 ++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 38 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 4b8952a..0db1abe 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -19,6 +19,8 @@
>>  #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
>>  #define IMPLEMENTER_ARM		0x43b
>>  
>> +#define INTERRUPT_ID_BITS_SPIS	10
>> +
>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  			      u32 intid);
>>  bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq);
>> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
>> index 2d10c06..13e101f 100644
>> --- a/virt/kvm/arm/vgic/vgic_mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
>> @@ -606,7 +606,29 @@ static int vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>  				  struct kvm_io_device *this,
>>  				  gpa_t addr, int len, void *val)
>>  {
>> -	/* TODO: implement */
>> +	struct vgic_io_device *iodev = container_of(this,
>> +						    struct vgic_io_device, dev);
>> +	u32 value = 0;
>> +
>> +	switch ((addr - iodev->base_addr) & ~3) {
>> +	case GICD_CTLR:
>> +		if (vcpu->kvm->arch.vgic.enabled)
>> +		       value |=	GICD_CTLR_ENABLE_SS_G1;
>> +		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
>> +		break;
>> +	case GICD_TYPER:
>> +		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>> +		value = (value >> 5) - 1;
>> +		value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
>> +		break;
>> +	case GICD_IIDR:
>> +		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>> +	write_mask32(value, addr & 3, len, val);
>>  	return 0;
>>  }
>>  
>> @@ -614,7 +636,19 @@ static int vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
>>  				   struct kvm_io_device *this,
>>  				   gpa_t addr, int len, const void *val)
>>  {
>> -	/* TODO: implement */
>> +	struct vgic_io_device *iodev = container_of(this,
>> +						    struct vgic_io_device, dev);
>> +	bool enabled;
>> +
>> +	/* These are not the bits you are looking for ... */
> 
> haha, nice.  But I don't understand what this case is?

Of the 16 bytes this region covers (CTLR, TYPER, IIDR) only the first
byte is writeable, the rest is WI.
I am afraid I have to replace the cool quote with something more
meaningful ...

>> +	if (addr - iodev->base_addr > 0)
>> +		return 0;
>> +
>> +	/* We only care about the enable bit, all other bits are WI. */
>> +	enabled = *(u8*)val & GICD_CTLR_ENABLE_SS_G1;
>> +
>> +	vcpu->kvm->arch.vgic.enabled = enabled;
> 
> I think some of the comments from the v2 side apply here as well.

Agreed.

Cheers,
Andre.

>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 2.7.3
>>
> 
