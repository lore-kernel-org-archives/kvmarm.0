Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD46C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAA65206D5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UhoDqW1r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAA65206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CF514B1B3;
	Mon,  8 Jun 2020 05:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u9asonGZEpOe; Mon,  8 Jun 2020 05:36:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28AD24B1AE;
	Mon,  8 Jun 2020 05:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8055C4B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:56:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7uLJpGw-bH3z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 04:56:45 -0400 (EDT)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 111F84B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:56:45 -0400 (EDT)
Received: by mail-io1-f67.google.com with SMTP id m81so17744731ioa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2020 01:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=DxNt0eIwm9p9g/mQmVwYWK8COQJtmgwTgesczuWioPg=;
 b=UhoDqW1r+NKy9FmTgwkOvep3I+dcHP4n4QbazpDBw5ENhBd5iDewyg+kEYSpd//7qj
 GVeay4/TsadhtoRTPVrfnbOmd+BjIKzn5RPbIogb/LQ2BGY6OUJDouApGyodISusf/fw
 HWbbT9X5pFBE/YIu/EvTPI86t9yV/EBzxNwgyAzf6bzcWD4LMmP9HrFC6zeW8ETQSxj2
 sIbmHWf1MRilR55K95KR5ISOQoAS2PpIOLjHX+u0zcesqRUgPheyMLAOzC/FcO3E5hul
 zBSXRWDsnkp9IcSK37yk4s0sZAYsSWhF0/rXYQDtxSNdVsZ2RzaYi1pJPNWQzrItm4rV
 Xh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=DxNt0eIwm9p9g/mQmVwYWK8COQJtmgwTgesczuWioPg=;
 b=hDA2g7/iuOAy+CmP/dm+ebfDqSrb4yiAx4j6II2obsK1D6nVy9yRRJe/ayHTVOLyVv
 niUEvWO+VvYuCLwEnMrlcd3SjakyHawp0ONIM3SQ3vB9z5Nj0BeTXuEETO+H21pfrXGo
 2e2lAGUqbmKvC+yNdVJz+a2a8v3lyGOUEVpT6uLRIUDLPEXlzAtKJ9YPvc2GWWSm5Q0N
 FZCP6CsMA5da4pwtoK3Q3RGXIsksPeINB/pMW+6vq3JMSwMgP27qvpAjDglQ2ADbBhW3
 0OVxVoM1QFcjCWXwyKs6mWmUyPQKX+XYy4QQBDZf7tiElk/YZSstlkJhPxuYuXwjN/bS
 Nv1w==
X-Gm-Message-State: AOAM533tYQkYQo/DTXBSgyOgM+SdCnG+ibKkrXXrt+4ZhHpfzrtV4D6z
 1Ls4+7t8ZbzGTgDab4lurHnNc6Ffy2XiDGMdn6U=
X-Google-Smtp-Source: ABdhPJy33K/MZi/8fowNpbavwNCsNJmtMmm7LuXYb74EHZQGkej9w1i7LTwl8SZ8cZENnVTKt5AurBBwAssQbfegELw=
X-Received: by 2002:a05:6602:13c6:: with SMTP id
 o6mr20248830iov.84.1591606604459; 
 Mon, 08 Jun 2020 01:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-20-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-20-sean.j.christopherson@intel.com>
From: Huacai Chen <chenhuacai@gmail.com>
Date: Mon, 8 Jun 2020 16:56:32 +0800
Message-ID: <CAAhV-H6v+tO6PCqjfDcecxk-mUk8YEmSDUMjOXMj1hL5=XSpSw@mail.gmail.com>
Subject: Re: [PATCH 19/21] KVM: MIPS: Drop @max param from
 mmu_topup_memory_cache()
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Mon, 08 Jun 2020 05:36:10 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, "open list:MIPS" <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:44 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Replace the @max param in mmu_topup_memory_cache() and instead use
> ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
> BUG_ON() and sets the stage for moving MIPS to the common memory cache
> implementation.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mmu.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 7dad7a293eae..94562c54b930 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -25,15 +25,13 @@
>  #define KVM_MMU_CACHE_MIN_PAGES 2
>  #endif
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> -                                 int min, int max)
> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>  {
>         void *page;
>
> -       BUG_ON(max > KVM_NR_MEM_OBJS);
>         if (cache->nobjs >= min)
>                 return 0;
> -       while (cache->nobjs < max) {
> +       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
>                 page = (void *)__get_free_page(GFP_KERNEL);
>                 if (!page)
>                         return -ENOMEM;
> @@ -711,8 +709,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>                 goto out;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
> -                                    KVM_NR_MEM_OBJS);
> +       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (err)
>                 goto out;
>
> @@ -796,8 +793,7 @@ static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
>         int ret;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES,
> -                                    KVM_NR_MEM_OBJS);
> +       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (ret)
>                 return NULL;
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
