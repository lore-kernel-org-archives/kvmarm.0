From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 09/24] KVM: arm64: vgic-its: Introduce migration ABI
 infrastructure
Date: Fri, 5 May 2017 10:16:08 +0200
Message-ID: <2b69826d-9c8a-0ee3-9061-5de4d5f9dc21@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-10-git-send-email-eric.auger@redhat.com>
 <20170504171301.GT5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170504171301.GT5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/05/2017 19:13, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 01:44:29PM +0200, Eric Auger wrote:
>> We plan to support different migration ABIs, ie. characterizing
>> the ITS table layout format in guest RAM. For example, a new ABI
>> will be needed if vLPIs get supported for nested use case.
>>
>> So let's introduce an array of supported ABIs (at the moment a single
>> ABI is supported though). The following characteristics are foreseen
>> to vary with the ABI: size of table entries, save/restore operation,
>> the way abi settings are applied.
>>
>> By default the MAX_ABI_REV is applied on its creation. In subsequent
>> patches we will introduce a way for the userspace to change the ABI
>> in use.
>>
>> The entry sizes now are set according to the ABI version and not
>> hardcoded anymore.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v6 -> v7:
>> - rename abi into its_table_abi_versions
>> - kernel doc comments for struct vgic_its_abi
>> - comment GIC_ENCODE_SZ
>> - slighly rephrase the commit message
>>
>> v5: creation and squash KVM: arm64: ITS: Report the ITE size in
>>     GITS_TYPER
>> ---
>>  include/kvm/arm_vgic.h             |  3 ++
>>  include/linux/irqchip/arm-gic-v3.h |  5 +++
>>  virt/kvm/arm/vgic/vgic-its.c       | 92 ++++++++++++++++++++++++++++++++++++--
>>  3 files changed, 96 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index c0b3d99..285474a 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -162,6 +162,9 @@ struct vgic_its {
>>  	u32			creadr;
>>  	u32			cwriter;
>>  
>> +	/* migration ABI revision in use */
>> +	u32			abi_rev;
>> +
>>  	/* Protects the device and collection lists */
>>  	struct mutex		its_lock;
>>  	struct list_head	device_list;
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 97cbca1..81ebe43 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -132,6 +132,9 @@
>>  #define GIC_BASER_SHAREABILITY(reg, type)				\
>>  	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
>>  
>> +/* encode a size field of width @w containing @n - 1 units */
>> +#define GIC_ENCODE_SZ(n, w) (((unsigned long)(n) - 1) & GENMASK_ULL(((w) - 1), 0))
>> +
>>  #define GICR_PROPBASER_SHAREABILITY_SHIFT		(10)
>>  #define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT		(7)
>>  #define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT		(56)
>> @@ -232,6 +235,7 @@
>>  #define GITS_CTLR_QUIESCENT		(1U << 31)
>>  
>>  #define GITS_TYPER_PLPIS		(1UL << 0)
>> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
>>  #define GITS_TYPER_IDBITS_SHIFT		8
>>  #define GITS_TYPER_DEVBITS_SHIFT	13
>>  #define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
>> @@ -290,6 +294,7 @@
>>  #define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
>>  #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
>>  #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
>> +#define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
>>  #define GITS_BASER_SHAREABILITY_SHIFT	(10)
>>  #define GITS_BASER_InnerShareable					\
>>  	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 18588ef..c336cce 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -33,6 +33,12 @@
>>  #include "vgic.h"
>>  #include "vgic-mmio.h"
>>  
>> +/* Highest migration ABI revision supported by this code */
>> +#define MAX_ABI_REV 0
>> +
>> +static int vgic_its_set_abi(struct vgic_its *its, int rev);
>> +static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
>> +
>>  /*
>>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
>>   * If this LPI is already mapped on another ITS, we increase its refcount
>> @@ -123,6 +129,25 @@ struct its_ite {
>>  	u32 event_id;
>>  };
>>  
>> +/**
>> + * struct vgic_its_abi - ITS abi ops and settings
>> + * @cte_esz: collection table entry size
>> + * @dte_esz: device table entry size
>> + * @ite_esz: interrupt translation table entry size
>> + * @save tables: save the ITS tables into guest RAM
>> + * @restore_tables: restore the ITS internal structs from
>> + * tables stored in guest RAM
> 
> nit: indent to align with the beginning of 'restore...'
> 
> 
>> + * @commit: apply the ABI settings to the ITS
> 
> hmm, I already forgot what the commit function does, and reading this
> text doesn't seem to help me, unfortunately.  When is this called, what
> does it do?
what about:
 * @commit: initialize the registers which expose the ABI settings,
 *  especially the entry sizes

Thanks

Eric

> 
> Thanks,
> -Christoffer
> 
>> + */
>> +struct vgic_its_abi {
>> +	int cte_esz;
>> +	int dte_esz;
>> +	int ite_esz;
>> +	int (*save_tables)(struct vgic_its *its);
>> +	int (*restore_tables)(struct vgic_its *its);
>> +	int (*commit)(struct vgic_its *its);
>> +};
>> +
>>  /*
>>   * Find and returns a device in the device table for an ITS.
>>   * Must be called with the its_lock mutex held.
>> @@ -364,6 +389,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>>  					      struct vgic_its *its,
>>  					      gpa_t addr, unsigned int len)
>>  {
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>  	u64 reg = GITS_TYPER_PLPIS;
>>  
>>  	/*
>> @@ -376,6 +402,7 @@ static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
>>  	 */
>>  	reg |= 0x0f << GITS_TYPER_DEVBITS_SHIFT;
>>  	reg |= 0x0f << GITS_TYPER_IDBITS_SHIFT;
>> +	reg |= GIC_ENCODE_SZ(abi->ite_esz, 4) << GITS_TYPER_ITT_ENTRY_SIZE_SHIFT;
>>  
>>  	return extract_bytes(reg, addr & 7, len);
>>  }
>> @@ -1269,6 +1296,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>  				      gpa_t addr, unsigned int len,
>>  				      unsigned long val)
>>  {
>> +	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>  	u64 entry_size, device_type;
>>  	u64 reg, *regptr, clearbits = 0;
>>  
>> @@ -1279,12 +1307,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>  	switch (BASER_INDEX(addr)) {
>>  	case 0:
>>  		regptr = &its->baser_device_table;
>> -		entry_size = 8;
>> +		entry_size = abi->dte_esz;
>>  		device_type = GITS_BASER_TYPE_DEVICE;
>>  		break;
>>  	case 1:
>>  		regptr = &its->baser_coll_table;
>> -		entry_size = 8;
>> +		entry_size = abi->cte_esz;
>>  		device_type = GITS_BASER_TYPE_COLLECTION;
>>  		clearbits = GITS_BASER_INDIRECT;
>>  		break;
>> @@ -1426,7 +1454,6 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
>>  	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
>>  	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
>>  	 GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)		| \
>> -	 ((8ULL - 1) << GITS_BASER_ENTRY_SIZE_SHIFT)			| \
>>  	 GITS_BASER_PAGE_SIZE_64K)
>>  
>>  #define INITIAL_PROPBASER_VALUE						  \
>> @@ -1466,7 +1493,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>>  
>>  	dev->private = its;
>>  
>> -	return 0;
>> +	return vgic_its_set_abi(its, MAX_ABI_REV);
>>  }
>>  
>>  static void vgic_its_destroy(struct kvm_device *kvm_dev)
>> @@ -1584,6 +1611,63 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
>>  	return ret;
>>  }
>>  
>> +/**
>> + * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
>> + * according to v0 ABI
>> + */
>> +static int vgic_its_save_tables_v0(struct vgic_its *its)
>> +{
>> +	return -ENXIO;
>> +}
>> +
>> +/**
>> + * vgic_its_restore_tables_v0 - Restore the ITS tables from guest RAM
>> + * to internal data structs according to V0 ABI
>> + *
>> + */
>> +static int vgic_its_restore_tables_v0(struct vgic_its *its)
>> +{
>> +	return -ENXIO;
>> +}
>> +
>> +static int vgic_its_commit_v0(struct vgic_its *its)
>> +{
>> +	const struct vgic_its_abi *abi;
>> +
>> +	abi = vgic_its_get_abi(its);
>> +	its->baser_coll_table &= ~GITS_BASER_ENTRY_SIZE_MASK;
>> +	its->baser_device_table &= ~GITS_BASER_ENTRY_SIZE_MASK;
>> +
>> +	its->baser_coll_table |= (GIC_ENCODE_SZ(abi->cte_esz, 5)
>> +					<< GITS_BASER_ENTRY_SIZE_SHIFT);
>> +
>> +	its->baser_device_table |= (GIC_ENCODE_SZ(abi->dte_esz, 5)
>> +					<< GITS_BASER_ENTRY_SIZE_SHIFT);
>> +	return 0;
>> +}
>> +
>> +static const struct vgic_its_abi its_table_abi_versions[MAX_ABI_REV + 1] = {
>> +	{.cte_esz = 8, .dte_esz = 8, .ite_esz = 8,
>> +	 .save_tables = vgic_its_save_tables_v0,
>> +	 .restore_tables = vgic_its_restore_tables_v0,
>> +	 .commit = vgic_its_commit_v0,
>> +	},
>> +};
>> +
>> +inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>> +{
>> +	return &its_table_abi_versions[its->abi_rev];
>> +}
>> +
>> +int vgic_its_set_abi(struct vgic_its *its, int rev)
>> +{
>> +	const struct vgic_its_abi *abi;
>> +
>> +	its->abi_rev = rev;
>> +	abi = vgic_its_get_abi(its);
>> +	return abi->commit(its);
>> +}
>> +
>>  static int vgic_its_has_attr(struct kvm_device *dev,
>>  			     struct kvm_device_attr *attr)
>>  {
>> -- 
>> 2.5.5
>>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
