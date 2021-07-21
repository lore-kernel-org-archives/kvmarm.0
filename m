Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D87FC07E9B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 07:35:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8DED96113C
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 07:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DED96113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F39204B126;
	Wed, 21 Jul 2021 03:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0x2tpEqf8dyG; Wed, 21 Jul 2021 03:35:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB964B116;
	Wed, 21 Jul 2021 03:35:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 022D34B101
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 03:35:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mi0MwPrc3Tl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 03:35:03 -0400 (EDT)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44C240CF8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 03:35:03 -0400 (EDT)
Received: by mail-ot1-f48.google.com with SMTP id
 f12-20020a056830204cb029048bcf4c6bd9so1250612otp.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 00:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8+C3yWM1Aq25AnToXYe0OxrL1vCuAWOUW+a14IQfShM=;
 b=vtaMs7dhTXsjys2mWi5QB8shnliH3LrkB6s1LGUXdyJanimPJRQ7SUjC2I/vqoWGxY
 k3hviiV60qay40DJOSTvONJWAx1+PKwC0nu+4ZtW6HdXRuNwvO9S+1I39Qj8gQzE6zuV
 gLJk5Tic/HuzwEa1ubkMIUQbEjzfZ7tmpxdwFF4d8tzcMd1JVE7BQGvIdIeDsU37/ami
 IVklHeTuWAMtlrhMuic3GFQOWBFipA+CJt38rkdbMAR/Ls955ATKzwoU+dpMyed22fA1
 y9ltCCmdh96NJRIpZlLXDrqVg0gP5ycxewWFVVblNPyYrPYJZ4F/rqky9ww5tsY3Agti
 YaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8+C3yWM1Aq25AnToXYe0OxrL1vCuAWOUW+a14IQfShM=;
 b=gdWRGzQeLF3HHFxY9EM6RvvtisKoPp8iHjGl+B+lx1AAQqSkQ2KarLdNp5KGTii1gC
 fs8iJlUFAYG0df2HolOR83xRbhrjsKWPPj0i1heS1f5z5R74mSp1Y7JhoMZ2zr3pCl2s
 QkiSbNEgqItmn64qqsXCAbZwityPfU4mysKoQ99/3g0FFrHtBx0wVgV2cDJMnjqgPqc8
 lj+LEmhzlzyBvhAV3yvCmih/s9dFPC3NE5NlLdyAm8RWzU4dvaqNZJOLkcqVl+Hy7QPc
 iAJVVph0WimwYYzmpPhrzAH8BAyRjC/xiyRD6dIV4rP98rX9SQBt6V2+AHwuRDzRIT0T
 kZVQ==
X-Gm-Message-State: AOAM533GXHWSLoDGgRLGqaDq1zuWoflA8CQv56io2LQWAA3fqtkjeQMb
 vB2E6Kxdgj6scy4IS4Hf/Y/JmWYZm7SPi3U71VYCFA==
X-Google-Smtp-Source: ABdhPJxWS4P3/legZ/TlwXxppTSSemQXnWnvlkkGMpTD3obhtSOJNiFjn6I7+UP0SEsIAcukDCsLe6vdUfva3QrxYkQ=
X-Received: by 2002:a05:6830:1455:: with SMTP id
 w21mr25226545otp.365.1626852902894; 
 Wed, 21 Jul 2021 00:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-9-qperret@google.com>
 <CA+EHjTwmmV6EooG+Ykbso3G6nkjq=sbRzXH3vetazzPF5mO02g@mail.gmail.com>
 <YPbYdtRx6dMH52oO@google.com>
In-Reply-To: <YPbYdtRx6dMH52oO@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jul 2021 08:34:26 +0100
Message-ID: <CA+EHjTw4ZKCGUWz99c-Ui_e5yGWS2eh_f-85RaZpFeZKgy8D9Q@mail.gmail.com>
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


On Tue, Jul 20, 2021 at 3:06 PM Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 20 Jul 2021 at 14:48:09 (+0100), Fuad Tabba wrote:
> > This might tie in to Marc's comments for using enums, but
> > consolidating the translation between prot and ignored/software bits
> > in one place would be good: thinking about patch 10 as well, where you
> > get the prot from the ignored bits. Even though you have documented
> > it, I'm finding the part where a field can be borrowed and shared as
> > opposed to being only shared not very intuitive, and I need to reread
> > the comment here to remember the difference while going through the
> > code.
> >
> > You also mention lending as potentially reserved for the future, but I
> > think that lending is the other side of borrowing (depends on who's
> > doing the giving/taking). I wonder if in this case it would be clearer
> > to describe it in terms of whether it's exclusively owned vs owned but
> > shared (for the owner), and just shared for the sharer...
>
> Argh so I actually found the encoding pretty neat :/
> The idea is the following:
>
>   - an entity that has a page mapped as SHARED in its PT means it
>     doesn't have exclusive access to the page;
>
>   - an entity that has a page mapped as BORROWED in its PT means it has
>     access to a page it doesn't own;
>
> From that we can build the states we need:
>
>   - when an entity shares a page with another, the original owner gets a
>     SHARED mapping, and the recipient a SHARED+BORROWED mapping.
>
>   - and in the future when/if we implement lending (which means an
>     entity gives exclusive access to a page to another entity, but
>     retains ownership) we can map the page in the recipient as
>     'BORROWED' only, but not 'SHARED'. And the original owner will have
>     an invalid mapping with a new state 'LENT', which is encoded with
>     both SW bits set.
>
> How does that sound? Did you have something else in mind?

The encoding is very neat by the way :D

I see where you're going with the lent state now, and I understand the
states as well as the possible transitions now that you've explained
it.

It's the terminology that confused me a bit (especially when you
mention lending, which seemed to imply is something distinct from
borrowing as opposed to just the other side of it). What for me would
help is to document this, and the possible combinations/legal states.
kvm_pgtable.h describes the prots a bit, but maybe you could expand
that similar to what you've done in this email:

@KVM_PGTABLE_STATE_BORROWED: Page borrowed from another entity: has
access to the page but no ownership

Not sure if defining aliases for all legal combinations would also
help or add to the confusion, thinking out loud, something along the
lines of cache state taxonomy (e.g., Sweazy and Smith fig 3 [1]). You
have that in the borrowed (as opposed to owned), and shared (as
opposed to exclusive). So aliases to build on these:

#define KVM_PGTABLE_STATE_BORROWED_SHARED (KVM_PGTABLE_STATE_SHARED |
KVM_PGTABLE_STATE_BORROWED)
#define KVM_PGTABLE_STATE_BORROWED_EXCLUSIVE (KVM_PGTABLE_STATE_BORROWED)
#define KVM_PGTABLE_STATE_OWNED_SHARED (KVM_PGTABLE_STATE_SHARED)
#define KVM_PGTABLE_STATE_OWNED_EXCLUSIVE (0ULL)

You have thought about this way more than I have. But I think that
having clear documentation, ideally in the code itself via
helpers/enums/aliases could help people like me who come to the code
later not shoot themselves in the foot.

Thanks!
/fuad

[1] https://www.cs.auckland.ac.nz/compsci703s1c/archive/2008/resources/Sweazey.pdf

> Thanks,
> Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
