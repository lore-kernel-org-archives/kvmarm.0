Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFD5C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 528422075F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 07:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ssJPmRj0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 528422075F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2B44B1B6;
	Thu, 11 Jun 2020 03:22:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lkDGCSRjK8Ni; Thu, 11 Jun 2020 03:22:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B6D34B1E1;
	Thu, 11 Jun 2020 03:22:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6801D4B199
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:01:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1obB31ANEkvK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2020 18:01:01 -0400 (EDT)
Received: from mail-ua1-f65.google.com (mail-ua1-f65.google.com
 [209.85.222.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4ABA4B1B0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 18:01:01 -0400 (EDT)
Received: by mail-ua1-f65.google.com with SMTP id a10so1419643uan.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2020 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nR4rRNMXeXdrkwRNt5QUkb3PmbbCiqg+ykW9gq1PQDY=;
 b=ssJPmRj0DZMvwcNEm4rDMS1iQrTWKQ/CbrV5wUy4HLikCgt2cbVC/HDDuHwX2SXS34
 /J8wRq6CwydELAPYvYcbwrDRsMkJH2cXrp9p8LbG2wwj5rLX6heicwHC01b/RDYnbI2z
 WKvDdthm3zSW/suBOb+OllMNyyy9hLg5GcCuRmXJk2MArnFxKrNjxDQXng6qwvE2OXW3
 M63vgoCWkMbWKpR90U8Uq4o21HJsc/3BYhChAHeC7UpWQYUMofIIBtqHHBbXocUFsmb9
 aq3zx5lovFe4LSrej8YaDa1SAAckaY56q16hkEW5W4g3RTHhk1/l+KXZQ5nSmR2y9Sm4
 Lnig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nR4rRNMXeXdrkwRNt5QUkb3PmbbCiqg+ykW9gq1PQDY=;
 b=Fd6hw0sXnkIVsM/sMKEHJj3QPnlM4eMW2HS/lPTn014Z4SXLJzorvdxurvAC1ZmjEX
 WUX2EXFDEqUD60j2MVXDnSOAvp+xA13W9sbGZhkvNfIDJAW3VHlXfLx00qhdNyzeByKt
 5vrFPFHVqBY8AB3rdziHT7rDjRH02IVEn3NxZQTStdejekkWlG8dm4j1G5eAnIVQD9E0
 V5FgJEPZh+TpQ2hYRvCGr8QbNsbrdBXPkgWOwy9ZxpxKYmSQZx95ewh0yD3OApXtSia8
 a2oZvV9hhw0WNE1bLAOxCZSsbk8KtfcTC2hxeiP9Tijuv2hG/TxsU9Z7xzidchM1nSqC
 Hpzw==
X-Gm-Message-State: AOAM5335bt+xFPKuhqfQifRQpE93dMxEDXgWxe3Z4okeqZzqi+O9ZS8R
 44OVdHwJ+HoJZIc1tdcE93pYVwy2MonDUtfapsj1uw==
X-Google-Smtp-Source: ABdhPJz7I64SKS5NtEWHj0e9pQtJJ4M+FXlIhms8qP48sFrPid4B2AZwfLYjGcLpBA0gvUju57nQ5kEx5xqguip91SM=
X-Received: by 2002:ab0:70c9:: with SMTP id r9mr4204376ual.15.1591826460956;
 Wed, 10 Jun 2020 15:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-17-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-17-sean.j.christopherson@intel.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 10 Jun 2020 15:00:47 -0700
Message-ID: <CANgfPd-x=Af6Wdn9Wz=9r5CiHDCbxEgQhS2swALUMQd00oQ3jg@mail.gmail.com>
Subject: Re: [PATCH 16/21] KVM: arm64: Drop @max param from
 mmu_topup_memory_cache()
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
> Replace the @max param in mmu_topup_memory_cache() and instead use
> ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
> BUG_ON() and sets the stage for moving arm64 to the common memory cache
> implementation.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm64/kvm/mmu.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a1f6bc70c4e4..9398b66f8a87 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -124,15 +124,13 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
>         put_page(virt_to_page(pudp));
>  }
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -                                 int min, int max)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>  {
>         void *page;
>
> -       BUG_ON(max > KVM_NR_MEM_OBJS);
KVM_NR_MEM_OBJS should be undefined as of patch 14 in this series. I'd
recommend changing this to use the new constant you defined in that
patch.
>         if (cache->nobjs >= min)
>                 return 0;
> -       while (cache->nobjs < max) {
> +       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
>                 page = (void *)__get_free_page(GFP_PGTABLE_USER);
>                 if (!page)
>                         return -ENOMEM;
> @@ -1356,8 +1354,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                         pte = kvm_s2pte_mkwrite(pte);
>
>                 ret = mmu_topup_memory_cache(&cache,
> -                                            kvm_mmu_cache_min_pages(kvm),
> -                                            KVM_NR_MEM_OBJS);
See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> +                                            kvm_mmu_cache_min_pages(kvm));
>                 if (ret)
>                         goto out;
>                 spin_lock(&kvm->mmu_lock);
> @@ -1737,8 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         up_read(&current->mm->mmap_sem);
>
>         /* We need minimum second+third level pages */
> -       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
> -                                    KVM_NR_MEM_OBJS);
See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> +       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
>         if (ret)
>                 return ret;
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
