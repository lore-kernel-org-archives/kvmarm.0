Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731B58F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:40:10 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-3dfb9d11141so24943047b3.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=h7wpqeeUpvkwleQkxlh4fokebUNXMKLvIJ9N480R57+QgTtGRx3T6n4BoS6MfIoTO+
         NS7Q69EPy+WNlM4bnKfc2YLRyNMiUDL2MBwEerGnXrhQ6+6zpNo1HAVtjHP0Id7HB2yW
         YqZwFhv7Avuuv2ip4WXJQGowx3B/2CtBSaBYwajdSyRzeNvF2edV4m0XTYt3+kCoG2OU
         S/LkLWLTfXgDmBcplrikToQvrnogkbFfrP5iS2jqEKjvtVcaUynKiOY+DuRyRbCy6hh4
         Rx2GUgr5UTpZpYoOuVGW/lBylayXFJi5gIg0rRUaK1H34ZwF3M7VtlffRBggbTNIAsTQ
         iEUQ==
X-Gm-Message-State: ANoB5pkNshMYZE39frqtT6CgFpZlBf7S9h97ydWHIVwgFR+JzTJHUnbt
	1zAMwLAdX1kBhw9ozkdckLz1NbPEF4bDpw==
X-Google-Smtp-Source: AA0mqf5Y/oazogGX+tpbF7bdOJO4aayzIsYsnlV7zDudirQdvI5dtEVAX371oDYlEt+kHPpaNkmdcoOtQ7CEag==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c6c2:0:b0:6f0:b351:c300 with SMTP id
 k185-20020a25c6c2000000b006f0b351c300mr63444626ybf.102.1670528409549; Thu, 08
 Dec 2022 11:40:09 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:57 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-38-dmatlack@google.com>
Subject: [RFC PATCH 37/37] KVM: MMU: Move the TDP MMU to common code
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
Message-ID: <20221208193857.pWMY3RSmvWwBZG8_86YYQxgtprZ0AbbaT2KqkCxURNY@z>

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

