Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD95C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0F74BA83;
	Thu,  8 Dec 2022 14:40:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7fxXNss-Yg6V; Thu,  8 Dec 2022 14:40:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A89094BA76;
	Thu,  8 Dec 2022 14:40:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1983C4BA7E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 93NkI3m0IRmb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:07 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D48D24BA7A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:05 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 u3-20020a056a00124300b0056d4ab0c7cbso1743537pfi.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=7el2leYxw6DuE2TKpxO/GVa0AQVZhVPYSCMmz19ZHuI=;
 b=O++bFFpSURwB8JUZDeWwEc8lxc4/9crS2K4HsyuyBbvilW8kdB4FZPUpBapa95NsxY
 0xO+2BUFvsH7Lv9OpM/ZNw6lAX1BZkwmvpchLqFMC1N46mGiLFFJBG/HkNWtdDFKz0HV
 gaJZcacGlJwuJDiHLoKW0WYD/nKr6azk72Tngx5olXe8pBzakRuhI16DprQMVZTjM2QI
 klMPqFL6afDQzxyjJFzvNFwT6YpAogs4p8iE9rScX7ZpN21ivdBFghpL37wrQT+9CnOv
 tdduCPP5Ti74kCPUwjTk76Ln1pEwMrFI/tCITETf7aNuyVpMp2Rq1UKSZarbJfTksvTP
 6Wqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=7el2leYxw6DuE2TKpxO/GVa0AQVZhVPYSCMmz19ZHuI=;
 b=YAFvw0+HP8ddJH4ICtsM9iNoy5tDtL6bCy7KKMEIM9K4xDwpdx2tYK1nAFbXns59u9
 nYF2o0qYhQx0rO4YbEb6IBQQcsXcr9BFBjdHptLMUGqgaVOVHNPxXN5KRUyyc4q4AH92
 GdNeP8ItdvL5iE8qRZ86oxKLC9EuRfgZCr0021TzZew+fHPR5/pQGIqrea4i27ev+qNj
 W6B/UfYaBEOBgXpSJ3h/p1KlkWlNQsVwYpIsyLdrPXso/0DFLr/t5oh8aaJclfJ9Klua
 Fwbv1NirdNA7btCZ2Qh6HVSzTPnOM7erdjGKX69qFN9UzS/Py6i5VfVy89uE3+PGKPgC
 E8GA==
X-Gm-Message-State: ANoB5pk4EoDxvZ1oJlPbHIKAX/xZ+vqt75qqm8xUXH67EffYbXFi5ABh
 /QF3U3D8AnwXRG4uIbuYDCtXajD4TvvuLg==
X-Google-Smtp-Source: AA0mqf4ImIWXetG7XX1SXxRXGnECaJ0ODlsgksb3SPKCTTh3sr1uwrp/2qso+8Xm6A48WDYB3HG6hZIxDgKp9g==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2183:b0:574:2104:5657 with SMTP
 id h3-20020a056a00218300b0057421045657mr5713585pfi.58.1670528404717; Thu, 08
 Dec 2022 11:40:04 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:54 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-35-dmatlack@google.com>
Subject: [RFC PATCH 34/37] KVM: MMU: Move the TDP iterator to common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Move arch/x86/kvm/mmu/tdp_iter.{c,h} to into common code so that it can
be used by other architectures in the future.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                                  | 2 +-
 arch/x86/kvm/Makefile                        | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                   | 2 +-
 arch/x86/kvm/mmu/tdp_pgtable.c               | 2 +-
 {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h | 9 +++------
 virt/kvm/Makefile.kvm                        | 2 ++
 {arch/x86 => virt}/kvm/mmu/tdp_iter.c        | 4 +---
 7 files changed, 10 insertions(+), 13 deletions(-)
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h (96%)
 rename {arch/x86 => virt}/kvm/mmu/tdp_iter.c (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e586d7ba78c..3c33eca85480 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11206,7 +11206,7 @@ F:	include/uapi/asm-generic/kvm*
 F:	include/uapi/linux/kvm*
 F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
-F:	virt/kvm/*
+F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c294ae51caba..cb9ae306892a 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,7 +18,7 @@ ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1f1f511cd1a0..c035c051161c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,10 +2,10 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <kvm/tdp_iter.h>
 #include <kvm/tdp_pgtable.h>
 #include <kvm/mmutrace.h>
 
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index cc7b10f703e1..fb40abdb9234 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -2,10 +2,10 @@
 
 #include <linux/kvm_types.h>
 #include <kvm/tdp_pgtable.h>
+#include <kvm/tdp_iter.h>
 
 #include "mmu.h"
 #include "spte.h"
-#include "tdp_iter.h"
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_TDP_PTE & SPTE_MMU_PRESENT_MASK));
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/include/kvm/tdp_iter.h
similarity index 96%
rename from arch/x86/kvm/mmu/tdp_iter.h
rename to include/kvm/tdp_iter.h
index 6e3c38532d1d..0a154fcf2664 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/include/kvm/tdp_iter.h
@@ -1,14 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#ifndef __KVM_X86_MMU_TDP_ITER_H
-#define __KVM_X86_MMU_TDP_ITER_H
+#ifndef __KVM_TDP_ITER_H
+#define __KVM_TDP_ITER_H
 
 #include <linux/kvm_host.h>
 #include <kvm/tdp_pgtable.h>
 
-#include "mmu.h"
-#include "spte.h"
-
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
  * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
@@ -117,4 +114,4 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
-#endif /* __KVM_X86_MMU_TDP_ITER_H */
+#endif /* __KVM_TDP_ITER_H */
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367..58b595ac9b8d 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,3 +12,5 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
+
+kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_iter.o
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/virt/kvm/mmu/tdp_iter.c
similarity index 98%
rename from arch/x86/kvm/mmu/tdp_iter.c
rename to virt/kvm/mmu/tdp_iter.c
index d5f024b7f6e4..674d93f91979 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/virt/kvm/mmu/tdp_iter.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "mmu_internal.h"
-#include "tdp_iter.h"
-#include "spte.h"
+#include <kvm/tdp_iter.h>
 
 /*
  * Recalculates the pointer to the SPTE for the current GFN and level and
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
