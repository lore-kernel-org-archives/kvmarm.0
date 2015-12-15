From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v7 06/19] KVM: ARM64: Add access handler for PMCEID0 and
 PMCEID1 register
Date: Tue, 15 Dec 2015 16:49:26 +0800
Message-ID: <1450169379-12336-7-git-send-email-zhaoshenglong@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 199B6412D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:53:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCcjOtU4ufHU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 03:53:39 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C1A2411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:53:38 -0500 (EST)
In-Reply-To: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add access handler which gets host value of PMCEID0 or PMCEID1 when
guest access these registers. Writing action to PMCEID0 or PMCEID1 is
ignored.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c21f91b..e043224 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -486,6 +486,24 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	u64 pmceid;
+
+	if (p->is_write)
+		return write_to_read_only(vcpu, p);
+
+	if (!(p->Op2 & 1))
+		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
+	else
+		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
+
+	p->regval = pmceid;
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -688,10 +706,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmselr, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
-	  trap_raz_wi },
+	  access_pmceid },
 	/* PMCEID1_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
-	  trap_raz_wi },
+	  access_pmceid },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
 	  trap_raz_wi },
@@ -937,8 +955,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
-- 
2.0.4
