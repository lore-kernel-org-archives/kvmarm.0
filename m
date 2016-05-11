From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 24/55] KVM: arm/arm64: vgic-new: Add ENABLE registers
 handlers
Date: Wed, 11 May 2016 14:04:13 +0100
Message-ID: <57332DCD.1020701@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-25-git-send-email-andre.przywara@arm.com>
 <20160511123423.GO27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D912849B34
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:00:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-0l2qgTafIH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:00:46 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA117499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:00:46 -0400 (EDT)
In-Reply-To: <20160511123423.GO27623@cbox>
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

On 11/05/16 13:34, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:37AM +0100, Andre Przywara wrote:
>> As the enable register handlers are shared between the v2 and v3
>> emulation, their implementation goes into vgic-mmio.c, to be easily
>> referenced from the v3 emulation as well later.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - use lower bits of address to determine IRQ number
>> - remove TODO, confirmed to be fine
>>
>> Changelog v1 .. v2:
>> - adapt to new MMIO framework
>>
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +--
>>  virt/kvm/arm/vgic/vgic-mmio.c    | 56 ++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio.h    | 11 ++++++++
>>  3 files changed, 69 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index 69e96f7..448d1da 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -72,9 +72,9 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
>>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 1),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
>>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 41cf4f4..077ae86 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -46,6 +46,62 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
>>  	/* Ignore */
>>  }
>>  
>> +/*
>> + * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
>> + * of the enabled bit, so there is only one function for both here.
>> + */
>> +unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
>> +				    gpa_t addr, unsigned int len)
>> +{
>> +	u32 intid = (addr & 0x7f) * 8;
> 
> is there anything we can do about this to make it more intuitive?  A
> macro to generate the mask/offset based on bits per interrupt or
> something?

Yes, something where you give it the address and the bits-per-IRQ and it
tells you the IRQ number.
Not sure it is advisable to squash this into v4 still?

> 
>> +	u32 value = 0;
>> +	int i;
>> +
>> +	/* Loop over all IRQs affected by this read */
>> +	for (i = 0; i < len * 8; i++) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		if (irq->enabled)
>> +			value |= (1U << i);
> 
> I couldn't find the code anywhere that enforces word-aligned accesses to
> these registers.  Do we have that?

Not that I am aware of. I was suggesting this since we have one in the
IROUTER function. Architecturally we don't need to support halfword
accesses, it's: byte + word, word only or double-word + word, depending
on the actual register, IIRC.
As a fix we can at least deny (read: ignore) halfword accesses in
general in the dispatcher. Shall I do this (two two-liners)?
I think byte and word accesses are safe with the existing handlers last
time I checked.

> If that's not the case, doesn't this break of you do a non-word aligned
> access?

Why would it? vgic_data_host_to_mmio_bus and extract_bytes should cover
this, shouldn't they?

Cheers,
Andre.

> 
>> +	}
>> +
>> +	return extract_bytes(value, addr & 3, len);
>> +}
>> +
>> +void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val)
>> +{
>> +	u32 intid = (addr & 0x7f) * 8;
>> +	int i;
>> +
>> +	for_each_set_bit(i, &val, len * 8) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +		irq->enabled = true;
>> +		vgic_queue_irq_unlock(vcpu->kvm, irq);
>> +	}
>> +}
>> +
>> +void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val)
>> +{
>> +	u32 intid = (addr & 0x7f) * 8;
>> +	int i;
>> +
>> +	for_each_set_bit(i, &val, len * 8) {
>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		irq->enabled = false;
>> +
>> +		spin_unlock(&irq->irq_lock);
> 
> nit: whitespace consistency with senable
> 
>> +	}
>> +}
>> +
>>  static int match_region(const void *key, const void *elt)
>>  {
>>  	const unsigned int offset = (unsigned long)key;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
>> index 4f4dd2b..188909a 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.h
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>> @@ -74,6 +74,17 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
>>  void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
>>  			unsigned int len, unsigned long val);
>>  
>> +unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
>> +				    gpa_t addr, unsigned int len);
>> +
>> +void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val);
>> +
>> +void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
>> +			     gpa_t addr, unsigned int len,
>> +			     unsigned long val);
>> +
>>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>>  
>>  #endif
>> -- 
>> 2.7.3
>>
> 
