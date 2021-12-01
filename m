Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A83C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 16:41:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 934964B218;
	Wed,  1 Dec 2021 11:41:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b-a2dm6cuuOX; Wed,  1 Dec 2021 11:41:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486924B200;
	Wed,  1 Dec 2021 11:41:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 463C44B200
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:41:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E89+h2swUgJM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 11:41:09 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 144474B1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 11:41:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638376868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SnH7pitgX4lHmYlmAxxzezWYSXvVY830GNF3XqnXOcQ=;
 b=SC7E/y8cb/Vb8ANeEoGdLL34uhC2QlY/YZJE9sDblUZ54b0s9ulp3V0+02O/NLtvEH1O1c
 Oyur8Jl3zRNBab7zAfqCqE20iEeS8jlwFsonGKMbm8+KO5Ymy9lro5r27NOaL18zT6HQhk
 /u+aqzoTTiL0mHYsB3WoFdHOF2RVl9o=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-Z5iKAJFjO0e9jnilV6jrkg-1; Wed, 01 Dec 2021 11:41:05 -0500
X-MC-Unique: Z5iKAJFjO0e9jnilV6jrkg-1
Received: by mail-ed1-f70.google.com with SMTP id
 w5-20020a05640234c500b003f1b9ab06d2so8708121edc.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 08:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=SnH7pitgX4lHmYlmAxxzezWYSXvVY830GNF3XqnXOcQ=;
 b=D2Dz6BE3tU4N1nmmqetjHBntZF7LzwPI5LA9ceKqQNPsHyu2L2YJtGpVCpK5rYct0Z
 vNJPejIZVVAtYi8i1ZSCXI7lY8NNOTNdQ0reegDnVM0c2Y8NnXvm94OKeAeruE+hlkNA
 ezmU9MGrjdi0QfgSip78KDutBz9iZifZLX14Ficu54sKG6jvY81vdkDYcCUGXuXbE34Q
 PaEMwzRJBkPBjIRQNzNjH8BwOf+bFVeP+qjxaVdHfyMAhzDGcEVRQ1MlMTvMDneqKnza
 6V98Ert44IkwTaApt1qp1UdfKQK2D+2+38QUECeWXQMX4tw8Jb1GAfzJmVkKK4wswxl4
 UDMw==
X-Gm-Message-State: AOAM530E09P4R2HBbtSVtCZYf32YiZMniL4A2zofEDWDoLzhreZB251z
 L2e/paUlMg+sC6w3ZCAE1Q3CGTGIo5mo39JxOA1vS0qsgjCViEHzOwuxvEQTSTlxXX/wePHnQ2l
 fr/WRLQQ/mnatZpcz6yYFtZmP
X-Received: by 2002:a17:907:7e96:: with SMTP id
 qb22mr8301420ejc.469.1638376864208; 
 Wed, 01 Dec 2021 08:41:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7NgTpX038FPeTelSCzUfb+R+QmNIuw2Yq+6qAI1XJAIRnYJhRSKw++EkKdFdXuTjVs3aJVA==
X-Received: by 2002:a17:907:7e96:: with SMTP id
 qb22mr8301380ejc.469.1638376863918; 
 Wed, 01 Dec 2021 08:41:03 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id s4sm174995ejn.25.2021.12.01.08.41.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Dec 2021 08:41:02 -0800 (PST)
Date: Wed, 1 Dec 2021 17:41:00 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Message-ID: <20211201164100.57ima4v5ppqojmu7@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
 <20211124164859.4enqimrptr3pfdkp@gator> <87o860xpkr.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87o860xpkr.fsf@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Dec 01, 2021 at 04:20:02PM +0000, Alex Benn=E9e wrote:
> =

> Andrew Jones <drjones@redhat.com> writes:
> =

> > On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Benn=E9e wrote:
> >> The upcoming MTTCG tests don't need to be run for normal KVM unit
> >> tests so lets add the facility to have a custom set of tests.
> >
> > I think an environment variable override would be better than this comm=
and
> > line override, because then we could also get mkstandalone to work with
> > the new unittests.cfg files. Or, it may be better to just add them to
> > the main unittests.cfg with lines like these
> >
> > groups =3D nodefault mttcg
> > accel =3D tcg
> >
> > That'll "dirty" the logs with SKIP ... (test marked as manual run only)
> > for each one, but at least we won't easily forget about running them fr=
om
> > time to time.
> =

> So what is the meaning of accel here? Is it:
> =

>   - this test only runs on accel FOO
> =

> or
> =

>   - this test defaults to running on accel FOO
> =

> because while the tests are for TCG I want to run them on KVM (so I can
> validate the test on real HW). If I have accel=3Dtcg then:
> =

>   env ACCEL=3Dkvm QEMU=3D$HOME/lsrc/qemu.git/builds/all/qemu-system-aarch=
64 ./run_tests.sh -g mttcg
>   SKIP tlbflush-code::all_other (tcg only, but ACCEL=3Dkvm)
>   SKIP tlbflush-code::page_other (tcg only, but ACCEL=3Dkvm)
>   SKIP tlbflush-code::all_self (tcg only, but ACCEL=3Dkvm)
>   ...
> =

> so I can either drop the accel line and rely on nodefault to ensure it
> doesn't run normally or make the env ACCEL processing less anal about
> preventing me running TCG tests under KVM. What do you think?

Just drop the 'accel =3D tcg' line. I only suggested it because I didn't
know you also wanted to run the MTTCG "specific" tests under KVM. Now,
that I do, I wonder why we wouldn't run them all the time, i.e. no
nodefault group? Do the tests not exercise enough hypervisor code to
be worth the energy used to run them?

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
