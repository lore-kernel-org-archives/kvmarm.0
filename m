Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CA9C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAEC12075F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HtBemui3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAEC12075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 820BB4B1DE;
	Thu, 11 Jun 2020 03:22:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bc+xEeVgAHvu; Thu, 11 Jun 2020 03:22:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8209F4B1E8;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E9F4B150
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:03:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mMVcQMYdjTW7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 18:03:47 -0400 (EDT)
Received: from mail-vs1-f68.google.com (mail-vs1-f68.google.com
 [209.85.217.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15D944B101
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:03:47 -0400 (EDT)
Received: by mail-vs1-f68.google.com with SMTP id q2so2259500vsr.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 15:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vDWPbvyM3cqJd2ORoD0SPltk6IcPQq+mA/Xeq0EsR5Q=;
 b=HtBemui3S+wlJlJDJ02Q481rDHDfxLfLvNajFyxAV+3MgJgw3oMaW3w+9xkzOJHdOU
 OzI3lyiSjv6lYHSB6aO+fOX8oTLV1e+4dTEvg0Bb3jYIltK/8hP7WE2rTFWFLo0BKv+g
 jChlOJLa2VmIeGOlncQkZ+6vIdpbi3ZVjs/+gIMU9m/V7BQmRgkLIDPlHOBzNvHwA7He
 z3s054JQpPVmd5YxEVf2WtDoip/eqp+jrUiBedV1cRI0/JEKwBwm9TwQyKRXySbhpoEO
 8JOOuQ6iXe4IMpPwP/km8+5+pozfjgb/vmU+yBmORAc7J+MYPgsGqfxUKYCncbmW1xJc
 d1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vDWPbvyM3cqJd2ORoD0SPltk6IcPQq+mA/Xeq0EsR5Q=;
 b=JQ7QYHrcYb62mf8rFSU8zmuWMpk86GQKhqMbWAxSzFaKH3dN54680HChxZgeNee75N
 gbArloanoBdeRdPyW4NKccx0Rc+JKV0Z3JtHNtYJ4uB4FldxhUASFsyb4KeHGoWVHflm
 oR7S1lWNXql1XV4lwaJdeHOpZ445YW7StbOLSHfwNxdrgGjtWAogSDgMfnDBAzu4nvSu
 hQ7sBGb0H+XWZh2ZRTJQNvYYoFi3HDfKg9SILZyjPORSVCday4ZxE9dn/h5tMwW3D4if
 t/jU7FJokeGZHdtVq1Dj4CqlUVz/Jm+myQdXNJuQNAWHRelhzU1LqQ1TXDcaIcZE6clg
 MmQg==
X-Gm-Message-State: AOAM532RMxtK9seH5j2g5septlX35q78lrIn/0IyDOocG+53w9hmPTGs
 HzvfaLguaSZALymltHl6pbKERIPwddpSx4cqiSo2Ig==
X-Google-Smtp-Source: ABdhPJzQqRq1kSgZfPTBAuvGye9mC+iq+87t5Ox/WTN7eShxqXFGWQvbS00c/EdH8V5E91+Dg9ynPn922dWRj734K9w=
X-Received: by 2002:a67:70c3:: with SMTP id l186mr4267734vsc.117.1591826626254; 
 Wed, 10 Jun 2020 15:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-4-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-4-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 15:03:35 -0700
Message-ID: <CANgfPd9tOLb2ipbm9-zyo0G4Onh6LqmYq1rg9o93k90DoMsx2A@mail.gmail.com>
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Use consistent "mc" name for
 kvm_mmu_memory_cache locals
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Thu, 11 Jun 2020 03:22:32 -0400
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
> Use "mc" for local variables to shorten line lengths and provide
> consistent names, which will be especially helpful when some of the
> helpers are moved to common KVM code in future patches.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc101663a89..36c90f004ef4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1060,27 +1060,27 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>         local_irq_enable();
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
>
> -       if (cache->nobjs >= min)
> +       if (mc->nobjs >= min)
>                 return 0;
> -       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               if (cache->kmem_cache)
> -                       obj = kmem_cache_zalloc(cache->kmem_cache, GFP_KERNEL_ACCOUNT);
> +       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> +               if (mc->kmem_cache)
> +                       obj = kmem_cache_zalloc(mc->kmem_cache, GFP_KERNEL_ACCOUNT);
>                 else
>                         obj = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>                 if (!obj)
> -                       return cache->nobjs >= min ? 0 : -ENOMEM;
> -               cache->objects[cache->nobjs++] = obj;
> +                       return mc->nobjs >= min ? 0 : -ENOMEM;
> +               mc->objects[mc->nobjs++] = obj;
>         }
>         return 0;
>  }
>
> -static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
> +static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
> -       return cache->nobjs;
> +       return mc->nobjs;
>  }
>
>  static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> @@ -1395,10 +1395,10 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
>
>  static bool rmap_can_add(struct kvm_vcpu *vcpu)
>  {
> -       struct kvm_mmu_memory_cache *cache;
> +       struct kvm_mmu_memory_cache *mc;
>
> -       cache = &vcpu->arch.mmu_pte_list_desc_cache;
> -       return mmu_memory_cache_free_objects(cache);
> +       mc = &vcpu->arch.mmu_pte_list_desc_cache;
> +       return mmu_memory_cache_free_objects(mc);
>  }
>
>  static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
