From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Wed, 25 Oct 2017 18:42:55 +0100
Message-ID: <59F0CD1F.9070201@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2016BA9E4@DGGEMA503-MBX.china.huawei.com> <0184EA26B2509940AA629AE1405DD7F2016BAC2B@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2016BAC2B@DGGEMA503-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "lishuo (A)" <lishuo1@hisilicon.com>, "Liujun (Jun Liu)" <liujun88@hisilicon.com>, "Lilei (Lious)" <lious.lilei@hisilicon.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Huangshaoyu <huangshaoyu@huawei.com>, Wuquanming <wuquanming@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 20/10/17 16:33, gengdongjiu wrote:
> As we discuss below solution:
> When guest happen SEA/SEI, KVM calls memory_failure() to send an asynchronous SIGBUS
> signal(BUS_MCEERR_AO) to QEMU, and make this address to poisoned.
> after QEMU receive this BUS_MCEERR_AO, it will record this address to CPER and notify guest.
> When guest happen stage2 page fault, KVM send a synchronous SIGBUS
> BUS_MCEERR_AR to QEMU, and QEMU also record CPER and immediately inject SEA abort.
> 
> But this solution, still have some problems.
> 
> 1. In some situation, For RAS, when happen SEA, hardware cannot provide an error physical
> address

Eh? For any RAS error you should get a physical address in ERR<n>ADDR.

When you get an external abort due to RAS you can scan these nodes to find which
one generated the error and collect the component information.
Doing this in firmware is better because firmware knows the SoC topology, so it
can skip the nodes it knows won't be relevant to an error on this CPU.


> to software instead it can only provide virtual address in FAR_ELx, 
> This is to say, firmware cannot provide physical error address, but provided the virtual
> address in the FAR_ELx. so BIOS cannot record this address to APEI table. In

Nit: APEI table, you mean recorded as CPER records in a buffer pointed to by a
GHES's ErrorStatusAddress. APEI tables aren't parsed post boot.


> this case, when firmware Jump to hypervisor, hypervisor cannot call
> memory_failure(), now only the physical address is recorded and valid, APEI
> driver will call the memory_failure()), in this case, host will not send SIGBUS
> to QEMU. So guest cannot know there is SEA happen.
> At least there is such issue in Huawei's platform (cannot provide PA for RAS firmware-first,
> only can provide VA in FAR_ELx)

This isn't a KVM problem.

It looks like both of UEFI's 'Table 275. Memory Error Record' and 'Table 276.
Memory Error Record 2' require a physical address. You can't describe a memory
error without one.

Is this really a memory error?, or some other component, say, a virtually
indexed cache.


> 2. if there is SEA/SEI, only deliver SIGBUS to notify QEMU. This information is limit.
> This SIGBUS can only provide an address and si_code(BUS_MCEERR_AO/ BUS_MCEERR_AR), nothing else.
> if QEMU record CPER and inject SEA/specify ESR, it may needs to know more information.
> For example, if it injects SEA, it needs so setup many registers for guest, such as 
> FAR_EL1. If sets it, it needs to know FAR_EL2.

Linux is given CPER records describing a memory error using NOTIFY_IRQ. It
delivers BUS_MCEERR_AO to Qemu. What value does FAR_EL2 have?

Even for 'AR' from KVM, we already know Marc is against exposing EL2 registers. [0]


> But QEMU cannot know this information to setup it if KVM cannot pass more fault info to QEMU.
> Of cause, we can identify the guest FAR_El1 register to invalid. But some time, guest needs to
> know it in the situation that host cannot provide the PA.

When is this? You can get the IPA from the si_addr and Qemu's memory layout. The
IPA goes in the CPER records allowing you to emulate firmware first.
The IPA goes in the ERR<n>ADDR register (once we have emulation support for it),
covering the kernel first case.

What's left? Neither: You can generate an external abort using DFSC=0b010000 and
set FnV to tell it you don't have a virtual stage1 address.


A better argument is that user-space needs to know if BUS_MCEERR_AR triggered by
KVM's stage2 was an instruction or data abort so it can make this the correct
flavour of Synchronous External Abort.

I agree this bit needs exposing (but only for exits due to BUS_MCEERR_AR
triggered by KVM at stage2), and maybe KVM could include a little more
information to allow the full range of external-abort ESRs to be used.



> 3. For SEI, the address is invalid, 

You mean FAR_ELx?


> so in some platform, firmware will not record this AP.

For any RAS error you should get a physical address in ERR<n>ADDR.


> At least in HUAWEI's platform, firmware will not record it. we cannot always
> think that all platform can record PA for RAS, sometime it may use
> VA(in FAR_ELx).

What component do you see this happen with?


> For SEI, if the address is not recorded, then the
> memory_failure() will be not called. So guest will not know it happens SEI.


Thanks,

James

[0] https://lkml.org/lkml/2017/8/7/612
