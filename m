Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE01BC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 16:41:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8686649EFB;
	Mon, 14 Mar 2022 12:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3CxPoSBNlGJG; Mon, 14 Mar 2022 12:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E8649EFD;
	Mon, 14 Mar 2022 12:40:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD4749EC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id faKghCJrDUBx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 12:40:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617F549EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:40:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AF2BE60AF6;
 Mon, 14 Mar 2022 16:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80008C340EE;
 Mon, 14 Mar 2022 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647276056;
 bh=uxi3l7XD1dsCHWv/V+37GxYxDWy+/GagQ9LpcOEAld8=;
 h=From:To:Cc:Subject:Date:From;
 b=b3vju7KpuxWzL0Th0rFVIMLGLVXfrMn1gh6R1Pj0ixRO1tGY+nPicps9FSyfvANQv
 16mvkgpfof8s5XJEjSpnkhr/xnHeP5yvKqFUpQUAaGXUG8jWNoUlmXhjbxO6b+phFo
 n7bQvKCwaYNyfX1otXWgwbQCkpUK9cB8qYr5HSJT5357Z7w/obIrvYhSx7EYFvgFZ2
 Ox4WCruGxd97TldBZ333a5tSlPKcngAO5TgSuTajGlPMpYyjOWeFNPKC8KFbcjiB76
 gLutIMup/bRuovq+HgsrOAyycIFC3sT93I5CR1e4dHqz6wNT7lAsvbSCsgp9Muo8Ax
 jT6fpX78oUWMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nTnkb-00EPS0-6D; Mon, 14 Mar 2022 16:40:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/4] KVM: arm64: vgic-v3: MMIO-based LPI invalidation and co
Date: Mon, 14 Mar 2022 16:40:40 +0000
Message-Id: <20220314164044.772709-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, andre.przywara@arm.com, eric.auger@redhat.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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

Since revision IHI0069G of the GICv3 spec, an implementation is
allowed to implement MMIO-based LPI invalidation, without having to
support RVPEI (which is essentially a GICv4.1 feature).

This has the potential to make workloads using heavy LPI invalidation
fare a bit better, as they don't need to lock the access to the
command queue.

Similarly, an implementation can now expose that it allows LPIs to be
turned off, something that we always supported.

This series implements both these features, exposing the new
GICR_{INVLPIR,INVALLR,SYNCR} registers, transitions of the
GICR_CTLR.RWP bit on LPI disabling, and finally exposes these to
userspace and the guest with a new GICD_IIDR revision (and the ability
to save/restore it).

This series has been extremely useful to debug related GIC features,
and will be complemented by a few GIC patches.

Patches on top of 5.17-rc3.

	M.

Marc Zyngier (4):
  irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR,CES}
  KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
  KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
  KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR,CES} as a new GICD_IIDR
    revision

 arch/arm64/kvm/vgic/vgic-init.c    |   7 +-
 arch/arm64/kvm/vgic/vgic-its.c     |  64 ++++++++++------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  18 ++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 119 ++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.h         |   5 ++
 include/kvm/arm_vgic.h             |   8 +-
 include/linux/irqchip/arm-gic-v3.h |   2 +
 7 files changed, 184 insertions(+), 39 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
