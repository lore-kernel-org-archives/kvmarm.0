From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 24/55] KVM: arm/arm64: vgic-new: Add ENABLE registers
 handlers
Date: Wed, 11 May 2016 14:13:48 +0100
Message-ID: <5733300C.9070304@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-25-git-send-email-andre.przywara@arm.com>
 <20160511123423.GO27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160511123423.GO27623@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

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

Untested (and thus probably wrong):

#define VGIC_ADDR_IRQ_MASK(bits) ((1024 - 1) >> (4 - (bits))
#define VGIC_ADDR_IRQ_MULT(bits) (8 / (bits))
#define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
					 VGIC_ADDR_IRQ_MULT(bits))

	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
