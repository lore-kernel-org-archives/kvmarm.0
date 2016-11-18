From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] arm64: KVM: pmu: Fix AArch32 cycle counter access
Date: Fri, 18 Nov 2016 09:39:25 +0000
Message-ID: <1479461966-20136-2-git-send-email-marc.zyngier@arm.com>
References: <1479461966-20136-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609D340457
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2016 04:39:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eMG3ENFxleNp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2016 04:39:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4554540288
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2016 04:39:36 -0500 (EST)
In-Reply-To: <1479461966-20136-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Huang <wei@redhat.com>

We're missing the handling code for the cycle counter accessed
from a 32bit guest, leading to unexpected results.

Cc: stable@vger.kernel.org # 4.6+
Signed-off-by: Wei Huang <wei@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f302fdb..87e7e66 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -597,8 +597,14 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 
 			idx = ARMV8_PMU_CYCLE_IDX;
 		} else {
-			BUG();
+			return false;
 		}
+	} else if (r->CRn == 0 && r->CRm == 9) {
+		/* PMCCNTR */
+		if (pmu_access_event_counter_el0_disabled(vcpu))
+			return false;
+
+		idx = ARMV8_PMU_CYCLE_IDX;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 8) {
 		/* PMEVCNTRn_EL0 */
 		if (pmu_access_event_counter_el0_disabled(vcpu))
@@ -606,7 +612,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
 	} else {
-		BUG();
+		return false;
 	}
 
 	if (!pmu_counter_idx_valid(vcpu, idx))
-- 
2.1.4
