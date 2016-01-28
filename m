From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/5] arm64: KVM: Fix comments of the CP handler
Date: Thu, 28 Jan 2016 10:30:37 +0000
Message-ID: <1453977038-13516-5-git-send-email-marc.zyngier@arm.com>
References: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5B2740C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 05:25:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e7QRTg9Jg44n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2016 05:25:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E72F40FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 05:25:54 -0500 (EST)
In-Reply-To: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Dave Martin <Dave.Martin@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Make sure the documentation reflects the actual name of the functions.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index eec3598..4048934 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1043,7 +1043,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 }
 
 /**
- * kvm_handle_cp_64 -- handles a mrrc/mcrr trap on a guest CP15 access
+ * kvm_handle_cp_64 -- handles a mrrc/mcrr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
  * @run:  The kvm_run struct
  */
@@ -1095,7 +1095,7 @@ out:
 }
 
 /**
- * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
+ * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
  * @run:  The kvm_run struct
  */
-- 
2.1.4
