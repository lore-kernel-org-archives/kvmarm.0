Return-Path: <SRS0=Dlxa=7X=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BADC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B85552074B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Jun 2020 11:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WLpRcLXq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B85552074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFB34B2CE;
	Wed, 10 Jun 2020 07:20:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ln2xdhejYhuk; Wed, 10 Jun 2020 07:20:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CEA84B2C0;
	Wed, 10 Jun 2020 07:20:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13DEB4B1D5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 19:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id btINRqxV4NzK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 19:56:26 -0400 (EDT)
Received: from mail-ua1-f66.google.com (mail-ua1-f66.google.com
 [209.85.222.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BC594B1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 19:56:26 -0400 (EDT)
Received: by mail-ua1-f66.google.com with SMTP id z47so237160uad.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2020 16:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4sxWZx3UI6VKLDq8Qy1UYUg5vtAHPMsTevThfv39TWA=;
 b=WLpRcLXqwdVOvuMgwWkmR8Gr4lwaHRK/EF6daq2IMeFXYgWSJrphnkQvLEH+41LO0x
 pBkEeJfVAEq/uryeN4HHM4Hb3NfdIqrrZcULOeMuMtGfZEKTK0JPggE4ybLNYEuiV0pp
 hiSCdaRlAd+ayR3yLwkLqaPFRVUUau1KjcEyNNFF5lmfQTLhnmvgVGyA1JJV3qaW45Fh
 jEN3gjAjfZpQCTtGPfowcu+cTV09P9OWMskURcxzz2UEuwU2bgMY7NSPvwSFJYRc6/bv
 5cAINv0x9snM9p3flSgBPUFTJrC9TtnEnQ07K+dBbcgAeuIsCrM4zFy5fBTuIldM5yBs
 xNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4sxWZx3UI6VKLDq8Qy1UYUg5vtAHPMsTevThfv39TWA=;
 b=cOojYzGD+ACwP/aPqoXzN6r2ses5E2n6di4w0ZgG2mStEHBuvWNUA7DaAcId6kgZ4u
 EaROuo22SZcYmS63RTec+nsdWKzloh5TPh3PQdCvgBu4KznJkAvBvXOLiEOHLfhDjsTY
 o45cki8thrQYjgR+kmbt6kzmxNgfcd73Og7TZl6V6yZCsNKwlwvcNUMK/hA2Nys7d50o
 hS0FMTYazMIJCY6KP3wiUbZrTUSu38TMDP3fgNh78U/0JvDFT1SKsdgTvqp7BHOkxhEV
 TU9g3cjUkM9zyGl13VXaKQoroKRqRCZL2uTUFjlf/rxaFTM1PZMKZPsH9EpovR7PqONf
 SI/w==
X-Gm-Message-State: AOAM531ee2dIG6iSIoezR6RM0TvjWeV0ciSdwAbTFLDTF4TOLu4yuTKu
 eSy03he92EC72W+g7BiJ9X59Tjd10ReB1k9lApW/RQ==
X-Google-Smtp-Source: ABdhPJyXAGLXljdkHhgQRDD2Vm3KO3b89VigddFLuju4QbS8KbKbayXYphsX76+lBqoc+5yPzGQnUDz7icYaQgNy+rs=
X-Received: by 2002:ab0:6012:: with SMTP id j18mr679163ual.69.1591746985111;
 Tue, 09 Jun 2020 16:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-10-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-10-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 9 Jun 2020 16:56:13 -0700
Message-ID: <CANgfPd_ftZ_fC0EEt=1nOoyc6Yi6Xo3TB4woY=tkHzXbjHk4aA@mail.gmail.com>
Subject: Re: [PATCH 09/21] KVM: x86/mmu: Separate the memory caches for shadow
 pages and gfn arrays
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Wed, 10 Jun 2020 07:20:46 -0400
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
> Use separate caches for allocating shadow pages versus gfn arrays.  This
> sets the stage for specifying __GFP_ZERO when allocating shadow pages
> without incurring extra cost for gfn arrays.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 15 ++++++++++-----
>  2 files changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 16347b050754..e7a427547557 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -636,7 +636,8 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu *walk_mmu;
>
>         struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> -       struct kvm_mmu_memory_cache mmu_page_cache;
> +       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> +       struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
>
>         /*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 451e0365e5dd..d245acece3cd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1108,8 +1108,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>                                    1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> -                                  2 * PT64_ROOT_MAX_LEVEL);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +                                  PT64_ROOT_MAX_LEVEL);
> +       if (r)
> +               return r;
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> +                                  PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
>         return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> @@ -1119,7 +1123,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>         mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +       mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
>         mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> @@ -2096,9 +2101,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>         struct kvm_mmu_page *sp;
>
>         sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> +       sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>         if (!direct)
> -               sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> +               sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
>         /*
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
