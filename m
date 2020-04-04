Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E78BC2BA1A
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2928F206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJgqSLHL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2928F206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D91B54B26E;
	Sat,  4 Apr 2020 10:39:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cb4GuqtKRa10; Sat,  4 Apr 2020 10:39:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8474B285;
	Sat,  4 Apr 2020 10:39:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70E714B179
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Se86tFIRBOy for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:39:34 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B7304B270
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011173;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QNG141TmX85y30XV5pUtpTniRxPlixz+Zq4HHGjDFaQ=;
 b=gJgqSLHLnCs6ZPE8gyJJ4l1NC1NT0j9JQ6yGsu7LX6YPexHZfjhhNtOVinazZmocgpCuYd
 0o7Ldiix8K/OefUjXhGvHkF8TqsuyUad28nkSBNBaTQnxIuxuu3TIBqgrl4x/g5ZoQV30r
 K4v3vHyRp4FFLN5STsmXj6AXVxIkfsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-THYbQIZAO1O17HkrSuL1ZA-1; Sat, 04 Apr 2020 10:39:30 -0400
X-MC-Unique: THYbQIZAO1O17HkrSuL1ZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A70B41005516;
 Sat,  4 Apr 2020 14:39:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2EEB39B912;
 Sat,  4 Apr 2020 14:39:28 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 38/39] arm/arm64: ITS: migration tests
Date: Sat,  4 Apr 2020 16:37:30 +0200
Message-Id: <20200404143731.208138-39-drjones@redhat.com>
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

This test maps LPIs (populates the device table, the collection table,
interrupt translation tables, configuration table), migrates and make
sure the translation is correct on the destination.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
[ Complete migration even when the test is skipped. Otherwise the
  migration scripts hang. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c                  | 64 ++++++++++++++++++++++++++++++++++----
 arm/unittests.cfg          |  8 +++++
 lib/arm64/asm/gic-v3-its.h |  3 ++
 lib/arm64/gic-v3-its.c     | 22 +++++++++++++
 4 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 54ae83d26eb9..d98d70a5d9e9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -592,6 +592,7 @@ static void gic_test_mmio(void)
 
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
+static void test_its_migration(void) {}
 
 #else /* __aarch64__ */
 
@@ -660,13 +661,19 @@ static int its_prerequisites(int nb_cpus)
 	return 0;
 }
 
-static void test_its_trigger(void)
+/*
+ * Setup the configuration for those mappings:
+ * dev_id=2 event=20 -> vcpu 3, intid=8195
+ * dev_id=7 event=255 -> vcpu 2, intid=8196
+ * LPIs ready to hit
+ */
+static int its_setup1(void)
 {
 	struct its_collection *col3, *col2;
 	struct its_device *dev2, *dev7;
 
 	if (its_prerequisites(4))
-		return;
+		return -1;
 
 	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
@@ -677,14 +684,10 @@ static void test_its_trigger(void)
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
 	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
 
-	report_prefix_push("int");
 	/*
 	 * dev=2, eventid=20  -> lpi= 8195, col=3
 	 * dev=7, eventid=255 -> lpi= 8196, col=2
-	 * Trigger dev2, eventid=20 and dev7, eventid=255
-	 * Check both LPIs hit
 	 */
-
 	its_send_mapd(dev2, true);
 	its_send_mapd(dev7, true);
 
@@ -696,6 +699,22 @@ static void test_its_trigger(void)
 
 	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
 	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3;
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	col3 = its_get_collection(3);
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+	report_prefix_push("int");
 
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
@@ -750,6 +769,35 @@ static void test_its_trigger(void)
 	check_lpi_stats("no LPI after device unmap");
 	report_prefix_pop();
 }
+
+static void test_its_migration(void)
+{
+	struct its_device *dev2, *dev7;
+	bool test_skipped = false;
+
+	if (its_setup1()) {
+		test_skipped = true;
+		goto do_migrate;
+	}
+
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+do_migrate:
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+	if (test_skipped)
+		return;
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
+}
 #endif
 
 int main(int argc, char **argv)
@@ -787,6 +835,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_trigger();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migration")) {
+		report_prefix_push(argv[1]);
+		test_its_migration();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 47f9446adcc3..20a1ae269571 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -191,6 +191,14 @@ extra_params = -machine gic-version=3 -append 'its-trigger'
 groups = its
 arch = arm64
 
+[its-migration]
+file = gic.flat
+smp = $MAX_SMP
+accel = kvm
+extra_params = -machine gic-version=3 -append 'its-migration'
+groups = its migration
+arch = arm64
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index c203293a7838..0258daa15709 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -168,4 +168,7 @@ extern void __its_send_sync(struct its_collection *col, bool verbose);
 #define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, false)
 #define its_send_sync_nv(col)				__its_send_sync(col, false)
 
+extern struct its_device *its_get_device(u32 id);
+extern struct its_collection *its_get_collection(u32 id);
+
 #endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index ca91c3dd1108..c22bda3a8ba2 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -147,3 +147,25 @@ struct its_collection *its_create_collection(u16 col_id, u32 pe)
 	its_data.nr_collections++;
 	return new;
 }
+
+struct its_device *its_get_device(u32 id)
+{
+	int i;
+
+	for (i = 0; i < GITS_MAX_DEVICES; i++) {
+		if (its_data.devices[i].device_id == id)
+			return &its_data.devices[i];
+	}
+	assert(0);
+}
+
+struct its_collection *its_get_collection(u32 id)
+{
+	int i;
+
+	for (i = 0; i < GITS_MAX_COLLECTIONS; i++) {
+		if (its_data.collections[i].col_id == id)
+			return &its_data.collections[i];
+	}
+	assert(0);
+}
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
