Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659EBC54FCB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:41:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E84A2075A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 15:41:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hanuki1Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E84A2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4484B1D0;
	Thu, 23 Apr 2020 11:41:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id INj+uCl79oZM; Thu, 23 Apr 2020 11:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8583B4B297;
	Thu, 23 Apr 2020 11:40:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 389DF4B1F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iV20CmB-gRiR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 11:40:36 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2579B4B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 11:40:36 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5411121582;
 Thu, 23 Apr 2020 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587656435;
 bh=x4EzRTXzGeE0DRCtlZuwX2meq+RMl9m7BhkyHYoNL0k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Hanuki1YEkG9mssuhAR8caG+7BFP4pFLq8r1Q0ILUNbu09zBfN5uWziNBfqS4P2rq
 JCZ4LwdfEMRXXhZrx0XkSfw5Obj3VUcX3bpXrGleWfq17/ba9+xEVUqnp6zENNUNHk
 f078ZkMv9BSvZf+pu4h01fRp3TkBuFnrvufW1+Z8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRdxp-005oPM-Kk; Thu, 23 Apr 2020 16:40:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/8] KVM: arm: vgic: Only use the virtual state when userspace
 accesses enable bits
Date: Thu, 23 Apr 2020 16:40:06 +0100
Message-Id: <20200423154009.4113562-6-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org,
 yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

There is no point in accessing the HW when writing to any of the
ISENABLER/ICENABLER registers from userspace, as only the guest
should be allowed to change the HW state.

Introduce new userspace-specific accessors that deal solely with
the virtual state.

Reported-by: James Morse <james.morse@arm.com>
Tested-by: James Morse <james.morse@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 +++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 16 +++++++-----
 virt/kvm/arm/vgic/vgic-mmio.c    | 42 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 ++++++
 4 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index d63881f60e1a5..f51c6e939c761 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -409,10 +409,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		NULL, vgic_mmio_uaccess_write_v2_group, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
-		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_senable,
+		NULL, vgic_uaccess_write_senable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
-		vgic_mmio_read_enable, vgic_mmio_write_cenable, NULL, NULL, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable,
+		NULL, vgic_uaccess_write_cenable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index f2b37a081f26a..416613f2400c5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -538,10 +538,12 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
-		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_senable,
+		NULL, vgic_uaccess_write_senable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
-		vgic_mmio_read_enable, vgic_mmio_write_cenable, NULL, NULL, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable,
+	       NULL, vgic_uaccess_write_cenable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
@@ -609,11 +611,13 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IGROUPR0,
 		vgic_mmio_read_group, vgic_mmio_write_group, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_ISENABLER0,
-		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_senable,
+		NULL, vgic_uaccess_write_senable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_ICENABLER0,
-		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable,
+		NULL, vgic_uaccess_write_cenable, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index b38e94e8f74ad..6e30034d14645 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -184,6 +184,48 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	}
 }
 
+int vgic_uaccess_write_senable(struct kvm_vcpu *vcpu,
+			       gpa_t addr, unsigned int len,
+			       unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		irq->enabled = true;
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
+			       gpa_t addr, unsigned int len,
+			       unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		irq->enabled = false;
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len)
 {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 30713a44e3faa..327d0a6938e4d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -138,6 +138,14 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
+int vgic_uaccess_write_senable(struct kvm_vcpu *vcpu,
+			       gpa_t addr, unsigned int len,
+			       unsigned long val);
+
+int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
+			       gpa_t addr, unsigned int len,
+			       unsigned long val);
+
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len);
 
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
