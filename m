From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 03/17] ARM: KVM: Enforce sorting of all CP tables
Date: Wed, 17 Feb 2016 16:40:35 +0000
Message-ID: <1455727249-24752-4-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51EA949958
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:34:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LGuSyTpFxk3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 11:34:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 441A949954
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 11:34:47 -0500 (EST)
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
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

Since we're obviously terrible at sorting the CP tables, make sure
we're going to do it properly (or fail to boot). arm64 has had the
same mechanism for a while, and nobody ever broke it...

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 16c74f8..03f5d14 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -381,17 +381,26 @@ static const struct coproc_reg cp15_regs[] = {
 	{ CRn(15), CRm( 0), Op1( 4), Op2( 0), is32, access_cbar},
 };
 
+static int check_reg_table(const struct coproc_reg *table, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 1; i < n; i++) {
+		if (cmp_reg(&table[i-1], &table[i]) >= 0) {
+			kvm_err("reg table %p out of order (%d)\n", table, i - 1);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /* Target specific emulation tables */
 static struct kvm_coproc_target_table *target_tables[KVM_ARM_NUM_TARGETS];
 
 void kvm_register_target_coproc_table(struct kvm_coproc_target_table *table)
 {
-	unsigned int i;
-
-	for (i = 1; i < table->num; i++)
-		BUG_ON(cmp_reg(&table->table[i-1],
-			       &table->table[i]) >= 0);
-
+	BUG_ON(check_reg_table(table->table, table->num));
 	target_tables[table->target] = table;
 }
 
@@ -1210,8 +1219,8 @@ void kvm_coproc_table_init(void)
 	unsigned int i;
 
 	/* Make sure tables are unique and in order. */
-	for (i = 1; i < ARRAY_SIZE(cp15_regs); i++)
-		BUG_ON(cmp_reg(&cp15_regs[i-1], &cp15_regs[i]) >= 0);
+	BUG_ON(check_reg_table(cp15_regs, ARRAY_SIZE(cp15_regs)));
+	BUG_ON(check_reg_table(invariant_cp15, ARRAY_SIZE(invariant_cp15)));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_cp15); i++)
-- 
2.1.4
