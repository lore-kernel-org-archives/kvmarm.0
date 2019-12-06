Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2870C2BD09
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88CB42466E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPotZyqM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88CB42466E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E6494AF29;
	Fri,  6 Dec 2019 12:28:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYSWOMJAJkod; Fri,  6 Dec 2019 12:28:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B0D4AECD;
	Fri,  6 Dec 2019 12:28:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A87084AECD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:27:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A70qHRFF2yZr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:27:58 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A706E4AE94
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:27:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575653278;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WMQUa3khr5jsekFu/skIEP0pnlonAM+9sITcAnn0lGM=;
 b=UPotZyqMhn3HXPQwkXqU42VdoN5rNg+zs7d8/TXKADZbgZrj4KhP7j3B9gzZwphD/vOiPX
 una8aZ0hGX+J+FBYV3l8DxVU0anICDq86DJuqNBhWWz78pBrVJ6VDGnkwQmv4x4NCLnLI7
 RGD4eoEcHqT461keUGdQiWc81gcSONg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-bNevScXFNg-cmD5S24rlpg-1; Fri, 06 Dec 2019 12:27:56 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE4C31005502;
 Fri,  6 Dec 2019 17:27:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC286CE40;
 Fri,  6 Dec 2019 17:27:47 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests RFC 04/10] pmu: Check Required Event Support
Date: Fri,  6 Dec 2019 18:27:18 +0100
Message-Id: <20191206172724.947-5-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: bNevScXFNg-cmD5S24rlpg-1
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
 arm/pmu.c         | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 ++++
 2 files changed, 76 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 8e95251..f78c43f 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -102,6 +102,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
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
@@ -140,6 +144,69 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 	: [pmcr] "r" (pmcr)
 	: "cc");
 }
+
+#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
+
+static bool is_event_supported(uint32_t n, bool warn)
+{
+	uint64_t pmceid0 = read_sysreg(pmceid0_el0);
+	uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
+	bool supported;
+	uint32_t reg;
+
+	if (n >= 0x0  && n <= 0x1F) {
+		reg = pmceid0 & 0xFFFFFFFF;
+	} else if  (n >= 0x4000 && n <= 0x401F) {
+		reg = pmceid0 >> 32;
+	} else if (n >= 0x20  && n <= 0x3F) {
+		reg = pmceid1 & 0xFFFFFFFF;
+	} else if (n >= 0x4020 && n <= 0x403F) {
+		reg = pmceid1 >> 32;
+	} else {
+		abort();
+	}
+	supported =  reg & (1 << n);
+	if (!supported && warn)
+		report_info("event %d is not supported", n);
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
+	if (pmu.nb_implemented_counters < 2)
+		report_info("%d event counters are implemented. "
+                            "ARM recommends to implement at least 2",
+                            pmu.nb_implemented_counters);
+
+	/* PMUv3 requires an implementation includes some common events */
+	required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
+			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
+			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
+			   is_event_supported(0x1B, true) /* INST_PREC */);
+	if (!is_event_supported(0x8, false))
+		report_info("ARM strongly recomments INST_RETIRED (0x8) event "
+			    "to be implemented");
+
+	if (pmu.version == 0x4) {
+		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
+		required_events = required_events ||
+				  is_event_supported(0x23, true) ||
+				  is_event_supported(0x24, true);
+	}
+
+	/* L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
+	   L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are only
+	   required if program-flow prediction is implemented. */
+
+	report("Check required events are implemented", required_events);
+}
+
 #endif
 
 /*
@@ -324,6 +391,9 @@ int main(int argc, char *argv[])
 		report("Monotonically increasing cycle count", check_cycles_increase());
 		report("Cycle/instruction ratio", check_cpi(cpi));
 		pmccntr64_test();
+	} else if (strcmp(argv[1], "event-introspection") == 0) {
+		report_prefix_push(argv[1]);
+		test_event_introspection();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 79f0d7a..4433ef3 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,6 +66,12 @@ file = pmu.flat
 groups = pmu
 extra_params = -append 'cycle-counter 0'
 
+[pmu-event-introspection]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'event-introspection'
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
