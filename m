Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1617C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 08:57:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878DE4B11F;
	Sat, 23 Apr 2022 04:57:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-+h2xuJGnDp; Sat, 23 Apr 2022 04:57:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF3E14B2A0;
	Sat, 23 Apr 2022 04:57:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0034C49F14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2NfUiVWH5F3z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 17:06:03 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1BED49F10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 17:06:03 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 j8-20020aa78d08000000b0050ade744b37so4051036pfe.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6Ge2konkzI9kQNZbecDBE3zVrokGdYazCMQ6Hdz7Pwc=;
 b=AD8Y3WB05zkFGBEDy5r+SFYfa2sNP1cX5UEbVkBh7FjsDK04aTlV5V4DnMAa7Xmcc6
 OyzgE7DlP8hdtrQxCidYsNj/YK7xEf8u1swAnALBHXRy+4GkAJ35kSjO3m7L0oaqAKEU
 MnPIjC2QokD43JHymgLhIiCuaFp6/oISh+eS1yf5lmp+aRpaPWUt+uuVOE8sfKRMOww1
 N17W5qyxxqKzCwYWcggy07wrq9uFZoudUbzXx9K0B63DfbTAo5HP/+vxQNO/O+slFhIm
 hyrx4zUtX4fKgIO2JxEKn7cPxFO1lolKq407Rz6ywCy6eGUxTmsqGGwjDVI1EJA0LsB2
 Ykig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6Ge2konkzI9kQNZbecDBE3zVrokGdYazCMQ6Hdz7Pwc=;
 b=PAlXS9trB20pkjpoCvKou8C6eOpyjX/N3cm5eD1/revm1vZu7+6furyhAhWnM3qePK
 I+qKiwGBNzZtNzrdjICQU+Lt9nyvhmqAomtHoSi6THV6kZmXaEyDemch4BrKATmJD+MK
 qCVoQDG+nkBfstgjKHTmI7B5zzrJPDcS5O7EPwMHBDL1liBqUeRnLeyGismEonSio3Jp
 UtaH2hClvgG5Vnrjyq43PitpoLOBNxnHrrsZ9y/In7Y+qwZlI5ZeI8WeeWEEtH4EaOr8
 lDSI+dacPd47ZbJpqjs1ElWiGkBR+IAZjk/EWuqhuSHreBZ/gHOSuAzPSxKol8cyl2H8
 XpOA==
X-Gm-Message-State: AOAM533O72gjwP864XPL/RlNUCgGdmZiemAx2tH04UvZkWZNoG8Gcreu
 Lp+wTVysUidyYcg4JyQ+NNYGWVxxWWVyhA==
X-Google-Smtp-Source: ABdhPJyGkgN0mxn2pzRhuXRhxNLv3I8AHy2/O/qb/da6JelMMUf8mJooEx0Eo7Gmh0ca+j3lSTwpgxrQLkmutw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:14d2:b0:50a:48f0:881a with SMTP
 id w18-20020a056a0014d200b0050a48f0881amr6883386pfu.36.1650661562831; Fri, 22
 Apr 2022 14:06:02 -0700 (PDT)
Date: Fri, 22 Apr 2022 21:05:35 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 09/20] KVM: x86/mmu: Replace vcpu with kvm in
 kvm_mmu_alloc_shadow_page()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Sat, 23 Apr 2022 04:57:06 -0400
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

The vcpu pointer in kvm_mmu_alloc_shadow_page() is only used to get the
kvm pointer. So drop the vcpu pointer and just pass in the kvm pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 943595ed0ba1..df110e0d57cf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2084,7 +2084,7 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *gfn_array_cache;
 };
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
@@ -2104,16 +2104,16 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 
 	if (!role.direct)
-		account_shadowed(vcpu->kvm, sp);
+		account_shadowed(kvm, sp);
 
 	return sp;
 }
@@ -2132,7 +2132,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
