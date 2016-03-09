From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 90/95] KVM: arm/arm64: vgic-v2: Make GICD_SGIR quicker to hit
Date: Wed,  9 Mar 2016 07:31:24 +0000
Message-ID: <1457508689-19672-91-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DD449B77
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LgZUNwZDMvNg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:36:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D6849BD5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:02 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
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
