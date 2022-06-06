Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BACC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 11:12:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE2C04B369;
	Tue,  7 Jun 2022 07:12:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eMHz3GWVVwSl; Tue,  7 Jun 2022 07:12:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD004B35C;
	Tue,  7 Jun 2022 07:12:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29C0149ECF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bYv-o+dThnY6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 18:21:15 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB3D549ECC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:14 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 y8-20020a17090322c800b0016777c34c83so1882808plg.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2022 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lCj5vf6+ANqLHv3122ZbLr+VtIsIBzbS/r0LeVNVl3w=;
 b=fhNqTQhqkFux/ukIEgHzIyWXf7nWgidEa7EZyE6ojT7eSM39dn6EJghTF0Wz+po+G8
 NrXJEpS7gJdVDOJob5aQvoGsOmcx+ynWrkIQ6mokqSgyj8IvYWY1o4fPwhteMr1UyxnN
 +cNHE3z/DMTyLaXYmsi6tOorj2M77FxEsSXaEjz/7pr793GUJ9HhGSRtQN77II9Kyt1x
 VCEb+fRiffbhSZD7SWq09vE6VbwZtBwVsEFs3id87zkSeTVMGB608xT5Z3874uG8vwE8
 TehuFGa8lHQuFkXATbjbgXalldhf4GeMOqL5oJbujtgTwTrXOyonxqdb6ZfbN2/Hk4qK
 UzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lCj5vf6+ANqLHv3122ZbLr+VtIsIBzbS/r0LeVNVl3w=;
 b=RgG0Jan4LODwjJbniNTNz713/X3qX3CHoSBSqyHyUGxjOX23BzWo0M5HzkbaR9LVc/
 3yNPgIIqjiy+H2ZKhPGDYYa+F9zm5osE8WPKMI1Lyk7spg6bCoVfkVPBggdp7678xdYl
 P88Vi74SgJVQzx1cPeghGXNLntrYOXLpOehTuDeDm7WceaM/8AB+djedS+mkkPFvZP0t
 9jBvT5NsVtVq2pZ4BqIsQAwT5wJ611vkTUR85vE9H/8qf+qfV/0lBbaZoNXrsyFnXRGX
 5cjKLAFTRzlU5Y+sFjWqFfOfKrqq3mYBjfbxXNmd+mKV7asnbpMB9ohU9qlJl1gp5yA2
 Ukew==
X-Gm-Message-State: AOAM533d+7jgeaZmFkHxGtGR+MC6+BHP9IDdXCICIH8hCsFpinhjhOcv
 MEDWB2wUM7+P+ZhwyblowjTuEy9lm3va9s0U
X-Google-Smtp-Source: ABdhPJzBKxlko2XskCwZ7XghA3/1uxqpH481I1Y3w7YnTvGyWNqjKRB0PQYcZSZzhwqgcHglYMcExUynh375FBjd
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:902:cf0f:b0:15a:24e0:d9b0 with SMTP
 id i15-20020a170902cf0f00b0015a24e0d9b0mr25703791plg.42.1654554074043; Mon,
 06 Jun 2022 15:21:14 -0700 (PDT)
Date: Mon,  6 Jun 2022 22:20:58 +0000
In-Reply-To: <20220606222058.86688-1-yosryahmed@google.com>
Message-Id: <20220606222058.86688-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in secondary
 pagetable stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Tue, 07 Jun 2022 07:12:43 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Count the pages used by KVM in arm64 for stage2 mmu in secondary pagetable
stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/arm64/kvm/mmu.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a85..80bc92601fd96 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
+	void *virt;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(mc);
+	virt = kvm_mmu_memory_cache_alloc(mc);
+	if (virt)
+		kvm_account_pgtable_pages(virt, 1);
+	return virt;
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -102,6 +106,21 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
 	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
+static void *kvm_s2_zalloc_pages_exact(size_t size)
+{
+	void *virt = kvm_host_zalloc_pages_exact(size);
+
+	if (virt)
+		kvm_account_pgtable_pages(virt, (size >> PAGE_SHIFT));
+	return virt;
+}
+
+static void kvm_s2_free_pages_exact(void *virt, size_t size)
+{
+	kvm_account_pgtable_pages(virt, -(size >> PAGE_SHIFT));
+	free_pages_exact(virt, size);
+}
+
 static void kvm_host_get_page(void *addr)
 {
 	get_page(virt_to_page(addr));
@@ -112,6 +131,15 @@ static void kvm_host_put_page(void *addr)
 	put_page(virt_to_page(addr));
 }
 
+static void kvm_s2_put_page(void *addr)
+{
+	struct page *p = virt_to_page(addr);
+	/* Dropping last refcount, the page will be freed */
+	if (page_count(p) == 1)
+		kvm_account_pgtable_pages(addr, -1);
+	put_page(p);
+}
+
 static int kvm_host_page_count(void *addr)
 {
 	return page_count(virt_to_page(addr));
@@ -625,10 +653,10 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
-	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
-	.free_pages_exact	= free_pages_exact,
+	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
+	.free_pages_exact	= kvm_s2_free_pages_exact,
 	.get_page		= kvm_host_get_page,
-	.put_page		= kvm_host_put_page,
+	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
