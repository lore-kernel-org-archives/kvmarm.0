From: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH v2 00/25] arm64: KVM: Mediate access to GICv3 sysregs at
 EL2
Date: Thu, 1 Jun 2017 14:00:21 -0700
Message-ID: <7dd609ce-6f7b-2a12-fa06-4ce1c6ba6ebe@caviumnetworks.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F9940C4A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 16:56:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvMpB9QmIqa8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 16:56:29 -0400 (EDT)
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0072.outbound.protection.outlook.com [104.47.37.72])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7B9F40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 16:56:28 -0400 (EDT)
In-Reply-To: <20170601102117.17750-1-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/01/2017 03:20 AM, Marc Zyngier wrote:
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
> I've taken the liberty to rebase David Daney's initial Cavium erratum
> 30115 workaround on top of this series, and included it here as a
> typical use case.

I pulled this from:

 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv3-cpuif-mediated-access

this morning at commit	58c1763c5aa6223ab3d04e0c183a31eb0aef832e

Entire series tested by and

Acked-by: David Daney <david.daney@cavium.com>

Thanks again.

> 
> - From v1:
>    * Fix bug in DIR handling which would have performed a deactivation even
>      when EOImode==0
>    * Some minor cleanups and clarifications.
>    * All the initial fixes have already been merged.
>    * Rebased on 4.12-rc3.
> 
> David Daney (2):
>    arm64: Add MIDR values for Cavium cn83XX SoCs
>    arm64: Add workaround for Cavium Thunder erratum 30115
> 
> Marc Zyngier (23):
>    arm64: Add a facility to turn an ESR syndrome into a sysreg encoding
>    KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
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
>   arch/arm64/Kconfig                     |  11 +
>   arch/arm64/include/asm/cpucaps.h       |   3 +-
>   arch/arm64/include/asm/cputype.h       |   2 +
>   arch/arm64/include/asm/esr.h           |  24 +
>   arch/arm64/include/asm/kvm_hyp.h       |   1 +
>   arch/arm64/include/asm/sysreg.h        |   9 +
>   arch/arm64/kernel/cpu_errata.c         |  21 +
>   arch/arm64/kvm/hyp/switch.c            |  14 +
>   include/kvm/arm_vgic.h                 |   1 +
>   include/linux/irqchip/arm-gic-v3.h     |   6 +
>   virt/kvm/arm/aarch32.c                 |   2 +-
>   virt/kvm/arm/hyp/vgic-v3-sr.c          | 803 ++++++++++++++++++++++++++++++++-
>   virt/kvm/arm/vgic/vgic-v3.c            |  45 ++
>   14 files changed, 925 insertions(+), 18 deletions(-)
> 
