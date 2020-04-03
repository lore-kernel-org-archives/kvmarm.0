Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3E2C43331
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:14:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 270F020787
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOTY5w5e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 270F020787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E484B0EF;
	Fri,  3 Apr 2020 03:14:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W5PAnaV29rop; Fri,  3 Apr 2020 03:14:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC0234B163;
	Fri,  3 Apr 2020 03:14:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBEB44B0EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:14:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Cieu5Nel8Pv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 03:14:02 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C21F4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:14:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585898042;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cuxQzZymJ+j/hsy41QQY4o/LcnKvlePF7LiNjbaBNOQ=;
 b=GOTY5w5eWsv6Z6qt3Ps9pMDtJK5CwXoG6dm9zqtfJmlpP6wkYObz6O8kcw8P+7Nk2pAJCX
 Bm8e68s4xoyP827678w5DlbSC+JMjqnEZ9EDfhypOlnWDsBdHfv6rtvY61L7+6qA/Xk8KA
 Tp3Q6ciihyDY0altTi2/hmOWdcv/49Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-RE5oBnMMMMi0wXriTR7ufA-1; Fri, 03 Apr 2020 03:14:00 -0400
X-MC-Unique: RE5oBnMMMMi0wXriTR7ufA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E6AD8017F3;
 Fri,  3 Apr 2020 07:13:59 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 51FB248;
 Fri,  3 Apr 2020 07:13:56 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v4 06/12] arm: pmu: Check Required Event Support
Date: Fri,  3 Apr 2020 09:13:20 +0200
Message-Id: <20200403071326.29932-7-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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

If event counters are implemented check the common events
required by the PMUv3 are implemented.

Some are unconditionally required (SW_INCR, CPU_CYCLES,
either INST_RETIRED or INST_SPEC). Some others only are
required if the implementation implements some other features.

Check those wich are unconditionally required.

This test currently fails on TCG as neither INST_RETIRED
or INST_SPEC are supported.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- use 0x%x instead %d in trace
- pmu.version >= ID_DFR0_PMU_v3_8_1
- added prefix pop
- assert instead of abort, inverse assert and test
- add defines for used events and common events
- given the changes I did not apply Andre's R-b
- introduce and use upper_32_bits()/lower_32_bits()
- added pmu prefix to the test name

v1 -> v2:
- fix is_event_supported()
- fix boolean condition for PMU v4
- fix PMCEID0 definition

RFC ->v1:
- add a comment to explain the PMCEID0/1 splits
---
 arm/pmu.c         | 77 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 ++++
 lib/bitops.h      |  3 ++
 3 files changed, 86 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index a04588a..8c49e50 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -18,6 +18,7 @@
 #include "asm/barrier.h"
 #include "asm/sysreg.h"
 #include "asm/processor.h"
+#include <bitops.h>
 
 #define PMU_PMCR_E         (1 << 0)
 #define PMU_PMCR_C         (1 << 2)
@@ -33,6 +34,19 @@
 
 #define NR_SAMPLES 10
 
+/* Some PMU events */
+#define SW_INCR			0x0
+#define INST_RETIRED		0x8
+#define CPU_CYCLES		0x11
+#define INST_PREC		0x1B
+#define STALL_FRONTEND		0x23
+#define STALL_BACKEND		0x24
+
+#define COMMON_EVENTS_LOW	0x0
+#define COMMON_EVENTS_HIGH	0x3F
+#define EXT_COMMON_EVENTS_LOW	0x4000
+#define EXT_COMMON_EVENTS_HIGH	0x403F
+
 struct pmu {
 	unsigned int version;
 	unsigned int nb_implemented_counters;
@@ -110,6 +124,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: [pmcr] "r" (pmcr), [z] "r" (0)
 	: "cc");
 }
+
+/* event counter tests only implemented for aarch64 */
+static void test_event_introspection(void) {}
+
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
 #define ID_AA64DFR0_PERFMON_MASK  0xf
@@ -155,6 +173,61 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: [pmcr] "r" (pmcr)
 	: "cc");
 }
+
+#define PMCEID1_EL0 sys_reg(3, 3, 9, 12, 7)
+
+static bool is_event_supported(uint32_t n, bool warn)
+{
+	uint64_t pmceid0 = read_sysreg(pmceid0_el0);
+	uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
+	bool supported;
+	uint64_t reg;
+
+	/*
+	 * The low 32-bits of PMCEID0/1 respectively describe
+	 * event support for events 0-31/32-63. Their High
+	 * 32-bits describe support for extended events
+	 * starting at 0x4000, using the same split.
+	 */
+	assert((n >= COMMON_EVENTS_LOW  && n <= COMMON_EVENTS_HIGH) ||
+	       (n >= EXT_COMMON_EVENTS_LOW && n <= EXT_COMMON_EVENTS_HIGH));
+
+	if (n <= COMMON_EVENTS_HIGH)
+		reg = lower_32_bits(pmceid0) | ((u64)lower_32_bits(pmceid1) << 32);
+	else
+		reg = upper_32_bits(pmceid0) | ((u64)upper_32_bits(pmceid1) << 32);
+
+	supported =  reg & (1UL << (n & 0x3F));
+
+	if (!supported && warn)
+		report_info("event 0x%x is not supported", n);
+	return supported;
+}
+
+static void test_event_introspection(void)
+{
+	bool required_events;
+
+	if (!pmu.nb_implemented_counters) {
+		report_skip("No event counter, skip ...");
+		return;
+	}
+
+	/* PMUv3 requires an implementation includes some common events */
+	required_events = is_event_supported(SW_INCR, true) &&
+			  is_event_supported(CPU_CYCLES, true) &&
+			  (is_event_supported(INST_RETIRED, true) ||
+			   is_event_supported(INST_PREC, true));
+
+	if (pmu.version >= ID_DFR0_PMU_V3_8_1) {
+		required_events = required_events &&
+				  is_event_supported(STALL_FRONTEND, true) &&
+				  is_event_supported(STALL_BACKEND, true);
+	}
+
+	report(required_events, "Check required events are implemented");
+}
+
 #endif
 
 /*
@@ -325,6 +398,10 @@ int main(int argc, char *argv[])
 		report(check_cpi(cpi), "Cycle/instruction ratio");
 		pmccntr64_test();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-event-introspection") == 0) {
+		report_prefix_push(argv[1]);
+		test_event_introspection();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index fe6515c..f993548 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,6 +66,12 @@ file = pmu.flat
 groups = pmu
 extra_params = -append 'cycle-counter 0'
 
+[pmu-event-introspection]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-event-introspection'
+
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
 #file = pmu.flat
diff --git a/lib/bitops.h b/lib/bitops.h
index 636064c..b310a22 100644
--- a/lib/bitops.h
+++ b/lib/bitops.h
@@ -33,6 +33,9 @@
 #define GENMASK_ULL(h, l) \
 	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))
 
+#define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
+#define lower_32_bits(n) ((u32)(n))
+
 #ifndef HAVE_BUILTIN_FLS
 static inline unsigned long fls(unsigned long word)
 {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
