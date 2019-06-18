Return-Path: <SRS0=HYBR=UR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD82C31E60
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:18:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62B41213F2
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jun 2019 15:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B41213F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4F74A4DF;
	Tue, 18 Jun 2019 11:18:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdqunKkHJ-q0; Tue, 18 Jun 2019 11:18:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67704A525;
	Tue, 18 Jun 2019 11:18:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F594A519
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:18:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZWxIhChPz1dY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jun 2019 11:18:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19A624A4BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jun 2019 11:18:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4452360;
 Tue, 18 Jun 2019 08:18:05 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B56493F718;
 Tue, 18 Jun 2019 08:18:04 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 6/6] arm64: Update silicon-errata.txt for Neoverse-N1
 #1349291
Date: Tue, 18 Jun 2019 16:17:38 +0100
Message-Id: <20190618151738.258983-7-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151738.258983-1-james.morse@arm.com>
References: <20190618151738.258983-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
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

Neoverse-N1 affected by #1349291 may report an Uncontained RAS Error
as Unrecoverable. The kernel's architecture code already considers
Unrecoverable errors as fatal as without kernel-first support no
further error-handling is possible.

Now that KVM attributes SError to the host/guest more precisely
the host's architecture code will always handle host errors that
become pending during world-switch.
Errors misclassified by this errata that affected the guest will be
re-injected to the guest as an implementation-defined SError, which can
be uncontained.

Until kernel-first support is implemented, no workaround is needed
for this issue.

Signed-off-by: James Morse <james.morse@arm.com>
---
imp-def SError can mean uncontained. In the RAS spec, 2.4.2 "ESB and other
containable errors":
| It is [imp-def] whether [imp-def] and uncategorized SError interrupts
| are containable or Uncontainable.
---
 Documentation/arm64/silicon-errata.txt | 1 +
 arch/arm64/kernel/traps.c              | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 2735462d5958..51d506a1f8dc 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -63,6 +63,7 @@ stable kernels.
 | ARM            | Cortex-A76      | #1286807        | ARM64_ERRATUM_1286807       |
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
+| ARM            | Neoverse-N1     | #1349291        | N/A                         |
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375,24313    | CAVIUM_ERRATUM_22375        |
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e6be1a6efc0a..9f64cd609298 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -888,6 +888,10 @@ bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr)
 		/*
 		 * The CPU can't make progress. The exception may have
 		 * been imprecise.
+		 *
+		 * Neoverse-N1 #1349291 means a non-KVM SError reported as
+		 * Unrecoverable should be treated as Uncontainable. We
+		 * call arm64_serror_panic() in both cases.
 		 */
 		return true;
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
