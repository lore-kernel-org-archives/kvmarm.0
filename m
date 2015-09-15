From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 06/15] arm64: Clean config usages for page size
Date: Tue, 15 Sep 2015 16:41:15 +0100
Message-ID: <1442331684-28818-7-git-send-email-suzuki.poulose@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93498412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nu1yIip0P2NT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2015 11:40:47 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A845C412F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:46 -0400 (EDT)
In-Reply-To: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

We use !CONFIG_ARM64_64K_PAGES for CONFIG_ARM64_4K_PAGES
(and vice versa) in code. It all worked well, so far since
we only had two options. Now, with the introduction of 16K,
these cases will break. This patch cleans up the code to
use the required CONFIG symbol expression without the assumption
that !64K => 4K (and vice versa)

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   |    4 ++--
 arch/arm64/Kconfig.debug             |    2 +-
 arch/arm64/include/asm/thread_info.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7d95663..ab0a36f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -451,7 +451,7 @@ config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
 config ARCH_WANT_HUGE_PMD_SHARE
-	def_bool y if !ARM64_64K_PAGES
+	def_bool y if ARM64_4K_PAGES
 
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
@@ -663,7 +663,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	bool "Kernel support for 32-bit EL0"
-	depends on !ARM64_64K_PAGES || EXPERT
+	depends on ARM64_4K_PAGES || EXPERT
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	select OLD_SIGSUSPEND3
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index d6285ef..c24d6ad 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -77,7 +77,7 @@ config DEBUG_RODATA
           If in doubt, say Y
 
 config DEBUG_ALIGN_RODATA
-	depends on DEBUG_RODATA && !ARM64_64K_PAGES
+	depends on DEBUG_RODATA && ARM64_4K_PAGES
 	bool "Align linker sections up to SECTION_SIZE"
 	help
 	  If this option is enabled, sections that may potentially be marked as
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index dcd06d1..d9c8c9f 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -23,7 +23,7 @@
 
 #include <linux/compiler.h>
 
-#ifndef CONFIG_ARM64_64K_PAGES
+#ifdef CONFIG_ARM64_4K_PAGES
 #define THREAD_SIZE_ORDER	2
 #endif
 
-- 
1.7.9.5
