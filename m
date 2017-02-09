From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/25] KVM: arm/arm64: vgic: Introduce find_reg_by_id()
Date: Thu,  9 Feb 2017 14:59:03 +0000
Message-ID: <1486652363-7696-6-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, Pavel Fedin <p.fedin@samsung.com>, Shanker Donthineni <shankerd@codeaurora.org>, Jintack Lim <jintack@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

In order to implement vGICv3 CPU interface access, we will need to perform
table lookup of system registers. We would need both index_to_params() and
find_reg() exported for that purpose, but instead we export a single
function which combines them both.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++-----------
 arch/arm64/kvm/sys_regs.h |  4 ++++
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87e7e66..caa47ce 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1795,6 +1795,17 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
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
@@ -1807,11 +1818,8 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
 		return NULL;
 
-	if (!index_to_params(id, &params))
-		return NULL;
-
 	table = get_target_table(vcpu->arch.target, true, &num);
-	r = find_reg(&params, table, num);
+	r = find_reg_by_id(id, &params, table, num);
 	if (!r)
 		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 
@@ -1918,10 +1926,8 @@ static int get_invariant_sys_reg(u64 id, void __user *uaddr)
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
 
@@ -1935,9 +1941,8 @@ static int set_invariant_sys_reg(u64 id, void __user *uaddr)
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
index dbbb01c..9c6ffd0 100644
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
2.1.4
