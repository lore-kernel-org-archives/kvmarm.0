Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33ECC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 15:23:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59A0B4B14D;
	Tue, 26 Apr 2022 11:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ue-EvXrr67lg; Tue, 26 Apr 2022 11:23:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5494B1ED;
	Tue, 26 Apr 2022 11:23:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0544B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvGb8yZyyLhL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 01:39:28 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 158274B1C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:28 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t24-20020a17090a449800b001d2d6e740c3so881688pjg.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 22:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UwrHlKcfzo3tcKJryiZhc3lnWD2SSBQRLRI0NxtXWrY=;
 b=lNtBON0+mp7QtqbJUF/yxX4uqPIpQ5Y7hbeXAfVLxM4ZET7uCEK3knJCpkoyZMJa9s
 i7nzVR4VlmZxg+avleS7/Kn/bJZBjnZBXIxlYf/uArgxa5lJaYe/WDTMeZAb28KsbwWU
 ocTkXwvTjA1uESTwFj+I7wr5Rl5sM2mE2cN5TIARIpTfKY2dD2+gpHj1coFpygAy+fc7
 zaCTEQdiWA+0CcKFMaPUEAafXSOqS1yBx10IaODNf6+xQNBSZhNIV/u+JCOUySMFWRfr
 Ms9jv8dEpQuxx8npEiVjqTZIl7JhMtAENDSGpOK7TpWZOGwxxlN4+Ot896M99UFlnkfM
 gIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UwrHlKcfzo3tcKJryiZhc3lnWD2SSBQRLRI0NxtXWrY=;
 b=uz0HV1mGyi+z65YbbIlm7wSTtAfswTkgNe0gz7j9LiBB/QGn+wb+/MogX492T1j+Xx
 +E4H4DHW1NXn2/Z60fmh6Wtw7jUPCfA50EwCSTUIp7Mg33sZ4WgMdmZdAmr056BYSabR
 5fHoGD/i/S2H68i+b57lX4+5c83sjJBAR+149oCaPXVeYxZ0OUPiPqtUGpuuQ5+yHxRR
 zEeF2S3xnKrvFl0QwfU569Ub63dujxkVhoGyeKLcyahvthGEHpxomlrX8P6uXPIQDdhd
 ytrW6og+yT+/ybDn7yzWzVxJpm39SqElgYrBbJl6M7/sfgTi5vfzokTSRObZd5oyheMn
 40Aw==
X-Gm-Message-State: AOAM531znEx/aDuhnCxZpL0xV23s4U0MDsqDWAoSKKrJH9AG35A9zS+q
 EdJRLu/tQNOhbOC0BFj+vbrQ7Sj5tJpiX7Ex
X-Google-Smtp-Source: ABdhPJx5ME5q1MQ2ad+XyRFl1/rgChFdKOrjKjC1cyKbrSm7xzgtrgQj+f7lrmteCRcN2yNApoWsTRuKdbMVeiBw
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a05:6a00:1acd:b0:50c:f6ca:6e6f with
 SMTP id f13-20020a056a001acd00b0050cf6ca6e6fmr18897423pfv.75.1650951567275;
 Mon, 25 Apr 2022 22:39:27 -0700 (PDT)
Date: Tue, 26 Apr 2022 05:39:04 +0000
In-Reply-To: <20220426053904.3684293-1-yosryahmed@google.com>
Message-Id: <20220426053904.3684293-7-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 6/6] KVM: mips/mmu: count KVM page table pages in pagetable
 stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Sean Christopherson <seanjc@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Marc Zyngier <maz@kernel.org>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 11:23:27 -0400
Cc: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
 linux-mm@kvack.org, kvm-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Count the pages used by KVM in mips for page tables in pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/mips/kvm/mips.c | 1 +
 arch/mips/kvm/mmu.c  | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index a25e0b73ee70..e60c1920a408 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -175,6 +175,7 @@ static void kvm_mips_free_gpa_pt(struct kvm *kvm)
 {
 	/* It should always be safe to remove after flushing the whole range */
 	WARN_ON(!kvm_mips_flush_gpa_pt(kvm, 0, ~0));
+	kvm_account_pgtable_pages((void *)kvm->arch.gpa_mm.pgd, -1);
 	pgd_free(NULL, kvm->arch.gpa_mm.pgd);
 }
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 1bfd1b501d82..18da2ac2ded7 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -81,8 +81,10 @@ pgd_t *kvm_pgd_alloc(void)
 	pgd_t *ret;
 
 	ret = (pgd_t *)__get_free_pages(GFP_KERNEL, PGD_ORDER);
-	if (ret)
+	if (ret) {
 		kvm_pgd_init(ret);
+		kvm_account_pgtable_pages((void *)ret, +1);
+	}
 
 	return ret;
 }
@@ -125,6 +127,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 		pmd_init((unsigned long)new_pmd,
 			 (unsigned long)invalid_pte_table);
 		pud_populate(NULL, pud, new_pmd);
+		kvm_account_pgtable_pages((void *)new_pmd, +1);
 	}
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -135,6 +138,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
 		new_pte = kvm_mmu_memory_cache_alloc(cache);
 		clear_page(new_pte);
 		pmd_populate_kernel(NULL, pmd, new_pte);
+		kvm_account_pgtable_pages((void *)new_pte, +1);
 	}
 	return pte_offset_kernel(pmd, addr);
 }
@@ -189,6 +193,7 @@ static bool kvm_mips_flush_gpa_pmd(pmd_t *pmd, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pte(pte, start_gpa, end)) {
 			pmd_clear(pmd + i);
+			kvm_account_pgtable_pages((void *)pte, -1);
 			pte_free_kernel(NULL, pte);
 		} else {
 			safe_to_remove = false;
@@ -217,6 +222,7 @@ static bool kvm_mips_flush_gpa_pud(pud_t *pud, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pmd(pmd, start_gpa, end)) {
 			pud_clear(pud + i);
+			kvm_account_pgtable_pages((void *)pmd, -1);
 			pmd_free(NULL, pmd);
 		} else {
 			safe_to_remove = false;
@@ -247,6 +253,7 @@ static bool kvm_mips_flush_gpa_pgd(pgd_t *pgd, unsigned long start_gpa,
 
 		if (kvm_mips_flush_gpa_pud(pud, start_gpa, end)) {
 			pgd_clear(pgd + i);
+			kvm_account_pgtable_pages((void *)pud, -1);
 			pud_free(NULL, pud);
 		} else {
 			safe_to_remove = false;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
