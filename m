Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF84C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Dec 2021 08:25:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6BE4B0C0;
	Fri,  3 Dec 2021 03:25:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wd4ag7uh8cpt; Fri,  3 Dec 2021 03:25:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CABAD4B0C5;
	Fri,  3 Dec 2021 03:25:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EED3F4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:25:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1EpAG7arcnAG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 03:25:36 -0500 (EST)
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com
 [209.85.161.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B24A49FB7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 03:25:36 -0500 (EST)
Received: by mail-oo1-f43.google.com with SMTP id
 x1-20020a4aea01000000b002c296d82604so1669284ood.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 00:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5hSiMdJ4JdkXT1oeu0/j2Zq5lEiHg2epV5ZCpOwmuQw=;
 b=nAAlnmy1RSemJkeBB4OVDRQDw5dpmnQYMiPDQlFL1Ue1igIWlTxYmiKfgQtZGZwQ79
 YS94v4PBThMoGMq7bfi4XGebdFBLkawteKHC4ADPkqQcHU8KjszSAroCxYrHXqi1DZHa
 b9A9oQ7anxnEo/6rberBet4OIQT0VgQLLEIK1bYMoN8FSUpm7at4138DtV5PUZrioy4K
 zOGjFXqI5brY/D3zDSdS5g9kYoO3DOJJnPMbq+mHKtml7rDdb8saIWV66WBDFRpBrveo
 OuEV6ZpXEcweYo48fWRzAJatHNEtsYg9axDSVGku6IouPJXtgmsQ1IzILulUjMU2Uh5f
 z1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5hSiMdJ4JdkXT1oeu0/j2Zq5lEiHg2epV5ZCpOwmuQw=;
 b=i2tfCf2kfmCJCx67CAqj3HFJCSgKs3TGG+nVdguWUG4TywbSsoB5ggH2dP+sMrXfnV
 1riZYse9YTpF7oCKZL3y5SvASr4AxTKtwZSxgDB3a9nbeyZGRMlRwrFES7VNidx78BMM
 znFdz7ui1CJd9WBNX1eObAV8GPE9VPJ7M4b/ameQgJBOA9r6k251CQIfsF8SukHFjenU
 /fHIAyE51Nw/AoT1T94akJHZd3PHs8VcN6qYGNfuopAOm+ljCqcevRWqmGxR/a7/hkV5
 eFAG0M7QJkUj1xI/medgM76DJmqt4mdza54XD1+jOioDsfffsZGDSy9Ymv2Kdkb8QTVL
 wKmQ==
X-Gm-Message-State: AOAM530Q7rncD0DboTdHx2+/yQAVWpNYnGT33gS4dTD3tQuGgr5mPEdJ
 5CtgAac1G23y1gcRukFNCk1gkccrXi/S38gCInca6A==
X-Google-Smtp-Source: ABdhPJywwb75M4Zqa9QiA47dmCtUK2M+h7ghpc5t1CS2q+nv0Dvi3Yu6JPoj/oN/wXK8h27Ql2XXTss/rtHf7qXDbIk=
X-Received: by 2002:a9d:67c1:: with SMTP id c1mr15670573otn.299.1638519935492; 
 Fri, 03 Dec 2021 00:25:35 -0800 (PST)
MIME-Version: 1.0
References: <20211202171048.26924-1-will@kernel.org>
 <20211202171048.26924-2-will@kernel.org>
In-Reply-To: <20211202171048.26924-2-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 3 Dec 2021 08:24:59 +0000
Message-ID: <CA+EHjTxdLYHJFbuxaj2btXW=ArGG97SrQ5n6-a4etfGGzWkM+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm64: Add missing include of asm/cpufeature.h to
 asm/mmu.h
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Dec 2, 2021 at 5:10 PM Will Deacon <will@kernel.org> wrote:
>
> asm/mmu.h refers to cpus_have_const_cap() in the definition of
> arm64_kernel_unmapped_at_el0() so include asm/cpufeature.h directly
> rather than force all users of the header to do it themselves.

Simplifies the code and makes it cleaner.

I tested this code (the complete patch series) as well and it ran fine.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/mmu.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index e9c30859f80c..48f8466a4be9 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -15,6 +15,7 @@
>  #ifndef __ASSEMBLY__
>
>  #include <linux/refcount.h>
> +#include <asm/cpufeature.h>
>
>  typedef struct {
>         atomic64_t      id;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
