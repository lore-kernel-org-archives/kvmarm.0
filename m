From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 47/55] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Thu, 12 May 2016 19:52:38 +0100
Message-ID: <5734D0F6.9090406@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-48-git-send-email-andre.przywara@arm.com>
 <20160512184740.GM27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B84B949B42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 14:49:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ipve9J3JSdXc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 14:49:09 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C69649B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 14:49:08 -0400 (EDT)
In-Reply-To: <20160512184740.GM27623@cbox>
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

On 12/05/16 19:47, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:46:00AM +0100, Andre Przywara wrote:
>> Using the VMCR accessors we provide access to GIC CPU interface state
>> to userland by wiring it up to the existing userland interface.
>> [Marc: move and make VMCR accessors static, streamline MMIO handlers]
> 
> does this mean Marc did this and serves as credit or is it a lost
> reminder?

It was meant as credit. I thought that is the usual annotation for this?

>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>> Changelog v2 .. v3:
>> - total rework, moving into vgic-mmio-v2.c
>> - move vmcr accessor wrapper functions into this file
>> - use the register description table for CPU i/f registers as well
>> - add RAZ/WI handling for the active priority registers
>> - streamline MMIO handler functions
>>
>>  virt/kvm/arm/vgic/vgic-kvm-device.c |   2 +-
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c    | 104 ++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h            |   2 +
>>  3 files changed, 107 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index bb33af8..2122ff2 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -300,7 +300,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
>>  
>>  	switch (attr->group) {
>>  	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>> -		ret = -EINVAL;
>> +		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
>>  		break;
>>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>>  		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index c453e6f..0060539 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -206,6 +206,84 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>>  	}
>>  }
>>  
>> +static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_set_vmcr(vcpu, vmcr);
>> +	else
>> +		vgic_v3_set_vmcr(vcpu, vmcr);
>> +}
>> +
>> +static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>> +{
>> +	if (kvm_vgic_global_state.type == VGIC_V2)
>> +		vgic_v2_get_vmcr(vcpu, vmcr);
>> +	else
>> +		vgic_v3_get_vmcr(vcpu, vmcr);
>> +}
>> +
>> +#define GICC_ARCH_VERSION_V2	0x2
>> +
>> +/* These are for userland accesses only, there is no guest-facing emulation. */
>> +static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
>> +					   gpa_t addr, unsigned int len)
>> +{
>> +	struct vgic_vmcr vmcr;
>> +	u32 val;
>> +
>> +	vgic_get_vmcr(vcpu, &vmcr);
>> +
>> +	switch (addr & 0xff) {
>> +	case GIC_CPU_CTRL:
>> +		val = vmcr.ctlr;
>> +		break;
>> +	case GIC_CPU_PRIMASK:
>> +		val = vmcr.pmr;
>> +		break;
>> +	case GIC_CPU_BINPOINT:
>> +		val = vmcr.bpr;
>> +		break;
>> +	case GIC_CPU_ALIAS_BINPOINT:
>> +		val = vmcr.abpr;
>> +		break;
>> +	case GIC_CPU_IDENT:
>> +		val = ((PRODUCT_ID_KVM << 20) |
>> +		       (GICC_ARCH_VERSION_V2 << 16) |
>> +		       IMPLEMENTER_ARM);
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>> +	return extract_bytes(val, addr & 3, len);
> 
> I don't think we allow anything than a full 32-bit aligned accesses
> from userspace - we shouldn't at least.

Indeed - I think userland was always 32-bit only. And since last night
we even enforce this. So potentially there are more extract_bytes()
calls that can go.

Cheers,
Andre.
