Return-Path: <SRS0=pAxc=S3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAF8C4321A
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE6D5206C1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Apr 2019 13:49:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE6D5206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A254A34E;
	Thu, 25 Apr 2019 09:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IP6rs3ziqh+P; Thu, 25 Apr 2019 09:49:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6844A49F;
	Thu, 25 Apr 2019 09:49:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C82174A34E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id axhEK6HzLeIY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Apr 2019 09:49:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 722424A46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Apr 2019 09:49:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06EB8A78;
 Thu, 25 Apr 2019 06:49:19 -0700 (PDT)
Received: from big-swifty.cambridge.arm.com (c02v53d0hv2r.cambridge.arm.com
 [10.1.37.80])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C85A3F246;
 Thu, 25 Apr 2019 06:49:15 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/5] KVM: arm/arm64: vgic-v3: Retire pending interrupts on
 disabling LPIs
Date: Thu, 25 Apr 2019 14:48:53 +0100
Message-Id: <20190425134857.26109-3-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425134857.26109-1-marc.zyngier@arm.com>
References: <20190425134857.26109-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190425134853.MVdVbr9G7fqs-7tAw9mFohqL1I85ybP7wrJGCy5O6VQ@z>

When disabling LPIs (for example on reset) at the redistributor
level, it is expected that LPIs that was pending in the CPU
interface are eventually retired.

Currently, this is not what is happening, and these LPIs will
stay in the ap_list, eventually being acknowledged by the vcpu
(which didn't quite expect this behaviour).

The fix is thus to retire these LPIs from the list of pending
interrupts as we disable LPIs.

Reported-by: Heyi Guo <guoheyi@huawei.com>
Tested-by: Heyi Guo <guoheyi@huawei.com>
Fixes: 0e4e82f154e3 ("KVM: arm64: vgic-its: Enable ITS emulation as a virtual MSI controller")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +++
 virt/kvm/arm/vgic/vgic.c         | 21 +++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  1 +
 3 files changed, 25 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 4a12322bf7df..9f4843fe9cda 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -200,6 +200,9 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 
 	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
 
+	if (was_enabled && !vgic_cpu->lpis_enabled)
+		vgic_flush_pending_lpis(vcpu);
+
 	if (!was_enabled && vgic_cpu->lpis_enabled)
 		vgic_enable_lpis(vcpu);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 3af69f2a3866..191deccf60bf 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -151,6 +151,27 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	kfree(irq);
 }
 
+void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_irq *irq, *tmp;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
+
+	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
+		if (irq->intid >= VGIC_MIN_LPI) {
+			raw_spin_lock(&irq->irq_lock);
+			list_del(&irq->ap_list);
+			irq->vcpu = NULL;
+			raw_spin_unlock(&irq->irq_lock);
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+
+	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+}
+
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
 {
 	WARN_ON(irq_set_irqchip_state(irq->host_irq,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a90024718ca4..abeeffabc456 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -238,6 +238,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
