From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v1 0/3] manually add Error Synchronization Barrier at
 exception handler entry and exit
Date: Wed, 1 Nov 2017 11:21:22 +0000
Message-ID: <7f8a9f5f-0474-c1ed-5904-3839b9073d97@arm.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>, catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, james.morse@arm.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, cov@codeaurora.org, Dave.Martin@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/11/17 19:14, Dongjiu Geng wrote:
> Some hardware platform can support RAS Extension, but not support IESB,
> such as Huawei's platform, so software need to insert Synchronization Barrier
> operations at exception handler entry.
> 
> This series patches are based on  James's series patches "SError rework +
> RAS&IESB for firmware first support". In Huawei's platform, we do not
> support IESB, so software needs to insert that.
> 
> 
> Dongjiu Geng (3):
>   arm64: add a macro for SError synchronization
>   arm64: add error synchronization barrier in kernel_entry/kernel_exit
>   KVM: arm64: add ESB in exception handler entry and exit.
> 
> James Morse (18):
>   arm64: explicitly mask all exceptions
>   arm64: introduce an order for exceptions
>   arm64: Move the async/fiq helpers to explicitly set process context
>     flags
>   arm64: Mask all exceptions during kernel_exit
>   arm64: entry.S: Remove disable_dbg
>   arm64: entry.S: convert el1_sync
>   arm64: entry.S convert el0_sync
>   arm64: entry.S: convert elX_irq
>   KVM: arm/arm64: mask/unmask daif around VHE guests
>   arm64: kernel: Survive corrected RAS errors notified by SError
>   arm64: cpufeature: Enable IESB on exception entry/return for
>     firmware-first
>   arm64: kernel: Prepare for a DISR user
>   KVM: arm64: Set an impdef ESR for Virtual-SError using VSESR_EL2.
>   KVM: arm64: Save/Restore guest DISR_EL1
>   KVM: arm64: Save ESR_EL2 on guest SError
>   KVM: arm64: Handle RAS SErrors from EL1 on guest exit
>   KVM: arm64: Handle RAS SErrors from EL2 on guest exit
>   KVM: arm64: Take any host SError before entering the guest
> 
> Xie XiuQi (2):
>   arm64: entry.S: move SError handling into a C function for future
>     expansion
>   arm64: cpufeature: Detect CPU RAS Extentions
> 
>  arch/arm64/Kconfig                   | 33 +++++++++++++-
>  arch/arm64/include/asm/assembler.h   | 59 +++++++++++++++++-------
>  arch/arm64/include/asm/barrier.h     |  1 +
>  arch/arm64/include/asm/cpucaps.h     |  4 +-
>  arch/arm64/include/asm/daifflags.h   | 61 +++++++++++++++++++++++++
>  arch/arm64/include/asm/esr.h         | 17 +++++++
>  arch/arm64/include/asm/exception.h   | 14 ++++++
>  arch/arm64/include/asm/irqflags.h    | 40 ++++++----------
>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++
>  arch/arm64/include/asm/kvm_host.h    | 16 +++++++
>  arch/arm64/include/asm/processor.h   |  2 +
>  arch/arm64/include/asm/sysreg.h      |  6 +++
>  arch/arm64/include/asm/traps.h       | 36 +++++++++++++++
>  arch/arm64/kernel/asm-offsets.c      |  1 +
>  arch/arm64/kernel/cpufeature.c       | 43 ++++++++++++++++++
>  arch/arm64/kernel/debug-monitors.c   |  5 +-
>  arch/arm64/kernel/entry.S            | 88 +++++++++++++++++++++---------------
>  arch/arm64/kernel/hibernate.c        |  5 +-
>  arch/arm64/kernel/machine_kexec.c    |  4 +-
>  arch/arm64/kernel/process.c          |  3 ++
>  arch/arm64/kernel/setup.c            |  8 ++--
>  arch/arm64/kernel/signal.c           |  8 +++-
>  arch/arm64/kernel/smp.c              | 12 ++---
>  arch/arm64/kernel/suspend.c          |  7 +--
>  arch/arm64/kernel/traps.c            | 64 +++++++++++++++++++++++++-
>  arch/arm64/kvm/handle_exit.c         | 19 +++++++-
>  arch/arm64/kvm/hyp-init.S            |  3 ++
>  arch/arm64/kvm/hyp/entry.S           | 15 ++++++
>  arch/arm64/kvm/hyp/hyp-entry.S       |  1 +
>  arch/arm64/kvm/hyp/switch.c          | 19 ++++++--
>  arch/arm64/kvm/hyp/sysreg-sr.c       |  6 +++
>  arch/arm64/kvm/inject_fault.c        | 13 +++++-
>  arch/arm64/kvm/sys_regs.c            |  1 +
>  arch/arm64/mm/proc.S                 | 14 ++++--
>  virt/kvm/arm/arm.c                   |  4 ++
>  35 files changed, 527 insertions(+), 115 deletions(-)
>  create mode 100644 arch/arm64/include/asm/daifflags.h

If you're sending a patch series, please have the cover letter describe
*those patches*, rather than dozens of other patches that aren't part of
it. This diffstat and summary is very confusing.

Robin.
