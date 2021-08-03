Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E53C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:44:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4FF5600D4
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4FF5600D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A61449FE6;
	Tue,  3 Aug 2021 06:44:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgZnI7JhnzSb; Tue,  3 Aug 2021 06:44:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA664086F;
	Tue,  3 Aug 2021 06:44:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC014086F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:44:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TSs4KpQgXnch for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:44:08 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F88740623
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:44:08 -0400 (EDT)
Received: by mail-oi1-f177.google.com with SMTP id 26so9774750oiy.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yaNx5vDzglyO/0OfjHwfgJ9vhfDLVyx661pK/MAUsA8=;
 b=dVh6ktfKl/CmGwenXxBiuBj7rQKh2aljyeA1exgKoGSGKNgNYgcjYdawdaDKHH8nzn
 /BQL/xwjCvvlTq7RvVWJnDnlIVV/aZr4pzV3RLA9NNynINGSSKLWu6uARzGcwM3coHR8
 Varoz0BHPMjUE80DcbiIsdcwPxx1SMgyWTYpagPD/PJZAyQGJt0zEz3y3EiIkg/el/ES
 oaCCFlt4a4J+tNoj6nFdSnwvLkeB/OAhLAhy7O4WdZn6S7DTXExr0zVWdaaB3hCP7pBW
 v5Yi/QTAA6jM5SPjTcOnBBlfX2vUWu1YZTjOOooTLlLd24h7plROwT2vsyroHVMAvuCo
 MzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yaNx5vDzglyO/0OfjHwfgJ9vhfDLVyx661pK/MAUsA8=;
 b=DINgMq8imjy2XAiNHPKUdmZqdx8RfuR6VZK5K4B5qrjN3wpuKPxDIs6QcVMAFGMYye
 g5wrNbUQi+Wh3NJueX8BbvU1g8XlnqHB4Fzk6HINZ1oRcOI/libo95rHxdi61wAskG5f
 +usZIkHSUXhhdGUV9zy7fBcwKusfpZPB5QktZ2sbHA0wXfsErhKU2kdZ7YiFIipLEeAn
 V8qdc9ILFQdGyAmy7YreyrDB8i7D/4hitq3ffGmespcaektpdXoNAansFBv2iy8vNOEC
 LUvTKyFb2oYR3ohBvM4AIqWPGiBjOPm08/9hCXl/oXpaJNmSvoYkLlIgaf2/al/uvIdr
 Wgqw==
X-Gm-Message-State: AOAM531fjc5bLKhba1XW9vQAdx687xJQOfVTDEg2Ld355qC1QYqiDuKA
 ahqHoa3OLdP1vl16+vVGdHqb7zxR7RIRVUUGQbJsAQ==
X-Google-Smtp-Source: ABdhPJwYzCSdWjyi0pYSnKyyrs+IptK4BCpyosUrou0C9GbEJeZ1RjMGqStuxXt0pVyzMJHXXFxwuoId3kQv0IvjGUQ=
X-Received: by 2002:aca:2102:: with SMTP id 2mr2456621oiz.67.1627987447441;
 Tue, 03 Aug 2021 03:44:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-11-qperret@google.com>
 <CA+EHjTxCvqQ=jmBPJ1N6ShBf=f4J5cjT4pt9akfnqNjQUoqzWw@mail.gmail.com>
 <YQkWuCVkKWJX81en@google.com>
In-Reply-To: <YQkWuCVkKWJX81en@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 12:43:30 +0200
Message-ID: <CA+EHjTwamSQ+msUUnuCi6c_hw5TzDy-7dSxLxEnGmA4T4uhw_Q@mail.gmail.com>
Subject: Re: [PATCH v3 10/21] KVM: arm64: Enable forcing page-level stage-2
 mappings
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Quentin,

> > > +static bool stage2_block_mapping_allowed(u64 addr, u64 end, u32 level,
> > > +                                        struct stage2_map_data *data)
> > > +{
> > > +       if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
> > > +               return false;
> >
> > I'm not sure I understand why checking the level is necessary. Can
> > there be block mapping at the last possible level?
>
> That's probably just a matter of naming, but this function is in fact
> called at every level, just like kvm_block_mapping_supported() was
> before. And we rely on it returning true at the last level, so I need to
> do that check here.
>
> Maybe renaming this stage2_leaf_mapping_allowed() would clarify?

Yes it would.

Thanks,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
