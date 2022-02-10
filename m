Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913F1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 04:15:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2BFD49F0E;
	Wed,  9 Feb 2022 23:15:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zkiOB062GZOT; Wed,  9 Feb 2022 23:15:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A20649F10;
	Wed,  9 Feb 2022 23:15:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1521C49F0B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 23:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2R7vLp+nEsBP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Feb 2022 23:15:29 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05F4240AEB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 23:15:28 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 h7-20020a17090a648700b001b927560c2bso3145761pjj.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Feb 2022 20:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MDxf4BrnwStXUjsYxwjI3lJC+rIcyxFDuuEmHqrQ/Oc=;
 b=qgqsDox8Uz2voagu3SS62EbUZLzC4+jwAS+IETwJnJ3WDf9LcHDPRHBYlPb+QqvTwz
 rr1ve49rjegbL66nRKCfoRHGLIT5zui9RIxCMIs4Ibi4DDbfhdUEGAlhoWwzDaR1LDWU
 6fNbAKXodXe6oPJrV7mO0cU1Lv9u7VmoR5tHwSZ4IvQL3lqQBkcsRe5QAHSL5zPpACji
 lg6qPIaKgZ4e75HuHXkXm73zjeCkEOKMVnkxFIUUZ1snmXAx7Y6Lvo8hY45HlEAgT1uD
 xokqMib5SOuBx/sCi958eRUq7d9bDw+qWNEvZbObBDUokOwxpuzwX7UR5lKsV5bxHr/9
 5Zyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MDxf4BrnwStXUjsYxwjI3lJC+rIcyxFDuuEmHqrQ/Oc=;
 b=uew6M2DgaeLVuoamBvqlMfnWD+7LEPPBgFFXPbP1QbfM0w28G0NUOmQQlay4FJjgb/
 rw8XblHZScv3861KXJ+k6mDpHMF4Tu6mSciTWXDTQ6BJEJSMxFKP68paodOYUm2F/yPW
 UtIyxtkKkrR09NFiZN6YcfYOpHSMkGNRtuW16u/LB1D6LWxba7GEUjvthiYwtxiTCvKy
 kxGpPFFpR6uB+evPT+Q1yRJgtygi5YlbIqMVtwW1B5evnzHuKhDvgOfBuRAIIv627bmA
 kXmp7n66gUQHIKoTcKBYntPf+z/ABeLlvauPAOz3yeppaPorv/fBAGFGw/+s0V/iUvFm
 Cqeg==
X-Gm-Message-State: AOAM5320bx7WKyPx9EM83xS7yj32vYH44/nnzeUlIssFbjhopB5U8mLp
 vj3j92EDrllKowMAgQlvSHm3j07v9r/4eemdNnBAXA==
X-Google-Smtp-Source: ABdhPJycsJw7aHUyLA1Fvry8/yj4cc0Za+AYbDOdm5osBbufU/q5zbR4L8vQjN32IWZfSBIFBZwlUxfcLH1cXtwOU7k=
X-Received: by 2002:a17:90b:4f43:: with SMTP id pj3mr783525pjb.9.1644466527831; 
 Wed, 09 Feb 2022 20:15:27 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
 <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
 <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
In-Reply-To: <CA+EHjTx=ztc-RnuazbUcR-JsKocyie+FtrukvzUP=SZ-y9WPuw@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 9 Feb 2022 20:15:11 -0800
Message-ID: <CAAeT=FyEbk+9mM802Drb-pVgE=aL-RUdyn7zdHOnUACoMtDVmQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of
 ID_AA64PFR0_EL1
To: Fuad Tabba <tabba@google.com>
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

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
> > >
> > > Covers the CPTR flags for AMU, but as you mentioned, does not
> > > explicitly clear HCR_AMVOFFEN.
> >
> > In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
> > CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
> > AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
> > (Or is my understanding wrong ??)
>
> You're right. However, I think they should be cleared first for
> completeness. Also, if I understand correctly, AMVOFFEN is about
> enabling and disabling virtualization of the registers, making
> indirect reads of the virtual offset registers as zero, so it's not
> just about trapping.

I understand that AMVOFFEN is making indirect reads of the
virtual offset registers as zero.  But, in my understanding,
enabling and disabling virtualization of the registers doesn't
matter as long as CPTR_EL2.TAM == 1 (a value of HCR_EL2.AMVOFFEN
doesn't change any behavior because the virtual offset registers
won't be used). So, I'm not too keen on adding that so far.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
