Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F72C10F1B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2467A4B814;
	Thu,  8 Dec 2022 14:40:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vke1qRhTmwBj; Thu,  8 Dec 2022 14:40:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B644B838;
	Thu,  8 Dec 2022 14:40:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 578874BA3A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w2vFO-Jtlsm2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:40:05 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9FAF4BA6A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:40:01 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 s6-20020a259006000000b00706c8bfd130so2552251ybl.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=XV6plMeF8MwFNJz3HbB05g+syGBZZ4afzsZVPB1fNOM=;
 b=Or/+tQ35VJl1emV0K4s+0pZ6UBajubG9tq8FrCH/hA3kAwbcecTNaCZrvYWvTtsU9g
 5JZnVfab3n41kCOJL7IiSST4+aKZY4JSEhz9//xqRqAsRUBEKxw9xl8ylX8pwq0BwIdV
 I/Xh88N0cUIemHf3DBiDhLCAmUuyGnaY5gTHAU4MfbG4ILGutMlede6Fq/e7cS9eVM31
 nHh094v1U0MR6DFbL/HmUOOC1ZS2/Zm3j4YdatXU4M2l2wqxp12xCNyRytDsAZdWIiVJ
 2+SDuw6pj88vz17PG6Z8Q+mIQbHf2BO5E5P+E5Z5Z6J+LaEFzERjkL2lFcMUz4dZZ5j1
 PSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XV6plMeF8MwFNJz3HbB05g+syGBZZ4afzsZVPB1fNOM=;
 b=3e3Z/X3lR9dpmw6ipa9is79YpmAJgLUvQ2enxVbJUOx9XM4L+ROdU8xTf9uxTxeNyY
 r6oY+Ea0VC7VSP/7Z0WnY7I4RX0iemjZa+jVUbC9OKC2QWh/lPj2qBBGMOqnA5Xf6cxm
 R74T/Pt+oe1tRlzo2rDo58e+YpryZ8KKdCrHGZJqsRRzRC2cj+XP5mCylRzeVXqLdTQs
 iERaQYhXIxCbsdCJDl3fRb7RMXLdz5/uVQqt5La/IHUxbXYjCNM3xgwvAxPFTpPnP0fj
 n1x1xu1Exmj930bLtOeSBdHSC0nDEzgUiNxoxwcOqD+h3LxEuL2Ax79zk58MZC464L0o
 2qKw==
X-Gm-Message-State: ANoB5pnPG7UgZeTEiZ0Mnil2mLx3vXrI1be3f1w/+TonskpG9gLcZjnZ
 +I2hfNSFHuHQT7RPtCe6iXba1/fVqKSVjA==
X-Google-Smtp-Source: AA0mqf6Wkh0OUy4PlZrJU9hOTo3IInMenz2jMKiaSBByUieGZ1GCpj8vRhZKagSo80e6dZu+mbM8OPIkZWhBWg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:230b:0:b0:6f9:b1b0:67f5 with SMTP id
 j11-20020a25230b000000b006f9b1b067f5mr28607189ybj.471.1670528401185; Thu, 08
 Dec 2022 11:40:01 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:52 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-33-dmatlack@google.com>
Subject: [RFC PATCH 32/37] KVM: Allow range-based TLB invalidation from common
 code
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

Make kvm_flush_remote_tlbs_range() visible in common code and create a
default implementation that just invalidates the whole TLB. This will be
used in future commits to clean up kvm_arch_flush_remote_tlbs_memslot()
and to move the KVM/x86 TDP MMU to common code.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 1 -
 include/linux/kvm_host.h        | 1 +
 virt/kvm/kvm_main.c             | 9 +++++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e44fe7ad3cfb..df815cb84bd2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,6 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ec3a6de6d54e..d9a7f559d2c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1365,6 +1365,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f1d48ed7d57..662ca280c0cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -379,6 +379,15 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
 
+/*
+ * Architectures that support range-based TLB invalidation can override this
+ * function.
+ */
+void __weak kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
