From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v12 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Mon, 22 Feb 2016 17:37:39 +0800
Message-ID: <1456133877-9584-4-git-send-email-zhaoshenglong@huawei.com>
References: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456133877-9584-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

We are about to trap and emulate accesses to each PMU register
individually. This adds the context offsets for the AArch64 PMU
registers.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6f0241f..6bab7fb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -115,6 +115,21 @@ enum vcpu_sysreg {
 	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 
+	/* Performance Monitors Registers */
+	PMCR_EL0,	/* Control Register */
+	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
+	PMSELR_EL0,	/* Event Counter Selection Register */
+	PMEVCNTR0_EL0,	/* Event Counter Register (0-30) */
+	PMEVCNTR30_EL0 = PMEVCNTR0_EL0 + 30,
+	PMCCNTR_EL0,	/* Cycle Counter Register */
+	PMEVTYPER0_EL0,	/* Event Type Register (0-30) */
+	PMEVTYPER30_EL0 = PMEVTYPER0_EL0 + 30,
+	PMCCFILTR_EL0,	/* Cycle Count Filter Register */
+	PMCNTENSET_EL0,	/* Count Enable Set Register */
+	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
+	PMUSERENR_EL0,	/* User Enable Register */
+	PMSWINC_EL0,	/* Software Increment Register */
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
-- 
2.0.4


