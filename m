Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76B9C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 07:02:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9EC4B28C;
	Tue, 17 May 2022 03:02:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTJW64vJOqQH; Tue, 17 May 2022 03:02:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94EC84B2E3;
	Tue, 17 May 2022 03:02:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7B8A4B1F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIn3Kkn+5Fk5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 19:21:52 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F49449F02
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 19:21:52 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r14-20020a17090a1bce00b001df665a2f8bso374466pjr.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 16:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dp0gVynR2MPrnpeuYvn51CVf+cNAegH1EXG5CT9dhEw=;
 b=gHaTCYwpfkvH3lQhJPlpmSVln6yaXSFVxIaIcnzBKfab3oQKOlR27bMBpz7+S/wOpB
 4U3ORun7fl8sXshOKVayI0C84rIJv7wpxKBnOZfwD5JCVYhbqYZoZWG9/Lgw8jDptmL5
 Ktwt/K2d4b8sWumo5gl5g8gCI5yupB9ZBiWBhlHA/4/0KGsECzLZWYKFEdx7ftAkITRz
 D4KAFSNx3oT2VhLm9/XVlmsh/Oowngjzu+9FpIk5Yr50oaZo0IL+ALoFjjFr/IFv3p+0
 YNm5p17D+FTim3udsSWZ99Zjzwv2t+m6BUyNOreeKCiW83i7hH9L0GDG24LnTCQjtHr0
 wkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dp0gVynR2MPrnpeuYvn51CVf+cNAegH1EXG5CT9dhEw=;
 b=TRWcH7bh34jqoT7rZG7avOlI6X9QdEvC1DpTFixNhxMjXuqixTdajbWEyVTeuUTema
 /ZMdkExnMyU9qCB5v9Pseqnmlwd2wGiitwx4FLZfyJLr6yQRJ6Y02SnoWP5eHIpoT5MV
 yFX77kEm+kXWZlKF26j9X/AeszA7SiOgcQp8Bxast5XtHbFsrnivARxgUmr1/+2D7ljA
 8JMWK9VXpXsY1o76Sv94XSL31adlOGZGhS8SOPMNtLOGydeThXN2j3Z0llWX4aXptO0V
 j8PvniFq7bz/btxfXfcAn+m8yX7NWHtrdoh8unUx3rlaL7//2iikcT3gTzSXF4jLFwJj
 iOkA==
X-Gm-Message-State: AOAM530BWAc5tgkFnqqVSijHKITH7BzFtsIZbUId478HyCazk+me2LuS
 jOuC8DJ62jrAqSr1J7WjcnKsFGwm5YGVZQ==
X-Google-Smtp-Source: ABdhPJzgCO2KpA6b1qP0OzwDx33XZpyNVfr01TpeWbuLnhhk9ki0NjPFSmILq0BDBb73MITLx02mf5aRddvD3A==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f647:b0:15f:3408:60e8 with SMTP
 id m7-20020a170902f64700b0015f340860e8mr19377660plg.82.1652743311499; Mon, 16
 May 2022 16:21:51 -0700 (PDT)
Date: Mon, 16 May 2022 23:21:22 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 06/22] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Tue, 17 May 2022 03:02:25 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
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

Decompose kvm_mmu_get_page() into separate helper functions to increase
readability and prepare for allocating shadow pages without a vcpu
pointer.

Specifically, pull the guts of kvm_mmu_get_page() into 2 helper
functions:

kvm_mmu_find_shadow_page() -
  Walks the page hash checking for any existing mmu pages that match the
  given gfn and role.

kvm_mmu_alloc_shadow_page()
  Allocates and initializes an entirely new kvm_mmu_page. This currently
  requries a vcpu pointer for allocation and looking up the memslot but
  that will be removed in a future commit.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8508c4bfddb5..c8ee92e45e8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2019,16 +2019,16 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+						     gfn_t gfn,
+						     struct hlist_head *sp_list,
+						     union kvm_mmu_page_role role)
 {
-	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
 	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
@@ -2053,7 +2053,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		/* unsync and write-flooding only apply to indirect SPs. */
 		if (sp->role.direct)
-			goto trace_get_page;
+			goto out;
 
 		if (sp->unsync) {
 			/*
@@ -2079,14 +2079,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		__clear_sp_write_flooding_count(sp);
 
-trace_get_page:
-		trace_kvm_mmu_get_page(sp, false);
 		goto out;
 	}
 
+	sp = NULL;
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+out:
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
+	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
+		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      gfn_t gfn,
+						      struct hlist_head *sp_list,
+						      union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
 
 	sp->gfn = gfn;
 	sp->role = role;
@@ -2096,12 +2108,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
-	trace_kvm_mmu_get_page(sp, true);
-out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
+{
+	struct hlist_head *sp_list;
+	struct kvm_mmu_page *sp;
+	bool created = false;
+
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+
+	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
+	if (!sp) {
+		created = true;
+		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, sp_list, role);
+	}
+
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
-- 
2.36.0.550.gb090851708-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
