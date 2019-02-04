From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v2 0/5] KVM: arm/arm64: add support for chained counters
Date: Mon,  4 Feb 2019 16:53:33 +0000
Message-ID: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA8F34A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 11:53:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VqsbRYuQEXeY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 11:53:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB7D4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 11:53:45 -0500 (EST)
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

Andrew Murray (5):
  KVM: arm/arm64: rename kvm_pmu_{enable/disable}_counter functions
  KVM: arm/arm64: extract duplicated code to own function
  KVM: arm/arm64: re-create event when setting counter value
  KVM: arm/arm64: lazily create perf events on enable
  KVM: arm/arm64: support chained PMU counters

 arch/arm64/kvm/sys_regs.c |   4 +-
 include/kvm/arm_pmu.h     |   9 +-
 virt/kvm/arm/pmu.c        | 409 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 352 insertions(+), 70 deletions(-)

-- 
2.7.4
