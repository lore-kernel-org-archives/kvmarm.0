Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B420FC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 13 Sep 2022 04:11:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA094BBF9;
	Tue, 13 Sep 2022 00:11:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3caF05G0P0e5; Tue, 13 Sep 2022 00:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1EA4BBFB;
	Tue, 13 Sep 2022 00:11:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7855D4BBF9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 00:11:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xeNIlInQpZCA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 00:11:12 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2441D4BBF4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 00:11:12 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id k9so18794157wri.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Sep 2022 21:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=CVbSa+/qoRHiRq48IgUS3irpZOjrJDEoYacMrNQAtOE=;
 b=duGTUBwr7IU1If9T6F9LAshp5l73d5fJ2R+vTkprg/tyemXx34dXvA88VvFZyHTyQV
 OU4kwDzMCnE8C2bPP8wNvZaseK7PfgYr2JKAnJfndUKXxG08+EzAr2kMl8ALl1PKs+ZD
 +cU0j1JloAUNmi9IEV/oByNE4fSEiLydbPjqHmfFFdxAnbBellfWTw6ABnaZav8Qu05N
 BCtKCViC4JngjL1jOevVvHhjvFUZqauiTwvq6itbHgECYm1CqDx9tOvQGXKfLy4lB+WG
 k+wYZZ2RGqbuRLqA8W9grIAOP6Zr8h/ahClTUNYHpkbeabfw69y8XAo/xCxvaait17OH
 40Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=CVbSa+/qoRHiRq48IgUS3irpZOjrJDEoYacMrNQAtOE=;
 b=CuFrd/o0thrglA4nhAiAfu51GtLlSEwBL7aIGc7/+dnPcnFazD9wNV2XFr7L+dpBYc
 WE+qsoPwF4ovccnlanHQhLqsgpYSM/nA9eLzzCHLykME0gXntf7XJsv9r6Yqdmc0YBIy
 3YL1lE91JD7Fk5x4IPQc7qTixHiLXgkoLtJ5Uq4Y1PagdlQhzQwjFVlnl9lGT5sWasVc
 2zEzL8fUVFwjkrd9MerteMya2f7037vYFqfvjSCYhgtcN/shG+J9nykRU+rxKHlgb+XT
 bKlv4A8xk6asvnUrK/Gaj5t2lyKA2k8APFiAzLB2d17nmZXHvJ7jWkWmdMagwaLhOeaK
 RDgQ==
X-Gm-Message-State: ACgBeo0gYegBs2n2lYqkqHiEAke+0VrkzAga2UC/aR3/MorRcl7OQzrX
 tx6c/Ysd/avDm8ywgXZUjxN41iTPSmZknUQyp5zH4w==
X-Google-Smtp-Source: AA6agR5gH2VCKDnM+Ue9zmgPKtM7MNJrX54DRWkE+hNVUsK6TWIw8+oDlVQ2ylRk9OAf5b10MjfzYxGJzELYkEt7dTw=
X-Received: by 2002:adf:f54a:0:b0:228:951a:2949 with SMTP id
 j10-20020adff54a000000b00228951a2949mr16641246wrp.240.1663042271021; Mon, 12
 Sep 2022 21:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-7-pcc@google.com>
 <874jxcv9xn.wl-maz@kernel.org>
In-Reply-To: <874jxcv9xn.wl-maz@kernel.org>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 12 Sep 2022 21:10:59 -0700
Message-ID: <CAMn1gO6ZHrQkkYOaicDftUbRSYgngUa4bPKFTLk_q0qxuGz6Zw@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Mon, Sep 12, 2022 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 10 Aug 2022 20:30:32 +0100,
> Peter Collingbourne <pcc@google.com> wrote:
> >
> > Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
> > on being able to map guest memory as MAP_SHARED. The current restriction
> > on sharing MAP_SHARED pages with the guest is preventing the use of
> > those features with MTE. Now that the races between tasks concurrently
> > clearing tags on the same page have been fixed, remove this restriction.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 8 --------
> >  1 file changed, 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d54be80e31dd..fc65dc20655d 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> >
> >  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> >  {
> > -     /*
> > -      * VM_SHARED mappings are not allowed with MTE to avoid races
> > -      * when updating the PG_mte_tagged page flag, see
> > -      * sanitise_mte_tags for more details.
> > -      */
> > -     if (vma->vm_flags & VM_SHARED)
> > -             return false;
> > -
> >       return vma->vm_flags & VM_MTE_ALLOWED;
> >  }
> >
>
> Can you provide a pointer to some VMM making use of this functionality
> and enabling MTE? A set of crosvm patches (for example) would be
> useful to evaluate this series.

Hi Marc,

I've been using a modified crosvm to test this series. Please find
below a link to the proposed crosvm patches which make use of the
series:
https://chromium-review.googlesource.com/c/crosvm/crosvm/+/3892141

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
