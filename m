Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA947C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 16:44:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1F44B1EF;
	Wed, 24 Nov 2021 11:44:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 27svFrYYNdrz; Wed, 24 Nov 2021 11:44:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFED14B1A0;
	Wed, 24 Nov 2021 11:44:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02CF4B190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:44:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TAcxJpldi7eS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 11:44:53 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D2014B175
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:44:53 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id v23so2995640pjr.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=G0XEOHQMGnJK/8jzhumR1dUDWBiMpAvYusRY69A+QEY=;
 b=eKZc15RFplIM1j+sc6nPMLo59g2hHqww5v6Ch0Ogt/sb5WaGNlNpE+Rs3fn936v5lE
 /Ud+RsF/XuWccx7dCQ7EyPY8kpZ0I+PN9phBLbgsB+gzia/f/pPM/RywK9SN/tXJLV7k
 51opGqL28LBGKnfkdEZqfz/c2eL0n+kgusNELgPhpOP3iP+hQZsMPCDHBFm74MR09tPR
 oG/fh0qQPDlbArNQFYgO2gOihsBqB4aVTyzq6YML6Kyeof0O5GeGxKmvV8lj4RXmrHPq
 jMV/Xjlimauhw3+H/g6W8AKtqqbifVnmECZCqTNAENX5QWkUcJtpWeZAAtbIIkSDdu/u
 2d5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=G0XEOHQMGnJK/8jzhumR1dUDWBiMpAvYusRY69A+QEY=;
 b=XVgTFmbBcd626sqZyIq3Q2PGUQ9WBNyUsSdz+3meXNgnvQSs0MIjMrPrYKW5s/r3rm
 j9+oeIv11PkDvzbONwoPA3lew7eNCUjZ7WJM/rFxEsD2AlOqBXdSMGWPYZj6sdCObR+V
 ww7di+QFKYgH1eSZml87qh+HgNZUFCp07eK67tVraPcODnuojZZfmDtVqRHwAzQ8OVgB
 CWFwMGNSYhHgtu1M8UfaA9ilAoiCPx+mTwAylA0usToUkuW46zXAdzsA7eoty4fFnJ2b
 iYo1O2t2P/rD+Fos6+9Q4ZSsZgpFexKljZcm1emNlq9ktLB8yHH+Id2Jd6xKnyD63A2o
 Z0Xg==
X-Gm-Message-State: AOAM532raVSp7Fxq6c7lKY/q0A13LYzq8oaJgciD+Ditsp1JIs8XIy8Z
 UqWSQVir/70/KaFHI38jayyPgEvjOPelAswAt+hUig==
X-Google-Smtp-Source: ABdhPJykkFs1jEUeGODGlA7xKP0OubpatAx4WM/2/8+q/u0xJvkZku4bnMmyPdKIKUWU0zS3NOMpnWmjGnWJ2Zg38BA=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr10825100pjb.110.1637772292285; 
 Wed, 24 Nov 2021 08:44:52 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <YZ0WfQDGT5d8+6i1@monolith.localdoman>
 <CAAeT=FwTrWts=jdO2SzAECKKp5-1gGc5UR22Mf=xpx_8qOcbHw@mail.gmail.com>
 <YZ4Yg2R+r7q/iHpu@monolith.localdoman>
In-Reply-To: <YZ4Yg2R+r7q/iHpu@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 24 Nov 2021 08:44:36 -0800
Message-ID: <CAAeT=FwSYVDEUgkDVMxR9tJCbyERmyZ5zOV0xJ9Xc0MmXiS9mw@mail.gmail.com>
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

> > > The API documentation for KVM_ARM_VCPU_INIT states:
> > >
> > > "Userspace can call this function multiple times for a given vcpu,
> > > including after the vcpu has been run. This will reset the vcpu to its
> > > initial state. All calls to this function after the initial call must use
> > > the same target and same set of feature flags, otherwise EINVAL will be
> > > returned."
> > >
> > > The consequences of that, according to my understanding:
> > >
> > > 1. Any changes to the VCPU features made by KVM are observable by
> > > userspace.
> > >
> > > 2. The features in KVM weren't designed and implemented to be disabled
> > > after being enabled.
> > >
> > > With that in mind, I have two questions:
> > >
> > > 1. What happens when userspace disables a feature via the ID registers
> > > which is set in vcpu->arch.features? Does the feature bit get cleared from
> > > vcpu->arch.features? Does it stay set? If it gets cleared, is it now
> > > possible for userspace to call KVM_ARM_VCPU_INIT again with a different set
> > > of VCPU features (it doesn't look possible to me after looking at the
> > > code). If it stays set, what does it mean when userspace calls
> > > KVM_ARM_VCPU_INIT with a different set of features enabled than what is
> > > present in the ID registers? Should the ID registers be changed to match
> > > the features that userspace set in the last KVM_ARM_VCPU_INIT call (it
> > > looks to me that the ID registers are not changed)?
> >
> > KVM will not allow userspace to set the ID register value that conflicts
> > with CPU features that are configured by the initial KVM_ARM_VCPU_INIT
> > (or there are a few more APIs).
> > KVM_SET_ONE_REG for such requests will fail.
> >
> >
> > > 2. What happens to vcpu->arch.features when userspace enables a feature via
> > > the ID registers which is not present in the bitmap?
> >
> > The answer for this question is basically the same as above.
> > Userspace is not allowed to enable a feature via the ID registers
> > which is not present in the bit map.
> >
> > The cover lever included a brief explanation of this, but I will
> > try to improve the explanation:-)
>
> So the ID registers are used to set the version of a feature which is present in
> the VCPU features bitmap, not to enable or a disable a VCPU feature. Thank you
> for the explanation!

Yes, that is correct for the CPU features that can be enabled by
KVM_ARM_VCPU_INIT (or KVM_ENABLE_CAP).

For the other CPU features that are indicated in ID registers on
the host, userspace can disable (hide) the features (or lower the
level of features) for the guest by updating its ID registers.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
