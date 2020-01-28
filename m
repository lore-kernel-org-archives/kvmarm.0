Return-Path: <SRS0=H5Sr=3R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84BBC33C9E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:37:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91DE524686
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bOTkgTJC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91DE524686
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2944A7D9;
	Tue, 28 Jan 2020 05:37:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FCc9hEZLCdhh; Tue, 28 Jan 2020 05:37:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0444AC68;
	Tue, 28 Jan 2020 05:37:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 970C04A5C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:37:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V2nl4cWmr7+p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jan 2020 05:37:02 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753B74A5C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:37:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580207822;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=iejx/JZ1+EnGuUcmALEj4bgYElrakUr3k1rCRIjvnWk=;
 b=bOTkgTJCq6OhK5qYTfHbLo2eEz44h5FgNroCnNrTS2V4qPA7aS3ACyFdfvTn0F8KmpsAZJ
 Fle7bIhmNQDNfKRdCwiGBYxQPNVQmMtTwpC8hTPWaUG1n3agJSeZG+tMnmpAETZi72iQgg
 UlHtxcMExvE6mpJ3x6APTgzrMUlbga8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-8h2aoagmPQePo-TwIz8zLA-1; Tue, 28 Jan 2020 05:37:00 -0500
X-MC-Unique: 8h2aoagmPQePo-TwIz8zLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B199618C43C2;
 Tue, 28 Jan 2020 10:36:58 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CA9FD1001DD8;
 Tue, 28 Jan 2020 10:36:50 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 14/14] arm/arm64: ITS: pending table
 migration test
Date: Tue, 28 Jan 2020 11:34:59 +0100
Message-Id: <20200128103459.19413-15-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Add two new migration tests. One testing the migration of
a topology where collection were unmapped. The second test
checks the migration of the pending table.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- tests belong to both its and migration groups
---
 arm/gic.c         | 150 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  16 +++++
 2 files changed, 166 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index fa8626a..ec3dd3a 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -195,6 +195,7 @@ static void lpi_handler(struct pt_regs *regs __unused)
 	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
 	lpi_stats.observed.cpu_id = smp_processor_id();
 	lpi_stats.observed.lpi_id = irqnr;
+	acked[lpi_stats.observed.cpu_id]++;
 	smp_wmb(); /* pairs with rmb in check_lpi_stats */
 }
 
@@ -239,6 +240,18 @@ static void secondary_lpi_test(void)
 	while (1)
 		wfi();
 }
+
+static void check_lpi_hits(int *expected)
+{
+	int i;
+
+	for (i = 0; i < nr_cpus; i++) {
+		if (acked[i] != expected[i])
+			report(false, "expected %d LPIs on PE #%d, %d observed",
+			       expected[i], i, acked[i]);
+		}
+	report(true, "check LPI on all vcpus");
+}
 #endif
 
 static void gicv2_ipi_send_self(void)
@@ -594,6 +607,8 @@ static void gic_test_mmio(void)
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
 static void test_its_migration(void) {}
+static void test_migrate_unmapped_collection(void) {}
+static void test_its_pending_migration(void) {}
 
 #else /* __arch64__ */
 
@@ -666,6 +681,18 @@ static bool its_prerequisites(int nb_cpus)
 	return false;
 }
 
+static void set_lpi(struct its_device *dev, u32 eventid, u32 physid,
+		    struct its_collection *col)
+{
+	if (!dev || !col)
+		report_abort("wrong device or collection");
+
+	its_send_mapti(dev, physid, eventid, col);
+
+	gicv3_lpi_set_config(physid, LPI_PROP_DEFAULT);
+	its_send_invall(col);
+}
+
 /*
  * Setup the configuration for those mappings:
  * dev_id=2 event=20 -> vcpu 3, intid=8195
@@ -806,6 +833,121 @@ static void test_its_migration(void)
 	its_send_int(dev7, 255);
 	check_lpi_stats();
 }
+
+static void test_migrate_unmapped_collection(void)
+{
+	struct its_collection *col;
+	struct its_device *dev2, *dev7;
+	u8 config;
+
+	if (its_setup1())
+		return;
+
+	col = its_create_collection(nr_cpus - 1, nr_cpus - 1);
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+	/* MAPTI with the collection unmapped */
+	set_lpi(dev2, 0, 8192, col);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report(true, "Migration complete");
+
+	/* on the destination, map the collection */
+	its_send_mapc(col, true);
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats();
+
+	config = gicv3_lpi_get_config(8192);
+	report(config == LPI_PROP_DEFAULT,
+	       "Config of LPI 8192 was properly migrated");
+
+	lpi_stats_expect(nr_cpus - 1, 8192);
+	its_send_int(dev2, 0);
+	check_lpi_stats();
+
+	/* unmap the collection */
+	its_send_mapc(col, false);
+
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 0);
+	check_lpi_stats();
+
+	/* remap event 0 onto lpiid 8193 */
+	set_lpi(dev2, 0, 8193, col);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 0);
+	check_lpi_stats();
+
+	/* remap the collection */
+	its_send_mapc(col, true);
+	lpi_stats_expect(nr_cpus - 1, 8193);
+}
+
+static void test_its_pending_migration(void)
+{
+	struct its_device *dev;
+	struct its_collection *collection[2];
+	int expected[NR_CPUS];
+	u64 pendbaser;
+	void *ptr;
+	int i;
+
+	if (its_prerequisites(4))
+		return;
+
+	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	its_send_mapd(dev, true);
+
+	collection[0] = its_create_collection(nr_cpus - 1, nr_cpus - 1);
+	collection[1] = its_create_collection(nr_cpus - 2, nr_cpus - 2);
+	its_send_mapc(collection[0], true);
+	its_send_mapc(collection[1], true);
+
+	/* disable lpi at redist level */
+	gicv3_lpi_rdist_ctrl(nr_cpus - 1, false);
+	gicv3_lpi_rdist_ctrl(nr_cpus - 2, false);
+
+	/* even lpis are assigned to even cpu */
+	for (i = 0; i < 256; i++) {
+		struct its_collection *col = i % 2 ? collection[0] :
+						     collection[1];
+		int vcpu = col->target_address >> 16;
+
+		its_send_mapti(dev, 8192 + i, i, col);
+		gicv3_lpi_set_config(8192 + i, LPI_PROP_DEFAULT);
+		gicv3_lpi_set_pending_table_bit(vcpu, 8192 + i, true);
+	}
+	its_send_invall(collection[0]);
+	its_send_invall(collection[1]);
+
+	/* Set the PTZ bit on each pendbaser */
+
+	expected[nr_cpus - 1] = 128;
+	expected[nr_cpus - 2] = 128;
+
+	ptr = gicv3_data.redist_base[nr_cpus - 1] + GICR_PENDBASER;
+	pendbaser = readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	ptr = gicv3_data.redist_base[nr_cpus - 2] + GICR_PENDBASER;
+	pendbaser = readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	gicv3_lpi_rdist_ctrl(nr_cpus - 1, true);
+	gicv3_lpi_rdist_ctrl(nr_cpus - 2, true);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report(true, "Migration complete");
+
+	mdelay(1000);
+
+	check_lpi_hits(expected);
+}
 #endif
 
 int main(int argc, char **argv)
@@ -847,6 +989,14 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_migration();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-pending-migration")) {
+		report_prefix_push(argv[1]);
+		test_its_pending_migration();
+		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
+		report_prefix_push(argv[1]);
+		test_migrate_unmapped_collection();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 8b8ec79..d917157 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -144,6 +144,22 @@ extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
 arch = arm64
 
+[its-pending-migration]
+file = gic.flat
+smp = $MAX_SMP
+accel = kvm
+extra_params = -machine gic-version=3 -append 'its-pending-migration'
+groups = its migration
+arch = arm64
+
+[its-migrate-unmapped-collection]
+file = gic.flat
+smp = $MAX_SMP
+accel = kvm
+extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
+groups = its migration
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
