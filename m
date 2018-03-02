From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [REPOST PATCH] arm/arm64: KVM: Add PSCI version selection API
Date: Fri, 2 Mar 2018 13:26:14 +0100
Message-ID: <40c74835-da24-485f-14bb-a0c357c7e79b@redhat.com>
References: <20180215175803.6870-1-marc.zyngier@arm.com>
 <db215c1e-0ce8-32e4-d131-e790bebf353e@redhat.com>
 <86o9k63f7a.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86o9k63f7a.wl-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 02/03/18 12:11, Marc Zyngier wrote:
> On Fri, 02 Mar 2018 10:44:48 +0000,
> Auger Eric wrote:
>>
>> Hi Marc,
>>
>> On 15/02/18 18:58, Marc Zyngier wrote:
>>> Although we've implemented PSCI 0.1, 0.2 and 1.0, we expose either 0.1
>>> or 1.0 to a guest, defaulting to the latest version of the PSCI
>>> implementation that is compatible with the requested version. This is
>>> no different from doing a firmware upgrade on KVM.
>>>
>>> But in order to give a chance to hypothetical badly implemented guests
>>> that would have a fit by discovering something other than PSCI 0.2,
>>> let's provide a new API that allows userspace to pick one particular
>>> version of the API.
>>
>> I understand the get/set is called as part of the migration process.
>> So my understanding is the benefit of this series is migration fails in
>> those cases:
>>
>>> =0.2 source -> 0.1 destination
>> 0.1 source -> >=0.2 destination
> 
> It also fails in the case where you migrate a 1.0 guest to something
> that cannot support it.

That's because on the destination, the number of regs is less than on
source, right?

My previous reasoning was:

At the moment, in QEMU, IIUC, we check the KVM_CAP_ARM_PSCI_0_2
capability and if it is advertised, we initialize the vpcu with
KVM_ARM_VCPU_PSCI_0_2. This holds for a 0.2 or 1.0 kernel.

Assuming the source is 1.0 capable and the destination has a < 4.16
kernel so 0.2 only. On migration the fw reg get() returns
KVM_ARM_PSCI_1_0. On Set, wants_02 is set and
vcpu->kvm->arch.psci_version gets set to KVM_ARM_PSCI_1_0.

> 
>> However in the above mentioned use case where the guest would absolutely
>> need a 0.2 and not a 1.0 I don't get on which event the userspace would
>> do a set to force 0.2?
> 
> You'd have to know that your guest cannot support 0.2, and force 0.2
> by doing a SET_ONE_REG(KVM_REG_ARM_PSCI_VERSION, PSCI_VERSION(0, 2)).
> 
> Or am I missing what you're asking for?
My question rather was how do you get to know?
> 
>>>
>>> This is implemented as a new class of "firmware" registers, where
>>> we expose the PSCI version. This allows the PSCI version to be
>>> save/restored as part of a guest migration, and also set to
>>> any supported version if the guest requires it.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>> This is a repost of this proposal for a firmware selection API, as
>>> there was some discussion during the merging window. Now that the core
>>> variant-2 stuff is merged, we can have a go at more
>>> bikesheding. Please open fire!
>>>
>>>  Documentation/virtual/kvm/api.txt      |  9 ++++-
>>>  Documentation/virtual/kvm/arm/psci.txt | 30 +++++++++++++++++
>>>  arch/arm/include/asm/kvm_host.h        |  3 ++
>>>  arch/arm/include/uapi/asm/kvm.h        |  6 ++++
>>>  arch/arm/kvm/guest.c                   | 13 ++++++++
>>>  arch/arm64/include/asm/kvm_host.h      |  3 ++
>>>  arch/arm64/include/uapi/asm/kvm.h      |  6 ++++
>>>  arch/arm64/kvm/guest.c                 | 14 +++++++-
>>>  include/kvm/arm_psci.h                 | 16 +++++++--
>>>  virt/kvm/arm/psci.c                    | 60 ++++++++++++++++++++++++++++++++++
>>>  10 files changed, 156 insertions(+), 4 deletions(-)
>>>  create mode 100644 Documentation/virtual/kvm/arm/psci.txt
>>
>>>
>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>> index 57d3ee9e4bde..d2b41e1608b4 100644
>>> --- a/Documentation/virtual/kvm/api.txt
>>> +++ b/Documentation/virtual/kvm/api.txt
>>> @@ -1943,6 +1943,9 @@ ARM 32-bit VFP control registers have the following id bit patterns:
>>>  ARM 64-bit FP registers have the following id bit patterns:
>>>    0x4030 0000 0012 0 <regno:12>
>>>  
>>> +ARM firmware pseudo-registers have the following bit pattern:
>> s/bit pattern/id bit patterns?
>>> +  0x4030 0000 0014 <regno:16>
>>> +
>>>  
>>>  arm64 registers are mapped using the lower 32 bits. The upper 16 of
>>>  that is the register group type, or coprocessor number:
>>> @@ -1959,6 +1962,9 @@ arm64 CCSIDR registers are demultiplexed by CSSELR value:
>>>  arm64 system registers have the following id bit patterns:
>>>    0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
>>>  
>>> +arm64 firmware pseudo-registers have the following bit pattern:
>> s/bit pattern/id bit patterns?
>>> +  0x6030 0000 0014 <regno:16>
>>> +
>>>  
>>>  MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
>>>  the register group type:
>>> @@ -2493,7 +2499,8 @@ Possible features:
>>>  	  and execute guest code when KVM_RUN is called.
>>>  	- KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
>>>  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
>>> -	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
>>> +	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
>>> +          backward compatible with v0.2) for the CPU.
>>>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>>  	  Depends on KVM_CAP_ARM_PMU_V3.
>>> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
>>> new file mode 100644
>>> index 000000000000..aafdab887b04
>>> --- /dev/null
>>> +++ b/Documentation/virtual/kvm/arm/psci.txt
>>> @@ -0,0 +1,30 @@
>>> +KVM implements the PSCI (Power State Coordination Interface)
>>> +specification in order to provide services such as CPU on/off, reset
>>> +and power-off to the guest.
>>> +
>>> +The PSCI specification is regularly updated to provide new features,
>>> +and KVM implements these updates if they make sense from a virtualization
>>> +point of view.
>>> +
>>> +This means that a guest booted on two different versions of KVM can
>>> +observe two different "firmware" revisions. This could cause issues if
>>> +a given guest is tied to a particular PSCI revision (unlikely), or if
>>> +a migration causes a different PSCI version to be exposed out of the
>>> +blue to an unsuspecting guest.
>>> +
>>> +In order to remedy this situation, KVM exposes a set of "firmware
>>> +pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>>> +interface. These registers can be saved/restored by userspace, and set
>>> +to a convenient value if required.
>>> +
>>> +The following register is defined:
>>> +
>>> +* KVM_REG_ARM_PSCI_VERSION:
>>> +
>>> +  - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
>>> +    (and thus has already been initialized)
>>> +  - Returns the current PSCI version on GET_ONE_REG (defaulting to the
>>> +    highest PSCI version implemented by KVM and compatible with v0.2)
>> backwards compatible?
>>> +  - Allows any PSCI version implemented by KVM and compatible with
>> backwards compatible?
>>> +    v0.2 to be set with SET_ONE_REG
>>> +  - Affects the whole VM (even if the register view is per-vcpu)
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index ef54013b5b9f..6c05e3b13081 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -75,6 +75,9 @@ struct kvm_arch {
>>>  	/* Interrupt controller */
>>>  	struct vgic_dist	vgic;
>>>  	int max_vcpus;
>>> +
>>> +	/* Mandated version of PSCI */
>>> +	u32 psci_version;
>>>  };
>>>  
>>>  #define KVM_NR_MEM_OBJS     40
>>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>>> index 6edd177bb1c7..47dfc99f5cd0 100644
>>> --- a/arch/arm/include/uapi/asm/kvm.h
>>> +++ b/arch/arm/include/uapi/asm/kvm.h
>>> @@ -186,6 +186,12 @@ struct kvm_arch_memory_slot {
>>>  #define KVM_REG_ARM_VFP_FPINST		0x1009
>>>  #define KVM_REG_ARM_VFP_FPINST2		0x100A
>>>  
>>> +/* KVM-as-firmware specific pseudo-registers */
>>> +#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
>>> +#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
>>> +					 KVM_REG_ARM_FW | ((r) & 0xffff))
>>> +#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
>>
>> #define KVM_ARM_VCPU_PSCI_0_2           2 /* CPU uses PSCI v0.2 */
>> Comment may deserve an upgrade too
> 
> I'm not sure we want this. KVM_REG_PSCI_VERSION takes a PSCI version
> number, as indicated in the PSCI spec. You should use
> PSCI_VERSION(0,2), as defined in include/uapi/linux/psci.h.
The above define is used when initializing the vcpu, right? This now
means we are likely to have a >=0.2 PSCI version and not strictly
speaking a 0.2 one?

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
