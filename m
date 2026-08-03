Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B40417BC3;
	Mon,  3 Aug 2026 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764758; cv=none; b=dHtfG699cnOjuk0lZvRHtGdHnkbs733/tLOay0sMEjVe03gifN5ClHoUkIKy/GIAgm7aIFfidlCR8fFjKCN73TbSYpE59E/dXFrOmcDk9xsGkFyO2imFC9koOldsJyYCgU+TPj0TZcv5r6g5WTG4gshvHDdXwoBQWlORK3vyQPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764758; c=relaxed/simple;
	bh=cqTMhbIa83aTp8kjyG4T8WMTL8yZoAVg00R6YVLJmZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOx1qG4c6JqqKK6hkYCuNWkhIE6sJZ3NbJIspl3g7jieQ87A+q1G9GZ96ZgLpIsMiPUoNIRdKtBoie2oS8EUq2DM5QPGdb6xMZK7Ilsw578NWqXOrkUbbYzajJRabI8JfM+xMSrSY7HWG5hdeXeAzKAJpfz8fkMaD1xogVBOU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i4+tXJAj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i4+tXJAj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3713F1655;
	Mon,  3 Aug 2026 06:45:52 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDACE3F66F;
	Mon,  3 Aug 2026 06:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764756; bh=cqTMhbIa83aTp8kjyG4T8WMTL8yZoAVg00R6YVLJmZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4+tXJAjFHb55f2Gt6txuXNwITpvEw1nXFfpdXjzblsiuZtqAWxbgal+L2hB53gzV
	 rmOcxYWafOItfT6SSWD+7SO7SRIp9PJ8Bl17wTNDn6JBsp7CZ6VaEUc/w0uywWRbZc
	 8RTy91TMVBPVA9tbPCsINOc9/UXFKdR3p2Mg6B/Q=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 21/45] KVM: arm64: CCA: Handle realm enter/exit
Date: Mon,  3 Aug 2026 14:43:37 +0100
Message-ID: <20260803134403.80630-22-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Entering a realm is done using a SMC call to the RMM. On exit the
exit-codes need to be handled slightly differently to the normal KVM
path so define our own functions for realm enter/exit and hook them
in if the guest is a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Major rewrite to use KVM requests and fit in better with the existing
   KVM code.
Changes since v13:
 * The RMM is now required to provide an ESR value with the correct
   information to emulate MMIO, so we no longer need to hardcode 0s in
   rec_exit_sys_reg().
 * The PSCI changes mean that there is a potential race when turning on
   a VCPU which can cause a RMI_ERROR_REC return. Exit to user space
   with -EAGAIN in this case.
Changes since v12:
 * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
 * Add handling of the IRQ exception case where IRQs need to be briefly
   enabled before exiting guest timing.
Changes since v8:
 * Introduce kvm_rec_pre_enter() called before entering an atomic
   section to handle operations that might require memory allocation
   (specifically completing a RIPAS change introduced in a later patch).
 * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
   HPFAR_EL2_NS as a valid flag.
 * Fix exit reason when racing with PSCI shutdown to return
   KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
Changes since v7:
 * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
   been read (although that can never happen in the current code). Tidy
   up the condition to handle any future refactoring.
Changes since v6:
 * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
   vcpu to the error.
 * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
   this exit type.
 * Split code handling a RIPAS change triggered by the guest to the
   following patch.
Changes since v5:
 * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
   change on next entry rather than immediately on the exit. This allows
   the VMM to 'reject' a RIPAS change by refusing to continue
   scheduling.
Changes since v4:
 * Rename handle_rme_exit() to handle_rec_exit()
 * Move the loop to copy registers into the REC enter structure from the
   to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
   where the handler exits to user space and user space wants to modify
   the GPRS.
 * Some code rearrangement in rec_exit_ripas_change().
Changes since v2:
 * realm_set_ipa_state() now provides an output parameter for the
   top_iap that was changed. Use this to signal the VMM with the correct
   range that has been transitioned.
 * Adapt to previous patch changes.
---
 arch/arm64/include/asm/kvm_asm.h  |   2 +
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/kvm_rmi.h  |   5 +
 arch/arm64/kvm/Makefile           |   2 +-
 arch/arm64/kvm/arm.c              |  18 +++-
 arch/arm64/kvm/handle_exit.c      |  14 +++
 arch/arm64/kvm/rmi-exit.c         | 167 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/rmi.c              |  56 ++++++++++
 8 files changed, 263 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/rmi-exit.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..0629851e1114 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -21,6 +21,7 @@
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
 #define ARM_EXCEPTION_IL	  3
+#define ARM_EXCEPTION_EXIT	  4
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
@@ -28,6 +29,7 @@
 	{ARM_EXCEPTION_IRQ,		"IRQ"		},	\
 	{ARM_EXCEPTION_EL1_SERROR, 	"SERROR"	},	\
 	{ARM_EXCEPTION_TRAP, 		"TRAP"		},	\
+	{ARM_EXCEPTION_EXIT,		"EXIT"		},	\
 	{ARM_EXCEPTION_HYP_GONE,	"HYP_GONE"	}
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9b46b39ed11e..15d42d1993bb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -56,6 +56,7 @@
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
 #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
+#define KVM_REQ_RMI			KVM_ARCH_REQ(12)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 3bffd021ca26..1e5026039458 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -102,6 +102,11 @@ void kvm_destroy_realm(struct kvm *kvm);
 int kvm_realm_teardown_stage2(struct kvm *kvm);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
+int kvm_rec_enter(struct kvm_vcpu *vcpu);
+int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
+int kvm_rec_handle_request(struct kvm_vcpu *vcpu);
+bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret);
+
 static inline bool kvm_realm_is_private_address(struct realm *realm,
 						unsigned long addr)
 {
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index ed3cf30eb06e..4a2d52fdb6a2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o config.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
-	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
+	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o rmi-exit.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2959a1451232..3ad2f1d5b9e2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1206,6 +1206,13 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
 
+		if (kvm_check_request(KVM_REQ_RMI, vcpu)) {
+			int ret = kvm_rec_handle_request(vcpu);
+
+			if (ret <= 0)
+				return ret;
+		}
+
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
 
@@ -1291,9 +1298,18 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	int ret;
 
 	guest_state_enter_irqoff();
-	ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
+	if (vcpu_is_rec(vcpu))
+		ret = kvm_rec_enter(vcpu);
+	else
+		ret = kvm_call_hyp_ret(__kvm_vcpu_run, vcpu);
 	guest_state_exit_irqoff();
 
+	if (vcpu_is_rec(vcpu)) {
+		instrumentation_begin();
+		ret = kvm_rec_exit(vcpu, ret);
+		instrumentation_end();
+	}
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..6950188efc68 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -18,6 +18,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_rmi.h>
 #include <asm/debug-monitors.h>
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
@@ -37,10 +38,15 @@ static void kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u64 esr)
 
 static int handle_hvc(struct kvm_vcpu *vcpu)
 {
+	int ret;
+
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
+	if (kvm_rec_handle_hvc(vcpu, &ret))
+		return ret;
+
 	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
 	if (vcpu_has_nv(vcpu)) {
 		if (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_HCD)
@@ -447,6 +453,9 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (exception_index < 0)
+		return exception_index;
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		/*
 		 * The SError is handled by handle_exit_early(). If the guest
@@ -478,6 +487,8 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 */
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return -EINVAL;
+	case ARM_EXCEPTION_EXIT:
+		return 0;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
@@ -489,6 +500,9 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 /* For exit types that need handling before we can be preempted */
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 {
+	if (exception_index < 0 || exception_index == ARM_EXCEPTION_EXIT)
+		return;
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
 			u64 disr = kvm_vcpu_get_disr(vcpu);
diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
new file mode 100644
index 000000000000..04e6535552cb
--- /dev/null
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/kvm_host.h>
+
+#include <linux/arm-smccc-rmi.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_rmi.h>
+#include <asm/kvm_mmu.h>
+
+static int rec_exit_fatal(struct kvm_vcpu *vcpu, const char *reason,
+			  unsigned long value)
+{
+	vcpu_err(vcpu, "%s: %#lx\n", reason, value);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	kvm_vm_dead(vcpu->kvm);
+	return ARM_EXCEPTION_EXIT;
+}
+
+static void rec_exit_sync(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	u64 esr = rec->run->exit.esr;
+	u8 ec = ESR_ELx_EC(esr);
+
+	switch (ec) {
+	case ESR_ELx_EC_SYS64: {
+		int rt = ESR_ELx_SYS64_ISS_RT(esr);
+		bool is_write = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) ==
+				ESR_ELx_SYS64_ISS_DIR_WRITE;
+
+		if (is_write && rt < REC_RUN_GPRS)
+			vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);
+		else if (!is_write)
+			kvm_make_request(KVM_REQ_RMI, vcpu);
+		break;
+	}
+	}
+}
+
+static void rec_exit_hvc(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	int i;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	vcpu->arch.fault.esr_el2 = (ESR_ELx_EC_HVC64 << ESR_ELx_EC_SHIFT) |
+				     ESR_ELx_IL;
+}
+
+bool kvm_rec_handle_hvc(struct kvm_vcpu *vcpu, int *ret)
+{
+	struct realm_rec *rec;
+	struct realm *realm;
+	unsigned long base;
+	unsigned long ripas;
+	unsigned long top;
+
+	if (!vcpu_is_rec(vcpu))
+		return false;
+
+	rec = &vcpu->arch.rec;
+	if (rec->run->exit.exit_reason != RMI_EXIT_RIPAS_CHANGE)
+		return false;
+
+	realm = &vcpu->kvm->arch.realm;
+	base = rec->run->exit.ripas_base;
+	top = rec->run->exit.ripas_top;
+	ripas = rec->run->exit.ripas_value;
+
+	if (top <= base ||
+	    !kvm_realm_is_private_address(realm, base) ||
+	    !kvm_realm_is_private_address(realm, top - 1)) {
+		vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
+			 base, top, ripas);
+		/* Set RMI_REJECT bit */
+		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
+		*ret = -EINVAL;
+		return true;
+	}
+
+	/* Exit to VMM, the actual RIPAS change is done on next entry */
+	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
+				      ripas == RMI_RAM);
+	kvm_make_request(KVM_REQ_RMI, vcpu);
+
+	/*
+	 * KVM_EXIT_MEMORY_FAULT requires a return code of -EFAULT, see the
+	 * API documentation
+	 */
+	*ret = -EFAULT;
+	return true;
+}
+
+int kvm_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long status;
+
+	if (rec_run_ret < 0)
+		return rec_exit_fatal(vcpu, "REC_ENTER failed", rec_run_ret);
+
+	status = RMI_RETURN_STATUS(rec_run_ret);
+
+	/*
+	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we might
+	 * see the following status code indicating an attempt to run
+	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need to
+	 * return to user space which can deal with the system event or will try
+	 * to run the KVM VCPU again, at which point we will no longer attempt
+	 * to enter the Realm because we will have a sleep request pending on
+	 * the VCPU as a result of KVM's PSCI handling.
+	 */
+	if (status == RMI_ERROR_REALM) {
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		return ARM_EXCEPTION_EXIT;
+	}
+
+	/*
+	 * If a VCPU has been turned on, but the REC state hasn't been updated
+	 * we may experience RMI_ERROR_REC. Exit to the userspace with -EAGAIN
+	 * for a retry.
+	 */
+	if (status == RMI_ERROR_REC)
+		return -EAGAIN;
+	if (rec_run_ret)
+		return rec_exit_fatal(vcpu, "Unexpected REC_ENTER status",
+				      rec_run_ret);
+
+	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
+	vcpu->arch.fault.far_el2 = rec->run->exit.far;
+	/* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
+	vcpu->arch.fault.hpfar_el2 = 0;
+
+	/* Reset the emulation flags for the next run of the REC */
+	rec->run->enter.flags = 0;
+
+	switch (rec->run->exit.exit_reason) {
+	case RMI_EXIT_SYNC:
+		/*
+		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
+		 * see __get_fault_info()
+		 */
+		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
+		rec_exit_sync(vcpu);
+		return ARM_EXCEPTION_TRAP;
+	case RMI_EXIT_IRQ:
+	case RMI_EXIT_FIQ:
+		return ARM_EXCEPTION_IRQ;
+	case RMI_EXIT_SERROR:
+		return ARM_EXCEPTION_EL1_SERROR;
+	case RMI_EXIT_PSCI:
+		rec_exit_hvc(vcpu);
+		kvm_make_request(KVM_REQ_RMI, vcpu);
+		return ARM_EXCEPTION_TRAP;
+	case RMI_EXIT_RIPAS_CHANGE:
+		rec_exit_hvc(vcpu);
+		return ARM_EXCEPTION_TRAP;
+	}
+
+	return rec_exit_fatal(vcpu, "Unsupported Realm exit reason",
+			      rec->run->exit.exit_reason);
+}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index f6686287119d..92085b88f427 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/rmi_cmds.h>
@@ -205,6 +206,61 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
 	return realm_destroy_rtts(kvm);
 }
 
+int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	u64 esr;
+
+	switch (rec->run->exit.exit_reason) {
+	case RMI_EXIT_SYNC:
+		esr = rec->run->exit.esr;
+		if (ESR_ELx_EC(esr) == ESR_ELx_EC_SYS64 &&
+		    (esr & ESR_ELx_SYS64_ISS_DIR_MASK) ==
+				ESR_ELx_SYS64_ISS_DIR_READ) {
+			int rt = ESR_ELx_SYS64_ISS_RT(esr);
+
+			if (rt < REC_RUN_GPRS)
+				rec->run->enter.gprs[rt] =
+					vcpu_get_reg(vcpu, rt);
+		}
+		break;
+	default:
+		KVM_BUG(1, vcpu->kvm, "Unhandled realm exit_reason");
+		return -ENXIO;
+	}
+
+	return 1;
+}
+
+static void noinstr load_realm_timer_state(struct kvm_vcpu *vcpu)
+{
+	struct rec_exit *rec_exit = &vcpu->arch.rec.run->exit;
+
+	/*
+	 * The RMM reports the EL1 timer state on every REC exit. Install that
+	 * state before returning to the generic KVM run loop, which expects
+	 * the loaded vCPU's timers to be live.
+	 */
+	write_sysreg_el0(rec_exit->cntv_cval, SYS_CNTV_CVAL);
+	write_sysreg_el0(rec_exit->cntp_cval, SYS_CNTP_CVAL);
+	isb();
+
+	write_sysreg_el0(rec_exit->cntv_ctl, SYS_CNTV_CTL);
+	write_sysreg_el0(rec_exit->cntp_ctl, SYS_CNTP_CTL);
+}
+
+int noinstr kvm_rec_enter(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	int ret;
+
+	ret = rmi_rec_enter(rec->rec_phys, rec->run_phys);
+	if (!ret)
+		load_realm_timer_state(vcpu);
+
+	return ret;
+}
+
 static int __maybe_unused kvm_create_rec(struct kvm_vcpu *vcpu)
 {
 	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
-- 
2.43.0

