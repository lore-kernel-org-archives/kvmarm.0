From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/19] arm64: KVM: Rename HCR_VA to HCR_VSE
Date: Tue,  6 Sep 2016 14:01:59 +0100
Message-ID: <1473166937-15271-2-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9305249B5A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z6qjz4Eh+Rhb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:54:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8646E40B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:00 -0400 (EDT)
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

HCR_VA is a leftover from ARMv7, On ARMv8, this is HCR_VSE
(which stands for Virtual System Error), and has better
defined semantics.

Let's rename the constant.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 4b5c977..2a2752b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -50,7 +50,7 @@
 #define HCR_BSU		(3 << 10)
 #define HCR_BSU_IS	(UL(1) << 10)
 #define HCR_FB		(UL(1) << 9)
-#define HCR_VA		(UL(1) << 8)
+#define HCR_VSE		(UL(1) << 8)
 #define HCR_VI		(UL(1) << 7)
 #define HCR_VF		(UL(1) << 6)
 #define HCR_AMO		(UL(1) << 5)
@@ -80,7 +80,7 @@
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
 			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
-#define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
+#define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-- 
2.1.4
