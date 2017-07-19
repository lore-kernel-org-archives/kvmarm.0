From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 04/11] arm64/cpufeature: add ARMv8.3 id_aa64isar1 bits
Date: Wed, 19 Jul 2017 17:01:25 +0100
Message-ID: <1500480092-28480-5-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E0D41260
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jul 2017 12:02:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M4THyDyUvx18 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jul 2017 12:02:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 421744104E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jul 2017 12:02:05 -0400 (EDT)
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
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
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Dave.Martin@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

>From ARMv8.3 onwards, ID_AA64ISAR1 is no longer entirely RES0, and now
has four fields describing the presence of pointer authentication
functionality:

* APA - address authentication present, using an architected algorithm
* API - address authentication present, using an IMP DEF algorithm
* GPA - generic authentication present, using an architected algorithm
* GPI - generic authentication present, using an IMP DEF algoithm

This patch adds the requisite definitions so that we can identify the
presence of this functionality. For the timebeing, the features are
hidden from userspace.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9f9e0064..b23ad83 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -120,7 +120,11 @@ static int __init register_cpu_hwcaps_dumper(void)
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_LRCPC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_FCMA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_JSCVT_SHIFT, 4, 0),
-	ARM64_FTR_END,
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_GPI_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_GPA_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_API_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64ISAR1_APA_SHIFT, 4, 0),
+	ARM64_FTR_END
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
-- 
1.9.1
