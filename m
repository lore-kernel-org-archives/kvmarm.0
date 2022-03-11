Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A8DC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FD149EDE;
	Fri, 11 Mar 2022 03:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2PEZDXOysLD5; Fri, 11 Mar 2022 03:49:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 761584B0B3;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 926DF408A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 44WG-DmShXzn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:14 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D24C40C52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:14 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 d4-20020a170902f14400b001518350e5c7so3550428plb.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=//m+/4Erm4fn+rEULp2+N5ovNu4tAor1JU0kGbOkSFg=;
 b=DMOErCjEnqpcFOKygIlsSFTfCmw0C9Pj2tK0NYpYCgAcTI1iGWeaL6FRV1b2ZlfKX8
 fHYQBmv/QbDdZc+efkMwruYG+KF4wDiQDaVEfR1WJ8mcUSF76wTcN32p8eRd3os+gbwe
 HmiPcVbSsqLkKI3pTJ0GlBqlqq9PA36fDqQPPRemYGpGS2VlQfbNt1iRDlvaB0K2kTnc
 XnxAxv59lS8YUiLJmKwZc6thsP7Jo1gj39W7PaGOaRSlJdD4vh92yg8lUDbEdT2KiQZ8
 tIhYCc+gAjCABk9ZJUASFdr26iqSp1JW7do4XHUHG5vHE4zhj5bN+IYHo6EeO/tLY3TV
 7glw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=//m+/4Erm4fn+rEULp2+N5ovNu4tAor1JU0kGbOkSFg=;
 b=EsZZeSfKvA89GXpEN9KoatX9XdjRMlrqdbUmKzg+TzWl4i0cr2JUcvR+Jpefz+FPME
 sy9y/u9kfHaOWpAOiuRTvlNtZjVGcqifH+SUEK5Jhkudgyrop69I+5O06yRTzd9KqNdh
 zm5bH8BJiIwSYRXeGP7Miea0Y4os4wvA54fjjIiaHuw6V7KdDiT4jRY8g0DfAMg++cu3
 Q1zisGcwsh6FMeqY5kv1I/LVfAmXZRiNiqDth0oczZTKwZ8O0PdEcd5d7eYhf291MFro
 +6I3Iv+zQXqwJPJmA6wxc+mqRV589L7SRK2qViiS2tcfX/6+zuqjne2nyREVBNYQDOdR
 044Q==
X-Gm-Message-State: AOAM530/JfUq7Rp9xwPhwJ+MFbkVlVecb8sqtSZfHglpVGX28KAoj+92
 p/PDD4ZqrVToE6emAQdAsNwNtgaTCqU33w==
X-Google-Smtp-Source: ABdhPJzhIkawyFt0f4OEQ5xaTKMM8Gn4o1vOGnaEYzvNSaPlKUnsrfCuFW5EPlURrJUZ7m52xqfE2I313J0YiA==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a510:b0:1bc:5887:d957 with SMTP
 id a16-20020a17090aa51000b001bc5887d957mr18553716pjq.38.1646958373723; Thu,
 10 Mar 2022 16:26:13 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:27 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-26-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 25/26] KVM: x86/mmu: Drop NULL pte_list_desc_cache fallback
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Now that the eager page splitting code no longer passes in NULL cache
pointers we can get rid of the debug WARN_ON() and allocation fallback.
While here, also drop the helper function mmu_alloc_pte_list_desc() as
it no longer serves any purpose.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 68785b422a08..d2ffebb659e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -725,16 +725,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
-{
-	static const gfp_t gfp_nocache = GFP_ATOMIC | __GFP_ACCOUNT | __GFP_ZERO;
-
-	if (WARN_ON_ONCE(!cache))
-		return kmem_cache_alloc(pte_list_desc_cache, gfp_nocache);
-
-	return kvm_mmu_memory_cache_alloc(cache);
-}
-
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
@@ -914,7 +904,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_pte_list_desc(cache);
+		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
@@ -926,7 +916,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
 			if (!desc->more) {
-				desc->more = mmu_alloc_pte_list_desc(cache);
+				desc->more = kvm_mmu_memory_cache_alloc(cache);
 				desc = desc->more;
 				desc->spte_count = 0;
 				break;
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
