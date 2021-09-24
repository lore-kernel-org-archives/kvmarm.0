Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11DEC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 07:20:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B1656124D
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 07:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B1656124D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59A44B0C2;
	Fri, 24 Sep 2021 03:20:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3MJyNGQAqlW5; Fri, 24 Sep 2021 03:20:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8FC4A5A0;
	Fri, 24 Sep 2021 03:20:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD9B405EE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 03:20:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8zuhYH7sV64 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 03:20:48 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F9164048B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 03:20:48 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id k23so6384203pji.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 00:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oa6c5pdb6GgT+FciQG9zGryGSgSV0wDGRTDly5jSdik=;
 b=Yb8BC8+W8zNJ2cn6C+2RpR53j2vs6KwDm3Q0f/gzO14zIh5KXkaWH8KHkJLfKvq/Gt
 Tvd67QkiEuG2mLPoLbndnQmE3KpY+0IqGKcsf6kG5YVEqGkhLSn85eM84xm3e7jZGZIs
 zHpgI6i+lu05G+eLTl7ihnBzI10EADdGbnS+ZkD2CPbD52aBb5kKgEZdL8exiVx01EPs
 Rj1gflu+ib3d88jvp7c+KFMw6VgWW8pYfg/3Sk/X5/XrjbmJ1yOouczfljbaFPuNOX9K
 76DZQ7y34SwmHbayWrhTeJyUEbosSNA3bxtX1njDRagU+RoNFCgTHy+mW3M2nDxp9vNn
 HYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oa6c5pdb6GgT+FciQG9zGryGSgSV0wDGRTDly5jSdik=;
 b=0GbzDiKTPYtRqazCjpumix8nsV79AFrpVQChDUyGaOOcUEkJHbqNfg5uffLFixRZaO
 9RgwwSw2xU04cPcVQIv9Souru+dYxyB13xrvgsO/pZBVWgJvLrbNYyIES+j9cVvLCvSi
 df+AOCIdKndADcvQj8nUu/ECoWUz4WWDBsxlUh6ComF0FT6zmuRAi3WP2xI0LhDfe0iA
 nOeBVGgbZqjfoT4bqOpseJvIcSwuw7LTFeoOBusftXoWA6A4ATLWs994NkFUHAwSZOLZ
 Kqv5+nc9cQ8QPWzULL+yKgKtyuHoVsqHAj6KJQqDmdzcEk6nemurHkduXs2RO65p1j7j
 H81w==
X-Gm-Message-State: AOAM5320q6Q3upRfXro/7CcdsDThKsouTpNet4shcC6jBHKvs+GMa2Ze
 blMC1bcAgWs9OSfLEj2fJMqCNvAFJW378jUCNJD37FeQMxXVQQ==
X-Google-Smtp-Source: ABdhPJyQE81Xvn5qKelAV4RVuvdM8+D6Sr0NIlWcPD2y3ECryKNkbPx229P43Hc2o82o3mdURpHlbiPyX4ZN9pQ1DwE=
X-Received: by 2002:a17:90b:a02:: with SMTP id
 gg2mr161551pjb.110.1632468047511; 
 Fri, 24 Sep 2021 00:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-7-oupton@google.com>
 <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
In-Reply-To: <CAAeT=Fwrh5L8FNKVJipOH6a8MohRsPOgmJDhojRw8DkAS4Kk2Q@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 24 Sep 2021 00:20:31 -0700
Message-ID: <CAAeT=FxcW0+cVgfkoU8LWndxM1njC6rDhoWuL+JwXXbPRpYnyg@mail.gmail.com>
Subject: Re: [PATCH v8 6/8] KVM: arm64: Allow userspace to configure a guest's
 counter-timer offset
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Hi Oliver,

I have additional questions/comments.

> > +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> > +-----------------------------------------
> > +
> > +:Parameters: in kvm_device_attr.addr the address for the timer offset is a
> > +             pointer to a __u64
> > +
> > +Returns:
> > +
> > +        ======= ==================================
> > +        -EFAULT Error reading/writing the provided
> > +                parameter address
> > +        -ENXIO  Timer offsetting not implemented
> > +        ======= ==================================
> > +
> > +Specifies the guest's counter-timer offset from the host's virtual counter.
> > +The guest's physical counter value is then derived by the following
> > +equation:
> > +
> > +  guest_cntpct = host_cntvct - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
> > +
> > +The guest's virtual counter value is derived by the following equation:
> > +
> > +  guest_cntvct = host_cntvct - KVM_REG_ARM_TIMER_OFFSET
> > +                       - KVM_ARM_VCPU_TIMER_PHYS_OFFSET

Although KVM_REG_ARM_TIMER_OFFSET is available only if userspace
opt-in KVM_CAP_ARM_VTIMER_OFFSET, setting this attribute doesn't
depend on the capability, correct ?

> > +KVM does not allow the use of varying offset values for different vCPUs;
> > +the last written offset value will be broadcasted to all vCPUs in a VM.

What if a new vCPU is added after KVM_ARM_VCPU_TIMER_PHYS_OFFSET
is set (for other existing vCPUs) ?  Don't we want to set the offset for
the newly created vCPU as well ?

I'm a bit concerned about extra cost during Live Migration of a VM
that has large number of vCPUs if setting this is done by each vCPU
because that invokes update_timer_offset(), which sets the offset
for every vCPU that is owned by the guest holding kvm->lock,
two times (e.g. for a VM who number of vCPUs is KVM_MAX_VCPUS,
which is 512, the offset setting is done 524288 times).
Userspace can be implemented to run this just for single vCPU though.


> In my understanding, the offset that the code below specifies
> to call update_vtimer_cntvoff() is (guest's virtual counter) offset
> from the host's counter, which is always same as guest's virtual
> counter offset from the guest's physical counter-timer before this patch.
>
> int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> {
>         struct arch_timer_context *timer;
>
>         switch (regid) {
>         <...>
>         case KVM_REG_ARM_TIMER_CNT:
>                 timer = vcpu_vtimer(vcpu);
>                 update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
>                 break;
>         <...>
>
> With this patch, since the guest's counter-timer offset from the host's
> counter can be set by userspace, doesn't the code need to specify
> guest's virtual counter offset (from guest's physical counter-timer) ?


Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
