From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 0/2] kvm: arm/arm64: Fix emulated physical timer IRQ
 injection
Date: Wed, 25 Jul 2018 10:19:57 +0100
Message-ID: <20180725091959.11475-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D1804065F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 05:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9s89z9JCd1rd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 05:20:37 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0513340493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 05:20:36 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

those two patches fix the (physical EL1) arch timer emulation in KVM,
which missed to inject the timer IRQ if the vCPU was asleep when the
timer expired. This can be checked by a new kvm-unit-tests test [1].

I am now taking Christoffer's approach, which keeps phys_timer_emulate()
mostly as it is, and adds the explicit IRQ injection check in the caller.
This turned out to fit better into the upcoming arch timer rework.

Cheers,
Andre.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2018-July/032220.html

Christoffer Dall (2):
  KVM: arm/arm64: Fix potential loss of ptimer interrupts
  KVM: arm/arm64: Fix lost IRQs from emulated physcial timer when
    blocked

 virt/kvm/arm/arch_timer.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

-- 
2.14.4
