Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C429C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:56:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBB74610CB
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EBB74610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 682274A19F;
	Tue, 10 Aug 2021 00:56:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jCHHn8i8Bo6o; Tue, 10 Aug 2021 00:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7967D4086C;
	Tue, 10 Aug 2021 00:56:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D8FD4086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:56:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HKBqxA+Ln2HA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:56:49 -0400 (EDT)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com
 [209.85.210.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6775C401A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:56:49 -0400 (EDT)
Received: by mail-ot1-f49.google.com with SMTP id
 c2-20020a0568303482b029048bcf4c6bd9so20682748otu.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mxeliMxH5RLFkPOnb9VsFpY7z4s/EY26/y2zKcYFTKM=;
 b=bVgvBw5b7c+dnqH9Mqa8QCUVGtdlkSzsJdLu8tgceEC8aichoBtE9PmOu7p2DgHM/b
 Kg3vuLFLb8vLj2+1Uy5FN/4DASs1PxiRhu3EwFF/6FQDKASEhmcdz9yTTSGvH4NbmizX
 pVd6NBGKtdNZbROLtLmKdHU7uYasf6BWB0RZf85go1IgfV3Od2wkYyFTGOHg5RvSNmDs
 ABT95AgjkumKr5rgI78ZQr7ONkZwHeX5V5aUn4IV+ZmzafkNsOszHE4lgKZRsySe5qqP
 Vx8zx5mPT6nLUfgEGyNsDWQcWtkgpaLTePlxsMAIS++oDe/4mutz19DbGmQLmhn22LYb
 qdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mxeliMxH5RLFkPOnb9VsFpY7z4s/EY26/y2zKcYFTKM=;
 b=K3mr5//zp43t4JBZwwbB2sTDS+jSw7sTbt2DAKmKssqVp56ee0B8/Q7h8u8JOv4W/F
 j5voPFYIFtf0SeN8UwAeqOhXUci4un0WqvPL/Ixm2CRyT477Zg56c6u0rDNKUuv3ECRB
 fViFViuajtdH5Eyl4RgfPGxh1Zc5nGSFb+U4i31rysP2T5I9sXhkSMMcUevFSKtUW0Ux
 TEssXiJu51GEMsROLejLuBJNhiwDrh+SdeXNZKMp65JEpUTpyFICho1VoxBTQRGq7k6M
 BiKDRaVoEBzcnvqQDrexdqrvLD7KrTY5fx66Jo7tKbZoWVNHIs1ttFUs/keUgyvLqY0N
 zmNw==
X-Gm-Message-State: AOAM530GUbNSE+VmVBE02u+WyoV3JiDUWuJHHiCM2WQ8/21SHoDCrTwh
 Shhi+ityt+urwZ9Q5NARkRdFZ6pg5rRgviWvgurIBA==
X-Google-Smtp-Source: ABdhPJxj6p0KnGyA4aW6SVCeVdmvEmXsuvlbMJKaWVWtf3r2Eo7FyUh+gAsfwiu9BiPHdssNSgxFG1JxZLzy2B1wzSc=
X-Received: by 2002:a9d:7359:: with SMTP id l25mr1020479otk.52.1628571408731; 
 Mon, 09 Aug 2021 21:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-6-qperret@google.com>
In-Reply-To: <20210809152448.1810400-6-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:56:12 +0200
Message-ID: <CA+EHjTzu=_-ZBZYUWiz7T328UYsNsHEfAqxnSRvO5s52t-g2Bw@mail.gmail.com>
Subject: Re: [PATCH v4 05/21] KVM: arm64: Expose page-table helpers
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
> The KVM pgtable API exposes the kvm_pgtable_walk() function to allow
> the definition of walkers outside of pgtable.c. However, it is not easy
> to implement any of those walkers without some of the low-level helpers.
> Move some of them to the header file to allow re-use from other places.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 40 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 39 ---------------------------
>  2 files changed, 40 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 082b9d65f40b..6938eac72c1f 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -25,6 +25,46 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>
>  typedef u64 kvm_pte_t;
>
> +#define KVM_PTE_VALID                  BIT(0)
> +
> +#define KVM_PTE_ADDR_MASK              GENMASK(47, PAGE_SHIFT)
> +#define KVM_PTE_ADDR_51_48             GENMASK(15, 12)
> +
> +static inline bool kvm_pte_valid(kvm_pte_t pte)
> +{
> +       return pte & KVM_PTE_VALID;
> +}
> +
> +static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
> +{
> +       u64 pa = pte & KVM_PTE_ADDR_MASK;
> +
> +       if (PAGE_SHIFT == 16)
> +               pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> +
> +       return pa;
> +}
> +
> +static inline u64 kvm_granule_shift(u32 level)
> +{
> +       /* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
> +       return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
> +}
> +
> +static inline u64 kvm_granule_size(u32 level)
> +{
> +       return BIT(kvm_granule_shift(level));
> +}
> +
> +static inline bool kvm_level_supports_block_mapping(u32 level)
> +{
> +       /*
> +        * Reject invalid block mappings and don't bother with 4TB mappings for
> +        * 52-bit PAs.
> +        */
> +       return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
> +}
> +
>  /**
>   * struct kvm_pgtable_mm_ops - Memory management callbacks.
>   * @zalloc_page:               Allocate a single zeroed memory page.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 78f36bd5df6c..49d768b92997 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -11,16 +11,12 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/stage2_pgtable.h>
>
> -#define KVM_PTE_VALID                  BIT(0)
>
>  #define KVM_PTE_TYPE                   BIT(1)
>  #define KVM_PTE_TYPE_BLOCK             0
>  #define KVM_PTE_TYPE_PAGE              1
>  #define KVM_PTE_TYPE_TABLE             1
>
> -#define KVM_PTE_ADDR_MASK              GENMASK(47, PAGE_SHIFT)
> -#define KVM_PTE_ADDR_51_48             GENMASK(15, 12)
> -
>  #define KVM_PTE_LEAF_ATTR_LO           GENMASK(11, 2)
>
>  #define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX        GENMASK(4, 2)
> @@ -61,17 +57,6 @@ struct kvm_pgtable_walk_data {
>         u64                             end;
>  };
>
> -static u64 kvm_granule_shift(u32 level)
> -{
> -       /* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
> -       return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
> -}
> -
> -static u64 kvm_granule_size(u32 level)
> -{
> -       return BIT(kvm_granule_shift(level));
> -}
> -
>  #define KVM_PHYS_INVALID (-1ULL)
>
>  static bool kvm_phys_is_valid(u64 phys)
> @@ -79,15 +64,6 @@ static bool kvm_phys_is_valid(u64 phys)
>         return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_PARANGE_MAX));
>  }
>
> -static bool kvm_level_supports_block_mapping(u32 level)
> -{
> -       /*
> -        * Reject invalid block mappings and don't bother with 4TB mappings for
> -        * 52-bit PAs.
> -        */
> -       return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
> -}
> -
>  static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
>  {
>         u64 granule = kvm_granule_size(level);
> @@ -135,11 +111,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>         return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>  }
>
> -static bool kvm_pte_valid(kvm_pte_t pte)
> -{
> -       return pte & KVM_PTE_VALID;
> -}
> -
>  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
>  {
>         if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> @@ -151,16 +122,6 @@ static bool kvm_pte_table(kvm_pte_t pte, u32 level)
>         return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
>  }
>
> -static u64 kvm_pte_to_phys(kvm_pte_t pte)
> -{
> -       u64 pa = pte & KVM_PTE_ADDR_MASK;
> -
> -       if (PAGE_SHIFT == 16)
> -               pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> -
> -       return pa;
> -}
> -
>  static kvm_pte_t kvm_phys_to_pte(u64 pa)
>  {
>         kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
> --
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
