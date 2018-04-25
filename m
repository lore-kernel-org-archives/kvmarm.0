From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/3] arm64: fix possible spectre-v1 in ptrace_hbp_get_event()
Date: Wed, 25 Apr 2018 17:13:40 +0100
Message-ID: <20180425161342.38133-2-mark.rutland@arm.com>
References: <20180425161342.38133-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CA049FD1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 12:04:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hMLgQyECUwXf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 12:04:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ACFA49FBC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 12:04:32 -0400 (EDT)
In-Reply-To: <20180425161342.38133-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It's possible for userspace to control idx. Sanitize idx when using it
as an array index.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/ptrace.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 71d99af24ef2..49830b5586b4 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -25,6 +25,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
@@ -249,15 +250,20 @@ static struct perf_event *ptrace_hbp_get_event(unsigned int note_type,
 
 	switch (note_type) {
 	case NT_ARM_HW_BREAK:
-		if (idx < ARM_MAX_BRP)
-			bp = tsk->thread.debug.hbp_break[idx];
+		if (idx >= ARM_MAX_BRP)
+			goto out;
+		idx = array_index_nospec(idx, ARM_MAX_BRP);
+		bp = tsk->thread.debug.hbp_break[idx];
 		break;
 	case NT_ARM_HW_WATCH:
-		if (idx < ARM_MAX_WRP)
-			bp = tsk->thread.debug.hbp_watch[idx];
+		if (idx >= ARM_MAX_WRP)
+			goto out;
+		idx = array_index_nospec(idx, ARM_MAX_WRP);
+		bp = tsk->thread.debug.hbp_watch[idx];
 		break;
 	}
 
+out:
 	return bp;
 }
 
-- 
2.11.0
