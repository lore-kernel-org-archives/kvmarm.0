Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491BDC2D0F3
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 18:02:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BCFEB206F6
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 18:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bbu75Kuk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCFEB206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EFD4B154;
	Thu,  2 Apr 2020 14:02:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id htRpool69eXE; Thu,  2 Apr 2020 14:02:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315384B107;
	Thu,  2 Apr 2020 14:02:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADFA4B0F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 14:02:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nkql5V1UDyhN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 14:02:08 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 200F14B0C9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 14:02:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585850527;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Tjp557QoSwX1zXO0Qt6n7kWqUIk7/59D04dmkiPODOE=;
 b=bbu75KukY0+WDO5Sb4UqSPMNfTWykKZ2uzm1YgLefeNoL9tOQDfsBRc421tuSwb/e3oYX7
 Cxcp/RjG2M1n8jx+nJlIoG9+67vVuBYoZieqqnCQvnzpFQ6ctSkUqbG2pNFbp3+q6x7Ih7
 vNtcklCOp180V2e4H9NqLSaWKThgdn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-PBDxcm1jN-qIMcFRkyICVA-1; Thu, 02 Apr 2020 14:02:05 -0400
X-MC-Unique: PBDxcm1jN-qIMcFRkyICVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D257B13F6;
 Thu,  2 Apr 2020 18:01:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E3CBD118F22;
 Thu,  2 Apr 2020 18:01:50 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [PATCH kvm-unit-tests] fixup! arm/arm64: ITS: pending table migration
 test
Date: Thu,  2 Apr 2020 20:01:48 +0200
Message-Id: <20200402180148.490026-1-drjones@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: thuth@redhat.com, andre.przywara@arm.com
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

[ Without the fix this test would hang, as timeouts don't work with
  the migration scripts (yet). Use errata to skip instead of hang. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c  | 18 ++++++++++++++++--
 errata.txt |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ddf0f9d09b14..c0781f8c2c80 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -12,6 +12,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -812,13 +813,23 @@ static void test_its_migration(void)
 	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
 }
 
+#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
+
 static void test_migrate_unmapped_collection(void)
 {
-	struct its_collection *col;
-	struct its_device *dev2, *dev7;
+	struct its_collection *col = NULL;
+	struct its_device *dev2 = NULL, *dev7 = NULL;
+	bool test_skipped = false;
 	int pe0 = 0;
 	u8 config;
 
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+		report_skip("Skipping test, as this test hangs without the fix. "
+			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
+		test_skipped = true;
+		goto do_migrate;
+	}
+
 	if (its_setup1())
 		return;
 
@@ -830,9 +841,12 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
 
+do_migrate:
 	puts("Now migrate the VM, then press a key to continue...\n");
 	(void)getchar();
 	report_info("Migration complete");
+	if (test_skipped)
+		return;
 
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
diff --git a/errata.txt b/errata.txt
index 7d6abc2a7bf6..b66afaa9c079 100644
--- a/errata.txt
+++ b/errata.txt
@@ -5,4 +5,5 @@
 9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix AArch32 cycle counter access
 7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulate the EL1 phys timer registers
 6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
+8c58be34494b    : 5.6                           : KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
 #---------------:-------------------------------:---------------------------------------------------
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
