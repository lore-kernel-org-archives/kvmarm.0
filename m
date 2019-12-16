Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4418C43603
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:05:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98A16206A5
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 14:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHiULuDY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98A16206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5294C4A4AA;
	Mon, 16 Dec 2019 09:05:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S23QjkpXJvO1; Mon, 16 Dec 2019 09:05:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 187674A531;
	Mon, 16 Dec 2019 09:05:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 208A54A4AA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:05:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4wDXt+MfzJQV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 09:05:08 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2A34A4A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 09:05:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576505107;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=50Vms+tgESY3M8NHXPohpfNztkjGMy8JPeeKVTKoeLA=;
 b=QHiULuDYBgTwGGwW1mR8qFFL6QDM/Pog1adpOKfvfrFJYvsMG3Do47iXss2owwk9FGo9yF
 tQAfse6PyQruZkRY0o/A8/5eVQh0LnUB4kTYILXVT1+vz5KsicuJPT0F0rmOkocSwmD3sI
 vknW++xVUMWnB+ODRE0ANyRJZ5OwDiM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-i2RWS0w7O9OR_4XEIYzBcg-1; Mon, 16 Dec 2019 09:04:19 -0500
X-MC-Unique: i2RWS0w7O9OR_4XEIYzBcg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CCD180257B;
 Mon, 16 Dec 2019 14:04:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3242968863;
 Mon, 16 Dec 2019 14:04:14 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH 11/16] arm/arm64: ITS: Device and collection
 Initialization
Date: Mon, 16 Dec 2019 15:02:30 +0100
Message-Id: <20191216140235.10751-12-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Introduce an helper functions to register
- a new device, characterized by its device id and the
  max number of event IDs that dimension its ITT (Interrupt
  Translation Table).  The function allocates the ITT.

- a new collection, characterized by its ID and the
  target processing engine (PE).

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++
 lib/arm/gic-v3-its.c     | 46 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index ab639c5..245ef61 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -87,6 +87,9 @@
 
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
 
+#define GITS_MAX_DEVICES		8
+#define GITS_MAX_COLLECTIONS		8
+
 struct its_typer {
 	unsigned int ite_size;
 	unsigned int eventid_bits;
@@ -117,6 +120,17 @@ struct its_cmd_block {
 	u64     raw_cmd[4];
 };
 
+struct its_device {
+	u32 device_id;	/* device ID */
+	u32 nr_ites;	/* Max Interrupt Translation Entries */
+	void *itt;	/* Interrupt Translation Table GPA */
+};
+
+struct its_collection {
+	u64 target_address;
+	u16 col_id;
+};
+
 struct its_data {
 	void *base;
 	struct its_typer typer;
@@ -124,6 +138,10 @@ struct its_data {
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
 	struct its_cmd_block *cmd_readr;
+	struct its_device devices[GITS_MAX_DEVICES];
+	u32 nb_devices;		/* Allocated Devices */
+	struct its_collection collections[GITS_MAX_COLLECTIONS];
+	u32 nb_collections;	/* Allocated Collections */
 };
 
 extern struct its_data its_data;
@@ -140,6 +158,8 @@ extern u8 get_lpi_config(int n);
 extern void set_pending_table_bit(int rdist, int n, bool set);
 extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
+extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 9a51ef4..9906428 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -284,3 +284,49 @@ void its_enable_defaults(void)
 
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
 }
+
+struct its_device *its_create_device(u32 device_id, int nr_ites)
+{
+	struct its_baser *baser;
+	struct its_device *new;
+	unsigned long n, order;
+
+	if (its_data.nb_devices >= GITS_MAX_DEVICES)
+		report_abort("%s redimension GITS_MAX_DEVICES", __func__);
+
+	baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+	if (!baser)
+		return NULL;
+
+	new = &its_data.devices[its_data.nb_devices];
+
+	new->device_id = device_id;
+	new->nr_ites = nr_ites;
+
+	n = (baser->esz * nr_ites) >> PAGE_SHIFT;
+	order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	new->itt = (void *)virt_to_phys(alloc_pages(order));
+
+	its_data.nb_devices++;
+	return new;
+}
+
+struct its_collection *its_create_collection(u32 col_id, u32 pe)
+{
+	struct its_collection *new;
+
+	if (its_data.nb_collections >= GITS_MAX_COLLECTIONS)
+		report_abort("%s redimension GITS_MAX_COLLECTIONS", __func__);
+
+	new = &its_data.collections[its_data.nb_collections];
+
+	new->col_id = col_id;
+
+	if (its_data.typer.pta)
+		new->target_address = (u64)gicv3_data.redist_base[pe];
+	else
+		new->target_address = pe << 16;
+
+	its_data.nb_collections++;
+	return new;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
