From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 01/14] ARM: add CPU part numbers for Cortex A73, A75 and
 Brahma B15
Date: Wed, 16 May 2018 12:00:42 +0100
Message-ID: <E1fIuAk-0003ja-BC@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E1A4A0DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:50:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tHuFBWrBBlzq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:50:30 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B49C749F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:50:30 -0400 (EDT)
In-Reply-To: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Content-Disposition: inline
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add CPU part numbers for the above mentioned CPUs

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/include/asm/cputype.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index cb546425da8a..adc4a3eef815 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -77,8 +77,13 @@
 #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
 #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
 #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
+#define ARM_CPU_PART_CORTEX_A73		0x4100d090
+#define ARM_CPU_PART_CORTEX_A75		0x4100d0a0
 #define ARM_CPU_PART_MASK		0xff00fff0
 
+/* Broadcom cores */
+#define ARM_CPU_PART_BRAHMA_B15		0x420000f0
+
 /* DEC implemented cores */
 #define ARM_CPU_PART_SA1100		0x4400a110
 
-- 
2.7.4
