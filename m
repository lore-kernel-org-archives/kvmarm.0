Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91841C43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48BEE206DF
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h47tVp+4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48BEE206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01D944AF2B;
	Fri,  6 Dec 2019 12:28:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JWJtz1TE5SJB; Fri,  6 Dec 2019 12:28:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1BE54AF00;
	Fri,  6 Dec 2019 12:28:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9720F4AEDA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xO-DRIgHjI4I for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:28:17 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8832E4AECE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:28:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575653297;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uHy6JtDFNgRRZUOE/EOkjvVUEne6jqUvFOy591Cbfrs=;
 b=h47tVp+4Tc3SrZw+tDX0LUm6aXF0pOMfmv17POB1nphloPJPl8RyvKxB8UgODdFdMl/157
 b7UPOFIeD/Mdkuy1hL51B7TskLoDapmRfJEMmseKXOjVsi5NzfbtJjNfibPj0yZZ+5vkXX
 XB+fId0uzLRbyYM3xHahohw5dTrvnQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-BOXZZEcbPF-QJRXfsfQH8w-1; Fri, 06 Dec 2019 12:28:16 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 925BC800EB9;
 Fri,  6 Dec 2019 17:28:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 15F6560BF4;
 Fri,  6 Dec 2019 17:28:11 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests RFC 10/10] pmu: Test overflow interrupts
Date: Fri,  6 Dec 2019 18:27:24 +0100
Message-Id: <20191206172724.947-11-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: BOXZZEcbPF-QJRXfsfQH8w-1
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

Test overflows for MEM_ACESS and SW_INCR events. Also tests
overflows with 64-bit events.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 133 +++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |   6 +++
 2 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 47d46a2..a63b93e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -45,8 +45,12 @@ struct pmu {
 	uint32_t pmcr_ro;
 };
 
-static struct pmu pmu;
+struct pmu_stats {
+	unsigned long bitmap;
+	uint32_t interrupts[32];
+};
 
+static struct pmu pmu;
 
 #if defined(__arm__)
 #define ID_DFR0_PERFMON_SHIFT 24
@@ -117,6 +121,7 @@ static void test_mem_access(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
 static void test_chain_promotion(void) {}
+static void test_overflow_interrupt(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -263,6 +268,43 @@ asm volatile(
 	: );
 }
 
+static struct pmu_stats pmu_stats;
+
+static void irq_handler(struct pt_regs *regs)
+{
+        uint32_t irqstat, irqnr;
+
+        irqstat = gic_read_iar();
+        irqnr = gic_iar_irqnr(irqstat);
+        gic_write_eoir(irqstat);
+
+        if (irqnr == 23) {
+                unsigned long overflows = read_sysreg(pmovsclr_el0);
+		int i;
+
+                report_info("--> PMU overflow interrupt %d (counter bitmask 0x%lx)", irqnr, overflows);
+		for (i = 0; i < 32; i++) {
+			if (test_and_clear_bit(i, &overflows)) {
+				pmu_stats.interrupts[i]++;
+				pmu_stats.bitmap |= 1 << i;
+			}
+		}
+                write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+        } else {
+                report_info("Unexpected interrupt: %d\n", irqnr);
+        }
+}
+
+static void pmu_reset_stats(void)
+{
+	int i;
+
+	for (i = 0; i < 32; i++) {
+		pmu_stats.interrupts[i] = 0;
+	}
+	pmu_stats.bitmap = 0;
+}
+
 static void pmu_reset(void)
 {
 	/* reset all counters, counting disabled at PMCR level*/
@@ -273,6 +315,7 @@ static void pmu_reset(void)
 	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
 	/* disable overflow interrupts on all counters */
 	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	pmu_reset_stats();
 	isb();
 }
 
@@ -691,8 +734,93 @@ static void test_chain_promotion(void)
 			read_sysreg(pmovsclr_el0));
 }
 
+static bool expect_interrupts(uint32_t bitmap)
+{
+	int i;
+
+	if (pmu_stats.bitmap ^ bitmap)
+		return false;
+
+	for (i = 0; i < 32; i++) {
+		if (test_and_clear_bit(i, &pmu_stats.bitmap))
+			if (pmu_stats.interrupts[i] != 1)
+				return false;
+	}
+	return true;
+}
+
+static void test_overflow_interrupt(void)
+{
+	uint32_t events[] = { 0x13 /* MEM_ACCESS */, 0x00 /* SW_INCR */};
+	void *addr = malloc(PAGE_SIZE);
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	setup_irq(irq_handler);
+	gic_enable_irq(23);
+
+	pmu_reset();
+
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	isb();
+
+	/* interrupts are disabled */
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report("no overflow interrupt received", expect_interrupts(0));
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++) {
+		write_sysreg(0x2, pmswinc_el0);
+	}
+	set_pmcr(pmu.pmcr_ro);
+	report("no overflow interrupt received", expect_interrupts(0));
+
+	/* enable interrupts */
+
+	pmu_reset_stats();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	write_sysreg(0xFFFFFFFF, pmintenset_el1);
+	isb();
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++) {
+		write_sysreg(0x3, pmswinc_el0);
+	}
+	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
+	report("overflow interrupts expected on #0 and #1", expect_interrupts(0x3));
+
+	/* promote to 64-b */
+
+	pmu_reset_stats();
+
+	events[1] = 0x1E /* CHAIN */;
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report("no overflow interrupt expected on 32b boundary", expect_interrupts(0));
+
+	/* overflow on odd counter */
+	pmu_reset_stats();
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report("expect overflow interrupt on odd counter", expect_interrupts(0x2));
+}
 #endif
 
+
 /*
  * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
  * null. Also print out a couple other interesting fields for diagnostic
@@ -896,6 +1024,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "chain-promotion") == 0) {
 		report_prefix_push(argv[1]);
 		test_chain_promotion();
+	} else if (strcmp(argv[1], "overflow-interrupt") == 0) {
+		report_prefix_push(argv[1]);
+		test_overflow_interrupt();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index eb6e87e..31b4c7a 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -108,6 +108,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'chain-promotion'
 
+[pmu-chain-promotion]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'overflow-interrupt'
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
