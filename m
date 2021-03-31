Return-Path: <SRS0=69BX=I5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A69C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:44:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E1D6E619BD
	for <kvmarm@archiver.kernel.org>; Wed, 31 Mar 2021 07:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1D6E619BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6E54B394;
	Wed, 31 Mar 2021 03:44:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YHgNLk4Uih24; Wed, 31 Mar 2021 03:44:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D94104B37F;
	Wed, 31 Mar 2021 03:44:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F11C54B2C7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:44:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgFYDvzyGs+O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 03:44:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B93214B294
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 03:44:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617176667;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=HCixOYNQFJEmCwNjkKeRd8lCZMOXCEBzJPf2kb2CuW8=;
 b=SkR7Nw7IyJ+G51SVOif8y2tkitAY+0SvmBDqn8EOhG0SOdrh6U9GnriE2ZEANeDGVg1D6J
 mwgG8wj0qxP+e1I6sjTvKcsxkxeZhtkn/o6n1sakCnrJ9D27UkTSXSSfHgYzUxYHUQ4tA9
 fLITZPiESpKTCbP1KKBY1dV2iRGbniE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-wVBasrAyPKmr3fhwN5Zbfg-1; Wed, 31 Mar 2021 03:41:41 -0400
X-MC-Unique: wVBasrAyPKmr3fhwN5Zbfg-1
Received: by mail-wm1-f69.google.com with SMTP id a3so116027wmm.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 00:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=HCixOYNQFJEmCwNjkKeRd8lCZMOXCEBzJPf2kb2CuW8=;
 b=O86AfIAWKTyRr2O92NSZCXbrSz7W9rBLkOV6ZIhqppMVe3ihE7WJL8wGNEWDJecHkD
 qUClszo7nNyPjuFMHEyYj9rEqQM8Nx4d+wAhcGffBpo0chY7PZL/SyYGrof44Hsv1IPD
 Vg6/32LaqyxJyv1oK/v4Dt3iD0m6THmDANS+D4RgDDKFSZhkw7fnw56WwgRWwpeL+com
 iWaZpNpYQSQxj8Z7WDYJs/+qt6MfL7TfdJ2AVFYkP9pceK4b1CeGdc1pI06GAKLpRCz5
 3oVAlUJSoPiYTcPt3aW1Va01bJMUv/MGQtemrygriA/5vU89iiPh7qryeePKjfV/33dG
 EOfA==
X-Gm-Message-State: AOAM530N6+4lvqnH8WyeEI7kvVxsZjRySVkw5IZpR81WGm5YKHdHjr6P
 goZA3RW6Qg5QLCCuCC6UnPUQD/vqvSRvLX9t11zHUpwmuU/4iXDjLD3W941Ag71OoSHVlj/l8bx
 cZBTAXwWkwXVFjWqVtEJIP7Q+
X-Received: by 2002:a1c:b789:: with SMTP id h131mr1904509wmf.106.1617176499782; 
 Wed, 31 Mar 2021 00:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiHmYD2Le+p2rRCHafUQsuCWJvR5BP1vyRx1fx+QhpZoWEEC9/7YIvjmyyJZB+n8xVLiTOmA==
X-Received: by 2002:a1c:b789:: with SMTP id h131mr1904488wmf.106.1617176499531; 
 Wed, 31 Mar 2021 00:41:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id a131sm2662492wmc.48.2021.03.31.00.41.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 31 Mar 2021 00:41:38 -0700 (PDT)
Subject: Re: [PATCH 12/18] KVM: MIPS/MMU: Convert to the gfn-based MMU
 notifier callbacks
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-13-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26c87b3e-7a89-6cfa-1410-25486b114f32@redhat.com>
Date: Wed, 31 Mar 2021 09:41:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210326021957.1424875-13-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 26/03/21 03:19, Sean Christopherson wrote:
> Move MIPS to the gfn-based MMU notifier APIs, which do the hva->gfn
> lookup in common code, and whose code is nearly identical to MIPS'
> lookup.
> 
> No meaningful functional change intended, though the exact order of
> operations is slightly different since the memslot lookups occur before
> calling into arch code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I'll post a couple patches to enable more coalescing of the flushes, but 
this particular patch is okay.

Paolo

> ---
>   arch/mips/include/asm/kvm_host.h |  1 +
>   arch/mips/kvm/mmu.c              | 97 ++++++--------------------------
>   2 files changed, 17 insertions(+), 81 deletions(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index feaa77036b67..374a3c8806e8 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -967,6 +967,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
>   						   bool write);
>   
>   #define KVM_ARCH_WANT_MMU_NOTIFIER
> +#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
>   
>   /* Emulation */
>   int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 3dabeda82458..3dc885df2e32 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -439,85 +439,36 @@ static int kvm_mips_mkold_gpa_pt(struct kvm *kvm, gfn_t start_gfn,
>   				  end_gfn << PAGE_SHIFT);
>   }
>   
> -static int handle_hva_to_gpa(struct kvm *kvm,
> -			     unsigned long start,
> -			     unsigned long end,
> -			     int (*handler)(struct kvm *kvm, gfn_t gfn,
> -					    gpa_t gfn_end,
> -					    struct kvm_memory_slot *memslot,
> -					    void *data),
> -			     void *data)
> +bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	struct kvm_memslots *slots;
> -	struct kvm_memory_slot *memslot;
> -	int ret = 0;
> -
> -	slots = kvm_memslots(kvm);
> -
> -	/* we only care about the pages that the guest sees */
> -	kvm_for_each_memslot(memslot, slots) {
> -		unsigned long hva_start, hva_end;
> -		gfn_t gfn, gfn_end;
> -
> -		hva_start = max(start, memslot->userspace_addr);
> -		hva_end = min(end, memslot->userspace_addr +
> -					(memslot->npages << PAGE_SHIFT));
> -		if (hva_start >= hva_end)
> -			continue;
> -
> -		/*
> -		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> -		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> -		 */
> -		gfn = hva_to_gfn_memslot(hva_start, memslot);
> -		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
> -
> -		ret |= handler(kvm, gfn, gfn_end, memslot, data);
> -	}
> -
> -	return ret;
> -}
> -
> -
> -static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				 struct kvm_memory_slot *memslot, void *data)
> -{
> -	kvm_mips_flush_gpa_pt(kvm, gfn, gfn_end);
> -	return 1;
> -}
> -
> -int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> -			unsigned flags)
> -{
> -	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
> +	kvm_mips_flush_gpa_pt(kvm, range->start, range->end);
>   
>   	kvm_mips_callbacks->flush_shadow_all(kvm);
>   	return 0;
>   }
>   
> -static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				struct kvm_memory_slot *memslot, void *data)
> +static bool __kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	gpa_t gpa = gfn << PAGE_SHIFT;
> -	pte_t hva_pte = *(pte_t *)data;
> +	gpa_t gpa = range->start << PAGE_SHIFT;
> +	pte_t hva_pte = range->pte;
>   	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
>   	pte_t old_pte;
>   
>   	if (!gpa_pte)
> -		return 0;
> +		return false;
>   
>   	/* Mapping may need adjusting depending on memslot flags */
>   	old_pte = *gpa_pte;
> -	if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
> +	if (range->slot->flags & KVM_MEM_LOG_DIRTY_PAGES && !pte_dirty(old_pte))
>   		hva_pte = pte_mkclean(hva_pte);
> -	else if (memslot->flags & KVM_MEM_READONLY)
> +	else if (range->slot->flags & KVM_MEM_READONLY)
>   		hva_pte = pte_wrprotect(hva_pte);
>   
>   	set_pte(gpa_pte, hva_pte);
>   
>   	/* Replacing an absent or old page doesn't need flushes */
>   	if (!pte_present(old_pte) || !pte_young(old_pte))
> -		return 0;
> +		return false;
>   
>   	/* Pages swapped, aged, moved, or cleaned require flushes */
>   	return !pte_present(hva_pte) ||
> @@ -526,27 +477,21 @@ static int kvm_set_spte_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
>   	       (pte_dirty(old_pte) && !pte_dirty(hva_pte));
>   }
>   
> -int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> +bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	unsigned long end = hva + PAGE_SIZE;
> -	int ret;
> -
> -	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
> -	if (ret)
> +	if (__kvm_set_spte_gfn(kvm, range))
>   		kvm_mips_callbacks->flush_shadow_all(kvm);
> -	return 0;
> +	return false;
>   }
>   
> -static int kvm_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -			       struct kvm_memory_slot *memslot, void *data)
> +bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	return kvm_mips_mkold_gpa_pt(kvm, gfn, gfn_end);
> +	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
>   }
>   
> -static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
> -				    struct kvm_memory_slot *memslot, void *data)
> +bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> -	gpa_t gpa = gfn << PAGE_SHIFT;
> +	gpa_t gpa = range->start << PAGE_SHIFT;
>   	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
>   
>   	if (!gpa_pte)
> @@ -554,16 +499,6 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
>   	return pte_young(*gpa_pte);
>   }
>   
> -int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> -{
> -	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
> -}
> -
> -int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
> -{
> -	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
> -}
> -
>   /**
>    * _kvm_mips_map_page_fast() - Fast path GPA fault handler.
>    * @vcpu:		VCPU pointer.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
