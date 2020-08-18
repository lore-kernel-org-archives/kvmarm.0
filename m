Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F30C433E3
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52B3E206DA
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 01:13:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLcSNKNF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52B3E206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BFA94C294;
	Mon, 17 Aug 2020 21:13:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GH4FddZbV3mT; Mon, 17 Aug 2020 21:13:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 267194C295;
	Mon, 17 Aug 2020 21:13:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0DE4C29E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S3GdeWTKigkW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 21:13:51 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 964514B3F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 21:13:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597713230;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=suPSmMRvwoRNvZlehurO157MDIex678E3Y229NuAwBY=;
 b=hLcSNKNFtb3BH/A2lrJoCySGqm72+udtvBJuugSNsFFzjDiQLAzlDxclFl5g3IZcWm4rKA
 gJal9wncP2bNvcZan+fBv0Q5Idzp7KEsYer8qOsxBuzPubVj/J9h/GKqH3p+R86qRoY06D
 R+iIpIak6mzcr+zeYI1crN1Mb1NKSdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-tSRgpnTHOR2I65AWSSw35Q-1; Mon, 17 Aug 2020 21:13:47 -0400
X-MC-Unique: tSRgpnTHOR2I65AWSSw35Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9931C1005E62;
 Tue, 18 Aug 2020 01:13:45 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTP id CFE395D9D2;
 Tue, 18 Aug 2020 01:13:42 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 5/6] drivers/acpi: Import ACPI APF table
Date: Tue, 18 Aug 2020 11:13:18 +1000
Message-Id: <20200818011319.91777-6-gshan@redhat.com>
In-Reply-To: <20200818011319.91777-1-gshan@redhat.com>
References: <20200818011319.91777-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com, will@kernel.org
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

This defines the struct for ACPI APF table. The information included
in this table will be used by guest kernel to retrieve SDEI event
number, PPI number and its triggering properties:

   * @sdei_event: number of SDEI event used for page-not-present
   * @interrupt:  PPI used for page-ready
   * @interrupt_flags: PPI's mode and polarity

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 include/acpi/actbl2.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index ec66779cb193..2eb715f4463b 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -44,6 +44,7 @@
 #define ACPI_SIG_SDEI           "SDEI"	/* Software Delegated Exception Interface Table */
 #define ACPI_SIG_SDEV           "SDEV"	/* Secure Devices table */
 #define ACPI_SIG_NHLT           "NHLT"	/* Non-HDAudio Link Table */
+#define ACPI_SIG_APFT           "APFT"  /* Asynchronous Page Fault Table */
 
 /*
  * All tables must be byte-packed to match the ACPI specification, since
@@ -1737,6 +1738,23 @@ struct acpi_sdev_pcie_path {
 	u8 function;
 };
 
+/*******************************************************************************
+ *
+ * APFT - Asynchronous Page Fault Table
+ *
+ * Customized table used for asynchronous page fault on ARM
+ *
+ ******************************************************************************/
+struct acpi_table_apft {
+	struct acpi_table_header header;
+	u32 sdei_event;
+	u32 interrupt;
+	u32 interrupt_flags;
+};
+
+#define ACPI_APFT_INTERRUPT_MODE	(1)
+#define ACPI_APFT_INTERRUPT_POLARITY	(1<<1)
+
 /* Reset to default packing */
 
 #pragma pack()
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
