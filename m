From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 32/50] arm: KVM: Drop unreachable HYP abort handlers
Date: Tue, 27 Sep 2016 20:05:40 +0200
Message-ID: <20160927180558.14699-33-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0929149BA9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dcEfAKAFnKex for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:57 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0777D49B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:55 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id d66so30466159wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:18 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Both data and prefetch aborts occuring in HYP lead to a well
deserved panic. Let's get rid of these silly handlers.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.9.0
