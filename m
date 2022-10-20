Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDBCC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 19:51:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247B14B644;
	Thu, 20 Oct 2022 15:51:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1AsMCA2VaX9l; Thu, 20 Oct 2022 15:51:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1523F4B93E;
	Thu, 20 Oct 2022 15:51:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F09C4B644
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuN-mtNOFnq9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 15:51:14 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40B494B640
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 15:51:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8624C61CF2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 19:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1683C43140
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 19:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666295472;
 bh=A9VoRgR6bzi4c4yYMEbN8DyaGqa9LNIhOqN8jYUfKqA=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=gYb7DLPLyl8l88Vt/X7GycrZ/0/jleWydToJueFcqG/h1sKYtlMrtmvCWl8u4ywuJ
 rd64jyUJuHEtS+jOoczJrViqo52qY83pp0tdpN1UCTXc/4rnGFhCrKWBeLbmaY7Kxu
 kkzmJ44fLv8agouTqQE6dvSfJFkdXb9yZepZoQ4iQNj2vERQU74oKqCF6mOHWRZDIz
 wozR37fA26tIy1yUv4IxuYgpsfYwqMs0r4O/D+ccY0KFGK6iisC3obB28+sDK5NlGr
 9utJTjp2iJnDZjPTFPIairX4Os9ZQ1eNhOHZiQ2V87lQfo46VIER77Z3iSRxMHE1Gb
 YYeCum9JptQPw==
Received: by mail-vk1-f170.google.com with SMTP id y129so357707vkg.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 12:51:12 -0700 (PDT)
X-Gm-Message-State: ACrzQf3rCgoFpHmPkEKKreS2pFA9nvTXn+2OtFHf1lu/uwYM+TUiyfnn
 WsD6b9lg1O2IVyI9AzHJB90BHJeXyWn7GVKyrg==
X-Google-Smtp-Source: AMsMyM7u7wV871a7sMf6cDm8Cp2SxQcmq+IVFFx8ESqkntMYR2zBJYwu6TxtcDkd2XcyxAgHl8fZrJU2s7ju9Elrgj0=
X-Received: by 2002:a1f:3d4c:0:b0:3aa:feb8:3ec6 with SMTP id
 k73-20020a1f3d4c000000b003aafeb83ec6mr8414254vka.26.1666295471867; Thu, 20
 Oct 2022 12:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220825-arm-spe-v8-7-v2-0-e37322d68ac0@kernel.org>
 <20220825-arm-spe-v8-7-v2-3-e37322d68ac0@kernel.org>
 <Y1FcRNhFpZxZ7AMx@sirena.org.uk>
In-Reply-To: <Y1FcRNhFpZxZ7AMx@sirena.org.uk>
From: Rob Herring <robh@kernel.org>
Date: Thu, 20 Oct 2022 14:51:02 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
Message-ID: <CAL_JsqLVjWH-x3jxGQpJ3ax_ddvBqHd-P2DE=DEnrknoHuq+Qg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] arm64/sysreg: Convert SPE registers to automatic
 generation
To: Mark Brown <broonie@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
 Namhyung Kim <namhyung@kernel.org>, Will Deacon <will@kernel.org>,
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

On Thu, Oct 20, 2022 at 9:33 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Oct 19, 2022 at 02:11:26PM -0500, Rob Herring wrote:
> > Convert all the SPE register defines to automatic generation. No
> > functional changes.
> >
> > New registers and fields for SPEv1.2 are added with the conversion.
> >
> > Some of the PMBSR MSS field defines are kept as the automatic generation
> > has no way to create multiple names for the same register bits. The
> > meaning of the MSS field depends on other bits.
>
> A few small things below from checking against DDI0487I.a, nothing
> major:

[...]

> > +Sysreg       PMSIDR_EL1      3       0       9       9       7
>
> > +Field        23:20   FORMAT
> > +Field        19:16   COUNTSIZE
> > +Field        15:12   MAXSIZE
> > +Field        11:8    INTERVAL
>
> These should really be enums.

Okay for COUNTSIZE and INTERVAL.

The only defined value for FORMAT is 'Format 0'. I assume next will be
'Format 1'. I don't think defines with the value in the name are too
useful. When this is used, we'll just be passing the value to
userspace via either sysfs or perf aux buffer.

MAXSIZE is the power of 2 encoded size and we just convert to bytes
(1<<MAXSIZE). So I can add them, but they will never be used.

> > +Sysreg       PMBLIMITR_EL1   3       0       9       10      0
> > +Enum 2:1     FM
> > +     0b0000  STOP_IRQ
> > +EndEnum
>
> DDI0487I.a also defines
>
>         0b01    DISCARD

STOP_IRQ doesn't seem like the best name either. It's not used, so I
changed it to 'FILL'.

> > +Sysreg       PMBIDR_EL1      3       0       9       10      7
> > +Res0 63:12
> > +Field        11:8    EA
>
> This looks like it should be described as an enum.

    0b0000    Not_Described
    0b0001    Ignored
    0b0010    SError

What's the preferred case here?

>
> > +Field        3:0     ALIGN
>
> This could potentially also be an enum.

Another power of 2 encoding.

> > +Sysreg       PMSCR_EL2       3       4       9       9       0
> > +Res0 63:8
> > +Field        7:6     PCT
>
> This lookslike it should be an enum.

Humm, PCT is a bit tricky. Here's what I came up with:

Enum    7:6    PCT
    0b00    VIRT
    0b01    PHYS
    0b11    GUEST
EndEnum

Again, CAPS or CarrotCase for new things?

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
