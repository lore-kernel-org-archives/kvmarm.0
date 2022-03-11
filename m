Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBABC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DBB49EF2;
	Fri, 11 Mar 2022 03:48:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id njJ+bedLVjdE; Fri, 11 Mar 2022 03:48:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2418749F21;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B5A41016
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysJlsCTQmgWp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:40 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C425E40BBF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:40 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 h69-20020a628348000000b004f769e5b4bdso2389355pfe.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HT5iizWaNyX/scodM/UgaJfvTolyFgDlKXTIQK5ovbE=;
 b=ci1RV/cDxZwD5zNwmfmqMYmXEiXEpZeRiCx1bWeGOaV4x9h0XElhebmz7axQ94hcJK
 bZap8UCpYa0n+D0V1WGsj49i9GocZPpnOW/R6liGZwWWd+MLFvGP4SmRm18uGvNf7VJA
 hM4w3wETJZ3BZ98Lv4ivSwkHviUvB82J6N2Xmv9hmmGXSXClEANNQCTSmZl/thTSHvF3
 qMaREJKuH529np34JrNojketBObofC9CldBCVw8lMyUMfILV1nVUnlrgaj9SjXRE3cnb
 ez8mqQgD4jcpfyLRKrLcfMsV8AyaZdBvsT3nFJZl/AvexHb6QnSL9UFeXZ9O9z2drwbU
 ZGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HT5iizWaNyX/scodM/UgaJfvTolyFgDlKXTIQK5ovbE=;
 b=hj6K3CJHauczxMUh1Vcm6CK/jlBcg1dPj8HPXCq0HwHgaNOg2WGqLMUN59Ki8g2hY/
 qwRXXlvk2O1QYNQVSksgdigzlX+CD1vv3sLxh77Bv35yj9SL4U2+QXvpB4QPlQDVtvpO
 xqy6zAM/dPytLOnVCgJLj0MsNBm/romjDeWDEXN5StoNLtkMoVniZKfXzuP19c4bB2q7
 re81eOHlMjPHTLz9gdmCHcxw8b2CC+MYybST502ao2sO+9O+wlx6X9BD5m9qTHSUCXQX
 eCzO9xB0yvtjqEmZalJY4nAH42Ih5+XvEBCCRr/HAsBMFdTKTbYGNX1wjKAuPiWx1Brg
 sHGw==
X-Gm-Message-State: AOAM531BBiseMW3NU1FXX+RSZcDzGo+MHU2cwTy8iAxI9JA7cXEdjXzX
 u1BWymytvLyMAqZAAMBLCpkU9lBDcD7i2A==
X-Google-Smtp-Source: ABdhPJzSyoUJ2mS8Kxw0tWZmurwVG8N3wCZURTli9JtC3Otg5er4JZvYmqgznJT5OSafq4YssNwt2bbQk0+S3g==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP
 id pg16-20020a17090b1e1000b001bf6c7854a9mr321588pjb.1.1646958339516; Thu, 10
 Mar 2022 16:25:39 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:07 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that deal
 with shadow pages
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:41 -0500
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

Rename 3 functions:

  kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
  kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
  kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()

This change makes it clear that these functions deal with shadow pages
rather than struct pages. Prefer "shadow_page" over the shorter "sp"
since these are core routines.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 80dbfe07c87b..b6fb50e32291 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1668,7 +1668,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
+static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
@@ -1706,7 +1706,8 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      bool direct)
 {
 	struct kvm_mmu_page *sp;
 
@@ -2134,7 +2135,7 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+	sp = kvm_mmu_alloc_shadow_page(vcpu, role.direct);
 	sp->gfn = gfn;
 	sp->role = role;
 
@@ -2150,8 +2151,9 @@ static struct kvm_mmu_page *kvm_mmu_new_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+						    gfn_t gfn,
+						    union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 	bool created = false;
@@ -2210,7 +2212,7 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 
 	role = kvm_mmu_child_role(sptep, direct, access);
-	return kvm_mmu_get_page(vcpu, gfn, role);
+	return kvm_mmu_get_shadow_page(vcpu, gfn, role);
 }
 
 static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
@@ -2486,7 +2488,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
-		kvm_mmu_free_page(sp);
+		kvm_mmu_free_shadow_page(sp);
 	}
 }
 
@@ -3417,7 +3419,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 		role.quadrant = quadrant;
 	}
 
-	sp = kvm_mmu_get_page(vcpu, gfn, role);
+	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
 
 	return __pa(sp->spt);
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
