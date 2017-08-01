From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC PATCH v2 00/38] Nested Virtualization on KVM/ARM
Date: Tue, 1 Aug 2017 06:48:57 -0400
Message-ID: <CAHyh4xjKc43BQEsxvzaRWj0KzYqKh=CYa1C8Gf=7Zr2==4O4Nw@mail.gmail.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org> <20170731130054.GY5176@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731130054.GY5176@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, Daniel Lezcano <daniel.lezcano@linaro.org>, david.daney@cavium.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, stefan@hello-penguin.com, Andy Gross <andy.gross@linaro.org>, wcohen@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, lkm
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Mon, Jul 31, 2017 at 9:00 AM, Christoffer Dall <cdall@linaro.org> wrote:
> Hi Jintack,
>
> On Tue, Jul 18, 2017 at 11:58:26AM -0500, Jintack Lim wrote:
>> Nested virtualization is the ability to run a virtual machine inside ano=
ther
>> virtual machine. In other words, it=E2=80=99s about running a hypervisor=
 (the guest
>> hypervisor) on top of another hypervisor (the host hypervisor).
>>
>> Supporting nested virtualization on ARM means that the hypervisor provid=
es not
>> only EL0/EL1 execution environment to VMs as it usually does but also th=
e
>> virtualization extensions including EL2 execution environment. Once the =
host
>> hypervisor provides those execution environments to the VMs, then the gu=
est
>> hypervisor can run its own VMs (nested VMs) naturally.
>>
>> This series supports nested virtualization on arm64. ARM recently announ=
ced an
>> extension (ARMv8.3) which has support for nested virtualization[1]. This=
 patch
>> set is based on the ARMv8.3 specification and tested on the FastModel wi=
th
>> ARMv8.3 extension.
>>
>> The whole patch set to support nested virtualization is huge over 70
>> patches, so I categorized them into four parts: CPU, memory, VGIC, and t=
imer
>> virtualization. This patch series is the first part.
>>
>> CPU virtualization patch series provides basic nested virtualization fra=
mework
>> and instruction emulations including v8.1 VHE feature and v8.3 nested
>> virtualization feature for VMs.
>>
>> This patch series again can be divided into four parts. Patch 1 to 5 int=
roduces
>> nested virtualization by discovering hardware feature, adding a kernel
>> parameter and allowing the userspace to set the initial CPU mode to EL2.
>>
>> Patch 6 to 25 are to support the EL2 execution environment, the virtual =
EL2, to
>> a VM on v8.0 architecture. We de-privilege the guest hypervisor and emul=
ate the
>> virtual EL2 mode in EL1 using the hardware features provided by ARMv8.3;=
 The
>> host hypervisor manages virtual EL2 register state for the guest hypervi=
sor
>> and shadow EL1 register state that reflects the virtual EL2 register sta=
te to
>> run the guest hypervisor in EL1.
>>
>> Patch 26 to 33 add support for the virtual EL2 with Virtualization Host
>> Extensions. These patches emulate newly defined registers and bits in v8=
.1 and
>> allow the virtual EL2 to access EL2 register states via EL1 register acc=
esses
>> as in the real EL2.
>>
>> Patch 34 to 38 are to support for the virtual EL2 with nested virtualiza=
tion.
>> These enable recursive nested virtualization.
>>
>> This patch set is tested on the FastModel with the v8.3 extension for ar=
m64 and
>> a cubietruck for arm32. On the FastModel, the host and the guest kernels=
 are
>> compiled with and without VHE, so there are four combinations. I was abl=
e to
>> boot SMP Linux in the nested VM on all four configurations and able to r=
un
>> hackbench. I also checked that regular VMs could boot when the nested
>> virtualization kernel parameter was not set. On the cubietruck, I also v=
erified
>> that regular VMs could boot as well.
>>
>> I'll share my experiment setup shortly.
>>
>> Even though this work has some limitations and TODOs, I'd appreciate ear=
ly
>> feedback on this RFC. Specifically, I'm interested in:
>>
>> - Overall design to manage vcpu context for the virtual EL2
>> - Verifying correct EL2 register configurations such as HCR_EL2, CPTR_EL=
2
>>   (Patch 30 and 32)
>> - Patch organization and coding style
>>
>> This patch series is based on kvm/next d38338e.
>> The whole patch series including memory, VGIC, and timer patches is avai=
lable
>> here:
>>
>> git@github.com:columbia/nesting-pub.git rfc-v2
>>
>> Limitations:
>> - There are some cases that the target exception level of a VM is ambigu=
ous when
>>   emulating eret instruction. I'm discussing this issue with Christoffer=
 and
>>   Marc. Meanwhile, I added a temporary patch (not included in this
>>   series. f1beaba in the repo) and used 4.10.0 kernel when testing the g=
uest
>>   hypervisor with VHE.
>> - Recursive nested virtualization is not tested yet.
>> - Other hypervisors (such as Xen) on KVM are not tested.
>>
>> TODO:
>> - Submit memory, VGIC, and timer patches
>> - Evaluate regular VM performance to see if there's a negative impact.
>> - Test other hypervisors such as Xen on KVM
>> - Test recursive nested virtualization
>>
>
> I think this overall looks pretty good, and I think you can drop the RFC
> tag from the next revision, assuming the remaining patch sets for
> memory, vgic, and timers don't require some major controversial rework
> of these patches.

Thank you for your thorough review. I'm happy that we can drop the RFC tag =
:).

Thanks,
Jintack

>
> Thanks,
> -Christoffer
>
>> v1-->v2:
>> - Added support for the virtual EL2 with VHE
>> - Rewrote commit messages and comments from the perspective of supportin=
g
>>   execution environments to VMs, rather than from the perspective of the=
 guest
>>   hypervisor running in them.
>> - Fixed a few bugs to make it run on the FastModel.
>> - Tested on ARMv8.3 with four configurations. (host/guest. with/without =
VHE.)
>> - Rebased to kvm/next
>>
>> [1] https://www.community.arm.com/processors/b/blog/posts/armv8-a-archit=
ecture-2016-additions
>>
>> Christoffer Dall (7):
>>   KVM: arm64: Add KVM nesting feature
>>   KVM: arm64: Allow userspace to set PSR_MODE_EL2x
>>   KVM: arm64: Add vcpu_mode_el2 primitive to support nesting
>>   KVM: arm/arm64: Add a framework to prepare virtual EL2 execution
>>   arm64: Add missing TCR hw defines
>>   KVM: arm64: Create shadow EL1 registers
>>   KVM: arm64: Trap EL1 VM register accesses in virtual EL2
>>
>> Jintack Lim (31):
>>   arm64: Add ARM64_HAS_NESTED_VIRT feature
>>   KVM: arm/arm64: Enable nested virtualization via command-line
>>   KVM: arm/arm64: Check if nested virtualization is in use
>>   KVM: arm64: Add EL2 system registers to vcpu context
>>   KVM: arm64: Add EL2 special registers to vcpu context
>>   KVM: arm64: Add the shadow context for virtual EL2 execution
>>   KVM: arm64: Set vcpu context depending on the guest exception level
>>   KVM: arm64: Synchronize EL1 system registers on virtual EL2 entry and
>>     exit
>>   KVM: arm64: Move exception macros and enums to a common file
>>   KVM: arm64: Support to inject exceptions to the virtual EL2
>>   KVM: arm64: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
>>   KVM: arm64: Trap CPACR_EL1 access in virtual EL2
>>   KVM: arm64: Handle eret instruction traps
>>   KVM: arm64: Set a handler for the system instruction traps
>>   KVM: arm64: Handle PSCI call via smc from the guest
>>   KVM: arm64: Inject HVC exceptions to the virtual EL2
>>   KVM: arm64: Respect virtual HCR_EL2.TWX setting
>>   KVM: arm64: Respect virtual CPTR_EL2.TFP setting
>>   KVM: arm64: Add macros to support the virtual EL2 with VHE
>>   KVM: arm64: Add EL2 registers defined in ARMv8.1 to vcpu context
>>   KVM: arm64: Emulate EL12 register accesses from the virtual EL2
>>   KVM: arm64: Support a VM with VHE considering EL0 of the VHE host
>>   KVM: arm64: Allow the virtual EL2 to access EL2 states without trap
>>   KVM: arm64: Manage the shadow states when virtual E2H bit enabled
>>   KVM: arm64: Trap and emulate CPTR_EL2 accesses via CPACR_EL1 from the
>>     virtual EL2 with VHE
>>   KVM: arm64: Emulate appropriate VM control system registers
>>   KVM: arm64: Respect the virtual HCR_EL2.NV bit setting
>>   KVM: arm64: Respect the virtual HCR_EL2.NV bit setting for EL12
>>     register traps
>>   KVM: arm64: Respect virtual HCR_EL2.TVM and TRVM settings
>>   KVM: arm64: Respect the virtual HCR_EL2.NV1 bit setting
>>   KVM: arm64: Respect the virtual CPTR_EL2.TCPAC setting
>>
>>  Documentation/admin-guide/kernel-parameters.txt |   4 +
>>  arch/arm/include/asm/kvm_emulate.h              |  17 ++
>>  arch/arm/include/asm/kvm_host.h                 |  15 +
>>  arch/arm64/include/asm/cpucaps.h                |   3 +-
>>  arch/arm64/include/asm/esr.h                    |   1 +
>>  arch/arm64/include/asm/kvm_arm.h                |   2 +
>>  arch/arm64/include/asm/kvm_coproc.h             |   3 +-
>>  arch/arm64/include/asm/kvm_emulate.h            |  56 ++++
>>  arch/arm64/include/asm/kvm_host.h               |  64 ++++-
>>  arch/arm64/include/asm/kvm_hyp.h                |  24 --
>>  arch/arm64/include/asm/pgtable-hwdef.h          |   6 +
>>  arch/arm64/include/asm/sysreg.h                 |  70 +++++
>>  arch/arm64/include/uapi/asm/kvm.h               |   1 +
>>  arch/arm64/kernel/asm-offsets.c                 |   1 +
>>  arch/arm64/kernel/cpufeature.c                  |  11 +
>>  arch/arm64/kvm/Makefile                         |   5 +-
>>  arch/arm64/kvm/context.c                        | 346 +++++++++++++++++=
++++++
>>  arch/arm64/kvm/emulate-nested.c                 |  83 ++++++
>>  arch/arm64/kvm/guest.c                          |   2 +
>>  arch/arm64/kvm/handle_exit.c                    |  89 +++++-
>>  arch/arm64/kvm/hyp/entry.S                      |  13 +
>>  arch/arm64/kvm/hyp/hyp-entry.S                  |   2 +-
>>  arch/arm64/kvm/hyp/switch.c                     |  33 ++-
>>  arch/arm64/kvm/hyp/sysreg-sr.c                  | 117 ++++----
>>  arch/arm64/kvm/inject_fault.c                   |  12 -
>>  arch/arm64/kvm/nested.c                         |  63 +++++
>>  arch/arm64/kvm/reset.c                          |   8 +
>>  arch/arm64/kvm/sys_regs.c                       | 359 +++++++++++++++++=
++++++-
>>  arch/arm64/kvm/sys_regs.h                       |   8 +
>>  arch/arm64/kvm/trace.h                          |  43 ++-
>>  virt/kvm/arm/arm.c                              |  20 ++
>>  31 files changed, 1363 insertions(+), 118 deletions(-)
>>  create mode 100644 arch/arm64/kvm/context.c
>>  create mode 100644 arch/arm64/kvm/emulate-nested.c
>>  create mode 100644 arch/arm64/kvm/nested.c
>>
>> --
>> 1.9.1
>>
