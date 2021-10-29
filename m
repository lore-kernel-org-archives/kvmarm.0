Return-Path: <SRS0=gNwE=PR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3261C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 18:18:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B1F061040
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 18:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B1F061040
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8CB94B08D;
	Fri, 29 Oct 2021 14:18:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J8aQ2o3Ylmng; Fri, 29 Oct 2021 14:18:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD7AA4B149;
	Fri, 29 Oct 2021 14:18:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86BC4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Oct 2021 14:18:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QFf61z4QMzXX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Oct 2021 14:18:28 -0400 (EDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com
 [209.85.208.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC2784B08D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Oct 2021 14:18:27 -0400 (EDT)
Received: by mail-lj1-f179.google.com with SMTP id 188so18233134ljj.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Oct 2021 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6gzqVRL5S6+afpMyNODH0pBpVAT9PrZbeLsch+p0Irs=;
 b=tGz+64nOHnWsxk51dfc06pYJyhw9jonhHrQdFBodgY5y5sesT8bA8ktgmSBugp+3Je
 FzZDdezUG1/Jeq3xf5CiQrNyVymLY416TUqBoP548TlAKopBWSaAzkjP024cOrvd+OUL
 CWV3ga0R0bj2W2/REDcE7KL+gJ+IJER0KwaRXFnO4MZS0lT5ozuJU+dT3b4k/n7vS+1h
 AUF6HL5lxYlDmvqaPUePlgp9FtD51CuXXhHpyCANZwkPjrNhe0lyIEECqEhiuCrpcW7I
 xcWGXGSIxic4UqkUeU5UDXcSDjXtq0rh0lQoq4hlpiDn4qaty2wTflNUkZTLli3josc+
 zJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6gzqVRL5S6+afpMyNODH0pBpVAT9PrZbeLsch+p0Irs=;
 b=ThJJv29QlWbvCRWmjxeO+aeDF/Lq1d/PnbD2r67HojvVwOZBrNq//oJ/N0WA/w2mzT
 ffJQTZeebbmHFs0STLOMuy5ssMx3OpxqcQko37vXQ8REZ7tvEFwDw8ilWd0SXESdh2cI
 N0xQzJA+eg402rkSNY2KDQPIvaXWyC9yhGe77dDK/8K1aLCpQRapfoHuQsasr/imsOC4
 5ixojafUB+Zw5/SRcgF4mDd2AZBcJcPsFYc5hIeeu/q553FenP08G1/zzh9T48pCcgRi
 P7klV0Te3cjrvt133BEGNEq1dHTwojRJcdvULzpBtoDOjO8clOJaLsXBVzwDIWlnWFmw
 sslA==
X-Gm-Message-State: AOAM5318eY8YPhTentEkqCHuI4SqaMMQAHxf37Ojau7reltholBmTy1c
 pSAQFjUl1I59OgdHTdU+42KoB6vDL54iqJZ6JJ/fWw==
X-Google-Smtp-Source: ABdhPJwuuUqHsGAxudNHy1pXSqXpNJwQ0mQILNxJN/3XPiTCFRDAfELtLMvtP273AM4utb+UT0qen6DLY3ZL1rAG6JA=
X-Received: by 2002:a05:651c:1051:: with SMTP id
 x17mr10679682ljm.337.1635531506374; 
 Fri, 29 Oct 2021 11:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211029003202.158161-1-oupton@google.com>
 <20211029003202.158161-4-oupton@google.com>
 <87k0hw9iez.wl-maz@kernel.org>
In-Reply-To: <87k0hw9iez.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Fri, 29 Oct 2021 11:18:13 -0700
Message-ID: <CAOQ_QshjMXMFK2uHVDxYbFkVJApGxhT4M4NbMNY+qX3QvPe5_A@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Raise KVM's reported debug architecture
 to v8.2
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

Hey Marc,

On Fri, Oct 29, 2021 at 4:31 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 29 Oct 2021 01:32:02 +0100,
> Oliver Upton <oupton@google.com> wrote:
[...]
> >       case SYS_ID_AA64DFR0_EL1:
> > -             /* Limit debug to ARMv8.0 */
> > +             /* Limit debug to ARMv8.2 */
> >               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
> > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 8);
> > +
> > +             /* Hide DoubleLock from guests */
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK);
> > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), 0CF);
> > +
>
> One issue with that is that this will break migration from an older
> kernel (DFR0 will be different between source and destination).
>
> You'll need a set_user handler and deal with it in a similar way to
> CSV2/CSV3.

Yeah, definitely so. In that case, unless we're strongly motivated to
expose these changes soon, I'll just punt the ID register changes
until Reiji's series [1] lands, as anything I add for a writable DFR0
will invariably be scrapped in favor of his work.

I'll post v2 of this series folding in your feedback (thx for quick
review, btw), less this patch.

[1] https://patchwork.kernel.org/project/kvm/cover/20211012043535.500493-1-reijiw@google.com/

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
