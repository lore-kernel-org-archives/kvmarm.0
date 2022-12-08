Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CB5C2D0CB
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA3E4BA2A;
	Thu,  8 Dec 2022 14:40:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f4S6CvHmky5S; Thu,  8 Dec 2022 14:40:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 125A14BA3A;
	Thu,  8 Dec 2022 14:40:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD064BA24
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IbUCMAEP-jQc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:12 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECE9A4BA0A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:09 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 y6-20020a25b9c6000000b006c1c6161716so2535607ybj.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=9jkEeOR+eFVYLdV/biNhqONLCqpOOeuWNQBN9kUw+a4=;
 b=RcX1fA9WGa6w4C9PUxG4OPVBo1zxjA/xcbKeSP6a3foCAqZ7FzqI1mFwD63t1Zj64f
 dUcsVkx5+LL+NIjjNV1LqNWVddFOpYikSd3WUTyGFLn96H50k7PwdHsttsFJt9P1ez0b
 1mfPx6AlqK6ylftXIU2F9Nj5hSc+ikFrGZ/z1f/qPxYxfvx/OXVl/tDLZo61SUF3zvKK
 PYv1RXX6MMcltPMtFw1Jp+095PHbtWtFgqbpJbKkr0cp5YLn1DUp9X/nB2YNG55HXF6K
 /rKkgYv9i7/aE4/qJBLcexm7xz9bNSYN/tkjp5XaQYlxAPljLege78wWIo+X1uBQR1Re
 /MJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=9jkEeOR+eFVYLdV/biNhqONLCqpOOeuWNQBN9kUw+a4=;
 b=nkktge6H8qMdMhh3/69t10BctX0FnkzDKQFiufJO+I34HvQtNDWFYVH5nEfCFFWBh8
 RaUMXmX9cqPzZeSec/5mJTdoq0J8DrhuSPMKmKWVKfO6wuRCAMgmsDPewFPeQjFLKiAU
 qM1tu8ckLglJjUwh9vh/J1rhFFxecY7CWRDR5M2deobFpqhsqRqNxmoKpCAVKZ7mcgSJ
 ORId5YY4Np2VNzHyOOxTGoeI78iI5gqk9aL6HM0tSQlwUvk9FvW2dStGAolity4JmQVn
 LNISe4udwAWPI/HqRq7WySLCERlMzGRoK+elU12DSGN3suQUmwmDOppEeidZ/x3kKrzm
 LoAA==
X-Gm-Message-State: ANoB5pmex7VVFuaM3yPpw9O5qMzMrlBwvY6H0inZAOsXqk9t75OMwot6
 J0mjG7RDXfx1f4SqnVyHALho8BzYqOzrdw==
X-Google-Smtp-Source: AA0mqf5Y/oazogGX+tpbF7bdOJO4aayzIsYsnlV7zDudirQdvI5dtEVAX371oDYlEt+kHPpaNkmdcoOtQ7CEag==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c6c2:0:b0:6f0:b351:c300 with SMTP id
 k185-20020a25c6c2000000b006f0b351c300mr63444626ybf.102.1670528409549; Thu, 08
 Dec 2022 11:40:09 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:57 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-38-dmatlack@google.com>
Subject: [RFC PATCH 37/37] KVM: MMU: Move the TDP MMU to common code
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

Move tdp_mmu.[ch] from arch/x86 and into the common code directories.
This will allow other architectures to use the TDP MMU in the future.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/Makefile                       | 2 +-
 arch/x86/kvm/mmu/mmu.c                      | 3 ++-
 {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h | 6 +++++-
 virt/kvm/Makefile.kvm                       | 1 +
 {arch/x86 => virt}/kvm/mmu/tdp_mmu.c        | 8 +++-----
 5 files changed, 12 insertions(+), 8 deletions(-)
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h (94%)
 rename {arch/x86 => virt}/kvm/mmu/tdp_mmu.c (99%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index cb9ae306892a..06b61fdea539 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,7 +18,7 @@ ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_mmu.o
+kvm-$(CONFIG_X86_64)	+= mmu/tdp_pgtable.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2602ee1771f..8653776bca6f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -19,7 +19,6 @@
 #include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "tdp_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "smm.h"
@@ -27,6 +26,8 @@
 #include "cpuid.h"
 #include "spte.h"
 
+#include <kvm/tdp_mmu.h>
+
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/include/kvm/tdp_mmu.h
similarity index 94%
rename from arch/x86/kvm/mmu/tdp_mmu.h
rename to include/kvm/tdp_mmu.h
index 607c1417abd1..538c848149c9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/include/kvm/tdp_mmu.h
@@ -5,7 +5,11 @@
 
 #include <linux/kvm_host.h>
 
-#include "spte.h"
+#include <kvm/mmu_types.h>
+#include <kvm/mmu.h>
+#include <kvm/tdp_iter.h>
+#include <kvm/tdp_pgtable.h>
+#include <kvm/mmutrace.h>
 
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 58b595ac9b8d..942681308140 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -14,3 +14,4 @@ kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 
 kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_iter.o
+kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_mmu.o
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/virt/kvm/mmu/tdp_mmu.c
similarity index 99%
rename from arch/x86/kvm/mmu/tdp_mmu.c
rename to virt/kvm/mmu/tdp_mmu.c
index c950d688afea..5ca8892ebef5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/virt/kvm/mmu/tdp_mmu.c
@@ -1,11 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "mmu.h"
-#include "mmu_internal.h"
-#include "tdp_mmu.h"
-#include "spte.h"
-
+#include <kvm/mmu_types.h>
+#include <kvm/mmu.h>
 #include <kvm/tdp_iter.h>
+#include <kvm/tdp_mmu.h>
 #include <kvm/tdp_pgtable.h>
 #include <kvm/mmutrace.h>
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
