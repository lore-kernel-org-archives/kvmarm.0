From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 15/15] ARM: KVM: report support for SMCCC_ARCH_WORKAROUND_1
Date: Fri, 25 May 2018 15:01:39 +0100
Message-ID: <E1fMDHn-00074D-Iw@rmk-PC.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D88F24A0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 09:56:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lkbGkalGfSeB for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 09:55:47 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E98A49F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 09:52:41 -0400 (EDT)
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Report support for SMCCC_ARCH_WORKAROUND_1 to KVM guests for affected
CPUs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/include/asm/kvm_host.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 248b930563e5..11f91744ffb0 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -21,6 +21,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_types.h>
+#include <asm/cputype.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
@@ -311,8 +312,17 @@ static inline void kvm_arm_vhe_guest_exit(void) {}
 
 static inline bool kvm_arm_harden_branch_predictor(void)
 {
-	/* No way to detect it yet, pretend it is not there. */
-	return false;
+	switch(read_cpuid_part()) {
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	case ARM_CPU_PART_BRAHMA_B15:
+	case ARM_CPU_PART_CORTEX_A12:
+	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_CORTEX_A17:
+		return true;
+#endif
+	default:
+		return false;
+	}
 }
 
 #endif /* __ARM_KVM_HOST_H__ */
-- 
2.7.4
