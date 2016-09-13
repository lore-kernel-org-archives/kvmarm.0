From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH 0/7] Add support for monitoring guest TLB operations
Date: Tue, 13 Sep 2016 11:16:02 +0100
Message-ID: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D232349B94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:07:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqhrND+FgHrt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 06:07:54 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BEAB49B93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:07:52 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

Although there are no PMU events to monitor TLB operations, ARMv8
supports trapping guest TLB maintenance operations to the
hypervisor. This trapping mechanism can be used to monitor the use of
guest TLB instructions.

As taking a trap for every TLB operation can have significant
overhead, trapping should only be enabled -

* on user request
* for the VM of interest

This patchset adds support to listen to perf trace event state change
notifications. The notifications and associated context are then used
to enable trapping of guest TLB operations when requested by the
user. The trap handling generates trace events (kvm_tlb_invalidate)
which can already be counted using existing perf trace functionality.

I would appreciate feedback on the approach to tie the control of TLB
monitoring with perf trace events (Patch 1) especially if there are
any suggestions on avoiding (or reducing) the overhead of "perf trace"
notifications.

I looked at using regfunc/unregfunc tracepoint hooks but they don't
include the event context. But the bigger problem was that the
callbacks are only called on the first instance of simultaneously
executing perf stat invocations.

The patchset is based on v4.8-rc5 and adds support for monitoring
guest TLB operations on 64bit hosts. If the approach taken in the
patches is acceptable, I'll add 32bit host support as well.

Earlier discussion on this patchset can be found at [0][1].

Changes:

RFC v2 -> v1
* Dropped the RFC tag
* Patch 2 - Use VM thread group id for identification
* Patch 4 - Update comment for clarity
* Patch 6 - Add comment explaining switch to hype-role when VHE is enabled
* Patch 7 - Add comment to clarify struct kvm_trace_hook

RFC -> RFC v2
* Patch 4 - Rename left-over TLBI macro to __TLBI
* Patch 6 - Replace individual TLB operation emulation with
  invalidating all stage 1 TLB for the VM. TLB monitoring is expected
  to be a debug feature and performance is not critical.

With this patchset, 'perf' tool when attached to a VM process can be
used to monitor the TLB operations. E.g., to monitor a VM with process
id 4166 -

# perf stat -e "kvm:kvm_tlb_invalidate" -p 4166

Perform some operations in VM (running 'make -j 7' on the kernel
sources in this instance). Breaking out of perf shows -

Performance counter stats for process id '4166':

         7,471,974      kvm:kvm_tlb_invalidate

     374.235405282 seconds time elapsed

All feedback welcome.

Thanks,
Punit

[0] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1210715.html
[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1224353.html

Mark Rutland (2):
  arm64: tlbflush.h: add __tlbi() macro
  arm64/kvm: hyp: tlb: use __tlbi() helper

Punit Agrawal (5):
  perf/trace: Add notification for perf trace events
  KVM: Track the pid of the VM process
  KVM: arm/arm64: Register perf trace event notifier
  arm64: KVM: Handle trappable TLB instructions
  arm64: KVM: Enable selective trapping of TLB instructions

 arch/arm/include/asm/kvm_host.h   |   3 +
 arch/arm/kvm/arm.c                |   2 +
 arch/arm64/include/asm/kvm_asm.h  |   1 +
 arch/arm64/include/asm/kvm_host.h |   8 ++
 arch/arm64/include/asm/tlbflush.h |  34 +++++++--
 arch/arm64/kvm/Kconfig            |   4 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/hyp/tlb.c          |  87 +++++++++++++++++++--
 arch/arm64/kvm/perf_trace.c       | 154 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  81 ++++++++++++++++++++
 arch/arm64/kvm/trace.h            |  16 ++++
 include/linux/kvm_host.h          |   1 +
 include/linux/trace_events.h      |   3 +
 kernel/trace/trace_event_perf.c   |  24 ++++++
 virt/kvm/kvm_main.c               |   2 +
 15 files changed, 407 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/kvm/perf_trace.c

-- 
2.8.1
