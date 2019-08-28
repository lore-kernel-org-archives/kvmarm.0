Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8302C3A5A6
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98807233FF
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98807233FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 507B24A582;
	Wed, 28 Aug 2019 09:39:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0l8fgZNJ90bN; Wed, 28 Aug 2019 09:39:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C224A5DB;
	Wed, 28 Aug 2019 09:39:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 473C24A5DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZLWxkaoscHbG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 09:39:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17CA44A594
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:39:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE66715AD;
 Wed, 28 Aug 2019 06:39:11 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B0CCF3F246;
 Wed, 28 Aug 2019 06:39:10 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 16/16] arm64: timer: Run tests with VHE
 disabled
Date: Wed, 28 Aug 2019 14:38:31 +0100
Message-Id: <1566999511-24916-17-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Disable VHE if first command line parameter is "nvhe" and then test the
timers. Just like with VHE enabled, if no other parameter is given, all
four timers are tested; otherwise, only the timers specified by the user.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h |  2 ++
 arm/timer.c               | 33 +++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 4d12913ca01f..36260a942795 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -26,6 +26,8 @@
 #define HCR_EL2_TGE		(1 << 27)
 #define HCR_EL2_E2H_SHIFT	34
 #define HCR_EL2_E2H		(UL(1) << 34)
+#define HCR_EL2_IMO		(1 << 4)
+#define HCR_EL2_FMO		(1 << 3)
 
 #define SCTLR_EL2_RES1		(3 << 28 | 3 << 22 | 1 << 18 |	\
 				 1 << 16 | 1 << 11 | 3 << 4)
diff --git a/arm/timer.c b/arm/timer.c
index faab671d0fb1..6b9d5d57a658 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -464,19 +464,34 @@ static void test_hptimer(void)
 	report_prefix_pop();
 }
 
-static void test_init(void)
+static void test_init(bool without_vhe)
 {
 	const struct fdt_property *prop;
 	const void *fdt = dt_fdt();
+	u64 hcr;
 	int node, len;
 	u32 *data;
 
+	if (without_vhe) {
+		disable_vhe();
+		hcr = read_sysreg(hcr_el2);
+		/* KVM doesn't support different IMO/FMO settings */
+		hcr |= HCR_EL2_IMO | HCR_EL2_FMO;
+		write_sysreg(hcr, hcr_el2);
+		isb();
+	}
+
 	if (current_el == CurrentEL_EL1) {
 		vtimer = &vtimer_info;
 		ptimer = &ptimer_info;
 	} else {
-		vtimer = &vtimer_info_vhe;
-		ptimer = &ptimer_info_vhe;
+		if (without_vhe) {
+			vtimer = &vtimer_info;
+			ptimer = &ptimer_info;
+		} else {
+			vtimer = &vtimer_info_vhe;
+			ptimer = &ptimer_info_vhe;
+		}
 		hvtimer = &hvtimer_info;
 		hptimer = &hptimer_info;
 	}
@@ -563,10 +578,20 @@ static void print_timer_info(void)
 int main(int argc, char **argv)
 {
 	int i;
+	bool without_vhe = false;
 
 	current_el = current_level();
 
-	test_init();
+	if (argc > 1 && strcmp(argv[1], "nvhe") == 0) {
+		if (current_el == CurrentEL_EL1)
+			report_info("Skipping EL2 tests. Boot at EL2 to enable.");
+		else
+			without_vhe = true;
+		argv = &argv[1];
+		argc--;
+	}
+
+	test_init(without_vhe);
 
 	print_timer_info();
 
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
