From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] arm/kvm: survive unknown traps from guests
Date: Mon, 20 Feb 2017 12:30:11 +0000
Message-ID: <1487593812-9174-2-git-send-email-mark.rutland@arm.com>
References: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C0D40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 07:29:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H3SjZTRmIW5B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Feb 2017 07:29:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78BA440B3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 07:29:27 -0500 (EST)
In-Reply-To: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Currently we BUG() if we see a HSR.EC value we don't recognise. As
configurable disables/enables are added to the architecture (controlled
by RES1/RES0 bits respectively), with associated synchronous exceptions,
it may be possible for a guest to trigger exceptions with classes that
we don't recognise.

While we can't service these exceptions in a manner useful to the guest,
we can avoid bringing down the host. Per ARM DDI 0406C.c, all currently
unallocated HSR EC encodings are reserved, and per ARM DDI
0487A.k_iss10775, page G6-4395, EC values within the range 0x00 - 0x2c
are reserved for future use with synchronous exceptions, and EC values
within the range 0x2d - 0x3f may be used for either synchronous or
asynchronous exceptions.

The patch makes KVM handle any unknown EC by injecting an UNDEFINED
exception into the guest, with a corresponding (ratelimited) warning in
the host dmesg. We could later improve on this with with a new (opt-in)
exit to the host userspace.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_arm.h |  1 +
 arch/arm/kvm/handle_exit.c     | 19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index e22089f..a3f0b3d 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -209,6 +209,7 @@
 #define HSR_EC_IABT_HYP	(0x21)
 #define HSR_EC_DABT	(0x24)
 #define HSR_EC_DABT_HYP	(0x25)
+#define HSR_EC_MAX	(0x3f)
 
 #define HSR_WFI_IS_WFE		(_AC(1, UL) << 0)
 
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 4e40d19..96af65a 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -79,7 +79,19 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	u32 hsr = kvm_vcpu_get_hsr(vcpu);
+
+	kvm_pr_unimpl("Unknown exception class: hsr: %#08x\n",
+		      hsr);
+
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
+	[0 ... HSR_EC_MAX]	= kvm_handle_unknown_ec,
 	[HSR_EC_WFI]		= kvm_handle_wfx,
 	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
 	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
@@ -98,13 +110,6 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 {
 	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
 
-	if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers) ||
-	    !arm_exit_handlers[hsr_ec]) {
-		kvm_err("Unknown exception class: hsr: %#08x\n",
-			(unsigned int)kvm_vcpu_get_hsr(vcpu));
-		BUG();
-	}
-
 	return arm_exit_handlers[hsr_ec];
 }
 
-- 
1.9.1
