Return-Path: <SRS0=I38I=X5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECEAC4360C
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F3DC2133F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Oct 2019 14:18:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F3DC2133F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B9F4A6A4;
	Fri,  4 Oct 2019 10:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4EOeyHRyW9U; Fri,  4 Oct 2019 10:18:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C7A4A6D9;
	Fri,  4 Oct 2019 10:18:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BA84A685
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KDheics4Bp5S for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Oct 2019 10:18:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6D84A663
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Oct 2019 10:18:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87F7D15AB;
 Fri,  4 Oct 2019 07:18:44 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB0783F68E;
 Fri,  4 Oct 2019 07:18:43 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v2 6/6] arm: Add missing test name prefix calls
Date: Fri,  4 Oct 2019 15:18:29 +0100
Message-Id: <20191004141829.87135-7-andre.przywara@arm.com>
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

When running the unit tests in TAP mode (./run_tests.sh -t), every single
test result is printed. This works fine for most tests which use the
reporting prefix feature to indicate the actual test name.
However psci and pci were missing those names, so the reporting left
people scratching their head what was actually tested:
...
ok 74 - invalid-function
ok 75 - affinity-info-on
ok 76 - affinity-info-off
ok 77 - cpu-on

Push a "psci" prefix before running those tests to make those report
lines more descriptive.
While at it, do the same for pci, even though it is less ambigious there.
Also the GIC ITARGETSR test was missing a report_prefix_pop().

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c      | 2 ++
 arm/pci-test.c | 2 ++
 arm/psci.c     | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 02d2928..adb6aa4 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -480,6 +480,8 @@ static void test_targets(int nr_irqs)
 	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
 
 	writel(orig_targets, targetsptr + GIC_FIRST_SPI);
+
+	report_prefix_pop();
 }
 
 static void gic_test_mmio(void)
diff --git a/arm/pci-test.c b/arm/pci-test.c
index cf128ac..7c3836e 100644
--- a/arm/pci-test.c
+++ b/arm/pci-test.c
@@ -19,6 +19,8 @@ int main(void)
 		return report_summary();
 	}
 
+	report_prefix_push("pci");
+
 	pci_print();
 
 	ret = pci_testdev();
diff --git a/arm/psci.c b/arm/psci.c
index 5cb4d5c..536c9b7 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -126,6 +126,8 @@ int main(void)
 {
 	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 
+	report_prefix_push("psci");
+
 	if (nr_cpus < 2) {
 		report_skip("At least 2 cpus required");
 		goto done;
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
