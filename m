From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 02/10] KVM: arm: rename pm_fake handler to trap_raz_wi
Date: Sat, 16 May 2015 12:45:43 +0800
Message-ID: <1431751551-4788-3-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

pm_fake doesn't quite describe what the handler does (ignoring writes
and returning 0 for reads).

As we're about to use it (a lot) in a different context, rename it
with a (admitedly cryptic) name that make sense for all users.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/coproc.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 2e12760..9d283d9 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -229,7 +229,7 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
  * must always support PMCCNTR (the cycle counter): we just RAZ/WI for
  * all PM registers, which doesn't crash the guest kernel at least.
  */
-static bool pm_fake(struct kvm_vcpu *vcpu,
+static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		    const struct coproc_params *p,
 		    const struct coproc_reg *r)
 {
@@ -239,19 +239,19 @@ static bool pm_fake(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
-#define access_pmcr pm_fake
-#define access_pmcntenset pm_fake
-#define access_pmcntenclr pm_fake
-#define access_pmovsr pm_fake
-#define access_pmselr pm_fake
-#define access_pmceid0 pm_fake
-#define access_pmceid1 pm_fake
-#define access_pmccntr pm_fake
-#define access_pmxevtyper pm_fake
-#define access_pmxevcntr pm_fake
-#define access_pmuserenr pm_fake
-#define access_pmintenset pm_fake
-#define access_pmintenclr pm_fake
+#define access_pmcr trap_raz_wi
+#define access_pmcntenset trap_raz_wi
+#define access_pmcntenclr trap_raz_wi
+#define access_pmovsr trap_raz_wi
+#define access_pmselr trap_raz_wi
+#define access_pmceid0 trap_raz_wi
+#define access_pmceid1 trap_raz_wi
+#define access_pmccntr trap_raz_wi
+#define access_pmxevtyper trap_raz_wi
+#define access_pmxevcntr trap_raz_wi
+#define access_pmuserenr trap_raz_wi
+#define access_pmintenset trap_raz_wi
+#define access_pmintenclr trap_raz_wi
 
 /* Architected CP15 registers.
  * CRn denotes the primary register number, but is copied to the CRm in the
@@ -532,8 +532,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
 	params.CRm = 0;
 
-	/* raz_wi */
-	(void)pm_fake(vcpu, &params, NULL);
+	(void)trap_raz_wi(vcpu, &params, NULL);
 
 	/* handled */
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
@@ -559,8 +558,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
 	params.Rt2 = 0;
 
-	/* raz_wi */
-	(void)pm_fake(vcpu, &params, NULL);
+	(void)trap_raz_wi(vcpu, &params, NULL);
 
 	/* handled */
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-- 
1.7.12.4

