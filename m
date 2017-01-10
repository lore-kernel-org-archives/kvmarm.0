From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v3 0/9] Add support for monitoring guest TLB operations
Date: Tue, 10 Jan 2017 11:38:47 +0000
Message-ID: <20170110113856.7183-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This is a new version of the patchset to monitor guest TLB
operations. The user interface has been re-written to incorporate
feedback from LPC'16 on the previous version - it now uses a software
PMU instead of relying on perf trace to track guest TLB operations
(Patch 6 and 7). Previous versions of the patches can be found at
[0][1][2][3].

Guest TLB operations can impact on system performance but these are
not exported as architected PMU events on arm/arm64. Instead the
architecture allows trapping of TLB operations to the hypervisor. This
patchset builds on this feature to monitor TLB operations.

To minimise the performance impact, trapping is enabled -
* on user request
* for the VM of interest

With this patchset, running 'perf' on the host can be used to monitor
the TLB operations. E.g., to monitor a VM with process id 2589 -

# perf stat -a -C 0 -e kvm/kvm_tlb_invalidate,vm=2589/ sleep 25

 Performance counter stats for 'system wide':

             3,386      kvm/tlb_invalidate,vm=2589/

      25.001086522 seconds time elapsed


The patches are based on v4.10-rc3 and have been tested on arm and
arm64.

Thanks,
Punit

[0] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1210715.html
[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1224353.html
[2] https://marc.info/?l=linux-kernel&m=147376184208258&w=2
[3] https://marc.info/?l=kvm&m=147750373716545&w=2

Changes:
v2 -> v3
* Replaced perf trace monitoring with software PMU
* Re-ordered patches as a result of the above re-write

v1 -> v2

* New (Patch 6) - Add support for trapping and emulating TLB
  operations to ARM hosts
* Move common code to handle perf trace notifications to virt/kvm/arm
* Move tracepoint to include/trace/events/kvm.h
* Drop patch to introduce __tlbi helper as it is now merged
* Reorder patches

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



Mark Rutland (1):
  arm64/kvm: hyp: tlb: use __tlbi() helper

Punit Agrawal (8):
  KVM: Track the pid of the VM process
  KVM: Add event to trace tlb invalidations
  arm: KVM: Handle trappable TLB instructions
  arm64: KVM: Handle trappable TLB instructions
  kvm: arm/arm64: Add host pmu to support VM introspection
  kvm: host_pmu: Add support for tracking guest TLB operations
  arm: KVM: Enable support for host pmu
  arm64: KVM: Enable support for the host pmu

 arch/arm/include/asm/kvm_asm.h    |   2 +
 arch/arm/include/asm/kvm_host.h   |   9 ++
 arch/arm/kvm/Kconfig              |   4 +
 arch/arm/kvm/Makefile             |   1 +
 arch/arm/kvm/arm.c                |   2 +
 arch/arm/kvm/coproc.c             |  56 +++++++
 arch/arm/kvm/hyp/tlb.c            |  33 ++++
 arch/arm64/include/asm/kvm_asm.h  |   2 +
 arch/arm64/include/asm/kvm_host.h |   9 ++
 arch/arm64/kvm/Kconfig            |   4 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/hyp/tlb.c          |  87 +++++++++-
 arch/arm64/kvm/sys_regs.c         |  83 ++++++++++
 include/linux/kvm_host.h          |   1 +
 include/trace/events/kvm.h        |  18 +++
 virt/kvm/arm/host_pmu.c           | 322 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c               |   2 +
 17 files changed, 630 insertions(+), 6 deletions(-)
 create mode 100644 virt/kvm/arm/host_pmu.c

-- 
2.11.0

