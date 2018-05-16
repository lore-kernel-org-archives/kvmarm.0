From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 05/14] ARM: spectre: add Kconfig symbol for CPUs vulnerable to
 Spectre
Date: Wed, 16 May 2018 12:01:02 +0100
Message-ID: <E1fIuB4-0003pm-SW@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED9D42121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:52:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKC2CxAe80qg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:51:35 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C43349EA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:51:08 -0400 (EDT)
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

Add a Kconfig symbol for CPUs which are vulnerable to the Spectre
attacks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 7f14acf67caf..8a5a1bb415c4 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -415,6 +415,7 @@ config CPU_V7
 	select CPU_CP15_MPU if !MMU
 	select CPU_HAS_ASID if MMU
 	select CPU_PABRT_V7
+	select CPU_SPECTRE
 	select CPU_THUMB_CAPABLE
 	select CPU_TLB_V7 if MMU
 
@@ -826,6 +827,9 @@ config CPU_BPREDICT_DISABLE
 	help
 	  Say Y here to disable branch prediction.  If unsure, say N.
 
+config CPU_SPECTRE
+	bool
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
-- 
2.7.4
