Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCD7C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AFA34B99B;
	Thu,  8 Dec 2022 14:40:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sjBDqn4HAxcp; Thu,  8 Dec 2022 14:39:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E29E4BA87;
	Thu,  8 Dec 2022 14:39:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E25814BA23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tCkCx0N3jeGy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:55 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 376BD4BA3A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:54 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 k7-20020a256f07000000b006cbcc030bc8so2528795ybc.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=XBAoBS5l4frpeZWkoJY/UpoQSbDyst8wBhQ9eKXZWXc=;
 b=nlEUPxR6NdyPJq+SxFDJtYRvDL+tSADMT14c6WeSKQQEUdTazqiEtfTEk+SgwjuGEq
 FmaRagIrALcak/FA6XBnlNgJ1op1uF68f9N8DQlFMf5Lg2V/XHFSd+dxvK4sOLW7bEkP
 RGyMlm7idURAZy4kLXqSJMwKdSUs8Pvjw42c4F3o6sWDVgr7R6EWxFOWpXNGMLR+X4qI
 871FbXvdNcwcg/9Wsr6QYxmjjpELz0YhLIMlRDhO3bl+KizlZ1eAChWn2q1SbXmr+KvW
 0p6sqHH9DhxqHphJvurk7B3DlzGH0FBewCHxofIksuZgZ1LvKdA0uEEqGlD800vqy01i
 +GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XBAoBS5l4frpeZWkoJY/UpoQSbDyst8wBhQ9eKXZWXc=;
 b=rTZlpYnOBrQFrUcJBdKgbHfNai1cbsso0hkzKY9e1OhXLbve2NP4z1A44lLPcx9tym
 ozRC1DQEY6fGOQx6u3dza+ipH5FOEgAAC9dex+TiJ8l1U9hUY73BtzlVqNSwoBE4b4nR
 DotzyXhGixzP7IA2lhzCeeiGud33b/+FKVPxWxBltJHe91/2/7Kk7zo1bmXNIPHQpegV
 OvmBloOOpnHPIEKhuHUqi/G1cmatdbEncKzQ95iRIXak4CH3gG6Z+uWq8CX1h1fWX0fK
 /p891AnjmT5yf0Bh/jkRn8u/5SSIh84lU4TyYoCFsmihFD58r5IobrkaDZ+6YsG126M8
 Q9dA==
X-Gm-Message-State: ANoB5pmIQlR7CRemq/jhB5JTlamPV99+qk8evsy86ftTvfLgwQ7qYzWK
 kVAPv4JigS5mz+/Gqho6rshxATQu8VKqnw==
X-Google-Smtp-Source: AA0mqf5xyrJDk8LkqxteQO3uKW9sySGhyFdSCZp1IMvsR62i1Fel4cZTd1/kwLAP2Vd6/CjzjTgnduujan+3NQ==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d34d:0:b0:6fa:7b0a:3eed with SMTP id
 e74-20020a25d34d000000b006fa7b0a3eedmr35292093ybf.83.1670528393951; Thu, 08
 Dec 2022 11:39:53 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:48 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-29-dmatlack@google.com>
Subject: [RFC PATCH 28/37] KVM: MMU: Stub out tracepoints on non-x86
 architectures
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

Create stub tracepoints outside of x86. The KVM MMU tracepoints can be
moved to common code, but will be deferred to a future commit.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 include/kvm/mmutrace.h     | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 include/kvm/mmutrace.h

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 891877a6fb78..72746b645e99 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,12 +2,12 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "mmutrace.h"
 #include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
 
 #include <kvm/tdp_pgtable.h>
+#include <kvm/mmutrace.h>
 
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
diff --git a/include/kvm/mmutrace.h b/include/kvm/mmutrace.h
new file mode 100644
index 000000000000..e95a3cb47479
--- /dev/null
+++ b/include/kvm/mmutrace.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_KVM_MMUTRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_MMUTRACE_H
+
+#ifdef CONFIG_X86
+#include "../../arch/x86/kvm/mmu/mmutrace.h"
+#else
+#define trace_mark_mmio_spte(...)		do {} while (0)
+#define trace_kvm_mmu_get_page(...)		do {} while (0)
+#define trace_kvm_mmu_prepare_zap_page(...)	do {} while (0)
+#define trace_kvm_mmu_set_spte(...)		do {} while (0)
+#define trace_kvm_mmu_spte_requested(...)	do {} while (0)
+#define trace_kvm_mmu_split_huge_page(...)	do {} while (0)
+#define trace_kvm_tdp_mmu_spte_changed(...)	do {} while (0)
+#endif
+
+#endif /* _TRACE_KVM_MMUTRACE_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
