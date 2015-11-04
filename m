From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 04/21] arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
Date: Wed,  4 Nov 2015 15:49:43 +0100
Message-ID: <1446648600-27297-5-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0E5E497BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqI78DQN2AP2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:49:50 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD63B49938
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:49 -0500 (EST)
Received: by wmll128 with SMTP id l128so116251981wml.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:02 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
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
 virt/kvm/arm/vgic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 367a180..f8ca2e9 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -690,10 +690,9 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
 	vgic_reg_access(mmio, &val, offset,
 			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
 	if (mmio->is_write) {
-		if (offset < 8) {
-			*reg = ~0U; /* Force PPIs/SGIs to 1 */
+		/* Ignore writes to read-only SGI and PPI bits */
+		if (offset < 8)
 			return false;
-		}
 
 		val = vgic_cfg_compress(val);
 		if (offset & 4) {
-- 
2.1.2.330.g565301e.dirty
