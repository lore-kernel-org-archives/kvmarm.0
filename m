From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 20/40] KVM: arm/arm64: Remove leftover comment from kvm_vcpu_run_vhe
Date: Thu, 15 Feb 2018 22:03:12 +0100
Message-ID: <20180215210332.8648-21-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

The comment only applied to SPE on non-VHE systems, so we simply remove
it.

Suggested-by: Andrew Jones <drjones@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 717c8f5c6be7..a99224996e33 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -410,10 +410,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 	}
 
-	/*
-	 * This must come after restoring the host sysregs, since a non-VHE
-	 * system may enable SPE here and make use of the TTBRs.
-	 */
 	__debug_switch_to_host(vcpu);
 
 	return exit_code;
-- 
2.14.2
