Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE7DC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:48:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCBBB49EE7;
	Fri, 11 Mar 2022 03:48:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u+2JB3wgg0iL; Fri, 11 Mar 2022 03:48:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB8E049F4C;
	Fri, 11 Mar 2022 03:48:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E1A240C2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Li73fs9k8wPd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:25:51 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F04DF40CF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:25:50 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 d14-20020a170902654e00b001518cc774d3so3569127pln.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=zCJDCK8B0lL6JubhIyGfaHMZb5Qp7vvPx+3RInS6vEE=;
 b=bEo8CbzbHriKnkqNIGJfYKHguuXOz576eX2T4cHlipuA8XvhukRnyam2cGRz+vvTpw
 RKJ42EslOVMjlUZ5CqQ4Ro08rbQLot9XVom2AtVhJJsFRpPuXeGRD7+kE5bpRt8Qchq7
 mMho4sxejFkUfAZbxPpKnDuYiyy3NfeZqL47umZAHwKfmYzRsaUKEQSMQF6uEpU395dt
 bTBuze3KrAItL51NXFJk8Yx6OLDDZZ+pkLmxqY+EN/KoiYLwEqHKxOtAT/Xc+klpzLNy
 L6eSziMkwAPaIASt9BXbcqjCoVM19WcMyU3KXGrS5/AslQMgCIEuuN29MySTWd/dS5VG
 L/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zCJDCK8B0lL6JubhIyGfaHMZb5Qp7vvPx+3RInS6vEE=;
 b=vowjDDAt5Q+PhuNnHde+aaWcY1O+bGWWVLMbEzb+VxIzsNl3DaUzGGUU+xa1unTMru
 nQW5uLm4+7h4/BZDbSEa0e4UffxZo1aL1xw1E0EeCYpicoHdH3ndToGLxbyGIS1DRytN
 FIjuo0HJuypQ1aFLDbKd53KgwjtNnsP7P4+05gGGLF/YJg6sBKKcxgEcuNlGWhPtkyp4
 KEkg8+0CkEi3PPN9Gw8Qsxz5HDYldpZq+PubmrcBFJ1XIg6cBHTMt3DV2JclpNG/kWOs
 QF+22aimQIJ8p0NwrypU58GhEM+u4wAsObjrHiEFZxotcK3sVKUmfEYMgp+11SKs4Kxe
 Mx4g==
X-Gm-Message-State: AOAM533EzHKQcvDDNvN6Of67WvUXFam+apNbuBF6Q+UTUFq1jtKom3cp
 9iXAluZoGycgSjG/s2pYLPaD73wC2t6zzA==
X-Google-Smtp-Source: ABdhPJz4xnTY2m6Isi4IBgbuJhluKtEZACOCW6bqOZj5r5ynVvnXZt7dHD/2bSBFHfhe17fyQtZKmIVyCTxRMw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP
 id f15-20020a056a00238f00b004f778b12f6bmr4873058pfc.17.1646958350133; Thu, 10
 Mar 2022 16:25:50 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:13 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 11/26] KVM: x86/mmu: Use common code to allocate
 kvm_mmu_page structs from vCPU caches
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

Now that allocating a kvm_mmu_page struct is isolated to a helper
function, it can be re-used in the TDP MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2dcafbef5ffc..4c8feaeb063d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1704,8 +1704,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 	mmu_spte_clear_no_track(parent_pte);
 }
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
-						      bool direct)
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct)
 {
 	struct kvm_mmu_page *sp;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5f91e4d07a95..d4e2de5f2a6d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -173,6 +173,7 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
 
+struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu, bool direct);
 void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 184874a82a1b..f285fd76717b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -269,13 +269,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
+	return kvm_mmu_alloc_shadow_page(vcpu, true);
 }
 
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
