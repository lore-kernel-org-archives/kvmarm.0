Return-Path: <SRS0=xsle=VW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF338C76194
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 15:36:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62DA822C7B
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jul 2019 15:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62DA822C7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9EE4A5F4;
	Thu, 25 Jul 2019 11:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y-G1NzA+7f5r; Thu, 25 Jul 2019 11:36:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 741EA4A5B2;
	Thu, 25 Jul 2019 11:36:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713704A5A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 11:36:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ACfXfZrbdJ8W for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jul 2019 11:36:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15B464A597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jul 2019 11:36:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94448344;
 Thu, 25 Jul 2019 08:36:25 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2A1C3F71A;
 Thu, 25 Jul 2019 08:36:23 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 00/10] KVM: arm/arm64: vgic: ITS translation cache
Date: Thu, 25 Jul 2019 16:35:33 +0100
Message-Id: <20190725153543.24386-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Andre Przywara <Andre.Przywara@arm.com>, "Raslan,
 KarimAllah" <karahmed@amazon.de>, "Saidi, Ali" <alisaidi@amazon.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

It recently became apparent[1] that our LPI injection path is not as
efficient as it could be when injecting interrupts coming from a VFIO
assigned device.

Although the proposed patch wasn't 100% correct, it outlined at least
two issues:

(1) Injecting an LPI from VFIO always results in a context switch to a
    worker thread: no good

(2) We have no way of amortising the cost of translating a DID+EID pair
    to an LPI number

The reason for (1) is that we may sleep when translating an LPI, so we
do need a context process. A way to fix that is to implement a small
LPI translation cache that could be looked up from an atomic
context. It would also solve (2).

This is what this small series proposes. It implements a very basic
LRU cache of pre-translated LPIs, which gets used to implement
kvm_arch_set_irq_inatomic. The size of the cache is currently
hard-coded at 16 times the number of vcpus, a number I have picked
under the influence of Ali Saidi. If that's not enough for you, blame
me, though.

Does it work? well, it doesn't crash, and is thus perfect. More
seriously, I don't really have a way to benchmark it directly, so my
observations are only indirect:

On a TX2 system, I run a 4 vcpu VM with an Ethernet interface passed
to it directly. From the host, I inject interrupts using debugfs. In
parallel, I look at the number of context switch, and the number of
interrupts on the host. Without this series, I get the same number for
both IRQ and CS (about half a million of each per second is pretty
easy to reach). With this series, the number of context switches drops
to something pretty small (in the low 2k), while the number of
interrupts stays the same.

Yes, this is a pretty rubbish benchmark, what did you expect? ;-)

Andre did run some benchmarks of his own, with some rather positive
results[2]. So I'm putting this out for people with real workloads to
try out and report what they see.

[1] https://lore.kernel.org/lkml/1552833373-19828-1-git-send-email-yuzenghui@huawei.com/
[2] https://www.spinics.net/lists/arm-kernel/msg742655.html

* From v2:

  - Added invalidation on turning the ITS off
  - Added invalidation on MAPC with V=0
  - Added Rb's from Eric

* From v1:

  - Fixed race on allocation, where the same LPI could be cached multiple times
  - Now invalidate the cache on vgic teardown, avoiding memory leaks
  - Change patch split slightly, general reshuffling
  - Small cleanups here and there
  - Rebased on 5.2-rc4

Marc Zyngier (10):
  KVM: arm/arm64: vgic: Add LPI translation cache definition
  KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
  KVM: arm/arm64: vgic-its: Add MSI-LPI translation cache invalidation
  KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on
    specific commands
  KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on
    disabling LPIs
  KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on ITS
    disable
  KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on vgic
    teardown
  KVM: arm/arm64: vgic-its: Cache successful MSI->LPI translation
  KVM: arm/arm64: vgic-its: Check the LPI translation cache on MSI
    injection
  KVM: arm/arm64: vgic-irqfd: Implement kvm_arch_set_irq_inatomic

 include/kvm/arm_vgic.h           |   3 +
 virt/kvm/arm/vgic/vgic-init.c    |   5 +
 virt/kvm/arm/vgic/vgic-irqfd.c   |  36 +++++-
 virt/kvm/arm/vgic/vgic-its.c     | 207 +++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
 virt/kvm/arm/vgic/vgic.c         |  26 ++--
 virt/kvm/arm/vgic/vgic.h         |   5 +
 7 files changed, 270 insertions(+), 16 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
