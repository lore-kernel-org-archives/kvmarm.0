Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1483EC43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:14:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8445F4B314;
	Tue,  7 Jun 2022 09:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QrPTCR6JMAn1; Tue,  7 Jun 2022 09:14:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 317634B330;
	Tue,  7 Jun 2022 09:14:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E376F4B30A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id trOqalijh9Z6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8710D4B20D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:14:34 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CABFD61224;
 Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37455C34115;
 Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654607673;
 bh=2ZyRR7tBSN/2EJrlNxB3h2/WkG/0rsIykzhySwBTGsI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UR8KJu1PR0JK5SDRg/mgf8pPbAloJt4zJe5lbA6WOWxvKjMCWKjJ3X8RltzNx2L74
 tstWo6d/WZZhhSC6VsU0GJ3gvIESuWXBJDMwQX0dgAzPZXSVd4HnxeFsvpfPXZaVAm
 A9Bd5qTQH8xXJ7xRtOcxKm/HEC3Y902HK6M/srhNKIntrp3KGdRIMZIAyoVppqvA2j
 bVAnhQ6fbxO/P7ohcf5GZ4ED2KF+uBLZ/OfB6KdoZ0ClzSM7CVIfEt91oS4WuiphiE
 8Cg949e1nQE2f4y+gSwfixnAZcQhpwqtRSPyevMREC1FVzJoJ6Vkb+Vy4plrP31iF0
 XtCF5APJTQjKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nyZ2U-00GBUI-SZ; Tue, 07 Jun 2022 14:14:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: arm64: Don't read a HW interrupt pending state in
 user context
Date: Tue,  7 Jun 2022 14:14:25 +0100
Message-Id: <20220607131427.1164881-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220607131427.1164881-1-maz@kernel.org>
References: <20220607131427.1164881-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Since 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state
from the HW"), we're able to source the pending bit for an interrupt
that is stored either on the physical distributor or on a device.

However, this state is only available when the vcpu is loaded,
and is not intended to be accessed from userspace. Unfortunately,
the GICv2 emulation doesn't provide specific userspace accessors,
and we fallback with the ones that are intended for the guest,
with fatal consequences.

Add a new vgic_uaccess_read_pending() accessor for userspace
to use, build on top of the existing vgic_mmio_read_pending().

Reported-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state from the HW")
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 ++--
 arch/arm64/kvm/vgic/vgic-mmio.c    | 19 ++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 77a67e9d3d14..e070cda86e12 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -429,11 +429,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
-		NULL, vgic_uaccess_write_spending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
-		NULL, vgic_uaccess_write_cpending, 1,
+		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 49837d3a3ef5..dc8c52487e47 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
-				     gpa_t addr, unsigned int len)
+static unsigned long __read_pending(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-		} else if (vgic_irq_is_mapped_level(irq)) {
+		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
 			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
@@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, false);
+}
+
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len)
+{
+	return __read_pending(vcpu, addr, len, true);
+}
+
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index 3fa696f198a3..6082d4b66d39 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 				     gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
+					gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
