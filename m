Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6135C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:43:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8424B365;
	Thu, 19 May 2022 09:43:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xZGb-9QE3vpo; Thu, 19 May 2022 09:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAA94B3C0;
	Thu, 19 May 2022 09:43:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6603D4B37B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ejso9wqg+FVV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:54 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F6734B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:53 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 23B8C6179A;
 Thu, 19 May 2022 13:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174B3C385B8;
 Thu, 19 May 2022 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967832;
 bh=kSjeJ0wTpZrUE91/BBFbgiVUW1Hl8frwaPBerzRxfbQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tgx+SomTlrxVTbry9WhL3XPipAi6F9W/DTiJUqJ4017wxzPbMFQEHgu2IUUOaek4g
 ZDiCuSUZNAz3sFW6vLu0r9KwnxhAKqtN5Hr8IkqKmwYgPlFgEabSRRUs7Ez++bANFu
 SPqkWjLD7lC8lmfcTBt4V9X4JNSydN0RRmGcghrlPNSdPKGL8YHad6oC30QXu9vYqi
 DuDTgMi+8wM3+kG0HyFXeU1sXqjG+wW6PhGY1POc9tfJazeE5KUgsYD9zTvuafVqV2
 NZYj1qJNcqjI3nHGtKHMw2SK6qHJuFXSUdnrOIxVxxht4VzAVwREOLDLUexkgun40D
 GTGhUGubUsS6A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 22/89] KVM: arm64: Add generic hyp_memcache helpers
Date: Thu, 19 May 2022 14:40:57 +0100
Message-Id: <20220519134204.5379-23-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

The host and hypervisor will need to dynamically exchange memory pages
soon. Indeed, the hypervisor will rely on the host to donate memory
pages it can use to create guest stage-2 page-table and to store
metadata. In order to ease this process, introduce a struct hyp_memcache
which is essentially a linked list of available pages, indexed by
physical addresses.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h             | 57 +++++++++++++++++++
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 33 +++++++++++
 arch/arm64/kvm/mmu.c                          | 26 +++++++++
 4 files changed, 118 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 13967fc9731a..f4272ce76084 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -72,6 +72,63 @@ u32 __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
+struct kvm_hyp_memcache {
+	phys_addr_t head;
+	unsigned long nr_pages;
+};
+
+static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
+				     phys_addr_t *p,
+				     phys_addr_t (*to_pa)(void *virt))
+{
+	*p = mc->head;
+	mc->head = to_pa(p);
+	mc->nr_pages++;
+}
+
+static inline void *pop_hyp_memcache(struct kvm_hyp_memcache *mc,
+				     void *(*to_va)(phys_addr_t phys))
+{
+	phys_addr_t *p = to_va(mc->head);
+
+	if (!mc->nr_pages)
+		return NULL;
+
+	mc->head = *p;
+	mc->nr_pages--;
+
+	return p;
+}
+
+static inline int __topup_hyp_memcache(struct kvm_hyp_memcache *mc,
+				       unsigned long min_pages,
+				       void *(*alloc_fn)(void *arg),
+				       phys_addr_t (*to_pa)(void *virt),
+				       void *arg)
+{
+	while (mc->nr_pages < min_pages) {
+		phys_addr_t *p = alloc_fn(arg);
+
+		if (!p)
+			return -ENOMEM;
+		push_hyp_memcache(mc, p, to_pa);
+	}
+
+	return 0;
+}
+
+static inline void __free_hyp_memcache(struct kvm_hyp_memcache *mc,
+				       void (*free_fn)(void *virt, void *arg),
+				       void *(*to_va)(phys_addr_t phys),
+				       void *arg)
+{
+	while (mc->nr_pages)
+		free_fn(pop_hyp_memcache(mc, to_va), arg);
+}
+
+void free_hyp_memcache(struct kvm_hyp_memcache *mc);
+int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages);
+
 struct kvm_vmid {
 	atomic64_t id;
 };
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index d11d9d68a680..36eea31a1c5f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -77,6 +77,8 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
 void reclaim_guest_pages(struct kvm_shadow_vm *vm);
+int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+		    struct kvm_hyp_memcache *host_mc);
 
 static __always_inline void __load_host_stage2(void)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index bdb39897343f..4e86a2123c05 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -307,3 +307,36 @@ int hyp_create_idmap(u32 hyp_va_bits)
 
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
 }
+
+static void *admit_host_page(void *arg)
+{
+	struct kvm_hyp_memcache *host_mc = arg;
+
+	if (!host_mc->nr_pages)
+		return NULL;
+
+	/*
+	 * The host still owns the pages in its memcache, so we need to go
+	 * through a full host-to-hyp donation cycle to change it. Fortunately,
+	 * __pkvm_host_donate_hyp() takes care of races for us, so if it
+	 * succeeds we're good to go.
+	 */
+	if (__pkvm_host_donate_hyp(hyp_phys_to_pfn(host_mc->head), 1))
+		return NULL;
+
+	return pop_hyp_memcache(host_mc, hyp_phys_to_virt);
+}
+
+/* Refill our local memcache by poping pages from the one provided by the host. */
+int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+		    struct kvm_hyp_memcache *host_mc)
+{
+	struct kvm_hyp_memcache tmp = *host_mc;
+	int ret;
+
+	ret =  __topup_hyp_memcache(mc, min_pages, admit_host_page,
+				    hyp_virt_to_phys, &tmp);
+	*host_mc = tmp;
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0d19259454d8..e77686d54e9f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -750,6 +750,32 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
+static void hyp_mc_free_fn(void *addr, void *unused)
+{
+	free_page((unsigned long)addr);
+}
+
+static void *hyp_mc_alloc_fn(void *unused)
+{
+	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+}
+
+void free_hyp_memcache(struct kvm_hyp_memcache *mc)
+{
+	if (is_protected_kvm_enabled())
+		__free_hyp_memcache(mc, hyp_mc_free_fn,
+				    kvm_host_va, NULL);
+}
+
+int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
+				    kvm_host_pa, NULL);
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
