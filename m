From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 03/14] KVM: arm/arm64: Introduce
 kvm_arch_vcpu_run_pid_change
Date: Fri,  4 May 2018 17:05:24 +0100
Message-ID: <1525449935-31424-4-git-send-email-Dave.Martin@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

KVM/ARM differs from other architectures in having to maintain an
additional virtual address space from that of the host and the
guest, because we split the execution of KVM across both EL1 and
EL2.

This results in a need to explicitly map data structures into EL2
(hyp) which are accessed from the hyp code.  As we are about to be
more clever with our FPSIMD handling on arm64, which stores data in
the task struct and uses thread_info flags, we will have to map
parts of the currently executing task struct into the EL2 virtual
address space.

However, we don't want to do this on every KVM_RUN, because it is a
fairly expensive operation to walk the page tables, and the common
execution mode is to map a single thread to a VCPU.  By introducing
a hook that architectures can select with
HAVE_KVM_VCPU_RUN_PID_CHANGE, we do not introduce overhead for
other architectures, but have a simple way to only map the data we
need when required for arm64.

This patch introduces the framework only, and wires it up in the
arm/arm64 KVM common code.

No functional change.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFCv4:

Back out the arm64 implementation of the new hook, which is
replaced by a subsequent patch (and not useful before that patch).

---
 include/linux/kvm_host.h | 9 +++++++++
 virt/kvm/Kconfig         | 3 +++
 virt/kvm/kvm_main.c      | 7 ++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c7b2e92..c32e240 100644
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
