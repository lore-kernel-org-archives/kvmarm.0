Return-Path: <SRS0=H5Sr=3R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF92C33CB3
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 696262467E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrcCg28f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 696262467E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21EF14A7D9;
	Tue, 28 Jan 2020 05:36:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rCUiwa9BpzvU; Tue, 28 Jan 2020 05:36:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E88E44A5C3;
	Tue, 28 Jan 2020 05:36:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1624A4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gIlrumGZWJOO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jan 2020 05:36:54 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F5D4A5C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580207813;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=K7xClZeAzAhgTph2V9BhHIcpidTH43JOzyIXf0zlJ/g=;
 b=HrcCg28fn1NXA2Cz2Voq3pAL0dItLjW2NzM486ox2oPJ+HgN2gYMnrLzVyB0NqqgXFBoAJ
 lmyOhkdPo5fBuOmy8dP/yaxW787KyURLOu//Io3J8INxGwU0qzA0EbBjzMe4OcfZgQ1mp1
 xu1mv9B1IW5oRgEhrrkdlVmu3ozgo8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-UG3wMHMNNiSvYC7irf-cqQ-1; Tue, 28 Jan 2020 05:36:52 -0500
X-MC-Unique: UG3wMHMNNiSvYC7irf-cqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12447800D53;
 Tue, 28 Jan 2020 10:36:50 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 52B201001B08;
 Tue, 28 Jan 2020 10:36:43 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 13/14] arm/arm64: ITS: migration tests
Date: Tue, 28 Jan 2020 11:34:58 +0100
Message-Id: <20200128103459.19413-14-eric.auger@redhat.com>
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

This test maps LPIs (populates the device table, the collection table,
interrupt translation tables, configuration table), migrates and make
sure the translation is correct on the destination.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/gic.c                | 59 ++++++++++++++++++++++++++++++++++++----
 arm/unittests.cfg        |  8 ++++++
 lib/arm/asm/gic-v3-its.h |  2 ++
 lib/arm/gic-v3-its.c     | 22 +++++++++++++++
 4 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 50104b1..fa8626a 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -593,6 +593,7 @@ static void gic_test_mmio(void)
 
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
+static void test_its_migration(void) {}
 
 #else /* __arch64__ */
 
@@ -665,13 +666,19 @@ static bool its_prerequisites(int nb_cpus)
 	return false;
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
@@ -685,14 +692,10 @@ static void test_its_trigger(void)
 	its_send_invall(col2);
 	its_send_invall(col3);
 
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
 
@@ -703,6 +706,23 @@ static void test_its_trigger(void)
 		       20 /* event id */, col3);
 	its_send_mapti(dev7, 8196 /* lpi id */,
 		       255 /* event id */, col2);
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3, *col2;
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	col3 = its_get_collection(3);
+	col2 = its_get_collection(2);
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+	report_prefix_push("int");
 
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
@@ -763,6 +783,29 @@ static void test_its_trigger(void)
 	check_lpi_stats();
 	report_prefix_pop();
 }
+
+static void test_its_migration(void)
+{
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report(true, "Migration complete");
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats();
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats();
+}
 #endif
 
 int main(int argc, char **argv)
@@ -800,6 +843,10 @@ int main(int argc, char **argv)
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
index bfafec5..8b8ec79 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -136,6 +136,14 @@ extra_params = -machine gic-version=3 -append 'its-trigger'
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
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 0e5c5b6..febc2b2 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -151,6 +151,8 @@ extern void its_send_invall(struct its_collection *col);
 extern void its_send_movi(struct its_device *dev,
 			  struct its_collection *col, u32 id);
 extern void its_send_sync(struct its_collection *col);
+extern struct its_device *its_get_device(u32 id);
+extern struct its_collection *its_get_collection(u32 id);
 
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
 #define ITS_FLAGS_WORKAROUND_CAVIUM_22375       (1ULL << 1)
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index c2dcd01..099940e 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -219,3 +219,25 @@ struct its_collection *its_create_collection(u32 col_id, u32 pe)
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
+	return NULL;
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
+	return NULL;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
