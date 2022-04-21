Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0355CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DCBA4B26E;
	Fri, 22 Apr 2022 13:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pgLHAfgVzx3y; Fri, 22 Apr 2022 13:50:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94394B2A0;
	Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 857FD49F02
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C9Ffa4KMzH6q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:35:38 -0400 (EDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com
 [209.85.219.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DF7D49F00
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:35:38 -0400 (EDT)
Received: by mail-yb1-f178.google.com with SMTP id w187so352282ybe.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2o+bfoCrm9ENS05/J4NbbBTAqkMpAlAf6csqUjQGcTQ=;
 b=m/ShF2lo3xbNaf8VAl5+Uia+xkKXoGYXilGMMPwqyh4OC1sg7+KDOMh6T+lZnC0GyF
 DzuRd+Q9l56n1anfHL3gafeiHNO9sqQFiwhwYqgFnyZD1d44XVjWjPeJReCzH6pf/7nk
 OkhzFnLO5KjRVIk+br7E9CWH0wsyQPfn+Qu35KvWTakz78FDeUTIA1x4Zf2NTGqhzIEU
 4cM2K7uY+ftNRBqv9Ws0GFb2BjQ4IQb/si+kZwf4AmjOp4iFOS+BIVNEWsdAXZv42qQY
 zCynBapR/RnINkNzeB4scrWsZoWDO/jSR7bGrk8hKVaJmERoTVg9RpO0RY7IjjCisuoU
 N0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2o+bfoCrm9ENS05/J4NbbBTAqkMpAlAf6csqUjQGcTQ=;
 b=pkR1DVoFimKI+Za1dV1h8GZp0KT+pNBY82NUvxBsXJ0sHtwP19S4G3DLkpzHea0YkZ
 QNC34qfS+HWAsEP7PbT9V+1ZA4j5AmvJb8B6h4NPeDAKw6+ZfE+DHJqXZBxyiQWzoJV2
 IEU8lnDGDPN76B8xnD5e9xIRVjxHANMC2SZZFbyZv1BNAXFuhwXJNV2Dj4dp9YdMrYUF
 KOC2biVs7JSbP16dNS/ehTaQlbK3Kpp5leUmMC9AmMOgLkOE2WMtib/+h6NlLmmEE+Y2
 MZQ/3Rrv1y5O4x6wsQiK7o1zcl8Y3hRbNTUdsJeKfo58ubcfY2Dk/W/0/8py+0TUNIo6
 AqVQ==
X-Gm-Message-State: AOAM53271cGeF8JAaX/LZXLTl2l+Kl+1ZLGsjg8zraGCnJAZ9R0g1gZJ
 rebgsweWoAJN9CxJ8OE1D6KBUXPCrJoM5cj1w0W8CnZX0U+HkA==
X-Google-Smtp-Source: ABdhPJwQjb989eibb7OonB7D8gVNlF36degE7seajBqNLXdn06AMKJRHpNLrwXdZytOXmLLJ77afmYHmHe7MXZNMyss=
X-Received: by 2002:a25:4094:0:b0:641:2b90:3b1a with SMTP id
 n142-20020a254094000000b006412b903b1amr568265yba.8.1650558937838; Thu, 21 Apr
 2022 09:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-17-oupton@google.com>
In-Reply-To: <20220415215901.1737897-17-oupton@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:35:27 -0700
Message-ID: <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 22 Apr 2022 13:50:47 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> Voila! Since the map walkers are able to work in parallel there is no
> need to take the write lock on a stage 2 memory abort. Relax locking
> on map operations and cross fingers we got it right.

Might be worth a healthy sprinkle of lockdep on the functions taking
"shared" as an argument, just to make sure the wrong value isn't going
down a callstack you didn't expect.

>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 21 +++------------------
>  1 file changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 63cf18cdb978..2881051c3743 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> -       bool use_read_lock = false;
>         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
>         unsigned long vma_pagesize, fault_granule;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (logging_active) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
> -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> -                                fault_granule == PAGE_SIZE);
>         } else {
>                 vma_shift = get_vma_page_shift(vma, hva);
>         }
> @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       /*
> -        * To reduce MMU contentions and enhance concurrency during dirty
> -        * logging dirty logging, only acquire read lock for permission
> -        * relaxation.
> -        */
> -       if (use_read_lock)
> -               read_lock(&kvm->mmu_lock);
> -       else
> -               write_lock(&kvm->mmu_lock);
> +       read_lock(&kvm->mmu_lock);
> +

Ugh, I which we could get rid of the analogous ugly block on x86.

>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1322,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
>                 ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
>         } else {
> -               WARN_ONCE(use_read_lock, "Attempted stage-2 map outside of write lock\n");
> -
>                 ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>                                              __pfn_to_phys(pfn), prot,
>                                              mmu_caches, true);
> @@ -1336,10 +1324,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       if (use_read_lock)
> -               read_unlock(&kvm->mmu_lock);
> -       else
> -               write_unlock(&kvm->mmu_lock);
> +       read_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
