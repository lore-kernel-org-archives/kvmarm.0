From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 16/19] arm: KVM: Drop unreachable HYP abort handlers
Date: Tue,  6 Sep 2016 14:02:14 +0100
Message-ID: <1473166937-15271-17-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F21649B6B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SCrzrcihywD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:54:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B8D49B5A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:15 -0400 (EDT)
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
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

Both data and prefetch aborts occuring in HYP lead to a well
deserved panic. Let's get rid of these silly handlers.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/handle_exit.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 4eacb5c..4e40d19 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -28,14 +28,6 @@
 
 typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
 
-static int handle_svc_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* SVC called from Hyp mode should never get here */
-	kvm_debug("SVC called from Hyp mode shouldn't go here\n");
-	BUG();
-	return -EINVAL; /* Squash warning */
-}
-
 static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int ret;
@@ -59,22 +51,6 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-static int handle_pabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* The hypervisor should never cause aborts */
-	kvm_err("Prefetch Abort taken from Hyp mode at %#08lx (HSR: %#08x)\n",
-		kvm_vcpu_get_hfar(vcpu), kvm_vcpu_get_hsr(vcpu));
-	return -EFAULT;
-}
-
-static int handle_dabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* This is either an error in the ws. code or an external abort */
-	kvm_err("Data Abort taken from Hyp mode at %#08lx (HSR: %#08x)\n",
-		kvm_vcpu_get_hfar(vcpu), kvm_vcpu_get_hsr(vcpu));
-	return -EFAULT;
-}
-
 /**
  * kvm_handle_wfx - handle a WFI or WFE instructions trapped in guests
  * @vcpu:	the vcpu pointer
@@ -112,13 +88,10 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
 	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
 	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
-	[HSR_EC_SVC_HYP]	= handle_svc_hyp,
 	[HSR_EC_HVC]		= handle_hvc,
 	[HSR_EC_SMC]		= handle_smc,
 	[HSR_EC_IABT]		= kvm_handle_guest_abort,
-	[HSR_EC_IABT_HYP]	= handle_pabt_hyp,
 	[HSR_EC_DABT]		= kvm_handle_guest_abort,
-	[HSR_EC_DABT_HYP]	= handle_dabt_hyp,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
-- 
2.1.4
