From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 03/16] KVM: arm64: Refactor kvm_arm_num_regs() for easier
 maintenance
Date: Thu, 21 Jun 2018 15:57:27 +0100
Message-ID: <1529593060-542-4-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6154A0F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gg9s1rg85PEd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:46:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DAC54A0E0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:46:44 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_arm_num_regs() adds together various partial register counts in
a freeform sum expression, which makes it harder than necessary to
read diffs that add, modify or remove a single term in the sum
(which is expected to the common case under maintenance).

This patch refactors the code to add the term one per line, for
maximum readability.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/guest.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 56a0260..4a9d77c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -205,8 +205,14 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
  */
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
-	return num_core_regs() + kvm_arm_num_sys_reg_descs(vcpu)
-		+ kvm_arm_get_fw_num_regs(vcpu)	+ NUM_TIMER_REGS;
+	unsigned long res = 0;
+
+	res += num_core_regs();
+	res += kvm_arm_num_sys_reg_descs(vcpu);
+	res += kvm_arm_get_fw_num_regs(vcpu);
+	res += NUM_TIMER_REGS;
+
+	return res;
 }
 
 /**
-- 
2.1.4
