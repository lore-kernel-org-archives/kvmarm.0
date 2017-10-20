From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from
 userspace
Date: Fri, 20 Oct 2017 15:36:51 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2016BAC5F@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: kvm-owner@vger.kernel.org
To: 'James Morse' <james.morse@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: "lishuo (A)" <lishuo1@hisilicon.com>, "Liujun (Jun Liu)" <liujun88@hisilicon.com>, "Lilei (Lious)" <lious.lilei@hisilicon.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Huangshaoyu <huangshaoyu@huawei.com>, Wuquanming <wuquanming@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

CC James.

> > In the user space, we can check the si_code, if it is 
> > "BUS_MCEERR_AR", we use SEA notification type for the guest; if it is "BUS_MCEERR_AO", we use SEI notification type for the guest.
> > Because there are only two values for si_code("BUS_MCEERR_AR" and 
> > BUS_MCEERR_AO), in which case we can use the GSIV(IRQ)
> notification type?
> 
> This is for Qemu/kvmtool to decide, it depends on what sort of machine they are emulating.
> 
> For example, the physical machine's memory-controller may notify the 
> CPU about memory errors by triggering SError trapped to EL3, or with a 
> dedicated FIQ, also routed to EL3. By the time this gets to the host kernel the distinction doesn't matter. The host has handled the error.
> 
> For a guest, your memory-controller is effectively the host kernel. It 
> will give you an BUS_MCEERR_AO signal for any guest memory that is affected, and a BUS_MCEERR_AR if the guest directly accesses a page of affected memory.
> 
> What Qemu/kvmtool do with this is up to them. If they're emulating a machine with no RAS features, printing an error and exit.
> 
> Otherwise BUS_MCEERR_AR could be notified as one of the flavours of 
> IRQ, unless the affected vcpu has interrupts masked, in which case an SEA notification gives you some NMI-like behaviour.
> 
> For BUS_MCEERR_AO you could use SEI, IRQ or polled notification. My 
> choice would be IRQ, as you can't know if the guest supports SEI and 
> it would be a shame to kill it with an SError if the affected memory was free. SEA for synchronous errors is still a good choice even if the guest doesn't support it as that memory is still gone so its still a valid guest:Synchronous-external-abort.
> 

Add James.

CC some huawei's hardware engineers.

Hi James/Marc/Christoffer,

  As we discuss below solution:
When guest happen SEA/SEI, KVM calls memory_failure() to send an asynchronous SIGBUS signal(BUS_MCEERR_AO) to QEMU, and make this address to poisoned.
after QEMU receive this BUS_MCEERR_AO, it will record this address to CPER and notify guest. When guest happen stage2 page fault, KVM send a synchronous SIGBUS BUS_MCEERR_AR to QEMU, and QEMU also record CPER and immediately inject SEA abort.

But this solution, still have some problems.

1. In some situation, For RAS, when happen SEA, hardware cannot provide an error physical address to software instead it can only provide virtual address in FAR_ELx, This is to say, firmware cannot provide physical error address, but provided the virtual address in the FAR_ELx.
so BIOS cannot record this address to APEI table. In this case, when firmware Jump to hypervisor, hypervisor cannot call memory_failure(), now only the physical address is recorded and valid, APEI driver will call the memory_failure()), in this case, host will not send SIGBUS to QEMU. So guest cannot know there is SEA happen.
At least there is such issue in Huawei's platform (cannot provide PA for RAS firmware-first, only can provide VA in FAR_ELx)

2. if there is SEA/SEI, only deliver SIGBUS to notify QEMU. This information is limit.
 This SIGBUS can only provide an address and si_code(BUS_MCEERR_AO/ BUS_MCEERR_AR), nothing else.
 if QEMU record CPER and inject SEA/specify ESR, it may needs to know more information.
For example, if it injects SEA, it needs so setup many registers for guest, such as FAR_EL1. If sets it, it needs to know FAR_EL2.
 But QEMU cannot know this information to setup it if KVM cannot pass more fault info to QEMU.
 Of cause, we can identify the guest FAR_El1 register to invalid. But some time, guest needs to know it in the situation that host cannot provide the PA.

3. For SEI, the address is invalid, so in some platform, firmware will not record this AP. At least in HUAWEI's platform, firmware will not record it.
  we cannot always think that all platform can record PA for RAS, sometime it may use VA(in FAR_ELx).
  For SEI, if the address is not recorded, then the memory_failure() will be not called. So guest will not know it happens SEI. 
