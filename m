From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 0/9] Add support for monitoring guest TLB operations
Date: Tue, 31 Jan 2017 17:16:21 +0000
Message-ID: <20170131171630.26898-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B52040967
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:16:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I5QtKBN5mMA8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 12:16:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E40740966
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 12:16:33 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series adds support for a software pmu on the host which can be
used to monitor VM operations. For arm and arm64, support is added to
monitor guest TLB operations using the host pmu infrastructure.

This posting addresses all feedback on the previous
version[0]. Instead of requiring a VM pid as part of the event
attribute, it now depends on vcpu thread ids being passed via the
standard perf interface (-t). Thread ids instead of process ids (-p)
is used as -p when called with the thread id ends up resolving to the
parent process.

Prior versions can be found at [1][2][3][4].

As a result of the changes, the user interface has changed as
well. With the patchset, TLB operations can be monitored using -

# perf stat -e kvm/tlb_invalidate/ -t 3967,3968
^C
 Performance counter stats for thread id '3967,3968':

                71      kvm/tlb_invalidate/

      10.207587028 seconds time elapsed

where 3967 and 3968 are the thread ids of the vcpus.

Patches based on v4.10-rc6.

Thanks,
Punit

[0] http://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg09357.html
[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1210715.html
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1224353.html
[3] https://marc.info/?l=linux-kernel&m=147376184208258&w=2
[4] https://marc.info/?l=kvm&m=147750373716545&w=2

Changes:
v3 -> v4
* Use vcpupid specified via perf instead of custom VM specifier. This
  results in simplifying the synchronisation requirements for
  callbacks
* Dropped change to track VM pid as it's no longer being used
* Moved host pmu to virt/kvm
* Added copyright headers

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
  KVM: Add event to trace tlb invalidations
  arm: KVM: Handle trappable TLB instructions
  arm64: KVM: Handle trappable TLB instructions
  kvm: Add host pmu to support VM introspection
  kvm: host_pmu: Add support for tracking guest TLB operations
  arm64: KVM: Enable support for the host pmu
  arm: KVM: Enable support for host pmu
  arm: KVM: Initialise the host pmu

 arch/arm/include/asm/kvm_asm.h    |   2 +
 arch/arm/include/asm/kvm_host.h   |   9 ++
 arch/arm/kvm/Kconfig              |   1 +
 arch/arm/kvm/Makefile             |   1 +
 arch/arm/kvm/arm.c                |   2 +
 arch/arm/kvm/coproc.c             |  56 +++++++++
 arch/arm/kvm/hyp/tlb.c            |  33 +++++
 arch/arm64/include/asm/kvm_asm.h  |   2 +
 arch/arm64/include/asm/kvm_host.h |   9 ++
 arch/arm64/kvm/Kconfig            |   1 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/hyp/tlb.c          |  87 +++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  83 +++++++++++++
 include/kvm/host_pmu.h            |  35 ++++++
 include/trace/events/kvm.h        |  18 +++
 virt/kvm/Kconfig                  |   3 +
 virt/kvm/arm/host_pmu_events.c    |  82 +++++++++++++
 virt/kvm/host_pmu.c               | 246 ++++++++++++++++++++++++++++++++++++++
 18 files changed, 665 insertions(+), 6 deletions(-)
 create mode 100644 include/kvm/host_pmu.h
 create mode 100644 virt/kvm/arm/host_pmu_events.c
 create mode 100644 virt/kvm/host_pmu.c

-- 
2.11.0
