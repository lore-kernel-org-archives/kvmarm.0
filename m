Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6766FC43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 11:12:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206604B353;
	Tue,  7 Jun 2022 07:12:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9nj0BrdYJSWC; Tue,  7 Jun 2022 07:12:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06B2D4B311;
	Tue,  7 Jun 2022 07:12:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D8149ECC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KcRhFzLSVBPf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jun 2022 18:21:13 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65FC749EF3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jun 2022 18:21:13 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 o16-20020a170902d4d000b00166d7813226so5565101plg.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2022 15:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kdA0hdnNlf5Ah+Sdfhrh5/pyHUvKpC5h3K4X0vH9N64=;
 b=Jy0Nvp6l/SeDINdaapKCgsH604PDzAKJu+q61zsdbqS0WgfTf6DKA9ui8w9NOeKXLB
 zV3rFx+mWBMFRAgLdnWnjF2l6fpisaOBqhX3AirSHdup3DSyot579H9rHLD+o6fbmQRk
 FaJKa3uBvvWb/ywHl+G68ob0ojkfCd4KvuSoq0n86mSq7L/FcuboeRh8rpDp78eY8qcZ
 n6nIYlYmcBUcV7QgzCTmqorAtcvEHjNETFQ+4fEEAn2BTJknB6ddaSu7THbAsyUBl7f8
 BE7FECym3Mw5OpxGAbMCVb195W/C84+VufxOQUotNgydoUbVy0Ws+K0ug9KPgynMKrtc
 1W+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kdA0hdnNlf5Ah+Sdfhrh5/pyHUvKpC5h3K4X0vH9N64=;
 b=OnkCR9n9Dqdw3SiHtuUCP7CTi0uPVOlez+kGyVKOrNnN6R04utDq/kGZsQGe/F1F5s
 1P+j0dLaN20WnGilrN6Ac4sgbz4xGIdUhoDe7IoCqHQ2jbBFxkZQzkiWrCwebaJv0xEt
 AQPapNJdJVgdNWFeXegL5wDlB7BzTI5WfFOF0ElyTq1puEvzSqJ72r1DQ34vyfsvgQOH
 UpIs5RpCoz9Qqji35I1qzd2AiQEzinkJUAuQXsG6zWuGiEAzEuV394MMWezo9GGqF1e4
 cAG5UCsLx11OwRfHpGjQa02+CSiDk2M9Xx3yUw4Fk6AesZqZKh1EWUiXaV4rn+kzeske
 d1Iw==
X-Gm-Message-State: AOAM531pNp1PG0r0Q2kc55ty0GPRPMeuyGyhwzVkTE2y0ueJKONc7Ivo
 fuqP7bKLyaPgX3OUqhnH2t0PTZccmMKD4Vok
X-Google-Smtp-Source: ABdhPJy/F+KWMgHvnxrFnjnNsWZmlcg4trdZU2aFBDmcWxfCaapFDM+3Zf8+GdGQEkdAdISq1qm0RKV9vDvadP+C
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a63:dd17:0:b0:3fd:695e:8728
 with SMTP
 id t23-20020a63dd17000000b003fd695e8728mr11359137pgg.70.1654554072536; Mon,
 06 Jun 2022 15:21:12 -0700 (PDT)
Date: Mon,  6 Jun 2022 22:20:57 +0000
In-Reply-To: <20220606222058.86688-1-yosryahmed@google.com>
Message-Id: <20220606222058.86688-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
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

Count the pages used by KVM mmu on x86 for in secondary pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e09..4090d228e1756 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1652,6 +1652,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
@@ -1707,7 +1719,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	 */
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	kvm_account_mmu_page(vcpu->kvm, sp);
 	return sp;
 }
 
@@ -2336,7 +2348,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 			list_add(&sp->link, invalid_list);
 		else
 			list_move(&sp->link, invalid_list);
-		kvm_mod_used_mmu_pages(kvm, -1);
+		kvm_unaccount_mmu_page(kvm, sp);
 	} else {
 		/*
 		 * Remove the active root from the active page list, the root
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 841feaa48be5e..0b70d1a1a3534 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -372,6 +372,16 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 /**
  * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
@@ -384,6 +394,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	tdp_unaccount_mmu_page(kvm, sp);
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
@@ -1146,6 +1157,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
 }
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
