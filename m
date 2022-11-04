Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B312C43219
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F41134A49C;
	Thu,  3 Nov 2022 21:11:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AZopHq0VTHfH; Thu,  3 Nov 2022 21:11:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70F0C4291D;
	Thu,  3 Nov 2022 21:11:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F23E240FF0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g3QbvU+QwI-b for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:02 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97ECD41070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:02 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 p66-20020a257445000000b006ca0ba7608fso3619202ybc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=+t0ALZHHA6ZFAi9QaYH6w0GblkExI9N8HBofpI53uEE=;
 b=coTqk8yN2lIpqf4lZuerdn/huDOzxShTgkUYVz06et76b9CUvnZWNbtYisMo8FAJe+
 bHk+un7ojScHCm3ttSHWveijfJgkQQ/jpEW9ZKdZyv5p9OsycrZW1cxlQuscVQzarevk
 V4p3UgCQesiJYEiFHSXHaD/VrBYJQTObnqJsK/fzbJ4ufyKAjS9D7JJn2vA82q7Wltzt
 PEQH5DmcP5NluJrA7GoVk2s2O7t3QYXkBouu9I8kK1VinDt230mAoZRqSluKQBeY4bp7
 vis3SkJ4xkj0sa2+msOP+yymYx/cL417FhqniDtlLNIh+ro5KCiTLnGXeXAHWGqf5Dee
 HA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+t0ALZHHA6ZFAi9QaYH6w0GblkExI9N8HBofpI53uEE=;
 b=nDaQvSjM2s8R/8uueHHNga02My3aFE4l7mTC2DMPJ7d2In18wHyaYZ/XDl0/BhjHHb
 k06yQ6NUpSrkJFfY8Wqo5jb9Mkr3AQbQaYlOF4u/LSxb1DFqoNRpU/2DR1Z5kzYg0VRF
 GnnvxY3ch+sHGwGz6IGOojaU6V2W96xsm5SPbhueCgi7fe6KYiomuvLjN1CbyTyF7FuN
 rmxq0dZuvhYOl0xOL0acRdrq7qAgyrz4FR1DVR1c55Ka7c7YlaT4953exXyb4SQwPwbQ
 SWqas1r/No55nePr9hJ4scfBCP8g4e71dwJu5HdCmwnRRuu+FObrG1XDgkiAR7d75hID
 kkdA==
X-Gm-Message-State: ACrzQf1VlRzIVWze0/uOA5tQMhwDm3a5LuESpNhul+JR3SkQRzcULX5G
 8HNiG2fNorWexltzWVA4paa9ULM=
X-Google-Smtp-Source: AMsMyM6DSVuK9mNKweU8pz1/m0WgjmOG8tIlqPQ+K5VyNJKxYPnNKrmU1a5ZoZdyX5Qe9xdFOo1rCys=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a05:690c:822:b0:35c:b671:d36a with SMTP id
 by2-20020a05690c082200b0035cb671d36amr203232ywb.62.1667524262070; Thu, 03 Nov
 2022 18:11:02 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:34 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-2-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 1/8] mm: Do not enable PG_arch_2 for all 64-bit
 architectures
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kernel test robot <lkp@intel.com>, kvm@vger.kernel.org,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

From: Catalin Marinas <catalin.marinas@arm.com>

Commit 4beba9486abd ("mm: Add PG_arch_2 page flag") introduced a new
page flag for all 64-bit architectures. However, even if an architecture
is 64-bit, it may still have limited spare bits in the 'flags' member of
'struct page'. This may happen if an architecture enables SPARSEMEM
without SPARSEMEM_VMEMMAP as is the case with the newly added loongarch.
This architecture port needs 19 more bits for the sparsemem section
information and, while it is currently fine with PG_arch_2, adding any
more PG_arch_* flags will trigger build-time warnings.

Add a new CONFIG_ARCH_USES_PG_ARCH_X option which can be selected by
architectures that need more PG_arch_* flags beyond PG_arch_1. Select it
on arm64.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[pcc@google.com: fix build with CONFIG_ARM64_MTE disabled]
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/Kconfig             | 1 +
 fs/proc/page.c                 | 2 +-
 include/linux/page-flags.h     | 2 +-
 include/trace/events/mmflags.h | 8 ++++----
 mm/Kconfig                     | 8 ++++++++
 mm/huge_memory.c               | 2 +-
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 2d505fc0e85e..db6b80752e5d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1966,6 +1966,7 @@ config ARM64_MTE
 	depends on ARM64_PAN
 	select ARCH_HAS_SUBPAGE_FAULTS
 	select ARCH_USES_HIGH_VMA_FLAGS
+	select ARCH_USES_PG_ARCH_X
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
 	  architectural support for run-time, always-on detection of
diff --git a/fs/proc/page.c b/fs/proc/page.c
index f2273b164535..882525c8e94c 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -219,7 +219,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
 #endif
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0b0ae5084e60..5dc7977edf9d 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -132,7 +132,7 @@ enum pageflags {
 	PG_young,
 	PG_idle,
 #endif
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	PG_arch_2,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 11524cda4a95..4673e58a7626 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -90,10 +90,10 @@
 #define IF_HAVE_PG_IDLE(flag,string)
 #endif
 
-#ifdef CONFIG_64BIT
-#define IF_HAVE_PG_ARCH_2(flag,string) ,{1UL << flag, string}
+#ifdef CONFIG_ARCH_USES_PG_ARCH_X
+#define IF_HAVE_PG_ARCH_X(flag,string) ,{1UL << flag, string}
 #else
-#define IF_HAVE_PG_ARCH_2(flag,string)
+#define IF_HAVE_PG_ARCH_X(flag,string)
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -129,7 +129,7 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
 IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
diff --git a/mm/Kconfig b/mm/Kconfig
index b0b56c33f2ed..8e9e26ca472c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1005,6 +1005,14 @@ config ARCH_USES_HIGH_VMA_FLAGS
 config ARCH_HAS_PKEYS
 	bool
 
+config ARCH_USES_PG_ARCH_X
+	bool
+	help
+	  Enable the definition of PG_arch_x page flags with x > 1. Only
+	  suitable for 64-bit architectures with CONFIG_FLATMEM or
+	  CONFIG_SPARSEMEM_VMEMMAP enabled, otherwise there may not be
+	  enough room for additional bits in page->flags.
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EXPERT
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d47b3f7b877..5d87dc4611b9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2401,7 +2401,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_workingset) |
 			 (1L << PG_locked) |
 			 (1L << PG_unevictable) |
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
 #endif
 			 (1L << PG_dirty) |
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
