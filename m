Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBD6C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 11:50:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 567924B1B4;
	Tue, 14 Dec 2021 06:50:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iI4l6PLf7wZs; Tue, 14 Dec 2021 06:50:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5D54B1D0;
	Tue, 14 Dec 2021 06:50:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0A14B1B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:50:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SzOoRcNwLt+3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 06:50:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FC564B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:50:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639482651;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=A+h2CjDECkE7naOqREV8EYRWbl6MLE1bq6FCssGIuZg=;
 b=LT4jmVKMnelV1cMaqq8nFS4AeqLgCMAHcMZI0pCcpsrQnWq5vJY1dz35x+54yVWhJF+X3m
 14jxSy6r5pEPQoi9SSiaB9POqdVIv7gMgImDuNedSeeaLXyqayGFcgyv2WoAyRyfqTu4xI
 C97EWAsOLipQyPKxMKZ1xvatKm4AUGw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-aXgT2K00OvWWYWvOyhaqWg-1; Tue, 14 Dec 2021 06:50:50 -0500
X-MC-Unique: aXgT2K00OvWWYWvOyhaqWg-1
Received: by mail-ed1-f70.google.com with SMTP id
 30-20020a508e5e000000b003f02e458b17so16756438edx.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 03:50:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=A+h2CjDECkE7naOqREV8EYRWbl6MLE1bq6FCssGIuZg=;
 b=r3nZe+N2AoqnrxWVxkgF6wgg/I5VdmIrzpZxcosufGe6T9eb4/EpiPx7IzN2cTIPgQ
 WeNB27lO5zjhML2lwQxdUztv+zKjBCsb6HZCcDx8N3F/XV3CrV34ZqtjRS5wDtZedi67
 7hnGNDuGSCgvYSODz1RBx2WLpkLxVGJX292qk4jK/YQaabkaolurGE9tHRj2wrOJjKTR
 Tegah+yyuvK3VbkkjosSggEdOKwgea/3CRKNH6TINQYN5GAE+8LWUN7/9+tCeHDtjz3a
 EzymRj1w2RyHPyhV0yyb9uC8Tv5D1izYeB7H2BI4CCTEJJMp2La5TYRoqx5S70Xf7cOW
 VZpA==
X-Gm-Message-State: AOAM531cAPXGLfXRqjxki/5OHgtTIAPIytN3apFhRiXsxm0VlXI7VhBp
 aCF9ckKmkOxKwnHfaoFESUTjeEWofwCYQhlfOW9X6kH2Gom8kzSGK5uSzJTMfGS7lDUHaMP5SwC
 ENGNIAixQUib/symonMZq2ac/
X-Received: by 2002:a05:6402:1d48:: with SMTP id
 dz8mr7262775edb.100.1639482648918; 
 Tue, 14 Dec 2021 03:50:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZwIm/I/NvC/GwFaVhvRl7q3rFDG7lL9ZjxXc1WAqWSefkTSYHH9dQu7NOGOLLyFjNvzKAwg==
X-Received: by 2002:a05:6402:1d48:: with SMTP id
 dz8mr7262761edb.100.1639482648779; 
 Tue, 14 Dec 2021 03:50:48 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id k21sm7507968edo.87.2021.12.14.03.50.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Dec 2021 03:50:48 -0800 (PST)
Date: Tue, 14 Dec 2021 12:50:46 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Message-ID: <20211214115046.kpiboz7uzgymdoci@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 christoffer.dall@arm.com, qemu-arm@nongnu.org, pbonzini@redhat.com,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Dec 02, 2021 at 11:53:43AM +0000, Alex Benn=E9e wrote:
> Hi,
> =

> Not a great deal has changed from the last posting although I have
> dropped the additional unittests.cfg in favour of setting "nodefault"
> for the tests. Otherwise the clean-ups are mainly textual (removing
> printfs, random newlines and cleaning up comments). As usual the
> details are in the commits bellow the ---.
> =

> I've also tweaked .git/config so get_maintainer.pl should ensure
> direct delivery of the patches ;-)
> =

> Alex Benn=E9e (9):
>   docs: mention checkpatch in the README
>   arm/flat.lds: don't drop debug during link

>   arm/run: use separate --accel form

I queued these three to arm/queue[1].

>   Makefile: add GNU global tags support

Haven't queued this yet since I think we need .gitignore changes.

>   lib: add isaac prng library from CCAN
>   arm/tlbflush-code: TLB flush during code execution
>   arm/locking-tests: add comprehensive locking test
>   arm/barrier-litmus-tests: add simple mp and sal litmus tests
>   arm/tcg-test: some basic TCG exercising tests

These I've queued to arm/mttcg[2] with a slight change of dropping the
'mttcg' group name from any tests that can also run under kvm and
renaming mttcg to to tcg for the tests that require tcg.

I haven't pushed everything to arm/queue yet since I'm not yet sure
I like all the nodefault tests showing up in the logs, even though that
was my suggestion... I need to play with it some more.

Thanks,
drew

[1] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
[2] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/mttcg

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
