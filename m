Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1502C001B2
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC2F4BA19;
	Thu,  8 Dec 2022 14:39:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KPG3WEP9O7VI; Thu,  8 Dec 2022 14:39:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E27D84BA2F;
	Thu,  8 Dec 2022 14:39:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 583274BA22
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q+SjZcCSIt8G for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:42 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC9F34BA13
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:40 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 t5-20020a5b07c5000000b006dfa2102debso2548606ybq.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=CaDXua+LFbRv3ei+U1Fgv/kax6A2A04L4lM62rMK90Q=;
 b=FQRVJBa4KRKObP8S3n7w3f2m+Bcx87+PQgURkRJCXrk7m4BdVxUrIfCvxY3dvCxGvX
 DFNpL9OiA6gV3a7OA6rX48DXADwjzhjgTFiSwWT9yA/sZdiwLepPrDM/Dmol5FJsTFtd
 1z4mxGJZs7yrfwU4FQjUHnKK5PWmnwdRAprtxH5S0Ua5f0HoeWKVyWfSamiqMLNdnacf
 wBp7G+B2Y+E/qsY0zWkyQWEjRsad/cIklCbMqtgv/ZnA3GI3slUIM7MR6Z7bKiBB5z6N
 n2PV1n0iU9J6gxAvFUL2pGUf26H+n9zVjk4Eh4mosAVvSNZBvAGEZTWWsWyjSDwLmgGs
 n+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=CaDXua+LFbRv3ei+U1Fgv/kax6A2A04L4lM62rMK90Q=;
 b=IjPo+P5q1uPAs2a5qJkn0Zg+NM6UetZWM0/YoRdHseOtgtY5+viU4g3WRIA4qPQMQc
 cQIoC5LyPuirICR88DmIxvRttk7uOK4XdshUJisS0opUKJCEXlqP7ItkUHLCFNlmS32i
 4zDd8Xp0kySBk1UTnZcsnsB7TVbC2muNxSokKVTe5xmaV3UU2rsQlcZFSXUUYr4tlRyD
 F61gGT1dJp6Rago0KxClVV4LlGbU8QRb5uNn5xC89D1kbWUPtA3G1U3AQ3UvlqSyWBZt
 f6O+P6U4J8v3FstOnvThjTbkKM6UuPeszNhyURa8WthFPIRC/Qr8/KOqN9EO5Kj/8Fwt
 42SQ==
X-Gm-Message-State: ANoB5pkd4FiveMZTSQ40F/NrQLPnAXYzYlNogQ3nLoK6S0NuktTfKid2
 Fpr+29xRIRGDmSC9f4+BYEHMPinp/XNK6A==
X-Google-Smtp-Source: AA0mqf5XxSPsh1gElJLISTCH8jBxKw2l85vxM5vFZMR7VtMxrzDAz9u8B+smh4G6eaCc3YG8CKpqOh9t0eSRDA==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:b18:b0:388:7d2:587b with SMTP id
 cj24-20020a05690c0b1800b0038807d2587bmr8897906ywb.416.1670528380375; Thu, 08
 Dec 2022 11:39:40 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:40 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-21-dmatlack@google.com>
Subject: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
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

Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
function for computing the max level that a given GFN can be mapped in
KVM's page tables. This will be used in a future commit to enable moving
the TDP MMU to common code.

Provide a default implementation for non-x86 architectures that just
returns the max level. This will result in more zapping than necessary
when disabling dirty logging (i.e. less than optimal performance) but no
correctness issues.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c     | 14 ++++++++++----
 arch/x86/kvm/mmu/tdp_pgtable.c |  7 +++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7670fbd8e72d..24d1dbd0a1ec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1696,6 +1696,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
+__weak int tdp_mmu_max_mapping_level(struct kvm *kvm,
+				     const struct kvm_memory_slot *slot,
+				     struct tdp_iter *iter)
+{
+	return TDP_MAX_HUGEPAGE_LEVEL;
+}
+
 static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
 				       const struct kvm_memory_slot *slot)
@@ -1727,15 +1734,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		/*
 		 * If iter.gfn resides outside of the slot, i.e. the page for
 		 * the current level overlaps but is not contained by the slot,
-		 * then the SPTE can't be made huge.  More importantly, trying
-		 * to query that info from slot->arch.lpage_info will cause an
+		 * then the SPTE can't be made huge. On x86, trying to query
+		 * that info from slot->arch.lpage_info will cause an
 		 * out-of-bounds access.
 		 */
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
+		max_mapping_level = tdp_mmu_max_mapping_level(kvm, slot, &iter);
 		if (max_mapping_level < iter.level)
 			continue;
 
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index b07ed99b4ab1..840d063c45b8 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -163,3 +163,10 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
+
+int tdp_mmu_max_mapping_level(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot,
+			      struct tdp_iter *iter)
+{
+	return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
+}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
