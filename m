Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6642C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823594BB00;
	Thu, 10 Nov 2022 09:52:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3khabB5rBTqY; Thu, 10 Nov 2022 09:52:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0631B4BB69;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1077C4BA20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:23:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mHdvA-y4h3TE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:23:37 -0500 (EST)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C855E4BA1C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:23:37 -0500 (EST)
Received: by mail-qt1-f179.google.com with SMTP id l2so27356qtq.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Nov 2022 14:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
 b=spArdvT5xfNKFKqJhO//PlvjWcnhvTF2+ViWLb1H96v+OMZm56WD/DL3FTv1+ByYEN
 lsgdE+x7WHSdiZJoLNMKj10oOzlPFVH7OOqJ3Jyl5kqmK/M/sL+IkOQM+KUYRBnDS+Am
 BC+jNOVK5u7F88DAPQFuRMrP8sNj8OpZ35wpepJFStMGQbp7Oicy1zBJOnz2SHSZDpbi
 iZIdImQTkj60o6FYxDzctqMSs5CpMqWSbgDo03a2UfLWnKiqGab805LagiU7qMPRCfXE
 Sq2ANew7d5NwsmA7OWYYkZd+UB7ov+92nWYlaeLE/MXNuAxohNyYD8KzCxJoTSOA58/c
 HdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
 b=rjOGz1BnX8Jp8UXHu+gh5qhHGh3GPJQwCR3t1fFH9adTKB3MWS6HdbKp6r0IDxMKAr
 uuvj/MomGn0luOvIVuq2td8x/+BVtA123nIfcaJeigyYJFKx61KnTbpmJNtnwILMqNbT
 pxoZXYiZcnkS08pq+BfQKF51CgATXstAikp9NxLXAWLNIuixfjLSnPUMuBMFDGh2cMPg
 SUzTTLcKD86+IrKZscR2qjhUVCbAuiSjhz2IWRFpA5GNjsGZxiqJ9uPQ8JRw8Gz1RLRb
 9nz0ts37H4NBrY4l8jwVuiwHPCChRFB2I6Sy5pYL0sZnswOJVmDUlDrslQnueO5+KIey
 SIrw==
X-Gm-Message-State: ACrzQf1ZPhZVEg6MuLSpuIr/AmLDgwJTXrdz3kuBaT14u5lQAj2DIlmb
 i7IGwLv8m/T0HRywqP7zgzUoZ7H+LOn2WTXF1zX0kA==
X-Google-Smtp-Source: AMsMyM4tGmioPPwHHbmDR56b9nxo9rsvbynmSavlKkjED5lHQQmrp870AqPkMfEw30VQwHWm31A/vU+rVcf7R8CSS1Q=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26351094qtb.566.1668032617470; Wed, 09
 Nov 2022 14:23:37 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-5-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-5-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:26 -0800
Message-ID: <CANgfPd_RXJXGQDWrzT-ZCYLOkK_J_LMP3mFkmGsnVAPsqr7KdQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through
 kvm_pgtable_walk_data
To: Oliver Upton <oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> In order to tear down page tables from outside the context of
> kvm_pgtable (such as an RCU callback), stop passing a pointer through
> kvm_pgtable_walk_data.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index db25e81a9890..93989b750a26 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -50,7 +50,6 @@
>  #define KVM_MAX_OWNER_ID               1
>
>  struct kvm_pgtable_walk_data {
> -       struct kvm_pgtable              *pgt;
>         struct kvm_pgtable_walker       *walker;
>
>         u64                             addr;
> @@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>         return (data->addr >> shift) & mask;
>  }
>
> -static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>  {
>         u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
>         u64 mask = BIT(pgt->ia_bits) - 1;
> @@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>         return (addr & mask) >> shift;
>  }
>
> -static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> -{
> -       return __kvm_pgd_page_idx(data->pgt, data->addr);
> -}
> -
>  static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>  {
>         struct kvm_pgtable pgt = {
> @@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>                 .start_level    = start_level,
>         };
>
> -       return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +       return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>  }
>
>  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> @@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>         return ret;
>  }
>
> -static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
>  {
>         u32 idx;
>         int ret = 0;
> -       struct kvm_pgtable *pgt = data->pgt;
>         u64 limit = BIT(pgt->ia_bits);
>
>         if (data->addr > limit || data->end > limit)
> @@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>         if (!pgt->pgd)
>                 return -EINVAL;
>
> -       for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +       for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
>                 kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>
>                 ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> @@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                      struct kvm_pgtable_walker *walker)
>  {
>         struct kvm_pgtable_walk_data walk_data = {
> -               .pgt    = pgt,
>                 .addr   = ALIGN_DOWN(addr, PAGE_SIZE),
>                 .end    = PAGE_ALIGN(walk_data.addr + size),
>                 .walker = walker,
>         };
>
> -       return _kvm_pgtable_walk(&walk_data);
> +       return _kvm_pgtable_walk(pgt, &walk_data);
>  }
>
>  struct leaf_walk_data {
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
