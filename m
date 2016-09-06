From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 4/7] arm64: KVM: Make kvm_skip_instr32 available to HYP
Date: Tue,  6 Sep 2016 09:28:44 +0100
Message-ID: <1473150527-4729-5-git-send-email-marc.zyngier@arm.com>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08FF749B50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZq34Fb+tEgO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 04:20:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63EFB49B62
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:38 -0400 (EDT)
In-Reply-To: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we plan to do some emulation at HYP, let's make kvm_skip_instr32
as part of the hyp_text section. This doesn't preclude the kernel
from using it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/aarch32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index ba4417b..528af4b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -23,6 +23,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 
 #ifndef CONFIG_ARM64
 #define COMPAT_PSR_T_BIT	PSR_T_BIT
@@ -108,7 +109,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
  *
  * IT[7:0] -> CPSR[26:25],CPSR[15:10]
  */
-static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 {
 	unsigned long itbits, cond;
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -138,7 +139,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  * kvm_skip_instr - skip a trapped instruction and proceed to the next
  * @vcpu: The vcpu pointer
  */
-void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
+void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
 {
 	bool is_thumb;
 
-- 
2.1.4
