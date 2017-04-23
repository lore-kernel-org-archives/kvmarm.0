From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 27/79] arm64: KVM: PMU: Refactor pmu_*_el0_disabled
Date: Sun, 23 Apr 2017 19:08:37 +0200
Message-ID: <20170423170929.27334-28-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF4549C71
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScHhLTLpDwde for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:16 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEB6449CC6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:13 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id m123so50336053wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:00 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

There is a lot of duplication in the pmu_*_el0_disabled helpers,
and as we're going to modify them shortly, let's move all the
common stuff in a single function.

No functional change.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e26f8c..036efc97 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -460,35 +460,32 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
-static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
+static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
-	return !((reg & ARMV8_PMU_USERENR_EN) || vcpu_mode_priv(vcpu));
+	return !enabled;
 }
 
-static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_EN);
+}
 
-	return !((reg & (ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
+{
+	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-
-	return !((reg & (ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN);
 }
 
 static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
 {
-	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-
-	return !((reg & (ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN))
-		 || vcpu_mode_priv(vcpu));
+	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
 }
 
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.9.0
