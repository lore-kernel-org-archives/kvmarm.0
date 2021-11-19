Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC44C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 18:31:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25A2361B44
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 18:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25A2361B44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 913D04B108;
	Fri, 19 Nov 2021 13:31:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gy5zP-w-JA4l; Fri, 19 Nov 2021 13:31:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 421BA4B0E1;
	Fri, 19 Nov 2021 13:31:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4F94B0C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 13:31:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xq3kAMw5-pk1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 13:31:07 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B304064F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 13:31:07 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637346667;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=U64RY7OU2Xju+JsoSQCaxT3xKU3oSuMc1u+Un65V0zY=;
 b=Vmnak2UghSzmiTeMiuGxWv9ulI4c6AdFCz8/GowKiUghP9uLd7SMseGr51uVcINnPB6XI+
 BTmSF70mRgDkqnOTvIqCec3cMtEdBXiTcLSe+Yep1ISN1HRB4L3AZiF8Ckzx9h7oSTbKWs
 hK5cF7CUaEfckoolP43DS7JGiCm33tA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-WhHBgtDpOGOjt5BJvA_5Dg-1; Fri, 19 Nov 2021 13:31:02 -0500
X-MC-Unique: WhHBgtDpOGOjt5BJvA_5Dg-1
Received: by mail-ed1-f72.google.com with SMTP id
 k7-20020aa7c387000000b003e7ed87fb31so9239136edq.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 10:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=U64RY7OU2Xju+JsoSQCaxT3xKU3oSuMc1u+Un65V0zY=;
 b=o2pzLlVnrAuMZi00gRq3U/LYz+6+8EeUEYDdTuhvp5INLpk5JnXAzs9Cs8eui0PELa
 gAXN4IR5PshTrGtMYLrF73SLu9ZhykisAO2GK9GqVHgavJLY7G6Js22AMf9/VAcoec8A
 d0q09OfkYpc2LA/lQotW8+2F4HSCPJG1kpyJsn3QNWQ5ZbAz0Ro2LGm03XNgwJ8uVFkM
 tflq9RPoTLLcNX73gAdR/rNxBoXbVjLvLtI9SYhkb8xsrgqdyG6YpoSreLD5nWxijQ83
 rc38+g8nqXdwxxG4B0P6sDy0Jup0d4+j5rIrm6FaJm7upZ5IvWBWHifpbcGL28cDU/Uf
 XAKw==
X-Gm-Message-State: AOAM531nkwjFn893yWR560yD+GQLLA4UY/6SrP3IyaulpXuQhPhrjVmA
 4K/SEpkP6LvU4q8hkzc+Tj3LfsDyCP06uBiRVBDWAg5vxcOJVa+8XpXhWP6JN5gEfME6nZAfHfu
 9yhcanTnsTwljC3Bq0CO9jBTn
X-Received: by 2002:a17:907:980e:: with SMTP id
 ji14mr10567045ejc.346.1637346661501; 
 Fri, 19 Nov 2021 10:31:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysizuNz29kxmyK5Y1pJmiEUFOOyuHyVXO5SYZcYalJ0raRF2y2AltBq/8bujU2pPYgEOHbiA==
X-Received: by 2002:a17:907:980e:: with SMTP id
 ji14mr10567009ejc.346.1637346661324; 
 Fri, 19 Nov 2021 10:31:01 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id qf9sm301194ejc.18.2021.11.19.10.31.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 10:31:00 -0800 (PST)
Date: Fri, 19 Nov 2021 19:30:59 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211119183059.jwrhb77jfjbv5rbz@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
 <877dd4umy6.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <877dd4umy6.fsf@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Nov 19, 2021 at 04:30:47PM +0000, Alex Benn=E9e wrote:
> =

> Andrew Jones <drjones@redhat.com> writes:
> =

> > On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Benn=E9e wrote:
> >> =

> >> Andrew Jones <drjones@redhat.com> writes:
> >> =

> >> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=E9e wrote:
> >> >> Hi,
> >> >> =

> >> >> Sorry this has been sitting in my tree so long. The changes are fai=
rly
> >> >> minor from v2. I no longer split the tests up into TCG and KVM
> >> >> versions and instead just ensure that ERRATA_FORCE is always set wh=
en
> >> >> run under TCG.
> >> >> =

> >> >> Alex Benn=E9e (3):
> >> >>   arm64: remove invalid check from its-trigger test
> >> >>   arm64: enable its-migration tests for TCG
> >> >>   arch-run: do not process ERRATA when running under TCG
> >> >> =

> >> >>  scripts/arch-run.bash |  4 +++-
> >> >>  arm/gic.c             | 16 ++++++----------
> >> >>  arm/unittests.cfg     |  3 ---
> >> >>  3 files changed, 9 insertions(+), 14 deletions(-)
> >> >> =

> >> >> -- =

> >> >> 2.30.2
> >> >> =

> >> >> _______________________________________________
> >> >> kvmarm mailing list
> >> >> kvmarm@lists.cs.columbia.edu
> >> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >> >
> >> > Hi Alex,
> >> >
> >> > Thanks for this. I've applied to arm/queue, but I see that
> >> >
> >> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI =
is received
> >> >
> >> > consistently fails for me. Is that expected? Does it work for you?
> >> =

> >> doh - looks like I cocked up the merge conflict...
> >> =

> >> Did it fail for TCG or for KVM (or both)?
> >
> > Just TCG, which was why I was wondering if it was expected. I've never =
run
> > these tests with TCG before.
> =

> Hmm I think expecting the IRQ at all is broken so I think I should
> delete the whole pending test.

Feel free to repost. I'll update the patches in arm/queue before my next
MR.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
