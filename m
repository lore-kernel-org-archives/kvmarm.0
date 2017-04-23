From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 28/79] arm64: KVM: PMU: Inject UNDEF exception on illegal
 register access
Date: Sun, 23 Apr 2017 19:08:38 +0200
Message-ID: <20170423170929.27334-29-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E6C49C9A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0a77nRBm21Ct for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:16 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E170149CB0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:14 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r190so50449221wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:01 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Both pmu_*_el0_disabled() and pmu_counter_idx_valid() perform checks
on the validity of an access, but only return a boolean indicating
if the access is valid or not.

Let's allow these functions to also inject an UNDEF exception if
the access was illegal.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 036efc97..750c129 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -465,6 +465,9 @@ static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
+	if (!enabled)
+		kvm_inject_undefined(vcpu);
+
 	return !enabled;
 }
 
@@ -564,8 +567,10 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 
 	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
-	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX)
+	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
+		kvm_inject_undefined(vcpu);
 		return false;
+	}
 
 	return true;
 }
-- 
2.9.0
