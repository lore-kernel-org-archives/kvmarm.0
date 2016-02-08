From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/8] arm64: KVM: Switch the sys_reg search to be a binary search
Date: Mon,  8 Feb 2016 11:40:15 +0000
Message-ID: <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Our 64bit sys_reg table is about 90 entries long (so far, and the
PMU support is likely to increase this). This means that on average,
it takes 45 comparaisons to find the right entry (and actually the
full 90 if we have to search the invariant table).

Not the most efficient thing. Specially when you think that this
table is already sorted. Switching to a binary search effectively
reduces the search to about 7 comparaisons. Slightly better!

As an added bonus, the comparaison is done by comparing all the
fields at once, instead of one at a time.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eec3598..0035869 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -20,6 +20,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
@@ -942,29 +943,32 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
 	}
 }
 
+#define reg_to_match_value(x)						\
+	({								\
+		unsigned long val;					\
+		val  = (x)->Op0 << 14;					\
+		val |= (x)->Op1 << 11;					\
+		val |= (x)->CRn << 7;					\
+		val |= (x)->CRm << 3;					\
+		val |= (x)->Op2;					\
+		val;							\
+	 })
+
+static int match_sys_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct sys_reg_desc *r = elt;
+
+	return pval - reg_to_match_value(r);
+}
+
 static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
 {
-	unsigned int i;
-
-	for (i = 0; i < num; i++) {
-		const struct sys_reg_desc *r = &table[i];
+	unsigned long pval = reg_to_match_value(params);
 
-		if (params->Op0 != r->Op0)
-			continue;
-		if (params->Op1 != r->Op1)
-			continue;
-		if (params->CRn != r->CRn)
-			continue;
-		if (params->CRm != r->CRm)
-			continue;
-		if (params->Op2 != r->Op2)
-			continue;
-
-		return r;
-	}
-	return NULL;
+	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
-- 
2.1.4

