Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBAEC10F1E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3699B4BA9B;
	Thu,  8 Dec 2022 14:40:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gJrN3nkt+wTb; Thu,  8 Dec 2022 14:40:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BFDA411C7;
	Thu,  8 Dec 2022 14:40:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F504BA30
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oc+aTKLTlbV6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:03 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2D9F4BA7A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:59 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3cf0762f741so24896197b3.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=4nLMUWhCbgygsyxQ4LP+FBPYpvg+KdNjD6AAx7BEWII=;
 b=rW1pkR31ur5/8vzbX6I0g9dHa5ieQLfxMNHl7/CiYy31x1gmEotFcgfb6bMg1XD9l4
 cVrOC8CHqZzC+Gd2V/LwvTlYuSZNohfxzCXcTVs+DyirYljuXOWNIY4uY7CZr2a2YKF5
 72eri2VmsAQGQbk2L3oKVAoFTeSQShiiqL6JV3UiQ4QZOs2UwURjWE1AFC0PhC62yXox
 X0dKf4S1b8a4rdREripCobtwsSCC9MJx4k5wGRfNkLSnee4Y5BiQ4yQ0Og5S8kz28vfk
 0som8w77mpuwlpN/KA9+tJzi+pYWYZboOtEkERDzhNWA7MhWTNWQZafjFT2UdiruzKAQ
 QPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=4nLMUWhCbgygsyxQ4LP+FBPYpvg+KdNjD6AAx7BEWII=;
 b=JhehjStlfa9qhmtNUhyIs3zw9KBn4i9bstwyCy5atb7VgSzPbmUKF7KeqoZYirRwst
 HMw8xQJU+I+MW9RE0JpowDtdKFz3rmdNljA3Eo+BDsaEOqUn/GbW7Peu/lJ9jEPVe2Dd
 Bpzs8fH47VqueJ6vdJUY5YVYV9Ia8YoJEeOMmPFWBm9vtVTSfwM5UoHbh57luRiJLu5A
 BZwFWYNjX/5XVyzPyjCBrNUS+teq7qDLk2u18JresCfyV8Pjpc53PgDvDsAPotixKbJV
 TPCFrVUoILrc0gvM8B142Y59TKq+LR7f1EFAl3hibH/L3PwZ1Jffp1Vi8zNNluIi1cgS
 ZqVA==
X-Gm-Message-State: ANoB5pmjb/GmY6JbKK34I93pXRloVgkeeRzWJkQ+UfPRUeBtYC8+wkc2
 0mX3LJiPMc2UIILBpgri2h/o+cPodwFEEQ==
X-Google-Smtp-Source: AA0mqf5kUDO3Tr6gk/fzW/ARrxEhzmkAXRSHhWoL0H7mQ0gz5ri8bxcSR3iro0wxy+7xhENFLIaYZergQrtKPg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:5:0:b0:6fc:8f88:813b with SMTP id
 5-20020a250005000000b006fc8f88813bmr27601586yba.629.1670528399532; Thu, 08
 Dec 2022 11:39:59 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:51 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-32-dmatlack@google.com>
Subject: [RFC PATCH 31/37] KVM: x86/MMU: Use gfn_t in
 kvm_flush_remote_tlbs_range()
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

Use gfn_t instead of u64 for the start_gfn parameter to
kvm_flush_remote_tlbs_range(), since that is the standard type for GFNs
throughout KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a28adaa92b4..19963ed83484 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,7 +244,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d35a5b408b98..e44fe7ad3cfb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
