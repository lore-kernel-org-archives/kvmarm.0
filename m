From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 2/2] arm64: add pabt injection test
Date: Fri, 22 Jul 2016 10:43:23 -0400
Message-ID: <1469198603-27537-3-git-send-email-drjones@redhat.com>
References: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/Makefile.arm64 |  2 +-
 arm/emul-abort.c   | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  | 25 ++++++++++++++
 3 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 arm/emul-abort.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 0b0761c729c7..6a1a997bc26b 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -12,7 +12,7 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 
 # arm64 specific tests
-tests =
+tests = $(TEST_DIR)/emul-abort.flat
 
 include $(TEST_DIR)/Makefile.common
 
diff --git a/arm/emul-abort.c b/arm/emul-abort.c
new file mode 100644
index 000000000000..cc2be586a422
--- /dev/null
+++ b/arm/emul-abort.c
@@ -0,0 +1,95 @@
+/*
+ * Test emulation of guest aborts
+ *
+ * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+#include <asm/setup.h>
+
+#define USAGE "usage: emul-abort <subtest>\n"	\
+	"subtests:\n"				\
+	"   pabtinj-usr32-mem\n"		\
+	"   pabtinj-usr64-mem\n"		\
+	"   pabtinj-usr32-io\n"			\
+	"   pabtinj-usr64-io"
+
+#define UNMAPPED_MEM		(PHYS_END + 64*1024)
+#define UNMAPPED_IO		0xf010000
+
+typedef void (*func_t)(void *arg);
+
+static unsigned long do_pabt, mode, far;
+static bool pass;
+
+static void finish_pabt(void)
+{
+	report("bad_addr=0x%08lx far=0x%08lx", pass, do_pabt, far);
+	exit(report_summary());
+}
+
+static void handle_pabt(struct pt_regs *regs, unsigned int esr)
+{
+	bool far_valid;
+
+	if (esr >> ESR_EL1_EC_SHIFT != ESR_EL1_EC_IABT_EL0)
+		return;
+
+	far_valid = get_far(esr, &far);
+
+	pass = far_valid && far == do_pabt;
+	pass = pass && regs->pc == do_pabt;
+	pass = pass && (regs->pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) == mode;
+
+	regs->pstate &= ~PSR_MODE32_BIT;
+	regs->pc = (unsigned long)finish_pabt;
+}
+
+static void pabtinj_test(bool is_64)
+{
+	unsigned long sp = (unsigned long)thread_stack_alloc();
+
+	if (is_64) {
+		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_IABT_EL0, handle_pabt);
+		start_usr((func_t)do_pabt, NULL, sp);
+	} else {
+		mode = PSR_MODE32_BIT;
+		install_exception_handler(EL0_SYNC_32, ESR_EL1_EC_IABT_EL0, handle_pabt);
+		start_usr32((func_t)do_pabt, NULL, sp);
+	}
+}
+
+void main(int ac, char **av)
+{
+	if (ac < 2)
+		report_abort(USAGE);
+
+	if (strncmp(av[1], "pabtinj-usr", 11) == 0) {
+
+		char *testname = av[1] + 11;
+		bool is_64 = false;
+
+		if (strncmp(testname, "32", 2) == 0)
+			is_64 = false;
+		else if (strncmp(testname, "64", 2) == 0)
+			is_64 = true;
+		else
+			report_abort(USAGE);
+
+		if (strcmp(testname + 2, "-mem") == 0)
+			do_pabt = UNMAPPED_MEM;
+		else if (strcmp(testname + 2, "-io") == 0)
+			do_pabt = UNMAPPED_IO;
+		else
+			report_abort(USAGE);
+
+		report_prefix_push(av[1]);
+		pabtinj_test(is_64);
+
+	} else {
+		report_abort(USAGE);
+	}
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index ffd12e5794aa..61c437f169c8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -51,3 +51,28 @@ file = selftest.flat
 smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
+
+# Emulation tests
+[emul-pabt-injection-usr32-mem]
+file = emul-abort.flat
+extra_params = -append 'pabtinj-usr32-mem'
+arch = arm64
+groups = emulation mode32
+
+[emul-pabt-injection-usr64-mem]
+file = emul-abort.flat
+extra_params = -append 'pabtinj-usr64-mem'
+arch = arm64
+groups = emulation mode64
+
+[emul-pabt-injection-usr32-io]
+file = emul-abort.flat
+extra_params = -append 'pabtinj-usr32-io'
+arch = arm64
+groups = emulation mode32
+
+[emul-pabt-injection-usr64-io]
+file = emul-abort.flat
+extra_params = -append 'pabtinj-usr64-io'
+arch = arm64
+groups = emulation mode64
-- 
1.8.3.1

