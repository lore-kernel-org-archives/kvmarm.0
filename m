From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 4/8] arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
Date: Tue, 29 Sep 2015 16:49:01 +0200
Message-ID: <1443538145-11990-5-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7C6B419C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZ9+K48DHGQH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:39 -0400 (EDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E906141D42
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:36 -0400 (EDT)
Received: by lahh2 with SMTP id h2so11757408lah.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:11 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
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
