Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C812C10DCE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:44:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA74D206FA
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KO3lDoee"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA74D206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8458E4AF0A;
	Thu, 12 Mar 2020 11:44:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ty2xTk3em8nn; Thu, 12 Mar 2020 11:44:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34E8A4AEE1;
	Thu, 12 Mar 2020 11:44:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAB1C4AEE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:44:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 99bsk09neAfQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 11:44:43 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96EFE4AEDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:44:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584027883;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XarQ6PV/N2BikZiOVzMV46m8k60fx8JOioXu8+pZywQ=;
 b=KO3lDoeeS3qyuW9RDERjshH45Zkwr8uLna+1wugPvzw3V3a2Rq8+h078VyfdtQ87g8VGd0
 NR2b1rwK7QvkWOfj3i40HzHks2rwu5Wsftz1s6rq1OOlRLA8nKanLHAlDjhZuB+wzZgRBw
 0xGXmi2DUDQvvSWsWwa0/D062CwfueU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-UAZ-rGDKN1ODer1zvlhl9w-1; Thu, 12 Mar 2020 11:44:41 -0400
X-MC-Unique: UAZ-rGDKN1ODer1zvlhl9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2165F19251D1;
 Thu, 12 Mar 2020 15:44:40 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3A2775C1B5;
 Thu, 12 Mar 2020 15:44:31 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 10/12] arm: pmu: test 32-bit <-> 64-bit
 transitions
Date: Thu, 12 Mar 2020 16:42:59 +0100
Message-Id: <20200312154301.9130-11-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Test configurations where we transit from 32b to 64b
counters and conversely. Also tests configuration where
chain counters are configured but only one counter is
enabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- added prefix pop
---
 arm/pmu.c         | 138 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 ++
 2 files changed, 144 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index ccca31b..79c2a0f 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -57,6 +57,7 @@
 #define ALL_SET			0xFFFFFFFF
 #define ALL_CLEAR		0x0
 #define PRE_OVERFLOW		0xFFFFFFF0
+#define PRE_OVERFLOW2		0xFFFFFFDC
 
 struct pmu {
 	unsigned int version;
@@ -144,6 +145,7 @@ static void test_mem_access(void) {}
 static void test_sw_incr(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
+static void test_chain_promotion(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -596,6 +598,138 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
+static void test_chain_promotion(void)
+{
+	uint32_t events[] = {MEM_ACCESS, CHAIN};
+	void *addr = malloc(PAGE_SIZE);
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	/* Only enable CHAIN counter */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x2, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn_el0(pmevcntr, 0),
+		"chain counter not counting if even counter is disabled");
+
+	/* Only enable even counter */
+	pmu_reset();
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
+		"odd counter did not increment on overflow if disabled");
+	report_info("MEM_ACCESS counter #0 has value %ld",
+		    read_regn_el0(pmevcntr, 0));
+	report_info("CHAIN counter #1 has value %ld",
+		    read_regn_el0(pmevcntr, 1));
+	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* disable the CHAIN event */
+	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+	report(read_sysreg(pmovsclr_el0) == 0x1,
+		"should have triggered an overflow on #0");
+	report(!read_regn_el0(pmevcntr, 1),
+		"CHAIN counter #1 shouldn't have incremented");
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
+
+	pmu_reset();
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
+		    read_sysreg(pmovsclr_el0));
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* enable the CHAIN event */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
+		"CHAIN counter #1 should have incremented and no overflow expected");
+
+	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
+		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* 0 becomes CHAINED */
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 1, 0x0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
+		"CHAIN counter #1 should have incremented and no overflow expected");
+
+	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
+		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0=0x%lx, counter #1=0x%lx",
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(read_sysreg(pmovsclr_el0) == 1,
+		"overflow is expected on counter 0");
+	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
 
 /*
@@ -794,6 +928,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_chained_sw_incr();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chain-promotion") == 0) {
+		report_prefix_push(argv[1]);
+		test_chain_promotion();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index d31dcbf..1b0c8c8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -108,6 +108,12 @@ groups = pmu
 arch = arm64
 extra_params = -append 'pmu-chained-sw-incr'
 
+[pmu-chain-promotion]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-chain-promotion'
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
