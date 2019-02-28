From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 06/13] arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE systems
Date: Thu, 28 Feb 2019 16:07:28 +0000
Message-ID: <20190228160737.3323-7-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCE24A475
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6JqnlOABfjsP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:11 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B94D4A47B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:11 -0500 (EST)
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

Currently, we are just using PMSCR_EL1 in the host for non VHE systems.
We already have the {read,write}_sysreg_el*() accessors for accessing
particular ELs' sysregs in the presence of VHE.

Lets just define PMSCR_EL12 and start making use of it here which will
access the right register on both VHE and non VHE systems. This change
is required to add SPE guest support on VHE systems.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/debug-sr.c    | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 68c49f258729..a4a6f6deef89 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -102,6 +102,7 @@
 #define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
 #define esr_EL12                sys_reg(3, 5, 5, 2, 0)
 #define far_EL12                sys_reg(3, 5, 6, 0, 0)
+#define SYS_PMSCR_EL12          sys_reg(3, 5, 9, 9, 0)
 #define mair_EL12               sys_reg(3, 5, 10, 2, 0)
 #define amair_EL12              sys_reg(3, 5, 10, 3, 0)
 #define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 50009766e5e5..fa51236ebcb3 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -89,8 +89,8 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
+	*pmscr_el1 = read_sysreg_el1_s(SYS_PMSCR);
+	write_sysreg_el1_s(0, SYS_PMSCR);
 	isb();
 
 	/* Now drain all buffered data to memory */
@@ -107,7 +107,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+	write_sysreg_el1_s(pmscr_el1, SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-- 
2.17.1
