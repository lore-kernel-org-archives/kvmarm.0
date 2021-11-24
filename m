Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D245C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 17:01:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B858E4B1AB;
	Wed, 24 Nov 2021 12:01:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kv3d-66no-v2; Wed, 24 Nov 2021 12:00:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C1C4B1D8;
	Wed, 24 Nov 2021 12:00:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C74D4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 12:00:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UUL5vMMAJ+TM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 12:00:57 -0500 (EST)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AC3D4B15C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 12:00:57 -0500 (EST)
Received: by mail-pl1-f175.google.com with SMTP id y7so2397078plp.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ccD0ntUVVYkwYlyadNBt1sjxaVIrP/hx7EjWxQNG1N8=;
 b=GOWk964Yosu4ck30FptZ70D1KfKid+USBLbkj8qHTGA21vV6GE7GYqSTOdM2HFjGeW
 2SxyiSkj0+IfbN3/2320KZDe3R7YEgaSwjdsvCkNh6MfmUBbb9k4SZ0rPYhB4qCeCqMb
 t/ZHRtkalvm2Q23Mu0NnH41nyx2BZihuqFVmuuUbsg3TWXJiz66zbOwFC/14Xb0PLQI+
 9FhNtTngAmj5DY4E/DkWHD40NtKCuujkZtfK2C8PahXspP61IoOPNfbRsBJ5mkj9dFFh
 lSYRq5586zAHmDgxQR8/n35KSbN2KVgpG0/QkTPRAHlbLz1CWRdIr9ou8r5QwD9PLIcQ
 Y29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ccD0ntUVVYkwYlyadNBt1sjxaVIrP/hx7EjWxQNG1N8=;
 b=VRxhJ/wCRxwdZpa9wuooPddgIFGlkhYjoPwo77uihSyBfmR2CZtOtX/mviUR9YAwms
 yhxvPHLY/fCYTuXyznuheekWrPgOwfC78X3MbvvEan9MVWThvryS63YrKsC5rtxTDP5g
 PKq5DPma1IXmZF5ji2D2OJ2PuTKaz80hqkggvTgYxSAyZ52cxQjLMZyn4+S22TuIvPse
 5z+QtYi5pACegKSfUE8SZcfq2HpPylMhKVJg/VGbIwfCvJcTo93HDmTxoCDrOeDrc+nq
 NBZcR4bG59OxJxqBvRL++aWm4tRbMwzYXlvGKB3yaqie0bePznTntqKXoa1IN5VA2qKP
 +ocA==
X-Gm-Message-State: AOAM530CIn1G7WGqpbF1jfCq+e/Uq673hX1R/NoYi24DXvD1MEYkI7WA
 /b+zS87HShD5m1ZYIvSy3kb2dh+d2lMv4JfnjPGwGA==
X-Google-Smtp-Source: ABdhPJx4hHfvg7PjcL9qHntLsSw4S293Gegpji2gVZVbaMxcedLFto0w5R8opTR+gtpycaYJ0aXlQUScJRfPuAzPG2I=
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr19489170ply.38.1637773256073; Wed, 24
 Nov 2021 09:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <YZ0QMK1QFjw/uznl@monolith.localdoman>
 <CAAeT=FxeXmgM3Pyt_brYRdehMrKHQwZut5xTbHOv-9um7anhYw@mail.gmail.com>
 <YZ4Y/r8BM2hnrlYQ@monolith.localdoman>
In-Reply-To: <YZ4Y/r8BM2hnrlYQ@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 24 Nov 2021 09:00:39 -0800
Message-ID: <CAAeT=FzhCmBTF2QpCdNVjtVT_Ct0mo2_05uTny73U4B3fTyVZg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/29] KVM: arm64: Make CPU ID registers writable
 by userspace
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alex,

> > > I started reviewing the series, but I ended up being very confused, see
> > > below.
> > >
> > > On Tue, Nov 16, 2021 at 10:43:30PM -0800, Reiji Watanabe wrote:
> > > > In KVM/arm64, values of ID registers for a guest are mostly same as
> > > > its host's values except for bits for feature that KVM doesn't support
> > > > and for opt-in features that userspace didn't configure.  Userspace
> > > > can use KVM_SET_ONE_REG to a set ID register value, but it fails
> > > > if userspace attempts to modify the register value.
> > > >
> > > > This patch series adds support to allow userspace to modify a value of
> > > > ID registers (as long as KVM can support features that are indicated
> > > > in the registers) so userspace can have more control of configuring
> > > > and unconfiguring features for guests.
> > >
> > > What not use VCPU features? Isn't that why the field
> > > kvm_vcpu_init->features exists in the first place? This cover letter does
> > > nothing to explaing why any changes are needed.
> > >
> > > Do you require finer grained control over certain feature that you cannot
> > > get with the 32 * 7 = 224 feature flag bits from kvm_vcpu_init? Does using
> > > the ID registers simplify certain aspects of the implementation?
> >
> > Since some features are not binary in nature (e.g. AA64DFR0_EL1.BRPs
> > fields indicate number of breakpoints minus 1), using
> > kvm_vcpu_init->features to configure such features is inconvenient.
>
> I see, this makes a lot of sense and this looks like a nice solution to
> that problem.
>
> >
> > One of the reasons why we want the finer grained control is that
> > we want to expose a uniform set/level of features for a group of
> > guests on systems with different ARM CPUs.
>
> So here you are talking specifically about KVM not checking that all VCPUs
> have the same feature bits set in vcpu->arch.features, which makes it
> possible for userspace to set different features for different VCPUs,
> right?

Yes, that is correct.  For features that can be configured by
KVM_ARM_VCPU_INIT, userspace can configure different features
for different vCPUs by using KVM_ARM_VCPU_INIT as before.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
