Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69BAC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71C9A2074B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 19:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Sk96oRFz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71C9A2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DE504B1A9;
	Wed, 10 Jun 2020 15:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qnzI4LJk-7Z5; Wed, 10 Jun 2020 15:40:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD5F4B1FE;
	Wed, 10 Jun 2020 15:40:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7797B4B168
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:57:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZDSuTuB8KnM0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 14:57:44 -0400 (EDT)
Received: from mail-ua1-f65.google.com (mail-ua1-f65.google.com
 [209.85.222.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7257E4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 14:57:44 -0400 (EDT)
Received: by mail-ua1-f65.google.com with SMTP id g44so1218023uae.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 11:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vVAD935vzmk+zCqhrKriBW6qDeJ9UbWhrYXMFyoDNbk=;
 b=Sk96oRFzgKSljVnt+6mnQTGDFRR0sIInBe9XAnfxFeWo07PzQGUesvjTrqS2UETGbw
 33JxIrEdcR+6sHmE/xgF9BdVMMrsqGaNijoxzDMr0BORvnpqMlkboWl1jjWyay1ys7QO
 8bpz6ZhJVssu9zvLNYu2RNYv8V5b1aDXEFpmiTlxEmWvOQJ5IbaCgyZIBROKMbu9R0Ts
 Q+V8y6LeyXVnKp3TlABf8aS4jdt3me7MPjKJum7oyVYTDbJvsXQXN3qWMLzNS+UjFXec
 Q9ZEwZtxWUmmCPNxf8lT36jJYD1cIcpvnyeN9ijj5+wpG8wuuX1kDrzho+WryA2ZSCwZ
 pqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vVAD935vzmk+zCqhrKriBW6qDeJ9UbWhrYXMFyoDNbk=;
 b=gAsZPbUt9NSf0XtuQfUJQJFJFrODdeb5b6WWmfdaAQr0bKb2Gb8jVnTRexhb8pXmwM
 hFZgjR3+kKh++VhbIlenv2cdDLbE8S4ltyJza6ZuLYIou1v3y/iuZXLQ6wsLOBi9QT4M
 /2nCk50188n+cDdtl8tMWcEbe7ref0GlFJ/d5ezDvRYZVDKNPA8zfEmAltXsHw90ZqBI
 cUmBcv71fr6phSSflth4sxBzJx3WB/fsJGWUb0mMMJHwnxk82uo2xdSj50dAE6K8yKM6
 G3n5LrfbiGOEvXz66+iIUgXt9ceSdiaonHjtyIKms7JOkMVcGHOBrGyUschCbcmzGIBm
 s/8Q==
X-Gm-Message-State: AOAM5325VTC+YvwDseUCmwqZAsif1VNjjFbxlRDUKkAO7vIyQtlSpouE
 C3xXACv91rZC495jpM1nCcU3x65cbuEV8ZBx4vVBoQ==
X-Google-Smtp-Source: ABdhPJwqVgX0Mxv8PTZWgFn/z7rA1Vsp5KXwbMJOCDIJ24b73HyTMCwRupwGMFcz8Y6tomohXhbM0jt7mBqkr2VcMvI=
X-Received: by 2002:ab0:70c9:: with SMTP id r9mr3681310ual.15.1591815463735;
 Wed, 10 Jun 2020 11:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-11-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-11-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 11:57:32 -0700
Message-ID: <CANgfPd9_BR_2NThfEs8faDxWeooZ6OeF2HAB5mUmted5sHwDPg@mail.gmail.com>
Subject: Re: [PATCH 10/21] KVM: x86/mmu: Make __GFP_ZERO a property of the
 memory cache
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
> Add a gfp_zero flag to 'struct kvm_mmu_memory_cache' and use it to
> control __GFP_ZERO instead of hardcoding a call to kmem_cache_zalloc().
> A future patch needs such a flag for the __get_free_page() path, as
> gfn arrays do not need/want the allocator to zero the memory.  Convert
> the kmem_cache paths to __GFP_ZERO now so as to avoid a weird and
> inconsistent API in the future.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 7 ++++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e7a427547557..fb99e6776e27 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -251,6 +251,7 @@ struct kvm_kernel_irq_routing_entry;
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
> +       gfp_t gfp_zero;
This would make more sense to me if it could be used for general extra
gfp flags and was called gfp_flags or something, or it was a boolean
that was later translated into the flag being set. Storing the
gfp_zero flag here is a little counter-intuitive. Probably not worth
changing unless you're sending out a v2 for some other reason.

>         struct kmem_cache *kmem_cache;
>         void *objects[KVM_NR_MEM_OBJS];
>  };
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d245acece3cd..6b0ec9060786 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1063,8 +1063,10 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                                                gfp_t gfp_flags)
>  {
> +       gfp_flags |= mc->gfp_zero;
> +
>         if (mc->kmem_cache)
> -               return kmem_cache_zalloc(mc->kmem_cache, gfp_flags);
> +               return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
>         else
>                 return (void *)__get_free_page(gfp_flags);
>  }
> @@ -5680,7 +5682,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>         int ret;
>
>         vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> +       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> +
>         vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> +       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
