Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E553DEFE8
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880674; cv=none; b=YoT6a0LBYke3ep1COfphpM+/AmSbTwAi3WjoTzz1sU6GJAAQoqOLp3xwXsH6xGUI9qI60B9QPC/V3D1WgIOztcmHvXatMOmwAc+83dZWyKQenSaq4V9aXT48R0VUE4sWAd1cJZz2Y5jiePnLqSfNJcR+JsyRQJyDXZVSBkf66k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880674; c=relaxed/simple;
	bh=BvzGUje05ZB+KN1UmGEoAnRfJHb/w/1zL4rddFo/53g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2yByfcl4HKnJD0Y++HAYTbxxlKiV+UulQdtpT86OcQ9Z5mNkyQdb7euvcV2LIzol72EgrVdj9Hh/bD0zuYH3cpBQkwaZ3C9chQmm7mHSnosgAvJn6XbDrDFRkI+1dw1y8sBsj1glT/TbKDr9pfzKLESCFFIXdaWFdSQe54GJqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dtAtRg0d; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dtAtRg0d"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6032B3562;
	Mon, 30 Mar 2026 07:24:26 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9AC903F915;
	Mon, 30 Mar 2026 07:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880672; bh=BvzGUje05ZB+KN1UmGEoAnRfJHb/w/1zL4rddFo/53g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtAtRg0dz8Wr6LM+lxN1iF5PNC66Tijp1kTTB8iCQwSXYzPfaRckbmzcew/fMxBd+
	 sJobSZswFheNjKI52zPrXsUIa4tPgOJ2bBVIT4pdg55Qvf9dugXKw6ddLwPy12sIll
	 PWKaz+Q/kpktra+RIAp3KWtvIkvTYpN/6yvNfrwE=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 11/17] arm64: Add skeleton implementation for PSCI
Date: Mon, 30 Mar 2026 15:23:28 +0100
Message-ID: <20260330142334.3309961-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Add an extremely barebones implementation for handling PSCI, where the
only supported call is PSCI_VERSION.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Makefile                  |  2 ++
 arm64/include/asm/smccc.h | 65 ++++++++++++++++++++++++++++++++++++
 arm64/kvm-cpu.c           | 19 ++++++++---
 arm64/kvm.c               |  3 ++
 arm64/psci.c              | 69 +++++++++++++++++++++++++++++++++++++++
 arm64/smccc.c             | 44 +++++++++++++++++++++++++
 6 files changed, 197 insertions(+), 5 deletions(-)
 create mode 100644 arm64/include/asm/smccc.h
 create mode 100644 arm64/psci.c
 create mode 100644 arm64/smccc.c

diff --git a/Makefile b/Makefile
index 60e551fd..1c0e7f55 100644
--- a/Makefile
+++ b/Makefile
@@ -181,6 +181,8 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm64/arm-cpu.o
 	OBJS		+= arm64/pvtime.o
 	OBJS		+= arm64/pmu.o
+	OBJS		+= arm64/psci.o
+	OBJS		+= arm64/smccc.o
 	ARCH_INCLUDE	:= arm64/include
 
 	ARCH_WANT_LIBFDT := y
diff --git a/arm64/include/asm/smccc.h b/arm64/include/asm/smccc.h
new file mode 100644
index 00000000..c1be21a7
--- /dev/null
+++ b/arm64/include/asm/smccc.h
@@ -0,0 +1,65 @@
+#ifndef __ARM_SMCCC_H__
+#define __ARM_SMCCC_H__
+
+#include "kvm/kvm-cpu.h"
+
+#include <linux/arm-smccc.h>
+#include <linux/types.h>
+
+static inline bool smccc_is_64bit(struct kvm_cpu *vcpu)
+{
+	return ARM_SMCCC_IS_64(vcpu->kvm_run->hypercall.nr);
+}
+
+static inline bool smccc_calling_conv_allowed(struct kvm_cpu *vcpu, u32 fn)
+{
+	return !(vcpu->kvm->cfg.arch.aarch32_guest && ARM_SMCCC_IS_64(fn));
+}
+
+static inline u64 smccc_get_arg(struct kvm_cpu *vcpu, u8 arg)
+{
+	u64 val;
+	struct kvm_one_reg reg = {
+		.id	= ARM64_CORE_REG(regs.regs[arg]),
+		.addr	= (u64)&val,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
+		die_perror("KVM_GET_ONE_REG failed");
+
+	if (!smccc_is_64bit(vcpu))
+		val = (u32)val;
+
+	return val;
+}
+
+static inline void smccc_return_result(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	unsigned long *vals = (unsigned long *)res;
+	unsigned long i;
+
+	/*
+	 * The author was lazy and chose to abuse the layout of struct
+	 * arm_smccc_res to write a loop set the retvals.
+	 */
+	for (i = 0; i < sizeof(*res) / sizeof(unsigned long); i++) {
+		u64 val = vals[i];
+		struct kvm_one_reg reg = {
+			.id	= ARM64_CORE_REG(regs.regs[i]),
+			.addr	= (u64)&val,
+		};
+
+		if (!smccc_is_64bit(vcpu))
+			val = (u32)val;
+
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
+			die_perror("KVM_SET_ONE_REG failed");
+	}
+}
+
+bool handle_hypercall(struct kvm_cpu *vcpu);
+void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res);
+
+void kvm__setup_smccc(struct kvm *kvm);
+
+#endif /* __ARM_SMCCC_H__ */
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index f8e08b5d..6cd058fa 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -1,6 +1,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/virtio.h"
+#include "asm/smccc.h"
 
 #include <asm/ptrace.h>
 #include <linux/bitops.h>
@@ -229,11 +230,6 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 	free(vcpu);
 }
 
-bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
-{
-	return false;
-}
-
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
 }
@@ -469,3 +465,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		die("KVM_GET_ONE_REG failed (lr)");
 	dprintf(debug_fd, " LR:    0x%lx\n", data);
 }
+
+bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+{
+	struct kvm_run *run = vcpu->kvm_run;
+
+	switch (run->exit_reason) {
+	case KVM_EXIT_HYPERCALL:
+		handle_hypercall(vcpu);
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 41c47b13..56e4f149 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -7,6 +7,8 @@
 #include "kvm/gic.h"
 #include "kvm/kvm-cpu.h"
 
+#include "asm/smccc.h"
+
 #include <linux/byteorder.h>
 #include <linux/cpumask.h>
 #include <linux/kernel.h>
@@ -127,6 +129,7 @@ void kvm__arch_init(struct kvm *kvm)
 		die("Failed to create virtual GIC");
 
 	kvm__arch_enable_mte(kvm);
+	kvm__setup_smccc(kvm);
 }
 
 
diff --git a/arm64/psci.c b/arm64/psci.c
new file mode 100644
index 00000000..72429b36
--- /dev/null
+++ b/arm64/psci.c
@@ -0,0 +1,69 @@
+#include "asm/smccc.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/psci.h>
+#include <linux/types.h>
+
+static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u32 arg = smccc_get_arg(vcpu, 1);
+
+	res->a0 = PSCI_RET_NOT_SUPPORTED;
+	if (!smccc_calling_conv_allowed(vcpu, arg))
+		return;
+
+	switch (arg) {
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_CPU_OFF:
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		res->a0 = PSCI_RET_SUCCESS;
+		break;
+	}
+}
+
+static void cpu_suspend(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_SUSPENDED,
+	};
+
+	/* Rely on in-kernel emulation of a 'suspended' (i.e. WFI) state. */
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+
+	res->a0 = PSCI_RET_SUCCESS;
+}
+
+static void cpu_off(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	struct kvm_mp_state mp_state = {
+		.mp_state	= KVM_MP_STATE_STOPPED,
+	};
+
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_MP_STATE, &mp_state))
+		die_perror("KVM_SET_MP_STATE failed");
+}
+
+void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	switch (vcpu->kvm_run->hypercall.nr) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+		res->a0 = PSCI_VERSION(1, 0);
+		break;
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		psci_features(vcpu, res);
+		break;
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		cpu_suspend(vcpu, res);
+		break;
+	case PSCI_0_2_FN_CPU_OFF:
+		cpu_off(vcpu, res);
+		break;
+	default:
+		res->a0 = PSCI_RET_NOT_SUPPORTED;
+	}
+}
diff --git a/arm64/smccc.c b/arm64/smccc.c
new file mode 100644
index 00000000..ef986d8c
--- /dev/null
+++ b/arm64/smccc.c
@@ -0,0 +1,44 @@
+#include "asm/smccc.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include <linux/types.h>
+
+static void handle_std_call(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u32 fn = vcpu->kvm_run->hypercall.nr;
+
+	switch (ARM_SMCCC_FUNC_NUM(fn)) {
+	/* PSCI */
+	case 0x00 ... 0x1F:
+		handle_psci(vcpu, res);
+		break;
+	}
+}
+
+bool handle_hypercall(struct kvm_cpu *vcpu)
+{
+	u32 fn = vcpu->kvm_run->hypercall.nr;
+	struct arm_smccc_res res = {
+		.a0	= SMCCC_RET_NOT_SUPPORTED,
+	};
+
+	if (!smccc_calling_conv_allowed(vcpu, fn))
+		goto out;
+
+	switch (ARM_SMCCC_OWNER_NUM(fn)) {
+	case ARM_SMCCC_OWNER_STANDARD:
+		handle_std_call(vcpu, &res);
+		break;
+	}
+
+out:
+	smccc_return_result(vcpu, &res);
+	return true;
+}
+
+void kvm__setup_smccc(struct kvm *kvm)
+{
+
+}
-- 
2.43.0

