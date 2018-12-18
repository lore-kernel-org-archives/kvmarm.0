From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v4 4/6] arm64/kvm: enable pointer authentication cpufeature
 conditionally
Date: Tue, 18 Dec 2018 13:26:48 +0530
Message-ID: <1545119810-12182-5-git-send-email-amit.kachhap@arm.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D463E4A32B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 02:57:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wL0YpU3m4qxq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Dec 2018 02:57:35 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F534A211
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 02:57:35 -0500 (EST)
In-Reply-To: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

According to userspace settings, pointer authentication cpufeature
is enabled/disabled from guests.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 Documentation/arm64/pointer-authentication.txt |  3 +++
 arch/arm64/kvm/sys_regs.c                      | 33 ++++++++++++++++----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index 8c0f338..a65dca2 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -92,3 +92,6 @@ created by passing a flag (KVM_ARM_VCPU_PTRAUTH) requesting this feature
 to be enabled. Without this flag, pointer authentication is not enabled
 in KVM guests and attempted use of the feature will result in an UNDEFINED
 exception being injected into the guest.
+
+Additionally, when KVM_ARM_VCPU_PTRAUTH is not set then KVM will mask the
+feature bits from ID_AA64ISAR1_EL1.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6af6c7d..ce6144a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1055,7 +1055,7 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
+static u64 read_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
@@ -1066,6 +1066,15 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 			kvm_debug("SVE unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
+	} else if (id == SYS_ID_AA64ISAR1_EL1) {
+		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
+					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
+		if (!kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
+			kvm_debug("ptrauth unsupported for guests, suppressing\n");
+			val &= ~ptrauth_mask;
+		}
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
@@ -1086,7 +1095,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(r, raz);
+	p->regval = read_id_reg(vcpu, r, raz);
 	return true;
 }
 
@@ -1115,17 +1124,17 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
-			bool raz)
+static int __get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			void __user *uaddr, bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
-	const u64 val = read_id_reg(rd, raz);
+	const u64 val = read_id_reg(vcpu, rd, raz);
 
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
-			bool raz)
+static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			void __user *uaddr, bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
 	int err;
@@ -1136,7 +1145,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
 		return err;
 
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(rd, raz))
+	if (val != read_id_reg(vcpu, rd, raz))
 		return -EINVAL;
 
 	return 0;
@@ -1145,25 +1154,25 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
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
2.7.4
