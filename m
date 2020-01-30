Return-Path: <SRS0=cl91=3T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD7DC33C9E
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9630214AF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jan 2020 11:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6NpkPLh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9630214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A30064A902;
	Thu, 30 Jan 2020 06:25:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dcSHpcSzSDF9; Thu, 30 Jan 2020 06:25:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F244A957;
	Thu, 30 Jan 2020 06:25:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697054AC89
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gngih9SfltlX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jan 2020 06:25:36 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB6E4A598
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jan 2020 06:25:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580383536;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UXlYDyzqTLtrcUrTm0BlWqi6aN682MJ2N066VEjbccE=;
 b=Y6NpkPLh44VghM81afI3jXtGZHWbdtA1/2hIgFidB1eJn+Ka2dCGBH9rXSCJ0zaBncwG1b
 rP6mZpZR3OKNs9sePy/UxKCvWKqluStkBXvxmpQvcsDGUWjG4ZpfgG57bar1vYQewLWgDN
 uJ4zxTjqi/uywGCxEQtSujJhU16auAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-xymuaHqZNVaOnRaHgqujGg-1; Thu, 30 Jan 2020 06:25:34 -0500
X-MC-Unique: xymuaHqZNVaOnRaHgqujGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6CF1005510;
 Thu, 30 Jan 2020 11:25:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTP id ECB171001B05;
 Thu, 30 Jan 2020 11:25:27 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v2 2/9] arm: pmu: Let pmu tests take a sub-test
 parameter
Date: Thu, 30 Jan 2020 12:25:03 +0100
Message-Id: <20200130112510.15154-3-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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
 arm/pmu.c         | 24 +++++++++++++++---------
 arm/unittests.cfg |  7 ++++---
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index d5a03a6..e5e012d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -287,22 +287,28 @@ int main(int argc, char *argv[])
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
 
-	report(check_pmcr(), "Control register");
-	report(check_cycles_increase(),
-	       "Monotonically increasing cycle count");
-	report(check_cpi(cpi), "Cycle/instruction ratio");
-
-	pmccntr64_test();
+	if (strcmp(argv[1], "cycle-counter") == 0) {
+		report_prefix_push(argv[1]);
+		if (argc > 2)
+			cpi = atol(argv[2]);
+		report(check_pmcr(), "Control register");
+		report(check_cycles_increase(),
+		       "Monotonically increasing cycle count");
+		report(check_cpi(cpi), "Cycle/instruction ratio");
+		pmccntr64_test();
+	} else {
+		report_abort("Unknown sub-test '%s'", argv[1]);
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
