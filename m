From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 00/31] arm64: KVM: Mediate access to GICv3 sysregs at EL2
Date: Mon, 8 May 2017 17:05:56 -0700
Message-ID: <3f177b5e-e5c1-c681-1607-0a80c5aafba4@caviumnetworks.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/03/2017 03:45 AM, Marc Zyngier wrote:
> [Apologies for posting this at the beginning of a merge window, but as
>   this is a rather hot topic, I'd rather put it out as soon as possible]
> 
> Some systems have less than perfect GICv3 implementations, leading to
> all kind of ugly issues (guest hanging, host dying). In order to allow
> some level of diagnostic, and in some cases implement workarounds,
> this series enables the trapping of both Group-0, Group-1 and Common
> sysregs. Mediating the access at EL2 allows some form of sanity
> checking that the HW is sometimes sorely lacking.
> 
> Instead of fully emulating a GICv3 CPU interface, we still use the
> existing HW (list registers, AP registers, VMCR...), which allows the
> code to be independent from the rest of the KVM code, and to cope with
> partial trapping.
> 
> Of course, trapping has a cost, which is why this must be either
> enabled on the command line, or selected by another cpu capability
> (see Cavium erratum 30115). A quick test on an A57-based platform
> shows a 25% hit when repeatedly banging on the trapped registers,
> while normal workloads do not seem to suffer noticeably from such
> trapping (hackbench variance is in the usual noise, despite being very
> IPI happy).
> 
> This has been tested on a dual socket Thundex-X and a Freescale LS-2085a.
> 
> The first 6 patches are fixes, and only here for reference as they
> have already been posted separately. The rest of the patches implement
> Group-1, Group-0 and Common sysreg handlers, with the corresponding
> command line options. I've also taken the liberty to rebase David
> Daney's initial Cavium erratum 30115 workaround on top of this series,
> and included it here as a typical use case.
> 


Thanks Marc for working on this.

I tested this series based on your git branch:
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv3-cpuif-mediated-access

This does indeed fix the problems we were seeing, so feel free to add:

Tested-by: David Daney <david.daney@cavium.com>

to the entire series.

I would note that with these patches we see an occasional:

[ 3868.311491] Unexpected interrupt 4 on vcpu ffff801f57a6a020
[ 4262.063419] Unexpected interrupt 4 on vcpu ffff801f5b3dc040
[ 4262.063422] Unexpected interrupt 4 on vcpu ffff801f50972020

This is better than locking up the system, but I wonder if it indicates 
that improvement to the code is still possible.

David Daney



> David Daney (2):
>    arm64: Add MIDR values for Cavium cn83XX SoCs
>    arm64: Add workaround for Cavium Thunder erratum 30115
> 
> Marc Zyngier (29):
>    arm64: KVM: Fix decoding of Rt/Rt2 when trapping AArch32 CP accesses
>    arm64: KVM: Do not use stack-protector to compile EL2 code
>    arm: KVM: Do not use stack-protector to compile HYP code
>    KVM: arm/arm64: vgic-v2: Do not use Active+Pending state for a HW
>      interrupt
>    KVM: arm/arm64: vgic-v3: Do not use Active+Pending state for a HW
>      interrupt
>    KVM: arm/arm64: vgic-v3: Use PREbits to infer the number of
>      ICH_APxRn_EL2 registers
>    KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
>    arm64: Add a facility to turn an ESR syndrome into a sysreg encoding
>    KVM: arm64: Make kvm_condition_valid32() accessible from EL2
>    KVM: arm64: vgic-v3: Add hook to handle guest GICv3 sysreg accesses at
>      EL2
>    KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_IGRPEN1_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_AP1Rn_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_HPPIR1_EL1 handler
>    KVM: arm64: vgic-v3: Enable trapping of Group-1 system registers
>    KVM: arm64: Enable GICv3 Group-1 sysreg trapping via command-line
>    KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_IGNREN0_EL1 handler
>    KVM: arm64: vgic-v3: Add misc Group-0 handlers
>    KVM: arm64: vgic-v3: Enable trapping of Group-0 system registers
>    KVM: arm64: Enable GICv3 Group-0 sysreg trapping via command-line
>    KVM: arm64: vgic-v3: Add ICV_DIR_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_RPR_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
>    KVM: arm64: vgic-v3: Add ICV_PMR_EL1 handler
>    KVM: arm64: Enable GICv3 common sysreg trapping via command-line
>    KVM: arm64: vgic-v3: Log which GICv3 system registers are trapped
> 
>   Documentation/arm64/silicon-errata.txt |   1 +
>   arch/arm/kvm/hyp/Makefile              |   2 +
>   arch/arm64/Kconfig                     |  11 +
>   arch/arm64/include/asm/cpucaps.h       |   3 +-
>   arch/arm64/include/asm/cputype.h       |   2 +
>   arch/arm64/include/asm/esr.h           |  25 ++
>   arch/arm64/include/asm/kvm_emulate.h   |   6 +
>   arch/arm64/include/asm/kvm_hyp.h       |   1 +
>   arch/arm64/include/asm/sysreg.h        |   9 +
>   arch/arm64/kernel/cpu_errata.c         |  21 +
>   arch/arm64/kvm/hyp/Makefile            |   2 +
>   arch/arm64/kvm/hyp/switch.c            |  14 +
>   arch/arm64/kvm/sys_regs.c              |   8 +-
>   include/kvm/arm_vgic.h                 |   1 +
>   include/linux/irqchip/arm-gic-v3.h     |   6 +
>   virt/kvm/arm/aarch32.c                 |   2 +-
>   virt/kvm/arm/hyp/vgic-v3-sr.c          | 792 +++++++++++++++++++++++++++++++--
>   virt/kvm/arm/vgic/vgic-v2.c            |   7 +
>   virt/kvm/arm/vgic/vgic-v3.c            |  52 +++
>   19 files changed, 934 insertions(+), 31 deletions(-)
> 
