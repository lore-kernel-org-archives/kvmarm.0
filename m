From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v9 03/21] KVM: ARM64: Add offset defines for PMU registers
Date: Fri, 15 Jan 2016 14:27:37 +0800
Message-ID: <1452839275-19368-4-git-send-email-zhaoshenglong@huawei.com>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D3649A58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 01:25:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id StrntlHmJnhW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 01:25:21 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09D3749A23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 01:25:19 -0500 (EST)
In-Reply-To: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
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

We are about to trap and emulate accesses to each PMU register
individually. This adds the context offsets for the AArch64 PMU
registers.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
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
