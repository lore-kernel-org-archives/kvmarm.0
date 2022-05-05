Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5008DC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 22:51:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A41944B21F;
	Thu,  5 May 2022 18:51:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cPbwcahvpLbf; Thu,  5 May 2022 18:51:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 605744B1F0;
	Thu,  5 May 2022 18:51:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 240704B1F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:51:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LiAQuGwDEMIw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 18:51:44 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C34A04B1BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 18:51:44 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id x52so4785496pfu.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 15:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=s96H1umg/qV43/22C5Nl7ZCpsFN6ZXGIf/o3otHdHt8=;
 b=jsm2XbMzlpriHcwfe/0kOKXVy11FyfFWR1rwiMswYuBj3MK90WLoqIxsUysaUenNru
 w+Qo0MpA74zT+u8UowzpWq2pwRjUbrRRbWdeKjjmpIqM1Sb0wbIovDKg6c3RAvc6Uoad
 oLzc+INoLRj+x0uDEvn8irK06jUP/vzPL2dEwZONHsm67S/FWHN/Pewp+GP4G9rOAoyq
 2yZaiyLj+utfBZD03HEG1IEGoY4LLpKt4St/1RNK4vCDUnseQnfpDh+a+ZulwZbZIuW3
 Jjv6ico/YqIGh536YOT3DHDDnVn5iYlV6G+OI7YOTUQH7SI6As6F/lAfW1SAzJsVhC7Q
 I+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=s96H1umg/qV43/22C5Nl7ZCpsFN6ZXGIf/o3otHdHt8=;
 b=57F8rnNcIOXf+q0LEdzck+pofWnRh3KqxXxIy3JypHcdwqHU9O0Eug4CLjHEzYuf5r
 V1cwvfiiABATZlYxaJCllpvjG+YkFb6y4vYwScDXKgiGgjhQPfcuDOK8lw2yxIeutm5h
 Psn9ihPSkmwSs/7K/02yXEkVGQMl4hz/01vK1bWQtUhNwgUugsBS0FlkQdgIcEyZfEfQ
 F5/bLeJUOz7si/kvHjg1M5LygJpHU8INSUBxNtsJ6IFKYjH9Hz4+Bg3TmCgfT0FFMSI9
 KF/utYg8MFZ6Pwldfvyzvs+SDa4lQBCdx6Ty55zuwfF1xawAg1pELRPSu088JsWW4GeE
 ov5Q==
X-Gm-Message-State: AOAM531+gCBnDOt9/jXRF4SvGaqmQDM3f5Ub7RiBB6/1PChifSM9Z9C9
 5oVKkFw4ATlBR3731PnDwkOHXA==
X-Google-Smtp-Source: ABdhPJyCAW6StWjxRVvfp7RlyOBP2jZqbrBA7pmE/nSSvQ5s4y9qix3e0nUwHDNmFnbiUshcoMsJuQ==
X-Received: by 2002:a63:1d6:0:b0:3c1:732a:3855 with SMTP id
 205-20020a6301d6000000b003c1732a3855mr270000pgb.571.1651791103104; 
 Thu, 05 May 2022 15:51:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 cq21-20020a056a00331500b0050dc76281e0sm1848870pfb.186.2022.05.05.15.51.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 15:51:42 -0700 (PDT)
Date: Thu, 5 May 2022 22:51:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
Message-ID: <YnRU+zN9T8Zf91Ei@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-8-dmatlack@google.com>
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
> Move the code that write-protects newly-shadowed guest page tables into
> account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
> more logical place for this code to live. But most importantly, this
> reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
> kvm_vcpu pointer, which will be necessary when creating new shadow pages
> during VM ioctls for eager page splitting.
> 
> Note, it is safe to drop the role.level == PG_LEVEL_4K check since
> account_shadowed() returns early if role.level > PG_LEVEL_4K.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fa7846760887..4f894db88bbf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  						    KVM_PAGE_TRACK_WRITE);
>  
>  	kvm_mmu_gfn_disallow_lpage(slot, gfn);
> +
> +	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  	sp->gfn = gfn;
>  	sp->role = role;
>  	hlist_add_head(&sp->hash_link, sp_list);
> -	if (!role.direct) {
> +
> +	if (!role.direct)
>  		account_shadowed(vcpu->kvm, sp);
> -		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))

Huh.  Two thoughts.

1. Can you add a patch to drop kvm_vcpu_write_protect_gfn() entirely, i.e. convert
   mmu_sync_children() to use kvm_mmu_slot_gfn_write_protect?  It's largely a moot
   point, but only because mmu_sync_children() only operates on shadow pages that
   are relevant to the current non-SMM/SMM role.  And _that_ holds true only because
   KVM does kvm_mmu_reset_context() and drops roots for the vCPU on SMM transitions.

   That'd be a good oppurtunity to move this pair into a helper:

   	slots = kvm_memslots_for_spte_role(kvm, sp->role);
	slot = __gfn_to_memslot(slots, gfn);

2. This got me thinking...  Write-protecting for shadow paging should NOT be
   associated with the vCPU or even the role.  The SMM memslots conceptually
   operate on the same guest physical memory, SMM is just given access to memory
   that is not present in the non-SMM memslots.

   If KVM creates SPTEs for non-SMM, then it needs to write-protect _all_ memslots
   that contain the relevant gfn, e.g. if the guest takes an SMI and modifies the
   non-SMM page tables, then KVM needs trap and emulate (or unsync) those writes.

   The mess "works" because no sane SMM handler (kind of a contradiction in terms)
   will modify non-SMM page tables, and vice versa.

   The entire duplicate memslots approach is flawed.  Better would have been to
   make SMM a flag and hide SMM-only memslots, not duplicated everything...

> -			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> -	}
>  
>  	return sp;
>  }
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
