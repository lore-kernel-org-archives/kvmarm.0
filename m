Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FC6C76191
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D9582189F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D9582189F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFBF4A5AD;
	Wed, 24 Jul 2019 05:04:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s3hqJmo1r806; Wed, 24 Jul 2019 05:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB614A5A3;
	Wed, 24 Jul 2019 05:04:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 468374A59C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGiETl2gR+Jo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1302B4A56C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 02EDA65D9F3FEEC4FB62;
 Wed, 24 Jul 2019 17:04:46 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:42 +0800
From: Xiangyou Xie <xiexiangyou@huawei.com>
To: <marc.zyngier@arm.com>
Subject: [PATCH 3/3] KVM: arm/arm64: vgic: introduce vgic_cpu pending status
 and lowest_priority
Date: Wed, 24 Jul 2019 17:04:37 +0800
Message-ID: <20190724090437.49952-4-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20190724090437.49952-1-xiexiangyou@huawei.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

During the halt polling process, vgic_cpu->ap_list_lock is frequently
obtained andreleased, (kvm_vcpu_check_block->kvm_arch_vcpu_runnable->
kvm_vgic_vcpu_pending_irq).This action affects the performance of virq
interrupt injection, because vgic_queue_irq_unlock also attempts to get
vgic_cpu->ap_list_lock and add irq to vgic_cpu ap_list.

The irq pending state and the minimum priority introduced by the patch,
kvm_vgic_vcpu_pending_irq do not need to traverse vgic_cpu ap_list, only
the check pending state and priority.

Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
---
 include/kvm/arm_vgic.h   |  5 +++++
 virt/kvm/arm/vgic/vgic.c | 40 ++++++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ce372a0..636db29 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -337,6 +337,11 @@ struct vgic_cpu {
 
 	/* Cache guest interrupt ID bits */
 	u32 num_id_bits;
+
+	/* Minimum of priority in all irqs */
+	u8 lowest_priority;
+	/* Irq pending flag */
+	bool pending;
 };
 
 extern struct static_key_false vgic_v2_cpuif_trap;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index deb8471..767dfe0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -398,6 +398,12 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * now in the ap_list.
 	 */
 	vgic_get_irq_kref(irq);
+
+	if (!irq->active) {
+		vcpu->arch.vgic_cpu.pending = true;
+		if (vcpu->arch.vgic_cpu.lowest_priority > irq->priority)
+			vcpu->arch.vgic_cpu.lowest_priority = irq->priority;
+	}
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
@@ -618,6 +624,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 retry:
 	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
+	vgic_cpu->lowest_priority = U8_MAX;
+	vgic_cpu->pending = false;
+
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
 		bool target_vcpu_needs_kick = false;
@@ -649,6 +658,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		}
 
 		if (target_vcpu == vcpu) {
+			if (!irq->active) {
+				vgic_cpu->pending = true;
+				if (vgic_cpu->lowest_priority > irq->priority)
+					vgic_cpu->lowest_priority = irq->priority;
+			}
 			/* We're on the right CPU */
 			raw_spin_unlock(&irq->irq_lock);
 			continue;
@@ -690,6 +704,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 			list_del(&irq->ap_list);
 			irq->vcpu = target_vcpu;
+			if (!irq->active) {
+				new_cpu->pending = true;
+				if (new_cpu->lowest_priority > irq->priority)
+					new_cpu->lowest_priority = irq->priority;
+			}
 			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
 			target_vcpu_needs_kick = true;
 		}
@@ -930,9 +949,6 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_irq *irq;
-	bool pending = false;
-	unsigned long flags;
 	struct vgic_vmcr vmcr;
 
 	if (!vcpu->kvm->arch.vgic.enabled)
@@ -943,22 +959,10 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 
 	vgic_get_vmcr(vcpu, &vmcr);
 
-	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
-
-	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		raw_spin_lock(&irq->irq_lock);
-		pending = irq_is_pending(irq) && irq->enabled &&
-			  !irq->active &&
-			  irq->priority < vmcr.pmr;
-		raw_spin_unlock(&irq->irq_lock);
-
-		if (pending)
-			break;
-	}
-
-	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+	if (vgic_cpu->pending && vgic_cpu->lowest_priority < vmcr.pmr)
+		return true;
 
-	return pending;
+	return false;
 }
 
 void vgic_kick_vcpus(struct kvm *kvm)
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
