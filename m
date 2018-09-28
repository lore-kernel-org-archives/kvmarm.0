From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 09/23] KVM: arm64: Propagate vcpu into read_id_reg()
Date: Fri, 28 Sep 2018 14:39:13 +0100
Message-ID: <1538141967-15375-10-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB194A252
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dje9doJbVkwc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 328EC4A217
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:33 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Architecture features that are conditionally visible to the guest
will require run-time checks in the ID register accessor functions.
In particular, read_id_reg() will need to perform checks in order
to generate the correct emulated value for certain ID register
fields such as ID_AA64PFR0_EL1.SVE for example.

This patch propagates vcpu into read_id_reg() so that future
patches can add run-time checks on the guest configuration here.

For now, there is no functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22fbbdb..0dfd064 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1029,7 +1029,8 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
+static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
@@ -1060,7 +1061,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(r, raz);
+	p->regval = read_id_reg(vcpu, r, raz);
 	return true;
 }
 
@@ -1089,16 +1090,18 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+static int __get_id_reg(const struct kvm_vcpu *vcpu,
+			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
-	const u64 val = read_id_reg(rd, raz);
+	const u64 val = read_id_reg(vcpu, rd, raz);
 
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+static int __set_id_reg(const struct kvm_vcpu *vcpu,
+			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
@@ -1110,7 +1113,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
 		return err;
 
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(rd, raz))
+	if (val != read_id_reg(vcpu, rd, raz))
 		return -EINVAL;
 
 	return 0;
@@ -1119,25 +1122,25 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(rd, uaddr, false);
+	return __get_id_reg(vcpu, rd, uaddr, false);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(rd, uaddr, false);
+	return __set_id_reg(vcpu, rd, uaddr, false);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(rd, uaddr, true);
+	return __get_id_reg(vcpu, rd, uaddr, true);
 }
 
 static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(rd, uaddr, true);
+	return __set_id_reg(vcpu, rd, uaddr, true);
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-- 
2.1.4
