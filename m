Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA673C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 14:34:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 403D04B128;
	Tue, 30 Nov 2021 09:34:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ycxd1Cg0aop2; Tue, 30 Nov 2021 09:34:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC094B14C;
	Tue, 30 Nov 2021 09:34:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8356E4B11C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 09:34:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pxFqEa-bZk3Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 09:34:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46CEF4B108
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 09:34:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638282878;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lUXILyRo006H5l+ZcdqOJwD3xK1tyZFHAK4YXmJdU1Y=;
 b=A/yGFEcAeax/SQmkIq/FR8Gh4EUagWOvMoY1dreAcKi2n74Xr8QB2eXOrT0JehrN2m+2eN
 OTeY36NsXxgzJX7sKa2/6frLHMBctj1u+d/vSk2yTG/gVVkFrgo35xBL6MnRPzh5we43j1
 1chajIT5iCA25JsZDVMevl2zDCsshpU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-qeIz-2BfNzC-4DM89Gd9OQ-1; Tue, 30 Nov 2021 09:34:34 -0500
X-MC-Unique: qeIz-2BfNzC-4DM89Gd9OQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 v22-20020a50a456000000b003e7cbfe3dfeso17090036edb.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 06:34:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=lUXILyRo006H5l+ZcdqOJwD3xK1tyZFHAK4YXmJdU1Y=;
 b=ax6l3SLSbVAaamWH8hVNlui7DeLu3OuX+1FV1QH+TVYAa1UGh7NIS3l1+wv0JNtXFQ
 fH4HOTFVHXOf/u3aBqiRMdD8SvNp05JybLZSpatUhnHDi/fJP1Y7ttexc9oV0dMQSioM
 GmLCuL9rxNRES4r1WiqRQ14tmTO8bpZXjMILnGYzgDI/i9JPlFGHGorhZRfMkDNehUXW
 bgzjRqwfIhNPa73Oyssp4KIHEWAakd/Y273k0dIAqsZlk4OdQZseucAcpyxhUtZtwA8Z
 ctI0UbroS2tf3IpmYVRKH/6ALEZ+uLqiMB6+NmC0dTnOtdbJFtMZ/QHQ7DQxlnMpM87H
 qNig==
X-Gm-Message-State: AOAM530+4TihYaCMdyKIyru5bKeJk0YSQE0cZNQx9FNUbBqzsARDuY6B
 nBy83h6QQPMbObXX+j0y8oL3q9/1B6iXFexVof9c/OcWGObDG5TjMTJPclUfPCK8b19LTMDrwV3
 5FEJ0aycsQG9JRqOJW1QL6iHC
X-Received: by 2002:a17:907:7d86:: with SMTP id
 oz6mr67730906ejc.312.1638282873389; 
 Tue, 30 Nov 2021 06:34:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8H6MTC5V0R+7/9bPSvceggffYmK7PI41bx1rR80Zl9gohq2DRWT7vDe9+IiNWcQObFE6zzQ==
X-Received: by 2002:a17:907:7d86:: with SMTP id
 oz6mr67730877ejc.312.1638282873127; 
 Tue, 30 Nov 2021 06:34:33 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id g11sm12219088edz.53.2021.11.30.06.34.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Nov 2021 06:34:32 -0800 (PST)
Date: Tue, 30 Nov 2021 15:34:25 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20211130143425.bh27yy47vpihllvs@gator.home>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
 <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home>
 <87a6hlzq8t.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87a6hlzq8t.fsf@linaro.org>
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

On Tue, Nov 30, 2021 at 02:11:34PM +0000, Alex Benn=E9e wrote:
> =

> Andrew Jones <drjones@redhat.com> writes:
> =

> > On Fri, Nov 19, 2021 at 04:30:47PM +0000, Alex Benn=E9e wrote:
> >> =

> >> Andrew Jones <drjones@redhat.com> writes:
> >> =

> >> > On Fri, Nov 12, 2021 at 02:08:01PM +0000, Alex Benn=E9e wrote:
> >> >> =

> >> >> Andrew Jones <drjones@redhat.com> writes:
> >> >> =

> >> >> > On Fri, Nov 12, 2021 at 11:47:31AM +0000, Alex Benn=E9e wrote:
> >> >> >> Hi,
> >> >> >> =

> >> >> >> Sorry this has been sitting in my tree so long. The changes are =
fairly
> >> >> >> minor from v2. I no longer split the tests up into TCG and KVM
> >> >> >> versions and instead just ensure that ERRATA_FORCE is always set=
 when
> >> >> >> run under TCG.
> >> >> >> =

> >> >> >> Alex Benn=E9e (3):
> >> >> >>   arm64: remove invalid check from its-trigger test
> >> >> >>   arm64: enable its-migration tests for TCG
> >> >> >>   arch-run: do not process ERRATA when running under TCG
> >> >> >> =

> >> >> >>  scripts/arch-run.bash |  4 +++-
> >> >> >>  arm/gic.c             | 16 ++++++----------
> >> >> >>  arm/unittests.cfg     |  3 ---
> >> >> >>  3 files changed, 9 insertions(+), 14 deletions(-)
> >> >> >> =

> >> >> >> -- =

> >> >> >> 2.30.2
> >> >> >> =

> >> >> >> _______________________________________________
> >> >> >> kvmarm mailing list
> >> >> >> kvmarm@lists.cs.columbia.edu
> >> >> >> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >> >> >
> >> >> > Hi Alex,
> >> >> >
> >> >> > Thanks for this. I've applied to arm/queue, but I see that
> >> >> >
> >> >> > FAIL: gicv3: its-trigger: inv/invall: dev2/eventid=3D20 pending L=
PI is received
> >> >> >
> >> >> > consistently fails for me. Is that expected? Does it work for you?
> >> >> =

> >> >> doh - looks like I cocked up the merge conflict...
> >> >> =

> >> >> Did it fail for TCG or for KVM (or both)?
> >> >
> >> > Just TCG, which was why I was wondering if it was expected. I've nev=
er run
> >> > these tests with TCG before.
> >> =

> >> Hmm I think expecting the IRQ at all is broken so I think I should
> >> delete the whole pending test.
> >
> > Feel free to repost. I'll update the patches in arm/queue before my next
> > MR.
> =

> Actually I think the problem was with a regression in the TCG ITS
> support (now fixed in master). So I believe as of v3 everything is
> correct (and v4 should be ignored).
> =

> Are you happy to apply this series or do you want me to repost it as v5?

No need to repost. I'll retest v3 with latest QEMU.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
