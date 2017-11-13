From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 06/27] KVM: arm/arm64: vITS: Add a helper to update the
 affinity of an LPI
Date: Mon, 13 Nov 2017 10:17:31 +0100
Message-ID: <20171113091752.10663-7-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2ECC49D9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nQGe2dOkL-Gg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:15:54 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02FBD49D99
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:52 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id k61so13770302wrc.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:02 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to help integrating the vITS code with GICv4, let's add
a new helper that deals with updating the affinity of an LPI,
which will later be augmented with super duper extra GICv4
goodness.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1de4e68ef1b6..09accdfed189 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -336,6 +336,15 @@ static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	return i;
 }
 
+static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
+{
+	spin_lock(&irq->irq_lock);
+	irq->target_vcpu = vcpu;
+	spin_unlock(&irq->irq_lock);
+
+	return 0;
+}
+
 /*
  * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
  * is targeting) to the VGIC's view, which deals with target VCPUs.
@@ -350,10 +359,7 @@ static void update_affinity_ite(struct kvm *kvm, struct its_ite *ite)
 		return;
 
 	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
-
-	spin_lock(&ite->irq->irq_lock);
-	ite->irq->target_vcpu = vcpu;
-	spin_unlock(&ite->irq->irq_lock);
+	update_affinity(ite->irq, vcpu);
 }
 
 /*
@@ -696,11 +702,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	spin_lock(&ite->irq->irq_lock);
-	ite->irq->target_vcpu = vcpu;
-	spin_unlock(&ite->irq->irq_lock);
-
-	return 0;
+	return update_affinity(ite->irq, vcpu);
 }
 
 /*
-- 
2.14.2
