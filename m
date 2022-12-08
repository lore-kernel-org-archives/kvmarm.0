Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F27C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F71F4B838;
	Thu,  8 Dec 2022 14:40:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GP7iNbix6TfH; Thu,  8 Dec 2022 14:40:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CFB4BA98;
	Thu,  8 Dec 2022 14:40:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024104B855
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ekhWXouv+8JE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:11 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 744F94B81A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:08 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 y133-20020a25328b000000b006f997751950so2528223yby.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=tkNWRrDgNwNzqtgNwpxgN/DTrlBNLFki8K4gCSCF3lo=;
 b=Jeo44smHjnYpe2uFwUmmqKcQe01M1Ze9ea9B4uMIU5ntQkPkvB3Zc4thQ3NAsyCsM6
 njB6ARB2/jwqICHZjLWARLgqlROkOE8dE/Nlmg+cddGuhCUdBUCre+Ape5y9bEn1AH0m
 QTNzlGiRNxTFT7VabJhOsxdhwjPofjbAJZ1PCWCHwTDUYPBouSQgwVrjYVu7xNslHehx
 1YNfAbWUQ8IDhGJBMwkGg2u+vzD4HHd3ftPyCOz4Y9YrRbPnwANRWTtpcXIgRmYN6yTS
 OWchh5FCUZ+isGuwUpxCxPxLXQApiy8OtxlS5CtERREsPneeyxTaL8RKmGDzc7PdZpGa
 /plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tkNWRrDgNwNzqtgNwpxgN/DTrlBNLFki8K4gCSCF3lo=;
 b=OI6cVGwMZNz7kDmOsTO3lVwM34Bljt8GyUWUVVNEn0ctMLwlThKwJVkl07mK+9d67a
 ZZw2AsGNU/xVSzewDcdwDnSGzPMiQZCUUaeHVPFA/vytr7WT1FMOIm3ToDMtOLs9YSWo
 lr/dgdqIjeMaGRXpjjbSH7AZkqrMEIgxuvQcrmKum96/sN1WSrGJbxjksp1PK04whmyr
 dZFAXKDrEoES4/5nHyT6FdGZYtr3ln5nO20JiVOg7F6TnLsqifqMsG0rOOysmHcBgpLl
 i9b+3l/WYDkJtjNb9210OD5WF+zS4VS27rxTHsBikd71rptcTUgk5no8b2qwYOL4bJpG
 FC1A==
X-Gm-Message-State: ANoB5pmfEgCEFwjPRaAa3SaOsOS6kwWQbSfa84AAXPPLTg2Z49g9yKT7
 AZMqbUcE6E8NqbUfaHmGwC3FQ5tVrVMTuw==
X-Google-Smtp-Source: AA0mqf6e/93WEAJhtz+5cgWWhhHXPdHpxdnhitMPWlmfhQ9qhBNIB9WsoIo+5YOGLZdc8lSlrXS+3/eouLkxig==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:818d:0:b0:70e:58c:1c8b with SMTP id
 p13-20020a25818d000000b0070e058c1c8bmr2474845ybk.229.1670528408086; Thu, 08
 Dec 2022 11:40:08 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:56 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-37-dmatlack@google.com>
Subject: [RFC PATCH 36/37] KVM: x86/mmu: Move is_tdp_mmu_page() to
 mmu_internal.h
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

Move is_tdp_mmu_page(), which is x86-specific, into mmu_internal.h. This
prepares for moving tdp_mmu.h into common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 9 +++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index df815cb84bd2..51aef9624521 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -147,4 +147,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+#ifdef CONFIG_X86_64
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
+{
+	return !sp->arch.shadow_mmu_page;
+}
+#else
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
+#endif
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 897608be7f75..607c1417abd1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -71,13 +71,4 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
-#ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp)
-{
-	return !sp->arch.shadow_mmu_page;
-}
-#else
-static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
-#endif
-
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
