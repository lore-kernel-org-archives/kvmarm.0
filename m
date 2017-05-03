From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 22/22] KVM: arm64: vgic-v3:
 KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES
Date: Thu, 4 May 2017 00:22:45 +0200
Message-ID: <a236dc61-2454-835d-985e-db154661042c@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-23-git-send-email-eric.auger@redhat.com>
 <20170430213219.GE1499@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170430213219.GE1499@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/04/2017 23:32, Christoffer Dall wrote:
> On Fri, Apr 14, 2017 at 12:15:34PM +0200, Eric Auger wrote:
>> This patch adds a new attribute to GICV3 KVM device
>> KVM_DEV_ARM_VGIC_GRP_CTRL group. This Allows the userspace to
> 
> nit: allows (lowercase)
> nit: s/the userspace/userspace/
> 
>> flush all GICR pending tables into guest RAM. At the moment
>> we do not offer any restore control as the sync is implicit.
> 
> I would probably remove the last sentence here.
> 
>>
>> As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
>> definition in the irqchip header. We restore the full length
>> of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
>> field length of [51:12].
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - move pending table save code/ctrl into VGICv3 instead of ITS
>> - remove useless gpa_t cast
>> - use the same optimization as in its_sync_lpi_pending_table
>>
>> v3 -> v4:
>> - remove the wrong comment about locking
>> - pass kvm struct instead of its handle
>> - add comment about restore method
>> - remove GITR_PENDABASER.PTZ check
>> - continue if target_vcpu == NULL
>> - new locking strategy
>>
>> v1 -> v2:
>> - do not care about the 1st KB which should be zeroed according to
>>   the spec.
>> ---
>>  arch/arm/include/uapi/asm/kvm.h     |  1 +
>>  arch/arm64/include/uapi/asm/kvm.h   |  1 +
>>  include/linux/irqchip/arm-gic-v3.h  |  2 ++
>>  virt/kvm/arm/vgic/vgic-its.c        |  6 ++---
>>  virt/kvm/arm/vgic/vgic-kvm-device.c | 20 ++++++++++++++
>>  virt/kvm/arm/vgic/vgic-v3.c         | 54 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h            |  1 +
>>  7 files changed, 81 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>> index 8e6563c..78fe803 100644
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -202,6 +202,7 @@ struct kvm_arch_memory_slot {
>>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
>>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
>>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
>> +#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>>  
>>  /* KVM_IRQ_LINE irq field index values */
>>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 1e35115..8a3758a 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -222,6 +222,7 @@ struct kvm_arch_memory_slot {
>>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
>>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
>>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
>> +#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>>  
>>  /* Device Control API on vcpu fd */
>>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 0c6798c..9d3932f 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -158,6 +158,7 @@
>>  #define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
>>  
>>  #define GICR_PROPBASER_IDBITS_MASK			(0x1f)
>> +#define GICR_PROPBASER_ADDRESS(x)    ((x) & GENMASK_ULL(51, 12))
>>  
>>  #define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
>>  #define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
>> @@ -183,6 +184,7 @@
>>  #define GICR_PENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWb)
>>  
>>  #define GICR_PENDBASER_PTZ				BIT_ULL(62)
>> +#define GICR_PENDBASER_ADDRESS(x)    ((x) & GENMASK_ULL(51, 16))
>>  
>>  /*
>>   * Re-Distributor registers, offsets from SGI_base
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index be848be..745c245 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -189,8 +189,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
>>   */
>>  #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
>> -#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
>> -#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
>>  
>>  #define GIC_LPI_OFFSET 8192
>>  
>> @@ -227,7 +225,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
>>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>>  			     struct kvm_vcpu *filter_vcpu)
>>  {
>> -	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>> +	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
>>  	u8 prop;
>>  	int ret;
>>  
>> @@ -339,7 +337,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
>>   */
>>  static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>>  {
>> -	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>> +	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>>  	struct vgic_irq *irq;
>>  	int last_byte_offset = -1;
>>  	int ret = 0;
>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index 859bfa8..d48743c 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -580,6 +580,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>>  		reg = tmp32;
>>  		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>>  	}
>> +	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>> +		int ret;
>> +
>> +		switch (attr->attr) {
>> +		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
>> +			mutex_lock(&dev->kvm->lock);
>> +
>> +			if (!lock_all_vcpus(dev->kvm)) {
>> +				mutex_unlock(&dev->kvm->lock);
>> +				return -EBUSY;
>> +			}
>> +			ret = vgic_v3_save_pending_tables(dev->kvm);
>> +			unlock_all_vcpus(dev->kvm);
>> +			mutex_unlock(&dev->kvm->lock);
>> +			return ret;
>> +		}
>> +		break;
>> +	}
>>  	}
>>  	return -ENXIO;
>>  }
>> @@ -658,6 +676,8 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>>  		switch (attr->attr) {
>>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
>>  			return 0;
>> +		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
>> +			return 0;
>>  		}
>>  	}
>>  	return -ENXIO;
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index be0f4c3..1f0977f 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/irqchip/arm-gic-v3.h>
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>> +//#include <linux/bitops.h>
>>  #include <kvm/arm_vgic.h>
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/kvm_asm.h>
>> @@ -252,6 +253,59 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>>  }
>>  
>> +/**
>> + * vgic_its_save_pending_tables - Save the pending tables into guest RAM
>> + * kvm lock and all vcpu lock must be held
>> + */
>> +int vgic_v3_save_pending_tables(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	int last_byte_offset = -1;
>> +	struct vgic_irq *irq;
>> +	int ret;
>> +
>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>> +		int byte_offset, bit_nr;
>> +		struct kvm_vcpu *vcpu;
>> +		gpa_t pendbase, ptr;
>> +		bool stored;
>> +		u8 val;
>> +
>> +		vcpu = irq->target_vcpu;
>> +		if (!vcpu)
>> +			continue;
>> +
>> +		pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>> +
>> +		byte_offset = irq->intid / BITS_PER_BYTE;
>> +		bit_nr = irq->intid % BITS_PER_BYTE;
>> +		ptr = pendbase + byte_offset;
>> +
>> +		if (byte_offset != last_byte_offset) {
>> +			ret = kvm_read_guest(kvm, ptr, &val, 1);
>> +			if (ret)
>> +				return ret;
>> +			last_byte_offset = byte_offset;
>> +		}
>> +
>> +		stored = val & bit_nr;
> 
> didn't you mean 'stored = val & (1 << bit_nr)' ?
yes thanks!
> 
>> +		if (stored == irq->pending_latch)
>> +			continue;
>> +
>> +		if (irq->pending_latch)
>> +			val |= 1 << bit_nr;
>> +		else
>> +			val &= ~(1 << bit_nr);
>> +
>> +		ret = kvm_write_guest(kvm, ptr, &val, 1);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> This loop could probably be written a bit more efficiently and
> simplicity by reading the memory one word at a time (and remembering to
> do le64_to_cpu) and then doing something like:
> 
> 		if (irq->pending_latch)
> 			old = __test_and_set_bit(bit_nr, &val);
> 		else
> 			old = __test_and_clear_bit(bit_nr, &val);
> 
> 		if (old != val) {
> 			tmp = cpu_to_le64(val);
> 			ret = kvm_write_guest(kvm, ptr, &tmp,
> 					      sizeof(unsigned long));
> 			if (ret)
> 				retur ret;
> 		}
> 
> Further, you could also detect when the word_offset changes and write
> back the entire word with all its changes then, but you'd also have to
> check at the end of the loop then.  Not sure that's worth the
> optimization or easier to read than what you heave.  It's up to you.
I eventually chose to leave the code as it is today. One of the
rationale is it is pretty similar to the its_sync_lpi_pending_table
function in vgic-its.c.

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
>> +
>> +	return 0;
>> +}
>> +
>> +
>>  /* check for overlapping regions and for regions crossing the end of memory */
>>  static bool vgic_v3_check_base(struct kvm *kvm)
>>  {
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 9bc52ef..535c2fc 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -177,6 +177,7 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>>  void vgic_v3_enable(struct kvm_vcpu *vcpu);
>>  int vgic_v3_probe(const struct gic_kvm_info *info);
>>  int vgic_v3_map_resources(struct kvm *kvm);
>> +int vgic_v3_save_pending_tables(struct kvm *kvm);
>>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>>  
>>  int vgic_register_its_iodevs(struct kvm *kvm);
>> -- 
>> 2.5.5
>>
