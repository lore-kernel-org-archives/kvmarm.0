From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/7] KVM: arm/arm64: vgic-v4: Only perform an unmap for valid
 vLPIs
Date: Thu, 16 Nov 2017 17:58:19 +0000
Message-ID: <20171116175821.26544-6-marc.zyngier@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7BD49D14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CnsxE3RLNQrU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BBD406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:22 -0500 (EST)
In-Reply-To: <20171116175821.26544-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Before performing an unmap, let's check that what we have was
really mapped the first place.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 53c324aa44ef..4a37292855bc 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -337,8 +337,10 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 		goto out;
 
 	WARN_ON(!(irq->hw && irq->host_irq == virq));
-	irq->hw = false;
-	ret = its_unmap_vlpi(virq);
+	if (irq->hw) {
+		irq->hw = false;
+		ret = its_unmap_vlpi(virq);
+	}
 
 out:
 	mutex_unlock(&its->its_lock);
-- 
2.14.2
