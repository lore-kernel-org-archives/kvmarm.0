Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F8CC43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 02:25:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE3CD4B38B;
	Wed,  8 Jun 2022 22:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ur1umPkct9B5; Wed,  8 Jun 2022 22:25:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F8E4B28B;
	Wed,  8 Jun 2022 22:25:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD2D840D26
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 22:25:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8c036Disq-cm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 22:25:46 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976D6401D7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 22:25:46 -0400 (EDT)
Received: by mail-oi1-f177.google.com with SMTP id y69so16512751oia.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 19:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sT97t32fGuh4Lagfso1CZFM0kPU0D0D1QyfmHoUG+44=;
 b=FlD7+FLEtlusX0WSzAljCqODKnZlDNVX6zv5nuensD+DAQfgYzSt6opmfIlf7wiJj/
 Nt9JN3V9g0iXXJa/8VFnUg/u00F18NaVVn/MlDaslGw9ZyQSz9n9Jt5XaxcOgTLhAdyE
 DtfJvnqM8qBfys3KsSCd8Vj5xAEVnLwqnAArYcaV2t21UcPTX1/crwi7Gesl5rfI/ecS
 Dq6AkM0gHNAl08qSLdpijFziD8wQmuCKIW5Wfk6GvY5s15NhwFOXMn4kABOfofyTFNDQ
 noRLBmIzBnbZGeEzC8txzKPBRXpWlJVBlEZiSn7+qR239uHAf4KFndoAdxxEHGT+6ryS
 at7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sT97t32fGuh4Lagfso1CZFM0kPU0D0D1QyfmHoUG+44=;
 b=6/BGEm/PXnXP+j6nZUWV5s7AgpIt1mKP7b4tXBY4VdChmSFWW+pBoARNujdtK8k7rx
 5opIQiTd0zg4FAQHJchEoT809Q7yeBPX3R4D+mN0Z0W2+foxI99UEGgU+HXIFX6v9DqT
 mbb/uXXg02SbxXvtMWQYJbCzDT8CpmHnbiK3wA72T2SXCE7aB6TNaZYxjueLQLfrhm3F
 ddbtP132APNtDt7n5yYc9/lSyg/xqUdPLpySA7N0XI53Bxsg3UhaJrDMxEwyyjm9/IOf
 HojwiOfgWCYsHE+3s9es4aYdRT8GtaLn5Ok6H+rYrbU+lJipmy79ZDgVbAhPN0PTGOIv
 h5Zg==
X-Gm-Message-State: AOAM532TZ+V4B1UEDY/KPcxyjGyHr9fS9rArvU/3CI7A/a546hCTR51y
 HfZe4pD8yuXwbW63MwVnA5lI2PQmNdC6jrjxKqO/3A==
X-Google-Smtp-Source: ABdhPJx6V/+rGfOAySSbcC5tiNalve3Vr1NpKeuTrCwESzAeUsSTl6Wm6kiZjM4IKoD0l0bTtA9RSQkatNz1vj8mXn0=
X-Received: by 2002:a05:6808:3198:b0:32b:a54:1238 with SMTP id
 cd24-20020a056808319800b0032b0a541238mr508612oib.16.1654741545717; Wed, 08
 Jun 2022 19:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-6-maz@kernel.org>
 <CAAeT=FyruEc5pDhdg0wOtFcV0EFUnhOVyt+o5BMfn5GsooM9Jw@mail.gmail.com>
 <87mtenzlzh.wl-maz@kernel.org>
In-Reply-To: <87mtenzlzh.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 8 Jun 2022 19:25:30 -0700
Message-ID: <CAAeT=Fwgt9Dv319C_Wr4=UEZJeW+pkSE__B3dB4du-Hq54U=ng@mail.gmail.com>
Subject: Re: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

> > > +#define vcpu_get_flag(v, ...)  __vcpu_get_flag(v, __VA_ARGS__)
> > > +#define vcpu_set_flag(v, ...)  __vcpu_set_flag(v, __VA_ARGS__)
> > > +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag(v, __VA_ARGS__)
> > > +
> > > +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> > > +
> > > +#define __flag_unpack(_set, _f, _m)    _f
> >
> > Nit: Probably it might be worth adding a comment that explains the
> > above two macros ? (e.g. what is each element of the triplets ?)
>
> How about this?
>
> /*
>  * Each 'flag' is composed of a comma-separated triplet:
>  *
>  * - the flag-set it belongs to in the vcpu->arch structure
>  * - the value for that flag
>  * - the mask for that flag
>  *
>  *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
>  * unpack_vcpu_flag() extract the flag value from the triplet for
>  * direct use outside of the flag accessors.
>  */

Looks good to me, thank you!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
