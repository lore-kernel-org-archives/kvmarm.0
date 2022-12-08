Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE628F71
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:59 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-368994f4bc0so24901117b3.14
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=jk+FImgmNN59DiGsDY++vx/KQEmASc1e1hla7uc87GMTyPZlR2UOBXLaVPtTxGYnAm
         uvBb1Ket+Mn8YBdl9xYp1q6V97DYRXauq4VRKICgtNCR1YMz1jjccQk1Fq6gZAHxD2FA
         PAxC04NoAc6UtZzkExg6xhxWc8u5pUHmGEGggu55OIjtFsdhGVaeglRzbz+WUF+DPHZ1
         djgcaYID6dxZJ/0/yKuUgM4jEWXcvZtwBBQis/9GX6FBwsNe2+45eiuhZhRtkrCqRfnS
         AgIUnJCP2QepnvxHb4nCXIDyQas3doejnji8W4Dw1rngMOFSVIsMUvCb3SiqWoJfJ01T
         b6rQ==
X-Gm-Message-State: ANoB5pnfYtYqwj0Eqw5s7EjwfH5etm1nEcZ3Ves9H4NyITeie1NAPbGW
	WLdFcLC0EDB+Adxvqt61+lln6UaZ7k94Aw==
X-Google-Smtp-Source: AA0mqf5kUDO3Tr6gk/fzW/ARrxEhzmkAXRSHhWoL0H7mQ0gz5ri8bxcSR3iro0wxy+7xhENFLIaYZergQrtKPg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:5:0:b0:6fc:8f88:813b with SMTP id
 5-20020a250005000000b006fc8f88813bmr27601586yba.629.1670528399532; Thu, 08
 Dec 2022 11:39:59 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:51 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-32-dmatlack@google.com>
Subject: [RFC PATCH 31/37] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
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
Message-ID: <20221208193851.iZlLA6JadQIxavPOAKnd20W_uFpzmFju1mqx1HbF0dU@z>

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

