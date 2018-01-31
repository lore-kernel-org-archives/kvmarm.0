From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 07/16] arm/arm64: KVM: Add PSCI version selection API
Date: Wed, 31 Jan 2018 17:45:56 +0000
Message-ID: <1de5a7a8-8118-597f-d1a3-14c406b57b0e@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-8-marc.zyngier@arm.com>
 <20180131173824.leyfy4vlqq3vmd37@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180131173824.leyfy4vlqq3vmd37@kamzik.brq.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Robin Murphy <robin.murphy@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/01/18 17:38, Andrew Jones wrote:
> On Mon, Jan 29, 2018 at 05:45:50PM +0000, Marc Zyngier wrote:
>> Although we've implemented PSCI 1.0 and 1.1, nothing can select them
>> Since all the new PSCI versions are backward compatible, we decide to
>> default to the latest version of the PSCI implementation. This is no
>> different from doing a firmware upgrade on KVM.
>>
>> But in order to give a chance to hypothetical badly implemented guests
>> that would have a fit by discovering something other than PSCI 0.2,
>> let's provide a new API that allows userspace to pick one particular
>> version of the API.
>>
>> This is implemented as a new class of "firmware" registers, where
>> we expose the PSCI version. This allows the PSCI version to be
>> save/restored as part of a guest migration, and also set to
>> any supported version if the guest requires it.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt      |  3 +-
>>  Documentation/virtual/kvm/arm/psci.txt | 28 ++++++++++++++
>>  arch/arm/include/asm/kvm_host.h        |  3 ++
>>  arch/arm/include/uapi/asm/kvm.h        |  6 +++
>>  arch/arm/kvm/guest.c                   | 13 +++++++
>>  arch/arm64/include/asm/kvm_host.h      |  3 ++
>>  arch/arm64/include/uapi/asm/kvm.h      |  6 +++
>>  arch/arm64/kvm/guest.c                 | 14 ++++++-
>>  include/kvm/arm_psci.h                 |  9 +++++
>>  virt/kvm/arm/psci.c                    | 68 +++++++++++++++++++++++++++++++++-
>>  10 files changed, 149 insertions(+), 4 deletions(-)
>>  create mode 100644 Documentation/virtual/kvm/arm/psci.txt
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 57d3ee9e4bde..334905202141 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2493,7 +2493,8 @@ Possible features:
>>  	  and execute guest code when KVM_RUN is called.
>>  	- KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
>>  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
>> -	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
>> +	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
>> +          backward compatible with v0.2) for the CPU.
>>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>  	  Depends on KVM_CAP_ARM_PMU_V3.
>> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
>> new file mode 100644
>> index 000000000000..2e49a4e9f084
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/arm/psci.txt
>> @@ -0,0 +1,28 @@
>> +KVM implements the PSCI (Power State Coordination Interface)
>> +specification in order to provide services such as CPU on/off, reset
>> +and power-off to the guest.
>> +
>> +The PSCI specification is regularly updated to provide new features,
>> +and KVM implements these updates if they make sense from a virtualization
>> +point of view.
>> +
>> +This means that a guest booted on two different versions of KVM can
>> +observe two different "firmware" revisions. This could cause issues if
>> +a given guest is tied to a particular PSCI revision (unlikely), or if
>> +a migration causes a different PSCI version to be exposed out of the
>> +blue to an unsuspecting guest.
>> +
>> +In order to remedy this situation, KVM exposes a set of "firmware
>> +pseuodo-registers" that can be manipulated using the GET/SET_ONE_REG
>> +interface. These registers can be saved/restored by userspace, and set
>> +to a convenient value if required.
> 
> Userspace can save/restore any state it deems necessary. 

Only if it has access to it. Until now, that wasn't an option.

> Is there another
> reason to invent a pseudo register? Considering the PSCI version is VM
> state, then maybe a VM "device" attribute[*], like s390 use, would fit
> better. 

Possibly. But that means current userspace won't engage the mitigation
by default, and that's pretty bad.

> Or, if keeping it VCPU state has some benefit, then we already
> have VCPU device attribute support for ARM that we could extend with
> another attribute. An advantage of using the device-attr API is that it
> has KVM_HAS_DEVICE_ATTR, allowing the new attribute support to be probed.
> How should userspace check if the pseudo register is supported? Maybe
> by just failing with NOT_SUPPORTED to get/set it?
> 
> [*] Documentation/virtual/kvm/devices/vm.txt

Frankly, I have no opinion on the way to implement it. My only
requirement is that it becomes enabled by default, without any userspace
change.

> 
>> +
>> +The following register is defined:
>> +
>> +* KVM_REG_ARM_PSCI_VERSION:
>> +
>> +  - Only valid if the vcpu has KVM_ARM_VCPU_PSCI_0_2 feature set
>> +  - Returns the current PSCI version on GET_ONE_REG
>> +  - Allows any supported PSCI version compatible with v0.2 to be set
>> +    with SET_ONE_REG
>> +  - Affects the whole VM (even if the register view is per-vcpu)
> 
> 
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index acbf9ec7b396..e9d57060d88c 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -75,6 +75,9 @@ struct kvm_arch {
>>  	/* Interrupt controller */
>>  	struct vgic_dist	vgic;
>>  	int max_vcpus;
>> +
>> +	/* Mandated version of PSCI */
>> +	u32 psci_version;
>>  };
>>  
>>  #define KVM_NR_MEM_OBJS     40
>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>> index 6edd177bb1c7..47dfc99f5cd0 100644
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -186,6 +186,12 @@ struct kvm_arch_memory_slot {
>>  #define KVM_REG_ARM_VFP_FPINST		0x1009
>>  #define KVM_REG_ARM_VFP_FPINST2		0x100A
>>  
>> +/* KVM-as-firmware specific pseudo-registers */
>> +#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> 
> Is this 0x14 documented somewhere? I'm just curious how the space for
> pseudo registers is reserved. Is there a common place that we should
> document that 0x14 is for the firmware (if it's not documented there
> already)?

No. First come, first served.

	M.
-- 
Jazz is not dead. It just smells funny...
