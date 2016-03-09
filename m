From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 78/95] arm64: KVM: Switch the sys_reg search to be a binary
 search
Date: Wed,  9 Mar 2016 07:31:12 +0000
Message-ID: <1457508689-19672-79-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1878149BB8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JypB-YjlWIex for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01DB349BA8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:28 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Our 64bit sys_reg table is about 90 entries long (so far, and the
PMU support is likely to increase this). This means that on average,
it takes 45 comparaisons to find the right entry (and actually the
full 90 if we have to search the invariant table).

Not the most efficient thing. Specially when you think that this
table is already sorted. Switching to a binary search effectively
reduces the search to about 7 comparaisons. Slightly better!

As an added bonus, the comparison is done by comparing all the
fields at once, instead of one at a time.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fe15c23..61ba591 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -20,6 +20,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
@@ -1453,29 +1454,32 @@ static const struct sys_reg_desc *get_target_table(unsigned target,
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
