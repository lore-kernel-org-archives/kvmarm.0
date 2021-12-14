Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5475FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 14:47:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7C654A531;
	Tue, 14 Dec 2021 09:47:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EgQqpL-Ee374; Tue, 14 Dec 2021 09:47:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7FB44B089;
	Tue, 14 Dec 2021 09:47:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0620D4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:47:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FSmdU5l6XJSW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 09:47:20 -0500 (EST)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
 [209.85.166.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2BB549FE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 09:47:19 -0500 (EST)
Received: by mail-io1-f46.google.com with SMTP id z26so24423262iod.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MFaTwQNiJAc7a2QN3hWW+V35/FnCiOZBYqAWjbKuIEY=;
 b=kRnF5ehDIA7oj8ynLN6/ltuRWtbP1Yd+CvSCVe4k9EkbJXvnlglG+1TDjcATPA25Bj
 Toe5TmW4Ih3plx0uXi1C+1Ey/n9J4MbMoNhiMLaU4INjM6u8fx9yqpd7//siCMT6Gjf3
 r7mcUYOMJDqa7InKOh1Z6F5/ZGChUydGGme2nU9whTylnLQaSXlkAYLgV34kuL9KwWDY
 46N2GfRQ25/g17+mJR2D5cuMR1UHt7jUDDX3m9ByOBl4/LUBJr5pYIPLmeIqjGLH9bFG
 0NKZWxrE0q4zHMjQQ9ueSaTozGAKng5dAfbKsRW5U8B1J+1nGB3tKlaADsvVu8Ao0W/3
 qYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MFaTwQNiJAc7a2QN3hWW+V35/FnCiOZBYqAWjbKuIEY=;
 b=cUfuyvQkg6dSZJS4gAK5aPsigzYpemMlb93/DZgFlpkb7zXkFeNm0dPGZSpusrhrds
 ovdeTRZPNEMpoVgEdliX+K0WzTMo46TOHtwOvtgvqBJT+jspq8ucq9DoitLa0LRYwMj2
 vhAB13CWRBwcIVZA5J1pRtXaQDgqT7vaeya1pwrvOy8kNI1HM39WVLgy2EBzRu/Gk4Xk
 5Vr4DLeGf36S8q3vsIGgrcWrHT/wkGai3RTWme/HDI1Cj0yLuek+jvmSePBSbMqTq0jG
 SSYf9dadlSqpYQC1xYiU/EdDXR1Z2JOcLrpk0vS99b8DIX1GSjys9eCrHNh1uGaI8qFa
 ACdA==
X-Gm-Message-State: AOAM53042qHmd30v2ZRChsgE+wS2qWwzdo8E+V4pZQkuAO7w9BjtuSgI
 WZx5PLKn7l05+v2hZ+3U6zgrKPGq18GcU3pI3X9NZw==
X-Google-Smtp-Source: ABdhPJzTpfUg42dgB93Wl6laSIqoo4VQsY8HvOE1UvakA3FA6F/Os6E0TdbetECxIp+IWdNKdcuksIXKsEXFhJuTcWo=
X-Received: by 2002:a05:6602:2a44:: with SMTP id
 k4mr3890265iov.43.1639493238209; 
 Tue, 14 Dec 2021 06:47:18 -0800 (PST)
MIME-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-10-qperret@google.com>
In-Reply-To: <20211201170411.1561936-10-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Tue, 14 Dec 2021 14:47:06 +0000
Message-ID: <CA+_y_2FssSEiyBVU6D5MVrFw9nhBuoJp-qKWQePOMC6HV+NBCA@mail.gmail.com>
Subject: Re: [PATCH v3 09/15] KVM: arm64: Extend pkvm_page_state enumeration
 to handle absent pages
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Wed, 1 Dec 2021 at 17:04, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> Explicitly name the combination of SW0 | SW1 as reserved in the pte and
> introduce a new PKVM_NOPAGE meta-state which, although not directly
> stored in the software bits of the pte, can be used to represent an
> entry for which there is no underlying page. This is distinct from an
> invalid pte, as stage-2 identity mappings for the host are created
> lazily and so an invalid pte there is the same as a valid mapping for
> the purposes of ownership information.
>
> This state will be used for permission checking during page transitions
> in later patches.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index b58c910babaf..56445586c755 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -24,6 +24,11 @@ enum pkvm_page_state {
>         PKVM_PAGE_OWNED                 = 0ULL,
>         PKVM_PAGE_SHARED_OWNED          = KVM_PGTABLE_PROT_SW0,
>         PKVM_PAGE_SHARED_BORROWED       = KVM_PGTABLE_PROT_SW1,
> +       __PKVM_PAGE_RESERVED            = KVM_PGTABLE_PROT_SW0 |
> +                                         KVM_PGTABLE_PROT_SW1,
> +
> +       /* Meta-states which aren't encoded directly in the PTE's SW bits */
> +       PKVM_NOPAGE,
>  };
>
>  #define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> --
> 2.34.0.rc2.393.gf8c9666880-goog

Reviewed-by: Andrew Walbran <qwandor@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
