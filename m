From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 0/8] Add support for monitoring guest TLB operations
Date: Tue, 08 Nov 2016 17:19:47 +0000
Message-ID: <87vavx51os.fsf@e105922-lin.cambridge.arm.com>
References: <20161026174148.17172-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161026174148.17172-1-punit.agrawal@arm.com> (Punit Agrawal's
        message of "Wed, 26 Oct 2016 18:41:40 +0100")
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

[ +PeterZ who should've been cc'd but doesn't show up in get_maintainers ]

Punit Agrawal <punit.agrawal@arm.com> writes:

> Hi,
>
> This is the fourth posting of this series. The biggest change compared
> to previous vesion is the addition of support for ARM hosts. With the
> addition of ARM support, the patchset is now more complete. Prior
> versions can be found at [0][1][2].
>
> I would particularly appreciate feedback from maintainers on the
> approach to tie the control of TLB monitoring with perf trace events
> (Patch 3 and 4) especially if there are any suggestions on avoiding
> (or reducing) the overhead of "perf trace" notifications.
>
> I looked at using regfunc/unregfunc tracepoint hooks but they don't
> include the event context. But the bigger problem was that the
> callbacks are only called on the first instance of simultaneously
> executing perf stat invocations.

I had a chance to discuss this patchset with SteveR and PeterZ at LPC
and both don't like the idea of introducing notifications on perf trace
event [un]registration.

Peter suggested using the PMU interface to expose this functionality. As
we want to monitor TLB instructions for for each VM, this will require
creating a PMU per-VM. The PMU events can be extended in the future if
monitoring of additional operations is supported and required.

I'll post the next version with the above changes - please chime-in if
you disagrees with this approach.

Thanks,
Punit

>
> Changelog and previous cover-letter follows.
>
> Changes:
>
> v1 -> v2
>
> * New (Patch 6) - Add support for trapping and emulating TLB
>   operations to ARM hosts
> * Move common code to handle perf trace notifications to virt/kvm/arm
> * Move tracepoint to include/trace/events/kvm.h
> * Drop patch to introduce __tlbi helper as it is now merged
> * Reorder patches
>
> RFC v2 -> v1
> * Dropped the RFC tag
> * Patch 2 - Use VM thread group id for identification
> * Patch 4 - Update comment for clarity
> * Patch 6 - Add comment explaining switch to hype-role when VHE is enabled
> * Patch 7 - Add comment to clarify struct kvm_trace_hook
>
> RFC -> RFC v2
> * Patch 4 - Rename left-over TLBI macro to __TLBI
> * Patch 6 - Replace individual TLB operation emulation with
>   invalidating all stage 1 TLB for the VM. TLB monitoring is expected
>   to be a debug feature and performance is not critical.
>
> Although there are no PMU events to monitor TLB operations, ARMv8
> supports trapping guest TLB maintenance operations to the
> hypervisor. This trapping mechanism can be used to monitor the use of
> guest TLB instructions.
>
> As taking a trap for every TLB operation can have significant
> overhead, trapping should only be enabled -
>
> * on user request
> * for the VM of interest
>
> This patchset adds support to listen to perf trace event state change
> notifications. The notifications and associated context are then used
> to enable trapping of guest TLB operations when requested by the
> user. The trap handling generates trace events (kvm_tlb_invalidate)
> which can already be counted using existing perf trace functionality.
>
> With this patchset, 'perf' tool when attached to a VM process can be
> used to monitor the TLB operations. E.g., to monitor a VM with process
> id 4166 -
>
> # perf stat -e "kvm:kvm_tlb_invalidate" -p 4166
>
> Perform some operations in VM (running 'make -j 7' on the kernel
> sources in this instance). Breaking out of perf shows -
>
> Performance counter stats for process id '4166':
>
>          7,471,974      kvm:kvm_tlb_invalidate
>
>      374.235405282 seconds time elapsed
>
> Thanks,
> Punit
>
> [0] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1210715.html
> [1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1224353.html
> [2] https://marc.info/?l=linux-kernel&m=147376184208258&w=2
>
> Mark Rutland (1):
>   arm64/kvm: hyp: tlb: use __tlbi() helper
>
> Punit Agrawal (7):
>   KVM: Track the pid of the VM process
>   perf/trace: Add notification for perf trace events
>   KVM: arm/arm64: Register perf trace event notifier
>   KVM: Add event to trace tlb invalidations
>   arm: KVM: Handle trappable TLB instructions
>   arm64: KVM: Handle trappable TLB instructions
>   KVM: arm/arm64: Enable selective trapping of TLB instructions
>
>  arch/arm/include/asm/kvm_asm.h    |   1 +
>  arch/arm/include/asm/kvm_host.h   |   8 ++
>  arch/arm/kvm/Kconfig              |   4 +
>  arch/arm/kvm/Makefile             |   1 +
>  arch/arm/kvm/arm.c                |   2 +
>  arch/arm/kvm/coproc.c             |  55 ++++++++++++++
>  arch/arm/kvm/hyp/tlb.c            |  33 ++++++++
>  arch/arm64/include/asm/kvm_asm.h  |   1 +
>  arch/arm64/include/asm/kvm_host.h |   8 ++
>  arch/arm64/kvm/Kconfig            |   4 +
>  arch/arm64/kvm/Makefile           |   1 +
>  arch/arm64/kvm/hyp/tlb.c          |  87 +++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.c         |  81 ++++++++++++++++++++
>  include/linux/kvm_host.h          |   1 +
>  include/linux/trace_events.h      |   3 +
>  include/trace/events/kvm.h        |  17 +++++
>  kernel/trace/trace_event_perf.c   |  24 ++++++
>  virt/kvm/arm/perf_trace.c         | 154 ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |   2 +
>  19 files changed, 481 insertions(+), 6 deletions(-)
>  create mode 100644 virt/kvm/arm/perf_trace.c
