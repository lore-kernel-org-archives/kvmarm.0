Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556461DFE8
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279051; cv=none; b=Dv13ucDDqFpTd2evv53srbQNk6x+OElzEvjAbFd1WG1C85S4KPNU645nV0bEL4j+CqKPjFnIAL3XL2AuYsOHzIuONGGoELvP35KbchOy8rGDCyf6jJRrba6FBssm2RIq2TAB85+xGLwzmuZT3j6ICyzNpsL6MTPVj0zUXq7grVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279051; c=relaxed/simple;
	bh=y9uypaxSEepR4vxAhVraBb+AvdE6M/OPivucWs6Q+zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dU7oGO5K6009mYLtYDbNe98UDFGzvoNeilQIPhDkNXM6z3/0nBYENK8KW2GSbcUR3LLzBrrh9Qw2FYYJHCeNNzF4oHE7/HLoBkGRzW50ds1buu/08oGHq7m264fL9CkBG3i4PHqXsbFnTcPSlhKL2KeLJjAqC9A2apjN+yrEOFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NzhS3NQo; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NzhS3NQo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMC0wnAmYWRXpreCMSeE0f06r4zEF4/WWKlAHaXsL/M=;
	b=NzhS3NQo0lJmA7zPwsBOug26mKmI6kRRjlqQYPjQI9pmTQDlbs0H0o3Kd5m2zOGvOfXiXW
	Z1Bl8weTdpn+eATIW2yQxdAvVkfooId05qGRgbrfzkGIx5NjBR6SP35FTkIBHFTFJEhDnt
	lls/mX0Zv6dyKsinn8FtqHpiPILJhBI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 13/24] arm/arm64: Share on_cpus
Date: Fri, 26 Jan 2024 15:23:38 +0100
Message-ID: <20240126142324.66674-39-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that the previous patches have cleaned up Arm's on_cpus
implementation we can move it to the common lib where riscv
will share it.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 arm/Makefile.common |   1 +
 lib/arm/asm/smp.h   |   8 +--
 lib/arm/smp.c       | 144 -----------------------------------------
 lib/on-cpus.c       | 154 ++++++++++++++++++++++++++++++++++++++++++++
 lib/on-cpus.h       |  14 ++++
 5 files changed, 170 insertions(+), 151 deletions(-)
 create mode 100644 lib/on-cpus.c
 create mode 100644 lib/on-cpus.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5214c8acdab3..dc92a7433350 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -43,6 +43,7 @@ cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/migrate.o
+cflatobjs += lib/on-cpus.o
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-host-generic.o
 cflatobjs += lib/pci-testdev.o
diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index f0c0f97a19f8..2e1dc27f7bd8 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -6,6 +6,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <cpumask.h>
+#include <on-cpus.h>
 #include <asm/barrier.h>
 #include <asm/thread_info.h>
 
@@ -22,14 +23,7 @@ extern struct secondary_data secondary_data;
 #define smp_wait_for_event()	wfe()
 #define smp_send_event()	sev()
 
-extern bool cpu0_calls_idle;
-
 extern void halt(void);
-extern void do_idle(void);
-
-extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
-extern void on_cpu(int cpu, void (*func)(void *data), void *data);
-extern void on_cpus(void (*func)(void *data), void *data);
 
 extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index e0872a1a72c2..0207ca2a7d57 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -10,13 +10,10 @@
 #include <cpumask.h>
 #include <asm/thread_info.h>
 #include <asm/spinlock.h>
-#include <asm/barrier.h>
 #include <asm/mmu.h>
 #include <asm/psci.h>
 #include <asm/smp.h>
 
-bool cpu0_calls_idle;
-
 cpumask_t cpu_present_mask;
 cpumask_t cpu_online_mask;
 cpumask_t cpu_idle_mask;
@@ -83,144 +80,3 @@ void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
 		__smp_boot_secondary(cpu, entry);
 	spin_unlock(&lock);
 }
-
-struct on_cpu_info {
-	void (*func)(void *data);
-	void *data;
-	cpumask_t waiters;
-};
-static struct on_cpu_info on_cpu_info[NR_CPUS];
-static cpumask_t on_cpu_info_lock;
-
-static bool get_on_cpu_info(int cpu)
-{
-	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
-}
-
-static void put_on_cpu_info(int cpu)
-{
-	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
-	assert(ret);
-}
-
-static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
-{
-	int i;
-
-	for_each_cpu(i, waiters) {
-		if (i == cpu) {
-			printf("CPU%d", cpu);
-			*found = true;
-			return;
-		}
-		__deadlock_check(cpu, &on_cpu_info[i].waiters, found);
-		if (*found) {
-			printf(" <=> CPU%d", i);
-			return;
-		}
-	}
-}
-
-static void deadlock_check(int me, int cpu)
-{
-	bool found = false;
-
-	__deadlock_check(cpu, &on_cpu_info[me].waiters, &found);
-	if (found) {
-		printf(" <=> CPU%d deadlock detectd\n", me);
-		assert(0);
-	}
-}
-
-static void cpu_wait(int cpu)
-{
-	int me = smp_processor_id();
-
-	if (cpu == me)
-		return;
-
-	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
-	deadlock_check(me, cpu);
-	while (!cpu_idle(cpu))
-		smp_wait_for_event();
-	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
-}
-
-void do_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	if (cpu == 0)
-		cpu0_calls_idle = true;
-
-	set_cpu_idle(cpu, true);
-	smp_send_event();
-
-	for (;;) {
-		while (cpu_idle(cpu))
-			smp_wait_for_event();
-		smp_rmb();
-		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
-		on_cpu_info[cpu].func = NULL;
-		smp_wmb();
-		set_cpu_idle(cpu, true);
-		smp_send_event();
-	}
-}
-
-void on_cpu_async(int cpu, void (*func)(void *data), void *data)
-{
-	if (cpu == smp_processor_id()) {
-		func(data);
-		return;
-	}
-
-	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
-						"If this is intended set cpu0_calls_idle=1");
-
-	smp_boot_secondary_nofail(cpu, do_idle);
-
-	for (;;) {
-		cpu_wait(cpu);
-		if (get_on_cpu_info(cpu)) {
-			if ((volatile void *)on_cpu_info[cpu].func == NULL)
-				break;
-			put_on_cpu_info(cpu);
-		}
-	}
-
-	on_cpu_info[cpu].func = func;
-	on_cpu_info[cpu].data = data;
-	set_cpu_idle(cpu, false);
-	put_on_cpu_info(cpu);
-	smp_send_event();
-}
-
-void on_cpu(int cpu, void (*func)(void *data), void *data)
-{
-	on_cpu_async(cpu, func, data);
-	cpu_wait(cpu);
-}
-
-void on_cpus(void (*func)(void *data), void *data)
-{
-	int cpu, me = smp_processor_id();
-
-	for_each_present_cpu(cpu) {
-		if (cpu == me)
-			continue;
-		on_cpu_async(cpu, func, data);
-	}
-	func(data);
-
-	for_each_present_cpu(cpu) {
-		if (cpu == me)
-			continue;
-		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
-		deadlock_check(me, cpu);
-	}
-	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
-		smp_wait_for_event();
-	for_each_present_cpu(cpu)
-		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
-}
diff --git a/lib/on-cpus.c b/lib/on-cpus.c
new file mode 100644
index 000000000000..aed70f7b27b2
--- /dev/null
+++ b/lib/on-cpus.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * on_cpus() support based on cpumasks.
+ *
+ * Copyright (C) 2015, Red Hat Inc, Andrew Jones <drjones@redhat.com>
+ */
+#include <libcflat.h>
+#include <cpumask.h>
+#include <on-cpus.h>
+#include <asm/barrier.h>
+#include <asm/smp.h>
+
+bool cpu0_calls_idle;
+
+struct on_cpu_info {
+	void (*func)(void *data);
+	void *data;
+	cpumask_t waiters;
+};
+static struct on_cpu_info on_cpu_info[NR_CPUS];
+static cpumask_t on_cpu_info_lock;
+
+static bool get_on_cpu_info(int cpu)
+{
+	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
+}
+
+static void put_on_cpu_info(int cpu)
+{
+	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
+	assert(ret);
+}
+
+static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
+{
+	int i;
+
+	for_each_cpu(i, waiters) {
+		if (i == cpu) {
+			printf("CPU%d", cpu);
+			*found = true;
+			return;
+		}
+		__deadlock_check(cpu, &on_cpu_info[i].waiters, found);
+		if (*found) {
+			printf(" <=> CPU%d", i);
+			return;
+		}
+	}
+}
+
+static void deadlock_check(int me, int cpu)
+{
+	bool found = false;
+
+	__deadlock_check(cpu, &on_cpu_info[me].waiters, &found);
+	if (found) {
+		printf(" <=> CPU%d deadlock detectd\n", me);
+		assert(0);
+	}
+}
+
+static void cpu_wait(int cpu)
+{
+	int me = smp_processor_id();
+
+	if (cpu == me)
+		return;
+
+	cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
+	deadlock_check(me, cpu);
+	while (!cpu_idle(cpu))
+		smp_wait_for_event();
+	cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
+}
+
+void do_idle(void)
+{
+	int cpu = smp_processor_id();
+
+	if (cpu == 0)
+		cpu0_calls_idle = true;
+
+	set_cpu_idle(cpu, true);
+	smp_send_event();
+
+	for (;;) {
+		while (cpu_idle(cpu))
+			smp_wait_for_event();
+		smp_rmb();
+		on_cpu_info[cpu].func(on_cpu_info[cpu].data);
+		on_cpu_info[cpu].func = NULL;
+		smp_wmb();
+		set_cpu_idle(cpu, true);
+		smp_send_event();
+	}
+}
+
+void on_cpu_async(int cpu, void (*func)(void *data), void *data)
+{
+	if (cpu == smp_processor_id()) {
+		func(data);
+		return;
+	}
+
+	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
+						"If this is intended set cpu0_calls_idle=1");
+
+	smp_boot_secondary_nofail(cpu, do_idle);
+
+	for (;;) {
+		cpu_wait(cpu);
+		if (get_on_cpu_info(cpu)) {
+			if ((volatile void *)on_cpu_info[cpu].func == NULL)
+				break;
+			put_on_cpu_info(cpu);
+		}
+	}
+
+	on_cpu_info[cpu].func = func;
+	on_cpu_info[cpu].data = data;
+	set_cpu_idle(cpu, false);
+	put_on_cpu_info(cpu);
+	smp_send_event();
+}
+
+void on_cpu(int cpu, void (*func)(void *data), void *data)
+{
+	on_cpu_async(cpu, func, data);
+	cpu_wait(cpu);
+}
+
+void on_cpus(void (*func)(void *data), void *data)
+{
+	int cpu, me = smp_processor_id();
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+		on_cpu_async(cpu, func, data);
+	}
+	func(data);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+		cpumask_set_cpu(me, &on_cpu_info[cpu].waiters);
+		deadlock_check(me, cpu);
+	}
+	while (cpumask_weight(&cpu_idle_mask) < nr_cpus - 1)
+		smp_wait_for_event();
+	for_each_present_cpu(cpu)
+		cpumask_clear_cpu(me, &on_cpu_info[cpu].waiters);
+}
diff --git a/lib/on-cpus.h b/lib/on-cpus.h
new file mode 100644
index 000000000000..41103b0245c7
--- /dev/null
+++ b/lib/on-cpus.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ON_CPUS_H_
+#define _ON_CPUS_H_
+#include <stdbool.h>
+
+extern bool cpu0_calls_idle;
+
+void do_idle(void);
+
+void on_cpu_async(int cpu, void (*func)(void *data), void *data);
+void on_cpu(int cpu, void (*func)(void *data), void *data);
+void on_cpus(void (*func)(void *data), void *data);
+
+#endif /* _ON_CPUS_H_ */
-- 
2.43.0

