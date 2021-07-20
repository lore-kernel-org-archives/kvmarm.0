Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F8CC07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:48:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9ECD761186
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9ECD761186
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A01D4B0C7;
	Tue, 20 Jul 2021 09:48:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cx6sh9iwI1E6; Tue, 20 Jul 2021 09:48:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F380849D50;
	Tue, 20 Jul 2021 09:48:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5EC40808
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:48:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1TVggj+cfzrg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 09:48:46 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8361407EF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:48:46 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 o72-20020a9d224e0000b02904bb9756274cso21582007ota.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sSKYKbxnVu+G8KsuMx0V0FlK4uTjY08r+UWrZ/z8LHQ=;
 b=utAjJcc9cGMaMXp3rIBJ1ZRTSBKvYt0c86Q62CMxLwEWhTH+xS0N+cbAwxz7Y2TFM4
 dp6GRnKGtA6N6wQuQ+FTqHC5WYixuviEtvzFioOV8p6mJoFir6Qc99xo2H87a8BznM6T
 SmXVeUKSAJ2YxDebBssr4xVaAO78BHlhlYwsMlGNwZ8wmSgRCDB9iH5Ar+9VJBzUU4ga
 7M6VNPrGVXhUCdtAr+Dmzm7WHV7bhTh/T6OMjEb6K2tww/GGztX2oZoTDDfyGdZ24ZfN
 h6PgRlr2wokfmTq8lbrr7qoeplfwRm/eGNhXml8CRF+5rGCpdRCemqSuz/HNtGv1TRK/
 8DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sSKYKbxnVu+G8KsuMx0V0FlK4uTjY08r+UWrZ/z8LHQ=;
 b=S8m9YZRO9dr6xPcsxoc24Yb8ir+cYXNbx+792Dl1yU+h6ck6I+y6A8+POVfhW+wdMy
 0S1xVVpDOWFXHM2ZmvELdp/NXg5cW8Y3aV7HbdkJC+x+2JuGywu8pKPYayGs34jSd2PA
 Yk5fpjp2lDZqD2MWfgJay0By7DHbGx1xCIkeXXbeHR7uSPlVuxlfbITjg+0svIMmr9Qk
 axvUofWjYoqGivo3wZr8mvCCDJeWWRFQV/fRglcB/62fuwsoy/8NLvQ1G3vSPxXOMeYj
 sWMYOWF4++qDSWdqVdNWVY8fbh+ylLKKwqXiRUCcfSjbdyjG7WdOeaKagaZKmFlSxTGi
 ZRiw==
X-Gm-Message-State: AOAM533TYnNKfeuexF0Bb5r+OTv19MQ5ssBCzemlBRXX49koITL3RrpC
 tthjbBhq9t3OVjHKgxHGg+WR4LZKshJv/AYXx45o+g==
X-Google-Smtp-Source: ABdhPJwO2Xb6g/ZfTRHpSfHvJvHBkk79kp1jTLisPNfqjoFjNOCC/oC/AfEZFLcKbXu8Y1Xt91MqVh+c+yhVsZgW1nw=
X-Received: by 2002:a05:6830:1455:: with SMTP id
 w21mr22257855otp.365.1626788926039; 
 Tue, 20 Jul 2021 06:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-9-qperret@google.com>
In-Reply-To: <20210719104735.3681732-9-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jul 2021 14:48:09 +0100
Message-ID: <CA+EHjTwmmV6EooG+Ykbso3G6nkjq=sbRzXH3vetazzPF5mO02g@mail.gmail.com>
Subject: Re: [PATCH 08/14] KVM: arm64: Add support for tagging shared pages in
 page-table
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
> The hypervisor will soon be in charge of tracking ownership of all
> memory pages in the system. The current page-tracking infrastructure at
> EL2 only allows binary states: a page is either owned or not by an
> entity. But a number of use-cases will require more complex states for
> pages that are shared between two entities (host, hypervisor, or guests).
>
> In preparation for supporting these use-cases, introduce in the KVM
> page-table library some infrastructure allowing to tag shared pages
> using ignored bits (a.k.a. software bits) in PTEs.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
>  arch/arm64/kvm/hyp/pgtable.c         | 25 +++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dd72653314c7..f6d3d5c8910d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -81,6 +81,8 @@ enum kvm_pgtable_stage2_flags {
>   * @KVM_PGTABLE_PROT_W:                Write permission.
>   * @KVM_PGTABLE_PROT_R:                Read permission.
>   * @KVM_PGTABLE_PROT_DEVICE:   Device attributes.
> + * @KVM_PGTABLE_STATE_SHARED:  Page shared with another entity.
> + * @KVM_PGTABLE_STATE_BORROWED:        Page borrowed from another entity.
>   */
>  enum kvm_pgtable_prot {
>         KVM_PGTABLE_PROT_X                      = BIT(0),
> @@ -88,6 +90,9 @@ enum kvm_pgtable_prot {
>         KVM_PGTABLE_PROT_R                      = BIT(2),
>
>         KVM_PGTABLE_PROT_DEVICE                 = BIT(3),
> +
> +       KVM_PGTABLE_STATE_SHARED                = BIT(4),
> +       KVM_PGTABLE_STATE_BORROWED              = BIT(5),
>  };
>
>  #define KVM_PGTABLE_PROT_RW    (KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5bdbe7a31551..51598b79dafc 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -211,6 +211,29 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
>         return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
>  }
>
> +static kvm_pte_t pte_ignored_bit_prot(enum kvm_pgtable_prot prot)
> +{
> +       kvm_pte_t ignored_bits = 0;
> +
> +       /*
> +        * Ignored bits 0 and 1 are reserved to track the memory ownership
> +        * state of each page:
> +        *   00: The page is owned solely by the page-table owner.
> +        *   01: The page is owned by the page-table owner, but is shared
> +        *       with another entity.
> +        *   10: The page is shared with, but not owned by the page-table owner.
> +        *   11: Reserved for future use (lending).
> +        */
> +       if (prot & KVM_PGTABLE_STATE_SHARED) {
> +               if (prot & KVM_PGTABLE_STATE_BORROWED)
> +                       ignored_bits |= BIT(1);
> +               else
> +                       ignored_bits |= BIT(0);
> +       }

This might tie in to Marc's comments for using enums, but
consolidating the translation between prot and ignored/software bits
in one place would be good: thinking about patch 10 as well, where you
get the prot from the ignored bits. Even though you have documented
it, I'm finding the part where a field can be borrowed and shared as
opposed to being only shared not very intuitive, and I need to reread
the comment here to remember the difference while going through the
code.

You also mention lending as potentially reserved for the future, but I
think that lending is the other side of borrowing (depends on who's
doing the giving/taking). I wonder if in this case it would be clearer
to describe it in terms of whether it's exclusively owned vs owned but
shared (for the owner), and just shared for the sharer...

Thanks,
/fuad


> +       return FIELD_PREP(KVM_PTE_LEAF_ATTR_IGNORED, ignored_bits);
> +}
> +
>  static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
>                                   u32 level, kvm_pte_t *ptep,
>                                   enum kvm_pgtable_walk_flags flag)
> @@ -357,6 +380,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>         attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
> +       attr |= pte_ignored_bit_prot(prot);
>         *ptep = attr;
>
>         return 0;
> @@ -558,6 +582,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>
>         attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
>         attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +       attr |= pte_ignored_bit_prot(prot);
>         *ptep = attr;
>
>         return 0;
> --
> 2.32.0.402.g57bb445576-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
