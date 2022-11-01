Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5587C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:49:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33EFE4B9C2;
	Wed,  2 Nov 2022 12:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iKnBWrIbUX3N; Wed,  2 Nov 2022 12:49:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 289E04B98C;
	Wed,  2 Nov 2022 12:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9744BA22
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 17:15:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuBU7w7DwsCn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 17:15:30 -0400 (EDT)
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr
 [80.12.242.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03AAB4BA05
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 17:15:29 -0400 (EDT)
Received: from pop-os.home ([86.243.100.34]) by smtp.orange.fr with ESMTPA
 id pyanoKD2rsfCIpybYoWfLE; Tue, 01 Nov 2022 22:15:29 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 01 Nov 2022 22:15:29 +0100
X-ME-IP: 86.243.100.34
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 25/30] KVM: arm64: vgic-v3: Use kstrtobool() instead of
 strtobool()
Date: Tue,  1 Nov 2022 22:14:13 +0100
Message-Id: <b10987c659a72c191137b8599f6634d6e61a0bae.1667336095.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
References: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 02 Nov 2022 12:49:29 -0400
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is part of a serie that axes all usages of strtobool().
Each patch can be applied independently from the other ones.

The last patch of the serie removes the definition of strtobool().

You may not be in copy of the cover letter. So, if needed, it is available
at [1].


This patch has NOT been compile tested.


[1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/
---
 arch/arm64/kvm/vgic/vgic-v3.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 826ff6f2a4e7..efb2726efbb3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -3,6 +3,7 @@
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/kstrtox.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
@@ -587,25 +588,25 @@ DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
 
 static int __init early_group0_trap_cfg(char *buf)
 {
-	return strtobool(buf, &group0_trap);
+	return kstrtobool(buf, &group0_trap);
 }
 early_param("kvm-arm.vgic_v3_group0_trap", early_group0_trap_cfg);
 
 static int __init early_group1_trap_cfg(char *buf)
 {
-	return strtobool(buf, &group1_trap);
+	return kstrtobool(buf, &group1_trap);
 }
 early_param("kvm-arm.vgic_v3_group1_trap", early_group1_trap_cfg);
 
 static int __init early_common_trap_cfg(char *buf)
 {
-	return strtobool(buf, &common_trap);
+	return kstrtobool(buf, &common_trap);
 }
 early_param("kvm-arm.vgic_v3_common_trap", early_common_trap_cfg);
 
 static int __init early_gicv4_enable(char *buf)
 {
-	return strtobool(buf, &gicv4_enable);
+	return kstrtobool(buf, &gicv4_enable);
 }
 early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
