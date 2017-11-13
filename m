From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 21/27] KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs can
 be delivered
Date: Mon, 13 Nov 2017 10:17:46 +0100
Message-ID: <20171113091752.10663-22-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 794CE49DAA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x8Rh5yQFwrvd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:16:17 -0500 (EST)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6772249D96
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:16:17 -0500 (EST)
Received: by mail-wr0-f196.google.com with SMTP id l22so13756059wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:28 -0800 (PST)
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

In order for VLPIs to be delivered to the guest, we must make sure that
the virtual cpuif is always enabled, irrespective of the presence of
virtual interrupt in the LRs.

Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 91728faa13fd..f5c3d6d7019e 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -258,7 +258,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 		}
 	} else {
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+		    cpu_if->its_vpe.its_vm)
 			write_gicreg(0, ICH_HCR_EL2);
 
 		cpu_if->vgic_elrsr = 0xffff;
@@ -337,9 +338,11 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 		/*
 		 * If we need to trap system registers, we must write
 		 * ICH_HCR_EL2 anyway, even if no interrupts are being
-		 * injected,
+		 * injected. Same thing if GICv4 is used, as VLPI
+		 * delivery is gated by ICH_HCR_EL2.En.
 		 */
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+		    cpu_if->its_vpe.its_vm)
 			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 	}
 
-- 
2.14.2
