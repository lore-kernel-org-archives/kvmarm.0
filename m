From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v5 13/15] ARM: spectre-v2: KVM: invalidate icache on guest
 exit for Brahma B15
Date: Tue, 29 May 2018 15:55:18 +0100
Message-ID: <E1fNg1u-0005BA-3z@rmk-PC.armlinux.org.uk>
References: <20180529145320.GJ17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A584A0DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 May 2018 10:46:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1GediGJoES0b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 May 2018 10:46:13 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3B2E4A0D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 May 2018 10:44:52 -0400 (EDT)
In-Reply-To: <20180529145320.GJ17671@n2100.armlinux.org.uk>
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

Include Brahma B15 in the Spectre v2 KVM workarounds.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/include/asm/kvm_mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 48edb1f4ced4..fea770f78144 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -306,6 +306,7 @@ static inline void *kvm_get_hyp_vector(void)
 		return kvm_ksym_ref(__kvm_hyp_vector_bp_inv);
 	}
 
+	case ARM_CPU_PART_BRAHMA_B15:
 	case ARM_CPU_PART_CORTEX_A15:
 	{
 		extern char __kvm_hyp_vector_ic_inv[];
-- 
2.7.4
