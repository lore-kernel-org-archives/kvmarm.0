From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/26] KVM: arm64: Fix caching of host MDCR_EL2 value
Date: Fri, 19 Oct 2018 13:58:58 +0100
Message-ID: <20181019125901.185478-24-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 919884A2BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XkYeWR8iu9bG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB524A202
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:26 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
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
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

At boot time, KVM stashes the host MDCR_EL2 value, but only does this
when the kernel is not running in hyp mode (i.e. is non-VHE). In these
cases, the stashed value of MDCR_EL2.HPMN happens to be zero, which can
lead to CONSTRAINED UNPREDICTABLE behaviour.

Since we use this value to derive the MDCR_EL2 value when switching
to/from a guest, after a guest have been run, the performance counters
do not behave as expected. This has been observed to result in accesses
via PMXEVTYPER_EL0 and PMXEVCNTR_EL0 not affecting the relevant
counters, resulting in events not being counted. In these cases, only
the fixed-purpose cycle counter appears to work as expected.

Fix this by always stashing the host MDCR_EL2 value, regardless of VHE.

Cc: Christopher Dall <christoffer.dall@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
Fixes: 1e947bad0b63b351 ("arm64: KVM: Skip HYP setup when already running in HYP")
Tested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4ce99bb223bc..4c5ff06b18f9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1296,8 +1296,6 @@ static void cpu_init_hyp_mode(void *dummy)
 
 	__cpu_init_hyp_mode(pgd_ptr, hyp_stack_ptr, vector_ptr);
 	__cpu_init_stage2();
-
-	kvm_arm_init_debug();
 }
 
 static void cpu_hyp_reset(void)
@@ -1315,6 +1313,8 @@ static void cpu_hyp_reinit(void)
 	else
 		cpu_init_hyp_mode(NULL);
 
+	kvm_arm_init_debug();
+
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
 }
-- 
2.19.1
