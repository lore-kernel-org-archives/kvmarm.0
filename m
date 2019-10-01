Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D67C352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3671A21D79
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3671A21D79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E23224A6D3;
	Tue,  1 Oct 2019 06:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ydti2KSJ2zKD; Tue,  1 Oct 2019 06:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AEDF4A6C6;
	Tue,  1 Oct 2019 06:23:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C26714A612
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ar56X5rDLtxW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FE34A69C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EC651570;
 Tue,  1 Oct 2019 03:23:39 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 191BD3F739;
 Tue,  1 Oct 2019 03:23:37 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 01/19] lib: arm/arm64: Remove unused
 CPU_OFF parameter
Date: Tue,  1 Oct 2019 11:23:05 +0100
Message-Id: <20191001102323.27628-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The first version of PSCI required an argument for CPU_OFF, the power_state
argument, which was removed in version 0.2 of the specification [1].
kvm-unit-tests supports PSCI 0.2, and KVM ignores any CPU_OFF parameters,
so let's remove the PSCI_POWER_STATE_TYPE_POWER_DOWN parameter.

[1] ARM DEN 0022D, section 7.3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/psci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index c3d399064ae3..936c83948b6a 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -40,11 +40,9 @@ int cpu_psci_cpu_boot(unsigned int cpu)
 	return err;
 }
 
-#define PSCI_POWER_STATE_TYPE_POWER_DOWN (1U << 16)
 void cpu_psci_cpu_die(void)
 {
-	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF,
-			PSCI_POWER_STATE_TYPE_POWER_DOWN, 0, 0);
+	int err = psci_invoke(PSCI_0_2_FN_CPU_OFF, 0, 0, 0);
 	printf("CPU%d unable to power off (error = %d)\n", smp_processor_id(), err);
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
