Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5669BC4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF684B813;
	Thu,  8 Dec 2022 14:40:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yeujbXVSmlYv; Thu,  8 Dec 2022 14:40:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1F404BA99;
	Thu,  8 Dec 2022 14:40:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95FCD4BA85
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3RFSjYtxiZc7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:09 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E84B94BA79
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:06 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 i10-20020a25f20a000000b006ea4f43c0ddso2549209ybe.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=ZDFxAZ/PI9aKYqwedjkDPDUn0PCD9WUxHYy13eGAWTI=;
 b=UW5TQakihQ1Rj8oX0fHh6ol3yHICPRAUjId2fBE9HBOx4Z4cfwRHCzOFro0DVog5Py
 z1d9aYSN4fRQh+yVjk9c6erIMnvGY+3XCA5eND2mJd3lmcs6ZMcic9/HWoIHmoYD+B1m
 XjqLDiAn+QBJHnf0vzOfnGkxZlkIa53ilOScS8egg7kyZLK+h2NKejyWCaVjbbt+sR5R
 IhfagMv7s1KO30A1KDYGC5ziILrcoD8HH6N1IH5+EVj3HMWjpbtHUPdv5fpd7dQKJ+67
 MzWuFb+b2SqNDBq56KYHPAYiPt7QBIFy/9sPV8aGa7CXG5RzY4NELQedDkJBW9qr9WbA
 evPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ZDFxAZ/PI9aKYqwedjkDPDUn0PCD9WUxHYy13eGAWTI=;
 b=jUteMmrOjOSPytRrF1EixumnfDElsc9B7aboN3g1JPekd8DSuQOc2DwI+Dono1mQwF
 SPO/WZhFjMGiB+6MoF86OCwHIuZrVcvI/j05lbw5KMUc0dnR44dIiT2MfIcUTposO+mm
 ZFZVm2IyMzn+ktuYEy5noarxKDfVJezoew4ZqkoBYwD5SfxcBR/pmZ+J77JLis//vAoW
 mLSUD0TFWhtJKpTiZdkYKH03W52ZWgU3R0nr+tA3gsvAztqDAnSO9NLF4CbsEPwZcvj1
 XjKcstjmC2Xg83uQut+h0aKcUIK+DWeb7+g14RmfgFdPi+4H92Zi94Dwt9GXn7Z44DuH
 XBdg==
X-Gm-Message-State: ANoB5plJUWL/wBv5HageT3hssz76mItxbK0M+yrp8r4DzYV2PRRds4gw
 E8nKF6XZ73AXNq51nfEeu5BX5GO5Bmwn2w==
X-Google-Smtp-Source: AA0mqf4h5P1c4eLdLR7BQ8qrkqY9isQdWdfvRcIECxB1d810mucDHdG6W99tV9EeqSL89xl1lTy+w8pwh40XXQ==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6a89:0:b0:6dd:989f:2af4 with SMTP id
 f131-20020a256a89000000b006dd989f2af4mr92028743ybc.38.1670528406445; Thu, 08
 Dec 2022 11:40:06 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:55 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-36-dmatlack@google.com>
Subject: [RFC PATCH 35/37] KVM: x86/mmu: Move tdp_mmu_max_gfn_exclusive() to
 tdp_pgtable.c
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

Move tdp_mmu_max_gfn_exclusive() to tdp_pgtable.c since it currently
relies on the x86-specific kvm_mmu_max_gfn() function. This can be
improved in the future by implementing a common API for calculating the
max GFN.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c             | 11 -----------
 arch/x86/kvm/mmu/tdp_pgtable.c         | 11 +++++++++++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
index ff2691ced38b..c1047fcf1a91 100644
--- a/arch/x86/include/asm/kvm/tdp_pgtable.h
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -67,4 +67,7 @@ u64 tdp_mmu_make_changed_pte_notifier_pte(struct tdp_iter *iter,
 					  struct kvm_gfn_range *range);
 u64 tdp_mmu_make_huge_page_split_pte(struct kvm *kvm, u64 huge_spte,
 				     struct kvm_mmu_page *sp, int index);
+
+gfn_t tdp_mmu_max_gfn_exclusive(void);
+
 #endif /* !__ASM_KVM_TDP_PGTABLE_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c035c051161c..c950d688afea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -828,17 +828,6 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
-{
-	/*
-	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
-	 * a gpa range that would exceed the max gfn, and KVM does not create
-	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
-	 * the slow emulation path every time.
-	 */
-	return kvm_mmu_max_gfn() + 1;
-}
-
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			       bool shared, int zap_level)
 {
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index fb40abdb9234..4e747956d6ee 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -170,3 +170,14 @@ int tdp_mmu_max_mapping_level(struct kvm *kvm,
 {
 	return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
 }
+
+gfn_t tdp_mmu_max_gfn_exclusive(void)
+{
+	/*
+	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
+	 * a gpa range that would exceed the max gfn, and KVM does not create
+	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
+	 * the slow emulation path every time.
+	 */
+	return kvm_mmu_max_gfn() + 1;
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
