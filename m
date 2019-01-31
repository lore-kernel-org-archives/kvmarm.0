From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/2] arm64: kvm: expose sanitised cache type register to
 guest
Date: Thu, 31 Jan 2019 14:17:17 +0100
Message-ID: <20190131131718.1627-2-ard.biesheuvel@linaro.org>
References: <20190131131718.1627-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F464A3B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:17:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrEDC4i3J05F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 08:17:30 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A7194A331
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 08:17:30 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id f7so3303923wrp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 05:17:30 -0800 (PST)
In-Reply-To: <20190131131718.1627-1-ard.biesheuvel@linaro.org>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We currently permit CPUs in the same system to deviate in the exact
topology of the caches, and we subsequently hide this fact from user
space by exposing a sanitised value of the cache type register CTR_EL0.

However, guests running under KVM see the bare value of CTR_EL0, which
could potentially result in issues with, e.g., JITs or other pieces of
code that are sensitive to misreported cache line sizes.

So let's start trapping cache ID instructions if there is a mismatch,
and expose the sanitised version of CTR_EL0 to guests. Note that CTR_EL0
is treated as an invariant to KVM user space, so update that part as well.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  3 +
 arch/arm64/include/asm/sysreg.h      |  1 +
 arch/arm64/kvm/sys_regs.c            | 59 +++++++++++++++++++-
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 506386a3edde..87f9c1b6387e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -77,6 +77,9 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 */
 	if (!vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 |= HCR_TID3;
+
+	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 72dc4c011014..6726a4c98ce7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -361,6 +361,7 @@
 
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
+#define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
 #define SYS_CLIDR_EL1			sys_reg(3, 1, 0, 0, 1)
 #define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3e37228ae4e..1312aebf74e6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1148,6 +1148,49 @@ static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return __set_id_reg(rd, uaddr, true);
 }
 
+static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	return true;
+}
+
+static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = read_sysreg(clidr_el1);
+	return true;
+}
+
+static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+	else
+		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+	return true;
+}
+
+static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	u32 csselr;
+
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	csselr = vcpu_read_sys_reg(vcpu, CSSELR_EL1);
+	p->regval = get_ccsidr(csselr);
+	return true;
+}
+
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -1365,7 +1408,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
 
-	{ SYS_DESC(SYS_CSSELR_EL1), NULL, reset_unknown, CSSELR_EL1 },
+	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
+	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
+	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 
 	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, },
 	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
@@ -1665,6 +1711,7 @@ static const struct sys_reg_desc cp14_64_regs[] = {
  * register).
  */
 static const struct sys_reg_desc cp15_regs[] = {
+	{ Op1( 0), CRn( 0), CRm( 0), Op2( 1), access_ctr },
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
@@ -1782,6 +1829,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	PMU_PMEVTYPER(30),
 	/* PMCCFILTR */
 	{ Op1(0), CRn(14), CRm(15), Op2(7), access_pmu_evtyper },
+
+	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
+	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
+	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, c0_CSSELR },
 };
 
 static const struct sys_reg_desc cp15_64_regs[] = {
@@ -2206,11 +2257,15 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 	}
 
 FUNCTION_INVARIANT(midr_el1)
-FUNCTION_INVARIANT(ctr_el0)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(clidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
+static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
+{
+	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
+}
+
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] = {
 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
-- 
2.20.1
