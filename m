Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0F8C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  4 Dec 2021 01:04:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511BB49F5F;
	Fri,  3 Dec 2021 20:04:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W66MfMk+V-TU; Fri,  3 Dec 2021 20:04:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B6E24064F;
	Fri,  3 Dec 2021 20:04:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 886C2405A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 20:04:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V9Uv-TFnI0bD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Dec 2021 20:04:28 -0500 (EST)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 421E940573
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Dec 2021 20:04:28 -0500 (EST)
Received: by mail-pf1-f172.google.com with SMTP id b68so4432298pfg.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Dec 2021 17:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XE1lgBHY1qjRhoYofuOFOoV/YwT3xICq/rIHwhXBdqc=;
 b=LQswGke5VHeD+dcHpM0HR1sTjV718lOri+p9ap3AWxvHaVYqT3z0Qu5HKofsfSmI6l
 re4YXfADVjvD47PWcqLWzd/yxEe9v87Lqm9Ie4gQbwot+W6VZc+TV59LgVIfQ9t+L8yV
 V8tA4cGG/dgdNmqCvZiMRffTla8nA09bIk846uLw+nNCMY749ZArqdo2Ot4ZUavI4Vam
 7YCqJ//Y7DVs2hxwO/YlvS3ywEuKJ2llxcS2qaYYwXH8ruPRmIQ+y3BpaAdW8ze11Xsc
 loXwvufLKFrlSb8aWi3kxF0P7fr+n0RS92KO/MpIbI6mBH5lePdPan91H+TAndcmn7i7
 KG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XE1lgBHY1qjRhoYofuOFOoV/YwT3xICq/rIHwhXBdqc=;
 b=GZFAyMuRTQoMLIVOOUhFScQTWHd9s4vyWJgc67irxL+RAW+MhOYULFxRiiBmORBawm
 mUgpjpoWgiJKeJgCgmT1Dk0YEGUrnwsqEocc3NiE+Xi1q/mfQDSMp2KBShOLEJ7MkNS3
 0Y/M/bGi2cSPPelpfxhR9au4O4bfOLbI7pX0MzS5/mArkEEMrOYfDFeGmkEEajB+kid/
 9geaC86gN3J324Ud80jEWsEVDblGsVgYsLiUWCJOUQZTwE5Qnv2YazFm9x+YeXBD5f63
 6aRReqI8/K+hE6NqEgOJSnoOhB0K+5GUUVvW4zAO+rlHN/vtCisW5BznzSc6skUTB7zI
 AC9Q==
X-Gm-Message-State: AOAM532a9jLknOEsSRPWLSIqdBabJgZLDay9PPbEFGe0LpTAtizIp9Mm
 0OlPiPvi8HSQy5nb5UFgS0gUa9CYBr5//UR5IDvJwaZ3YUEQlw==
X-Google-Smtp-Source: ABdhPJxAmeyiI93S2DwlX8TZyZoxgW2fHpUKvj4k/QXSw5lXDVt0PSll4BikwnO6GpDsx5uU7xiFtMjjJYepa2ojll4=
X-Received: by 2002:a63:c042:: with SMTP id z2mr951044pgi.491.1638579867102;
 Fri, 03 Dec 2021 17:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
 <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
In-Reply-To: <5bd01c9c-6ac8-4034-6f49-be636a3b287c@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 3 Dec 2021 17:04:11 -0800
Message-ID: <CAAeT=FwEogskDQVwwTkZSstYX7-X0r1B+hUUHbZOE5T5o9V=ww@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Eric Auger <eauger@redhat.com>
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

Hi Eric,

On Thu, Dec 2, 2021 at 2:57 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/30/21 6:32 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> >>> means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> >>> expose the value for the guest as it is.  Since KVM doesn't support
> >>> IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> >>> exopse 0x0 (PMU is not implemented) instead.
> >> s/exopse/expose
> >>>
> >>> Change cpuid_feature_cap_perfmon_field() to update the field value
> >>> to 0x0 when it is 0xf.
> >> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >> guest should not use it as a PMUv3?
> >
> >> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> >> guest should not use it as a PMUv3?
> >
> > For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> > Arm ARM says:
> >   "IMPLEMENTATION DEFINED form of performance monitors supported,
> >    PMUv3 not supported."
> >
> > Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> > be exposed to guests (And this patch series doesn't allow userspace
> > to set the fields to 0xf for guests).
> What I don't get is why this isn't detected before (in kvm_reset_vcpu).
> if the VCPU was initialized with KVM_ARM_VCPU_PMU_V3 can we honor this
> init request if the host pmu is implementation defined?

KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_PMU_V3 will fail in
kvm_reset_vcpu() if the host PMU is implementation defined.

The AA64DFR0 and DFR0 registers for a vCPU without KVM_ARM_VCPU_PMU_V3
indicates IMPLEMENTATION DEFINED PMU support, which is not correct.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
