Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5A1C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:38:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37ED8610CE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 37ED8610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D18994A522;
	Mon,  2 Aug 2021 05:38:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id peIgPx+j7OTW; Mon,  2 Aug 2021 05:38:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C922740C88;
	Mon,  2 Aug 2021 05:38:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEF44048B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IwpABCrDFamA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:38:00 -0400 (EDT)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53C414020A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:38:00 -0400 (EDT)
Received: by mail-oi1-f181.google.com with SMTP id u10so23411176oiw.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Qnd2EC9vITZLgMCS/eh0ytFlSZARisHdIkWr1reDb+g=;
 b=Cvc16oiWzGruwX0f0ktKnc1ZiyBzxwiqQhJ6zidI9O6soPlFBx0S/h8qiBq1giZ56R
 PLmLFPAKGf6XX1jfTnDi+CtnyBSyDI1LjXcdPSCj7WOhuUHZvjUAQ/cZS6RgpvKQ1FHz
 TufIGOxp4rJPwGDFLeJFThrkm/En8Il1VlcdRkyzsOSBHueCNo/+xiKF1yhSEMEWsYSp
 Aux21NZtYuiMwvPO+6MIZeReeC0zX2cPlz8ebAmvspErZuhEABpQCC+NS58haHIVsyrQ
 HcUOBpS0EsOFhpkNWgZFTYQC62C08pl6dgWCd8FH3fb/YproWIVcsLrfzz42r2uUO6to
 5N2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Qnd2EC9vITZLgMCS/eh0ytFlSZARisHdIkWr1reDb+g=;
 b=iCXZ/IkIVjOObizhPSTFZ9w7JrsZbvHUtq1pDd2LQ3p2hi8lRd2GyPIaXlvArN/v6z
 Ms5EVL2ReVjQbm2+ad1U7ydvlE1rlsdYnrIX83v8YU/XGDN1iLYtUhX7S1hbWZ+YQeXz
 AurMP74wmQjjKooyO+X7Xx6nrEc5XUTQhvMTeezgLFADLW0jRvcLlEkXw7ru7qbcPwMl
 QrUY/ni37PQkM1LYONNm0myyQ4Esme4BfrwmrHmupN/A1Bzlltuilryn0Sg1l+s20bfX
 rqkPvlECAKhF//UpoiG/6grwA35AT/NiQHtXNh4tGm6Irxp7aOexyWatOHacV8TZL/l8
 sYXg==
X-Gm-Message-State: AOAM531fk3DBuWnO950E/pOsdG7pAtcJNJpATq3F7apJP60I2U5D6/Mu
 1UEsAAafk5yAek1/WuaEbgfjgMen4Xi8tNO8wAVGVA==
X-Google-Smtp-Source: ABdhPJxAZ2w+4Gmwl0Swj3Q7EhvFKuhBneyXqG8Tc52r4GVBIzVckQSJCz5xN0cudeXLur8PfIFHqP4V3T4Vzap4ILk=
X-Received: by 2002:a05:6808:1981:: with SMTP id
 bj1mr5627597oib.8.1627897079715; 
 Mon, 02 Aug 2021 02:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-8-qperret@google.com>
In-Reply-To: <20210729132818.4091769-8-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:37:23 +0200
Message-ID: <CA+EHjTyvMdjTAt3Q7ypniF10Qj3_1m_dos=EzxSSCe3Jeo3z4A@mail.gmail.com>
Subject: Re: [PATCH v3 07/21] KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
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
> The ignored bits for both stage-1 and stage-2 page and block
> descriptors are in [55:58], so rename KVM_PTE_LEAF_ATTR_S2_IGNORED to
> make it applicable to both. And while at it, since these bits are more
> commonly known as 'software' bits, rename accordingly.

As in the Armv8-A Address Translation spec.

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad



> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4dff2ad39ee4..59a394d82de3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -36,6 +36,8 @@
>
>  #define KVM_PTE_LEAF_ATTR_HI           GENMASK(63, 51)
>
> +#define KVM_PTE_LEAF_ATTR_HI_SW                GENMASK(58, 55)
> +
>  #define KVM_PTE_LEAF_ATTR_HI_S1_XN     BIT(54)
>
>  #define KVM_PTE_LEAF_ATTR_HI_S2_XN     BIT(54)
> @@ -44,8 +46,6 @@
>                                          KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
>                                          KVM_PTE_LEAF_ATTR_HI_S2_XN)
>
> -#define KVM_PTE_LEAF_ATTR_S2_IGNORED   GENMASK(58, 55)
> -
>  #define KVM_INVALID_PTE_OWNER_MASK     GENMASK(63, 56)
>  #define KVM_MAX_OWNER_ID               1
>
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
