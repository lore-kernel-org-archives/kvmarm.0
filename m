Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13076C43219
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 18:20:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3CAF4B2BC;
	Fri,  1 Apr 2022 14:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5zCIfccGquae; Fri,  1 Apr 2022 14:20:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 172144B29C;
	Fri,  1 Apr 2022 14:20:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7A04B20F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JIZS4InkFEde for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 13:56:13 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D4424B265
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 13:56:13 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 mm2-20020a17090b358200b001bf529127dfso1928167pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 10:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T6MU8k6cQbf3TkeoEFiVrn7xHGx6m7+aDUnGVn3gY9A=;
 b=psRoNjQx06GKBw5vk1GEEdr6zd56BqsU6L5ZB+rOQfu2XH6HJb+EMCsMZX4hnwAonC
 2qG5EnZHZ6vyxBjGbdz8b1ylt6lv4n/XYVsWPs5pHj7JFPfkrX1V4OyHPShUpqfk7GLA
 d911moNr53YYCdp3FNox0tSzlA0Fh25LgD83E572TTJFC+Gdm06EViMmGs2KvtC8wZ6W
 x17XSyEP01m5bqVgtCZ+WxHNdlHXdwqVUZvyOmLgdiN5Hlznx1jD+fC30Tj0tHOgwdXd
 rQUzG3elXhJ5R145vXnIyE5klI/0eFbeDgab/AtBOOlKGNWRf4G056rfgCyinO9LPkIZ
 +xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T6MU8k6cQbf3TkeoEFiVrn7xHGx6m7+aDUnGVn3gY9A=;
 b=Vl/kGjLuR3X/Gy7+U9uUehYqW/J5LVoLqmE2DQYalg+apuy/hFKv27nQ5pQdlJo7mu
 aDVxdRPrkOGOHNdvkTuwxJsOpRpTno3xIcjj78emOBU3yT9ng3S7Dfqaq7jRQ85SLg1s
 o/o1dNXf+drXpIoxQrcunzLGsGdnOHILnk108RhDU1mAvCUHmmNxRgAiV4f1+X3l5/Mw
 KgaSec9YUTcAmPELS7hG3/g2F2ElwbxA/J/xt6TgZ4IjKDb0yPfUlK+8zIf1d0Gw4WBK
 fmOVYuggqa8xerZ2kzRTBjkn3qo/9yWusJI3d0JQoYlIiSOcjQJtkLbYBqWopuVTdUM7
 9zng==
X-Gm-Message-State: AOAM533lDQ4keDdVYYJ7JKcsb9XQtmCUM4/wdp4V7Ta0xSO6UpYe1F47
 prJZB9DeOO5IyfCsMGwzt/+xyKU/3S395w==
X-Google-Smtp-Source: ABdhPJxpf4Ryvjy4Xf0xw/2qrejO1ASWA3zDiH/Rc6IEicNMwrszz8mQR+qiF4YjulK0xOMtMCMyzDcI70BvKg==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:995:b0:4fb:607d:444c with SMTP
 id u21-20020a056a00099500b004fb607d444cmr12098520pfg.69.1648835772682; Fri,
 01 Apr 2022 10:56:12 -0700 (PDT)
Date: Fri,  1 Apr 2022 17:55:38 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 07/23] KVM: x86/mmu: Separate shadow MMU sp allocation from
 initialization
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 14:20:42 -0400
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

Separate the code that allocates a new shadow page from the vCPU caches
from the code that initializes it. This is in preparation for creating
new shadow pages from VM ioctls for eager page splitting, where we do
not have access to the vCPU caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index abfb3e5d1372..421fcbc97f9e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1716,16 +1716,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	/*
-	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
-	 * depends on valid pages being added to the head of the list.  See
-	 * comments in kvm_zap_obsolete_pages().
-	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
 }
 
@@ -2123,27 +2116,31 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
-						    struct kvm_memory_slot *slot,
-						    gfn_t gfn,
-						    union kvm_mmu_page_role role)
+static void init_shadow_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			     struct kvm_memory_slot *slot, gfn_t gfn,
+			     union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_page *sp;
 	struct hlist_head *sp_list;
 
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, 1);
+
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, slot, sp);
-
-	return sp;
+		account_shadowed(kvm, slot, sp);
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
@@ -2158,7 +2155,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	if (!sp) {
 		created = true;
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		sp = kvm_mmu_new_shadow_page(vcpu, slot, gfn, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
+		init_shadow_page(vcpu->kvm, sp, slot, gfn, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
