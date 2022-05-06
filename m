Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D61C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 19:47:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FEDD49EE6;
	Fri,  6 May 2022 15:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dfL7qZgj3aTp; Fri,  6 May 2022 15:47:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FAA94B11E;
	Fri,  6 May 2022 15:47:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A4B4B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 15:47:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id llM2xEtHR93l for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 15:47:19 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17F6549EE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 15:47:18 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 t11-20020a17090ad50b00b001d95bf21996so11701547pju.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 May 2022 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nmr+AH6GUiQVKg/lqAG1BcDa6rkwmcO9PiTJLcm3vjM=;
 b=U2bwdDOISPfpNSZR7/BlxGhBrUPE80tEwKwbP78OiiiqRJAS7GEuBM4FtQq0mbcwwK
 1eJ07Uq+ALubHgrrirJAgrVh3bK0cxESTZ41vWBDRSSoQ4p+EUYwSeotKxB+qT5dflR/
 0bFjJQ++RP9GZ5CVlPHE7PUiV/zMVIvci8VDwW4+WVe5sP8iSYBwZ+CKqsBFvWgCL5XZ
 nhFyG8n+bNq4qzsVlIdX7CMJQzQPgQ0fuIKbiEXUwvOZ/+9gtadOW9UAfhFV+VjXFGAa
 oVoukit96tPbVfrWQ4mpFiFvUPZ2xpqRuq5IRIU93CVwGPX5dIzahsTxzlYlw1wfxEoO
 uZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nmr+AH6GUiQVKg/lqAG1BcDa6rkwmcO9PiTJLcm3vjM=;
 b=tKgEjmX5qbYi1oJyf9+GAI+aoFvi8Qp4rZ44rZdQLeyW3sXYKMQCbQcKi8Ti5XtYZd
 xS5QZAuFT+1CHHmPMVRFUsV7O6Ta6doCWj9qrEpenjrLESnRPJcMFMPEKyUhZvb84f1l
 edjC34DvYNGISkeyx29OX7CTDorEKHqAxPjN40Fio+gLj/bCokSrxM8dJhuwIJ1hz481
 jpDuMaObF/vk9Je5ng4smnurKuRwn6bunjnwCdc6+bLsBvzS/zpx+DsTi/qBOJYzqImN
 cr7Cad1OhCzKrvqBSA/ro1iuj2tZ8yQ+6uNfeUbd3a7S4X72igZ/JIesO5Zx1crIWXLr
 mpcg==
X-Gm-Message-State: AOAM533K5DTKZ3wAOM621OlNl+dTmkfPO1FJ/AUWuAlJiGT5zeYN7sg9
 tL1M5AnzSnswQb12u31LrQW+Xg==
X-Google-Smtp-Source: ABdhPJx2W2s0XDr5knnrxjU/QOn2nWMZ5XriOwGOqf4NFEZIHnzgq+6wjY1bPlgr+nIx5/fnbHXnhA==
X-Received: by 2002:a17:902:ef45:b0:155:cede:5a9d with SMTP id
 e5-20020a170902ef4500b00155cede5a9dmr5107832plx.93.1651866437748; 
 Fri, 06 May 2022 12:47:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 gt9-20020a17090af2c900b001dc1e6db7c2sm7599741pjb.57.2022.05.06.12.47.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 06 May 2022 12:47:16 -0700 (PDT)
Date: Fri, 6 May 2022 19:47:13 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <YnV7QUOkYVg+Ktnl@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-16-dmatlack@google.com>
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
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a8a755e1561d..97bf53b29b88 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  }
>  
>  /*
> - * Using the cached information from sp->gfns is safe because:
> + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> + * and kvm_mmu_page_get_access()) is safe because:
>   * - The spte has a reference to the struct page, so the pfn for a given gfn
>   *   can't change unless all sptes pointing to it are nuked first.
>   *
> @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
>  			continue;
>  
> -		if (gfn != sp->gfns[i]) {
> +		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
>  			drop_spte(vcpu->kvm, &sp->spt[i]);
>  			flush = true;
>  			continue;
>  		}
>  
> +		if (pte_access != kvm_mmu_page_get_access(sp, i))
> +			kvm_mmu_page_set_access(sp, i, pte_access);

Very tangentially related, and more an FYI than anything else (I'll send a patch
separately)...   Replying here because this got me wondering about the validity of
pte_access.

There's an existing bug for nEPT here, which I proved after 3 hours of fighting
with KUT's EPT tests (ugh).

  1. execute-only EPT entries are supported
  2. L1 creates a upper-level RW EPTE and a 4kb leaf RW EPTE
  3. L2 accesses the address; KVM installs a SPTE
  4. L1 modifies the leaf EPTE to be X-only, and does INVEPT
  5. ept_sync_page() creates a SPTE with pte_access=0 / RWX=0

The logic for pte_access (just above this code) is:

		pte_access = sp->role.access;
		pte_access &= FNAME(gpte_access)(gpte);

The parent guest EPTE is 'RW', and so sp->role.access is 'RW'.  When the new 'X'
EPTE is ANDed with the 'RW' parent protections, the result is a RWX=0 SPTE.  This
is only possible if execute-only is supported, because otherwise PTEs are always
readable, i.e. shadow_present_mask is non-zero.

I don't think anything bad happens per se, but it's odd to have a !PRESENT in
hardware, shadow-present SPTE.  I think the correct/easiest fix is:

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b025decf610d..f8ea881cfce6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1052,7 +1052,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
                if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
                        continue;

-               if (gfn != sp->gfns[i]) {
+               if ((!pte_access && !shadow_present_mask) || gfn != sp->gfns[i]) {
                        drop_spte(vcpu->kvm, &sp->spt[i]);
                        flush = true;
                        continue;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c9e87d446a..9ad60662beac 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -101,6 +101,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
        u64 spte = SPTE_MMU_PRESENT_MASK;
        bool wrprot = false;

+       WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+
        if (sp->role.ad_disabled)
                spte |= SPTE_TDP_AD_DISABLED_MASK;
        else if (kvm_mmu_page_ad_need_write_protect(sp))


> +
>  		sptep = &sp->spt[i];
>  		spte = *sptep;
>  		host_writable = spte & shadow_host_writable_mask;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
