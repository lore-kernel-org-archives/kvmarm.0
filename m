Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF4E3E5EE7
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281464; cv=none; b=pC6oc9xVA7lK7t+uXbfbsFnV5Wmp7eUZVMfG/LjrWj4ou7WkLbLZuECpXErtf+y5dRBqTkVD/fYAGn+iwn0mPP/pKwxCN9pv7uVIuesvhJ0F5fgg7c+xeLc24cpZnpIE7njbqYUgp8VbLiYoOWgboBVswtKt2sZoxkRrQLpU6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281464; c=relaxed/simple;
	bh=vAClADCgCQBCt/qYeMJkO5SXTU35Ou+fa4NCteEDdtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZURwhv6vFMeO38cAFebx8zQZXhX6yJRHl2fWLAs3LPP7n2t5RyhkjH/txB+ZIPK1trcHItIgTjgDEp+SEnUCn/Kg9TfUPKItbngv3mMXM+C4UDdUcKzmIfXJvkrTU2nxb8LijewvsX5g8IkFjkLz6lGp8mXFgBvZzpvdqtt+/SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADqaz5y3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADqaz5y3"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b8a97b11so13736475e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281459; x=1781886259; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ow6Lcgf/RFgv5jAm1y7NuVlWFYYd0/JrOjI+zfS6dAY=;
        b=ADqaz5y3HLFbQ7/xiqejyMhlRpdqc7iwzUJyZFf03IN5K4EurocqGjEQrDwLwsox+9
         jByKr+1Zre/PsBM3m1gDYcxmITKvIBxcez4MTOCJqcXtdQCPJ4S61hoQmlM1BqJhYxRL
         dItUs46Fp+wq+pj9dWCqIpcbVLuSFrMFWaVX2iCBA5aTU11Wav7FOKT/hxOxHZTfjZz6
         5I6YLWTSF7myo/punr28jZcU1oTmSZR6uyXX2Pe9EbwqZXf5OLHmCpnQAE2EidT8yAdd
         ygnyrFLte/fIqGEphG9G8qKwR5fcE9J1CVXksoY+AfnObtKNosI/y6WQc+SF0W0/rSuv
         dzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281459; x=1781886259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ow6Lcgf/RFgv5jAm1y7NuVlWFYYd0/JrOjI+zfS6dAY=;
        b=RgJCyjBpejqzU7GBiqtmmd8PgDXdje70Zas+EhCS8gWgMzWMQx4YioYwwlWh70M4zK
         jR+PSiWXVPsb2r/Uj5NBqSOAKcLP11QXJNT4oRMbO03FeKXzPAhulMocGNRNZRrBvaoX
         2p2QPTPF7vy/fIU74MuniXWvugwOw4KHLMHQUQj4yo00D2abdIPjg2TXQe0x14IRj19T
         w5swfn7RMf3WLMVYMppABfnH/OpuZoG11QsoPU4SEyiHcqEAJOtBdz3o7qmFgIHmwy/S
         9ClFOyfAvEyVvdFPD8yFVe/xncb5ZTqMmE+S0a/moK9F/BubSz2DSdS790DL+6hcsv1s
         OhJw==
X-Forwarded-Encrypted: i=1; AFNElJ/ndWgRte+C4Y3rfaX8m46ckH4k0T6u6PZXe8XN1XpOOsHL0SCVMYP7B35J+F3VwL9tkF2QnGU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLzAN8PTX511Y6GHK3iIGELF4pIXOcyee6uQDB0QamuKKvOKce
	PMP8O+epn60NJa+EUazWP7CvFeRU6IN+KhNk2QfOnpHC9dO/URApk4uR
X-Gm-Gg: Acq92OHdau5Krso5fs9IpUKVRZOyYtCvJMdvBsIXPIxnAmuMeat91IeYiUrgO2q3I5G
	kXJL0R88QFvZgT1pHaqZYaBnL2DaScyQyOn6hXM6Auo1QI7rrHjBIJtPZXwaJble81U3yPsYvX6
	f6ppFqa6xeI9pXWr454CNg94478LaQlOm542/BALIrTy+2kXWLIEirpXcZwCpT9f/LgP4Z3bxkg
	JEJHnmp8EPA4T3gAJBtm7COZyN643CsgJFqbeWSUoqoBrqzW6RxJFMNobdzQ2El4Eo5xH6BuNvU
	X+hrrvszzPHrII298JpBWlZMnUlr4d31E62ChsPv8oKnEyHYs6VmsrgaN8svDh2hzl4KESg7uZ6
	hGRfwkvElmOg+Q3wz85c7pzPgNnSO6i3eJ2l5lR+3msLy4gvDK6omIijSOrPnI/92+Q1tmy5Him
	QRTfEj5q8soVQZn8/zptAJdygmPboxmwTVuEt7jsZ3H0U3xH6b6+wQRAN6EGw4Fg==
X-Received: by 2002:a05:600c:4e48:b0:490:e60b:6860 with SMTP id 5b1f17b1804b1-4922005e235mr2153615e9.7.1781281459529;
        Fri, 12 Jun 2026 09:24:19 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm57620935e9.1.2026.06.12.09.24.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 09:24:19 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	corbet@lwn.net,
	vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com,
	Jack Thomson <jackabt@amazon.com>
Subject: [PATCH v5 5/5] KVM: selftests: Add nested pre-fault test for arm64
Date: Fri, 12 Jun 2026 17:23:53 +0100
Message-ID: <20260612162354.73378-6-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260612162354.73378-1-jackabt.amazon@gmail.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Add an arm64 nested-virt selftest for KVM_PRE_FAULT_MEMORY. The guest
enters vEL1 and exits to userspace with a nested/shadow stage-2 MMU as
the vCPU's last-run context.

Before prefaulting, userspace enables HCR_EL2.VM and points VTTBR_EL2 at
an empty nested stage-2 root. A prefault implementation that incorrectly
treats the userspace GPA as an L2 IPA will fail the ioctl; the correct
path swaps to the canonical stage-2 and succeeds.

Restore the original nested state before resuming the guest, then touch
the prefaulted range to check that vEL1 still runs correctly.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/arm64/nv_pre_fault_memory_test.c      | 200 ++++++++++++++++++
 2 files changed, 201 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4609d8f23e38..63d79245b47d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -170,6 +170,7 @@ TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
+TEST_GEN_PROGS_arm64 += arm64/nv_pre_fault_memory_test
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
diff --git a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
new file mode 100644
index 000000000000..2bbd5540599c
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * nv_pre_fault_memory_test - Test KVM_PRE_FAULT_MEMORY on a vCPU whose
+ * last-run context is nested.
+ *
+ * The guest starts at vEL2, mirrors its EL2 translation regime into the
+ * real EL1 registers, drops HCR_EL2.TGE and ERETs to vEL1, then exits to
+ * userspace from vEL1 so that the vCPU's last-run context selects a
+ * shadow stage-2 MMU. Userspace then enables an empty nested stage-2
+ * before prefaulting. Prefaulting must target the canonical stage-2,
+ * regardless of the vCPU's nested state.
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#include <asm/sysreg.h>
+#include <linux/sizes.h>
+
+#define TEST_MEM_SLOT		10
+#define NESTED_S2_ROOT_SLOT	11
+#define TEST_MEM_SIZE		SZ_2M
+#define TEST_MEM_GPA		SZ_1G
+#define NESTED_S2_ROOT_GPA	(TEST_MEM_GPA + TEST_MEM_SIZE)
+
+struct nested_s2_state {
+	u64 hcr_el2;
+	u64 vttbr_el2;
+};
+
+static void guest_el1_code(void)
+{
+	u64 offset;
+
+	GUEST_ASSERT_EQ(get_current_el(), 1);
+
+	/* Exit to userspace with the vEL1 (nested) context live. */
+	GUEST_SYNC(1);
+
+	/*
+	 * Touch the prefaulted range. vstage-2 is disabled, so the shadow
+	 * stage-2 is a 1:1 view of the canonical IPA space.
+	 */
+	for (offset = 0; offset < TEST_MEM_SIZE; offset += SZ_4K)
+		READ_ONCE(*(u64 *)(TEST_MEM_GPA + offset));
+
+	GUEST_DONE();
+}
+
+static void guest_code(void)
+{
+	u64 sp;
+
+	GUEST_ASSERT_EQ(get_current_el(), 2);
+
+	/*
+	 * Mirror the EL2 translation regime into the real EL1 registers so
+	 * that vEL1 runs on the test's stage-1 page tables. With E2H=1, the
+	 * _EL1 accessors read the EL2 registers, and the _EL12 accessors
+	 * write the real EL1 registers.
+	 */
+	write_sysreg_s(read_sysreg(sctlr_el1), SYS_SCTLR_EL12);
+	write_sysreg_s(read_sysreg(tcr_el1), SYS_TCR_EL12);
+	write_sysreg_s(read_sysreg(ttbr0_el1), SYS_TTBR0_EL12);
+	write_sysreg_s(read_sysreg(mair_el1), SYS_MAIR_EL12);
+	write_sysreg_s(read_sysreg(cpacr_el1), SYS_CPACR_EL12);
+
+	/* Run vEL1 on the same stack. */
+	asm volatile("mov %0, sp" : "=r"(sp));
+	write_sysreg(sp, sp_el1);
+
+	/*
+	 * Drop TGE so that vEL1 is a nested context rather than host EL0.
+	 * KVM backs it with a shadow stage-2 MMU even though vstage-2 is
+	 * disabled (HCR_EL2.VM=0).
+	 */
+	write_sysreg(read_sysreg(hcr_el2) & ~HCR_EL2_TGE, hcr_el2);
+	isb();
+
+	write_sysreg(PSR_MODE_EL1h | PSR_F_BIT | PSR_I_BIT | PSR_A_BIT |
+		     PSR_D_BIT, spsr_el2);
+	write_sysreg((u64)guest_el1_code, elr_el2);
+	asm volatile("eret");
+
+	GUEST_ASSERT(false);
+}
+
+static void pre_fault(struct kvm_vcpu *vcpu, u64 gpa, u64 size)
+{
+	struct kvm_pre_fault_memory range = {
+		.gpa = gpa,
+		.size = size,
+	};
+	int ret;
+
+	do {
+		ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
+	} while (ret < 0 && errno == EINTR);
+
+	TEST_ASSERT(!ret, "KVM_PRE_FAULT_MEMORY failed, ret: %d errno: %d",
+		    ret, errno);
+	TEST_ASSERT_EQ(range.size, 0);
+}
+
+static struct nested_s2_state enable_empty_nested_s2(struct kvm_vcpu *vcpu)
+{
+	struct nested_s2_state state = {
+		.hcr_el2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2)),
+		.vttbr_el2 = vcpu_get_reg(vcpu,
+					   KVM_ARM64_SYS_REG(SYS_VTTBR_EL2)),
+	};
+
+	TEST_ASSERT(!(state.hcr_el2 & HCR_EL2_TGE),
+		    "vCPU should be in nested/vEL1 context");
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
+		     NESTED_S2_ROOT_GPA);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     state.hcr_el2 | HCR_EL2_VM);
+
+	return state;
+}
+
+static void restore_nested_s2(struct kvm_vcpu *vcpu,
+			      struct nested_s2_state *state)
+{
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), state->hcr_el2);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
+		     state->vttbr_el2);
+}
+
+int main(void)
+{
+	struct nested_s2_state s2;
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	u64 npages;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
+
+	vm = vm_create(1);
+
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	npages = TEST_MEM_SIZE / vm->page_size;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, TEST_MEM_GPA,
+				    TEST_MEM_SLOT, npages, 0);
+	virt_map(vm, TEST_MEM_GPA, TEST_MEM_GPA, npages);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    NESTED_S2_ROOT_GPA, NESTED_S2_ROOT_SLOT,
+				    1, 0);
+
+	/* Run the guest until it has ERET'd from vEL2 to vEL1. */
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT_EQ(uc.args[1], 1);
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+
+	/*
+	 * The vCPU's last-run context is vEL1, backed by a shadow stage-2
+	 * MMU. Enable nested stage-2 with an empty root so that the ioctl
+	 * fails if it tries to interpret the userspace GPA as an L2 IPA.
+	 * Prefault in two halves so that the second ioctl exercises a
+	 * repeated shadow-MMU attach and canonical stage-2 swap.
+	 */
+	s2 = enable_empty_nested_s2(vcpu);
+	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE / 2);
+	pre_fault(vcpu, TEST_MEM_GPA + TEST_MEM_SIZE / 2, TEST_MEM_SIZE / 2);
+	restore_nested_s2(vcpu, &s2);
+
+	/* Resume at vEL1 and touch the prefaulted range. */
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.43.0

