From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 01/10] arm: kvm: move kvm_vgic_global_state out of .text
 section
Date: Thu,  9 Mar 2017 09:25:03 +0100
Message-ID: <1489047912-642-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE2240B40
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y8-s1CNEHHzc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 03:24:00 -0500 (EST)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9459B40AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:00 -0500 (EST)
Received: by mail-wr0-f174.google.com with SMTP id l37so39662668wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 00:25:25 -0800 (PST)
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The kvm_vgic_global_state struct contains a static key which is
written to by jump_label_init() at boot time. So in preparation of
making .text regions truly (well, almost truly) read-only, mark
kvm_vgic_global_state __ro_after_init so it moves to the .rodata
section instead.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 654dfd40e449..7713d96e85b7 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -29,7 +29,9 @@
 #define DEBUG_SPINLOCK_BUG_ON(p)
 #endif
 
-struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
+struct vgic_global kvm_vgic_global_state __ro_after_init = {
+	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
+};
 
 /*
  * Locking order is always:
-- 
2.7.4
