Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3CCC4708F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 13:23:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B78CF613B4
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 13:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B78CF613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB954A3A5;
	Tue,  1 Jun 2021 09:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qrb2EQh+2Oay; Tue,  1 Jun 2021 09:23:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E88A4A1A5;
	Tue,  1 Jun 2021 09:23:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C19D04A198
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 09:23:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uubMC1y+kKdt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 09:23:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0114A193
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 09:23:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622553792;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J3IodH3/5b4duTPUMi2lNwYDriGX2oiejhw+9uyi1y0=;
 b=XQZ6CKSlNd//CnM5z6A/qWzdSKtL9TnpWgTqw/WOnSb7qrKQKR08fGxl2HFycY44ulpDzz
 kzEtu0xcBya7f9mUPX2QAgqVy1+lG8f+/fW+zNAw0Ug9KmluHQfEQWzshBxnGOZX9uHdVm
 j5tCpQK0t6gdIPGviEvstV+UVfIpwvI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-4LTwLODhOWWApMpGE4kzWw-1; Tue, 01 Jun 2021 09:23:09 -0400
X-MC-Unique: 4LTwLODhOWWApMpGE4kzWw-1
Received: by mail-ed1-f71.google.com with SMTP id
 h16-20020a0564020950b029038cbdae8cbaso7776718edz.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 06:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=J3IodH3/5b4duTPUMi2lNwYDriGX2oiejhw+9uyi1y0=;
 b=EoIVKCDLJNJjWvla/LmTpOpd/HhjBhbIDgya7OFoYc2dRAn1s85oZcwLlNEd0D++Oc
 EF1pUTdsv5tLZ45JQXeuGdSOXUiKPWR0IggN2YlY7E36gyit5eIVLSVYkMhZe+SfWZz5
 ZYqWm5hkhr2Kr/tMw8ixlsCiEH34dC88b6vgtRHszVX4tmFF3NqIA+JHc+LXF/S+36nn
 1Wf/Js8l7XdN/iD2XD2tQ24zQ1MC7mJzdsR0DNlv/HK/P2qCoy9ph13TwWe6YsbVWe1r
 gHffGpyGuqnstn60QXtUQxtKqCaLcpH1hbXtSBHBLxpkRcLJOntI23/1j+xWXEVDs3zn
 5DbA==
X-Gm-Message-State: AOAM533f0/ZxEXwfFTR1pzP0zydAz/edXMH1QStEJvBiwzQg4+WfhxvA
 j9XHN/28HghNEMeIXvay9oRSYBQb/poJTwoT8ALLwU7vr9COUOnYETAkrg7JPwzqL1FjKe630gi
 qlKhTIUr0wSSILObf5wTDK3Ex
X-Received: by 2002:a17:906:dffc:: with SMTP id
 lc28mr15927675ejc.96.1622553787896; 
 Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5RCkzLnBYYcXilaqIyjeB0+R4VhL9QfSWNvwncl7kByJOJVcRNOUzLrUOFq0trQAooTIEjg==
X-Received: by 2002:a17:906:dffc:: with SMTP id
 lc28mr15927655ejc.96.1622553787709; 
 Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id w14sm8639958edj.6.2021.06.01.06.23.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 06:23:07 -0700 (PDT)
Date: Tue, 1 Jun 2021 15:23:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests
 for TCG
Message-ID: <20210601132305.3r5x456icpaa454h@gator.home>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-4-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-4-alex.bennee@linaro.org>
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

On Tue, May 25, 2021 at 06:26:27PM +0100, Alex Benn=E9e wrote:
> With the support for TCG emulated GIC we can also test these now.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
> ---
>  arm/unittests.cfg | 2 --
>  1 file changed, 2 deletions(-)
> =

> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index f776b66..1a39428 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -194,7 +194,6 @@ arch =3D arm64
>  [its-migration]
>  file =3D gic.flat
>  smp =3D $MAX_SMP
> -accel =3D kvm
>  extra_params =3D -machine gic-version=3D3 -append 'its-migration'
>  groups =3D its migration
>  arch =3D arm64
> @@ -202,7 +201,6 @@ arch =3D arm64
>  [its-pending-migration]
>  file =3D gic.flat
>  smp =3D $MAX_SMP
> -accel =3D kvm
>  extra_params =3D -machine gic-version=3D3 -append 'its-pending-migration'
>  groups =3D its migration
>  arch =3D arm64
> -- =

> 2.20.1
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm


Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
