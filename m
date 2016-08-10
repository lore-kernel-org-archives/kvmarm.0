From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH] arm64: KVM: remove misleading comment on pmu status
Date: Wed, 10 Aug 2016 10:49:42 +0100
Message-ID: <1470822583-9014-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6424998D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 05:42:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZLpMLQxiA6eU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2016 05:42:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC342412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 05:42:51 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Comment about how PMU access is handled is not relavant since v4.6
where proper PMU support was added in.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bffc93a..6f5203d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -825,14 +825,6 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
2.0.0
