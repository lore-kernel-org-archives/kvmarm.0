Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D33C4321E
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:57:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC6649F38;
	Fri, 11 Mar 2022 12:57:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TOe+dLycj41C; Fri, 11 Mar 2022 12:57:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5448049F11;
	Fri, 11 Mar 2022 12:57:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 852D949F05
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6kwQW2dOloYz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:57:47 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07AA949EEF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:57:47 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 f18-20020a926a12000000b002be48b02bc6so5988780ilc.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4Pv27JBfLZfH/CmvIWK/wVlW7nXuMPk8mN4kvQnrF8Y=;
 b=LkJFfaF+QDSe8RcIrq5JqVH3HGsEBs6ubj8L5VyPFuDtXYYvW5BAzKcm+lxvvq4MKL
 iw6Ci+dRx3gDW6Il7hzdXHUXBSOu2ZR3LpsAvK3ISNBGxKKNzwD7mB11XiEaz+Ef7jIh
 vTpUPJM1SnQPELYHqYezGl0SjuOO9A1V0ezaQ8f+PgJnQ+WwCGIW4wG5me1oNdrmXwxI
 DmBiVhMsWpXaKbTiNZMqkwamgxdJR2++mu51KA23u7F7k7p9sdvSrPnB/xpF/QzHDKy/
 d8EFpp61p/23yPk7SAe/1JkL3dRSgNU0l0v5RNMsOVmyBmEaHQstYer3GWULVNLnaz72
 +kvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4Pv27JBfLZfH/CmvIWK/wVlW7nXuMPk8mN4kvQnrF8Y=;
 b=QG1Y8rwqeu8c/H8i7IrRrT1P2Bth5IsTHdmy7TXmA0urrW6DYvdRowYfA3FvNruQG0
 FqgqgpGVk83AzCiKA3vQLe8WCxpL5/qFavWcGVzoYLnxaXX8OnDQxvxLfv2Y1O4pmnuS
 Z0FuERPBGUC61O83WhHv9g+iDvS9UGViVh1FiRnDLR+Tpy8WJbHcqkP42iUW5oZuF9oE
 X8XFm5rHoANO3OTZiECC8UdD2uxgs4dusv/A6ZzinCZE/ZXvrH+s03dKM/oEzqo5Y5n2
 W0BjN2vwTm4J3Rh0HfQu3UqEheaSMDpXKp7HsYrqVq/acwYCwvt4L88bhUOJ3FmzettV
 rUQw==
X-Gm-Message-State: AOAM530AFNZWoXjH8tg5vxL06j6BJyA5uTjqirBA0Tcdcy3OfoGVoYoF
 1YbJHCUoB9DFnIii0p/EtucMrjvDcLEq8teny0XwBDhZdbqYQdjlC99k7aUy0wJRiIbMRpM5sG+
 S7R0ynYmeznMdndNyC85NeHar26is4LdSFAJadXbOTwJilYyrkd5sWuTgsrHFZjL+ECCvJg==
X-Google-Smtp-Source: ABdhPJxMl3lNbjrYiw3dPTWd6Qtur4nKZbyrPolqLB3Wtk5CoxQO4h6cUg3DgclyKsOnvihxhaP1UAZjIDM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:d93:b0:317:ca63:2d38
 with SMTP id
 l19-20020a0566380d9300b00317ca632d38mr3186286jaj.171.1647021466505; Fri, 11
 Mar 2022 09:57:46 -0800 (PST)
Date: Fri, 11 Mar 2022 17:57:17 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-6-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 5/5] ARM: Implement PSCI SYSTEM_SUSPEND
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

KVM_CAP_ARM_SYSTEM_SUSPEND allows VMMs to trap guest attempts to use the
PSCI SYSTEM_SUSPEND hypercall. Make use of that capability in KVM tool
to implement guest suspend support.

Add some minimal SMCCC register handling (params, return values) for
AArch32 and AArch64. Perform only the required sanity check before
suspending the VM by ensuring all other vCPUs besides the caller are
powered off. Leverage KVM_MP_STATE_SUSPENDED to emulate the suspend as
an architectural WFI.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arm/aarch32/kvm-cpu.c                 | 72 ++++++++++++++++++++++++
 arm/aarch64/kvm-cpu.c                 | 66 ++++++++++++++++++++++
 arm/include/arm-common/kvm-cpu-arch.h |  5 ++
 arm/kvm-cpu.c                         | 81 +++++++++++++++++++++++++++
 arm/kvm.c                             |  9 +++
 5 files changed, 233 insertions(+)

diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
index 95fb1da..dd5f70f 100644
--- a/arm/aarch32/kvm-cpu.c
+++ b/arm/aarch32/kvm-cpu.c
@@ -130,3 +130,75 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		die("KVM_GET_ONE_REG failed (LR_svc)");
 	dprintf(debug_fd, " LR_svc:  0x%x\n", data);
 }
+
+u64 kvm_cpu__smccc_get_arg1(struct kvm_vcpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u32 data;
+
+	reg.addr = (u64)&data;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (r1)");
+
+	return data;
+}
+
+u64 kvm_cpu__smccc_get_arg2(struct kvm_vcpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u32 data;
+
+	reg.addr = (u64)&data;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (r2)");
+
+	return data;
+}
+
+void kvm_cpu__smccc_return(struct kvm_cpu *vcpu, u64 a0, u64 a1, u64 a2, u64 a3)
+{
+	struct kvm_one_reg reg;
+	u32 data;
+
+	reg.addr = (u64)&data;
+
+	data = (u32)a0;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (r0)");
+
+	data = (u32)a1;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r1);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (r1)");
+
+	data = (u32)a2;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r2);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (r2)");
+
+	data = (u32)a3;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_r3);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (r3)");
+}
+
+void kvm_cpu__psci_set_entry(struct kvm_cpu *vcpu, u64 entry_addr, u64 context_id)
+{
+	struct kvm_one_reg reg;
+	u32 data;
+
+	reg.addr = (u64)&data;
+
+	data = (u32)entry_addr;
+	reg.id = ARM_CORE_REG(usr_regs.ARM_pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (pc)");
+
+	data = (u32)context_id;
+	reg.id = ARM64_CORE_REG(usr_regs.ARM_r0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (r0)");
+}
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 9f3e858..3118c54 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -254,3 +254,69 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		die("KVM_GET_ONE_REG failed (lr)");
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
+
+u64 kvm_cpu__smccc_get_arg1(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u64 data;
+
+	reg.addr = (u64)&data;
+	reg.id = ARM64_CORE_REG(regs.regs[1]);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (x1)");
+
+	return data;
+}
+
+u64 kvm_cpu__smccc_get_arg2(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	u64 data;
+
+	reg.addr = (u64)&data;
+	reg.id = ARM64_CORE_REG(regs.regs[2]);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (x2)");
+
+	return data;
+}
+
+void kvm_cpu__smccc_return(struct kvm_cpu *vcpu, u64 a0, u64 a1, u64 a2, u64 a3)
+{
+	struct kvm_one_reg reg;
+
+	reg.addr = (u64)&a0;
+	reg.id = ARM64_CORE_REG(regs.regs[0]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (x0)");
+
+	reg.addr = (u64)&a1;
+	reg.id = ARM64_CORE_REG(regs.regs[1]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (x1)");
+
+	reg.addr = (u64)&a2;
+	reg.id = ARM64_CORE_REG(regs.regs[2]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (x2)");
+
+	reg.addr = (u64)&a3;
+	reg.id = ARM64_CORE_REG(regs.regs[3]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (x3)");
+}
+
+void kvm_cpu__psci_set_entry(struct kvm_cpu *vcpu, u64 entry_addr, u64 context_id)
+{
+	struct kvm_one_reg reg;
+
+	reg.addr = (u64)&entry_addr;
+	reg.id = ARM64_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (pc)");
+
+	reg.addr = (u64)&context_id;
+	reg.id = ARM64_CORE_REG(regs.regs[0]);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (x0)");
+}
diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 4027afe..17179c2 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -59,4 +59,9 @@ static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
 
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
 
+u64 kvm_cpu__smccc_get_arg1(struct kvm_cpu *vcpu);
+u64 kvm_cpu__smccc_get_arg2(struct kvm_cpu *vcpu);
+void kvm_cpu__smccc_return(struct kvm_cpu *vcpu, u64 a0, u64 a1, u64 a2, u64 a3);
+void kvm_cpu__psci_set_entry(struct kvm_cpu *vcpu, u64 entry_addr, u64 context_id);
+
 #endif /* ARM_COMMON__KVM_CPU_ARCH_H */
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 164e399..677f8bb 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -163,3 +163,84 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
+
+static void kvm_cpu__arm_suspend(struct kvm_cpu *vcpu)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state = KVM_MP_STATE_SUSPENDED,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state) < 0)
+		die("KVM_SET_MP_STATE failed");
+}
+
+static void kvm_cpu__wakeup(struct kvm_cpu *vcpu)
+{
+	u64 entry_addr, context_id;
+
+	entry_addr = kvm_cpu__smccc_get_arg1(vcpu);
+	context_id = kvm_cpu__smccc_get_arg2(vcpu);
+
+	/*
+	 * The resuming CPU could have been a secondary CPU at boot. Ensure the
+	 * vCPU is made runnable.
+	 */
+	vcpu->init.features[0] &= ~(1ul << KVM_ARM_VCPU_POWER_OFF);
+
+	kvm_cpu__arch_reinit(vcpu);
+	kvm_cpu__reset_vcpu(vcpu);
+	kvm_cpu__psci_set_entry(vcpu, entry_addr, context_id);
+}
+
+static void kvm_cpu__psci_system_suspend(struct kvm_cpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	bool denied = false;
+	int i;
+
+	/*
+	 * Mark the caller as paused before actually pausing the VM. This avoids
+	 * the hazard of attempting to acquire the pause_lock in the SIGKVMPAUSE
+	 * handler from the thread that already holds it.
+	 */
+	vcpu->paused = 1;
+
+	kvm__pause(kvm);
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		struct kvm_mp_state mp_state;
+
+		if (vcpu == tmp)
+			continue;
+
+		if (ioctl(tmp->vcpu_fd, KVM_GET_MP_STATE, &mp_state) < 0)
+			die("KVM_GET_MP_STATE failed");
+
+		if (mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+			denied = true;
+			break;
+		}
+	}
+
+	if (!denied)
+		kvm_cpu__arm_suspend(vcpu);
+	else
+		kvm_cpu__smccc_return(vcpu, PSCI_RET_DENIED, 0, 0, 0);
+
+	vcpu->paused = 0;
+	kvm__continue(kvm);
+}
+
+bool kvm_cpu__arch_handle_system_event(struct kvm_cpu *vcpu)
+{
+	switch (vcpu->kvm_run->system_event.type) {
+	case KVM_SYSTEM_EVENT_SUSPEND:
+		kvm_cpu__psci_system_suspend(vcpu);
+		return true;
+	case KVM_SYSTEM_EVENT_WAKEUP:
+		kvm_cpu__wakeup(vcpu);
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/arm/kvm.c b/arm/kvm.c
index 80d233f..8ae4711 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -86,6 +86,15 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SYSTEM_SUSPEND)) {
+		struct kvm_enable_cap cap = {
+			.cap = KVM_CAP_ARM_SYSTEM_SUSPEND,
+		};
+
+		if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap) < 0)
+			die("Enabling KVM_CAP_ARM_SYSTEM_SUSPEND failed");
+	}
 }
 
 #define FDT_ALIGN	SZ_2M
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
