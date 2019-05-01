Return-Path: <SRS0=Vsle=TB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE829C43219
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:31:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63C8020835
	for <kvmarm@archiver.kernel.org>; Wed,  1 May 2019 16:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63C8020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C5C4A486;
	Wed,  1 May 2019 12:31:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jJn457ozn8DI; Wed,  1 May 2019 12:31:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 845604A4B9;
	Wed,  1 May 2019 12:31:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 438B04A456
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:31:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BhDMB0no4vX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 May 2019 12:31:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE71F4A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 May 2019 12:31:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D393A78;
 Wed,  1 May 2019 09:31:41 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D1E63F719;
 Wed,  1 May 2019 09:31:39 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 0/5] KVM: arm/arm64: add support for chained counters
Date: Wed,  1 May 2019 17:31:26 +0100
Message-Id: <20190501163131.43175-1-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190501163126.k_Hq51IF1zQZ70tpgPBbPHvPGmBu7q7cgI428WX_Cs4@z>

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

Changes since v4:

 - Track pairs of chained counters with a bitmap instead of using
   a struct kvm_pmc_pair.

 - Rebase onto kvmarm/queue

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


Andrew Murray (5):
  KVM: arm/arm64: rename kvm_pmu_{enable/disable}_counter functions
  KVM: arm/arm64: extract duplicated code to own function
  KVM: arm/arm64: re-create event when setting counter value
  arm64: perf: extract chain helper into header
  KVM: arm/arm64: support chained PMU counters

 arch/arm64/include/asm/perf_event.h |   5 +
 arch/arm64/kernel/perf_event.c      |   2 +-
 arch/arm64/kvm/sys_regs.c           |   4 +-
 include/kvm/arm_pmu.h               |  10 +-
 virt/kvm/arm/pmu.c                  | 322 +++++++++++++++++++++++-----
 5 files changed, 280 insertions(+), 63 deletions(-)

-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
