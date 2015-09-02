From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 4/5] KVM: arm64: Introduce find_reg_by_id()
Date: Wed, 02 Sep 2015 11:09:48 +0300
Message-ID: <af4234ba56858451ffb6152cac8bf34bf7692bb4.1441180858.git.p.fedin@samsung.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24C6548AB0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:09:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kLwK29XPRxwv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 04:09:37 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09E0C48A8A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 04:09:37 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NU100GDOIOJCT70@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 02 Sep 2015 09:09:55 +0100 (BST)
In-reply-to: <cover.1441180858.git.p.fedin@samsung.com>
In-reply-to: <cover.1441180858.git.p.fedin@samsung.com>
References: <cover.1441180858.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to implement vGICv3 CPU interface access, we will need to perform
table lookup of system registers. We would need both index_to_params() and
find_reg() exported for that purpose, but instead we export a single function
which combines them both.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/kvm/sys_regs.c | 22 +++++++++++++++-------
 arch/arm64/kvm/sys_regs.h |  4 ++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0a82b9e..89ae369 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1283,6 +1283,17 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
+const struct sys_reg_desc *find_reg_by_id(u64 id,
+					  struct sys_reg_params *params,
+				          const struct sys_reg_desc table[],
+				          unsigned int num)
+{
+	if (!index_to_params(id, params))
+		return NULL;
+
+	return find_reg(params, table, num);
+}
+
 /* Decode an index value, and find the sys_reg_desc entry. */
 static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 						    u64 id)
@@ -1410,10 +1421,8 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
 	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
 
-	if (!index_to_params(id, &params))
-		return -ENOENT;
-
-	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
+	r = find_reg_by_id(id, &params, invariant_sys_regs,
+			   ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
@@ -1427,9 +1436,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
 	int err;
 	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
 
-	if (!index_to_params(id, &params))
-		return -ENOENT;
-	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
+	r = find_reg_by_id(id, &params, invariant_sys_regs,
+			   ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 3267518..fd96ed2 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -136,6 +136,10 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 	return i1->Op2 - i2->Op2;
 }
 
+const struct sys_reg_desc *find_reg_by_id(u64 id,
+					  struct sys_reg_params *params,
+				          const struct sys_reg_desc table[],
+				          unsigned int num);
 
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
-- 
2.4.4
