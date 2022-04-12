Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE689C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:32:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0104B25E;
	Tue, 12 Apr 2022 09:32:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Cnyc0R5px+J; Tue, 12 Apr 2022 09:32:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 424EA4B2A6;
	Tue, 12 Apr 2022 09:32:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7264B25E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pf6NtdsrDlRK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FC8B4B1F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0227F1570;
 Tue, 12 Apr 2022 06:32:42 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 890403F70D;
 Tue, 12 Apr 2022 06:32:40 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 03/11] arm/arm64: pmu.h: Add missing header guards
Date: Tue, 12 Apr 2022 14:32:23 +0100
Message-Id: <20220412133231.35355-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/pmu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arm/include/arm-common/pmu.h b/arm/include/arm-common/pmu.h
index 7a170a56dadd..0085f2545553 100644
--- a/arm/include/arm-common/pmu.h
+++ b/arm/include/arm-common/pmu.h
@@ -1,4 +1,8 @@
+#ifndef ARM_COMMON__PMU_H
+#define ARM_COMMON__PMU_H
 
 #define KVM_ARM_PMUv3_PPI			23
 
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm);
+
+#endif /* ARM_COMMON__PMU_H */
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
