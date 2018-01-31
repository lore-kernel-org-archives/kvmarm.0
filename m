From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 12/28] Revert "arm64: KVM: Hide PMU from guests when disabled"
Date: Wed, 31 Jan 2018 10:34:51 +0100
Message-ID: <20180131093507.22219-13-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Commit 0c0543a128bd1c6a4c8610d0d9d869053fa2fbf5 breaks migration and
introduces a regression with existing userspace because it introduces an
ordering requirement of setting up all VCPU features before writing ID
registers which we didn't have before.

Revert this commit for now until we have a proper fix.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 503144f13af0..1830ebc227d1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -881,25 +881,18 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 }
 
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(struct kvm_vcpu *vcpu,
-		       struct sys_reg_desc const *r,
-		       bool raz)
+static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
 	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
-	switch (id) {
-	case SYS_ID_AA64DFR0_EL1:
-		if (!kvm_arm_pmu_v3_ready(vcpu))
-			val &= ~(0xfUL << ID_AA64DFR0_PMUVER_SHIFT);
-		break;
-	case SYS_ID_AA64PFR0_EL1:
+	if (id == SYS_ID_AA64PFR0_EL1) {
 		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
 			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
 				    task_pid_nr(current));
+
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
-		break;
 	}
 
 	return val;
@@ -915,7 +908,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_id_reg(vcpu, r, raz);
+	p->regval = read_id_reg(r, raz);
 	return true;
 }
 
@@ -944,17 +937,17 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-			void __user *uaddr, bool raz)
+static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
-	const u64 val = read_id_reg(vcpu, rd, raz);
+	const u64 val = read_id_reg(rd, raz);
 
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
-			void __user *uaddr, bool raz)
+static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
+			bool raz)
 {
 	const u64 id = sys_reg_to_index(rd);
 	int err;
@@ -965,7 +958,7 @@ static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		return err;
 
 	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
+	if (val != read_id_reg(rd, raz))
 		return -EINVAL;
 
 	return 0;
@@ -974,25 +967,25 @@ static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(vcpu, rd, uaddr, false);
+	return __get_id_reg(rd, uaddr, false);
 }
 
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(vcpu, rd, uaddr, false);
+	return __set_id_reg(rd, uaddr, false);
 }
 
 static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __get_id_reg(vcpu, rd, uaddr, true);
+	return __get_id_reg(rd, uaddr, true);
 }
 
 static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 			  const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	return __set_id_reg(vcpu, rd, uaddr, true);
+	return __set_id_reg(rd, uaddr, true);
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-- 
2.14.2
