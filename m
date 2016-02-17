From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 05/17] ARM: KVM: Switch the CP reg search to be a binary search
Date: Wed, 17 Feb 2016 16:40:37 +0000
Message-ID: <1455727249-24752-6-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Doing a linear search is a bit silly when we can do a binary search.
Not that we trap that so many things that it has become a burden yet,
but it makes sense to align it with the arm64 code.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 2a67f00..4f1c869 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -16,6 +16,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
+
+#include <linux/bsearch.h>
 #include <linux/mm.h>
 #include <linux/kvm_host.h>
 #include <linux/uaccess.h>
@@ -414,29 +416,32 @@ static const struct coproc_reg *get_target_table(unsigned target, size_t *num)
 	return table->table;
 }
 
+#define reg_to_match_value(x)						\
+	({								\
+		unsigned long val;					\
+		val  = (x)->CRn << 11;					\
+		val |= (x)->CRm << 7;					\
+		val |= (x)->Op1 << 4;					\
+		val |= (x)->Op2 << 1;					\
+		val |= !(x)->is_64bit;					\
+		val;							\
+	 })
+
+static int match_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct coproc_reg *r = elt;
+
+	return pval - reg_to_match_value(r);
+}
+
 static const struct coproc_reg *find_reg(const struct coproc_params *params,
 					 const struct coproc_reg table[],
 					 unsigned int num)
 {
-	unsigned int i;
-
-	for (i = 0; i < num; i++) {
-		const struct coproc_reg *r = &table[i];
+	unsigned long pval = reg_to_match_value(params);
 
-		if (params->is_64bit != r->is_64bit)
-			continue;
-		if (params->CRn != r->CRn)
-			continue;
-		if (params->CRm != r->CRm)
-			continue;
-		if (params->Op1 != r->Op1)
-			continue;
-		if (params->Op2 != r->Op2)
-			continue;
-
-		return r;
-	}
-	return NULL;
+	return bsearch((void *)pval, table, num, sizeof(table[0]), match_reg);
 }
 
 static int emulate_cp15(struct kvm_vcpu *vcpu,
-- 
2.1.4

