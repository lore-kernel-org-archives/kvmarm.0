From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 03/30] arm64: signal: Verify extra data is user-readable in
 sys_rt_sigreturn
Date: Tue, 31 Oct 2017 15:50:55 +0000
Message-ID: <1509465082-30427-4-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 455B249D5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c2JTQp34nwbB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 11:50:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E33C49D65
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:01 -0400 (EDT)
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently sys_rt_sigreturn() verifies that the base sigframe is
readable, but no similar check is performed on the extra data to
which an extra_context record points.

This matters because the extra data will be read with the
unprotected user accessors.  However, this is not a problem at
present because the extra data base address is required to be
exactly at the end of the base sigframe.  So, there would need to
be a non-user-readable kernel address within about 59K
(SIGFRAME_MAXSZ - sizeof(struct rt_sigframe)) of some address for
which access_ok(VERIFY_READ) returns true, in order for sigreturn
to be able to read kernel memory that should be inaccessible to the
user task.  This is currently impossible due to the untranslatable
address hole between the TTBR0 and TTBR1 address ranges.

Disappearance of the hole between the TTBR0 and TTBR1 mapping
ranges would require the VA size for TTBR0 and TTBR1 to grow to at
least 55 bits, and either the disabling of tagged pointers for
userspace or enabling of tagged pointers for kernel space; none of
which is currently envisaged.

Even so, it is wrong to use the unprotected user accessors without
an accompanying access_ok() check.

To avoid the potential for future surprises, this patch does an
explicit access_ok() check on the extra data space when parsing an
extra_context record.

Fixes: 33f082614c34 ("arm64: signal: Allow expansion of the signal frame")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 0bdc96c..4716729 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -343,6 +343,10 @@ static int parse_user_sigframe(struct user_ctxs *user,
 			 */
 			offset = 0;
 			limit = extra_size;
+
+			if (!access_ok(VERIFY_READ, base, limit))
+				goto invalid;
+
 			continue;
 
 		default:
-- 
2.1.4
