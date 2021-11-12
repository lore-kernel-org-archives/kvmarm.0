Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB174C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 13:23:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51A7861073
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 13:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 51A7861073
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B910A4B291;
	Fri, 12 Nov 2021 08:23:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qtpev+Bkb-ik; Fri, 12 Nov 2021 08:23:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66F134B297;
	Fri, 12 Nov 2021 08:23:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5A44B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 08:23:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdljuZQGpXLV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 08:23:19 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA7484B289
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 08:23:19 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636723399;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dyKHXIHlcMfQZRfkXKprwqg9ZzcuoNJyRdE1idLkbvo=;
 b=HR/XLVXT7EoDvSnSaIeg9IoHZJyK/2dtVCACjYkM6z2fBmJnci0yrgEXk2zwpZXtzZCY9R
 oPAH7oAM/KRlRWaCSrUtsFlmT3PMVO4vt5mXmE710c5VlJNAToN1hpNNHaVD1g4s5mJDwA
 znJOeybY3hEwfxQ/Mwpu7R6dZWJsI8k=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-9ClMUefHP--g5EhTfrtLUw-1; Fri, 12 Nov 2021 08:23:16 -0500
X-MC-Unique: 9ClMUefHP--g5EhTfrtLUw-1
Received: by mail-ed1-f72.google.com with SMTP id
 l15-20020a056402124f00b003e57269ab87so1593267edw.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 05:23:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=dyKHXIHlcMfQZRfkXKprwqg9ZzcuoNJyRdE1idLkbvo=;
 b=L6Ol/35wiCemh33Vl6AAOB4sf4GGpnDcr6fWB4CJZxo6+o1qsQGckI5GDVtmx1c5zB
 HyvZfFPXvojd4p6Yf3lfI57KW53i92Q+bgAfhctWrDfP3AmN0Rb1ApJ4OMH9xmjah5TR
 sQZsjEi6wIeGK6wYRMawfFO8mPPVG2u6VjimkvDWCJtgihQFw5nfMYx28Sb3hubQuIrx
 /57phvvaixNEG394iHZtCoQuBGtRonlDWZO+rIhJQQRBLXTx2FFxSTj3FTQL0vbZMoBf
 2UJK3aVUHdfKYcYsLWxfgjCXJGZJZ1vrQ0RGEILBNkCZh04i8Pq+8y2adh8SP1dBbbiz
 Lvag==
X-Gm-Message-State: AOAM530sfQL7DUAU6djhg5fTh5WLe4mrfv3FwOJsHsdj1P4qUvb3NkPH
 xtyl4lAAJKjrqZX47HV7T5Q/Up6P+vatBfwBah451X0UazS3LVQ/sXy2ze8EZD85sPGFUxS8IRo
 /VP2mC2vw2Pk8PC5DpeIR9QLi
X-Received: by 2002:a17:906:3a48:: with SMTP id
 a8mr19304755ejf.458.1636723395070; 
 Fri, 12 Nov 2021 05:23:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyY8HEfWPjz11A3Q4pU+tqaY6+zBIvvUXtomRkRBGvaA5KiR1eDXqnPaKamaP+yGLtQsTNnLg==
X-Received: by 2002:a17:906:3a48:: with SMTP id
 a8mr19304728ejf.458.1636723394897; 
 Fri, 12 Nov 2021 05:23:14 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id n16sm3041819edv.79.2021.11.12.05.23.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 05:23:14 -0800 (PST)
Date: Fri, 12 Nov 2021 14:23:12 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211112132312.qrgmby55mlenj72p@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211112114734.3058678-1-alex.bennee@linaro.org>
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

On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=E9e wrote:
> Hi,
> =

> Sorry this has been sitting in my tree so long. The changes are fairly
> minor from v2. I no longer split the tests up into TCG and KVM
> versions and instead just ensure that ERRATA_FORCE is always set when
> run under TCG.
> =

> Alex Benn=E9e (3):
>   arm64: remove invalid check from its-trigger test
>   arm64: enable its-migration tests for TCG
>   arch-run: do not process ERRATA when running under TCG
> =

>  scripts/arch-run.bash |  4 +++-
>  arm/gic.c             | 16 ++++++----------
>  arm/unittests.cfg     |  3 ---
>  3 files changed, 9 insertions(+), 14 deletions(-)
> =

> -- =

> 2.30.2
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

Hi Alex,

Thanks for this. I've applied to arm/queue, but I see that

FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending LPI is rece=
ived

consistently fails for me. Is that expected? Does it work for you?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
