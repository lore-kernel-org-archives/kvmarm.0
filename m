From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 11/17] KVM: arm64: implement basic ITS register
 handlers
Date: Mon, 11 Jul 2016 15:21:02 +0100
Message-ID: <5783AB4E.5070403@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-12-andre.przywara@arm.com> <577FBF92.9070005@arm.com>
 <fb079e7f-b84e-74d3-bc0f-be9c4f679a6d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <fb079e7f-b84e-74d3-bc0f-be9c4f679a6d@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/07/16 10:00, Andre Przywara wrote:
> Hi,
> 
> On 08/07/16 15:58, Marc Zyngier wrote:
>> On 05/07/16 12:23, Andre Przywara wrote:
>>> Add emulation for some basic MMIO registers used in the ITS emulation.
>>> This includes:
>>> - GITS_{CTLR,TYPER,IIDR}
>>> - ID registers
>>> - GITS_{CBASER,CREADR,CWRITER}
>>>   (which implement the ITS command buffer handling)
>>> - GITS_BASER<n>
>>>
>>> Most of the handlers are pretty straight forward, only the CWRITER
>>> handler is a bit more involved by taking the new its_cmd mutex and
>>> then iterating over the command buffer.
>>> The registers holding base addresses and attributes are sanitised before
>>> storing them.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  include/kvm/arm_vgic.h           |  16 ++
>>>  virt/kvm/arm/vgic/vgic-its.c     | 376 +++++++++++++++++++++++++++++++++++++--
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |   8 +-
>>>  virt/kvm/arm/vgic/vgic-mmio.h    |   6 +
>>>  virt/kvm/arm/vgic/vgic.c         |  12 +-
>>>  5 files changed, 401 insertions(+), 17 deletions(-)
>>>

[...]

>>> +/* Requires the its_lock to be held. */
>>> +static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
>>> +{
>>> +	list_del(&itte->itte_list);
>>> +	kfree(itte);
>>> +}
>>> +
>>> +static int vits_handle_command(struct kvm *kvm, struct vgic_its *its,
>>> +			       u64 *its_cmd)
>>> +{
>>> +	return -ENODEV;
>>> +}
>>> +
>>> +static u64 vgic_sanitise_its_baser(u64 reg)
>>> +{
>>> +	reg = vgic_sanitise_field(reg, GITS_BASER_SHAREABILITY_SHIFT,
>>> +				  GIC_BASER_SHAREABILITY_MASK,
>>> +				  vgic_sanitise_shareability);
>>> +	reg = vgic_sanitise_field(reg, GITS_BASER_INNER_CACHEABILITY_SHIFT,
>>> +				  GIC_BASER_CACHE_MASK,
>>> +				  vgic_sanitise_inner_cacheability);
>>> +	reg = vgic_sanitise_field(reg, GITS_BASER_OUTER_CACHEABILITY_SHIFT,
>>> +				  GIC_BASER_CACHE_MASK,
>>> +				  vgic_sanitise_outer_cacheability);
>>> +	return reg;
>>> +}
>>> +
>>> +static u64 vgic_sanitise_its_cbaser(u64 reg)
>>> +{
>>> +	reg = vgic_sanitise_field(reg, GITS_CBASER_SHAREABILITY_SHIFT,
>>> +				  GIC_BASER_SHAREABILITY_MASK,
>>
>> -ECOPYPASTE : GITS_CBASER_SHAREABILITY_MASK
>>
>>> +				  vgic_sanitise_shareability);
>>> +	reg = vgic_sanitise_field(reg, GITS_CBASER_INNER_CACHEABILITY_SHIFT,
>>> +				  GIC_BASER_CACHE_MASK,
>>
>> Same here?
>>
>>> +				  vgic_sanitise_inner_cacheability);
>>> +	reg = vgic_sanitise_field(reg, GITS_CBASER_OUTER_CACHEABILITY_SHIFT,
>>> +				  GIC_BASER_CACHE_MASK,
>>
>> And here?
> 
> Those shareability _masks_ are all the same.
> I can use specific #defines to that one value, if that makes you happy,
> though I wanted to avoid too many definitions.

What is the point of having #defines if their name doesn't indicate what
they do? You might as well call it BOB, or leave the raw value... And
no, don't do any of that. Just add the required defines.

> 
>>> +				  vgic_sanitise_outer_cacheability);
>>> +	return reg;
>>> +}
>>> +
>>> +static unsigned long vgic_mmio_read_its_cbaser(struct kvm *kvm,
>>> +					       struct vgic_its *its,
>>> +					       gpa_t addr, unsigned int len)
>>> +{
>>> +	return extract_bytes(its->cbaser, addr & 7, len);
>>> +}
>>> +
>>> +static void vgic_mmio_write_its_cbaser(struct kvm *kvm, struct vgic_its *its,
>>> +				       gpa_t addr, unsigned int len,
>>> +				       unsigned long val)
>>> +{
>>> +	/* When GITS_CTLR.Enable is 1, this register is RO. */
>>> +	if (its->enabled)
>>> +		return;
>>> +
>>> +	mutex_lock(&its->cmd_lock);
>>> +	its->cbaser = update_64bit_reg(its->cbaser, addr & 7, len, val);
>>> +	/* Sanitise the physical address to be 64k aligned. */
>>> +	its->cbaser &= ~GENMASK_ULL(15, 12);
>>
>> So you're not supporting 52bit addresses, as you're forcing the bottom
>> addresses to zero.
> 
> Yes, I decided to go with 48bits.
> 
>>> +	its->cbaser = vgic_sanitise_its_cbaser(its->cbaser);
>>> +	its->creadr = 0;
>>> +	/*
>>> +	 * CWRITER is architecturally UNKNOWN on reset, but we need to reset
>>> +	 * it to CREADR to make sure we start with an empty command buffer.
>>> +	 */
>>> +	its->cwriter = its->creadr;
>>> +	mutex_unlock(&its->cmd_lock);
>>> +}
>>> +
>>> +#define ITS_CMD_BUFFER_SIZE(baser)	((((baser) & 0xff) + 1) << 12)
>>> +#define ITS_CMD_SIZE			32
>>> +
>>> +/*
>>> + * By writing to CWRITER the guest announces new commands to be processed.
>>> + * To avoid any races in the first place, we take the its_cmd lock, which
>>> + * protects our ring buffer variables, so that there is only one user
>>> + * per ITS handling commands at a given time.
>>> + */
>>> +static void vgic_mmio_write_its_cwriter(struct kvm *kvm, struct vgic_its *its,
>>> +					gpa_t addr, unsigned int len,
>>> +					unsigned long val)
>>> +{
>>> +	gpa_t cbaser;
>>> +	u64 cmd_buf[4];
>>> +	u32 reg;
>>> +
>>> +	if (!its)
>>> +		return;
>>> +
>>> +	cbaser = CBASER_ADDRESS(its->cbaser);
>>> +
>>> +	reg = update_64bit_reg(its->cwriter & 0xfffe0, addr & 7, len, val);
>>> +	reg &= 0xfffe0;
>>> +	if (reg > ITS_CMD_BUFFER_SIZE(its->cbaser))
>>> +		return;
>>> +
>>> +	mutex_lock(&its->cmd_lock);
>>> +
>>> +	its->cwriter = reg;
>>> +
>>> +	while (its->cwriter != its->creadr) {
>>> +		int ret = kvm_read_guest(kvm, cbaser + its->creadr,
>>> +					 cmd_buf, ITS_CMD_SIZE);
>>> +		/*
>>> +		 * If kvm_read_guest() fails, this could be due to the guest
>>> +		 * programming a bogus value in CBASER or something else going
>>> +		 * wrong from which we cannot easily recover.
>>> +		 * We just ignore that command then.
>>> +		 */
>>> +		if (!ret)
>>> +			vits_handle_command(kvm, its, cmd_buf);
>>> +
>>> +		its->creadr += ITS_CMD_SIZE;
>>> +		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
>>> +			its->creadr = 0;
>>> +	}
>>> +
>>> +	mutex_unlock(&its->cmd_lock);
>>> +}
>>> +
>>> +static unsigned long vgic_mmio_read_its_cwriter(struct kvm *kvm,
>>> +						struct vgic_its *its,
>>> +						gpa_t addr, unsigned int len)
>>> +{
>>> +	return extract_bytes(its->cwriter & 0xfffe0, addr & 0x7, len);
>>> +}
>>> +
>>> +static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
>>> +					       struct vgic_its *its,
>>> +					       gpa_t addr, unsigned int len)
>>> +{
>>> +	return extract_bytes(its->creadr & 0xfffe0, addr & 0x7, len);
>>> +}
>>> +
>>> +#define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
>>> +static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
>>> +					      struct vgic_its *its,
>>> +					      gpa_t addr, unsigned int len)
>>> +{
>>> +	u64 reg;
>>> +
>>> +	switch (BASER_INDEX(addr)) {
>>> +	case 0:
>>> +		reg = its->baser_device_table;
>>> +		break;
>>> +	case 1:
>>> +		reg = its->baser_coll_table;
>>> +		break;
>>> +	default:
>>> +		reg = 0;
>>> +		break;
>>> +	}
>>> +
>>> +	return extract_bytes(reg, addr & 7, len);
>>> +}
>>> +
>>> +#define GITS_BASER_RO_MASK	(GENMASK_ULL(52, 48) | GENMASK_ULL(58, 56))
>>> +static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>> +				      struct vgic_its *its,
>>> +				      gpa_t addr, unsigned int len,
>>> +				      unsigned long val)
>>> +{
>>> +	u64 reg, *regptr;
>>> +	u64 entry_size, device_type;
>>> +
>>> +	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
>>> +	if (its->enabled)
>>> +		return;
>>> +
>>> +	switch (BASER_INDEX(addr)) {
>>> +	case 0:
>>> +		regptr = &its->baser_device_table;
>>> +		entry_size = 8;
>>> +		device_type = GITS_BASER_TYPE_DEVICE;
>>> +		break;
>>> +	case 1:
>>> +		regptr = &its->baser_coll_table;
>>> +		entry_size = 8;
>>> +		device_type = GITS_BASER_TYPE_COLLECTION;
>>> +		break;
>>> +	default:
>>> +		return;
>>> +	}
>>> +
>>> +	reg = update_64bit_reg(*regptr, addr & 7, len, val);
>>> +	reg &= ~GITS_BASER_RO_MASK;
>>> +	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
>>> +	reg |= device_type << GITS_BASER_TYPE_SHIFT;
>>> +	reg = vgic_sanitise_its_baser(reg);
>>
>> So you claim to support indirect tables on collections too? That's
>> pretty odd. I'd be happier if you filtered that out on collections.
> 
> Sure, can do. Just wondering what would be the reason for that? Is there
> anything that causes troubles on supporting indirect collection tables?

The main problem is that they don't make any sense, as this is not a
sparse space. A stupid GIC driver may use it and actively waste memory
(and performance on a real HW implementation).

> 
>> Also, you're supporting any page size (which is fine on its own), but
>> also not doing anything regarding the width of the address (52bits are
>> only valid for 64kB ITS pages). This is completely inconsistent with
>> what you're doing with GITS_CBASER.
>>
>> I'd suggest you reduce the scope to a single supported page size (64kB),
>> and decide whether you want to support 52bit PAs or not. Either way
>> would be valid, but it has to be consistent across the board.
> 
> My intention was to support all page sizes (we need 4K for AArch32,
> don't we?), but only 48 bits of PA (as KVM doesn't support more than
> 48bits atm anyway, if I am not mistaken).

Page size is the ITS page size, nothing to do with the CPU at all. So
there is absolutely no requirement to support a particular page size
(you just need to support one).

> So I will clear bits 15:12 if the page size is 64K. Does that make sense?

Don't bother with the "if". Stick to 64kB pages.

> 
>> It may not be of great importance right now, but it is going to be
>> really critical for save/restore, and we'd better get it right from the
>> beginning.
>>
>>> +
>>> +	*regptr = reg;
>>> +}
>>> +
>>>  #define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
>>>  {								\
>>>  	.reg_offset = off,					\
>>> @@ -42,8 +344,8 @@
>>>  	.its_write = wr,					\
>>>  }
>>>  
>>> -static unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
>>> -				       gpa_t addr, unsigned int len)
>>> +unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
>>> +				gpa_t addr, unsigned int len)
>>>  {
>>>  	return 0;
>>>  }
>>> @@ -56,28 +358,28 @@ static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
>>>  
>>>  static struct vgic_register_region its_registers[] = {
>>>  	REGISTER_ITS_DESC(GITS_CTLR,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 4,
>>> +		vgic_mmio_read_its_ctlr, vgic_mmio_write_its_ctlr, 4,
>>>  		VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_IIDR,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 4,
>>> +		vgic_mmio_read_its_iidr, its_mmio_write_wi, 4,
>>>  		VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_TYPER,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 8,
>>> +		vgic_mmio_read_its_typer, its_mmio_write_wi, 8,
>>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_CBASER,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 8,
>>> +		vgic_mmio_read_its_cbaser, vgic_mmio_write_its_cbaser, 8,
>>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_CWRITER,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 8,
>>> +		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
>>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_CREADR,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 8,
>>> +		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
>>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_BASER,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 0x40,
>>> +		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
>>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>>  	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
>>> -		its_mmio_read_raz, its_mmio_write_wi, 0x30,
>>> +		vgic_mmio_read_its_idregs, its_mmio_write_wi, 0x30,
>>>  		VGIC_ACCESS_32bit),
>>>  };
>>>  
>>> @@ -100,6 +402,18 @@ static int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
>>>  	return ret;
>>>  }
>>>  
>>> +#define INITIAL_BASER_VALUE						  \
>>> +	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
>>> +	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
>>> +	 GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)		| \
>>> +	 ((8ULL - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)			| \
>>> +	 GITS_BASER_PAGE_SIZE_64K)
>>> +
>>> +#define INITIAL_PROPBASER_VALUE						  \
>>> +	(GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWb)		| \
>>> +	 GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, SameAsInner)	| \
>>> +	 GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable))
>>> +
>>>  static int vgic_its_create(struct kvm_device *dev, u32 type)
>>>  {
>>>  	struct vgic_its *its;
>>> @@ -111,12 +425,25 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>>  	if (!its)
>>>  		return -ENOMEM;
>>>  
>>> +	mutex_init(&its->its_lock);
>>> +	mutex_init(&its->cmd_lock);
>>> +
>>>  	its->vgic_its_base = VGIC_ADDR_UNDEF;
>>>  
>>> +	INIT_LIST_HEAD(&its->device_list);
>>> +	INIT_LIST_HEAD(&its->collection_list);
>>> +
>>>  	dev->kvm->arch.vgic.has_its = true;
>>>  	its->initialized = false;
>>>  	its->enabled = false;
>>>  
>>> +	its->baser_device_table = INITIAL_BASER_VALUE			|
>>> +		((u64)GITS_BASER_TYPE_DEVICE << GITS_BASER_TYPE_SHIFT)	|
>>> +		GITS_BASER_INDIRECT;
>>
>> It is a bit odd to advertize the indirect flag as a reset value, but I
>> don't see anything that indicates it is not allowed...
> 
> I find it really confusing as to what fields are supposed to indicate
> support on reset and which are just taking part of that
> "write-and-see-if-it-sticks" game.

Reset values are usually "UNKNOWN".

> I take it now there are no requirements on the reset state and
> everything is negioated via writing to the register?
> In this case I'd move the indirect indication from here to the write
> function above.

Please do.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
