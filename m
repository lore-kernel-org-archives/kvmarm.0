From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 1/3] KVM: Introduce KVM_EXIT_IRQ
Date: Tue, 01 Dec 2015 13:19:43 +0300
Message-ID: <6ab9e57766d8fb3092bb57ed0214cd8c4a3d7bb2.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682854998C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zPiJ-xEwgM7t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CFAB49954
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO00LSJCP3H350@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 10:19:51 +0000 (GMT)
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This exit code means that this vCPU wants to inject an interrupt using
userspace-emulated controller.

IRQs are signalled by adding pending interrupt descriptors to vcpu
structure. For simplicity, we currently reserve only one pointer for a
single interrupt, which will be used by ARM virtual timer code. This can
be extended in the future if necessary.

The interface is designed to be as much arch-agnostic as possible.
Therefore, it has IRQ number and level as parameters (encoded in
struct kvm_irq_level).

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c       | 6 ++++++
 include/linux/kvm_host.h | 7 +++++++
 include/uapi/linux/kvm.h | 3 +++
 3 files changed, 16 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 66f90c1..6392a5b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -585,6 +585,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
+		} else if (vcpu->irq) {
+			ret = 0;
+			run->exit_reason = KVM_EXIT_IRQ;
+			run->irq.irq = vcpu->irq->irq;
+			run->irq.level = vcpu->irq->level;
+			vcpu->irq = NULL;
 		}
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c923350..93f59c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -281,6 +281,13 @@ struct kvm_vcpu {
 	} spin_loop;
 #endif
 	bool preempted;
+
+	/*
+	 * IRQ pending to the userspace on this CPU.
+	 * Currently we support only one slot, used only by ARM architecture.
+	 */
+	const struct kvm_irq_level *irq;
+
 	struct kvm_vcpu_arch arch;
 };
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 03f3618..a717a9b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -184,6 +184,7 @@ struct kvm_s390_skeys {
 #define KVM_EXIT_SYSTEM_EVENT     24
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
+#define KVM_EXIT_IRQ              27
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -338,6 +339,8 @@ struct kvm_run {
 		struct {
 			__u8 vector;
 		} eoi;
+		/* KVM_EXIT_IRQ */
+		struct kvm_irq_level irq;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.4.4
