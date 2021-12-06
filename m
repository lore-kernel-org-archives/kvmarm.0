Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA814C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:02:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 515154B10B;
	Mon,  6 Dec 2021 12:02:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SSr3YXi7QwVo; Mon,  6 Dec 2021 12:02:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D93974B0C2;
	Mon,  6 Dec 2021 12:02:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F28334B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xuz-k-6O3C+k for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:02:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A6B949FE6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFF5812FC;
 Mon,  6 Dec 2021 09:02:35 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDB5B3F73B;
 Mon,  6 Dec 2021 09:02:33 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/4] perf: Fix wrong name in comment for struct
 perf_cpu_context
Date: Mon,  6 Dec 2021 17:02:20 +0000
Message-Id: <20211206170223.309789-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206170223.309789-1-alexandru.elisei@arm.com>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: tglx@linutronix.de, mingo@redhat.com
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

Commit 0793a61d4df8 ("performance counters: core code") added the perf
subsystem (then called Performance Counters) to Linux, creating the struct
perf_cpu_context. The comment for the struct referred to it as a "struct
perf_counter_cpu_context".

Commit cdd6c482c9ff ("perf: Do the big rename: Performance Counters ->
Performance Events") changed the comment to refer to a "struct
perf_event_cpu_context", which was still the wrong name for the struct.

Change the comment to say "struct perf_cpu_context".

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/linux/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0dcfd265beed..14132570ea5d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -862,7 +862,7 @@ struct perf_event_context {
 #define PERF_NR_CONTEXTS	4
 
 /**
- * struct perf_event_cpu_context - per cpu event context structure
+ * struct perf_cpu_context - per cpu event context structure
  */
 struct perf_cpu_context {
 	struct perf_event_context	ctx;
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
