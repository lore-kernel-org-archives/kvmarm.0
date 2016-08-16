From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 0/7] Add support for monitoring guest TLB operations
Date: Tue, 16 Aug 2016 11:45:05 +0100
Message-ID: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Punit Agrawal <punit.agrawal@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

ARMv8 supports trapping guest TLB maintenance operations to the
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
which can already be counted using existing perf trace
functionality.

Trapping of guest TLB operations is disabled when not being monitored
(reducing profiling overhead).

I would appreciate feedback on the approach to tie the control of TLB
monitoring with perf trace events (Patch 1) especially if there are
any suggestions on avoiding (or reducing) the overhead of "perf trace"
notifications.

I looked at using regfunc/unregfunc tracepoint hooks but they don't
include the event context. But the bigger problem was that the
callbacks are only called on the first instance of simultaneously
executing perf stat invocations.

The patchset is based on v4.8-rc2 and adds support for monitoring
guest TLB operations on 64bit hosts. If the approach taken in the
patches is acceptable, I'll add 32bit host support as well.

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
 arch/arm64/include/asm/tlbflush.h |  31 ++++++--
 arch/arm64/kvm/Kconfig            |   4 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/hyp/tlb.c          | 158 ++++++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/perf_trace.c       | 154 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  81 +++++++++++++++++++
 arch/arm64/kvm/trace.h            |  16 ++++
 include/linux/kvm_host.h          |   1 +
 include/linux/trace_events.h      |   3 +
 kernel/trace/trace_event_perf.c   |  24 ++++++
 virt/kvm/kvm_main.c               |   2 +
 15 files changed, 475 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm64/kvm/perf_trace.c

-- 
2.8.1
