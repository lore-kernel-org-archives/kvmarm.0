From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] ARM: dts: vexpress: Support GICC_DIR operations
Date: Sat, 10 Dec 2016 21:13:51 +0100
Message-ID: <20161210201351.25894-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97463401B9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:12:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WERI-t43SkNY for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:12:42 -0500 (EST)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AAC4401A1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:12:42 -0500 (EST)
Received: by mail-lf0-f53.google.com with SMTP id c13so21502572lfg.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:13:45 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: lorenzo.pieralisi@arm.com, Marc Zyngier <marc.zyngier@arm.com>, liviu.dudau@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The GICv2 CPU interface registers span across 8K, not 4K as indicated in
the DT.  Only the GICC_DIR register is located after the initial 4K
boundary, leaving a functional system but without support for separately
EOI'ing and deactivating interrupts.

After this change the system support split priority drop and interrupt
deactivation.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
index 0205c97..2e0cf39 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
@@ -126,7 +126,7 @@
 		#address-cells = <0>;
 		interrupt-controller;
 		reg = <0 0x2c001000 0 0x1000>,
-		      <0 0x2c002000 0 0x1000>,
+		      <0 0x2c002000 0 0x2000>,
 		      <0 0x2c004000 0 0x2000>,
 		      <0 0x2c006000 0 0x2000>;
 		interrupts = <1 9 0xf04>;
-- 
2.9.0
