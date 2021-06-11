Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13862C48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF749611AE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF749611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6239249E8A;
	Thu, 10 Jun 2021 21:10:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 57355yNZuokV; Thu, 10 Jun 2021 21:10:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5614B09B;
	Thu, 10 Jun 2021 21:10:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB6A49FE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rS25wCScrqvd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:35 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37AB4AEDC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:33 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 v10-20020a1709029a0ab0290114c0e2bac6so1946743plp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MC18iDqGZ/WloaqWWMMtlYyOeDHuqPeRDIwlJz+c+dw=;
 b=Nt0qqLnUP+hM9LKAfPU7eVrBMrRIVGtyVBX2R2HSrhEfx+1PdLFckwFmvIP2govW0f
 7k8ch2UkKGoX3SOttXkvR10pKeT2Tbt08CGUfj8QFAmOQUNJft6lfklZgGeELhmDjBKR
 18CmfKJNnRFij/+pTXvc9sQQYX28cUdQJHxhFiAZIYGBmPyTpv7dRtmIAaGHbX2Sph0l
 rnL1nEJPpYePzIZY7/G25CgBTGh4ihVVEt2oq5Smd18Un8KaKmcR/T9eGwl+vWtzkTWv
 /TNjux0NgUV0/08xjz0gmRsJHUucWq7U2QzE4DqBbAdVLFNLD7+3GsdKLsxUZ9j5l6I3
 3q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MC18iDqGZ/WloaqWWMMtlYyOeDHuqPeRDIwlJz+c+dw=;
 b=ahcywKotxRpwLNaOonzCeCtaZKy6CTVmJ5inT6Rq3AUpApBdlC17aiy0kEnq6vGSJn
 HED07ebXL/L+Bn9MhMqxRFuoucYEkOnknsl/EWoWb0dqEK8r3G9B03OPLJOzEgtWkCLN
 QTqVQ98EzStkgbHQf2DIvH6fDrr4NG7Ysfp2AZLdivGhIW4EdZzfU9wUv4t05FtLJMaw
 4TErt94QK6QdAKvzWidvcfzmCYr793ElNW329EAZWLuGYPpyk3jZFAvSFmFzaJy6EVO2
 HO1wVBOWSVNRvQlK974ZLDGPvyXAajcjJV8B+9xcvK+dhMGIqGCMGBqwgB5Wyj9HrtXz
 GKuw==
X-Gm-Message-State: AOAM530NitwSsoz/c98tETJUAqrOnm7GEJCJZ5bDqk+gs3+rywEalix0
 x4QuFUC/jdCvHAB627u9r0TgpTGA5evtpQ==
X-Google-Smtp-Source: ABdhPJx6Zwz+S3+eC9uBioiNugvvEkFiKtXQaunp8ZjCXHrWVo5CvzXKLcAgsnZ+t+aoFdIdDdmGE6U39+//kw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:1c02:: with SMTP id
 s2mr1653643pjs.172.1623373832869; Thu, 10 Jun 2021 18:10:32 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:20 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 6/6] KVM: selftests: Add aarch64/debug-exceptions test
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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

Covers fundamental tests for debug exceptions. The guest installs and
handle its debug exceptions itself, without KVM_SET_GUEST_DEBUG.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 +-
 4 files changed, 268 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 524c857a049c..7e2c66155b06 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/get-reg-list-sve
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a77e6063f7e9..36e4ebcc82f0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,6 +78,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
+TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
new file mode 100644
index 000000000000..e5e6c92b60da
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define VCPU_ID 0
+
+#define MDSCR_KDE	(1 << 13)
+#define MDSCR_MDE	(1 << 15)
+#define MDSCR_SS	(1 << 0)
+
+#define DBGBCR_LEN8	(0xff << 5)
+#define DBGBCR_EXEC	(0x0 << 3)
+#define DBGBCR_EL1	(0x1 << 1)
+#define DBGBCR_E	(0x1 << 0)
+
+#define DBGWCR_LEN8	(0xff << 5)
+#define DBGWCR_RD	(0x1 << 3)
+#define DBGWCR_WR	(0x2 << 3)
+#define DBGWCR_EL1	(0x1 << 1)
+#define DBGWCR_E	(0x1 << 0)
+
+#define SPSR_D		(1 << 9)
+#define SPSR_SS		(1 << 21)
+
+extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+static volatile uint64_t sw_bp_addr, hw_bp_addr;
+static volatile uint64_t wp_addr, wp_data_addr;
+static volatile uint64_t svc_addr;
+static volatile uint64_t ss_addr[4], ss_idx;
+#define  PC(v)  ((uint64_t)&(v))
+
+static void reset_debug_state(void)
+{
+	asm volatile("msr daifset, #8");
+
+	write_sysreg(osdlr_el1, 0);
+	write_sysreg(oslar_el1, 0);
+	isb();
+
+	write_sysreg(mdscr_el1, 0);
+	/* This test only uses the first bp and wp slot. */
+	write_sysreg(dbgbvr0_el1, 0);
+	write_sysreg(dbgbcr0_el1, 0);
+	write_sysreg(dbgwcr0_el1, 0);
+	write_sysreg(dbgwvr0_el1, 0);
+	isb();
+}
+
+static void install_wp(uint64_t addr)
+{
+	uint32_t wcr;
+	uint32_t mdscr;
+
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
+	write_sysreg(dbgwcr0_el1, wcr);
+	write_sysreg(dbgwvr0_el1, addr);
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr_el1, mdscr);
+	isb();
+}
+
+static void install_hw_bp(uint64_t addr)
+{
+	uint32_t bcr;
+	uint32_t mdscr;
+
+	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
+	write_sysreg(dbgbcr0_el1, bcr);
+	write_sysreg(dbgbvr0_el1, addr);
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr_el1, mdscr);
+	isb();
+}
+
+static void install_ss(void)
+{
+	uint32_t mdscr;
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
+	write_sysreg(mdscr_el1, mdscr);
+	isb();
+}
+
+static volatile char write_data;
+
+static void guest_code(void)
+{
+	GUEST_SYNC(0);
+
+	/* Software-breakpoint */
+	asm volatile("sw_bp: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
+
+	GUEST_SYNC(1);
+
+	/* Hardware-breakpoint */
+	reset_debug_state();
+	install_hw_bp(PC(hw_bp));
+	asm volatile("hw_bp: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
+
+	GUEST_SYNC(2);
+
+	/* Hardware-breakpoint + svc */
+	reset_debug_state();
+	install_hw_bp(PC(bp_svc));
+	asm volatile("bp_svc: svc #0");
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
+	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
+
+	GUEST_SYNC(3);
+
+	/* Hardware-breakpoint + software-breakpoint */
+	reset_debug_state();
+	install_hw_bp(PC(bp_brk));
+	asm volatile("bp_brk: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
+
+	GUEST_SYNC(4);
+
+	/* Watchpoint */
+	reset_debug_state();
+	install_wp(PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
+	GUEST_SYNC(5);
+
+	/* Single-step */
+	reset_debug_state();
+	install_ss();
+	ss_idx = 0;
+	asm volatile("ss_start:\n"
+		     "mrs x0, esr_el1\n"
+		     "add x0, x0, #1\n"
+		     "msr daifset, #8\n"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], PC(ss_start));
+	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
+	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
+
+	GUEST_DONE();
+}
+
+static void guest_sw_bp_handler(struct ex_regs *regs)
+{
+	sw_bp_addr = regs->pc;
+	regs->pc += 4;
+}
+
+static void guest_hw_bp_handler(struct ex_regs *regs)
+{
+	hw_bp_addr = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static void guest_wp_handler(struct ex_regs *regs)
+{
+	wp_data_addr = read_sysreg(far_el1);
+	wp_addr = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static void guest_ss_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(ss_idx < 4, ss_idx);
+	ss_addr[ss_idx++] = regs->pc;
+	regs->pstate |= SPSR_SS;
+}
+
+static void guest_svc_handler(struct ex_regs *regs)
+{
+	svc_addr = regs->pc;
+}
+
+static int debug_version(struct kvm_vm *vm)
+{
+	uint64_t id_aa64dfr0;
+
+	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	return id_aa64dfr0 & 0xf;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int stage;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	if (debug_version(vm) < 6) {
+		print_skip("Armv8 debug architecture not supported.");
+		kvm_vm_free(vm);
+		exit(KSFT_SKIP);
+	}
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_BRK_INS, guest_sw_bp_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_WP_CURRENT, guest_wp_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_SSTEP_CURRENT, guest_ss_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_SVC64, guest_svc_handler);
+
+	for (stage = 0; stage < 7; stage++) {
+		vcpu_run(vm, VCPU_ID);
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				"Stage %d: Unexpected sync ucall, got %lx",
+				stage, (ulong)uc.args[1]);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
+				(const char *)uc.args[0],
+				__FILE__, uc.args[1], uc.args[2], uc.args[3]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b2b3e9d626cb..27dc5c2e56b9 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -14,12 +14,14 @@
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
-#define CPACR_EL1	3, 0,  1, 0, 2
-#define TCR_EL1		3, 0,  2, 0, 2
-#define MAIR_EL1	3, 0, 10, 2, 0
-#define TTBR0_EL1	3, 0,  2, 0, 0
-#define SCTLR_EL1	3, 0,  1, 0, 0
-#define VBAR_EL1	3, 0, 12, 0, 0
+#define CPACR_EL1               3, 0,  1, 0, 2
+#define TCR_EL1                 3, 0,  2, 0, 2
+#define MAIR_EL1                3, 0, 10, 2, 0
+#define TTBR0_EL1               3, 0,  2, 0, 0
+#define SCTLR_EL1               3, 0,  1, 0, 0
+#define VBAR_EL1                3, 0, 12, 0, 0
+
+#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
 
 /*
  * Default MAIR
@@ -98,6 +100,12 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_SVC64		0x15
+#define ESR_EC_HW_BP_CURRENT	0x31
+#define ESR_EC_SSTEP_CURRENT	0x33
+#define ESR_EC_WP_CURRENT	0x35
+#define ESR_EC_BRK_INS		0x3c
+
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 
@@ -119,4 +127,6 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 	val;								  \
 })
 
+#define isb()	asm volatile("isb" : : : "memory")
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
