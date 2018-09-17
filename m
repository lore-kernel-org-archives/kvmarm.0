From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 19/18] kvmtool: Allow backends to run checks on the
 KVM device fd
Date: Mon, 17 Sep 2018 11:41:41 +0100
Message-ID: <20180917104144.19188-20-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 073814A259
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SDEUfockFOOH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 06:43:16 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5CA4A210
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:15 -0400 (EDT)
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Allow architectures to perform initialisation based on the
KVM device fd ioctls, even before the VM is created.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/kvm/kvm.h | 4 ++++
 kvm.c             | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 1edacfd..dc3f0dd 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -135,6 +135,10 @@ int kvm__get_sock_by_instance(const char *name);
 int kvm__enumerate_instances(int (*callback)(const char *name, int pid));
 void kvm__remove_socket(const char *name);
 
+#ifndef kvm__arch_init_hyp
+static inline void kvm__arch_init_hyp(struct kvm *kvm) {}
+#endif
+
 void kvm__arch_set_cmdline(char *cmdline, bool video);
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size);
 void kvm__arch_delete_ram(struct kvm *kvm);
diff --git a/kvm.c b/kvm.c
index 7de825a..0894778 100644
--- a/kvm.c
+++ b/kvm.c
@@ -373,6 +373,8 @@ int kvm__init(struct kvm *kvm)
 		goto err_sys_fd;
 	}
 
+	kvm__arch_init_hyp(kvm);
+
 	kvm->vm_fd = ioctl(kvm->sys_fd, KVM_CREATE_VM, KVM_VM_TYPE);
 	if (kvm->vm_fd < 0) {
 		pr_err("KVM_CREATE_VM ioctl");
-- 
2.19.0
