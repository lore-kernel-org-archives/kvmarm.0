Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6609C8F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id c188-20020a25c0c5000000b006d8eba07513so2556702ybf.17
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jUiXg4Z/i5LqOe33gxGyRTPndvvAyQq0aDF8Gx926dw=;
        b=ighxqg/snU4tXdcxe5rmS9diIJMEYpBho3CcnpnWuQAtED+AhBGXYG30AvZnewuYSW
         +PxEPLajwD76T6tHoZB9rvsCIME05+Ml22rzK5huArVtcScCbqC6ekIOU+P5myHm4vXi
         R4EgQzje0PuBByDUR9/7eRDNQOVtYlSk3/+EZQFbpySSyYsvRa5mxUOW+WJy7P2kVHMr
         LdNRgzhOQbMvhiL/Ue8veJ5C2WtFDdDcwfdEEzx+4yjZrEaMU4AD1VnloLuIWDHrzj2p
         Nqw4S8uRQquwfvmcYjqYXUnPBaJxW1MX4LbeXgp1e25+ZAuz42vzjcVwAFjS+W3H33cg
         ky4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jUiXg4Z/i5LqOe33gxGyRTPndvvAyQq0aDF8Gx926dw=;
        b=MwVdz8T0OTvO45iUpmY442zrniP/EFvRLNuRBc9lVGoZ4bRIugGRo7Txh6OOFb9GcD
         e4KuOHN+YQ/XtpYWhm/oXU/GdTy7lUduIaTW8WYRAiK6vfjl3+rnbrnnrsBdknznR0aZ
         qH/C+iaT+jFylBnfrbvyGUjukthdI8V3+yB0O25Ugy2F28aXWwa8bX3sr4ZlldxxTm/h
         f032vczUMljcIJAUyzqanWiZUk9iMkxbBY0ezGNRqZ8MR/cc3f28KmZaKpdjVSuVCHXW
         H/u0BicZAj9edtn7yVWIS4mH8VkNXcWzMUWG7psdsURUJq9v02whFjlABW8uSrL0Sh2M
         FMOg==
X-Gm-Message-State: ANoB5pkpQNM19wdaT0AVTdWJL5UwfiNIabvoihXl83KOzNlx+8tIWzh0
	7t+OkEPg4uQuq+RcPoB0KGpXBSM96UJIaw==
X-Google-Smtp-Source: AA0mqf5wtd6nzz7Bw3k0h8Agwz4nMHxILunKJx9Z/GTmhAEf2vfAyvwOajGTYXd4NdEjBogKL293TlwJdHSxug==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:7a03:0:b0:6dd:7c0a:4520 with SMTP id
 v3-20020a257a03000000b006dd7c0a4520mr93728044ybc.352.1670528368448; Thu, 08
 Dec 2022 11:39:28 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:33 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-14-dmatlack@google.com>
Subject: [RFC PATCH 13/37] KVM: MMU: Move sptep_to_sp() to common code
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
Message-ID: <20221208193833.4WVwC0yc6hYH6wtddaeWCB5e-DpSWy56rV69gIMk4rA@z>

Move sptep_to_sp() to common code in preparation for moving the TDP MMU
to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.h | 14 ++------------
 include/kvm/mmu.h       | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)
 create mode 100644 include/kvm/mmu.h

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ad84c549fe96..4c5d518e3ac6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -3,6 +3,8 @@
 #ifndef KVM_X86_MMU_SPTE_H
 #define KVM_X86_MMU_SPTE_H
 
+#include <kvm/mmu.h>
+
 #include "mmu_internal.h"
 
 /*
@@ -219,23 +221,11 @@ static inline int spte_index(u64 *sptep)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
-{
-	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
-
-	return (struct kvm_mmu_page *)page_private(page);
-}
-
 static inline struct kvm_mmu_page *spte_to_child_sp(u64 spte)
 {
 	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
 }
 
-static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
-{
-	return to_shadow_page(__pa(sptep));
-}
-
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/include/kvm/mmu.h b/include/kvm/mmu.h
new file mode 100644
index 000000000000..425db8e4f8e9
--- /dev/null
+++ b/include/kvm/mmu.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_MMU_H
+#define __KVM_MMU_H
+
+#include <kvm/mmu_types.h>
+
+static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
+static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
+{
+	return to_shadow_page(__pa(sptep));
+}
+
+#endif /* !__KVM_MMU_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

