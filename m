Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF84C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21B73619E8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 21B73619E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8E444B1C8;
	Mon,  8 Nov 2021 21:39:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y9pIawf4rg1m; Mon,  8 Nov 2021 21:39:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878084B1E4;
	Mon,  8 Nov 2021 21:39:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 102FC4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OTIG1ZZ+4CIg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:24 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 542834B1ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:23 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 w133-20020a62dd8b000000b0049fd6d7b5caso2889201pff.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IFKj1RFpwXrhz0wYJvIT5CfUbp9nQu7H3z0fbBWNC6U=;
 b=sQpZotyapzi1P1RAEKkD/WirTgWCKCuS05w7aE+12Yly8SVrI8KCNK3kYmVM9nPUa6
 NdW0YXtG2zQ+iEA0sneSNN245ySwYUPGe8TCdlPreg8RGRBs8vNusrjouzxPZswGXjNh
 B/CPVS68j0XLy8fzQkFYyMuR//s2mzzuE92pLEud37rSCNSm49NpB2rVP+SnBDD9kMod
 oSufjWpsIKDB3PLpzIuOermS5emUc8FA/u4zuTpt+xHE/Nfu4T5mGt7/uvgpKJ6WrVuC
 hgj3ZxX6sIE1oeJCRhDMAB8DFeEiCZ/XRLAJYRRU0tPoOwP3BuyM7IDZISKmNN/Sh751
 1UJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IFKj1RFpwXrhz0wYJvIT5CfUbp9nQu7H3z0fbBWNC6U=;
 b=NL+ikhpKbCQH3MHJl5iJNM57n+JP8FHB6P4SbuQTvsEspjPRHD7LBe5W5yZ22LER3C
 MSvCefO8kDUiKhVj+3rZguBTHvMTY0ad/WvoDdZxfonI6eT3W6bFMdsC0LckkyQ62aJm
 m3Fvmfbbd6cIWnM/dOHK2qNHQbR+QIR0grKb7ePPsLUNFuaHK4eAtB0i/O1aZRA7KXWK
 arrC3B45zj9mh2TzFImTAfY1/Py3vSlw5lzumc4ZgQfdXwhHOihMYzyHL24+4o6xI3b7
 BMuFuAVfbLNDJsxuPUBh/YqPCJ1Qp13C14prwHok+m51bgZ+Ne6Ot/+oaE/MG4cEVdzD
 BNJg==
X-Gm-Message-State: AOAM532dGd+Ywa69DhqHMbraXb4FXTOdRzxZZ/bmujxSgKL3chCiujT6
 3WsAjBxrkmFJxU6BzunbuLJnVhACkTFjmA==
X-Google-Smtp-Source: ABdhPJxoX3l9V9y/4/BZ2HTvcdnviEgNfgz4hnyiwqcWSrazR8qgO9XxTQjpsnTyOj293mSrFpcRKeBy6XYVCw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:2306:b0:142:123a:24ec with SMTP
 id d6-20020a170903230600b00142123a24ecmr3958836plh.21.1636425562596; Mon, 08
 Nov 2021 18:39:22 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:55 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 06/17] KVM: selftests: aarch64: add vgic_irq to test userspace
 IRQ injection
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Add a new KVM selftest, vgic_irq, for testing userspace IRQ injection.  This
particular test injects an SPI using KVM_IRQ_LINE on GICv3 and verifies
that the IRQ is handled in the guest. The next commits will add more
types of IRQs and different modes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 244 ++++++++++++++++++
 3 files changed, 246 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_irq.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d4a830139683..7e59c94f8502 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -4,6 +4,7 @@
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
 /aarch64/vgic_init
+/aarch64/vgic_irq
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c23e89dea0b6..b90e1c9f7c8d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -93,6 +93,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
new file mode 100644
index 000000000000..e13e87427038
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vgic_irq.c - Test userspace injection of IRQs
+ *
+ * This test validates the injection of IRQs from userspace using various
+ * methods (e.g., KVM_IRQ_LINE) and modes (e.g., EOI). The guest "asks" the
+ * host to inject a specific intid via a GUEST_SYNC call, and then checks that
+ * it received it.
+ */
+
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+#include <linux/sizes.h>
+
+#include "processor.h"
+#include "test_util.h"
+#include "kvm_util.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "vgic.h"
+
+#define GICD_BASE_GPA		0x08000000ULL
+#define GICR_BASE_GPA		0x080A0000ULL
+#define VCPU_ID			0
+
+/*
+ * KVM implements 32 priority levels:
+ * 0x00 (highest priority) - 0xF8 (lowest priority), in steps of 8
+ *
+ * Note that these macros will still be correct in the case that KVM implements
+ * more priority levels. Also note that 32 is the minimum for GICv3 and GICv2.
+ */
+#define KVM_NUM_PRIOS		32
+#define KVM_PRIO_SHIFT		3 /* steps of 8 = 1 << 3 */
+#define LOWEST_PRIO		(KVM_NUM_PRIOS - 1)
+#define CPU_PRIO_MASK		(LOWEST_PRIO << KVM_PRIO_SHIFT)	/* 0xf8 */
+#define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
+#define IRQ_DEFAULT_PRIO_REG	(IRQ_DEFAULT_PRIO << KVM_PRIO_SHIFT) /* 0xf0 */
+
+static void *dist = (void *)GICD_BASE_GPA;
+static void *redist = (void *)GICR_BASE_GPA;
+
+/*
+ * The kvm_inject_* utilities are used by the guest to ask the host to inject
+ * interrupts (e.g., using the KVM_IRQ_LINE ioctl).
+ */
+
+typedef enum {
+	KVM_INJECT_EDGE_IRQ_LINE = 1,
+} kvm_inject_cmd;
+
+struct kvm_inject_args {
+	kvm_inject_cmd cmd;
+	uint32_t intid;
+};
+
+/* Used on the guest side to perform the hypercall. */
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid);
+
+/* Used on the host side to get the hypercall info. */
+static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
+		struct kvm_inject_args *args);
+
+/* Shared between the guest main thread and the IRQ handlers. */
+volatile uint64_t irq_handled;
+volatile uint32_t irqnr_received[MAX_SPI + 1];
+
+static void reset_stats(void)
+{
+	int i;
+
+	irq_handled = 0;
+	for (i = 0; i <= MAX_SPI; i++)
+		irqnr_received[i] = 0;
+}
+
+static uint64_t gic_read_ap1r0(void)
+{
+	uint64_t reg = read_sysreg_s(SYS_ICV_AP1R0_EL1);
+
+	dsb(sy);
+	return reg;
+}
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	uint32_t intid = gic_get_and_ack_irq();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(gic_irq_get_active(intid));
+
+	GUEST_ASSERT(!gic_irq_get_pending(intid));
+
+	GUEST_ASSERT(intid < MAX_SPI);
+	irqnr_received[intid] += 1;
+	irq_handled += 1;
+
+	gic_set_eoi(intid);
+	GUEST_ASSERT_EQ(gic_read_ap1r0(), 0);
+
+	GUEST_ASSERT(!gic_irq_get_active(intid));
+	GUEST_ASSERT(!gic_irq_get_pending(intid));
+}
+
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid)
+{
+	struct kvm_inject_args args = {
+		.cmd = cmd,
+		.intid = intid,
+	};
+	GUEST_SYNC(&args);
+}
+
+#define GUEST_ASSERT_IAR_EMPTY()						\
+do { 										\
+	uint32_t _intid;							\
+	_intid = gic_get_and_ack_irq();						\
+	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
+} while (0)
+
+static void test_kvm_irq_line(uint32_t intid)
+{
+	reset_stats();
+
+	asm volatile("msr daifset, #2" : : : "memory");
+	kvm_inject_call(KVM_INJECT_EDGE_IRQ_LINE, intid);
+
+	while (irq_handled < 1) {
+		asm volatile("wfi\n"
+			     "msr daifclr, #2\n"
+			     /* handle IRQ */
+			     "msr daifset, #2\n"
+			     : : : "memory");
+	}
+	asm volatile("msr daifclr, #2" : : : "memory");
+
+	GUEST_ASSERT_EQ(irq_handled, 1);
+	GUEST_ASSERT_EQ(irqnr_received[intid], 1);
+	GUEST_ASSERT_IAR_EMPTY();
+}
+
+static void guest_code(void)
+{
+	uint32_t i;
+	uint32_t nr_irqs = 64; /* absolute minimum number of IRQs supported. */
+
+	gic_init(GIC_V3, 1, dist, redist);
+
+	for (i = 0; i < nr_irqs; i++) {
+		gic_irq_enable(i);
+		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
+	}
+
+	gic_set_priority_mask(CPU_PRIO_MASK);
+
+	local_irq_enable();
+
+	test_kvm_irq_line(MIN_SPI);
+
+	GUEST_DONE();
+}
+
+static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
+		struct kvm_inject_args *inject_args)
+{
+	kvm_inject_cmd cmd = inject_args->cmd;
+	uint32_t intid = inject_args->intid;
+
+	switch (cmd) {
+	case KVM_INJECT_EDGE_IRQ_LINE:
+		kvm_arm_irq_line(vm, intid, 1);
+		kvm_arm_irq_line(vm, intid, 0);
+		break;
+	default:
+		break;
+	}
+}
+
+static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
+		struct kvm_inject_args *args)
+{
+	struct kvm_inject_args *kvm_args_hva;
+	vm_vaddr_t kvm_args_gva;
+
+	kvm_args_gva = uc->args[1];
+	kvm_args_hva = (struct kvm_inject_args *)addr_gva2hva(vm, kvm_args_gva);
+	memcpy(args, kvm_args_hva, sizeof(struct kvm_inject_args));
+}
+
+
+static void test_vgic(void)
+{
+	struct ucall uc;
+	int gic_fd;
+	struct kvm_vm *vm;
+	struct kvm_inject_args inject_args;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	gic_fd = vgic_v3_setup(vm, 1, GICD_BASE_GPA, GICR_BASE_GPA);
+
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
+			guest_irq_handler);
+
+	while (1) {
+		vcpu_run(vm, VCPU_ID);
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			kvm_inject_get_call(vm, &uc, &inject_args);
+			run_guest_cmd(vm, gic_fd, &inject_args);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
+					(const char *)uc.args[0],
+					__FILE__, uc.args[1], uc.args[2], uc.args[3]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	test_vgic();
+
+	return 0;
+}
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
