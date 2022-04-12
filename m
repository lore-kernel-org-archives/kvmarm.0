Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D667C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF18E4B2D0;
	Tue, 12 Apr 2022 09:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0wJADxwwp+yn; Tue, 12 Apr 2022 09:14:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53AD44B2E0;
	Tue, 12 Apr 2022 09:14:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BC84B27F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id otAlpaLOF5SS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28B3D4B28B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 41B96B81D7E;
 Tue, 12 Apr 2022 13:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D14C385B6;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769234;
 bh=S4wtuSawBIdOirV9+EXKlxJVAMKzTeuezpQs7TWd4mE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YbE9KazrXCIj2qDHvSDQlZyfW2OB5xe3ePJl0hCJVS3iDSlCzJCyJOJ+kHFhtqqHb
 koEdH/cQIBeXrhYZhwQ6v0dip/R5Xq030+LcuHdKJX22RJ0sADcfnwiaLwfLJvQd56
 O/vZBZ3ihbdgOS4YGR0+jPIzHxaqx+23DmVhhDw1dNGWTRTFhUDtoo+x22j64vXM2u
 HBlIQWMPsGeXxJlhiDbTzR0iZYE4LKTkk7bBW86ENd3frvn56l2t32UZopUgpkIVWc
 Yj++nACAbA+zmE1PXn1R3j/scIzBSrU2Si9QjTqKjDt9DhYlglIjRnPeDbu0L9V4Xy
 eyeW9NkYDTvhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGLA-003mvX-Qv; Tue, 12 Apr 2022 14:13:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 08/10] arm64: Add HWCAP advertising FEAT_WFXT
Date: Tue, 12 Apr 2022 14:13:01 +0100
Message-Id: <20220412131303.504690-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

In order to allow userspace to enjoy WFET, add a new HWCAP that
advertises it when available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/arm64/cpu-feature-registers.rst | 2 ++
 Documentation/arm64/elf_hwcaps.rst            | 4 ++++
 arch/arm64/include/asm/hwcap.h                | 1 +
 arch/arm64/include/uapi/asm/hwcap.h           | 1 +
 arch/arm64/kernel/cpufeature.c                | 3 ++-
 arch/arm64/kernel/cpuinfo.c                   | 1 +
 6 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/cpu-feature-registers.rst b/Documentation/arm64/cpu-feature-registers.rst
index 749ae970c319..04ba83e1965f 100644
--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -290,6 +290,8 @@ infrastructure:
      +------------------------------+---------+---------+
      | RPRES                        | [7-4]   |    y    |
      +------------------------------+---------+---------+
+     | WFXT                         | [3-0]   |    y    |
+     +------------------------------+---------+---------+
 
 
 Appendix I: Example
diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
index a8f30963e550..af3ab524e826 100644
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -264,6 +264,10 @@ HWCAP2_MTE3
     Functionality implied by ID_AA64PFR1_EL1.MTE == 0b0011, as described
     by Documentation/arm64/memory-tagging-extension.rst.
 
+HWCAP2_WFXT
+
+    Functionality implied by ID_AA64ISAR2_EL1.WFXT == 0b0010.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 8db5ec0089db..909337b50e1f 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -109,6 +109,7 @@
 #define KERNEL_HWCAP_AFP		__khwcap2_feature(AFP)
 #define KERNEL_HWCAP_RPRES		__khwcap2_feature(RPRES)
 #define KERNEL_HWCAP_MTE3		__khwcap2_feature(MTE3)
+#define KERNEL_HWCAP_WFXT		__khwcap2_feature(WFXT)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 99cb5d383048..9dddde1d046c 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -79,5 +79,6 @@
 #define HWCAP2_AFP		(1 << 20)
 #define HWCAP2_RPRES		(1 << 21)
 #define HWCAP2_MTE3		(1 << 22)
+#define HWCAP2_WFXT		(1 << 23)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index db6d9ab685e5..945190ebadd5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -237,7 +237,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_GPA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_WFXT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_WFXT_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2587,6 +2587,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
 	HWCAP_CAP(SYS_ID_AA64MMFR1_EL1, ID_AA64MMFR1_AFP_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_AFP),
 	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_RPRES_SHIFT, 4, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_RPRES),
+	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_WFXT_SHIFT, 4, FTR_UNSIGNED, ID_AA64ISAR2_WFXT_SUPPORTED, CAP_HWCAP, KERNEL_HWCAP_WFXT),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 330b92ea863a..781eab314794 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -98,6 +98,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_AFP]		= "afp",
 	[KERNEL_HWCAP_RPRES]		= "rpres",
 	[KERNEL_HWCAP_MTE3]		= "mte3",
+	[KERNEL_HWCAP_WFXT]		= "wfxt",
 };
 
 #ifdef CONFIG_COMPAT
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
