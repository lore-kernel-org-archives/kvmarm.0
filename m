Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2CBC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:22:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B76F54B303;
	Mon,  9 May 2022 12:22:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W628ym+oYkyJ; Mon,  9 May 2022 12:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 759E54B2F4;
	Mon,  9 May 2022 12:22:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A484B1F3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id makcRe3CaVad for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:22:27 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99C5F4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:22:27 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id 204so9877979pfx.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=h0BduPSlx+0DYGpcl48qYpS5kqKKQ08NtMh3QxSXYwI=;
 b=JanI5ZQydg1tdBAykjwdsFPI3CK1CwVbAt0KrqXY795qNT/V7Etv6rVxC+dyGPbEAV
 GziUvX8FGVtebKTogqpzyPQGeofN2Rg3T6iNHK6ejGDGzEpBWh3lXl+CCYPYssN94MbQ
 n3gY/+D8E8veN5qQIYAWPYX/1M0UC64rHNYGLvDhsHDZ80Cm9e5UYglbWcc/Cj5LvB1X
 gtHtYXMrhZ7rfTUhYpnNKNzSHb6kl6Uj3zo/cBe4Li6W9PLV2pGV3VFmo0dlz3aCFt1l
 Ep4A1epZ6BRdW5zx9ySp2yBXF7AFLl7bH9j9X7esz8gWCqvktjQqWznULIJpSLql5L+V
 DHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=h0BduPSlx+0DYGpcl48qYpS5kqKKQ08NtMh3QxSXYwI=;
 b=bCJewDPzr1FpeJDEcze6iL4hUGjVVZ9F/gANiP9PUfNb112it9gU0+qd2AQPOWn11h
 +qvlSDvTjPfJw2eeOoDDpJwZoihaHbzQ8QNZF6IW5BcFG1hXw2LJyTRDZ4tgJA9RaOiZ
 20DXGO4KeM5vjNvGQxq4ucHfC4lAxUbhJekX8hlx7UM2SSqn8zpLcyC8H1mlgnXbhFrV
 zzQAzuqpZR9cDyVv/kaNdfqoV0w4s2GXiYtn++mLwiiard28gD39gwf+kCtRQRsQSbLx
 oOnVEW9m2wp8yGzKw0iCzBMGycYQb4fj04CkwJs13Nd6eQLgiOK5YTPb/T+57f3v6KAt
 LJBQ==
X-Gm-Message-State: AOAM532Q4t4lVGm3g4VIC2cJ6imb+u96yMGj5rk6VwvEM3GbtpOtZaH5
 /o/BOo/5hvwXUYaR0h3Mb9sbPA==
X-Google-Smtp-Source: ABdhPJwS/aqF9inY824wgySOHIECTDMrAtVZPxpl4nEz+ZeRKEi2y7w0amGxzMFqw/dLeDMc+xApRA==
X-Received: by 2002:a63:2c8a:0:b0:3c5:f760:2e36 with SMTP id
 s132-20020a632c8a000000b003c5f7602e36mr13796842pgs.372.1652113346392; 
 Mon, 09 May 2022 09:22:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 s40-20020a056a0017a800b0050dc7628146sm9006481pfg.32.2022.05.09.09.22.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:22:25 -0700 (PDT)
Date: Mon, 9 May 2022 16:22:22 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 16/20] KVM: x86/mmu: Extend
 make_huge_page_split_spte() for the shadow MMU
Message-ID: <Ynk/vnHQsXnZkMGT@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-17-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
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

On Fri, Apr 22, 2022, David Matlack wrote:
> Currently make_huge_page_split_spte() assumes execute permissions can be
> granted to any 4K SPTE when splitting huge pages. This is true for the
> TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> shadowing a non-executable huge page.
> 
> To fix this, pass in the child shadow page where the huge page will be
> split and derive the execution permission from the shadow page's role.
> This is correct because huge pages are always split with direct shadow
> page and thus the shadow page role contains the correct access
> permissions.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c    | 13 +++++++------
>  arch/x86/kvm/mmu/spte.h    |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4739b53c9734..9db98fbeee61 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -215,10 +215,11 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> +u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)

Rather than pass in @sp, what about passing in @role?  Then the need for
exec_allowed and child_level goes away (for whatever reason I reacted to the
"allowed" part of exec_allowed).

E.g.

---
 arch/x86/kvm/mmu/spte.c    | 11 +++++------
 arch/x86/kvm/mmu/spte.h    |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 9db98fbeee61..1b766e381727 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -215,10 +215,9 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index)
 {
-	bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
-	int child_level = sp->role.level;
 	u64 child_spte;

 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
@@ -234,9 +233,9 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 	 * split. So we just have to OR in the offset to the page at the next
 	 * lower level for the given index.
 	 */
-	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;

-	if (child_level == PG_LEVEL_4K) {
+	if (role.level == PG_LEVEL_4K) {
 		child_spte &= ~PT_PAGE_SIZE_MASK;

 		/*
@@ -244,7 +243,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 		 * the page executable as the NX hugepage mitigation no longer
 		 * applies.
 		 */
-		if (exec_allowed && is_nx_huge_page_enabled())
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 921ea77f1b5e..80d36d0d9def 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 110a34ca41c2..c4c4bad69f38 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1469,7 +1469,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);

 	/*
 	 * Replace the huge spte with a pointer to the populated lower level

base-commit: 721828e2397ab854b536de3ea10a9bc7962091a9
--
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
