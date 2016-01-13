From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH 3/3] KVM: ARM64: Fix guest dead loop when register accessor
 returns false
Date: Wed, 13 Jan 2016 17:16:41 +0800
Message-ID: <1452676601-14796-4-git-send-email-zhaoshenglong@huawei.com>
References: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED23749B17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:16:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PXhW3wGdIOi4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 04:16:46 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B08749B08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:16:45 -0500 (EST)
In-Reply-To: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
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
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Currently emulate_cp will return 0 (Handled) no matter what the accessor
returns. If register accessor returns false, it will not skip current PC
while emulate_cp return handled. Then guest will stuck in a dead loop.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4048934..2e90371 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1007,10 +1007,9 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 		if (likely(r->access(vcpu, params, r))) {
 			/* Skip instruction, since it was emulated */
 			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+			/* Handled */
+			return 0;
 		}
-
-		/* Handled */
-		return 0;
 	}
 
 	/* Not handled */
-- 
2.0.4
