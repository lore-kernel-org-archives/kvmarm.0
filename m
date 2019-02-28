From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 03/13] arm64: KVM: reset E2PB correctly in MDCR_EL2 when
 exiting the guest(VHE)
Date: Thu, 28 Feb 2019 16:07:25 +0000
Message-ID: <20190228160737.3323-4-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 642984A453
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BTjGZGZO1YWo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A6324A3B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:06 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On VHE systems, the reset value for MDCR_EL2.E2PB=b00 which defaults
to profiling buffer using the EL2 stage 1 translations. However if the
guest are allowed to use profiling buffers changing E2PB settings, we
need to ensure we resume back MDCR_EL2.E2PB=b00. Currently we just
do bitwise '&' with MDCR_EL2_E2PB_MASK which will retain the value.

So fix it by clearing all the bits in E2PB.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 421ebf6f7086..08e2a01188ac 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -198,9 +198,7 @@ void deactivate_traps_vhe_put(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
 
 	write_sysreg(mdcr_el2, mdcr_el2);
 
-- 
2.17.1
