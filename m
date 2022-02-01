Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5207C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:15:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 411AF40B91;
	Tue,  1 Feb 2022 09:15:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lkXof4UINyHx; Tue,  1 Feb 2022 09:15:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1EE541016;
	Tue,  1 Feb 2022 09:14:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C51440BEE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 55HheiAb6axY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:14:58 -0500 (EST)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06841402DB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:58 -0500 (EST)
Received: by mail-oi1-f175.google.com with SMTP id y23so33412606oia.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6bOJYv1YXi57aXsNUO4DshkJvwNgZBMSvRbTKgSo7IM=;
 b=AWQE60HZuXRdf3uBXurgIDDbIMW/+IJJ25UY1gTmKDmw1WRzhEaf2iJfYhqZVs7/oI
 xkKLM9palj/+QbBbNhpvjIYROJDcGqerVuNAub/Kn4Z0zAa1cFcB2m/YcqKM0fG/P2f1
 Gie4zgekiYmfVvh/p0zxjmcUFtTk+SOrLOAKzRQ5g/gbz8gmqXr152WzTBgSHfVFH5PE
 mkmWGE3LF5kAXIYxKgggPCAoFJvYVaa9DKKEV58MdttyymffgCGu5jkT6y1LGKoTzN4A
 7t2k6zl4sc7JZncOe0WuWVT7JwKUfQHYnDms6xTATvu/dGWd7vJIVNsPhBaCJlFvdbsr
 C9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6bOJYv1YXi57aXsNUO4DshkJvwNgZBMSvRbTKgSo7IM=;
 b=Mz50P/If/G+gVgJPe4El3C3eZHTl9A6WxI2PWv7fusxhpBSYP+60IsZLY/kiVotbkM
 fn0PhPv8SjRsHX8TNdCD9cZELYWanWhdwSlrYWwCFrTn8W7PgXdeGB5hGHBQxiKdjztu
 I6IDqVsRl0v/HLUzIS+xBBZvEm8PTGeByQOdzav1oDce7Uk3DerSU3y8KFIv0GFC45zj
 4/pzBzH0ISyd/v6slNm9vhTnd6vpO0KtLFwjB8r1rpjVR3ykrSMF4xag9fWDf4Tex32C
 ikj1R2Eat0UhPScNKmxFs8cP/scpr1woQftl21QIvN6knOG56POUOGwfsDqZL7/OEvRV
 lfQQ==
X-Gm-Message-State: AOAM531L1CX6DVhvQnB9VzDCm7fBXuyfh4MyAf8LsitGhDHeFBg54XlG
 hZuxU0rVOW+1oPYCE95FfUz+JYSgivRtYvdiLNHZmQ==
X-Google-Smtp-Source: ABdhPJztijkLEYC0AMBbPf31NVpfBd3j1Dug7ndhyOGAhyIwbOmUQBb7IRhv9Rqqoj8sG1Fm2nt0s7rfxiTUrTZyh3I=
X-Received: by 2002:a05:6808:230f:: with SMTP id
 bn15mr1264184oib.91.1643724896991; 
 Tue, 01 Feb 2022 06:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
 <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
In-Reply-To: <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 1 Feb 2022 14:14:21 +0000
Message-ID: <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of
 ID_AA64PFR0_EL1
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

...

> > > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > > +{
> > > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
> >
> > Covers the CPTR flags for AMU, but as you mentioned, does not
> > explicitly clear HCR_AMVOFFEN.
>
> In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
> CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
> AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
> (Or is my understanding wrong ??)

You're right. However, I think they should be cleared first for
completeness. Also, if I understand correctly, AMVOFFEN is about
enabling and disabling virtualization of the registers, making
indirect reads of the virtual offset registers as zero, so it's not
just about trapping.

Thanks,
/fuad

> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
