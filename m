Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B365C4708F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 19:47:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C64E613BD
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 19:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C64E613BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E2B640291;
	Tue,  1 Jun 2021 15:46:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eeepP5hUbQ11; Tue,  1 Jun 2021 15:46:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E04407E7;
	Tue,  1 Jun 2021 15:46:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D20E8407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 15:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GwwAArjJyJP4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 15:46:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCABD40291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 15:46:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622576814;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mFg6dKRGX05/OpUoApdspKMfiFJcRvSvkAxKURmBAyQ=;
 b=dsQKmVl53EZQbqwpF4+a5WTZBuWzTLjK19hLIGfW3O5afr6ZvNvNEJv8UxMlJpFhvfyKnL
 4wlsYMoljcXpklLPdrp+v+HoA3L3Kc1V7d3P94jMNAzC4Osmkb3SNKMiqIolqmwyPx5dhC
 Flb6fn06Svlh8LmJb1JAq5BOCyijgHM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-k_um3720OzazVJXiKpgWng-1; Tue, 01 Jun 2021 15:46:52 -0400
X-MC-Unique: k_um3720OzazVJXiKpgWng-1
Received: by mail-ej1-f69.google.com with SMTP id
 eb10-20020a170907280ab02903d65bd14481so21495ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 12:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=mFg6dKRGX05/OpUoApdspKMfiFJcRvSvkAxKURmBAyQ=;
 b=sS48G0S0w3Sl7e4+gBbzjhiNDpniq4JH77Aeo0wZYd3kVBNaw0jGu6iFNhFKCdFcxz
 ixo+gCefuCeHlmsmxOJWTsHI+oZvmJxwWv4Cu9QNjqf+/WrfZ62iC0BEcNytDAAOQJuC
 9MlWwMp783updViSoRG0LoBf+I10ed2ouNnFvhFSetWSslidXoS/gif3uV/4adVKNSwP
 vxQxt5Ny/Vo+SPQVKrsQB7ZvpoaNHKLOp/xWuhushb86Vo995vPW4GA7Kw4ihiJVjG8G
 TwLBrHmJ8TB4JR9mzNJqzsvGyAhCxwkfjbM44ePGg4WyupAi1loNlzT8mL+GN70PWbge
 gV+A==
X-Gm-Message-State: AOAM531TugN7Aji2Y0Ty/tD4T5aG0eMCek1IAnr+Dkw5LaR9e7TZfpUx
 RCiuRuTUdcOcUDeuiO4g3yLijPw99W1cBurxcLkTqqfnobo0p5zfrFr4A5rS0Qa7dUhX6TVWxKL
 MIeojaF7QzJPLLP9uJMAQ0MJg
X-Received: by 2002:a05:6402:1d0c:: with SMTP id
 dg12mr11032454edb.155.1622576810863; 
 Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxbUPimAs6A73voDIIQ7UzbNe86cT5d42Vz4uZzsv/u4iPJgbTgX5R6x1u2RrubCP0A/kXRw==
X-Received: by 2002:a05:6402:1d0c:: with SMTP id
 dg12mr11032429edb.155.1622576810607; 
 Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id v1sm7546424ejw.117.2021.06.01.12.46.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 12:46:50 -0700 (PDT)
Date: Tue, 1 Jun 2021 21:46:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
Message-ID: <20210601194648.fdymtxiz6lkxycsx@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
 <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
 <87sg21bk7r.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87sg21bk7r.fsf@linaro.org>
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

On Tue, Jun 01, 2021 at 05:49:01PM +0100, Alex Benn=E9e wrote:
> =

> Auger Eric <eric.auger@redhat.com> writes:
> =

> > Hi Alex,
> >
> > On 5/25/21 7:26 PM, Alex Benn=E9e wrote:
> >> When running the test in TCG we are basically running on bare metal so
> >> don't rely on having a particular kernel errata applied.
> >> =

> >> You might wonder why we handle this with a totally new test name
> >> instead of adjusting the append to take an extra parameter? Well the
> >> run_migration shell script uses eval "$@" which unwraps the -append
> >> leading to any second parameter being split and leaving QEMU very
> >> confused and the test hanging. This seemed simpler than re-writing all
> >> the test running logic in something sane ;-)
> >
> > there is
> > lib/s390x/vm.h:bool vm_is_tcg(void)
> >
> > but I don't see any particular ID we could use to differentiate both the
> > KVM and the TCG mode, do you?
> =

> For -cpu max we do:
> =

>         /*
>          * Reset MIDR so the guest doesn't mistake our 'max' CPU type for=
 a real
>          * one and try to apply errata workarounds or use impdef features=
 we
>          * don't provide.
>          * An IMPLEMENTER field of 0 means "reserved for software use";
>          * ARCHITECTURE must be 0xf indicating "v7 or later, check ID reg=
isters
>          * to see which features are present";
>          * the VARIANT, PARTNUM and REVISION fields are all implementation
>          * defined and we choose to define PARTNUM just in case guest
>          * code needs to distinguish this QEMU CPU from other software
>          * implementations, though this shouldn't be needed.
>          */
>         t =3D FIELD_DP64(0, MIDR_EL1, IMPLEMENTER, 0);
>         t =3D FIELD_DP64(t, MIDR_EL1, ARCHITECTURE, 0xf);
>         t =3D FIELD_DP64(t, MIDR_EL1, PARTNUM, 'Q');
>         t =3D FIELD_DP64(t, MIDR_EL1, VARIANT, 0);
>         t =3D FIELD_DP64(t, MIDR_EL1, REVISION, 0);
>         cpu->midr =3D t;
> =

> However for the default -cpu cortex-a57 we aim to look just like the
> real thing - only without any annoying micro-architecture bugs ;-)
> =

> >
> > without a more elegant solution,
> =

> I'll look into the suggestion made by Richard.

Where did Richard make a suggestion? And what is it?

Thanks,
drew

> =

> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> >
> > Thanks
> >
> > Eric
> >
> >
> >> =

> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> >> ---
> >>  arm/gic.c         |  8 +++++++-
> >>  arm/unittests.cfg | 10 +++++++++-
> >>  2 files changed, 16 insertions(+), 2 deletions(-)
> >> =

> >> diff --git a/arm/gic.c b/arm/gic.c
> >> index bef061a..0fce2a4 100644
> >> --- a/arm/gic.c
> >> +++ b/arm/gic.c
> >> @@ -36,6 +36,7 @@ static struct gic *gic;
> >>  static int acked[NR_CPUS], spurious[NR_CPUS];
> >>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
> >>  static cpumask_t ready;
> >> +static bool under_tcg;
> >>  =

> >>  static void nr_cpu_check(int nr)
> >>  {
> >> @@ -834,7 +835,7 @@ static void test_migrate_unmapped_collection(void)
> >>  		goto do_migrate;
> >>  	}
> >>  =

> >> -	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
> >> +	if (!errata(ERRATA_UNMAPPED_COLLECTIONS) && !under_tcg) {
> >>  		report_skip("Skipping test, as this test hangs without the fix. "
> >>  			    "Set %s=3Dy to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> >>  		test_skipped =3D true;
> >> @@ -1005,6 +1006,11 @@ int main(int argc, char **argv)
> >>  		report_prefix_push(argv[1]);
> >>  		test_migrate_unmapped_collection();
> >>  		report_prefix_pop();
> >> +	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection-tcg")) {
> >> +		under_tcg =3D true;
> >> +		report_prefix_push(argv[1]);
> >> +		test_migrate_unmapped_collection();
> >> +		report_prefix_pop();
> >>  	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
> >>  		report_prefix_push(argv[1]);
> >>  		test_its_introspection();
> >> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> >> index 1a39428..adc1bbf 100644
> >> --- a/arm/unittests.cfg
> >> +++ b/arm/unittests.cfg
> >> @@ -205,7 +205,7 @@ extra_params =3D -machine gic-version=3D3 -append =
'its-pending-migration'
> >>  groups =3D its migration
> >>  arch =3D arm64
> >>  =

> >> -[its-migrate-unmapped-collection]
> >> +[its-migrate-unmapped-collection-kvm]
> >>  file =3D gic.flat
> >>  smp =3D $MAX_SMP
> >>  accel =3D kvm
> >> @@ -213,6 +213,14 @@ extra_params =3D -machine gic-version=3D3 -append=
 'its-migrate-unmapped-collection'
> >>  groups =3D its migration
> >>  arch =3D arm64
> >>  =

> >> +[its-migrate-unmapped-collection-tcg]
> >> +file =3D gic.flat
> >> +smp =3D $MAX_SMP
> >> +accel =3D tcg
> >> +extra_params =3D -machine gic-version=3D3 -append 'its-migrate-unmapp=
ed-collection-tcg'
> >> +groups =3D its migration
> >> +arch =3D arm64
> >> +
> >>  # Test PSCI emulation
> >>  [psci]
> >>  file =3D psci.flat
> >> =

> =

> =

> -- =

> Alex Benn=E9e
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
