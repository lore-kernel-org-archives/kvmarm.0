Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99563C2BA19
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54D82206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GiOBOVj2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54D82206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 111E64B255;
	Sat,  4 Apr 2020 10:38:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X2G1Yw2tJNOE; Sat,  4 Apr 2020 10:38:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6ED64B248;
	Sat,  4 Apr 2020 10:38:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857FF4B196
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pYu2hQ1Vg3v9 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:50 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C3484B1E1
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011129;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=o/HtE4kD9Ya8MkHXVocYcKIgEQVisPRhIPUyZlQYN94=;
 b=GiOBOVj2CfalxSTZUfkAbs+/Ih9sqsRtpz4C/a9BASKvzq3ypOZyyzGLVoHN1vcWotaJ/y
 A1ib534iLIdp4bmWI1AkzzGriv4cb1ZyGiaiv100YFwh4nCzynIFR1nBWUhh5FvIsQC1E9
 DDxxd6jFp7MNmnevKkpz15rbdXwCxMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-Dqa0rjBvOBe8HVdERkn99Q-1; Sat, 04 Apr 2020 10:38:44 -0400
X-MC-Unique: Dqa0rjBvOBe8HVdERkn99Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC2E107ACC7;
 Sat,  4 Apr 2020 14:38:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id DB9079B912;
 Sat,  4 Apr 2020 14:38:41 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 26/39] arm: pmu: Test overflow interrupts
Date: Sat,  4 Apr 2020 16:37:18 +0200
Message-Id: <20200404143731.208138-27-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Eric Auger <eric.auger@redhat.com>

Test overflows for MEM_ACCESS and SW_INCR events. Also tests
overflows with 64-bit events.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pmu.c         | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 ++
 2 files changed, 145 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 9602e70f4185..cece53ef6431 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -59,12 +59,20 @@
 #define PRE_OVERFLOW		0xFFFFFFF0
 #define PRE_OVERFLOW2		0xFFFFFFDC
 
+#define PMU_PPI			23
+
 struct pmu {
 	unsigned int version;
 	unsigned int nb_implemented_counters;
 	uint32_t pmcr_ro;
 };
 
+struct pmu_stats {
+	unsigned long bitmap;
+	uint32_t interrupts[32];
+	bool unexpected;
+};
+
 static struct pmu pmu;
 
 #if defined(__arm__)
@@ -146,6 +154,7 @@ static void test_sw_incr(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
 static void test_chain_promotion(void) {}
+static void test_overflow_interrupt(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -276,6 +285,43 @@ asm volatile(
 	: "x9", "x10", "cc");
 }
 
+static struct pmu_stats pmu_stats;
+
+static void irq_handler(struct pt_regs *regs)
+{
+	uint32_t irqstat, irqnr;
+
+	irqstat = gic_read_iar();
+	irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr == PMU_PPI) {
+		unsigned long overflows = read_sysreg(pmovsclr_el0);
+		int i;
+
+		for (i = 0; i < 32; i++) {
+			if (test_and_clear_bit(i, &overflows)) {
+				pmu_stats.interrupts[i]++;
+				pmu_stats.bitmap |= 1 << i;
+			}
+		}
+		write_sysreg(ALL_SET, pmovsclr_el0);
+	} else {
+		pmu_stats.unexpected = true;
+	}
+	gic_write_eoir(irqstat);
+}
+
+static void pmu_reset_stats(void)
+{
+	int i;
+
+	for (i = 0; i < 32; i++)
+		pmu_stats.interrupts[i] = 0;
+
+	pmu_stats.bitmap = 0;
+	pmu_stats.unexpected = false;
+}
+
 static void pmu_reset(void)
 {
 	/* reset all counters, counting disabled at PMCR level*/
@@ -286,6 +332,7 @@ static void pmu_reset(void)
 	write_sysreg(ALL_SET, pmovsclr_el0);
 	/* disable overflow interrupts on all counters */
 	write_sysreg(ALL_SET, pmintenclr_el1);
+	pmu_reset_stats();
 	isb();
 }
 
@@ -728,6 +775,94 @@ static void test_chain_promotion(void)
 			read_sysreg(pmovsclr_el0));
 }
 
+static bool expect_interrupts(uint32_t bitmap)
+{
+	int i;
+
+	if (pmu_stats.bitmap ^ bitmap || pmu_stats.unexpected)
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
+	uint32_t events[] = {MEM_ACCESS, SW_INCR};
+	void *addr = malloc(PAGE_SIZE);
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	gic_enable_defaults();
+	install_irq_handler(EL1H_IRQ, irq_handler);
+	local_irq_enable();
+	gic_enable_irq(23);
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	isb();
+
+	/* interrupts are disabled */
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0), "no overflow interrupt after preset");
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x2, pmswinc_el0);
+
+	set_pmcr(pmu.pmcr_ro);
+	report(expect_interrupts(0), "no overflow interrupt after counting");
+
+	/* enable interrupts */
+
+	pmu_reset_stats();
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_sysreg(ALL_SET, pmintenset_el1);
+	isb();
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
+	report(expect_interrupts(0x3),
+		"overflow interrupts expected on #0 and #1");
+
+	/* promote to 64-b */
+
+	pmu_reset_stats();
+
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0),
+		"no overflow interrupt expected on 32b boundary");
+
+	/* overflow on odd counter */
+	pmu_reset_stats();
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+	isb();
+	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0x2),
+		"expect overflow interrupt on odd counter");
+}
 #endif
 
 /*
@@ -930,6 +1065,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_chain_promotion();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
+		report_prefix_push(argv[1]);
+		test_overflow_interrupt();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1b0c8c8c7eef..455fd10d63c9 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -114,6 +114,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'pmu-chain-promotion'
 
+[pmu-overflow-interrupt]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-overflow-interrupt'
+
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
 #file = pmu.flat
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
