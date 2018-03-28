From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/85] KVM: arm/arm64: Move vcpu_load call after
 kvm_vcpu_first_run_init
Date: Wed, 28 Mar 2018 13:51:44 +0100
Message-ID: <20180328125254.31380-16-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 801014A028
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0rkwMQQ8W3Tn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:47:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE51A49DAB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:45:56 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Moving the call to vcpu_load() in kvm_arch_vcpu_ioctl_run() to after
we've called kvm_vcpu_first_run_init() simplifies some of the vgic and
there is also no need to do vcpu_load() for things such as handling the
immediate_exit flag.

Reviewed-by: Julien Grall <julien.grall@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c     |  4 ----
 virt/kvm/arm/arm.c            | 22 ++++++++--------------
 virt/kvm/arm/vgic/vgic-init.c | 11 -----------
 3 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 86eca32474cc..7dd8d9677dc5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -842,11 +842,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return ret;
 
 no_vgic:
-	preempt_disable();
 	timer->enabled = 1;
-	kvm_timer_vcpu_load(vcpu);
-	preempt_enable();
-
 	return 0;
 }
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 53572304843b..932e61858c55 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -632,27 +632,22 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (unlikely(!kvm_vcpu_initialized(vcpu)))
 		return -ENOEXEC;
 
-	vcpu_load(vcpu);
-
 	ret = kvm_vcpu_first_run_init(vcpu);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
 		if (ret)
-			goto out;
-		if (kvm_arm_handle_step_debug(vcpu, vcpu->run)) {
-			ret = 0;
-			goto out;
-		}
-
+			return ret;
+		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
+			return 0;
 	}
 
-	if (run->immediate_exit) {
-		ret = -EINTR;
-		goto out;
-	}
+	if (run->immediate_exit)
+		return -EINTR;
+
+	vcpu_load(vcpu);
 
 	kvm_sigset_activate(vcpu);
 
@@ -811,7 +806,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	kvm_sigset_deactivate(vcpu);
 
-out:
 	vcpu_put(vcpu);
 	return ret;
 }
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 743ca5cb05ef..3e8209a07585 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -302,17 +302,6 @@ int vgic_init(struct kvm *kvm)
 
 	dist->initialized = true;
 
-	/*
-	 * If we're initializing GICv2 on-demand when first running the VCPU
-	 * then we need to load the VGIC state onto the CPU.  We can detect
-	 * this easily by checking if we are in between vcpu_load and vcpu_put
-	 * when we just initialized the VGIC.
-	 */
-	preempt_disable();
-	vcpu = kvm_arm_get_running_vcpu();
-	if (vcpu)
-		kvm_vgic_load(vcpu);
-	preempt_enable();
 out:
 	return ret;
 }
-- 
2.14.2
