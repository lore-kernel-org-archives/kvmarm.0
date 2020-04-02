Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22896C2D0F3
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D029C20757
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJToJ+Q2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D029C20757
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75E704B142;
	Thu,  2 Apr 2020 10:53:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1EqwkDvr1u-S; Thu,  2 Apr 2020 10:53:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245EA4B0C7;
	Thu,  2 Apr 2020 10:53:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E7B4B142
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:53:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uALPxpWkUMem for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 10:53:51 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C10624B0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:53:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585839231;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0g7p+ohcESb2t9evPZIZBxOZPO5omYZTwjq3f479mGE=;
 b=HJToJ+Q2R2OV6gPxPiQddevZEct3lo9LjdYSmIa3HLHbMHdGvuXmtJrTuZu5zPq/Bcme0g
 xLcDntaqnC5kY9BTce9EHihBgVEA/KTcJ2xU71S201aertB5GYDR79oRhoj0jNhCjIyNk4
 NWI3YJrIPOkr7A4kF6/8h4l3mkTyVbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-7xcPsepSM4WBXt5sOfF0yg-1; Thu, 02 Apr 2020 10:53:47 -0400
X-MC-Unique: 7xcPsepSM4WBXt5sOfF0yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DAF618C35A2;
 Thu,  2 Apr 2020 14:53:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 52A4D5D9C9;
 Thu,  2 Apr 2020 14:53:42 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v8 10/13] arm/arm64: ITS: INT functional tests
Date: Thu,  2 Apr 2020 16:52:24 +0200
Message-Id: <20200402145227.20109-11-eric.auger@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: andre.przywara@arm.com, thuth@redhat.com
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

Triggers LPIs through the INT command.

the test checks the LPI hits the right CPU and triggers
the right LPI intid, ie. the translation is correct.

Updates to the config table also are tested, along with inv
and invall commands.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---
v7 -> v8:
- change the logic of check_lpi_stats()

v5 -> v6:
- removed collection-unmap test
- moved the collection invalidation after the MAPCs

v4 -> v5:
- move the test stub from the header to arm/gic.c

v3 -> v4:
- assert in lpi_handler if the interrupt is not an LPI
- remove check_lpi_stats from its_prerequisites()

v2 -> v3:
- add comments
- keep the report_skip in case there aren't 4 vcpus to be able to
  run other tests in the its category.
- fix the prefix pop
- move its_event and its_stats to arm/gic.c
---
 arm/gic.c         | 217 +++++++++++++++++++++++++++++++++++++++++++---
 arm/unittests.cfg |   7 ++
 2 files changed, 213 insertions(+), 11 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 649ed81..54ae83d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -159,6 +159,87 @@ static void ipi_handler(struct pt_regs *regs __unused)
 	}
 }
 
+static void setup_irq(irq_handler_fn handler)
+{
+	gic_enable_defaults();
+#ifdef __arm__
+	install_exception_handler(EXCPTN_IRQ, handler);
+#else
+	install_irq_handler(EL1H_IRQ, handler);
+#endif
+	local_irq_enable();
+}
+
+#if defined(__aarch64__)
+struct its_event {
+	int cpu_id;
+	int lpi_id;
+};
+
+struct its_stats {
+	struct its_event expected;
+	struct its_event observed;
+};
+
+static struct its_stats lpi_stats;
+
+static void lpi_handler(struct pt_regs *regs __unused)
+{
+	u32 irqstat = gic_read_iar();
+	int irqnr = gic_iar_irqnr(irqstat);
+
+	gic_write_eoir(irqstat);
+	assert(irqnr >= 8192);
+	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
+	lpi_stats.observed.cpu_id = smp_processor_id();
+	lpi_stats.observed.lpi_id = irqnr;
+	smp_wmb(); /* pairs with rmb in check_lpi_stats */
+}
+
+static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
+{
+	lpi_stats.expected.cpu_id = exp_cpu_id;
+	lpi_stats.expected.lpi_id = exp_lpi_id;
+	lpi_stats.observed.cpu_id = -1;
+	lpi_stats.observed.lpi_id = -1;
+	smp_wmb(); /* pairs with rmb in handler */
+}
+
+static void check_lpi_stats(const char *msg)
+{
+	int i;
+
+	for (i = 0; i < 50; i++) {
+		mdelay(100);
+		smp_rmb(); /* pairs with wmb in lpi_handler */
+		if (lpi_stats.observed.cpu_id == lpi_stats.expected.cpu_id &&
+		    lpi_stats.observed.lpi_id == lpi_stats.expected.lpi_id) {
+			report(true, "%s", msg);
+			return;
+		}
+	}
+
+	if (lpi_stats.observed.cpu_id == -1 && lpi_stats.observed.lpi_id == -1) {
+		report_info("No LPI received whereas (cpuid=%d, intid=%d) "
+			    "was expected", lpi_stats.expected.cpu_id,
+			    lpi_stats.expected.lpi_id);
+	} else {
+		report_info("Unexpected LPI (cpuid=%d, intid=%d)",
+			    lpi_stats.observed.cpu_id,
+			    lpi_stats.observed.lpi_id);
+	}
+	report(false, "%s", msg);
+}
+
+static void secondary_lpi_test(void)
+{
+	setup_irq(lpi_handler);
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	while (1)
+		wfi();
+}
+#endif
+
 static void gicv2_ipi_send_self(void)
 {
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
@@ -216,17 +297,6 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
 
-static void setup_irq(irq_handler_fn handler)
-{
-	gic_enable_defaults();
-#ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, handler);
-#else
-	install_irq_handler(EL1H_IRQ, handler);
-#endif
-	local_irq_enable();
-}
-
 static void ipi_send(void)
 {
 	setup_irq(ipi_handler);
@@ -521,6 +591,7 @@ static void gic_test_mmio(void)
 #if defined(__arm__)
 
 static void test_its_introspection(void) {}
+static void test_its_trigger(void) {}
 
 #else /* __aarch64__ */
 
@@ -559,6 +630,126 @@ static void test_its_introspection(void)
 	report_info("collection table entry_size = 0x%x", coll_baser->esz);
 }
 
+static int its_prerequisites(int nb_cpus)
+{
+	int cpu;
+
+	if (!gicv3_its_base()) {
+		report_skip("No ITS, skip ...");
+		return -1;
+	}
+
+	if (nr_cpus < nb_cpus) {
+		report_skip("Test requires at least %d vcpus", nb_cpus);
+		return -1;
+	}
+
+	stats_reset();
+
+	setup_irq(lpi_handler);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		smp_boot_secondary(cpu, secondary_lpi_test);
+	}
+	wait_on_ready();
+
+	its_enable_defaults();
+
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3, *col2;
+	struct its_device *dev2, *dev7;
+
+	if (its_prerequisites(4))
+		return;
+
+	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
+
+	col3 = its_create_collection(3 /* col id */, 3/* target PE */);
+	col2 = its_create_collection(2 /* col id */, 2/* target PE */);
+
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
+	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
+
+	report_prefix_push("int");
+	/*
+	 * dev=2, eventid=20  -> lpi= 8195, col=3
+	 * dev=7, eventid=255 -> lpi= 8196, col=2
+	 * Trigger dev2, eventid=20 and dev7, eventid=255
+	 * Check both LPIs hit
+	 */
+
+	its_send_mapd(dev2, true);
+	its_send_mapd(dev7, true);
+
+	its_send_mapc(col3, true);
+	its_send_mapc(col2, true);
+
+	its_send_invall(col2);
+	its_send_invall(col3);
+
+	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
+	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev=2, eventid=20  -> lpi= 8195, col=3");
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev=7, eventid=255 -> lpi= 8196, col=2");
+
+	report_prefix_pop();
+
+	report_prefix_push("inv/invall");
+
+	/*
+	 * disable 8195, check dev2/eventid=20 does not trigger the
+	 * corresponding LPI
+	 */
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED);
+	its_send_inv(dev2, 20);
+
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=20 does not trigger any LPI");
+
+	/*
+	 * re-enable the LPI but willingly do not call invall
+	 * so the change in config is not taken into account.
+	 * The LPI should not hit
+	 */
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=20 still does not trigger any LPI");
+
+	/* Now call the invall and check the LPI hits */
+	its_send_invall(col3);
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
+
+	report_prefix_pop();
+
+	report_prefix_push("mapd valid=false");
+	/*
+	 * Unmap device 2 and check the eventid 20 formerly
+	 * attached to it does not hit anymore
+	 */
+
+	its_send_mapd(dev2, false);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("no LPI after device unmap");
+	report_prefix_pop();
+}
 #endif
 
 int main(int argc, char **argv)
@@ -592,6 +783,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		gic_test_mmio();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-trigger")) {
+		report_prefix_push(argv[1]);
+		test_its_trigger();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 23d378e..b9a7a2c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -129,6 +129,13 @@ extra_params = -machine gic-version=3 -append 'its-introspection'
 groups = its
 arch = arm64
 
+[its-trigger]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'its-trigger'
+groups = its
+arch = arm64
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
