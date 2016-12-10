From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 2/7] KVM: arm/arm64: Move kvm_vgic_flush_hwstate under
 disabled irq
Date: Sat, 10 Dec 2016 21:47:07 +0100
Message-ID: <20161210204712.21830-3-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF68E40296
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30JQBroOHxGZ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:46:05 -0500 (EST)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D21E84028D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:04 -0500 (EST)
Received: by mail-lf0-f54.google.com with SMTP id b14so21782823lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:47:08 -0800 (PST)
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to play tricks with the timer to be more lazy in saving
and restoring state, we need to move the timer flush function under a
disabled irq section and since we hav to flush the vgic state after the
timer state, move it as well.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 13e54e8..6591af7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -627,11 +627,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		preempt_disable();
 		kvm_pmu_flush_hwstate(vcpu);
-		kvm_timer_flush_hwstate(vcpu);
-		kvm_vgic_flush_hwstate(vcpu);
 
 		local_irq_disable();
 
+		kvm_timer_flush_hwstate(vcpu);
+		kvm_vgic_flush_hwstate(vcpu);
+
 		/*
 		 * Re-check atomic conditions
 		 */
-- 
2.9.0
