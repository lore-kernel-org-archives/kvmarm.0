Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC13C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:05:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79B182067C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 10:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZAWoVi7b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79B182067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3D84C00D;
	Mon, 17 Aug 2020 06:05:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iXntWEEJJ1b3; Mon, 17 Aug 2020 06:05:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D99734BF95;
	Mon, 17 Aug 2020 06:05:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 068CC4BF95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:05:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bcar-nQc4FrP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 06:05:48 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AFED4BF8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 06:05:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597658748;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6AlofgTqUEw/nGPN1bXhtMBOTHIkm8lMFe6ktm3rCzQ=;
 b=ZAWoVi7bHQA6bi4Q+L/soFqQ0CakPw8zj+4C9WSlrBtyfCvDv6pIJpmyPoiDTtY1ZCGfSf
 tSLMSh/EWi8VzoSfQy/0/1JKAVRM5UMcE23dndCz232Tj8/UuErlPK9e4KZlx/bcCrcCDz
 NUZFuA2iIwDBlcxP07lrCiUm91keSYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-BMgFa0lTM4mkS7urHgAJhw-1; Mon, 17 Aug 2020 06:05:46 -0400
X-MC-Unique: BMgFa0lTM4mkS7urHgAJhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3B8918686C1;
 Mon, 17 Aug 2020 10:05:44 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6F178414;
 Mon, 17 Aug 2020 10:05:41 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 01/18] drivers/firmware/sdei: Retrieve event signaled property
 on registration
Date: Mon, 17 Aug 2020 20:05:14 +1000
Message-Id: <20200817100531.83045-2-gshan@redhat.com>
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

This retrieves the event signaled property when it's created for the
first time. The property will be needed when SDEI virtualization is
supported.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 drivers/firmware/arm_sdei.c | 6 ++++++
 include/linux/arm_sdei.h    | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 9c7a6a7c9527..3b34501610f9 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -225,6 +225,12 @@ static struct sdei_internal_event *sdei_event_create(u32 event_num,
 		goto fail;
 	event->type = result;
 
+	err = sdei_api_event_get_info(event_num, SDEI_EVENT_INFO_EV_SIGNALED,
+				      &result);
+	if (err)
+		goto fail;
+	event->signaled = result;
+
 	if (event->type == SDEI_EVENT_TYPE_SHARED) {
 		reg = kzalloc(sizeof(*reg), GFP_KERNEL);
 		if (!reg) {
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 2723a99937f3..447fe4ae8d8b 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -26,6 +26,7 @@ struct sdei_event {
 	u32			event_num;
 	u8			type;
 	u8			priority;
+	u8			signaled;
 };
 
 /*
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
