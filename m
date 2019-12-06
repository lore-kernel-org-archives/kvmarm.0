Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A41C2BBE2
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E183F206DF
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cth4FtdF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E183F206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9831F4AF39;
	Fri,  6 Dec 2019 12:28:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8VTwkXUW4WSH; Fri,  6 Dec 2019 12:28:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4AF4AF16;
	Fri,  6 Dec 2019 12:28:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6DA24AECE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uyJvLPuvgJwr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:28:02 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B0E4AED2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575653281;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=05gJo/iDZRpCh33ff7JxVNxihlf01laZ3I+XStrtiS8=;
 b=Cth4FtdFSriRT2ZrMI+nXrBt8KbOGBTLaOLxBTTlDKb65OP76ERl9K7tWTc/b9NkeDS+Yl
 VzrUnpb6Nw52wFcFu1qUAXwyq2yfpuHncrSFVsu4yGpiDj+Q9EL7NwtbBKawbF8sZ1OMGZ
 bKNKqH+urCLCTGtGtc194j0Jss0T/uI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-cZUedAMGMjSY8CBp_wrjmw-1; Fri, 06 Dec 2019 12:27:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0943800C7B;
 Fri,  6 Dec 2019 17:27:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 31D1060BF4;
 Fri,  6 Dec 2019 17:27:55 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests RFC 05/10] pmu: Basic event counter Tests
Date: Fri,  6 Dec 2019 18:27:19 +0100
Message-Id: <20191206172724.947-6-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: cZUedAMGMjSY8CBp_wrjmw-1
X-Mimecast-Spam-Score: 0
Cc: andre.przywara@arm.com
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

Adds the following tests:
- event-counter-config: test event counter configuration
- basic-event-count:
  - programs counters #0 and #1 to count 2 required events
  (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
  to a value close enough to the 32b
  overflow limit so that we check the overflow bit is set
  after the execution of the asm loop.
- mem-access: counts MEM_ACCESS event on counters #0 and #1
  with and without 32-bit overflow.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 254 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  18 ++++
 2 files changed, 272 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index f78c43f..8ffeb93 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -18,9 +18,15 @@
 #include "asm/barrier.h"
 #include "asm/sysreg.h"
 #include "asm/processor.h"
+#include <bitops.h>
+#include <asm/gic.h>
 
 #define PMU_PMCR_E         (1 << 0)
+#define PMU_PMCR_P         (1 << 1)
 #define PMU_PMCR_C         (1 << 2)
+#define PMU_PMCR_D         (1 << 3)
+#define PMU_PMCR_X         (1 << 4)
+#define PMU_PMCR_DP        (1 << 5)
 #define PMU_PMCR_LC        (1 << 6)
 #define PMU_PMCR_N_SHIFT   11
 #define PMU_PMCR_N_MASK    0x1f
@@ -105,6 +111,9 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
+static void test_event_counter_config(void) {}
+static void test_basic_event_count(void) {}
+static void test_mem_access(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -146,6 +155,32 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 }
 
 #define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
+#define PMCNTENSET_EL0 sys_reg(11, 3, 9, 12, 1)
+#define PMCNTENCLR_EL0 sys_reg(11, 3, 9, 12, 2)
+
+#define PMEVTYPER_EXCLUDE_EL1 (1 << 31)
+#define PMEVTYPER_EXCLUDE_EL0 (1 << 30)
+
+#define regn_el0(__reg, __n) __reg ## __n  ## _el0
+#define write_regn(__reg, __n, __val) \
+	write_sysreg((__val), __reg ## __n ## _el0)
+
+#define read_regn(__reg, __n) \
+	read_sysreg(__reg ## __n ## _el0)
+
+#define print_pmevtyper(__s , __n) do { \
+	uint32_t val; \
+	val = read_regn(pmevtyper, __n);\
+	report_info("%s pmevtyper%d=0x%x, eventcount=0x%x (p=%ld, u=%ld nsk=%ld, nsu=%ld, nsh=%ld m=%ld, mt=%ld)", \
+			(__s), (__n), val, val & 0xFFFF,  \
+			(BIT_MASK(31) & val) >> 31, \
+			(BIT_MASK(30) & val) >> 30, \
+			(BIT_MASK(29) & val) >> 29, \
+			(BIT_MASK(28) & val) >> 28, \
+			(BIT_MASK(27) & val) >> 27, \
+			(BIT_MASK(26) & val) >> 26, \
+			(BIT_MASK(25) & val) >> 25); \
+	} while (0)
 
 static bool is_event_supported(uint32_t n, bool warn)
 {
@@ -207,6 +242,216 @@ static void test_event_introspection(void)
 	report("Check required events are implemented", required_events);
 }
 
+static inline void mem_access_loop(void *addr, int loop, uint32_t pmcr)
+{
+asm volatile(
+	"       msr     pmcr_el0, %[pmcr]\n"
+	"       isb\n"
+	"       mov     x10, %[loop]\n"
+	"1:     sub     x10, x10, #1\n"
+	"       mov x8, %[addr]\n"
+	"       ldr x9, [x8]\n"
+	"       cmp     x10, #0x0\n"
+	"       b.gt    1b\n"
+	"       msr     pmcr_el0, xzr\n"
+	"       isb\n"
+	:
+	: [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
+	: );
+}
+
+
+static void pmu_reset(void)
+{
+	/* reset all counters, counting disabled at PMCR level*/
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	/* Disable all counters */
+	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+	/* clear overflow reg */
+	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+	/* disable overflow interrupts on all counters */
+	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	isb();
+}
+
+static void test_event_counter_config(void) {
+	int i;
+
+	if (!pmu.nb_implemented_counters) {
+		report_skip("No event counter, skip ...");
+		return;
+	}
+
+	pmu_reset();
+
+	/* Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read */
+        /* select counter 0 */
+        write_sysreg(1, PMSELR_EL0);
+        /* program this counter to count unsupported event */
+        write_sysreg(0xEA, PMXEVTYPER_EL0);
+        write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
+	report("PMESELR/PMXEVTYPER/PMEVTYPERn",
+		(read_regn(pmevtyper, 1) & 0xFFF) == 0xEA);
+	report("PMESELR/PMXEVCNTR/PMEVCNTRn",
+		(read_regn(pmevcntr, 1) == 0xdeadbeef));
+
+	/* try configure an unsupported event within the range [0x0, 0x3F] */
+	for (i = 0; i <= 0x3F; i++) {
+		if (!is_event_supported(i, false))
+			goto test_unsupported;
+	}
+	report_skip("pmevtyper: all events within [0x0, 0x3F] are supported");
+
+test_unsupported:
+	/* select counter 0 */
+	write_sysreg(0, PMSELR_EL0);
+	/* program this counter to count unsupported event */
+	write_sysreg(i, PMXEVCNTR_EL0);
+	/* read the counter value */
+	read_sysreg(PMXEVCNTR_EL0);
+	report("read of a counter programmed with unsupported event", read_sysreg(PMXEVCNTR_EL0) == i);
+
+}
+
+static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
+{
+	int i;
+
+	if (pmu.nb_implemented_counters < nb_events) {
+		report_skip("Skip test as number of counters is too small (%d)",
+			    pmu.nb_implemented_counters);
+		return false;
+	}
+
+	for (i = 0; i < nb_events; i++) {
+		if (!is_event_supported(events[i], false)) {
+			report_skip("Skip test as event %d is not supported",
+				    events[i]);
+			return false;
+		}
+	}		
+	return true;
+}
+
+static void test_basic_event_count(void)
+{
+	uint32_t implemented_counter_mask, non_implemented_counter_mask;
+	uint32_t counter_mask;
+	uint32_t events[] = {
+		0x11,	/* CPU_CYCLES */
+		0x8,	/* INST_RETIRED */
+	};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	implemented_counter_mask = (1 << pmu.nb_implemented_counters) - 1;
+	non_implemented_counter_mask = ~((1 << 31) | implemented_counter_mask);
+	counter_mask = implemented_counter_mask | non_implemented_counter_mask;
+
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+
+	/* disable all counters */
+	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+	report("pmcntenclr: disable all counters",
+	       !read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0));
+
+	/*
+	 * clear cycle and all event counters and allow counter enablement
+	 * through PMCNTENSET. LC is RES1.
+	 */
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	isb();	
+	report("pmcr: reset counters", get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC));
+
+	/* Preset counter #0 to 0xFFFFFFF0 to trigger an overflow interrupt */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	report("counter #0 preset to 0xFFFFFFF0",
+		read_regn(pmevcntr, 0) == 0xFFFFFFF0);
+	report("counter #1 is 0", !read_regn(pmevcntr, 1));
+
+	/*
+	 * Enable all implemented counters and also attempt to enable
+	 * not supported counters. Counting still is disabled by !PMCR.E
+	 */
+	write_sysreg_s(counter_mask, PMCNTENSET_EL0);
+
+	/* check only those implemented are enabled */
+	report("pmcntenset: enabled implemented_counters",
+	       (read_sysreg_s(PMCNTENSET_EL0) == read_sysreg_s(PMCNTENCLR_EL0)) &&
+		(read_sysreg_s(PMCNTENSET_EL0) == implemented_counter_mask));
+
+	/* Disable all counters but counters #0 and #1 */
+	write_sysreg_s(~0x3, PMCNTENCLR_EL0);
+	report("pmcntenset: just enabled #0 and #1",
+	       (read_sysreg_s(PMCNTENSET_EL0) == read_sysreg_s(PMCNTENCLR_EL0)) &&
+		(read_sysreg_s(PMCNTENSET_EL0) == 0x3));
+
+	/* clear overflow register */
+	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+	report("check overflow reg is 0", !read_sysreg(pmovsclr_el0));
+
+	/* disable overflow interrupts on all counters*/
+	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	report("pmintenclr_el1=0, all interrupts disabled",
+		!read_sysreg(pmintenclr_el1));
+
+	/* enable overflow interrupts on all event counters */
+	write_sysreg(implemented_counter_mask | non_implemented_counter_mask,
+		     pmintenset_el1);
+	report("overflow interrupts enabled on all implemented counters",
+		read_sysreg(pmintenset_el1) == implemented_counter_mask);
+
+	/* Set PMCR.E, execute asm code and unset PMCR.E */
+	precise_instrs_loop(20, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report_info("counter #0 is 0x%lx (CPU_CYCLES)", read_regn(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (INST_RETIRED)", read_regn(pmevcntr, 1));
+
+	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0) );
+	report("check overflow happened on #0 only", read_sysreg(pmovsclr_el0) & 0x1);
+}
+
+static void test_mem_access(void)
+{
+	void *addr = malloc(PAGE_SIZE);
+	uint32_t events[] = {
+                0x13,   /* MEM_ACCESS */
+                0x13,   /* MEM_ACCESS */
+        };
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 0));
+	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 1));
+	/* We may not measure exactly 20 mem access, this depends on the platform */
+	report("Ran 20 mem accesses",
+	       (read_regn(pmevcntr, 0) == read_regn(pmevcntr, 1)) &&
+	       (read_regn(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0));
+
+	pmu_reset();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFFA);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report("Ran 20 mem accesses with expected overflows on both counters",
+	       read_sysreg(pmovsclr_el0) == 0x3);
+	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
 
 /*
@@ -394,6 +639,15 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "event-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_event_introspection();
+        } else if (strcmp(argv[1], "event-counter-config") == 0) {
+                report_prefix_push(argv[1]);
+		test_event_counter_config();
+	} else if (strcmp(argv[1], "basic-event-count") == 0) {
+		report_prefix_push(argv[1]);
+		test_basic_event_count();
+	} else if (strcmp(argv[1], "mem-access") == 0) {
+		report_prefix_push(argv[1]);
+		test_mem_access();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 4433ef3..7a59403 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -72,6 +72,24 @@ groups = pmu
 arch = arm64
 extra_params = -append 'event-introspection'
 
+[pmu-event-counter-config]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'event-counter-config'
+
+[pmu-basic-event-count]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'basic-event-count'
+
+[pmu-mem-access]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'mem-access'
+
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
 #file = pmu.flat
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
