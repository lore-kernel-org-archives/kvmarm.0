Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDD8C4320A
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:57:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59AD66101D
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 59AD66101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB2E54AC78;
	Tue, 10 Aug 2021 00:57:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h75L9c-yvZsx; Tue, 10 Aug 2021 00:57:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB85C4086C;
	Tue, 10 Aug 2021 00:57:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA1C4086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFUOp9JnZ187 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:57:28 -0400 (EDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE6E4401A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:57:27 -0400 (EDT)
Received: by mail-ot1-f44.google.com with SMTP id
 h63-20020a9d14450000b02904ce97efee36so20727488oth.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=rVo6ZQuC84j17R2aTBYBkB+HNRftpnKp0JVkBVBb+Xo=;
 b=tWwOQaCGeIhZEXalvrP8HHqUNQA7VeVYHyJdvmsOYLUjqOXyTpN1ag9+s50Z49HT1t
 5TSSKXW6E9QWVKJGZLcv0+h6jmARLq+oQUTnarMT2np609QOaWwUBvEqIAZO/CLVpLuf
 CkOyqb3YY9qFPExPbXjIPRQCQq+m1lXeRO1yY63bHghiFWk899JO1LD7MVAKCoWd6+gS
 Y8QHYxbMmdjIK16lruHAgnhDYgHd6Aj0Ip4PsPmNBoDY+NayNNUjv2LEZatnwxos2v4b
 bMAKuQZ4P2vRkmN2AMC2sggG+VMNeZECBNIXqWOgfDpGSBpYIuoaOYggYTYQQADQec9w
 +8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=rVo6ZQuC84j17R2aTBYBkB+HNRftpnKp0JVkBVBb+Xo=;
 b=Z3E17zXQ+mYaVJtSY5Cz0ogXHKcDhkjkfngdwYUHK1fIApc+XLJIcGJx87P8xLSzd2
 2sMFxKs/BmyRlzBM48M+kZEtI8caBAEfWeRe38j0OnY6kfgyTg18AAcutPZpV5CIhhPp
 7+TOIzOjOhZd+Wyyloo1lznZfzLH+fEWaPVsD03v6uc5uJJJiJ1p2ErCS1v5UdFE2COc
 uVqYSJohYBO9ja2FMfJUzeb7L5EzxbF/+fS+eDP59MFBQcsxQ7gwEgtwtHBbBxn/OlRi
 vt/4kvN5IfEyRWr7lH27Nf+mawcVZQSldDyIHWX5Llp9rU4hu3HeJT3kc6BSuyKdt4Q5
 s0Bw==
X-Gm-Message-State: AOAM5336vDtGIg+oe7D96NyhyV4w400Kw8+kgJsHZD9QRFnT155Yz92N
 4F14R6iAksEapby9w1HUjYzPWWfjiZ0UjTJsfQcgeg==
X-Google-Smtp-Source: ABdhPJxvMM/sO0bA73bPjTe9IGxtJ/FmOSrcFeKX+ao6BaoN6NuD2s6Ca2nNmbdJHjaVARDvNLL+9vQBw5MoRxiMgTI=
X-Received: by 2002:a05:6830:1095:: with SMTP id
 y21mr9482008oto.144.1628571447257; 
 Mon, 09 Aug 2021 21:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-12-qperret@google.com>
In-Reply-To: <20210809152448.1810400-12-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:56:51 +0200
Message-ID: <CA+EHjTxu57SbJdp45k7Rnp14pSaakg7L9eYOtCr1ohXnj19JGw@mail.gmail.com>
Subject: Re: [PATCH v4 11/21] KVM: arm64: Allow populating software bits
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

On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
>
> Introduce infrastructure allowing to manipulate software bits in stage-1
> and stage-2 page-tables using additional entries in the kvm_pgtable_prot
> enum.
>
> This is heavily inspired by Marc's implementation of a similar feature
> in the NV patch series, but adapted to allow stage-1 changes as well:
>
>   https://lore.kernel.org/kvmarm/20210510165920.1913477-56-maz@kernel.org/
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/include/asm/kvm_pgtable.h | 12 +++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         |  5 +++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2c090b0eee77..ff9d52f8073a 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -121,6 +121,10 @@ enum kvm_pgtable_stage2_flags {
>   * @KVM_PGTABLE_PROT_W:                Write permission.
>   * @KVM_PGTABLE_PROT_R:                Read permission.
>   * @KVM_PGTABLE_PROT_DEVICE:   Device attributes.
> + * @KVM_PGTABLE_PROT_SW0:      Software bit 0.
> + * @KVM_PGTABLE_PROT_SW1:      Software bit 1.
> + * @KVM_PGTABLE_PROT_SW2:      Software bit 2.
> + * @KVM_PGTABLE_PROT_SW3:      Software bit 3.
>   */
>  enum kvm_pgtable_prot {
>         KVM_PGTABLE_PROT_X                      = BIT(0),
> @@ -128,6 +132,11 @@ enum kvm_pgtable_prot {
>         KVM_PGTABLE_PROT_R                      = BIT(2),
>
>         KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
> +
> +       KVM_PGTABLE_PROT_SW0                    = BIT(55),
> +       KVM_PGTABLE_PROT_SW1                    = BIT(56),
> +       KVM_PGTABLE_PROT_SW2                    = BIT(57),
> +       KVM_PGTABLE_PROT_SW3                    = BIT(58),
>  };
>
>  #define KVM_PGTABLE_PROT_RW    (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> @@ -420,7 +429,8 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
>   * If there is a valid, leaf page-table entry used to translate @addr, then
>   * relax the permissions in that entry according to the read, write and
>   * execute permissions specified by @prot. No permissions are removed, and
> - * TLB invalidation is performed after updating the entry.
> + * TLB invalidation is performed after updating the entry. Software bits cannot
> + * be set or cleared using kvm_pgtable_stage2_relax_perms().
>   *
>   * Return: 0 on success, negative error code on failure.
>   */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e25d829587b9..cff744136044 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -357,6 +357,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>         attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
> +       attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>         *ptep = attr;
>
>         return 0;
> @@ -558,6 +559,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>         attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +       attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>         *ptep = attr;
>
>         return 0;
> @@ -1025,6 +1027,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>         u32 level;
>         kvm_pte_t set = 0, clr = 0;
>
> +       if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
> +               return -EINVAL;
> +
>         if (prot & KVM_PGTABLE_PROT_R)
>                 set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
