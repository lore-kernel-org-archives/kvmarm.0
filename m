Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240B8C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 11:54:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0B214B116;
	Tue, 14 Dec 2021 06:54:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dEDrb-dl4ERu; Tue, 14 Dec 2021 06:54:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C10BF4B18F;
	Tue, 14 Dec 2021 06:54:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E7D4B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:54:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6gieak1YC+Gu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 06:54:12 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1534B116
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:54:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639482852;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vFWy//LIJxob/lWiTb+7jlaVoy7eDwB1D/1wX1Vb67M=;
 b=IvthaIQiYWJoGgNwcPqhI7m41bigMc5fBUMqhTfXnqcJiFb/QWrJnYQPNuMNFA/Nsynr+f
 uQw/mwJNSpGW8/E/beND7bsazLv4zK5W0nQ9DOFA1OPly+KKwo1fFPqzgIV04e0IDTmkqW
 4Q1tYsaMYU5s55wVNoAinmduPXfrK6o=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-z0e83HFKOo-jGQGy1PXGvw-1; Tue, 14 Dec 2021 06:54:08 -0500
X-MC-Unique: z0e83HFKOo-jGQGy1PXGvw-1
Received: by mail-ed1-f71.google.com with SMTP id
 q17-20020aa7da91000000b003e7c0641b9cso16757894eds.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 03:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=vFWy//LIJxob/lWiTb+7jlaVoy7eDwB1D/1wX1Vb67M=;
 b=sp+tWJ8eDhuRMIXtU9iPl6MsbzjYLoreI0hSEray0zM8sQm89edZ6C/OmIfcic74D0
 MFUhmo/6UPFRmi6EJYMnYxmXw3FVvAik/JMua9gy0VNR4NcCauCrJEaZdN/Tw2uUrOku
 Dl3aAZfTqwu5gZgppPGajjzST8a3KeCpIgt/96BNQaXUX9L11jcHZ1/8AZ+sdfhrf7sW
 0Fg5WOhhj0uhgyTbxWg9js4Cil0rnD+MG7TgiN24Pn7/BkupvGO3dO6t+oURN6YN3qS3
 v0k95pWpvWXJ1RwbrNnH2B8tWORpNnQFQ1+/HmwwUa/GrnUebl4TWsOJZV5Q3qk28Lqz
 LCrQ==
X-Gm-Message-State: AOAM533GQ6SMd+elXV0DbPXYPZb5hhcE/WY8xlBNGpJwXvwefXxWY3by
 plsGL6Kvg5yadQEwvMXh+cN0A6L7iGVKQxI1xJXLDgmsvU2jCX+BQ2x755Y/LFj38DcLAos+Swg
 jdU98MXRVW10ZG5R0bJuDSbEe
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr7389227edt.402.1639482847852; 
 Tue, 14 Dec 2021 03:54:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLM06eEkb8R3hqpzcN6AfgAcpZ997bUu2u6dHgiRyTJ9K7eZkp9IDJ4EfaILuqE4kwYGoHuQ==
X-Received: by 2002:aa7:cb48:: with SMTP id w8mr7389206edt.402.1639482847698; 
 Tue, 14 Dec 2021 03:54:07 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id t5sm7728720edd.68.2021.12.14.03.54.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Dec 2021 03:54:07 -0800 (PST)
Date: Tue, 14 Dec 2021 12:54:05 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v9 0/9] MTTCG sanity tests for ARM
Message-ID: <20211214115405.wt4gazkqsvmhqv6w@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211214115046.kpiboz7uzgymdoci@gator.home>
MIME-Version: 1.0
In-Reply-To: <20211214115046.kpiboz7uzgymdoci@gator.home>
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

On Tue, Dec 14, 2021 at 12:50:46PM +0100, Andrew Jones wrote:
> On Thu, Dec 02, 2021 at 11:53:43AM +0000, Alex Benn=E9e wrote:
> > Hi,
> > =

> > Not a great deal has changed from the last posting although I have
> > dropped the additional unittests.cfg in favour of setting "nodefault"
> > for the tests. Otherwise the clean-ups are mainly textual (removing
> > printfs, random newlines and cleaning up comments). As usual the
> > details are in the commits bellow the ---.
> > =

> > I've also tweaked .git/config so get_maintainer.pl should ensure
> > direct delivery of the patches ;-)
> > =

> > Alex Benn=E9e (9):
> >   docs: mention checkpatch in the README
> >   arm/flat.lds: don't drop debug during link
> =

> >   arm/run: use separate --accel form
> =

> I queued these three to arm/queue[1].
> =

> >   Makefile: add GNU global tags support
> =

> Haven't queued this yet since I think we need .gitignore changes.
> =

> >   lib: add isaac prng library from CCAN
> >   arm/tlbflush-code: TLB flush during code execution
> >   arm/locking-tests: add comprehensive locking test
> >   arm/barrier-litmus-tests: add simple mp and sal litmus tests
> >   arm/tcg-test: some basic TCG exercising tests
> =

> These I've queued to arm/mttcg[2] with a slight change of dropping the
> 'mttcg' group name from any tests that can also run under kvm and
> renaming mttcg to to tcg for the tests that require tcg.

Hmm. I also just noticed that we should rename these tests to something
without the ::  The :: works with standalone, but it isn't all that nice
of a unix file name.

Thanks,
drew

> =

> I haven't pushed everything to arm/queue yet since I'm not yet sure
> I like all the nodefault tests showing up in the logs, even though that
> was my suggestion... I need to play with it some more.
> =

> Thanks,
> drew
> =

> [1] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> [2] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/mttcg

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
