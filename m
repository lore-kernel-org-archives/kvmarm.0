From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 08/18] arm/arm64: KVM: Add PSCI version selection API
Date: Mon, 5 Feb 2018 09:24:33 +0000
Message-ID: <6b0d5f23-950c-b2a6-3cc8-63c3145893b4@arm.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-9-marc.zyngier@arm.com>
 <20180202201706.dj6jmff7lh7bleze@kamzik.brq.redhat.com>
 <20180203115932.24c4bcfb@why.wild-wind.fr.eu.org>
 <20180204123701.GK21802@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180204123701.GK21802@cbox>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/02/18 12:37, Christoffer Dall wrote:
> On Sat, Feb 03, 2018 at 11:59:32AM +0000, Marc Zyngier wrote:
>> On Fri, 2 Feb 2018 21:17:06 +0100
>> Andrew Jones <drjones@redhat.com> wrote:
>>
>>> On Thu, Feb 01, 2018 at 11:46:47AM +0000, Marc Zyngier wrote:
>>>> Although we've implemented PSCI 1.0 and 1.1, nothing can select them
>>>> Since all the new PSCI versions are backward compatible, we decide to
>>>> default to the latest version of the PSCI implementation. This is no
>>>> different from doing a firmware upgrade on KVM.
>>>>
>>>> But in order to give a chance to hypothetical badly implemented guests
>>>> that would have a fit by discovering something other than PSCI 0.2,
>>>> let's provide a new API that allows userspace to pick one particular
>>>> version of the API.
>>>>
>>>> This is implemented as a new class of "firmware" registers, where
>>>> we expose the PSCI version. This allows the PSCI version to be
>>>> save/restored as part of a guest migration, and also set to
>>>> any supported version if the guest requires it.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  Documentation/virtual/kvm/api.txt      |  3 +-
>>>>  Documentation/virtual/kvm/arm/psci.txt | 30 +++++++++++++++
>>>>  arch/arm/include/asm/kvm_host.h        |  3 ++
>>>>  arch/arm/include/uapi/asm/kvm.h        |  6 +++
>>>>  arch/arm/kvm/guest.c                   | 13 +++++++
>>>>  arch/arm64/include/asm/kvm_host.h      |  3 ++
>>>>  arch/arm64/include/uapi/asm/kvm.h      |  6 +++
>>>>  arch/arm64/kvm/guest.c                 | 14 ++++++-
>>>>  include/kvm/arm_psci.h                 |  9 +++++
>>>>  virt/kvm/arm/psci.c                    | 68 +++++++++++++++++++++++++++++++++-
>>>>  10 files changed, 151 insertions(+), 4 deletions(-)
>>>>  create mode 100644 Documentation/virtual/kvm/arm/psci.txt
>>>>
>>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>>> index 57d3ee9e4bde..334905202141 100644
>>>> --- a/Documentation/virtual/kvm/api.txt
>>>> +++ b/Documentation/virtual/kvm/api.txt
>>>> @@ -2493,7 +2493,8 @@ Possible features:
>>>>  	  and execute guest code when KVM_RUN is called.
>>>>  	- KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
>>>>  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
>>>> -	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
>>>> +	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
>>>> +          backward compatible with v0.2) for the CPU.
>>>>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>>>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>>>  	  Depends on KVM_CAP_ARM_PMU_V3.
>>>> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
>>>> new file mode 100644
>>>> index 000000000000..aafdab887b04
>>>> --- /dev/null
>>>> +++ b/Documentation/virtual/kvm/arm/psci.txt
>>>> @@ -0,0 +1,30 @@
>>>> +KVM implements the PSCI (Power State Coordination Interface)
>>>> +specification in order to provide services such as CPU on/off, reset
>>>> +and power-off to the guest.
>>>> +
>>>> +The PSCI specification is regularly updated to provide new features,
>>>> +and KVM implements these updates if they make sense from a virtualization
>>>> +point of view.
>>>> +
>>>> +This means that a guest booted on two different versions of KVM can
>>>> +observe two different "firmware" revisions. This could cause issues if
>>>> +a given guest is tied to a particular PSCI revision (unlikely), or if
>>>> +a migration causes a different PSCI version to be exposed out of the
>>>> +blue to an unsuspecting guest.
>>>> +
>>>> +In order to remedy this situation, KVM exposes a set of "firmware
>>>> +pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>>>> +interface. These registers can be saved/restored by userspace, and set
>>>> +to a convenient value if required.
>>>> +
>>>> +The following register is defined:
>>>> +
>>>> +* KVM_REG_ARM_PSCI_VERSION:
>>>> +
>>>> +  - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
>>>> +    (and thus has already been initialized)
>>>> +  - Returns the current PSCI version on GET_ONE_REG (defaulting to the
>>>> +    highest PSCI version implemented by KVM and compatible with v0.2)
>>>> +  - Allows any PSCI version implemented by KVM and compatible with
>>>> +    v0.2 to be set with SET_ONE_REG
>>>> +  - Affects the whole VM (even if the register view is per-vcpu)  
>>>
>>
>> Hi Drew,
>>
>> Thanks for looking into this, and for the exhaustive data.
>>
>>>
>>> I've put some more thought and experimentation into this. I think we
>>> should change to a vcpu feature bit. The feature bit would be used to
>>> force compat mode, v0.2, so KVM would still enable the new PSCI
>>> version by default. Below are two tables describing why I think we
>>> should switch to something other than a new sysreg, and below those
>>> tables are notes as to why I think we should use a vcpu feature. The
>>> asterisks in the tables point out behaviors that aren't what we want.
>>> While both tables have an asterisk, the sysreg approach's issue is
>>> bug. The vcpu feature approach's issue is risk incurred from an
>>> unsupported migration, albeit one that is hard to detect without a
>>> new machine type.
>>>
>>>  +-----------------------------------------------------------------------+
>>>  |                          sysreg approach                              |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | migration        | userspace | works |             notes              |
>>>  |                  |  change   |       |                                |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | new    -> new    |   NO      |  YES  | Expected                       |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | old    -> new    |   NO      |  YES  | PSCI 1.0 is backward compatible|
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | new    -> old    |   NO      |  NO   | Migration fails due to the new |
>>>  |                  |           |       | sysreg. Migration shouldn't    |
>>>  |                  |           |       | have been attempted, but no    |
>>>  |                  |           |       | way to know without a new      |
>>>  |                  |           |       | machine type.                  |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | compat -> old    |   YES     |  NO*  | Even when setting PSCI version |
>>>  |                  |           |       | to 0.2, we add a new sysreg,   |
>>>  |                  |           |       | so migration will still fail.  |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | old    -> compat |   YES     |  YES  | It's OK for the destination to |
>>>  |                  |           |       | support more sysregs than the  |
>>>  |                  |           |       | source sends.                  |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  
>>>  
>>>  +-----------------------------------------------------------------------+
>>>  |                        vcpu feature approach                          |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | migration        | userspace | works |             notes              |
>>>  |                  |  change   |       |                                |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | new    -> new    |   NO      |  YES  | Expected                       |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | old    -> new    |   NO      |  YES  | PSCI 1.0 is backward compatible|
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | new    -> old    |   NO      |  YES* | Migrates, but it's not safe    |
>>>  |                  |           |       | for the guest kernel, and no   |
>>>  |                  |           |       | way to know without a new      |
>>>  |                  |           |       | machine type.                  |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | compat -> old    |   YES     |  YES  | Expected                       |
>>>  +------------------+-----------+-------+--------------------------------+
>>>  | old    -> compat |   YES     |  YES  | Expected                       |
>>>  +------------------+-----------+-------+--------------------------------+
>>>
>>>
>>> Notes as to why the vcpu feature approach was selected:
>>>
>>> 1) While this is VM state, and thus a VM control would be a more natural
>>>    fit, a new vcpu feature bit would be much less new code. We also
>>>    already have a PSCI vcpu feature bit, so a new one will actually fit
>>>    quite well.
>>>
>>> 2) No new state needs to be migrated, as we already migrate the feature
>>>    bitmap. Unlike, KVM, QEMU doesn't track the max number of features,
>>>    so bumping it one more in KVM doesn't require a QEMU change.
>>>
>>>
>>> If we switch to a vcpu feature bit, then I think this patch can be
>>> replaced with something like this
>>
>> A couple of remarks:
>>
>> - My worry with this feature bit  is that it is a point fix, and it
>>   doesn't scale. Come PSCI 1.2 and WORKAROUND_2, what do we do? Add
>>   another feature bit that says "force to 1.0"? I'd really like
>>   something we can live with in the long run, and "KVM as firmware"
>>   needs to be able to evolve without requiring a new userspace
>>   interface each time we rev it.
>>
>> - The "compat->old" entry in your sysreg table is not quite fair. In
>>   the feature table, you teach userspace about the new feature bit. You
>>   could just as well teach userspace about the new sysreg. Yes, things
>>   may be different in QEMU, but that's not what we're talking about
>>   here.
>>
>> - Allowing a guest to migrate in an unsafe way seems worse than failing
>>   a migration unexpectedly. Or at least not any better.
>>
>> To be clear: I'm not dismissing the idea at all, but I want to make sure
>> we're not cornering ourselves into an uncomfortable place.
>>
>> Christoffer, Peter, what are your thoughts on this?
>>
> 
> Taking a step back, the only reasons why this patch isn't simply
> enabling PSCI v1.0 by default (without any selection method) are that we
> (1) want to support guests that complain about PSCI_VERSION != 0.2
> (which isn't completely outside the realm of a reasonable implementation
> if you read the description of PSCI_VERSION in the 0.2 spec) and (2) to
> provide migration support for guests that call
> PSCI_1_0_FN_PSCI_FEATURES.
> 
> If we ignore (1) because we don't know of any guests where this is an
> issue, then it's all about (2), migration from "new -> old".
> 
> As far as I can tell, the use case we are worried about here is updating
> the kernel (and not QEMU) on half of your data center and then trying to
> migrate from the upgraded kernel machine to a legacy (and potentially
> variant 2 vulnerable) machine.  For this specific move from PSCI 0.2 to
> 1.0 with the included mitigation, I don't really think this is an
> important use case to support.

I'm not so sure. Promising mitigation to a guest, and then seeing that
mitigation being silently taken away because we've allowed it to migrate
seem bad to me.

> In terms of the more general approach to "KVM firmware upgrades" and
> migration, I think something like the proposed FW register interface
> here should work, but I'm concerned about the lack of opportunity from
> userspace to predict a migration failure.  But I don't understand why

Userspace could predict some of the failure cases, if only by checking
that all registers can be restored in a new guest. I'm not sure how
viable this is in a data centre type of environment.

> this requires a new machine type?  Why can't we simply provide a KVM
> capability that libvirt etc. can query for?
> 
> Also, is it generally true that we can't expose any additional system
> registers from KVM without breaking migration and we don't have any
> method to deal with that in userspace and upper layers?  If that's true,

It is my understanding that each time we add a new sysreg to KVM,
migration in QEMU breaks in the new->old direction.

> that's a bigger problem in general and something we should work on
> trying to solve.  If it's not true, then there should be some method to
> deal with the FW register already (like capabilities).
> 
> Given the urgency of adding mitigation towards variant 2 which is the
> driver for this work, I think we should drop the compat functionality in
> this series and work this out later on if needed.  I think we can just
> tweak the previous patch to enable PSCI 1.0 by default and drop this
> patch for the current merge window.

I'd be fine with that, as long as we have a clear agreement on the
impact of such a move.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
