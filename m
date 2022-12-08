Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512508F72
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:40:05 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 94-20020a17090a09e700b002191897f70aso1553439pjo.9
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=Ugo1DqBeZmR2xTK0AkED7lfL+7STt3iSpzM3GDVtshWJQlLBKLqkroHnI6c79t0YGK
         IY8A9VIENyH0hazW5LP+ZgK+pdZkfVlRPmmUk/Bb0Kg0gAAE0sGdK+jzGB9aBS/4j+0L
         J3SZHHArNyVyCgfgu9JarNMHMvfmhHxeEYuvIPY1DegORjbWKkHmntav3uvJcMhFWnEh
         jywP9XBH+wICUOW3ZvTAfQ5y06AUAStb9bduKKUyT74otCQNFRYdYrQwsDG3Xav4nvrj
         I2aHUWt8xO37EXjxdoqWCkrolWYpoW8jWB4C+0hv3yEq9mFbT7l8bHfOQ3SEDKnnDCAA
         J3ug==
X-Gm-Message-State: ANoB5pmnNgsJ0++7V/YB8OXSe+E3iWkMXP2js8zZGIeh3H76/MJP73Tl
	i06KKxzff50166jww4H83/lJCecyWGJf/A==
X-Google-Smtp-Source: AA0mqf4ImIWXetG7XX1SXxRXGnECaJ0ODlsgksb3SPKCTTh3sr1uwrp/2qso+8Xm6A48WDYB3HG6hZIxDgKp9g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2183:b0:574:2104:5657 with SMTP
 id h3-20020a056a00218300b0057421045657mr5713585pfi.58.1670528404717; Thu, 08
 Dec 2022 11:40:04 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:54 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-35-dmatlack@google.com>
Subject: [RFC PATCH 34/37] KVM: MMU: Move the TDP iterator to common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Nadav Amit <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221208193854.OzhwLddBF2I6wJ2NW5OBQve4xqd__H_Mu-jE5p4l_Ss@z>

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

