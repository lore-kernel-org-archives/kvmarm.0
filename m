From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 09/14] KVM: arm64: Reuse sys_reg() macro when searching the
 trap table
Date: Thu, 24 Jan 2019 15:00:27 +0100
Message-ID: <20190124140032.8588-10-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6795A4A3D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:01:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oaLkrc9zdTiK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:01:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B71CE4A3A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:58 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Instead of having an open-coded macro, reuse the sys_reg() macro
that does the exact same thing.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3e37228ae4e..1a5bea4285e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -965,6 +965,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+#define reg_to_encoding(x)						\
+	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
+		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2);
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1820,30 +1824,19 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
 	}
 }
 
-#define reg_to_match_value(x)						\
-	({								\
-		unsigned long val;					\
-		val  = (x)->Op0 << 14;					\
-		val |= (x)->Op1 << 11;					\
-		val |= (x)->CRn << 7;					\
-		val |= (x)->CRm << 3;					\
-		val |= (x)->Op2;					\
-		val;							\
-	 })
-
 static int match_sys_reg(const void *key, const void *elt)
 {
 	const unsigned long pval = (unsigned long)key;
 	const struct sys_reg_desc *r = elt;
 
-	return pval - reg_to_match_value(r);
+	return pval - reg_to_encoding(r);
 }
 
 static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
 {
-	unsigned long pval = reg_to_match_value(params);
+	unsigned long pval = reg_to_encoding(params);
 
 	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
-- 
2.18.0
