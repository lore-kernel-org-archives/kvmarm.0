Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A8A8F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:22 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-3b5da1b3130so24900427b3.5
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HxpbJTUNlMZJd8tslVgq3JHdSPdfNWxn0UnaVUQQc0A=;
        b=X27Fj8NMQTMpgpQSLD6fEhoU4fVXBG4FfQvE4hDE+MTeWoJhGcT5LpYCDXh1D+/w82
         hPv1oB7AV9ecGMFLuN13hRpFiRPBuJVO9vanqpaNAxBJ4jir+35FDyU9qXPhlEpW7coO
         /8u9arxvokXqrqKeLqz9h601trg+4wcye67rx9tVyN1axVtupBSnJ7E5BSc5oEBXMlHO
         KSROKMtQE8+C88/p6gUIBi3yv6webYqOh7OUiLmP0ZCWyP2DF2whWsSz/1NabrWwZBVJ
         X38Wy5/22Z5LwdqIzNX3mhOM6a0liS8P2HZHtMcipS0tuORgcla3kymZxvCrrppA0ZTX
         8LTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HxpbJTUNlMZJd8tslVgq3JHdSPdfNWxn0UnaVUQQc0A=;
        b=Rfcq2RQ3zVpsgEDI8eMbYX7Wyv2/l/8GNeFtts+we5WzE65IE2vjq+1nS+UGx1HXW5
         y1xd1Lha5hq8Ki9Y/2X1kPDNHWz3JNn0cGH8fZuM3Kn1wD/lZXwxVdVZRPtbu8FohRE7
         GVg2WCXnsJG1FJQ1qXJ+3MgvEZNsHADqH22Rv85fSpX+mlY51DhkO+/w//mbQNzcLXq7
         LdrwPpiNIUBh6XnFmgA1jx9xZ/s87hSZ9O3JqeLrMP9CPCIbInvH2S3l/8HTSUaTZW8Y
         xTKiNoUucOW2QhuewC87M2gNn2mDsbBctoQeYBhIglRRPC0GuNHSujuzyu8WbF266W/H
         6kIw==
X-Gm-Message-State: ANoB5pkkBjyhIE5i774TuqntHbMhuGjxrKVonEY8bNec6Mf6bbL13p2D
	8VqpGnb4f7A6Ouv5yV+R/hKEZi9PocbmLQ==
X-Google-Smtp-Source: AA0mqf6nQ3bCSMPTn17mxc4GCVurLewt/EOjnyHvTIs/ImZGe4frb7eZXMD/Hm3cZq91ON4VNM6eRlaJXvRssg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d807:0:b0:6f4:1c40:273a with SMTP id
 p7-20020a25d807000000b006f41c40273amr52016342ybg.622.1670528361862; Thu, 08
 Dec 2022 11:39:21 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:29 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-10-dmatlack@google.com>
Subject: [RFC PATCH 09/37] KVM: Move page size stats into common code
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
Message-ID: <20221208193829.2Aw7OEN86BiO0BgD72QknR5C_vfd-MqoHL_5NQKxwu4@z>

Move the page size stats into common code. This will be used in a future
commit to move the TDP MMU, which populates these stats, into common
code. Architectures can also start populating these stats if they wish,
and export different stats depending on the page size.

Continue to only expose these stats on x86, since that's currently the
only architecture that populates them.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 --------
 arch/x86/kvm/mmu.h              | 5 -----
 arch/x86/kvm/x86.c              | 6 +++---
 include/linux/kvm_host.h        | 5 +++++
 include/linux/kvm_types.h       | 9 +++++++++
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f5743a652e10..9cf8f956bac3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1363,14 +1363,6 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	union {
-		struct {
-			atomic64_t pages_4k;
-			atomic64_t pages_2m;
-			atomic64_t pages_1g;
-		};
-		atomic64_t pages[KVM_NR_PAGE_SIZES];
-	};
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 168c46fd8dd1..ec662108d2eb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -261,11 +261,6 @@ kvm_mmu_slot_lpages(struct kvm_memory_slot *slot, int level)
 	return __kvm_mmu_slot_lpages(slot, slot->npages, level);
 }
 
-static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
-{
-	atomic64_add(count, &kvm->stat.pages[level - 1]);
-}
-
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u64 access,
 			   struct x86_exception *exception);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bfe060768fc..517c8ed33542 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -231,6 +231,9 @@ EXPORT_SYMBOL_GPL(host_xss);
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
+	STATS_DESC_ICOUNTER(VM_GENERIC, pages_4k),
+	STATS_DESC_ICOUNTER(VM_GENERIC, pages_2m),
+	STATS_DESC_ICOUNTER(VM_GENERIC, pages_1g),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
 	STATS_DESC_COUNTER(VM, mmu_pte_write),
 	STATS_DESC_COUNTER(VM, mmu_pde_zapped),
@@ -238,9 +241,6 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, mmu_recycled),
 	STATS_DESC_COUNTER(VM, mmu_cache_miss),
 	STATS_DESC_ICOUNTER(VM, mmu_unsync),
-	STATS_DESC_ICOUNTER(VM, pages_4k),
-	STATS_DESC_ICOUNTER(VM, pages_2m),
-	STATS_DESC_ICOUNTER(VM, pages_1g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f16c4689322b..22ecb7ce4d31 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2280,4 +2280,9 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
+{
+	atomic64_add(count, &kvm->stat.generic.pages[level - 1]);
+}
+
 #endif
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..59cf958d69df 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -20,6 +20,7 @@ enum kvm_mr_change;
 
 #include <linux/bits.h>
 #include <linux/mutex.h>
+#include <linux/pgtable.h>
 #include <linux/types.h>
 #include <linux/spinlock_types.h>
 
@@ -105,6 +106,14 @@ struct kvm_mmu_memory_cache {
 struct kvm_vm_stat_generic {
 	u64 remote_tlb_flush;
 	u64 remote_tlb_flush_requests;
+	union {
+		struct {
+			atomic64_t pages_4k;
+			atomic64_t pages_2m;
+			atomic64_t pages_1g;
+		};
+		atomic64_t pages[PG_LEVEL_NUM - 1];
+	};
 };
 
 struct kvm_vcpu_stat_generic {
-- 
2.39.0.rc1.256.g54fd8350bd-goog

