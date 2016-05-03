From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 42/54] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 access to VGIC registers
Date: Tue, 3 May 2016 11:12:41 +0100
Message-ID: <57287999.4040801@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-43-git-send-email-andre.przywara@arm.com>
 <57287671.3000902@arm.com> <572878C8.5070306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D62349BB9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 06:10:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YKDCUvNdx6j3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 06:10:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C804B49BB0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 06:10:08 -0400 (EDT)
In-Reply-To: <572878C8.5070306@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/05/16 11:09, Andre Przywara wrote:
> Hi,
> 
> On 03/05/16 10:59, Marc Zyngier wrote:
>> On 28/04/16 17:46, Andre Przywara wrote:
>>> From: Eric Auger <eric.auger@linaro.org>
>>>
>>> This patch implements the switches for KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>>> and KVM_DEV_ARM_VGIC_GRP_CPU_REGS API which allows the userspace to
>>> access VGIC registers.
>>>
>>> At that stage the interfaces with the MMIO API are not implemented:
>>> - vgic_attr_regs_access
>>> - vgic_v2_has_attr_regs
>>>
>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-kvm-device.c | 53 +++++++++++++++++++++++++++++++++++--
>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c    | 34 ++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h            |  1 +
>>>  3 files changed, 86 insertions(+), 2 deletions(-)
>>>
>>
>> [...]
>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> index ae6077e..f2a8efe 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>> @@ -276,3 +276,37 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>>>  
>>>  	return ret;
>>>  }
>>> +
>>> +int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>>> +{
>>> +	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>>> +	const struct vgic_register_region *regions;
>>> +	gpa_t addr;
>>> +	int nr_regions, i, len;
>>> +
>>> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>>> +
>>> +	switch (attr->group) {
>>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>>> +		regions = vgic_v2_dist_registers;
>>> +		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
>>> +		break;
>>> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>>> +		return -ENXIO;		/* TODO: describe CPU i/f regs also */
>>
>> This definitely needs addressing, as it breaks guest migration.
> 
> It is implemented in patch 46/54.

Ah, sorry. I was on my way there...

> Shall I remove the TODO to avoid confusion and/or replace it with a note
> either in a comment or in this commit message that the implementation
> will follow in one the next patches?

Just drop the comment.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
