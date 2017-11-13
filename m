From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/27] KVM: arm/arm64: GICv4: Use pending_last as a scheduling
 hint
Date: Mon, 13 Nov 2017 10:17:42 +0100
Message-ID: <20171113091752.10663-18-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74C5649D9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FvoHuhSnieK9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:11 -0500 (EST)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DA6C49D9C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:08 -0500 (EST)
Received: by mail-wr0-f196.google.com with SMTP id p96so13755756wrb.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:19 -0800 (PST)
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

When a vPE exits, the pending_last flag is set when there are pending
VLPIs stored in the pending table. Similarily, this flag will be set
when a doorbell interrupt fires, as it indicates the same condition.

Let's update kvm_vgic_vcpu_pending_irq() to account for that
flag as well, making a vcpu runnable when set.

Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index a05a5700910b..d29e91215366 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -781,6 +781,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
 
+	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
+		return true;
+
 	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-- 
2.14.2
