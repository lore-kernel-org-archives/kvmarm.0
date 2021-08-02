Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2F3C4320A
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 10:31:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F05B560F5A
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 10:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F05B560F5A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7069D4A193;
	Mon,  2 Aug 2021 06:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RtAMuyvpdFmS; Mon,  2 Aug 2021 06:31:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ABF34A19B;
	Mon,  2 Aug 2021 06:31:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23D04A126
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 06:31:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VydWCg0ZsrjL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 06:31:02 -0400 (EDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD2D34099E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 06:31:02 -0400 (EDT)
Received: by mail-ej1-f43.google.com with SMTP id oz16so30064763ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 03:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yGVEq9B5bByjRAfhMPs/aPNjzWR9vo1LM/IsDeZ/fw4=;
 b=NhuObWYcT4Ws0XBuXGzohVpUDGBsWLH4oX9MHLm87mGm0eyOzT5PsB+WKSYrCavXnr
 qPixW7MErBufFuWbaYkRUJLEeTDLjpSj7MFMfR1Xso+L8nRPbtdbfotRZGLumNl7gTJu
 R0K3BmV36cB5GI09hubxsKpuY4ThUI2+rMpsfE5o64afsQ72esreblTgFkjibXtlmMmC
 EOTGmpbqO5PirVRv9RmsdqwM9/ewHqzGMXXQIFHScsTHHJch8eRpXGFveDSELD035UZv
 ly9DrFt1gVzB0onpWLtIl7mzSfGMj9juv9pLca65D6xEx30TGFE6r4dxjouj1wJMNPkd
 48lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yGVEq9B5bByjRAfhMPs/aPNjzWR9vo1LM/IsDeZ/fw4=;
 b=n4FwTBhMC9JhhKFcU6Legpct4eMNl4RLcESXfbrZNJKV/vTtMX7e98lURXlFo1O8hF
 uoMDozEBIm85wDIlQdbugi2VeOPysMY/JVO1qvGDs6FYgJy835IhHJPjOmPGfRaiIACy
 /ATId8+ckJgxOZpd/dunHsffl2hz0IqdNXoX8H4Ynb26GOHZCSi2n4/WGoCcnmfyFUKd
 XOAepd4GZzISvOAqo1xbG5v40YEYoitiocdJkT6xTsdsVrLmzWfE1pnX6yEcfQoCVg6v
 OO8tddoCLuJ2SF6+H/CeN1UxS34XgIKB5WlA2Ga3IfUWJaAZbphGYkT3JOHlIEk/eTE/
 c8Qw==
X-Gm-Message-State: AOAM5300iBlATzNLJCux7/f8ISA+GPGbuPzmM6GrB8owG3rrQm8fh3FO
 XugLjejMwSMmaHfvqL+ymIgsqUihcMpqrJOXd/ESPw==
X-Google-Smtp-Source: ABdhPJwELrHM8KMcxJgMtc2//RdcfHO0BBsraGRqwLVekJXAVvzXhMzTKx/LaOqiF+bS/C2fHPTkVM4G1T50Hhsf+GE=
X-Received: by 2002:a17:906:2441:: with SMTP id
 a1mr13848525ejb.550.1627900261494; 
 Mon, 02 Aug 2021 03:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-13-qperret@google.com>
In-Reply-To: <20210729132818.4091769-13-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 12:30:25 +0200
Message-ID: <CA+EHjTzT+aMGkc5cEwGT+05z6aGmbLi0DBetBGXLh3GFY2GXgQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/21] KVM: arm64: Add helpers to tag shared pages in
 SW bits
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


On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> We will soon start annotating shared pages in page-tables in nVHE
> protected mode. Define all the states in which a page can be (owned,
> shared and owned, shared and borrowed), and provide helpers allowing to
> convert this into SW bits annotations using the matching prot
> attributes.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 9c227d87c36d..ae355bfd8c01 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -12,6 +12,32 @@
>  #include <asm/virt.h>
>  #include <nvhe/spinlock.h>
>
> +/*
> + * SW bits 0-1 are reserved to track the memory ownership state of each page:
> + *   00: The page is owned solely by the page-table owner.

nit: solely -> exclusively, because "exclusive" is the more common
term in context of shared resources

> + *   01: The page is owned by the page-table owner, but is shared
> + *       with another entity.
> + *   10: The page is shared with, but not owned by the page-table owner.
> + *   11: Reserved for future use (lending).
> + */
> +enum pkvm_page_state {
> +       PKVM_PAGE_OWNED                 = 0ULL,
> +       PKVM_PAGE_SHARED_OWNED          = KVM_PGTABLE_PROT_SW0,
> +       PKVM_PAGE_SHARED_BORROWED       = KVM_PGTABLE_PROT_SW1,
> +};
> +
> +#define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> +static inline enum kvm_pgtable_prot pkvm_mkstate(enum kvm_pgtable_prot prot,
> +                                                enum pkvm_page_state state)
> +{
> +       return (prot & ~PKVM_PAGE_STATE_PROT_MASK) | state;
> +}
> +
> +static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> +{
> +       return prot & PKVM_PAGE_STATE_PROT_MASK;
> +}
> +

I think that this encoding is pretty neat and easy to follow.

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  struct host_kvm {
>         struct kvm_arch arch;
>         struct kvm_pgtable pgt;
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
