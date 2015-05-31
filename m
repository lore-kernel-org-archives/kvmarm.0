From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v2 02/11] KVM: arm: rename pm_fake handler to trap_raz_wi
Date: Sun, 31 May 2015 12:27:03 +0800
Message-ID: <1433046432-1824-3-git-send-email-zhichao.huang@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04F6B526DC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2015 00:18:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3vXBejk6IG8N for <kvmarm@lists.cs.columbia.edu>;
 Sun, 31 May 2015 00:18:07 -0400 (EDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
 [209.85.192.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA96A526D3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 31 May 2015 00:18:06 -0400 (EDT)
Received: by pdbnf5 with SMTP id nf5so21869942pdb.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 May 2015 21:27:58 -0700 (PDT)
In-Reply-To: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
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
