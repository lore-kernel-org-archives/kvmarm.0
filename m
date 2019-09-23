Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6927C4CEC4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABC4D20B7C
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABC4D20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6680A4A694;
	Mon, 23 Sep 2019 14:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A6KIzRco3nrH; Mon, 23 Sep 2019 14:28:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DAEE4A654;
	Mon, 23 Sep 2019 14:28:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD5E4A688
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ECZBi0zKM6-Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:28:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F8B4A657
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECBC12D97;
 Mon, 23 Sep 2019 11:28:31 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4139A3F694;
 Mon, 23 Sep 2019 11:28:28 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 34/35] KVM: arm64: GICv4.1: Configure SGIs as HW interrupts
Date: Mon, 23 Sep 2019 19:26:05 +0100
Message-Id: <20190923182606.32100-35-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
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

To enable HW delivery of SGIs, set their hw flag to true, link them
to the corresponding Linux interrupt, which is then activated.

This configures the SGIs at the ITS level, and put the show
on the road!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-v4.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index e61c7a149515..0ff6dac16cba 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -97,6 +97,46 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	return IRQ_HANDLED;
 }
 
+static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct vgic_irq *irq)
+{
+	vpe->sgi_config[irq->intid].enabled	= irq->enabled;
+	vpe->sgi_config[irq->intid].group 	= irq->group;
+	vpe->sgi_config[irq->intid].priority	= irq->priority;
+}
+
+static void vgic_v4_init_vsgis(struct kvm_vcpu *vcpu)
+{
+	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+	int i;
+
+	if (!kvm_vgic_global_state.has_gicv4_1)
+		return;
+
+	/*
+	 * With GICv4.1, every virtual SGI can be directly injected. So
+	 * let's pretend that they are HW interrupts, tied to a host
+	 * IRQ. The SGI code will do its magic.
+	 */
+	for (i = 0; i < VGIC_NR_SGIS; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
+		struct irq_desc *desc;
+		int ret;
+
+		irq->hw = true;
+		irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);
+		vgic_v4_sync_sgi_config(vpe, irq);
+		/*
+		 * SGIs are initialised as disabled. Enable them if
+		 * required by the rest of the VGIC init code.
+		 */
+		desc = irq_to_desc(irq->host_irq);
+		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
+					      false);
+		WARN_ON(ret);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 /**
  * vgic_v4_init - Initialize the GICv4 data structures
  * @kvm:	Pointer to the VM being initialized
@@ -168,6 +208,8 @@ int vgic_v4_init(struct kvm *kvm)
 			dist->its_vm.nr_vpes = i;
 			break;
 		}
+
+		vgic_v4_init_vsgis(vcpu);
 	}
 
 	if (ret)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
