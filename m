Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7D7C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3001B61AA5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 15:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3001B61AA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D69AA4B187;
	Wed, 17 Nov 2021 10:38:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9qzYAZTiFhD3; Wed, 17 Nov 2021 10:38:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CADD4B1F3;
	Wed, 17 Nov 2021 10:38:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9737E4B131
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yhOFmmTulEdY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 10:38:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 398D54B190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 10:38:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 005C9106F;
 Wed, 17 Nov 2021 07:38:10 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6CFF3F5A1;
 Wed, 17 Nov 2021 07:38:08 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, mark.rutland@arm.com
Subject: [RFC PATCH v5 37/38] KVM: arm64: Make CONFIG_KVM_ARM_SPE depend on
 !CONFIG_NUMA_BALANCING
Date: Wed, 17 Nov 2021 15:38:41 +0000
Message-Id: <20211117153842.302159-38-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117153842.302159-1-alexandru.elisei@arm.com>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
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

Automatic NUMA balancing is a performance strategy that Linux uses to
reduce the cost associated with memory accesses by having a task use
the memory closest to the NUMA node where the task is executing. This is
accomplished by triggering periodic page faults to examine the memory
location that a task uses, and decide if page migration is necessary.

The periodic page faults that drive automatic NUMA balancing are triggered
by clearing permissions on certain pages from the task's address space.
Clearing the permissions invokes mmu_notifier_invalidate_range_start(),
which causes guest memory from being unmapped from stage 2. As a result,
SPE can start reporting stage 2 faults, which KVM has no way of handling.

Make CONFIG_KVM_ARM_SPE depend on !CONFIG_NUMA_BALANCING to keep SPE usable
for a guest.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 9c8c8424ab58..5899ee95fbda 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -56,7 +56,7 @@ config NVHE_EL2_DEBUG
 
 config KVM_ARM_SPE
 	bool "Virtual Statistical Profiling Extension (SPE) support"
-	depends on KVM && ARM_SPE_PMU=y
+	depends on KVM && ARM_SPE_PMU=y && !NUMA_BALANCING
 	default y
 	help
 	  Adds support for Statistical Profiling Extension (SPE) in virtual
-- 
2.33.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
