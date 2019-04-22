From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 25/98] KVM: arm64: Reset the PMU in preemptible context
Date: Mon, 22 Apr 2019 15:40:52 -0400
Message-ID: <20190422194205.10404-25-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Sasha Levin <sashal@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit ebff0b0e3d3c862c16c487959db5e0d879632559 ]

We've become very cautious to now always reset the vcpu when nothing
is loaded on the physical CPU. To do so, we now disable preemption
and do a kvm_arch_vcpu_put() to make sure we have all the state
in memory (and that it won't be loaded behind out back).

This now causes issues with resetting the PMU, which calls into perf.
Perf itself uses mutexes, which clashes with the lack of preemption.
It is worth realizing that the PMU is fully emulated, and that
no PMU state is ever loaded on the physical CPU. This means we can
perfectly reset the PMU outside of the non-preemptible section.

Fixes: e761a927bc9a ("KVM: arm/arm64: Reset the VCPU without preemption and vcpu state loaded")
Reported-by: Julien Grall <julien.grall@arm.com>
Tested-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm64/kvm/reset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f16a5f8ff2b4..e2a0500cd7a2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -123,6 +123,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	int ret = -EINVAL;
 	bool loaded;
 
+	/* Reset PMU outside of the non-preemptible section */
+	kvm_pmu_vcpu_reset(vcpu);
+
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
@@ -170,9 +173,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		vcpu->arch.reset_state.reset = false;
 	}
 
-	/* Reset PMU */
-	kvm_pmu_vcpu_reset(vcpu);
-
 	/* Default workaround setup is enabled (if supported) */
 	if (kvm_arm_have_ssbd() == KVM_SSBD_KERNEL)
 		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
-- 
2.19.1
