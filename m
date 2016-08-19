From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/5] arm/arm64: KVM: Don't BUG_ON if IT bits are set in ARM
 mode
Date: Fri, 19 Aug 2016 13:38:11 +0100
Message-ID: <1471610295-1456-2-git-send-email-marc.zyngier@arm.com>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFDB54011D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 08:30:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9GWvcZMP61K7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2016 08:30:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D1240F77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2016 08:30:51 -0400 (EDT)
In-Reply-To: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
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

The ARM ARM asserts that having the IT bits set in ARM mode is
unpredictable. But should a CPU do that (and still be able to
run correctly), we shouldn't kill the system.

So let's drop the BUG_ON that checks for this, as it is not
very helpful.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/emulate.c   | 4 +---
 arch/arm64/kvm/emulate.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index af93e3f..eda9ddd 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -221,9 +221,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_arm = !(cpsr & PSR_T_BIT);
 
-	BUG_ON(is_arm && (cpsr & PSR_IT_MASK));
-
-	if (!(cpsr & PSR_IT_MASK))
+	if (is_arm || !(cpsr & PSR_IT_MASK))
 		return;
 
 	cond = (cpsr & 0xe000) >> 13;
diff --git a/arch/arm64/kvm/emulate.c b/arch/arm64/kvm/emulate.c
index f87d8fb..df76590 100644
--- a/arch/arm64/kvm/emulate.c
+++ b/arch/arm64/kvm/emulate.c
@@ -120,9 +120,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_arm = !(cpsr & COMPAT_PSR_T_BIT);
 
-	BUG_ON(is_arm && (cpsr & COMPAT_PSR_IT_MASK));
-
-	if (!(cpsr & COMPAT_PSR_IT_MASK))
+	if (is_arm || !(cpsr & COMPAT_PSR_IT_MASK))
 		return;
 
 	cond = (cpsr & 0xe000) >> 13;
-- 
2.1.4
