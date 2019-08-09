Return-Path: <SRS0=zTnl=WF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CA6C31E40
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B998D20B7C
	for <kvmarm@archiver.kernel.org>; Fri,  9 Aug 2019 07:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B998D20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 721A44A561;
	Fri,  9 Aug 2019 03:49:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JNb+hNcmkgFT; Fri,  9 Aug 2019 03:49:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132EB4A587;
	Fri,  9 Aug 2019 03:49:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5014A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gbhl9rhT8FXN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Aug 2019 03:49:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C705A4A558
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Aug 2019 03:49:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DDA3344;
 Fri,  9 Aug 2019 00:49:06 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D509C3F706;
 Fri,  9 Aug 2019 00:49:04 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 4/4] KVM: arm/arm64: vgic: Reevaluate level sensitive
 interrupts on enable
Date: Fri,  9 Aug 2019 08:48:32 +0100
Message-Id: <20190809074832.13283-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809074832.13283-1-maz@kernel.org>
References: <20190809074832.13283-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

A HW mapped level sensitive interrupt asserted by a device will not be put
into the ap_list if it is disabled at the VGIC level. When it is enabled
again, it will be inserted into the ap_list and written to a list register
on guest entry regardless of the state of the device.

We could argue that this can also happen on real hardware, when the command
to enable the interrupt reached the GIC before the device had the chance to
de-assert the interrupt signal; however, we emulate the distributor and
redistributors in software and we can do better than that.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 3ba7278fb533..44efc2ff863f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -113,6 +113,22 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool was_high = irq->line_level;
+
+			/*
+			 * We need to update the state of the interrupt because
+			 * the guest might have changed the state of the device
+			 * while the interrupt was disabled at the VGIC level.
+			 */
+			irq->line_level = vgic_get_phys_line_level(irq);
+			/*
+			 * Deactivate the physical interrupt so the GIC will let
+			 * us know when it is asserted again.
+			 */
+			if (!irq->active && was_high && !irq->line_level)
+				vgic_irq_set_phys_active(irq, false);
+		}
 		irq->enabled = true;
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
