Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FFFC2BD09
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:27:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 750F4206DF
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 17:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDxL6DE/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 750F4206DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 224684AEDE;
	Fri,  6 Dec 2019 12:27:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HdKfFB695ThU; Fri,  6 Dec 2019 12:27:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B46CD4AF1B;
	Fri,  6 Dec 2019 12:27:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A49C84AECE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:27:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zuOGGXUkgSqz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 12:27:46 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E15C4AF1D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 12:27:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575653265;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lZIWyVz0mXJm3WKdFFZ/MDv4wbAF4ZdIGNT+t+b1NIM=;
 b=gDxL6DE/1IjAi8VzFP4328+FXyLjs1PkxQMtPLyTulAm4D5a+n6lJMX0vtji190ALhfULQ
 oSZuMVyfE1Yf56EiNOvH4hG2m65WGl9LnY6qshrPDnErh+jr4VSkd1CEWjNBzfUyob0cTh
 FNxtOcIx8HD2ULoU7GSAyPDr7MJAa7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-D71sZqEuNFWfvlreylC4FA-1; Fri, 06 Dec 2019 12:27:43 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0DC9107ACC9;
 Fri,  6 Dec 2019 17:27:41 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 73DC86CE40;
 Fri,  6 Dec 2019 17:27:39 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests RFC 02/10] pmu: Let pmu tests take a sub-test
 parameter
Date: Fri,  6 Dec 2019 18:27:16 +0100
Message-Id: <20191206172724.947-3-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: D71sZqEuNFWfvlreylC4FA-1
X-Mimecast-Spam-Score: 0
Cc: andre.przywara@arm.com
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

As we intend to introduce more PMU tests, let's add
a sub-test parameter that will allow to categorize
them. Existing tests are in the cycle-counter category.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 22 ++++++++++++++--------
 arm/unittests.cfg |  7 ++++---
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 1de7d77..2ad6469 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -287,21 +287,27 @@ int main(int argc, char *argv[])
 {
 	int cpi = 0;
 
-	if (argc > 1)
-		cpi = atol(argv[1]);
-
 	if (!pmu_probe()) {
 		printf("No PMU found, test skipped...\n");
 		return report_summary();
 	}
 
+	if (argc < 2)
+		report_abort("no test specified");
+
 	report_prefix_push("pmu");
 
-	report("Control register", check_pmcr());
-	report("Monotonically increasing cycle count", check_cycles_increase());
-	report("Cycle/instruction ratio", check_cpi(cpi));
-
-	pmccntr64_test();
+	if (strcmp(argv[1], "cycle-counter") == 0) {
+		report_prefix_push(argv[1]);
+		if (argc > 2)
+			cpi = atol(argv[2]);
+		report("Control register", check_pmcr());
+		report("Monotonically increasing cycle count", check_cycles_increase());
+		report("Cycle/instruction ratio", check_cpi(cpi));
+		pmccntr64_test();
+	} else {
+		report_abort("Unknown subtest '%s'", argv[1]);
+	}
 
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a0..79f0d7a 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -61,21 +61,22 @@ file = pci-test.flat
 groups = pci
 
 # Test PMU support
-[pmu]
+[pmu-cycle-counter]
 file = pmu.flat
 groups = pmu
+extra_params = -append 'cycle-counter 0'
 
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
 #file = pmu.flat
-#extra_params = -icount 0 -append '1'
+#extra_params = -icount 0 -append 'cycle-counter 1'
 #groups = pmu
 #accel = tcg
 
 # Test PMU support (TCG) with -icount IPC=256
 #[pmu-tcg-icount-256]
 #file = pmu.flat
-#extra_params = -icount 8 -append '256'
+#extra_params = -icount 8 -append 'cycle-counter 256'
 #groups = pmu
 #accel = tcg
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
