From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 5/7] KVM: arm64: Introduce find_reg_by_id()
Date: Mon, 12 Oct 2015 11:29:37 +0300
Message-ID: <db53170fd923bfcb1e543da5b0e3093b19cde487.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to implement vGICv3 CPU interface access, we will need to perform
table lookup of system registers. We would need both index_to_params() and
find_reg() exported for that purpose, but instead we export a single
function which combines them both.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 22 +++++++++++++++-------
 arch/arm64/kvm/sys_regs.h |  4 ++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39db06dd..713b4fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1276,6 +1276,17 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
+const struct sys_reg_desc *find_reg_by_id(u64 id,
+					  struct sys_reg_params *params,
+					  const struct sys_reg_desc table[],
+					  unsigned int num)
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
@@ -1403,10 +1414,8 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
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
 
@@ -1420,9 +1429,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
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
index 3267518..0646108 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -136,6 +136,10 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 	return i1->Op2 - i2->Op2;
 }
 
+const struct sys_reg_desc *find_reg_by_id(u64 id,
+					  struct sys_reg_params *params,
+					  const struct sys_reg_desc table[],
+					  unsigned int num);
 
 #define Op0(_x) 	.Op0 = _x
 #define Op1(_x) 	.Op1 = _x
-- 
2.4.4

