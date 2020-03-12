Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143A0C2BB1D
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:44:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C20E5206FA
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 15:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wbf4nEv3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C20E5206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9C54AEE6;
	Thu, 12 Mar 2020 11:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jH0M63adEnJ9; Thu, 12 Mar 2020 11:44:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285924A5A6;
	Thu, 12 Mar 2020 11:44:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049D14AEDD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:44:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9XDJ6VC64Cs7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 11:44:02 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDC94A4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 11:44:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584027842;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fDpHgRY2PBeuAglXruVQh+Gy7es0EWulYw4xwBVDuzY=;
 b=Wbf4nEv35+pBwWfW8tQKefj6eRC2iO7i2WeWG34uglCRWBgREQYCUfjyT15GUR5JlhB//w
 2L0y4/TQIFGp+V247FPB7CigB4be1ZEIgCiEDs1JOuf15YxqBttEyUYfngf/ogIr3hmuMO
 42WCkTyqbhHKpLQwLKkL4QyP7ISLngg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-J_8iBLY1Or-lvj3aAcTcMw-1; Thu, 12 Mar 2020 11:44:00 -0400
X-MC-Unique: J_8iBLY1Or-lvj3aAcTcMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF2D5801F9D;
 Thu, 12 Mar 2020 15:43:58 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 687B82CE01;
 Thu, 12 Mar 2020 15:43:46 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v3 05/12] arm: pmu: Introduce defines for PMU
 versions
Date: Thu, 12 Mar 2020 16:42:54 +0100
Message-Id: <20200312154301.9130-6-eric.auger@redhat.com>
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

Introduce some defines encoding the different PMU versions.
v3 is encoded differently in 32 and 64 bits.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index d827e82..a04588a 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -45,6 +45,15 @@ static struct pmu pmu;
 #define ID_DFR0_PERFMON_SHIFT 24
 #define ID_DFR0_PERFMON_MASK  0xf
 
+#define ID_DFR0_PMU_NOTIMPL	0b0000
+#define ID_DFR0_PMU_V1		0b0001
+#define ID_DFR0_PMU_V2		0b0010
+#define ID_DFR0_PMU_V3		0b0011
+#define ID_DFR0_PMU_V3_8_1	0b0100
+#define ID_DFR0_PMU_V3_8_4	0b0101
+#define ID_DFR0_PMU_V3_8_5	0b0110
+#define ID_DFR0_PMU_IMPDEF	0b1111
+
 #define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
 #define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
@@ -105,6 +114,13 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
 #define ID_AA64DFR0_PERFMON_MASK  0xf
 
+#define ID_DFR0_PMU_NOTIMPL	0b0000
+#define ID_DFR0_PMU_V3		0b0001
+#define ID_DFR0_PMU_V3_8_1	0b0100
+#define ID_DFR0_PMU_V3_8_4	0b0101
+#define ID_DFR0_PMU_V3_8_5	0b0110
+#define ID_DFR0_PMU_IMPDEF	0b1111
+
 static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
@@ -116,7 +132,7 @@ static inline void set_pmccfiltr(uint32_t v) { write_sysreg(v, pmccfiltr_el0); }
 static inline uint8_t get_pmu_version(void)
 {
 	uint8_t ver = (get_id_aa64dfr0() >> ID_AA64DFR0_PERFMON_SHIFT) & ID_AA64DFR0_PERFMON_MASK;
-	return ver == 1 ? 3 : ver;
+	return ver;
 }
 
 /*
@@ -249,7 +265,7 @@ static bool check_cpi(int cpi)
 static void pmccntr64_test(void)
 {
 #ifdef __arm__
-	if (pmu.version == 0x3) {
+	if (pmu.version == ID_DFR0_PMU_V3) {
 		if (ERRATA(9e3f7a296940)) {
 			write_sysreg(0xdead, PMCCNTR64);
 			report(read_sysreg(PMCCNTR64) == 0xdead, "pmccntr64");
@@ -262,13 +278,13 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
-	uint32_t pmcr;
+	uint32_t pmcr = get_pmcr();
 
 	pmu.version = get_pmu_version();
-	if (pmu.version == 0 || pmu.version == 0xf)
+	if (pmu.version == ID_DFR0_PMU_NOTIMPL || pmu.version == ID_DFR0_PMU_IMPDEF)
 		return false;
 
-	report_info("PMU version: %d", pmu.version);
+	report_info("PMU version: 0x%x", pmu.version);
 
 	pmcr = get_pmcr();
 	report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
