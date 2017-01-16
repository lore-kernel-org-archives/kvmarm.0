From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH RFC 3/7] ARM64: KVM: Reset ID registers when creating the VCPUs
Date: Mon, 16 Jan 2017 17:33:30 +0800
Message-ID: <1484559214-2248-4-git-send-email-zhaoshenglong@huawei.com>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BBE240064
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:34:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kaXgrXELCs7P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jan 2017 04:34:02 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4243C4075C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jan 2017 04:33:50 -0500 (EST)
In-Reply-To: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Reset ID registers when creating the VCPUs and store the values per
VCPU. Also modify the get_invariant_sys_reg and set_invariant_sys_reg
to get/set the ID register from vcpu context.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/kvm_coproc.h |  1 +
 arch/arm64/kvm/guest.c              |  1 +
 arch/arm64/kvm/sys_regs.c           | 58 ++++++++++++++++++-------------------
 3 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index 0b52377..0801b66 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -24,6 +24,7 @@
 #include <linux/kvm_host.h>
 
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
+void kvm_reset_id_sys_regs(struct kvm_vcpu *vcpu);
 
 struct kvm_sys_reg_table {
 	const struct sys_reg_desc *table;
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b37446a..92abe2b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -48,6 +48,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
+	kvm_reset_id_sys_regs(vcpu);
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bf71eb4..7c5fa03 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1440,11 +1440,11 @@ static const struct sys_reg_desc cp15_64_regs[] = {
  * the guest, or a future kvm may trap them.
  */
 
-#define FUNCTION_INVARIANT(reg)						\
-	static void get_##reg(struct kvm_vcpu *v,			\
-			      const struct sys_reg_desc *r)		\
+#define FUNCTION_INVARIANT(register)					\
+	static void get_##register(struct kvm_vcpu *v,			\
+				   const struct sys_reg_desc *r)	\
 	{								\
-		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
+		vcpu_id_sys_reg(v, r->reg) = read_sysreg(register);	\
 	}
 
 FUNCTION_INVARIANT(midr_el1)
@@ -1480,7 +1480,6 @@ FUNCTION_INVARIANT(id_aa64mmfr1_el1)
 FUNCTION_INVARIANT(clidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-/* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] = {
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
 	  NULL, get_midr_el1, MIDR_EL1 },
@@ -1952,43 +1951,43 @@ static int reg_to_user(void __user *uaddr, const u64 *val, u64 id)
 	return 0;
 }
 
-static int get_invariant_sys_reg(u64 id, void __user *uaddr)
+static int get_invariant_sys_reg(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
 {
 	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
+	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
 
-	if (!index_to_params(id, &params))
+	if (!index_to_params(reg->id, &params))
 		return -ENOENT;
 
 	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
-	return reg_to_user(uaddr, &r->val, id);
+	if (r->get_user)
+		return (r->get_user)(vcpu, r, reg, uaddr);
+
+	return reg_to_user(uaddr, &vcpu_id_sys_reg(vcpu, r->reg), reg->id);
 }
 
-static int set_invariant_sys_reg(u64 id, void __user *uaddr)
+static int set_invariant_sys_reg(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
 {
 	struct sys_reg_params params;
 	const struct sys_reg_desc *r;
-	int err;
-	u64 val = 0; /* Make sure high bits are 0 for 32-bit regs */
+	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
 
-	if (!index_to_params(id, &params))
+	if (!index_to_params(reg->id, &params))
 		return -ENOENT;
 	r = find_reg(&params, invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs));
 	if (!r)
 		return -ENOENT;
 
-	err = reg_from_user(&val, uaddr, id);
-	if (err)
-		return err;
-
-	/* This is what we mean by invariant: you can't change it. */
-	if (r->val != val)
-		return -EINVAL;
+	if (r->set_user)
+		return (r->set_user)(vcpu, r, reg, uaddr);
 
-	return 0;
+	return reg_from_user(&vcpu_id_sys_reg(vcpu, r->reg), uaddr, reg->id);
 }
 
 static bool is_valid_cache(u32 val)
@@ -2086,7 +2085,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 
 	r = index_to_sys_reg_desc(vcpu, reg->id);
 	if (!r)
-		return get_invariant_sys_reg(reg->id, uaddr);
+		return get_invariant_sys_reg(vcpu, reg);
 
 	if (r->get_user)
 		return (r->get_user)(vcpu, r, reg, uaddr);
@@ -2107,7 +2106,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 
 	r = index_to_sys_reg_desc(vcpu, reg->id);
 	if (!r)
-		return set_invariant_sys_reg(reg->id, uaddr);
+		return set_invariant_sys_reg(vcpu, reg);
 
 	if (r->set_user)
 		return (r->set_user)(vcpu, r, reg, uaddr);
@@ -2252,7 +2251,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n)
 void kvm_sys_reg_table_init(void)
 {
 	unsigned int i;
-	struct sys_reg_desc clidr;
 
 	/* Make sure tables are unique and in order. */
 	BUG_ON(check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs)));
@@ -2262,10 +2260,6 @@ void kvm_sys_reg_table_init(void)
 	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs)));
 	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs)));
 
-	/* We abuse the reset function to overwrite the table itself. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
-		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
-
 	/*
 	 * CLIDR format is awkward, so clean it up.  See ARM B4.1.20:
 	 *
@@ -2276,8 +2270,7 @@ void kvm_sys_reg_table_init(void)
 	 *   value of 0b000, the values of Ctype4 to Ctype7 must be
 	 *   ignored.
 	 */
-	get_clidr_el1(NULL, &clidr); /* Ugly... */
-	cache_levels = clidr.val;
+	cache_levels = read_sysreg(clidr_el1);
 	for (i = 0; i < 7; i++)
 		if (((cache_levels >> (i*3)) & 7) == 0)
 			break;
@@ -2310,3 +2303,10 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 		if (vcpu_sys_reg(vcpu, num) == 0x4242424242424242)
 			panic("Didn't reset vcpu_sys_reg(%zi)", num);
 }
+
+void kvm_reset_id_sys_regs(struct kvm_vcpu *vcpu)
+{
+	unsigned int i;
+	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
+		invariant_sys_regs[i].reset(vcpu, &invariant_sys_regs[i]);
+}
-- 
2.0.4
