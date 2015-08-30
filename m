From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 4/9] arm/arm64: Implement GICD_ICFGR as RO for PPIs
Date: Sun, 30 Aug 2015 15:54:21 +0200
Message-ID: <1440942866-23802-5-git-send-email-christoffer.dall@linaro.org>
References: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The GICD_ICFGR allows the bits for the SGIs and PPIs to be read only.
We currently simulate this behavior by writing a hardcoded value to the
register for the SGIs and PPIs on every write of these bits to the
register (ignoring what the guest actually wrote), and by writing the
same value as the reset value to the register.

This is a bit counter-intuitive, as the register is RO for these bits,
and we can just implement it that way, allowing us to control the value
of the bits purely in the reset code.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index c5750be..0ba92d3 100644
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

