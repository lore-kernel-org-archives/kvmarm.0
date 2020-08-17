Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5DCC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:05:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A3542067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJykQ9i6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A3542067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0D54BFFD;
	Mon, 17 Aug 2020 06:05:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uRsEZ5jMMt5B; Mon, 17 Aug 2020 06:05:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 263524C01A;
	Mon, 17 Aug 2020 06:05:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 215284BFFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:05:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gj-8FGsBeG8M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:05:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D694BFFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:05:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658753;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MA2v3vE89FUu4aS1otniNGp24wVcz0FO7FYKp56xhsk=;
 b=CJykQ9i6zAXAUWiMGFxg1M6hNISfYFBaZeTvOHfahDU14XV6D4/1zvu+8RFZwACYG24Pyj
 e8YF2yzPz7o1Z6FJibyQpos9cIyBcPwCOe7s2C9cXuYy+kBzkVCzzPnrMFuP317jSjkAc3
 MoME35MbS/93ggmuKyWQF/t62IZWPpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-2DaIqkNZML6ZUrj4hKXtyA-1; Mon, 17 Aug 2020 06:05:49 -0400
X-MC-Unique: 2DaIqkNZML6ZUrj4hKXtyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DD281014DEE;
 Mon, 17 Aug 2020 10:05:48 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 903B9784A8;
 Mon, 17 Aug 2020 10:05:45 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 02/18] drivers/firmware/sdei: Add sdei_event_get_info()
Date: Mon, 17 Aug 2020 20:05:15 +1000
Message-Id: <20200817100531.83045-3-gshan@redhat.com>
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
References: <20200817100531.83045-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

This adds API sdei_event_get_info(), to be used when virtualized
SDEI is supported to retrieve the information about the specified
event.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 drivers/firmware/arm_sdei.c | 13 +++++++++++++
 include/linux/arm_sdei.h    |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 3b34501610f9..6bc84ab317d3 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -191,6 +191,19 @@ static int sdei_api_event_get_info(u32 event, u32 info, u64 *result)
 			      0, 0, result);
 }
 
+int sdei_event_get_info(u32 event_num, u32 info, u64 *result)
+{
+	int err;
+
+	mutex_lock(&sdei_events_lock);
+
+	err = sdei_api_event_get_info(event_num, info, result);
+
+	mutex_unlock(&sdei_events_lock);
+
+	return err;
+}
+
 static struct sdei_internal_event *sdei_event_create(u32 event_num,
 						     sdei_event_callback *cb,
 						     void *cb_arg)
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 447fe4ae8d8b..28d5d5853314 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -29,6 +29,8 @@ struct sdei_event {
 	u8			signaled;
 };
 
+int sdei_event_get_info(u32 event_num, u32 info, u64 *result);
+
 /*
  * Register your callback to claim an event. The event must be described
  * by firmware.
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
