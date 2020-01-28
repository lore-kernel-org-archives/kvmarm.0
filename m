Return-Path: <SRS0=H5Sr=3R=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B73C33C9E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B24972467E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jan 2020 10:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LujidaQN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B24972467E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A4CC4ACD5;
	Tue, 28 Jan 2020 05:36:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QEAUqY5dsx2Z; Tue, 28 Jan 2020 05:36:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E874AC65;
	Tue, 28 Jan 2020 05:36:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 324034A98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7jHXRicP-uI4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jan 2020 05:36:25 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 364844AC6C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jan 2020 05:36:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580207785;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ubJcGFSByeAYXmA6ZsXY2QS9ypGCX/uJRAkeSeWnSn8=;
 b=LujidaQNPhdQadnWYKyHegBS9v5j6zNNLqwFvHJkAUDADz7JM3LbETTSvTMocn0z8jkXhl
 iabEpSwVMai++7D7DnlBRWuTxSgGGOt3kopG0rv7uVyIdMhUzNh9UJI/bsECPcWUlEyMQ0
 1WbQHthmz6tVy25dOjmkied2PRcr3cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-DQXSTh9CMxKCq8ZczajPmw-1; Tue, 28 Jan 2020 05:36:23 -0500
X-MC-Unique: DQXSTh9CMxKCq8ZczajPmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2DBDB60;
 Tue, 28 Jan 2020 10:36:21 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 362721001B30;
 Tue, 28 Jan 2020 10:36:15 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 09/14] arm/arm64: ITS: Device and collection
 Initialization
Date: Tue, 28 Jan 2020 11:34:54 +0100
Message-Id: <20200128103459.19413-10-eric.auger@redhat.com>
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

Introduce an helper functions to register
- a new device, characterized by its device id and the
  max number of event IDs that dimension its ITT (Interrupt
  Translation Table).  The function allocates the ITT.

- a new collection, characterized by its ID and the
  target processing engine (PE).

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- s/report_abort/assert

v1 -> v2:
- s/nb_/nr_
---
 lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++-
 lib/arm/gic-v3-its.c     | 44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index fe73c04..acd97a9 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -31,6 +31,19 @@ struct its_baser {
 };
 
 #define GITS_BASER_NR_REGS              8
+#define GITS_MAX_DEVICES		8
+#define GITS_MAX_COLLECTIONS		8
+
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
 
 struct its_data {
 	void *base;
@@ -38,6 +51,10 @@ struct its_data {
 	struct its_baser baser[GITS_BASER_NR_REGS];
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
+	struct its_device devices[GITS_MAX_DEVICES];
+	u32 nr_devices;		/* Allocated Devices */
+	struct its_collection collections[GITS_MAX_COLLECTIONS];
+	u32 nr_collections;	/* Allocated Collections */
 };
 
 extern struct its_data its_data;
@@ -90,7 +107,6 @@ extern struct its_data its_data;
 #define GITS_BASER_TYPE_DEVICE		1
 #define GITS_BASER_TYPE_COLLECTION	4
 
-
 struct its_cmd_block {
 	u64 raw_cmd[4];
 };
@@ -100,6 +116,8 @@ extern void its_init(void);
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern struct its_baser *its_lookup_baser(int type);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
+extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
 
 #else /* __arm__ */
 
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index d1e7e52..c2dcd01 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -175,3 +175,47 @@ void its_enable_defaults(void)
 
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
 }
+
+struct its_device *its_create_device(u32 device_id, int nr_ites)
+{
+	struct its_baser *baser;
+	struct its_device *new;
+	unsigned long n, order;
+
+	assert(its_data.nr_devices < GITS_MAX_DEVICES);
+
+	baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+	if (!baser)
+		return NULL;
+
+	new = &its_data.devices[its_data.nr_devices];
+
+	new->device_id = device_id;
+	new->nr_ites = nr_ites;
+
+	n = (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
+	order = is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	new->itt = (void *)virt_to_phys(alloc_pages(order));
+
+	its_data.nr_devices++;
+	return new;
+}
+
+struct its_collection *its_create_collection(u32 col_id, u32 pe)
+{
+	struct its_collection *new;
+
+	assert(its_data.nr_collections < GITS_MAX_COLLECTIONS);
+
+	new = &its_data.collections[its_data.nr_collections];
+
+	new->col_id = col_id;
+
+	if (its_data.typer.pta)
+		new->target_address = (u64)gicv3_data.redist_base[pe];
+	else
+		new->target_address = pe << 16;
+
+	its_data.nr_collections++;
+	return new;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
