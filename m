From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 15/27] KVM: arm/arm64: GICv4: Propagate property updates to
 VLPIs
Date: Mon, 13 Nov 2017 10:17:40 +0100
Message-ID: <20171113091752.10663-16-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6BCE49D9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EU1--hsPlLhV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:07 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8349049DCA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:05 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id n74so13230434wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:16 -0800 (PST)
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

Upon updating a property, we propagate it all the way to the physical
ITS, and ask for an INV command to be executed there.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 78d11aed1e17..4768a0e21cc5 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -297,6 +297,9 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		spin_unlock_irqrestore(&irq->irq_lock, flags);
 	}
 
+	if (irq->hw)
+		return its_prop_update_vlpi(irq->host_irq, prop, true);
+
 	return 0;
 }
 
-- 
2.14.2
