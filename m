Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15CDC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B660206F7
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gEc2R+rV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B660206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADD114B20F;
	Wed, 10 Jun 2020 15:40:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZxoTFcqCUJXF; Wed, 10 Jun 2020 15:40:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 822254B1A8;
	Wed, 10 Jun 2020 15:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A9F4B16A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:52:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h9t1Vw0yXcTT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 14:52:48 -0400 (EDT)
Received: from mail-vk1-f193.google.com (mail-vk1-f193.google.com
 [209.85.221.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86E3F4B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:52:48 -0400 (EDT)
Received: by mail-vk1-f193.google.com with SMTP id i1so848478vkp.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 11:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ou/05hPwTWsJc4qPHUfA/rNqmKzeeLE9v7tAAiFJL6k=;
 b=gEc2R+rVmIe8RhTsWZBHBO23RbA0tr/u76/Es88LGQ/CPuIjId85GC2NsVm8kMoKgL
 xypuOsx9V+65XCavLo3ndTbi2lygTsd1FRAfHTRZ/ft4YFsvaQVS/90q3h6tRE9n54Mf
 xP6C42BDu/Xvcj+jMurPTuDkG8obmR20jvUI42vHwTjju14b7EiA89IQ+Io3L6jolyt7
 RP98ow/xYCC63pO16c+NjSTt4hjR/4a+L2b7Y5x1LoYmsGXUQEMAl+anxxVhRMjwEbfx
 c6Wfd+JbNHcTCTk0eLPkpkHtk69QBNuyxUainnJ40usnuLbLhv3qVR/McNQMZsJakaY8
 2yBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ou/05hPwTWsJc4qPHUfA/rNqmKzeeLE9v7tAAiFJL6k=;
 b=IxGnwUZru2xY4iuIqra2OOKPqYuITFmmiv7sC6PdM0K8NU3BpnUpO+0tbt3e/NOQDA
 t2fW5xUit3Sl5WA3ktpArVrlroOAnX3FIuYC7qD0jg4xUjOBhF1ef7eOrekPt6lac3Y0
 5p/xyR2yAvLVjtNfx7/HWamjYSc0W6zKsm6rnRkGwTtyeWR3oZG5IgR3Y3OP6bFNfA3a
 U7BQrpyJrsxjF4MArx9xDiDcVf8PW/hkV7uq8FG2VJ+C95B0g92WbgsBhISS3O39Aiab
 gzdCa8FRVn3HHZ1LaEC4c+z5d42p4Qvito0Qm/PNbphN7djrtjwCL9pUBZ1HyOB+tf8m
 /Wjw==
X-Gm-Message-State: AOAM533UdEa8WleZLzS6PzOqqE1EG58Jt7VJ6zoSURYFtCoxJJx+lBa4
 Z7++HQFEEWcCdy0G71tPLJlmMOq7QzR5A8YiGbcJmw==
X-Google-Smtp-Source: ABdhPJxdhrcI3GxwX+s2Z6W5dcJTIvbNz9DMjdWBqnMt5wpbMQTIwtRhtuhfggqhbSRYlsDnW4UACO8A1irmUlXnjZ8=
X-Received: by 2002:a05:6122:106f:: with SMTP id
 k15mr3512065vko.21.1591815167751; 
 Wed, 10 Jun 2020 11:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-13-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-13-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 11:52:35 -0700
Message-ID: <CANgfPd9Kjb2QH+K3KwPZBFR3wv33tq7WSX=RoJjJHfkAad5TSg@mail.gmail.com>
Subject: Re: [PATCH 12/21] KVM: x86/mmu: Skip filling the gfn cache for
 guaranteed direct MMU topups
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 15:40:12 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Don't bother filling the gfn array cache when the caller is a fully
> direct MMU, i.e. won't need a gfn array for shadow pages.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 18 ++++++++++--------
>  arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
>  2 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8f8eebf67df..8d66cf558f1b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1101,7 +1101,7 @@ static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>         }
>  }
>
> -static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
> +static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>         int r;
>
> @@ -1114,10 +1114,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>                                    PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> -                                  PT64_ROOT_MAX_LEVEL);
> -       if (r)
> -               return r;
> +       if (maybe_indirect) {
> +               r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> +                                          PT64_ROOT_MAX_LEVEL);
> +               if (r)
> +                       return r;
> +       }
>         return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
>                                       PT64_ROOT_MAX_LEVEL);
>  }
> @@ -4107,7 +4109,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         if (fast_page_fault(vcpu, gpa, error_code))
>                 return RET_PF_RETRY;
>
> -       r = mmu_topup_memory_caches(vcpu);
> +       r = mmu_topup_memory_caches(vcpu, false);
>         if (r)
>                 return r;
>
> @@ -5147,7 +5149,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  {
>         int r;
>
> -       r = mmu_topup_memory_caches(vcpu);
> +       r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
>         if (r)
>                 goto out;
>         r = mmu_alloc_roots(vcpu);
> @@ -5341,7 +5343,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>          * or not since pte prefetch is skiped if it does not have
>          * enough objects in the cache.
>          */
> -       mmu_topup_memory_caches(vcpu);
> +       mmu_topup_memory_caches(vcpu, true);
>
>         spin_lock(&vcpu->kvm->mmu_lock);
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 3de32122f601..ac39710d0594 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -818,7 +818,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>                 return RET_PF_EMULATE;
>         }
>
> -       r = mmu_topup_memory_caches(vcpu);
> +       r = mmu_topup_memory_caches(vcpu, true);
>         if (r)
>                 return r;
>
> @@ -905,7 +905,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>          * No need to check return value here, rmap_can_add() can
>          * help us to skip pte prefetch later.
>          */
> -       mmu_topup_memory_caches(vcpu);
> +       mmu_topup_memory_caches(vcpu, true);
>
>         if (!VALID_PAGE(root_hpa)) {
>                 WARN_ON(1);
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
