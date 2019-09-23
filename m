Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BD8C4CECF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E76B020665
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:26:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E76B020665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A02B14A319;
	Mon, 23 Sep 2019 14:26:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rY8kiqCrewBM; Mon, 23 Sep 2019 14:26:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EB24A60F;
	Mon, 23 Sep 2019 14:26:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D384A588
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:26:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hsCh0t3zCIvH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:26:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B114A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:26:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED436142F;
 Mon, 23 Sep 2019 11:26:27 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEC353F694;
 Mon, 23 Sep 2019 11:26:24 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/35] irqchip/gic-v4: GICv4.1 architecture support
Date: Mon, 23 Sep 2019 19:25:31 +0100
Message-Id: <20190923182606.32100-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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

[Apologies for posting this during the merge window, I'm fighting against
 another deadline which is incompatible with the -rc1 time frame]

This rather long series expands the existing GICv4 support to deal with the
new GICv4.1 architecture, which comes with a set of major improvements
compared to v4.0:

- One architectural doorbell per vcpu, instead of one doorbell per VLPI

- Doorbell entirely managed by the HW, with an "at most once" delivery
  guarantee per non-residency phase and only when requested by the
  hypervisor

- A shared memory scheme between ITSs and redistributors, allowing for an
  optimised residency sequence (the use of VMOVP becomes less frequent)

- Support for direct virtual SGI delivery (the injection path still involves
  the hypervisor), at the cost of losing the active state on SGIs. It
  shouldn't be a big deal, but some guest operating systems might notice
  (Linux definitely won't care)

On the other hand, public documentation is not available yet, so that's a
bit annoying..

The series is roughly organised in 5 parts:

(1) A bunch of reworks to make the checking of some features more
    straightforward,
(2) VPE table allocation, new flavours of VMAPP/VMOVP commands
(3) v4.1 doorbell management
(4) Virtual SGI support
(5) Plumbing of virtual SGIs in KVM

Note that patch #1 has been previously posted, and forms the base of this
work. This has had *very little* testing on a fairly early model, and some
behaviours are unexpected (the VSGI feature clearly misbehaves). But it is
in a shape that should make it possible to review and even debug. Consider
this an opportunity to influence the shape of this code at an early stage!
;-)


Marc Zyngier (35):
  KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by
    vcpu_load/put
  irqchip/gic-v3-its: Factor out wait_for_syncr primitive
  irqchip/gic-v3-its: Allow LPI invalidation via the DirectLPI interface
  irqchip/gic-v3: Detect GICv4.1 supporting RVPEID
  irqchip/gic-v3: Add GICv4.1 VPEID size discovery
  irqchip/gic-v3-its: Make is_v4 use a TYPER copy
  irqchip/gic-v3-its: Kill its->ite_size and use TYPER copy instead
  irqchip/gic-v3-its: Kill its->device_ids and use TYPER copy instead
  irqchip/gic-v3-its: Add get_vlpi_map() helper
  irqchip/gic-v4.1: VPE table (aka GICR_VPROPBASER) allocation
  irqchip/gic-v4.1: Implement the v4.1 flavour of VMAPP
  irqchip/gic-v4.1: Don't use the VPE proxy if RVPEID is set
  irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP
  irqchip/gic-v4.1: Plumb skeletal VPE irqchip
  irqchip/gic-v4.1: Add mask/unmask doorbell callbacks
  irqchip/gic-v4.1: Add VPE residency callback
  irqchip/gic-v4.1: Add VPE eviction callback
  irqchip/gic-v4.1: Add VPE INVALL callback
  irqchip/gic-v4.1: Suppress per-VLPI doorbell
  irqchip/gic-v4.1: Allow direct invalidation of VLPIs
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
  KVM: arm64: GICv4.1: Configure SGIs as HW interrupts
  KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs

 arch/arm/include/asm/arch_gicv3.h      |    2 +
 arch/arm64/include/asm/arch_gicv3.h    |    1 +
 drivers/irqchip/irq-gic-v3-its.c       | 1099 +++++++++++++++++++++---
 drivers/irqchip/irq-gic-v3.c           |   25 +-
 drivers/irqchip/irq-gic-v4.c           |  143 ++-
 include/kvm/arm_vgic.h                 |    5 +-
 include/linux/irqchip/arm-gic-common.h |    2 +
 include/linux/irqchip/arm-gic-v3.h     |   75 +-
 include/linux/irqchip/arm-gic-v4.h     |   45 +-
 virt/kvm/arm/arm.c                     |   12 +-
 virt/kvm/arm/vgic/vgic-debug.c         |   14 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c       |   15 +-
 virt/kvm/arm/vgic/vgic-mmio.c          |   88 +-
 virt/kvm/arm/vgic/vgic-v3.c            |    5 +
 virt/kvm/arm/vgic/vgic-v4.c            |  106 ++-
 virt/kvm/arm/vgic/vgic.c               |    4 -
 virt/kvm/arm/vgic/vgic.h               |    2 -
 17 files changed, 1466 insertions(+), 177 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
