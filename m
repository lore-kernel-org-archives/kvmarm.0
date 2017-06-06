From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/3] arm64: KVM: Preserve RES1 bits in SCTLR_EL2
Date: Tue,  6 Jun 2017 19:08:33 +0100
Message-ID: <20170606180835.14421-2-marc.zyngier@arm.com>
References: <20170606180835.14421-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129C140C92
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MvRmfd7i1lpT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 14:04:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E70940C26
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 14:04:44 -0400 (EDT)
In-Reply-To: <20170606180835.14421-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

__do_hyp_init has the rather bad habit of ignoring RES1 bits and
writing them back as zero. On a v8.0-8.2 CPU, this doesn't do anything
bad, but may end-up being pretty nasty on future revisions of the
architecture.

Let's preserve those bits so that we don't have to fix this later on.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  4 ++++
 arch/arm64/kvm/hyp-init.S       | 10 ++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 15c142ce991c..b4d13d9267ff 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -286,6 +286,10 @@
 #define SCTLR_ELx_A	(1 << 1)
 #define SCTLR_ELx_M	1
 
+#define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
+			 (1 << 16) | (1 << 18) | (1 << 22) | (1 << 23) | \
+			 (1 << 28) | (1 << 29))
+
 #define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
 			 SCTLR_ELx_SA | SCTLR_ELx_I)
 
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 839425c24b1c..4072d408a4b4 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -106,10 +106,12 @@ __do_hyp_init:
 	tlbi	alle2
 	dsb	sy
 
-	mrs	x4, sctlr_el2
-	and	x4, x4, #SCTLR_ELx_EE	// preserve endianness of EL2
-	ldr	x5, =SCTLR_ELx_FLAGS
-	orr	x4, x4, x5
+	/*
+	 * Preserve all the RES1 bits while setting the default flags,
+	 * as well as the EE bit on BE.
+	 */
+	ldr	x4, =(SCTLR_EL2_RES1 | SCTLR_ELx_FLAGS)
+CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
 	msr	sctlr_el2, x4
 	isb
 
-- 
2.11.0
