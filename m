From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 6/8] ARM: virt: select ARM_GIC_V3_ITS
Date: Fri, 21 Oct 2016 10:36:39 +0100
Message-ID: <1477042601-15227-7-git-send-email-vladimir.murzin@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AFA749B4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9YISt3KX6HjN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:26:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C581949B49
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:45 -0400 (EDT)
In-Reply-To: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch allows ARM guests to use GICv3 ITS on an arm64 host

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b5d529f..caef684 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -703,6 +703,7 @@ config ARCH_VIRT
 	select ARM_GIC
 	select ARM_GIC_V2M if PCI
 	select ARM_GIC_V3
+	select ARM_GIC_V3_ITS if PCI
 	select ARM_PSCI
 	select HAVE_ARM_ARCH_TIMER
 
-- 
1.7.9.5
