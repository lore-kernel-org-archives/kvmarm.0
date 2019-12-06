Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C9BC43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8BDE5206DF
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+c9/k5W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BDE5206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 457A74AF29;
	Fri,  6 Dec 2019 12:28:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Zfk3qmMGNRh; Fri,  6 Dec 2019 12:28:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8D64A7F0;
	Fri,  6 Dec 2019 12:28:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9084AF16
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LtfuwriInNh9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:28:08 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C32764AF32
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575653286;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ws3xaERf1779J4gNkymE+bAzmPMolefs3O1wIlcUpJo=;
 b=Z+c9/k5WUxFlrmhMZtZIT+HdTL9dU7irnnTOFtvHyN5hxLOWZSJio+BU8Uo02k4z86vHkV
 +qSjZOH+EIgGUKwz6ebGJKUAeVwX2SoBs7AjVV92lzEMUcoVnIiUCD5etKDnanq2qhkie/
 ZEy/ZyTItvVVdR19edkVaNBuNjlnrLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-F-9tv1RVOcePy6CWYZVclw-1; Fri, 06 Dec 2019 12:28:05 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 697F7107ACC4;
 Fri,  6 Dec 2019 17:28:03 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E3D7160BF4;
 Fri,  6 Dec 2019 17:28:00 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests RFC 07/10] arm: pmu: test 32-bit <-> 64-bit
 transitions
Date: Fri,  6 Dec 2019 18:27:21 +0100
Message-Id: <20191206172724.947-8-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: F-9tv1RVOcePy6CWYZVclw-1
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

---
 arm/pmu.c         | 125 +++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |   6 +++
 2 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index e185809..47d46a2 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -116,6 +116,7 @@ static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
+static void test_chain_promotion(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -262,7 +263,6 @@ asm volatile(
 	: );
 }
 
-
 static void pmu_reset(void)
 {
 	/* reset all counters, counting disabled at PMCR level*/
@@ -571,6 +571,126 @@ static void test_chained_sw_incr(void)
 		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
 }
 
+static void test_chain_promotion(void)
+{
+	uint32_t events[] = { 0x13 /* MEM_ACCESS */, 0x1E /* CHAIN */};
+	void *addr = malloc(PAGE_SIZE);
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	/* Only enable CHAIN counter */
+	pmu_reset();
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x2, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report("chain counter not counting if even counter is disabled",
+		!read_regn(pmevcntr, 0));
+
+	/* Only enable even counter */
+	pmu_reset();
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report("odd counter did not increment on overflow if disabled",
+		!read_regn(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1));
+	report_info("MEM_ACCESS counter #0 has value %ld", read_regn(pmevcntr, 0)); 
+	report_info("CHAIN counter #1 has value %ld", read_regn(pmevcntr, 1)); 
+	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+
+	/* disable the CHAIN event */
+	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+	report("should have triggered an overflow on #0", read_sysreg(pmovsclr_el0) == 0x1);
+	report("CHAIN counter #1 shouldn't have incremented", !read_regn(pmevcntr, 1));
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
+
+	pmu_reset();
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+		    read_sysreg(pmovsclr_el0));
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+
+	/* enable the CHAIN event */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+
+	report("CHAIN counter #1 should have incremented and no overflow expected",
+		(read_regn(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0));
+
+	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
+		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
+	pmu_reset();
+        write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+
+	/* 0 becomes CHAINED */
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+        write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx", read_regn(pmevcntr, 0)); 
+
+	report("CHAIN counter #1 should have incremented and no overflow expected",
+		(read_regn(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0));
+
+	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
+		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
+	pmu_reset();
+        write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0=0x%lx, counter #1=0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+        write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report("overflow is expected on counter 0", read_sysreg(pmovsclr_el0) == 1);
+	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
 
 /*
@@ -773,6 +893,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "chained-sw-incr") == 0) {
 		report_prefix_push(argv[1]);
 		test_chained_sw_incr();
+	} else if (strcmp(argv[1], "chain-promotion") == 0) {
+		report_prefix_push(argv[1]);
+		test_chain_promotion();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1bd4319..eb6e87e 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -102,6 +102,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'chained-sw-incr'
 
+[pmu-chain-promotion]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'chain-promotion'
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
