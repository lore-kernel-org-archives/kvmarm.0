From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 0/3] arm64: SVE fixes for v4.15-rc2
Date: Wed,  6 Dec 2017 16:45:44 +0000
Message-ID: <1512578747-4554-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C212040651
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 11:42:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iOcOhEsz5EyJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 11:42:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F1749D4E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 11:42:40 -0500 (EST)
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series contains a few fixes for known issues in the arm64 FPSIMD
and SVE implementation.

This supersedes the previous posting. [1]

Note that although patch 2 is not a fix, it provides refactoring that is
used by the fix in patch 3.

[1] [PATCH 0/3] arm64: SVE fixes for v4.15-rc1
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-December/545126.html

Dave Martin (3):
  arm64: fpsimd: Prevent registers leaking from dead tasks
  arm64: fpsimd: Abstract out binding of task's fpsimd context to the
    cpu.
  arm64/sve: Avoid dereference of dead task_struct in KVM guest entry

 arch/arm64/kernel/fpsimd.c  | 51 ++++++++++++++++++++++++++-------------------
 arch/arm64/kernel/process.c |  9 ++++++++
 2 files changed, 39 insertions(+), 21 deletions(-)

-- 
2.1.4
