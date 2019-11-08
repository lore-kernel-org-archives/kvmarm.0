Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D837FC5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B769222C4
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B769222C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 530EA4AEDD;
	Fri,  8 Nov 2019 09:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GXIKzmzSblzq; Fri,  8 Nov 2019 09:43:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6064AEFC;
	Fri,  8 Nov 2019 09:43:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9AB44AECA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vET8YN0yQmfs for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8684AEE4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35E5446A;
 Fri,  8 Nov 2019 06:43:01 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18ADD3F719;
 Fri,  8 Nov 2019 06:42:59 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 08/17] arm: gic: Add simple SPI MP test
Date: Fri,  8 Nov 2019 14:42:31 +0000
Message-Id: <20191108144240.204202-9-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Shared Peripheral Interrupts (SPI) can target a specific CPU. Test this
feature by routing the test SPI to each of the vCPUs, then triggering it
and confirm its reception on that requested core.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index 63aa9f4..304b7b9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -620,16 +620,45 @@ static void spi_test_single(void)
 	check_acked("now enabled SPI fires", &cpumask);
 }
 
+static void spi_test_smp(void)
+{
+	int cpu;
+	int cores = 1;
+
+	wait_on_ready();
+	for_each_present_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+		spi_configure_irq(SPI_IRQ, cpu);
+		if (trigger_and_check_spi(NULL, IRQ_STAT_IRQ, cpu))
+			cores++;
+		else
+			report_info("SPI delivery failed on core %d", cpu);
+	}
+	report("SPI delievered on all cores", cores == nr_cpus);
+}
+
 static void spi_send(void)
 {
 	irqs_enable();
 
 	spi_test_single();
 
+	if (nr_cpus > 1)
+		spi_test_smp();
+
 	check_spurious();
 	exit(report_summary());
 }
 
+static void spi_test(void *data __unused)
+{
+	if (smp_processor_id() == 0)
+		spi_send();
+	else
+		irq_recv();
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -663,7 +692,7 @@ int main(int argc, char **argv)
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "irq") == 0) {
 		report_prefix_push(argv[1]);
-		spi_send();
+		on_cpus(spi_test, NULL);
 		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
