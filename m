From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 03/12] arm64/cpufeature: add ARMv8.3 id_aa64isar1 bits
Date: Mon, 27 Nov 2017 16:37:57 +0000
Message-ID: <20171127163806.31435-4-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B368A49D6F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pLtqGeEwp5LR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 11:36:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5A740FB0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:00 -0500 (EST)
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
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
Cc: linux-arch@vger.kernel.org, cdall@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

>From ARMv8.3 onwards, ID_AA64ISAR1 is no longer entirely RES0, and now
has four fields describing the presence of pointer authentication
functionality:

* APA - address authentication present, using an architected algorithm
* API - address authentication present, using an IMP DEF algorithm
* GPA - generic authentication present, using an architected algorithm
* GPI - generic authentication present, using an IMP DEF algorithm

This patch adds the requisite definitions so that we can identify the
presence of this functionality.

For the timebeing, the features are hidden from both KVM guests and
userspace. As marking them with FTR_HIDDEN only hides them from
userspace, they are also protected with ifdeffery on
CONFIG_ARM64_POINTER_AUTHENTICATION.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c5ba0097887f..1883cdffcdf7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -137,9 +137,17 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_GPI_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_GPA_SHIFT, 4, 0),
+#endif
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_LRCPC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_FCMA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_JSCVT_SHIFT, 4, 0),
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_API_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_APA_SHIFT, 4, 0),
+#endif
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_DPB_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
-- 
2.11.0
