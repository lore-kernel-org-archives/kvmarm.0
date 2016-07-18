From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 1/7] arm64: KVM: Move GIC accessors to arch_gicv3.h
Date: Mon, 18 Jul 2016 11:48:13 +0100
Message-ID: <1468838899-34909-2-git-send-email-vladimir.murzin@arm.com>
References: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4323C49B32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B4muQcL1fGNB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 06:42:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C54949B1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 06:42:37 -0400 (EDT)
In-Reply-To: <1468838899-34909-1-git-send-email-vladimir.murzin@arm.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Since we are going to share vgic-v3 save/restore code with ARM
keep arch specific accessors separately.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |   13 +++++++++++++
 arch/arm64/kvm/hyp/vgic-v3-sr.c     |   13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 8ec88e5..ae7dbd7 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -79,6 +79,19 @@
 #include <linux/stringify.h>
 #include <asm/barrier.h>
 
+#define read_gicreg(r)							\
+	({								\
+		u64 reg;						\
+		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
+		reg;							\
+	})
+
+#define write_gicreg(v,r)						\
+	do {								\
+		u64 __val = (v);					\
+		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
+	} while (0)
+
 /*
  * Low-level accessors
  *
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 5f8f80b..f2dbd2e 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -24,19 +24,6 @@
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
 #define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
 
-#define read_gicreg(r)							\
-	({								\
-		u64 reg;						\
-		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
-		reg;							\
-	})
-
-#define write_gicreg(v,r)						\
-	do {								\
-		u64 __val = (v);					\
-		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
-	} while (0)
-
 static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
-- 
1.7.9.5
