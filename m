From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v4 0/6] KVM: arm/arm64: add support for chained counters
Date: Mon, 25 Mar 2019 18:30:00 +0000
Message-ID: <20190325183006.33115-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FB74A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y6Nhu8mgDSzA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 14:30:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D53534A34E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 14:30:13 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8 provides support for chained PMU counters, where an event type
of 0x001E is set for odd-numbered counters, the event counter will
increment by one for each overflow of the preceding even-numbered
counter. Let's emulate this in KVM by creating a 64 bit perf counter
when a user chains two emulated counters together.

Testing has been performed by hard-coding hwc->sample_period in
__hw_perf_event_init (arm_pmu.c) to a small value, this results in
regular overflows (for non sampling events). The following command
was then used to measure chained and non-chained instruction cycles:

perf stat -e armv8_pmuv3/long=1,inst_retired/u \
          -e armv8_pmuv3/long=0,inst_retired/u dd if=/dev/zero bs=1M \
          count=10 | gzip > /dev/null

The reported values were identical (and for non-chained was in the
same ballpark when running on a kernel without this patchset). Debug
was added to verify that the guest received overflow interrupts for
the chain counter.

For chained events we only support generating an overflow interrupt
on the high counter. We use the attributes of the low counter to
determine the attributes of the perf event.

Changes since v3:

 - Simplify approach by not creating events lazily and by introducing
   a struct kvm_pmc_pair to represent the relationship between
   adjacent counters.

 - Rebase onto v5.1-rc2

Changes since v2:

 - Rebased onto v5.0-rc7

 - Add check for cycle counter in correct patch

 - Minor style, naming and comment changes

 - Extract armv8pmu_evtype_is_chain from arch/arm64/kernel/perf_event.c
   into a common header that KVM can use

Changes since v1:

 - Rename kvm_pmu_{enable,disable}_counter to reflect that they can
   operate on multiple counters at once and use these functions where
   possible

 - Fix bugs with overflow handing, kvm_pmu_get_counter_value did not
   take into consideration the perf counter value overflowing the low
   counter

 - Ensure PMCCFILTR_EL0 is used when operating on the cycle counter

 - Rename kvm_pmu_reenable_enabled_{pair, single} and similar

 - Always create perf event disabled to simplify logic elsewhere

 - Move PMCNTENSET_EL0 test to kvm_pmu_enable_counter_mask


Andrew Murray (6):
  KVM: arm/arm64: rename kvm_pmu_{enable/disable}_counter functions
  KVM: arm/arm64: extract duplicated code to own function
  KVM: arm/arm64: re-create event when setting counter value
  arm64: perf: extract chain helper into header
  KVM: arm/arm64: represent paired counters with kvm_pmc_pair
  KVM: arm/arm64: support chained PMU counters

 arch/arm64/include/asm/perf_event.h |   5 +
 arch/arm64/kernel/perf_event.c      |   2 +-
 arch/arm64/kvm/sys_regs.c           |   4 +-
 include/kvm/arm_pmu.h               |  23 +-
 virt/kvm/arm/pmu.c                  | 396 +++++++++++++++++++++++-----
 5 files changed, 359 insertions(+), 71 deletions(-)

-- 
2.21.0
