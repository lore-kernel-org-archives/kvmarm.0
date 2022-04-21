Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CDBC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 16:21:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8565C4B268;
	Thu, 21 Apr 2022 12:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OHZ9iEcLXsp7; Thu, 21 Apr 2022 12:21:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 610974B27C;
	Thu, 21 Apr 2022 12:21:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1DAB4B120
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S3VDJS963QzS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:11:48 -0400 (EDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com
 [209.85.219.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835E24B103
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:11:48 -0400 (EDT)
Received: by mail-yb1-f169.google.com with SMTP id f17so9582764ybj.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9h79Dam9UnF7WuVSpGPR0fKcSCWthUWAHVVa4W5NH1Q=;
 b=P1q2oMu+LcPYjFpBImXpUU3WKyFrHl+pRUsD7F4zni8JefspRBqHLsgxE8tox5tnPI
 7fdcxpf96zptR8sH+Ks/+pTd2OJHPHketV67C1qNU442AGmBI/UbbQxsOchYTB1CYbIt
 0ZjXqq/npJKyA/O+FbCZeF2L1scB/7QCDktQlRF/279tdm0nbt9qTIWrwZk9dL6TbW9O
 H8t8aMTTKaQC8yhmv4+Kaha0ZeviiYEaKe0DHCGwnKaszP31r3g3jD3BjXRkqy/JC/og
 uIvQ2XqMdPRiTZxNwszFbx4xWjxTlLYpE00ye5/gSOhJ43/NrsoER/cAI1fvU8/kH2P7
 yMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9h79Dam9UnF7WuVSpGPR0fKcSCWthUWAHVVa4W5NH1Q=;
 b=yC4KBwJlk0LfJPos0NHPObaDjs9RWrW3rxiK3F4xP0VDSwQ6DjVAJetb/vAXSWyTcS
 XBCjoR+YK+OhCE4tOh5xykwfwDdNbif3GnmhSabidzRuAQVxmWLyu2QepAxGUB8syYeC
 khYbkmm5J7tpCjKsr55SJ9fAaPVngy1NrhglDfIrn6rOhanAqJVQ0tSk7hLY8yPh1lMa
 tnR0DkA15YiQoQPljwzCNW6Fu01RCydhh4AFSBw+9DFnN71Uwcy4q5kFXf3yCav3PP0H
 znkzvUvhATVnMDNpjPNGWYEENFyvg76HYRPNU++v37p8MIXIUU8L6ZwoZvwFw2KoAJU6
 K9+Q==
X-Gm-Message-State: AOAM533UbMv41QUQSnRWxyfP1ti9/D1yJu0gCAtwl3aBQtk0GirgSjDa
 KY9ifs3yTNLGbn+WIThmvETFOYo+UdTLYShAjqJmVw==
X-Google-Smtp-Source: ABdhPJz2cRZxZNHSPgU0ZKYBBHbqFE34lNJqe83C4OuSK2Sxd9ItKpzi7ayjSqm1qNcCzjtbCUQaDanXSmvgvbpX1oQ=
X-Received: by 2002:a25:94a:0:b0:615:7cf4:e2cd with SMTP id
 u10-20020a25094a000000b006157cf4e2cdmr401275ybm.227.1650557507772; Thu, 21
 Apr 2022 09:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-11-oupton@google.com>
In-Reply-To: <20220415215901.1737897-11-oupton@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:11:37 -0700
Message-ID: <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
Subject: Re: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already owned
 in post-order traversal
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Thu, 21 Apr 2022 12:21:15 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> For parallel walks that collapse a table into a block KVM ensures a
> locked invalid pte is visible to all observers in pre-order traversal.
> As such, there is no need to try breaking the pte again.

When you're doing the pre and post-order traversals, are they
implemented as separate traversals from the root, or is it a kind of
pre and post-order where non-leaf nodes are visited on the way down
and on the way up?
I assume either could be made to work, but the re-traversal from the
root probably minimizes TLB flushes, whereas the pre-and-post-order
would be a more efficient walk?

>
> Directly set the pte if it has already been broken.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 146fc44acf31..121818d4c33e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -924,7 +924,7 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                       kvm_pte_t *ptep, kvm_pte_t old,
>                                       struct stage2_map_data *data,
> -                                     bool shared)
> +                                     bool shared, bool locked)
>  {
>         kvm_pte_t new;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
> @@ -948,7 +948,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         if (!stage2_pte_needs_update(old, new))
>                 return -EAGAIN;
>
> -       if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
> +       if (!locked && !stage2_try_break_pte(ptep, old, addr, level, shared, data))
>                 return -EAGAIN;
>
>         /* Perform CMOs before installation of the guest stage-2 PTE */
> @@ -987,7 +987,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  }
>
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                               kvm_pte_t *old, struct stage2_map_data *data, bool shared)
> +                               kvm_pte_t *old, struct stage2_map_data *data, bool shared,
> +                               bool locked)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>         kvm_pte_t *childp, pte;
> @@ -998,10 +999,13 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                 return 0;
>         }
>
> -       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared);
> +       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared, locked);
>         if (ret != -E2BIG)
>                 return ret;
>
> +       /* We should never attempt installing a table in post-order */
> +       WARN_ON(locked);
> +
>         if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>                 return -EINVAL;
>
> @@ -1048,7 +1052,13 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>                 childp = data->childp;
>                 data->anchor = NULL;
>                 data->childp = NULL;
> -               ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
> +
> +               /*
> +                * We are guaranteed exclusive access to the pte in post-order
> +                * traversal since the locked value was made visible to all
> +                * observers in stage2_map_walk_table_pre.
> +                */
> +               ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, true);
>         } else {
>                 childp = kvm_pte_follow(*old, mm_ops);
>         }
> @@ -1087,7 +1097,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
>         case KVM_PGTABLE_WALK_TABLE_PRE:
>                 return stage2_map_walk_table_pre(addr, end, level, ptep, old, data, shared);
>         case KVM_PGTABLE_WALK_LEAF:
> -               return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
> +               return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, false);
>         case KVM_PGTABLE_WALK_TABLE_POST:
>                 return stage2_map_walk_table_post(addr, end, level, ptep, old, data, shared);
>         }
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
