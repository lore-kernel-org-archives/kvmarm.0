From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 4/8] arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
Date: Fri,  4 Sep 2015 21:40:46 +0200
Message-ID: <1441395650-19663-5-git-send-email-christoffer.dall@linaro.org>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The GICD_ICFGR allows the bits for the SGIs and PPIs to be read only.
We currently simulate this behavior by writing a hardcoded value to the
register for the SGIs and PPIs on every write of these bits to the
register (ignoring what the guest actually wrote), and by writing the
same value as the reset value to the register.

This is a bit counter-intuitive, as the register is RO for these bits,
and we can just implement it that way, allowing us to control the value
of the bits purely in the reset code.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index fe0e5db..e606f78 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -655,7 +655,7 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
 			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
 	if (mmio->is_write) {
 		if (offset < 8) {
-			*reg = ~0U; /* Force PPIs/SGIs to 1 */
+			/* Ignore writes to read-only SGI and PPI bits */
 			return false;
 		}
 
-- 
2.1.2.330.g565301e.dirty

