Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A874C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 16:58:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3124B1CF;
	Fri, 10 Dec 2021 11:58:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nx58Yd5HlhHw; Fri, 10 Dec 2021 11:58:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1C24B1F1;
	Fri, 10 Dec 2021 11:58:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B92984B174
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Ngg0L+Io+2s for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 11:58:10 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88AA64B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:10 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 x3-20020a17090a1f8300b001a285b9f2cbso5997531pja.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 08:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LZscy7U5ALfD1frMqggail4BJIPnE2PJTdnWpLXa2lE=;
 b=CNkTVZU3LmW/KWRri1WJ75uAagDZAHpc8l3vgZWAb/hV2Rq5RPv06ZFdGb62Arr1/n
 4NaEfwOq/zNDBOkqQEpXAg8rm7QMFLXsDJuHefdcWA59BRjJFR53btYm2FlsVXlIv6Qc
 Q/1vOy0IT9lke/lvbpyPq7Nu9sb+v/bXqlDT5K24PS/usYboNyr+urLM5OFCRZT8WgzW
 d5z2D3pCNVQ8IsRC9Hv0Bte0k1mokiHlLsJ+AJdHosbFdr06xQX4E6WaShlqWJjiab0p
 Z7ZssV5VHyY1boAT9f78kErgcqxs0bbpO6gAh+XucdBqVPP2fmi9CROmMkP2yQo5Nnnh
 x8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LZscy7U5ALfD1frMqggail4BJIPnE2PJTdnWpLXa2lE=;
 b=hFcK6JFWUAIYaWxs/3ykzC/w9GQ7u2TZUTJ+RFmoMX9YUkugfKsyNEQP9J8yEdYKEw
 bwZcgq4+EZmckafQ5yVTAEh9SGZtClGh5c0USD5/sW/dc4AB0ecvlIinWS/cAPp4PpS3
 ZsMraPp7YLTC3DVD/R2/0nNHoilTtUfTphadYN4yp0wV/No/iV3133CpC076LkwTMqFy
 NjO9HJzn1PxzHv59BevdoiaGGZgQOC8up0ZXsMFGYdPMTSsug4ibo2H9TFZ1LZfuphkr
 pPIdbuQBxSFP1HUIzlZHGmqhej0oxJtwrCKJFrR81HnotZcqjZ7haSbt48tj8zOESqk4
 9c7g==
X-Gm-Message-State: AOAM531ZHYTXCj20tNNkBIvPIkjm+5QsYPJrarcFtwZU6nhZ/tAREQoP
 jGAmxrTqovHUrTiBsQWk7yyjZvcNquZJrA==
X-Google-Smtp-Source: ABdhPJzxiCvCCA3XBnLd+t5as/ENSdXbNnNht3YNFEzu+8LRgj11KF9OaX8kOm290lw6r7aP3p0aUZAQ+tEXpQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8f97:b0:143:88c2:e2d5 with SMTP
 id z23-20020a1709028f9700b0014388c2e2d5mr77191442plo.70.1639155489691; Fri,
 10 Dec 2021 08:58:09 -0800 (PST)
Date: Fri, 10 Dec 2021 08:58:02 -0800
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Message-Id: <20211210165804.1623253-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211210165804.1623253-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 1/3] arm64: debug: add a migration test for
 breakpoint state
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>
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

Test the migration of breakpoint state. Program as many breakpoitns as
possible, migrate, and check that we get the corresponding exceptions.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/Makefile.arm64 |   1 +
 arm/debug.c        | 209 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  13 +++
 3 files changed, 223 insertions(+)
 create mode 100644 arm/debug.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index e8a38d7..6feac76 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -31,6 +31,7 @@ OBJDIRS += lib/arm64
 tests = $(TEST_DIR)/timer.flat
 tests += $(TEST_DIR)/micro-bench.flat
 tests += $(TEST_DIR)/cache.flat
+tests += $(TEST_DIR)/debug.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/debug.c b/arm/debug.c
new file mode 100644
index 0000000..fedf4ab
--- /dev/null
+++ b/arm/debug.c
@@ -0,0 +1,209 @@
+#include <libcflat.h>
+#include <errata.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/delay.h>
+#include <asm/smp.h>
+#include <asm/barrier.h>
+#include <asm/io.h>
+
+#define MDSCR_KDE		(1 << 13)
+#define MDSCR_MDE		(1 << 15)
+
+#define DBGBCR_LEN8		(0xff << 5)
+#define DBGBCR_EXEC		(0x0 << 3)
+#define DBGBCR_EL1		(0x1 << 1)
+#define DBGBCR_E		(0x1 << 0)
+
+#define SPSR_D			(1 << 9)
+
+#define ESR_EC_HW_BP_CURRENT    0x31
+
+#define ID_AA64DFR0_BRPS_SHIFT	12
+#define ID_AA64DFR0_BRPS_MASK	0xf
+
+static volatile uint64_t hw_bp_idx, hw_bp_addr[16];
+
+static void hw_bp_handler(struct pt_regs *regs, unsigned int esr)
+{
+	hw_bp_addr[hw_bp_idx++] = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static int get_num_hw_bp(void)
+{
+	uint64_t reg = read_sysreg(id_aa64dfr0_el1);
+	/* Number of breakpoints, minus 1 */
+	uint8_t brps = (reg >> ID_AA64DFR0_BRPS_SHIFT) & ID_AA64DFR0_BRPS_MASK;
+
+	return brps + 1;
+}
+
+static void write_dbgbcr(int n, uint32_t bcr)
+{
+	switch (n) {
+	case 0:
+		write_sysreg(bcr, dbgbcr0_el1); break;
+	case 1:
+		write_sysreg(bcr, dbgbcr1_el1); break;
+	case 2:
+		write_sysreg(bcr, dbgbcr2_el1); break;
+	case 3:
+		write_sysreg(bcr, dbgbcr3_el1); break;
+	case 4:
+		write_sysreg(bcr, dbgbcr4_el1); break;
+	case 5:
+		write_sysreg(bcr, dbgbcr5_el1); break;
+	case 6:
+		write_sysreg(bcr, dbgbcr6_el1); break;
+	case 7:
+		write_sysreg(bcr, dbgbcr7_el1); break;
+	case 8:
+		write_sysreg(bcr, dbgbcr8_el1); break;
+	case 9:
+		write_sysreg(bcr, dbgbcr9_el1); break;
+	case 10:
+		write_sysreg(bcr, dbgbcr10_el1); break;
+	case 11:
+		write_sysreg(bcr, dbgbcr11_el1); break;
+	case 12:
+		write_sysreg(bcr, dbgbcr12_el1); break;
+	case 13:
+		write_sysreg(bcr, dbgbcr13_el1); break;
+	case 14:
+		write_sysreg(bcr, dbgbcr14_el1); break;
+	case 15:
+		write_sysreg(bcr, dbgbcr15_el1); break;
+	default:
+		report_abort("Invalid bcr");
+	}
+}
+
+static void write_dbgbvr(int n, uint64_t bvr)
+{
+	switch (n) {
+	case 0:
+		write_sysreg(bvr, dbgbvr0_el1); break;
+	case 1:
+		write_sysreg(bvr, dbgbvr1_el1); break;
+	case 2:
+		write_sysreg(bvr, dbgbvr2_el1); break;
+	case 3:
+		write_sysreg(bvr, dbgbvr3_el1); break;
+	case 4:
+		write_sysreg(bvr, dbgbvr4_el1); break;
+	case 5:
+		write_sysreg(bvr, dbgbvr5_el1); break;
+	case 6:
+		write_sysreg(bvr, dbgbvr6_el1); break;
+	case 7:
+		write_sysreg(bvr, dbgbvr7_el1); break;
+	case 8:
+		write_sysreg(bvr, dbgbvr8_el1); break;
+	case 9:
+		write_sysreg(bvr, dbgbvr9_el1); break;
+	case 10:
+		write_sysreg(bvr, dbgbvr10_el1); break;
+	case 11:
+		write_sysreg(bvr, dbgbvr11_el1); break;
+	case 12:
+		write_sysreg(bvr, dbgbvr12_el1); break;
+	case 13:
+		write_sysreg(bvr, dbgbvr13_el1); break;
+	case 14:
+		write_sysreg(bvr, dbgbvr14_el1); break;
+	case 15:
+		write_sysreg(bvr, dbgbvr15_el1); break;
+	default:
+		report_abort("invalid bvr");
+	}
+}
+
+static void reset_debug_state(void)
+{
+	int i, num_bp = get_num_hw_bp();
+
+	asm volatile("msr daifset, #8");
+
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
+	isb();
+
+	write_sysreg(0, mdscr_el1);
+	for (i = 0; i < num_bp; i++) {
+		write_dbgbvr(i, 0);
+		write_dbgbcr(i, 0);
+	}
+	isb();
+}
+
+static void do_migrate(void)
+{
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+}
+
+static void test_hw_bp(bool migrate)
+{
+	extern unsigned char hw_bp0;
+	uint32_t bcr;
+	uint32_t mdscr;
+	uint64_t addr;
+	int num_bp = get_num_hw_bp();
+	int i;
+
+	install_exception_handler(EL1H_SYNC, ESR_EC_HW_BP_CURRENT, hw_bp_handler);
+
+	reset_debug_state();
+
+	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
+	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4) {
+		write_dbgbcr(i, bcr);
+		write_dbgbvr(i, addr);
+	}
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+
+	if (migrate) {
+		do_migrate();
+		report(num_bp == get_num_hw_bp(), "brps match after migrate");
+	}
+
+	hw_bp_idx = 0;
+
+	/* Trap on up to 16 debug exception unmask instructions. */
+	asm volatile("hw_bp0:\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n");
+
+	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4)
+		report(hw_bp_addr[i] == addr, "hw breakpoint: %d", i);
+}
+
+int main(int argc, char **argv)
+{
+	if (argc < 2)
+		report_abort("no test specified");
+
+	if (strcmp(argv[1], "bp") == 0) {
+		report_prefix_push(argv[1]);
+		test_hw_bp(false);
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "bp-migration") == 0) {
+		report_prefix_push(argv[1]);
+		test_hw_bp(true);
+		report_prefix_pop();
+	} else {
+		report_abort("Unknown subtest '%s'", argv[1]);
+	}
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 945c2d0..896ff87 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -241,3 +241,16 @@ arch = arm64
 file = cache.flat
 arch = arm64
 groups = cache
+
+# Debug tests
+[debug-bp]
+file = debug.flat
+arch = arm64
+extra_params = -append 'bp'
+groups = debug
+
+[debug-bp-migration]
+file = debug.flat
+arch = arm64
+extra_params = -append 'bp-migration'
+groups = debug migration
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
