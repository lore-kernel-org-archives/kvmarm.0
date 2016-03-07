From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 07/12] KVM: arm/arm64: vgic-v2: Make GICD_SGIR quicker to hit
Date: Mon,  7 Mar 2016 09:33:29 +0000
Message-ID: <1457343214-19547-8-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The GICD_SGIR register lives a long way from the beginning of
the handler array, which is searched linearly. As this is hit
pretty often, let's move it up. This saves us some precious
cycles when the guest is generating IPIs.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v2-emul.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..1b0bee0 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -321,6 +321,11 @@ static bool handle_mmio_sgi_clear(struct kvm_vcpu *vcpu,
 
 static const struct vgic_io_range vgic_dist_ranges[] = {
 	{
+		.base		= GIC_DIST_SOFTINT,
+		.len		= 4,
+		.handle_mmio	= handle_mmio_sgi_reg,
+	},
+	{
 		.base		= GIC_DIST_CTRL,
 		.len		= 12,
 		.bits_per_irq	= 0,
@@ -387,11 +392,6 @@ static const struct vgic_io_range vgic_dist_ranges[] = {
 		.handle_mmio	= handle_mmio_cfg_reg,
 	},
 	{
-		.base		= GIC_DIST_SOFTINT,
-		.len		= 4,
-		.handle_mmio	= handle_mmio_sgi_reg,
-	},
-	{
 		.base		= GIC_DIST_SGI_PENDING_CLEAR,
 		.len		= VGIC_NR_SGIS,
 		.handle_mmio	= handle_mmio_sgi_clear,
-- 
2.1.4

