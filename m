Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558B3C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 10:57:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EC54D539;
	Mon, 18 Jul 2022 06:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nx8yZp9jfJCo; Mon, 18 Jul 2022 06:57:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF3274D522;
	Mon, 18 Jul 2022 06:57:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE834D51D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EWJfIL3j6B7g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 06:57:18 -0400 (EDT)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B2F64D458
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:57:18 -0400 (EDT)
Received: by mail-wm1-f42.google.com with SMTP id
 be14-20020a05600c1e8e00b003a04a458c54so7084885wmb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 03:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=l+h2HYoyNpOTO71DMUTeHgfk/XO5dsFlakdohwm5DuU=;
 b=h1D8GxvDEHEp7hVSx8zz/boM9eIlbBFd3sUSsLcdyQ9XnBYcgPl95iHw4cQm6tt8Vf
 MPs79MZF3K4E9gZ2AGN0f+UFjTB4hU8z+Q7ziriYEakNbclvFu3z4eEy0jqDw04HshGP
 w/vdnBuuunuSFqMcPqkxy72xlOX2wztN3O3IceMuK6xtj2SB/TYr/QC+jY7q5xwe8Tg7
 Nhw4VAiUs5FQ/NDJsMnZkENeDju2dbcTHm5gfR7TshrGArFdjEPrBu0PW+02jJtB+NFw
 o6R6XkYuX5o1/KZyLqJr2yHurhS7R2mx2IhDiNEuFGh01u32GySQJ9TEYwxQJBuB2K6N
 UQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l+h2HYoyNpOTO71DMUTeHgfk/XO5dsFlakdohwm5DuU=;
 b=jGQap0897Y0id67UbA9+eS0m+l9TMs4I4tALLTj+7Hm/uulVVh7F2mH6NsxXpW20Tp
 fZ2U47b/x01Laz68qjWOGuCEaY8arfSh8g9b+w/Uqy7hpcCSaMqqG87p69LT4o9B7w3N
 qmgvOMSyq4AKnSea05S6ZepVdPW0w6r1W9r9E2On0QH9efqku24qxlLNzWqR/15MeIrX
 ap4EjL08PAzm7cOIxWfV/J50wEqDpHeL6W4unQTnt1He8U0GiWa7J6D1sWIlX7m7ghAs
 JBpHqNLHQAiC4tSYEC4wI4vJaYt7bdjmpgILgbtUuDoAdIfaBZjur5tqYRlJqR+L7z0e
 fYXg==
X-Gm-Message-State: AJIora9ilS99n2ZdVPEqkgN0zaYSua7im+HFdU51jUrBFpeL+/qEbK0h
 KNb4IEJ3z07v/K80IsvYvtEtnQ==
X-Google-Smtp-Source: AGRyM1s/cGj8fdxsA/y4TWPk5jYYyUcQDg5YvtMbBXY2i8ZjsjS6G9zcb8wwxCBGfHjPIxLBqEo4zg==
X-Received: by 2002:a05:600c:1908:b0:3a3:f85:702a with SMTP id
 j8-20020a05600c190800b003a30f85702amr13559591wmq.157.1658141837060; 
 Mon, 18 Jul 2022 03:57:17 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com.
 [35.187.36.109]) by smtp.gmail.com with ESMTPSA id
 j9-20020a05600c190900b0039db31f6372sm21111747wmq.2.2022.07.18.03.57.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 03:57:16 -0700 (PDT)
Date: Mon, 18 Jul 2022 11:57:13 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/24] KVM: arm64: Add flags to struct hyp_page
Message-ID: <YtU8iX6tmTOpxvlJ@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-4-will@kernel.org>
 <YtU74D9fcLCpHHwc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtU74D9fcLCpHHwc@google.com>
X-Mailman-Approved-At: Mon, 18 Jul 2022 06:57:36 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Jul 18, 2022 at 11:54:24AM +0100, Vincent Donnefort wrote:
> On Thu, Jun 30, 2022 at 02:57:26PM +0100, Will Deacon wrote:
> > From: Quentin Perret <qperret@google.com>
> > 
> > Add a 'flags' field to struct hyp_page, and reduce the size of the order
> > field to u8 to avoid growing the struct size.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h |  3 ++-
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
> >  3 files changed, 12 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > index 0a048dc06a7d..9330b13075f8 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > @@ -7,7 +7,7 @@
> >  #include <nvhe/memory.h>
> >  #include <nvhe/spinlock.h>
> >  
> > -#define HYP_NO_ORDER	USHRT_MAX
> > +#define HYP_NO_ORDER	0xff
> 
> BUG_ON in hyp_page_ref_inc() might now need to test for 0xff/HYP_NO_ORDER
> instead of USHRT_MAX.

My bad, read to quickly, refcount/order... 

> 
> [...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
