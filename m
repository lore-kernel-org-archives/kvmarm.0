From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 2/7] KVM: Track the pid of the VM process
Date: Tue, 16 Aug 2016 11:45:07 +0100
Message-ID: <1471344312-26685-3-git-send-email-punit.agrawal@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Punit Agrawal <punit.agrawal@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Userspace tools such as perf can be used to profile individual
processes.

Track the PID of the virtual machine process to match profiling requests
targeted at it. This can be used to take appropriate action to enable
the requested profiling operations for the VMs of interest.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9c28b4d..7c42c94 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -374,6 +374,7 @@ struct kvm_memslots {
 struct kvm {
 	spinlock_t mmu_lock;
 	struct mutex slots_lock;
+	struct pid *pid;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct srcu_struct srcu;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1950782..ab2535a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -613,6 +613,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	spin_lock_init(&kvm->mmu_lock);
 	atomic_inc(&current->mm->mm_count);
 	kvm->mm = current->mm;
+	kvm->pid = get_task_pid(current, PIDTYPE_PID);
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
@@ -712,6 +713,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	put_pid(kvm->pid);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
 	spin_lock(&kvm_lock);
-- 
2.8.1
