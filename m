Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B94AC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:17:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B339F6113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B339F6113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 337094A51D;
	Tue, 20 Jul 2021 06:17:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PI-3y-rgyK6L; Tue, 20 Jul 2021 06:17:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32E604B0A3;
	Tue, 20 Jul 2021 06:17:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9A84A51D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:17:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H9Vf57XBEmlv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 06:17:41 -0400 (EDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 234D04A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:17:41 -0400 (EDT)
Received: by mail-ot1-f53.google.com with SMTP id
 b18-20020a0568303112b02904cf73f54f4bso7514693ots.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 03:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3nSJt2wVIh6BPso+/5eEugChhl7K9J9KvL28I6hU2Mc=;
 b=GYmt8m/9xcpbfJpN+JDFmpyQSiDjQCb2/C4Arok72cqv+29SFuIJytkUrLba4/h+yJ
 S5kStZCpS/bjSyihG7MOnHe7cl6OnFiucpWXpykGdrB5sdipCaSB8Mr5r8RirOqjZZeX
 WfF7zxiBwr002UhhGIDgI6mfde7vtmlHyoxITYCgpo+UD9UFYM0WB12yJrweVBTL9JJt
 bEw/vodpV8o7GOxQZeTw4s2MTq7awvaU+7ls6ue7g6ggbra4UyhNdyVorfiugB4gZXt0
 KDuYdgE0NQotaJA/LI0UIW72g3iiFByxEIuPoaA0jns92tBXCSepKXSLpZanvY6KzDIP
 fHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3nSJt2wVIh6BPso+/5eEugChhl7K9J9KvL28I6hU2Mc=;
 b=O3mfmG7ZaoKhHieCjx/LPT44seWZadlt/NX39bk3XFJMFXnPpxakNhXblao0DfYy1b
 0JQrVlnh1Kp7k2w74h1+UaNXfWcnVY0v5xUshdkVjS5SR6aWwURZNfzGdJokJMJ2SA1T
 ZNYWtCrqE8lNSboW0C0dxCIoG48e3IO06GM3TpsupZ5O0VouPQyfllmvFz3Z8DgKBxbt
 sZNdcF3C2Ezziuecjfe7XCvDEVhAh21mYOEHLPDC0GGYHbhkfQEJwx3HuzMrdVfFXNJx
 sUC2Cs+oTQPvnNX+cRq79HUzcLxKInoFlpQqyRhye0v6lIC9liA2uSzg+bVL1b8G3EUi
 p0SA==
X-Gm-Message-State: AOAM532wy7vf+LsZky9OstLRxEzTVqnf24zvbmg5JLWlJ3BKatQBK1rj
 +cZx/XXFN0u6vO4WdE745XyE/NEsxAd9/Ch1a9wq1Q==
X-Google-Smtp-Source: ABdhPJwvdbge9dFU6ODLriZxUOU3MC1qOuSsWZfB9Ag10DwHavakZNHULRmsBxP5cWZD1feem6Z/2nFZ3dkKu0EzFlA=
X-Received: by 2002:a9d:600a:: with SMTP id h10mr21242926otj.144.1626776260256; 
 Tue, 20 Jul 2021 03:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-7-qperret@google.com>
In-Reply-To: <20210719104735.3681732-7-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jul 2021 11:17:03 +0100
Message-ID: <CA+EHjTzjT2iv=9jsTNquSAD-_AWqpyCKVPiuCBWGzpxcAkWf9w@mail.gmail.com>
Subject: Re: [PATCH 06/14] KVM: arm64: Tolerate re-creating hyp mappings to
 set ignored bits
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Quentin,


On Mon, Jul 19, 2021 at 11:47 AM Quentin Perret <qperret@google.com> wrote:
>
> The current hypervisor stage-1 mapping code doesn't allow changing an
> existing valid mapping. Relax this condition by allowing changes that
> only target ignored bits, as that will soon be needed to annotate shared
> pages.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a0ac8c2bc174..34cf67997a82 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -362,6 +362,17 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         return 0;
>  }
>
> +static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
> +{
> +       if (old == new)
> +               return false;
> +
> +       if (!kvm_pte_valid(old))
> +               return true;
> +
> +       return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_IGNORED);

Wouldn't this return false if both ignored and non-ignored bits were
different, or is that not possible (judging by the WARN_ON)? If it is,
then it would need an update, wouldn't it?

Thanks,
/fuad


> +}
> +
>  static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                     kvm_pte_t *ptep, struct hyp_map_data *data)
>  {
> @@ -371,9 +382,12 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         if (!kvm_block_mapping_supported(addr, end, phys, level))
>                 return false;
>
> -       /* Tolerate KVM recreating the exact same mapping */
> +       /*
> +        * Tolerate KVM recreating the exact same mapping, or changing ignored
> +        * bits.
> +        */
>         new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> -       if (old != new && !WARN_ON(kvm_pte_valid(old)))
> +       if (hyp_pte_needs_update(old, new))
>                 smp_store_release(ptep, new);
>
>         data->phys += granule;
> --
> 2.32.0.402.g57bb445576-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
