From: James Morse <james.morse@arm.com>
Subject: [PATCH] KVM: arm/arm64: Handle CPU_PM_ENTER_FAILED
Date: Mon, 22 Jan 2018 18:19:06 +0000
Message-ID: <20180122181906.29333-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEDEE49DAB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 13:16:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rcm7z42wTIJJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jan 2018 13:16:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1FCC49D32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jan 2018 13:16:17 -0500 (EST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

cpu_pm_enter() calls the pm notifier chain with CPU_PM_ENTER, then if
there is a failure: CPU_PM_ENTER_FAILED.

When KVM receives CPU_PM_ENTER it calls cpu_hyp_reset() which will
return us to the hyp-stub. If we subsequently get a CPU_PM_ENTER_FAILED,
KVM does nothing, leaving the CPU running with the hyp-stub, at odds
with kvm_arm_hardware_enabled.

Add CPU_PM_ENTER_FAILED as a fallthrough for CPU_PM_EXIT, this reloads
KVM based on kvm_arm_hardware_enabled. This is safe even if CPU_PM_ENTER
never gets as far as KVM, as cpu_hyp_reinit() calls cpu_hyp_reset()
to make sure the hyp-stub is loaded before reloading KVM.

CC: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
Prior to 67f691976662 ("arm64: kvm: allows kvm cpu hotplug") KVM only
called cpu_hpy_reinit() when it got CPU_PM_EXIT, so KVM would stay
loaded in the above scenario. But, this patch doesn't apply that far
back as KVM moved from arch/arm to virt/kvm/arm.

Fixes: 67f691976662 ("arm64: kvm: allows kvm cpu hotplug")

 virt/kvm/arm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 15bf026eb182..0a1025f87909 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1246,6 +1246,7 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 			cpu_hyp_reset();
 
 		return NOTIFY_OK;
+	case CPU_PM_ENTER_FAILED:
 	case CPU_PM_EXIT:
 		if (__this_cpu_read(kvm_arm_hardware_enabled))
 			/* The hardware was enabled before suspend. */
-- 
2.15.1
