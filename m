Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D31C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 18:33:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95B6661B51
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 18:33:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 95B6661B51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B49C4B108;
	Fri, 19 Nov 2021 13:33:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7B51XGmbWQHk; Fri, 19 Nov 2021 13:33:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A2744B0CB;
	Fri, 19 Nov 2021 13:33:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE9024B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 13:33:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q4d3moSIz556 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 13:33:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7004B0C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 13:33:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637346782;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=B+GQMwG10mbwdIIWMwu0ilfUEUoBg0jOybBvIrXEDjQ=;
 b=e2XVRTaVNssl40G/0AuQavwjAdwnC7zl1RiDl3/2Rzjt+7tdHLShMGqHYW4Zxepw2l+QUd
 z9GRdAeUEpKyaZuD8qQ3wfWO5cg5b64kwjssZhw8F+d02glyKK04Ny7BS7wbNuiAJL2EfK
 nLqb4iih4ePPrwZwHVF3rLWKqf3Vh/8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-zjv58fnSOmq4wA500Ft5ig-1; Fri, 19 Nov 2021 13:33:01 -0500
X-MC-Unique: zjv58fnSOmq4wA500Ft5ig-1
Received: by mail-ed1-f71.google.com with SMTP id
 v22-20020a50a456000000b003e7cbfe3dfeso9158422edb.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 10:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=B+GQMwG10mbwdIIWMwu0ilfUEUoBg0jOybBvIrXEDjQ=;
 b=h7ao+RnQnnALCr+wgT3VIGmyyoBykhI1o+/zqXEcux3ZcaCONuOdK9JFw41l/sbBO2
 GHCeM28Y61lzaWasCEkTYIufib+e4iFmzE5cq/UHq3k01BO4bVK6XdhvNO6rwmSQ0jOH
 no6alUpf/rTkAKzapPG5hnJ5R7niHZWP+uNxvtSdyVanf9smwp2mPQb6+cdd8yS4mIAX
 jEGWSvYUi72rivF0PoyMRLc2D184DrfrxwWCOFva/Zf9JLPDVM34Ai8muayoKxmSLJCR
 YNvQnSHYryVi8RO0BwFviEhoqGzD+aS/Lj3HNwKox0WuzCOk05k1sgtq96uWOf4KlV6Z
 44+g==
X-Gm-Message-State: AOAM531w8/2helWjq9wVYPTiej/m8X96PIZUM4RpfUvoAP28DNnGYcA2
 LTUJ3fy6idWz1Z60Dg2+zM/ZfeK8IxlLmjOe1lv5U5W/QWyKEHDzIukoe259U/hc+Gc+Qb7Fzus
 M7SyLLv69+VMRdxY2pnc/YzBe
X-Received: by 2002:a05:6402:4d5:: with SMTP id
 n21mr27235434edw.303.1637346780151; 
 Fri, 19 Nov 2021 10:33:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEuO0iTCuF5ryZ5+13DQLvOPXu0iE6NgZszeF9V/f02IjK+pJ3+OHzfTepFE/huLwiPjmqwQ==
X-Received: by 2002:a05:6402:4d5:: with SMTP id
 n21mr27235398edw.303.1637346779971; 
 Fri, 19 Nov 2021 10:32:59 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id sa3sm251805ejc.113.2021.11.19.10.32.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 10:32:59 -0800 (PST)
Date: Fri, 19 Nov 2021 19:32:57 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v4 0/3] GIC ITS tests
Message-ID: <20211119183257.unj256xrobwbjvae@gator.home>
References: <20211119163710.974653-1-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211119163710.974653-1-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, maz@kernel.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Alex,

Please CC me on the full series. I'm not always able to keep up
on the lists. I see there's another series too that you've
posted. I'll look next week.

Thanks,
drew

On Fri, Nov 19, 2021 at 04:37:07PM +0000, Alex Benn=E9e wrote:
> Hi,
> =

> changes since v3:
> =

>   - dropped the pending LPI test altogether
> =

> Alex Benn=E9e (3):
>   arm64: remove invalid check from its-trigger test
>   arm64: enable its-migration tests for TCG
>   arch-run: do not process ERRATA when running under TCG
> =

>  scripts/arch-run.bash |  4 +++-
>  arm/gic.c             | 28 ++++++++--------------------
>  arm/unittests.cfg     |  3 ---
>  3 files changed, 11 insertions(+), 24 deletions(-)
> =

> -- =

> 2.30.2
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
