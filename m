From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/10] arm/arm64: KVM: Fix ordering of timer/GIC on guest entry
Date: Mon,  8 Jun 2015 18:03:56 +0100
Message-ID: <1433783045-8002-2-git-send-email-marc.zyngier@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E2753E7A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 12:54:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GYFV6yQy-2a8 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2015 12:54:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F1753E79
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2015 12:54:12 -0400 (EDT)
In-Reply-To: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we now inject the timer interrupt when we're about to enter
the guest, it makes a lot more sense to make sure this happens
before the vgic code queues the pending interrupts.

Otherwise, we get the interrupt on the following exit, which is
not great for latency (and leads to all kind of bizarre issues
when using with active interrupts at the HW level).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..46db690 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -529,9 +529,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (vcpu->arch.pause)
 			vcpu_pause(vcpu);
 
-		kvm_vgic_flush_hwstate(vcpu);
 		kvm_timer_flush_hwstate(vcpu);
 
+		kvm_vgic_flush_hwstate(vcpu);
+
 		local_irq_disable();
 
 		/*
@@ -544,8 +545,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
 			local_irq_enable();
-			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
+			kvm_timer_sync_hwstate(vcpu);
 			continue;
 		}
 
@@ -577,9 +578,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * Back from guest
 		 *************************************************************/
 
-		kvm_timer_sync_hwstate(vcpu);
 		kvm_vgic_sync_hwstate(vcpu);
 
+		kvm_timer_sync_hwstate(vcpu);
+
 		ret = handle_exit(vcpu, run, ret);
 	}
 
-- 
2.1.4
