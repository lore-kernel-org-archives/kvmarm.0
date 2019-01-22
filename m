From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH 0/4] KVM: arm/arm64: add support for chained counters
Date: Tue, 22 Jan 2019 10:49:53 +0000
Message-ID: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F0104A399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:50:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CssDzctA29RS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 05:50:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48A384A394
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 05:50:03 -0500 (EST)
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

Andrew Murray (4):
  KVM: arm/arm64: extract duplicated code to own function
  KVM: arm/arm64: re-create event when setting counter value
  KVM: arm/arm64: lazily create perf events on enable
  KVM: arm/arm64: support chained PMU counters

 include/kvm/arm_pmu.h |   2 +
 virt/kvm/arm/pmu.c    | 377 +++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 327 insertions(+), 52 deletions(-)

-- 
2.7.4
