From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 19/55] KVM: arm/arm64: vgic-new: Add GICv3 world switch
 backend
Date: Tue, 10 May 2016 18:35:31 +0100
Message-ID: <57321BE3.4080204@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-20-git-send-email-andre.przywara@arm.com>
 <5731FE09.3000007@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5731FE09.3000007@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/16 16:28, Eric Auger wrote:
> On 05/06/2016 12:45 PM, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> As the GICv3 virtual interface registers differ from their GICv2
>> siblings, we need different handlers for processing maintenance
>> interrupts and reading/writing to the LRs.
>> Implement the respective handler functions and connect them to
>> existing code to be called if the host is using a GICv3.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - remove outdated comment about the dist_lock
>> - add WARN_ON about LR_STATE not being 0 in maintenance interrupts
>>
>> Changelog v1 .. v2:
>> - inject the IRQ priority into the list register
>>
>> Changelog v2 .. v3:
>> - remove no longer needed irqchip/arm-gic.h inclusion
>>
>>  include/linux/irqchip/arm-gic-v3.h |   1 +
>>  virt/kvm/arm/vgic/vgic-v3.c        | 168 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.c           |  25 ++++--
>>  virt/kvm/arm/vgic/vgic.h           |  29 +++++++
>>  4 files changed, 218 insertions(+), 5 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index ec938d1..35e93cf 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -275,6 +275,7 @@
>>  #define ICH_LR_ACTIVE_BIT		(1ULL << 63)
>>  #define ICH_LR_PHYS_ID_SHIFT		32
>>  #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
>> +#define ICH_LR_PRIORITY_SHIFT		48
>>  
>>  /* These are for GICv2 emulation only */
>>  #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> new file mode 100644
>> index 0000000..43d1dd7
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -0,0 +1,168 @@
>> +/*
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include "vgic.h"
>> +
>> +void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>> +
>> +	if (cpuif->vgic_misr & ICH_MISR_EOI) {
>> +		unsigned long eisr_bmap = cpuif->vgic_eisr;
>> +		int lr;
>> +
>> +		for_each_set_bit(lr, &eisr_bmap, kvm_vgic_global_state.nr_lr) {
> used_lrs?

Indeed.

>> +			u32 intid;
>> +			u64 val = cpuif->vgic_lr[lr];
>> +
>> +			if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>> +				intid = val & ICH_LR_VIRTUAL_ID_MASK;
>> +			else
>> +				intid = val & GICH_LR_VIRTUALID;
>> +
>> +			WARN_ON(cpuif->vgic_lr[lr] & ICH_LR_STATE);
>> +
>> +			kvm_notify_acked_irq(vcpu->kvm, 0,
>> +					     intid - VGIC_NR_PRIVATE_IRQS);
>> +
>> +			cpuif->vgic_elrsr |= 1ULL << lr;
>> +		}
>> +
>> +		/*
>> +		 * In the next iterations of the vcpu loop, if we sync
>> +		 * the vgic state after flushing it, but before
>> +		 * entering the guest (this happens for pending
>> +		 * signals and vmid rollovers), then make sure we
>> +		 * don't pick up any old maintenance interrupts here.
>> +		 */
>> +		cpuif->vgic_eisr = 0;
>> +	}
>> +
>> +	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
>> +}
>> +
>> +void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>> +
>> +	cpuif->vgic_hcr |= ICH_HCR_UIE;
>> +}
>> +
>> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>> +	int lr;
>> +
>> +	/* Assumes ap_list_lock held */
> I don't think there is such requirement and failed finding the lock held.

This looks like a leftover from a previous version. Folding the state is
done on a per-irq basis, and doesn't require to parse the ap_list.

> Besides Reviewed-by: Eric Auger <eric.auger@linaro.org>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
