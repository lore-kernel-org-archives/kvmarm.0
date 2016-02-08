From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/8] ARM: KVM: Switch the CP reg search to be a binary search
Date: Mon,  8 Feb 2016 11:40:19 +0000
Message-ID: <1454931622-14902-6-git-send-email-marc.zyngier@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 595C249761
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 06:34:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ztMkDOdU2dNk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2016 06:34:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33D1E4970D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2016 06:34:48 -0500 (EST)
In-Reply-To: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
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

Doing a linear search is a bit silly when we can do a binary search.
Not that we trap that so many things that it has become a burden yet,
but it makes sense to align it with the arm64 code.

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
