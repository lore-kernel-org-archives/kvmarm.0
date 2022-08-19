Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAFEC28B2B
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 16:15:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C8154C74A;
	Fri, 19 Aug 2022 12:15:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mFHWkV50Qlbv; Fri, 19 Aug 2022 12:15:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37A054C748;
	Fri, 19 Aug 2022 12:15:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB13C4C748
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 12:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMcsvq8OXgQG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2022 12:15:09 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FF784C747
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 12:15:09 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660925708;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=k0xkptv3Zqc9QB1iW0tg7GYz6w0QjKzvT8qQb1OUOvo=;
 b=HpdH+BTYOAHCdvv2kpRE5FYFGRD1GQes+Zjko16lbijJL3vTVXF105i/Vx5mGXmZ/FBrRk
 aIlt61jYoi38RhDvxwQffosCtoQDzbVPtv8eUtSMW/PUkgCxtM9EqMTD0+kt+bUDf8i2f2
 3NYNJqjwKBr5L45AWadau0UwHvlGNc0=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH] KVM: selftests: Update top-of-file comment in psci_test
Date: Fri, 19 Aug 2022 16:14:11 +0000
Message-Id: <20220819161411.212530-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Fix the comment to accurately describe the test and recently added
SYSTEM_SUSPEND test case.

What was once psci_cpu_on_test was renamed and extended to squeeze in a
test case for PSCI SYSTEM_SUSPEND. Nonetheless, the author of those
changes (whoever they may be...) failed to update the file comment to
reflect what had changed.

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index f7621f6e938e..8a77bd06427c 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -1,12 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * psci_cpu_on_test - Test that the observable state of a vCPU targeted by the
- * CPU_ON PSCI call matches what the caller requested.
+ * psci_test - Tests relating to KVM's PSCI implementation.
  *
  * Copyright (c) 2021 Google LLC.
  *
- * This is a regression test for a race between KVM servicing the PSCI call and
- * userspace reading the vCPUs registers.
+ * This test includes:
+ *  - A regression test for a race between KVM servicing the PSCI CPU_ON call
+ *    and userspace reading the targeted vCPU's registers.
+ *  - A test for KVM's handling of PSCI SYSTEM_SUSPEND and the associated
+ *    KVM_EXIT_SYSTEM_SUSPEND UAPI.
  */
 
 #define _GNU_SOURCE

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
