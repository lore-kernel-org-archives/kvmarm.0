Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E5C10F1B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0943C4BA2A;
	Thu,  8 Dec 2022 14:39:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sGHGv0vRh929; Thu,  8 Dec 2022 14:39:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2E284BA70;
	Thu,  8 Dec 2022 14:39:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 010B54BA18
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzl8DvGGyGTz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:25 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1BC84BA1B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:25 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-360b9418f64so24730617b3.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=jgO+J07Uxt+qL/UpUVJ8WFrJDihM9AG5kpD8vJwjTTs=;
 b=QrMj5zLDlUXO+ZJ45hsRtxdfgmeW4IfijEqSAU7FIBqFwathovRwq/mzAGouVficrL
 gQcJIU9VmUG2hiNERRKbyTP3Lu3VIHMZ2AloTdIYXMt+wMOuMe8kDJQZMRgSvO6lAwNU
 Y6eBROrQrZ0gTi3qA1W8jY3mdXkghgQbhZG8f+ggIaWBggOtbOEtA4aAL9qoZ6wA6iTL
 UulvutyuA0lBG+LimgEdM3A93jCX+bLrq+G1CQa39qEIq4rZ4XwAKrU+qa0csJ6wjd9Z
 9Ua/MZeoHkveM5nl5wYxeuSnKf6S8qPxrJT/LRGNG++VotU8B0SenTfkKWEFNecwApXV
 JVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=jgO+J07Uxt+qL/UpUVJ8WFrJDihM9AG5kpD8vJwjTTs=;
 b=Cu7FdEg7DhTlGCUFfOWSA+G49lhEEIxtBgtfc6SUXtXTiklN3OIR838yFOsPr01VsK
 JsLtTdVsT5ykJgZ/et1fy7odMj4GEgBjs++UeQZb1XZq9ZVkCyPCM+E2WJzK4hmoOz3f
 UxH6Sp2vHSFFKHRo4t+zLF2rQ/qo+dRSKV27B4HQQ2rynz55VAVSZesryTe8+sOj5YR8
 ovFesPZH9qM0KCEEEs1p9AchsNdjmqhQxX18jHTzXZEdMakcve49fhr/jD7XjpWkRQyU
 ZEh6ne+rM44GooTRTXYvTnEq7fYz+LwPK3CthHoY6faUwxQCwHq9vJySqmvi56g0EgtM
 bm1w==
X-Gm-Message-State: ANoB5pmoMvi/I7Dbpo+iejZj2SkJK/KSBqZIa/6Ts8ZcBf1rznW/HcML
 xBHFgfsHZIpG26NBVdf2wYunS/nCD8o/aw==
X-Google-Smtp-Source: AA0mqf4cuymNRC2hTArY/T3ebCSKh1ZW9fvhwu59cqHtPCYYXp2h3U5rWse1hGwJtXv7Z28ATD5Q6YFLoVGbsg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d03:0:b0:706:e165:f752 with SMTP id
 3-20020a250d03000000b00706e165f752mr8717208ybn.510.1670528365193; Thu, 08 Dec
 2022 11:39:25 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:31 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-12-dmatlack@google.com>
Subject: [RFC PATCH 11/37] KVM: MMU: Move RET_PF_* into common code
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

Move the RET_PF_* enum into common code in preparation for moving the
TDP MMU into common code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 28 ----------------------------
 include/kvm/mmu_types.h         | 26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4abb80a3bd01..d3c1d08002af 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -79,34 +79,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
-/*
- * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
- * and of course kvm_mmu_do_page_fault().
- *
- * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
- * RET_PF_RETRY: let CPU fault again on the address.
- * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
- * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
- * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
- *
- * Any names added to this enum should be exported to userspace for use in
- * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
- *
- * Note, all values must be greater than or equal to zero so as not to encroach
- * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
- * will allow for efficient machine code when checking for CONTINUE, e.g.
- * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.
- */
-enum {
-	RET_PF_CONTINUE = 0,
-	RET_PF_RETRY,
-	RET_PF_EMULATE,
-	RET_PF_INVALID,
-	RET_PF_FIXED,
-	RET_PF_SPURIOUS,
-};
-
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch)
 {
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
index 9f0ca920bf68..07c9962f9aea 100644
--- a/include/kvm/mmu_types.h
+++ b/include/kvm/mmu_types.h
@@ -110,4 +110,30 @@ struct kvm_page_fault {
 	struct kvm_page_fault_arch arch;
 };
 
+/*
+ * Return values for page fault handling routines.
+ *
+ * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ * RET_PF_FIXED: The faulting entry has been fixed.
+ * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ *
+ * Any names added to this enum should be exported to userspace for use in
+ * tracepoints via TRACE_DEFINE_ENUM() in arch/x86/kvm/mmu/mmutrace.h.
+ *
+ * Note, all values must be greater than or equal to zero so as not to encroach
+ * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, which
+ * will allow for efficient machine code when checking for CONTINUE.
+ */
+enum {
+	RET_PF_CONTINUE = 0,
+	RET_PF_RETRY,
+	RET_PF_EMULATE,
+	RET_PF_INVALID,
+	RET_PF_FIXED,
+	RET_PF_SPURIOUS,
+};
+
 #endif /* !__KVM_MMU_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
