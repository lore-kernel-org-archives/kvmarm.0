Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDECC10F1B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6264BA41;
	Thu,  8 Dec 2022 14:39:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7f5zsHX3CGNt; Thu,  8 Dec 2022 14:39:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0153C4BA63;
	Thu,  8 Dec 2022 14:39:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E044BA1A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qCrBd0M0Cm5d for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:30 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6E954BA12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:28 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3fe3bedbb16so24701467b3.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=toFdmm4HtKA+eVzBRfjNti6q3GbkaA/Avnzc+lt1DverOHRJmhgCuaILXW1ODHxuYT
 6/qG+vUnLNA+QrPQr07mTaMYXdEwGLi6nqjBMEVSENCZasHlaXVYyggWK4xTqDc8hDJP
 T+JWuWkaCa70USX3GzVpDLcFA3ulXyHTNSzeeleSpdr3mQxysAxWp+oXo6XK2RHKVeU4
 pFqCdIRzmvC9oz3My8jkYB/gMkJCXtuw4lM+M13kjOApHPCNnxcjOa1QCtUu9ZjNtWAj
 xIQhN6mX+ScOoqOzbIIu7Js1tAXvbUiGJ3SRq8435xVqjAEuJHcL7b90oW9gBSzr1J+P
 crJg==
X-Gm-Message-State: ANoB5pnC58miBQvs41LWRrmC/xo3m2OkSmWtB+cq4VE+0yupahQmcbWD
 2Z3175PnZHP2J0WPKs/pacJg1Qlf6Mr5nQ==
X-Google-Smtp-Source: AA0mqf5wtd6nzz7Bw3k0h8Agwz4nMHxILunKJx9Z/GTmhAEf2vfAyvwOajGTYXd4NdEjBogKL293TlwJdHSxug==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:7a03:0:b0:6dd:7c0a:4520 with SMTP id
 v3-20020a257a03000000b006dd7c0a4520mr93728044ybc.352.1670528368448; Thu, 08
 Dec 2022 11:39:28 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:33 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-14-dmatlack@google.com>
Subject: [RFC PATCH 13/37] KVM: MMU: Move sptep_to_sp() to common code
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
