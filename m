From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/2] arm64: fix possible spectre-v1 write in
 ptrace_hbp_set_event()
Date: Tue, 10 Jul 2018 19:01:22 +0100
Message-ID: <20180710180123.56461-2-mark.rutland@arm.com>
References: <20180710180123.56461-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFACE4A0D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 13:48:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ldvSjW7Q29Ic for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 13:48:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B7F4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 13:48:48 -0400 (EDT)
In-Reply-To: <20180710180123.56461-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It's possible for userspace to control idx. Sanitize idx when using it
as an array index, to inhibit the potential spectre-v1 write gadget.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/kernel/ptrace.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 5c338ce5a7fa..db5440339ab3 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -277,19 +277,22 @@ static int ptrace_hbp_set_event(unsigned int note_type,
 
 	switch (note_type) {
 	case NT_ARM_HW_BREAK:
-		if (idx < ARM_MAX_BRP) {
-			tsk->thread.debug.hbp_break[idx] = bp;
-			err = 0;
-		}
+		if (idx >= ARM_MAX_BRP)
+			goto out;
+		idx = array_index_nospec(idx, ARM_MAX_BRP);
+		tsk->thread.debug.hbp_break[idx] = bp;
+		err = 0;
 		break;
 	case NT_ARM_HW_WATCH:
-		if (idx < ARM_MAX_WRP) {
-			tsk->thread.debug.hbp_watch[idx] = bp;
-			err = 0;
-		}
+		if (idx >= ARM_MAX_WRP)
+			goto out;
+		idx = array_index_nospec(idx, ARM_MAX_WRP);
+		tsk->thread.debug.hbp_watch[idx] = bp;
+		err = 0;
 		break;
 	}
 
+out:
 	return err;
 }
 
-- 
2.11.0
