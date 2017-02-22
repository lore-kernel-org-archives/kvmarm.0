From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/8] arm64: KVM: PMU: Inject UNDEF on read access to PMSWINC_EL0
Date: Wed, 22 Feb 2017 11:47:26 +0000
Message-ID: <20170222114728.2472-7-marc.zyngier@arm.com>
References: <20170222114728.2472-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170222114728.2472-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

PMSWINC_EL0 is a WO register, so let's UNDEF when reading from it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cbe966658d5e..01c8d841851e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -778,6 +778,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return true;
 	}
 
+	pend_undef(vcpu);
 	return false;
 }
 
-- 
2.11.0
