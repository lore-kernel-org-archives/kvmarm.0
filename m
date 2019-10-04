Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28489C47404
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0DE2222C0
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0DE2222C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88F5A4A663;
	Fri,  4 Oct 2019 10:18:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YCzUoKF3m2sT; Fri,  4 Oct 2019 10:18:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5474B4A6D5;
	Fri,  4 Oct 2019 10:18:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D06944A612
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqTObexpFc+k for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 10:18:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D165F4A69A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88F0F15BF;
 Fri,  4 Oct 2019 07:18:42 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA7FF3F68E;
 Fri,  4 Oct 2019 07:18:41 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 4/6] arm: selftest: Split variable output
 data from test name
Date: Fri,  4 Oct 2019 15:18:27 +0100
Message-Id: <20191004141829.87135-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004141829.87135-1-andre.przywara@arm.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7..a0c1ab8 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -43,13 +43,16 @@ static void check_setup(int argc, char **argv)
 			phys_addr_t memsize = PHYS_END - PHYS_OFFSET;
 			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
 
-			report("size = %" PRIu64 " MB", memsize == expected,
-							memsize/1024/1024);
+			report("memory size matches expectation",
+			       memsize == expected);
+			report_info("found %" PRIu64 " MB", memsize/1024/1024);
 			++nr_tests;
 
 		} else if (strcmp(argv[i], "smp") == 0) {
 
-			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
+			report("number of CPUs matches expectation",
+			       nr_cpus == (int)val);
+			report_info("found %d CPUs", nr_cpus);
 			++nr_tests;
 		}
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
