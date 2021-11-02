Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB05FC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 23:36:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24679610E8
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 23:36:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24679610E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 983144B12F;
	Tue,  2 Nov 2021 19:36:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lvbGPQH-ojUn; Tue,  2 Nov 2021 19:36:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4DC4B10A;
	Tue,  2 Nov 2021 19:36:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96CA64B0E1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 19:36:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i8ohW97kh1tv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 19:36:41 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBCB24A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 19:36:40 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id y8so841006ljm.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 16:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=r/4nzkJMmTDZyc+V/cANtoDFkLP03MjQWCb296uizWE=;
 b=EY2Tll1U3TfHkFoSrC3QxcZUrqKEgh0CTGkntEj5tJXB3IvJI8sAhdNU/lkq1AzUYP
 eKXOg3mtfiV8K82o62fokLa3FGt5Hgxj0nNyEEgZZTnHgnC9S/JMxfIkrINKeLiBkCw8
 r836PJXY79LkC828AOuoGV7GXvPpviWElvit0u0ldLDczozbsFsHbBb2M4EpElWHi5ac
 mhWzR3mftO2qq/Y3wNnOV8EKdmZm0LhQQFHgjlxBvcT3aL5eig7zBd12jR90vt8L8wGE
 FfY9A86mRssxbd6rVmWAkwkOvJhQ2PA/8UBtUV0986IwNRQHGVQOoV6GoCYR8GXS6b6j
 qKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=r/4nzkJMmTDZyc+V/cANtoDFkLP03MjQWCb296uizWE=;
 b=P2Xo7fCnAxr6WkbLdjDgM28iU142YLGfv1hZlSAqPB0HdLeAHPXPYMLJ+OwKcmXquV
 hE7Ai4yOojouUy98BrZLtMghtcg174eWsdp81l5+2WaULNKdzsOOEsTpyx8BGA8kljFM
 yjcS3e+b9Q2EVZ7ntCh2dSiYvsVarWna9USg4CI5dA+oFTKnbQhv2GwAJjmbGeB02Scc
 UCHcSZXSQn653pmRkN8IdEBCNn9zF8GBtd8WqY+ReM7mZenZ8vedFSoaYmpPwGEE0MZv
 HZ7L3/VGReqno4R+z6nQxUglkAonKqHtMgNWPc5yZc0jVM8wDTDhPBu7PiLdMviHKFh+
 OS3A==
X-Gm-Message-State: AOAM530k9IykgUQb4dvOGlJf+XXFQwR8k4plbFY7MjuG90hlEIm8W116
 fEODdFl5tGXFQAuJ5K6WzqikEpmzNO3aR1C+2JQ4WJRcKYjitw==
X-Google-Smtp-Source: ABdhPJxZUGvKfPYF/m+Ok8JcJBPm4oZEXLpslPHb6Hk5EWAVGzh6JaKGzP67uq52qmjWXNc/OyCMzsMfwQYBoLJMC9o=
X-Received: by 2002:a05:651c:556:: with SMTP id
 q22mr29186105ljp.374.1635896199437; 
 Tue, 02 Nov 2021 16:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-7-oupton@google.com>
 <YYHJWmQ+RmNZ51dM@google.com>
In-Reply-To: <YYHJWmQ+RmNZ51dM@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 2 Nov 2021 16:36:28 -0700
Message-ID: <CAOQ_Qsj-KOGRdSy9yrosDqO+=wpYhmDeVYxWeY7uuRQAyycQ=A@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] selftests: KVM: Test OS lock behavior
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Ricardo,

On Tue, Nov 2, 2021 at 4:27 PM Ricardo Koller <ricarkol@google.com> wrote:
> > +static void enable_os_lock(void)
> > +{
> > +     write_sysreg(oslar_el1, 1);
>
> should be: write_sysreg(val, reg);

Yep, I'll do this once I rebase onto 5.16, as the sysreg rework isn't
available til then.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
