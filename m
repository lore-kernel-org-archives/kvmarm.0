Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74F134CF9
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E11C433EF;
	Tue, 16 May 2023 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684253232;
	bh=fXtE24B37oT73M/ze3nTFy1TG8QoQelzkE1vViT4cgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fysph3xUJar0DV/xTyHCioP0PMFBMbAMikkh0glldN8Qzm+GWY6I6mgrsIV9mryVY
	 J1ZTD346FQuvxFmSpdz6k5HM2HwVhd7cHSbqNqHgO97F4Gn40nsGAGs6Bf0Tc4udyB
	 xR3/AsvfQF7tz0ci19Su0ltRaUlss/PnQSkiXlnzD6UiVBNuZO53cDVcWiCJhJkJkh
	 LROOG4uzSg8sXOVQ6Z741sr76ZFkzLoSDPrC+svlEVx+97F/9lTbAD4YMUuu3b1Ac4
	 GCEGXT9R7wl4owm/NwKDzfwIP1DZ5MHnCAbuS9K2X4K11N/FgPy0TG5R9aHDkv2B9D
	 KZV0MUDcEaYjQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 04/15] arm64: move cpu_suspend_set_dbg_restorer() prototype to header
Date: Tue, 16 May 2023 18:06:31 +0200
Message-Id: <20230516160642.523862-5-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516160642.523862-1-arnd@kernel.org>
References: <20230516160642.523862-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The cpu_suspend_set_dbg_restorer() function is called by the hw_breakpoint
code but defined in another file. Since the declaration is in the
same file as the caller, the compiler warns about the definition
without a prior prototype:

arch/arm64/kernel/suspend.c:35:13: error: no previous prototype for 'cpu_suspend_set_dbg_restorer' [-Werror=missing-prototypes]

Move it into the corresponding header instead to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/hw_breakpoint.h | 8 ++++++++
 arch/arm64/kernel/hw_breakpoint.c      | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index fa4c6ff3aa9b..84055329cd8b 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -154,4 +154,12 @@ static inline int get_num_wrps(void)
 						ID_AA64DFR0_EL1_WRPs_SHIFT);
 }
 
+#ifdef CONFIG_CPU_PM
+extern void cpu_suspend_set_dbg_restorer(int (*hw_bp_restore)(unsigned int));
+#else
+static inline void cpu_suspend_set_dbg_restorer(int (*hw_bp_restore)(unsigned int))
+{
+}
+#endif
+
 #endif	/* __ASM_BREAKPOINT_H */
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index b29a311bb055..db2a1861bb97 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -973,14 +973,6 @@ static int hw_breakpoint_reset(unsigned int cpu)
 	return 0;
 }
 
-#ifdef CONFIG_CPU_PM
-extern void cpu_suspend_set_dbg_restorer(int (*hw_bp_restore)(unsigned int));
-#else
-static inline void cpu_suspend_set_dbg_restorer(int (*hw_bp_restore)(unsigned int))
-{
-}
-#endif
-
 /*
  * One-time initialisation.
  */
-- 
2.39.2

