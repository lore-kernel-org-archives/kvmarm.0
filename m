Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A9BC43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:54:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D6C82074D
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 14:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i7dOatTT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D6C82074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBF584B184;
	Thu,  2 Apr 2020 10:54:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sSpC3eBQgvJr; Thu,  2 Apr 2020 10:54:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF9B4B177;
	Thu,  2 Apr 2020 10:54:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 854534B0C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:54:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qjdLtqc-JLDz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 10:54:00 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6714B189
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 10:54:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585839240;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J4DOH8XWli/HMNH/+OslqOJNq8kw0A9oWrDd1ayDlhY=;
 b=i7dOatTTmLn5RPwxOJk5OPhQZRzZv1FmaC84AINojGH/pH0R58CFy/b8s/Fk0MUUl1EH/w
 FaCY2phfjP11+JDRBkNw6lAKBNYF2h3vj6A39/E4nn1Hvillv4CCAehh58IDqK+DJgmqxp
 3nZ4mTuaQFuMCMtyjJGEDkfdaINrtn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-bdL7AMF_NKWBZ_kweFWuBA-1; Thu, 02 Apr 2020 10:53:56 -0400
X-MC-Unique: bdL7AMF_NKWBZ_kweFWuBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A56D1107B267;
 Thu,  2 Apr 2020 14:53:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AB5E45D9C9;
 Thu,  2 Apr 2020 14:53:51 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v8 12/13] arm/arm64: ITS: migration tests
Date: Thu,  2 Apr 2020 16:52:26 +0200
Message-Id: <20200402145227.20109-13-eric.auger@redhat.com>
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

This test maps LPIs (populates the device table, the collection table,
interrupt translation tables, configuration table), migrates and make
sure the translation is correct on the destination.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---

v7 -> v8:
- typo: s/en PE #3/on PE #3/
- added Zenghui's R-b

v4 -> v5:
- move stub from header to arm/gic.c

v3 -> v4:
- assert in its_get_device/collection if the id is not found
---
 arm/gic.c                  | 58 ++++++++++++++++++++++++++++++++++----
 arm/unittests.cfg          |  8 ++++++
 lib/arm64/asm/gic-v3-its.h |  3 ++
 lib/arm64/gic-v3-its.c     | 22 +++++++++++++++
 4 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 54ae83d..6ae5515 100644
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
@@ -750,6 +769,29 @@ static void test_its_trigger(void)
 	check_lpi_stats("no LPI after device unmap");
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
+	report_info("Migration complete");
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
@@ -787,6 +829,10 @@ int main(int argc, char **argv)
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
index b9a7a2c..480adec 100644
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
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index c203293..0258daa 100644
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
index ca91c3d..c22bda3 100644
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
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
