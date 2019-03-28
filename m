From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/8] KVM: arm64: Reset the PMU in preemptible context
Date: Thu, 28 Mar 2019 13:36:01 +0000
Message-ID: <20190328133608.110805-2-marc.zyngier@arm.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D456C4A418
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u7kwp61vMsT1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 09:36:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F374A417
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:38 -0400 (EDT)
In-Reply-To: <20190328133608.110805-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

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
2.20.1
