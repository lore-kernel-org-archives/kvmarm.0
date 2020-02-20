Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BC8C11D0C
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 16:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5A5220722
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 16:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5A5220722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F14E4AF39;
	Thu, 20 Feb 2020 11:59:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lUrZcC2I9YZz; Thu, 20 Feb 2020 11:59:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0464AF8C;
	Thu, 20 Feb 2020 11:59:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E774AF4A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 11:59:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dh0w8BEgC4Yd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 11:59:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97F5F4AF70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 11:59:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54FCF31B;
 Thu, 20 Feb 2020 08:59:07 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05B783F68F;
 Thu, 20 Feb 2020 08:59:05 -0800 (PST)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/3] arm64: Ask the compiler to __always_inline functions used
 by KVM at HYP
Date: Thu, 20 Feb 2020 16:58:39 +0000
Message-Id: <20200220165839.256881-4-james.morse@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220165839.256881-1-james.morse@arm.com>
References: <20200220165839.256881-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <maz@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

KVM uses some of the static-inline helpers like icache_is_vipt() from
its HYP code. This assumes the function is inlined so that the code is
mapped to EL2. The compiler may decide not to inline these, and the
out-of-line version may not be in the __hyp_text section.

Add the additional __always_ hint to these static-inlines that are used
by KVM.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/cache.h      | 2 +-
 arch/arm64/include/asm/cacheflush.h | 2 +-
 arch/arm64/include/asm/cpufeature.h | 8 ++++----
 arch/arm64/include/asm/io.h         | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index 806e9dc2a852..a4d1b5f771f6 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -69,7 +69,7 @@ static inline int icache_is_aliasing(void)
 	return test_bit(ICACHEF_ALIASING, &__icache_flags);
 }
 
-static inline int icache_is_vpipt(void)
+static __always_inline int icache_is_vpipt(void)
 {
 	return test_bit(ICACHEF_VPIPT, &__icache_flags);
 }
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 665c78e0665a..e6cca3d4acf7 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -145,7 +145,7 @@ extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
 
-static inline void __flush_icache_all(void)
+static __always_inline void __flush_icache_all(void)
 {
 	if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
 		return;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 42ce41eef274..2a746b99e937 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -435,13 +435,13 @@ cpuid_feature_extract_signed_field(u64 features, int field)
 	return cpuid_feature_extract_signed_field_width(features, field, 4);
 }
 
-static inline unsigned int __attribute_const__
+static __always_inline unsigned int __attribute_const__
 cpuid_feature_extract_unsigned_field_width(u64 features, int field, int width)
 {
 	return (u64)(features << (64 - width - field)) >> (64 - width);
 }
 
-static inline unsigned int __attribute_const__
+static __always_inline unsigned int __attribute_const__
 cpuid_feature_extract_unsigned_field(u64 features, int field)
 {
 	return cpuid_feature_extract_unsigned_field_width(features, field, 4);
@@ -564,7 +564,7 @@ static inline bool system_supports_mixed_endian(void)
 	return val == 0x1;
 }
 
-static inline bool system_supports_fpsimd(void)
+static __always_inline bool system_supports_fpsimd(void)
 {
 	return !cpus_have_const_cap(ARM64_HAS_NO_FPSIMD);
 }
@@ -575,7 +575,7 @@ static inline bool system_uses_ttbr0_pan(void)
 		!cpus_have_const_cap(ARM64_HAS_PAN);
 }
 
-static inline bool system_supports_sve(void)
+static __always_inline bool system_supports_sve(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_SVE) &&
 		cpus_have_const_cap(ARM64_SVE);
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4e531f57147d..6facd1308e7c 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -34,7 +34,7 @@ static inline void __raw_writew(u16 val, volatile void __iomem *addr)
 }
 
 #define __raw_writel __raw_writel
-static inline void __raw_writel(u32 val, volatile void __iomem *addr)
+static __always_inline void __raw_writel(u32 val, volatile void __iomem *addr)
 {
 	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
 }
@@ -69,7 +69,7 @@ static inline u16 __raw_readw(const volatile void __iomem *addr)
 }
 
 #define __raw_readl __raw_readl
-static inline u32 __raw_readl(const volatile void __iomem *addr)
+static __always_inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	u32 val;
 	asm volatile(ALTERNATIVE("ldr %w0, [%1]",
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
