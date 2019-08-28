Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3D7C3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6508233FF
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6508233FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6C84A588;
	Wed, 28 Aug 2019 09:39:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id THNBu2KgzcmJ; Wed, 28 Aug 2019 09:39:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D86334A598;
	Wed, 28 Aug 2019 09:39:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E74FA4A5B7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FoiJGi8EaIJW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 09:39:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B074A5E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:39:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE7215AB;
 Wed, 28 Aug 2019 06:39:10 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 55D9C3F73D;
 Wed, 28 Aug 2019 06:39:09 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 15/16] arm64: selftest: Expand EL2 test to
 disable and re-enable VHE
Date: Wed, 28 Aug 2019 14:38:30 +0100
Message-Id: <1566999511-24916-16-git-send-email-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
KVM doesn't deal with a guest running with VHE enabled, then disabling it
[1]. I also proposed a fix [1] for it.

[1] https://www.spinics.net/lists/arm-kernel/msg749823.html

 arm/selftest.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index 211bc8a5642b..4a6c943497ee 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -395,6 +395,18 @@ static void check_el2_cpu(void *data __unused)
 	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
 	report("CPU(%3d) VHE supported and enabled",
 			vhe_supported() && vhe_enabled(), cpu);
+
+	report_info("CPU(%3d) Disabling VHE", cpu);
+	disable_vhe();
+
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE disabled", !vhe_enabled(), cpu);
+
+	report_info("CPU(%3d) Re-enabling VHE", cpu);
+	enable_vhe();
+
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE enabled", vhe_enabled(), cpu);
 }
 
 static bool psci_check(void);
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
