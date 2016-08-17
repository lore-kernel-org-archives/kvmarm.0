From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/12] arm64: KVM: remove misleading comment on pmu status
Date: Wed, 17 Aug 2016 21:38:58 +0200
Message-ID: <20160817193859.15726-12-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Comment about how PMU access is handled is not relavant since v4.6
where proper PMU support was added in.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b0b225c..af5ea86 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -823,14 +823,6 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
  *
- * We could trap ID_DFR0 and tell the guest we don't support performance
- * monitoring.  Unfortunately the patch to make the kernel check ID_DFR0 was
- * NAKed, so it will read the PMCR anyway.
- *
- * Therefore we tell the guest we have 0 counters.  Unfortunately, we
- * must always support PMCCNTR (the cycle counter): we just RAZ/WI for
- * all PM registers, which doesn't crash the guest kernel at least.
- *
  * Debug handling: We do trap most, if not all debug related system
  * registers. The implementation is good enough to ensure that a guest
  * can use these with minimal performance degradation. The drawback is
-- 
2.9.0

