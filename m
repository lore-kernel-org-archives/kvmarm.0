Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D245C33C9E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FE0C206D3
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vrk5yF2J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FE0C206D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDE654AEB1;
	Thu, 30 Jan 2020 06:25:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E3FgVGGRNaOl; Thu, 30 Jan 2020 06:25:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67444ACD6;
	Thu, 30 Jan 2020 06:25:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 281934AC89
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZBAEDwgpAdS0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 06:25:50 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 391C54A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580383550;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tZ8t/jvrMH9gmFlHWP1z+sDKBsuOrEE26InOIEyQnuA=;
 b=Vrk5yF2JhghvBuVNi1SL9AyL6jAyRLXVTPD/gbo8PwedGrJAD5fRzlHRsUROUoZnU331LW
 nlGXEz6BFz4nlbj3FCst5ERKMjfbzkVTcB/xgez79cZQoNpOn1+TdFTVQGsKyB8NW43PI0
 nQw1a5+AWBuScIp8mBM/QiWjAHp7goY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-5jvxqSYYPiuftcR82U1fbQ-1; Thu, 30 Jan 2020 06:25:48 -0500
X-MC-Unique: 5jvxqSYYPiuftcR82U1fbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC221800D41;
 Thu, 30 Jan 2020 11:25:46 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E28AF1001B05;
 Thu, 30 Jan 2020 11:25:41 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event Support
Date: Thu, 30 Jan 2020 12:25:05 +0100
Message-Id: <20200130112510.15154-5-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

v1 -> v2:
- fix is_event_supported()
- fix boolean condition for PMU v4
- fix PMCEID0 definition

RFC ->v1:
- add a comment to explain the PMCEID0/1 splits
---
 arm/pmu.c         | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 +++++
 2 files changed, 68 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index d24857e..4a26a76 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
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
@@ -139,6 +143,61 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
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
+	 * The low 32-bits of PMCEID0/1 respectly describe
+	 * event support for events 0-31/32-63. Their High
+	 * 32-bits describe support for extended events
+	 * starting at 0x4000, using the same split.
+	 */
+	if (n >= 0x0  && n <= 0x3F)
+		reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
+	else if  (n >= 0x4000 && n <= 0x403F)
+		reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
+	else
+		abort();
+
+	supported =  reg & (1UL << (n & 0x3F));
+
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
+
+	/* PMUv3 requires an implementation includes some common events */
+	required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
+			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
+			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
+			   is_event_supported(0x1B, true) /* INST_PREC */);
+
+	if (pmu.version == 0x4) {
+		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
+		required_events = required_events &&
+				  is_event_supported(0x23, true) &&
+				  is_event_supported(0x24, true);
+	}
+
+	report(required_events, "Check required events are implemented");
+}
+
 #endif
 
 /*
@@ -326,6 +385,9 @@ int main(int argc, char *argv[])
 		       "Monotonically increasing cycle count");
 		report(check_cpi(cpi), "Cycle/instruction ratio");
 		pmccntr64_test();
+	} else if (strcmp(argv[1], "event-introspection") == 0) {
+		report_prefix_push(argv[1]);
+		test_event_introspection();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
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
