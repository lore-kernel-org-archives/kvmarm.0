From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 02/40] KVM: arm/arm64: Move vcpu_load call after
 kvm_vcpu_first_run_init
Date: Thu, 15 Feb 2018 22:02:54 +0100
Message-ID: <20180215210332.8648-3-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Moving the call to vcpu_load() in kvm_arch_vcpu_ioctl_run() to after
we've called kvm_vcpu_first_run_init() simplifies some of the vgic and
there is also no need to do vcpu_load() for things such as handling the
immediate_exit flag.

Reviewed-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c     |  4 ----
 virt/kvm/arm/arm.c            | 22 ++++++++--------------
 virt/kvm/arm/vgic/vgic-init.c | 11 -----------
 3 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 70f4c30918eb..b744e6935a3f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -852,11 +852,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
