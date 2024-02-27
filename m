Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253C136989
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026894; cv=none; b=RoaisBnYSgCbr90iX0PHj11ykbWP7R18Zkq42Ivc09gINOgmbkFvGZJ3PNCtuONfxfGGRVnHHM0QFI4/EqsZ/tAoxGZaq0/Zreg/zMO79AWKOS5TTprdvD7tdzpqlExon6UamyCA8DzE3cosjS9APlYBGmjQRhXwJX30JrBBb+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026894; c=relaxed/simple;
	bh=KYqMEAx3KNzTVXzKFpKmaLV77MxDeZCls6ts/nHl4P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb/ZUmKJJozyWMHjBLcvx+SVyTPERg9T06s16JZ1T69SB1pTV7jFnpvRrucvinRFxQ0stKQUGkYNE064xUKBbsBT/W/ATl9ldAqjOsRqZwXW7MkUNz3nO7eeKTrCciNEhf0sr1cdyORMN7Iz82eI8GqMpzQeWnofX0GSjJem6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ibcqrxT7; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ibcqrxT7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709026889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uVCVoiYU0b/g0luLUlHCDdl8srJQWG7/ffSYIN1vYM=;
	b=ibcqrxT7ZiH1sXCBblalTizDvSQEL5NeD+MzriAPsZ7AYvaBOQzjJZXveUQ7nYJNvIEMbS
	ksKeNNq03ymTotrI+XvEyWnEm0t0z6xsrSAtg+LewEw+ej0Xn1IUr/x08XJXqXERP0Q1iv
	Cxuys7cmuzsKBMm5an7RvXWT64YZkR8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Don't initialize idreg debugfs w/ preemption disabled
Date: Tue, 27 Feb 2024 09:41:15 +0000
Message-ID: <20240227094115.1723330-3-oliver.upton@linux.dev>
In-Reply-To: <20240227094115.1723330-1-oliver.upton@linux.dev>
References: <20240227094115.1723330-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Testing KVM with DEBUG_ATOMIC_SLEEP enabled doesn't get far before hitting the
first splat:

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1578
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 13062, name: vgic_lpi_stress
  preempt_count: 1, expected: 0
  2 locks held by vgic_lpi_stress/13062:
   #0: ffff080084553240 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0xc0/0x13f0
   #1: ffff800080485f08 (&kvm->arch.config_lock){+.+.}-{3:3}, at: kvm_arch_vcpu_ioctl+0xd60/0x1788
  CPU: 19 PID: 13062 Comm: vgic_lpi_stress Tainted: G        W  O       6.8.0-dbg-DEV #1
  Call trace:
   dump_backtrace+0xf8/0x148
   show_stack+0x20/0x38
   dump_stack_lvl+0xb4/0xf8
   dump_stack+0x18/0x40
   __might_resched+0x248/0x2a0
   __might_sleep+0x50/0x88
   down_write+0x30/0x150
   start_creating+0x90/0x1a0
   __debugfs_create_file+0x5c/0x1b0
   debugfs_create_file+0x34/0x48
   kvm_reset_sys_regs+0x120/0x1e8
   kvm_reset_vcpu+0x148/0x270
   kvm_arch_vcpu_ioctl+0xddc/0x1788
   kvm_vcpu_ioctl+0xb6c/0x13f0
   __arm64_sys_ioctl+0x98/0xd8
   invoke_syscall+0x48/0x108
   el0_svc_common+0xb4/0xf0
   do_el0_svc+0x24/0x38
   el0_svc+0x54/0x128
   el0t_64_sync_handler+0x68/0xc0
   el0t_64_sync+0x1a8/0x1b0

kvm_reset_vcpu() disables preemption as it needs to unload vCPU state
from the CPU to twiddle with it, which subsequently explodes when
taking the parent inode's rwsem while creating the idreg debugfs file.

Fix it by moving the initialization to kvm_arch_create_vm_debugfs().

Fixes: 891766581dea ("KVM: arm64: Add debugfs file for guest's ID registers")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  4 ++++
 arch/arm64/kvm/sys_regs.c         | 13 ++++++++-----
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 181fef12e8e8..6883963bbc3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1102,6 +1102,7 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
 int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 
+void kvm_sys_regs_create_debugfs(struct kvm *kvm);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0df8507f66e3..3dee5490eea9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -190,6 +190,10 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
+void kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	kvm_sys_regs_create_debugfs(kvm);
+}
 
 /**
  * kvm_arch_destroy_vm - destroy the VM data structure
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1ebc483c2b0c..8e60aa4a8dfb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3502,6 +3502,14 @@ static const struct seq_operations idregs_debug_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(idregs_debug);
 
+void kvm_sys_regs_create_debugfs(struct kvm *kvm)
+{
+	kvm->arch.idreg_debugfs_iter = ~0;
+
+	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
+			    &idregs_debug_fops);
+}
+
 static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
@@ -3521,11 +3529,6 @@ static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 		id = reg_to_encoding(idreg);
 	}
 
-	kvm->arch.idreg_debugfs_iter = ~0;
-
-	debugfs_create_file("idregs", 0444, kvm->debugfs_dentry, kvm,
-			    &idregs_debug_fops);
-
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
 }
 
-- 
2.44.0.rc1.240.g4c46232300-goog

