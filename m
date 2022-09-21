Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B539C32771
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 699CC4B630;
	Tue, 20 Sep 2022 23:53:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cDvGK7ywNnwa; Tue, 20 Sep 2022 23:52:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 173DA4B797;
	Tue, 20 Sep 2022 23:52:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA5B4B62D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:52:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PRefBbEf5Vdi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:52:56 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 717BB4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:52:56 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-349e6acbac9so41534347b3.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=42cERv183XkdijpZKmHZz40mbcPpqj2SrtFe6QYwGFo=;
 b=jVQ+bhDPfNgb0Zv4dGdFOtZE7zp+ky3p9ZGgipNye8ZQLu+7IBE2l+m4cx+/S0TDcz
 l+1yKZjjyNH9ZRtvPSrA64qY0h+2Wv7IKqjVeul9rbOx+ctbvACt40l1MB7ROnMK8V1Y
 VEblbUVxXjAUhXTFlVGZj3pj1pWElOm6nItK2amAMNiPiMLUd0VjFsYj2ZWy5V5KVrVG
 GVTA5YpreEksMgvyiavKHtMmgVLBG1/UZmT1XNY5XQfKHPvNDBsvGSlfdn7t1R/mKWwf
 EiCotOeQ6p6PlDaFGst3cqPTKkMSggxwhEoHTiQepXglqKoEBj/p3y0/nukuvzOitB89
 x/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=42cERv183XkdijpZKmHZz40mbcPpqj2SrtFe6QYwGFo=;
 b=ewZrzlUumBcV2TpQbX9aLOSAKUYbUe6TDUhUaMqUqRfr1lTRlFdKyJR3IoiXvcfC5w
 W+TcITRsajxdR2rX5j9PIpahtmyGwNW8vfrqhK2B+wVHaySIRB00gQ5+reQsmo4W013/
 nLG1Tw+yOrSKUYC/CMxZFxJnUucgSpQMsUFAHKkmYa/DvYH2TKGNVClQcUk7TkA06ozx
 0kdO5tiWo8B/BUTQV2l0PbMs1vCGo3gxFv7SwW1jmaXIACdn6VV4Em7Cpes+QzyK1gRU
 vehFsT8/Ww5TghgYwqdzePdIAivXkw3arPKTNB8Ee+oQ6aBac1RgSDSnLRaE0OC9zSKk
 PcOA==
X-Gm-Message-State: ACrzQf1RJHneOSqWphfy2ijPyARb0EGmkV3BuVQhhrhG5tRcppS6gdms
 UoM/6pQQpsje+abh3SK1PgeB3CQ=
X-Google-Smtp-Source: AMsMyM5jNbWhmU932B8rxoEtdjT72QIvotJbqv2VWYv5z9L9TSsYcgjchE7s/pbH6gd6ko4Ir8CmwwU=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:9290:0:b0:6b3:8040:b6e4 with SMTP id
 y16-20020a259290000000b006b38040b6e4mr16367847ybl.481.1663732375937; Tue, 20
 Sep 2022 20:52:55 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:33 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-2-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 1/8] mm: Do not enable PG_arch_2 for all 64-bit
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
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Price <steven.price@arm.com>
---
 arch/arm64/Kconfig             | 1 +
 fs/proc/page.c                 | 2 +-
 include/linux/page-flags.h     | 2 +-
 include/trace/events/mmflags.h | 8 ++++----
 mm/Kconfig                     | 8 ++++++++
 mm/huge_memory.c               | 2 +-
 6 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f6737d2f37b2..f2435b62e0ba 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1948,6 +1948,7 @@ config ARM64_MTE
 	depends on ARM64_PAN
 	select ARCH_HAS_SUBPAGE_FAULTS
 	select ARCH_USES_HIGH_VMA_FLAGS
+	select ARCH_USES_PG_ARCH_X
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
 	  architectural support for run-time, always-on detection of
diff --git a/fs/proc/page.c b/fs/proc/page.c
index a2873a617ae8..6f4b4bcb9b0d 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -218,7 +218,7 @@ u64 stable_page_flags(struct page *page)
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
index ceec438c0741..a976cbb07bd6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -999,6 +999,14 @@ config ARCH_USES_HIGH_VMA_FLAGS
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
index 1cc4a5f4791e..24974a4ce28f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2444,7 +2444,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_workingset) |
 			 (1L << PG_locked) |
 			 (1L << PG_unevictable) |
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
 #endif
 			 (1L << PG_dirty) |
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
