Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E21C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:54:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A67F6108B
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A67F6108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E138F4B2E0;
	Fri, 12 Nov 2021 09:54:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oO+EsncxJNCI; Fri, 12 Nov 2021 09:54:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B854B2DE;
	Fri, 12 Nov 2021 09:54:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA6F4B2DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:54:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1k1QwEkTdBe7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 09:54:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C94C54B2B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:54:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636728888;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CqpS1HH0zhDySu1JBKv5pA0ucN4UqNVJlGatSL7MT0A=;
 b=FpBWA2S9wgAnV57bthshN9gjFxgCvLGa7HK9LkCOvBENpbZFNrq2m2RFDEx/t6S59QGgQT
 RZ24pkoZ9VfecoDUnTy4ZA8ZMZXZHKObEe6xMspZBLPKkY9T3GvnhYvbDgcWFpoVcjfk9K
 KuC/xhpL5kkAzq7O7hCjFjucnkTQe2k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-S9g7wxKWNfKj6BMJY94qlA-1; Fri, 12 Nov 2021 09:54:46 -0500
X-MC-Unique: S9g7wxKWNfKj6BMJY94qlA-1
Received: by mail-ed1-f69.google.com with SMTP id
 g3-20020a056402424300b003e2981e1edbso8516990edb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=CqpS1HH0zhDySu1JBKv5pA0ucN4UqNVJlGatSL7MT0A=;
 b=cd3fZwAr9RI0cIbldCbd25waqOX8FYNzNSjgR3N+nuESfQFHv0bFaydZv08MOIyP6U
 fERJvBzxifbAnt/zTcC/L7z3Y5cfWo7ReuuzGtcahCMUl8o/bHS8Bk+rs1IgKQS+mAdv
 jgi+D9TCb9rfuJtjtuwVRXy66N9HBIlpoz8dutXT0phHzUvslNEsSYsVQxROomsdshRi
 GGTGulGIJU47Qt0FjxYhZoKqwzHGP/oNEyp40FfkDDzrz21Ho4OokW9G1qrJpCQ8XWjC
 748SnSEb12Aw5zGF8UYRteM1WUFtHoN2IqEhhVOCdR6Ah0cTcHMRVpxo8GroZie5TijL
 DCxA==
X-Gm-Message-State: AOAM530A6b5EnXxmAWNnBVqmgUX/hyEjxgodORBnLOf+C1Uby8MBZCXt
 JVtyek2aMDxRbK3m7U9RXWOP/amjszrJQETPdkfkhNh+tO7AFdEyWWyvtRshEGPVCemxSVWsL63
 vwILzGIgjOB0zI26ZQjronSQ7
X-Received: by 2002:a50:e089:: with SMTP id f9mr22475519edl.290.1636728885138; 
 Fri, 12 Nov 2021 06:54:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5xCNQMS07DiZTiT4vSSKrzHxuhlKtuaSkvfESoFy0jlnHf/ZLWzbRuwGNBUwiLuFzccR8+g==
X-Received: by 2002:a50:e089:: with SMTP id f9mr22475491edl.290.1636728884981; 
 Fri, 12 Nov 2021 06:54:44 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id mc3sm2769954ejb.24.2021.11.12.06.54.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 06:54:43 -0800 (PST)
Date: Fri, 12 Nov 2021 15:54:42 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211112145442.5ktlpwyolwdsxlnx@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87wnldfoul.fsf@linaro.org>
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

On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Benn=E9e wrote:
> =

> Andrew Jones <drjones@redhat.com> writes:
> =

> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=E9e wrote:
> >> Hi,
> >> =

> >> Sorry this has been sitting in my tree so long. The changes are fairly
> >> minor from v2. I no longer split the tests up into TCG and KVM
> >> versions and instead just ensure that ERRATA_FORCE is always set when
> >> run under TCG.
> >> =

> >> Alex Benn=E9e (3):
> >>   arm64: remove invalid check from its-trigger test
> >>   arm64: enable its-migration tests for TCG
> >>   arch-run: do not process ERRATA when running under TCG
> >> =

> >>  scripts/arch-run.bash |  4 +++-
> >>  arm/gic.c             | 16 ++++++----------
> >>  arm/unittests.cfg     |  3 ---
> >>  3 files changed, 9 insertions(+), 14 deletions(-)
> >> =

> >> -- =

> >> 2.30.2
> >> =

> >> _______________________________________________
> >> kvmarm mailing list
> >> kvmarm@lists.cs.columbia.edu
> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
> > Hi Alex,
> >
> > Thanks for this. I've applied to arm/queue, but I see that
> >
> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is =
received
> >
> > consistently fails for me. Is that expected? Does it work for you?
> =

> doh - looks like I cocked up the merge conflict...
> =

> Did it fail for TCG or for KVM (or both)?

Just TCG, which was why I was wondering if it was expected. I've never run
these tests with TCG before.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
