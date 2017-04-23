From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 23/79] KVM: arm/arm64: vgic: Get rid of MISR and EISR fields
Date: Sun, 23 Apr 2017 19:08:33 +0200
Message-ID: <20170423170929.27334-24-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FF749C25
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3RyN8UdCe17I for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:11 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A259D49C63
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:09 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id w64so46374118wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:56 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We don't use these fields anymore so let's nuke them completely.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h        | 4 ----
 virt/kvm/arm/hyp/vgic-v2-sr.c | 2 --
 virt/kvm/arm/hyp/vgic-v3-sr.c | 2 --
 3 files changed, 8 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ea940db..26ed4fb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -225,8 +225,6 @@ struct vgic_dist {
 struct vgic_v2_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
-	u32		vgic_misr;	/* Saved only */
-	u64		vgic_eisr;	/* Saved only */
 	u64		vgic_elrsr;	/* Saved only */
 	u32		vgic_apr;
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
@@ -236,8 +234,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
-	u32		vgic_misr;	/* Saved only */
-	u32		vgic_eisr;	/* Saved only */
 	u32		vgic_elrsr;	/* Saved only */
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a4c3bb0..a3f18d3 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -77,9 +77,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
 		writel_relaxed(0, base + GICH_HCR);
 	} else {
-		cpu_if->vgic_eisr = 0;
 		cpu_if->vgic_elrsr = ~0UL;
-		cpu_if->vgic_misr = 0;
 		cpu_if->vgic_apr = 0;
 	}
 }
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 41bbbb0..3d0b1dd 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -170,8 +170,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
 		}
 	} else {
-		cpu_if->vgic_misr  = 0;
-		cpu_if->vgic_eisr  = 0;
 		cpu_if->vgic_elrsr = 0xffff;
 		cpu_if->vgic_ap0r[0] = 0;
 		cpu_if->vgic_ap0r[1] = 0;
-- 
2.9.0
