From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 07/19] KVM: arm/arm64: vgic-v4: Only perform an unmap for valid
 vLPIs
Date: Mon,  4 Dec 2017 15:03:36 +0100
Message-ID: <20171204140348.21965-5-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E05549D70
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:00:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V61bPps5SYuJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:00:50 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4985C49D46
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:00:50 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id v22so17414676wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:03:57 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Before performing an unmap, let's check that what we have was
really mapped the first place.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
