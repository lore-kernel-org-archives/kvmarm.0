Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B55DC10DCE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:43:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F258D206BE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3gvMKBt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F258D206BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F804AE8E;
	Thu, 12 Mar 2020 11:43:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2olAaMMC7344; Thu, 12 Mar 2020 11:43:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9AD4A418;
	Thu, 12 Mar 2020 11:43:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BAD54A418
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p5b-zREM7OB1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 11:43:41 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B2CF4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:43:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584027821;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=L32ijn0JvgWid8cEaZUZkfWPFPXKJ067qGBdQUVReeI=;
 b=K3gvMKBtkENSK0VDCovEM8XKOR98HLAmQeh8e8X5C4IBtGpfkuN4bssXMG0YMbFhUpTJK9
 aA0hXDPsWmGUiIE9VBGY3pTgvORe+bAWga1ScwCujZAAHIuLlBTdzCgEjkTv9trWb5hraN
 70xd3P8kd7xO4fhKm7NalunpXVRGn7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-rwhGuAlZN5-oHk3xKccUCg-1; Thu, 12 Mar 2020 11:43:37 -0400
X-MC-Unique: rwhGuAlZN5-oHk3xKccUCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC515108442C;
 Thu, 12 Mar 2020 15:43:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7DB66836;
 Thu, 12 Mar 2020 15:43:26 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 03/12] arm: pmu: Don't check PMCR.IMP anymore
Date: Thu, 12 Mar 2020 16:42:52 +0100
Message-Id: <20200312154301.9130-4-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

check_pmcr() checks the IMP field is different than 0.
However A zero IMP field is permitted by the architecture,
meaning the MIDR_EL1 should be looked at instead. This
causes TCG to fail this test on '-cpu max' because in
that case PMCR.IMP is set equal to MIDR_EL1.Implementer
which is 0.

So let's remove the check_pmcr() test and just print PMCR
info in the pmu_probe() function.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Peter Maydell <peter.maydell@linaro.org>
---
 arm/pmu.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 0122f0a..44f3543 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -134,29 +134,6 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 }
 #endif
 
-/*
- * As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
- * null. Also print out a couple other interesting fields for diagnostic
- * purposes. For example, as of fall 2016, QEMU TCG mode doesn't implement
- * event counters and therefore reports zero event counters, but hopefully
- * support for at least the instructions event will be added in the future and
- * the reported number of event counters will become nonzero.
- */
-static bool check_pmcr(void)
-{
-	uint32_t pmcr;
-
-	pmcr = get_pmcr();
-
-	report_info("PMU implementer/ID code/counters: %#x(\"%c\")/%#x/%d",
-		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
-		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
-		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
-		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
-
-	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) != 0;
-}
-
 /*
  * Ensure that the cycle counter progresses between back-to-back reads.
  */
@@ -278,9 +255,22 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
+	uint32_t pmcr;
+
 	pmu_version = get_pmu_version();
+	if (pmu_version == 0 || pmu_version == 0xf)
+		return false;
+
 	report_info("PMU version: %d", pmu_version);
-	return pmu_version != 0 && pmu_version != 0xf;
+
+	pmcr = get_pmcr();
+	report_info("PMU implementer/ID code/counters: %#x(\"%c\")/%#x/%d",
+		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
+		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
+		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
+		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
+
+	return true;
 }
 
 int main(int argc, char *argv[])
@@ -301,7 +291,6 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		if (argc > 2)
 			cpi = atol(argv[2]);
-		report(check_pmcr(), "Control register");
 		report(check_cycles_increase(),
 		       "Monotonically increasing cycle count");
 		report(check_cpi(cpi), "Cycle/instruction ratio");
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
