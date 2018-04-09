From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 2/4] KVM: arm/arm64: Introduce
 kvm_arch_vcpu_run_pid_change
Date: Mon,  9 Apr 2018 11:53:00 +0100
Message-ID: <1523271182-22130-3-git-send-email-Dave.Martin@arm.com>
References: <1523271182-22130-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B164A07E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Apr 2018 06:44:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mBSwBC-BUuuW for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Apr 2018 06:44:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3713E4A051
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Apr 2018 06:44:28 -0400 (EDT)
In-Reply-To: <1523271182-22130-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

KVM/ARM differs from other architectures in having to maintain an
additional virtual address space from that of the host and the guest,
because we split the execution of KVM across both EL1 and EL2.

This results in a need to explicitly map data structures into EL2 (hyp)
which are accessed from the hyp code.  As we are about to be more clever
with our FPSIMD handling, which stores data on the task struct and uses
thread_info flags, we have to map the currently executing task struct
into the EL2 virtual address space.

However, we don't want to do this on every KVM_RUN, because it is a
fairly expensive operation to walk the page tables, and the common
execution mode is to map a single thread to a VCPU.  By introducing a
hook that architectures can select with HAVE_KVM_VCPU_RUN_PID_CHANGE, we
do not introduce overhead for other architectures, but have a simple way
to only map the data we need when required for arm64.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Since RFCv1:

Back out setting of hyp_current, which isn't introduced to struct
vcpu_arch by this patch.  This series takes the approach of only
mapping current->thread_info instead in a later patch, which is
sufficient.
---
 arch/arm64/kvm/Kconfig   |  1 +
 include/linux/kvm_host.h |  9 +++++++++
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/arm/arm.c       | 10 ++++++++++
 virt/kvm/kvm_main.c      |  7 ++++++-
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 2257dfc..5b2c8d8 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ config KVM
 	select HAVE_KVM_IRQ_ROUTING
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
+	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6930c63..4268ace 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1276,4 +1276,13 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		unsigned long start, unsigned long end);
 
+#ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
+#else
+static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index cca7e06..72143cf 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -54,3 +54,6 @@ config HAVE_KVM_IRQ_BYPASS
 
 config HAVE_KVM_VCPU_ASYNC_IOCTL
        bool
+
+config HAVE_KVM_VCPU_RUN_PID_CHANGE
+       bool
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 5357230..d3af3f4 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -816,6 +816,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
+#ifdef CONFIG_ARM64
+int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
+{
+	struct task_struct *tsk = current;
+
+	/* Make sure the host task fpsimd state is visible to hyp: */
+	return create_hyp_mappings(tsk, tsk + 1, PAGE_HYP);
+}
+#endif
+
 static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
 {
 	int bit_index;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 65dea3f..de33a32 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2550,8 +2550,13 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		oldpid = rcu_access_pointer(vcpu->pid);
 		if (unlikely(oldpid != current->pids[PIDTYPE_PID].pid)) {
 			/* The thread running this VCPU changed. */
-			struct pid *newpid = get_task_pid(current, PIDTYPE_PID);
+			struct pid *newpid;
 
+			r = kvm_arch_vcpu_run_pid_change(vcpu);
+			if (r)
+				break;
+
+			newpid = get_task_pid(current, PIDTYPE_PID);
 			rcu_assign_pointer(vcpu->pid, newpid);
 			if (oldpid)
 				synchronize_rcu();
-- 
2.1.4
