Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF56C4332E
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:24:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A9D42078A
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 18:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxQo+XSR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A9D42078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E61C54B0A6;
	Fri, 20 Mar 2020 14:24:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vY-xP37AIfRM; Fri, 20 Mar 2020 14:24:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6974B0AA;
	Fri, 20 Mar 2020 14:24:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7504B0A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:24:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hdn--6-mVI9k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 14:24:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA8934A5A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 14:24:34 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C4BFF20767;
 Fri, 20 Mar 2020 18:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584728673;
 bh=OjWX+qwHZ6kJjLfCNmQUx1QBDMRyFaiz20SBTxnP4VY=;
 h=From:To:Cc:Subject:Date:From;
 b=AxQo+XSRfVNOtjYiVNPa9dIIogX1mu/9qfzW74IxW1pC7RhMbm0C5+X8c+w1hVSzE
 FUivaVM3+2TpCnpyDdGgiKnFGiOlPwNrbbKKOPsjKjzhHBkmpWn89R7i6xHf1N3p5p
 56OFSEOlR/L7NTWxvfs/vegxgadi/VP8yBejMHXQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFMJs-00EKAx-4i; Fri, 20 Mar 2020 18:24:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/23] irqchip/gic-v4: GICv4.1 architecture support
Date: Fri, 20 Mar 2020 18:23:43 +0000
Message-Id: <20200320182406.23465-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

This (now shorter) series expands the existing GICv4 support to deal
with the new GICv4.1 architecture, which comes with a set of major
improvements compared to v4.0:

- One architectural doorbell per vcpu, instead of one doorbell per VLPI

- Doorbell entirely managed by the HW, with an "at most once" delivery
  guarantee per non-residency phase and only when requested by the
  hypervisor

- A shared memory scheme between ITSs and redistributors, allowing for an
  optimised residency sequence (the use of VMOVP becomes less frequent)

- Support for direct virtual SGI delivery (the injection path still involves
  the hypervisor), at the cost of losing the active state on SGIs. It
  shouldn't be a big deal, but some guest operating systems might notice
  (Linux definitely won't care).

Some documentation is now available [0] in the IHI0069F documentation
from ARM (although still not final).

The series is roughly organised in 3 parts:

(0) Fixes
(1) v4.1 doorbell management
(2) Virtual SGI support
(3) Plumbing of virtual SGIs in KVM

Notes:

  - The whole thing is tested on a FVP model, which can be obtained
    free of charge on ARM's developer website. It requires you to
    create an account, unfortunately...

  - This series has uncovered a behaviour that looks like a HW bug on
    the Cavium ThunderX (aka TX1) platform. The fix for this is now
    in mainline (d01fd161e859).

  - I'm extremely grateful for Zenghui Yu's huge effort in carefully
    reviewing this rather difficult series (if we ever get to meet
    face to face, drinks are definitely on me!).

  - Thanks to Eric Auger for having joined the fun and spotted a
    number of funky things!

  - This is now left to brew in -next. Any issue will be fixed by
    addtional patches.

* From v5 [5]
  - Fixed VMOVP not being issued on systems that are not single-VMOVP
    capable
  - Propagated error on irq_get_irqchip_state() failure for vSGIs
  - vSGI pending state is now get reported to userspace
  - Restoring a GICD_TYPER2 value that doesn't match what KVM can offer
    because nASSGIcap is different results in a failure
  - Fixed locking on switch between SGI implementations
  - Added more comments where required to clarify the behaviour of
    some of the most nebulous parts

* From v4 [4]
  - Rebased on v5.6-rc4
  - Fixed locking all over the shop now that we can bypass the ITS
  - Wait on INVALL at the RD level
  - Plentu of cleanups/fixes thanks to Zenghui's careful review effort

* From v3 [3]:
  - Rebased on v5.6-rc1
  - Considerably smaller thanks to the initial patches being merged
  - Small bug fix after the v5.6 merge window

* From v2 [2]:
  - Another bunch of fixes thanks to Zenghui Yu's very careful review
  - HW-accelerated SGIs are now optional thanks to new architected
    discovery/selection bits exposed by KVM and used by the guest kernel
  - Rebased on v5.5-rc2

* From v1 [1]:
  - A bunch of minor reworks after Zenghui Yu's review
  - A workaround for what looks like a new and unexpected TX1 bug
  - A subtle reorder of the series so that some patches can go in early

[0] https://static.docs.arm.com/ihi0069/f/IHI0069F_gic_architecture_specification_v3_and_v4.1.pdf
[1] https://lore.kernel.org/lkml/20190923182606.32100-1-maz@kernel.org/
[2] https://lore.kernel.org/lkml/20191027144234.8395-1-maz@kernel.org/
[3] https://lore.kernel.org/r/20191224111055.11836-1-maz@kernel.org/
[4] https://lore.kernel.org/r/20200214145736.18550-1-maz@kernel.org/
[5] https://lore.kernel.org/r/20200304203330.4967-1-maz@kernel.org/

Marc Zyngier (22):
  irqchip/gic-v3: Use SGIs without active state if offered
  irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors
  irqchip/gic-v4.1: Ensure mutual exclusion between vPE affinity change
    and RD access
  irqchip/gic-v4.1: Ensure mutual exclusion betwen invalidations on the
    same RD
  irqchip/gic-v4.1: Advertise support v4.1 to KVM
  irqchip/gic-v4.1: Map the ITS SGIR register page
  irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
  irqchip/gic-v4.1: Add initial SGI configuration
  irqchip/gic-v4.1: Plumb mask/unmask SGI callbacks
  irqchip/gic-v4.1: Plumb get/set_irqchip_state SGI callbacks
  irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
  irqchip/gic-v4.1: Move doorbell management to the GICv4 abstraction
    layer
  irqchip/gic-v4.1: Add VSGI allocation/teardown
  irqchip/gic-v4.1: Add VSGI property setup
  irqchip/gic-v4.1: Eagerly vmap vPEs
  KVM: arm64: GICv4.1: Let doorbells be auto-enabled
  KVM: arm64: GICv4.1: Add direct injection capability to SGI registers
  KVM: arm64: GICv4.1: Allow SGIs to switch between HW and SW interrupts
  KVM: arm64: GICv4.1: Plumb SGI implementation selection in the
    distributor
  KVM: arm64: GICv4.1: Reload VLPI configuration on distributor
    enable/disable
  KVM: arm64: GICv4.1: Allow non-trapping WFI when using HW SGIs
  KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs

Zenghui Yu (1):
  irqchip/gic-v4.1: Wait for completion of redistributor's INVALL
    operation

 arch/arm/include/asm/kvm_host.h        |   1 +
 arch/arm64/include/asm/kvm_emulate.h   |   3 +-
 arch/arm64/include/asm/kvm_host.h      |   1 +
 drivers/irqchip/irq-gic-v3-its.c       | 422 +++++++++++++++++++++++--
 drivers/irqchip/irq-gic-v3.c           |  13 +-
 drivers/irqchip/irq-gic-v4.c           | 134 +++++++-
 include/kvm/arm_vgic.h                 |   4 +
 include/linux/irqchip/arm-gic-common.h |   2 +
 include/linux/irqchip/arm-gic-v3.h     |  20 +-
 include/linux/irqchip/arm-gic-v4.h     |  25 +-
 virt/kvm/arm/arm.c                     |   8 +
 virt/kvm/arm/vgic/vgic-debug.c         |  14 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c       |  81 ++++-
 virt/kvm/arm/vgic/vgic-mmio.c          |  88 +++++-
 virt/kvm/arm/vgic/vgic-v3.c            |   6 +-
 virt/kvm/arm/vgic/vgic-v4.c            | 141 +++++++--
 virt/kvm/arm/vgic/vgic.h               |   1 +
 17 files changed, 895 insertions(+), 69 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
