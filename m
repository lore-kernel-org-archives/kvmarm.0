From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 02/12] arm64: kvm: Fix {V}TCR_EL2_TG0 mask
Date: Mon, 14 Mar 2016 16:53:01 +0000
Message-ID: <1457974391-28456-3-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A8A49B37
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10U92FxBZYg0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8F2D412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:05 -0400 (EDT)
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

{V}TCR_EL2_TG0 is a 2bit wide field, where:

 00 - 4K
 01 - 64K
 10 - 16K

But we use only 1 bit, which has worked well so far since
we never cared about 16K. Fix it for 16K support.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d201d4b..b7d61e4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -99,7 +99,7 @@
 #define TCR_EL2_TBI	(1 << 20)
 #define TCR_EL2_PS	(7 << 16)
 #define TCR_EL2_PS_40B	(2 << 16)
-#define TCR_EL2_TG0	(1 << 14)
+#define TCR_EL2_TG0	(3 << 14)
 #define TCR_EL2_SH0	(3 << 12)
 #define TCR_EL2_ORGN0	(3 << 10)
 #define TCR_EL2_IRGN0	(3 << 8)
@@ -110,7 +110,7 @@
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
 #define VTCR_EL2_PS_MASK	(7 << 16)
-#define VTCR_EL2_TG0_MASK	(1 << 14)
+#define VTCR_EL2_TG0_MASK	(3 << 14)
 #define VTCR_EL2_TG0_4K		(0 << 14)
 #define VTCR_EL2_TG0_64K	(1 << 14)
 #define VTCR_EL2_SH0_MASK	(3 << 12)
-- 
1.7.9.5
