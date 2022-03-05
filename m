Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D2EC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  5 Mar 2022 02:47:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E04549E1A;
	Fri,  4 Mar 2022 21:47:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RMVmlK+5ODds; Fri,  4 Mar 2022 21:47:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BB2D411C7;
	Fri,  4 Mar 2022 21:47:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B65140BDC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 21:47:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v4iDPIamNRpx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Mar 2022 21:47:37 -0500 (EST)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB66C408AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Mar 2022 21:47:36 -0500 (EST)
Received: by mail-pg1-f174.google.com with SMTP id o8so8983405pgf.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Mar 2022 18:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:from:subject:to:cc
 :references:content-language:in-reply-to:content-transfer-encoding;
 bh=LVjEuXC4rM+M4KlBcuViREGDCqC/LjjwgQGBbeoRrtI=;
 b=rECfhM1P/3mpDuzhKSLP/02SrnsOWf+Ner+ol+IBbVSbLhw9RIUH41vuQMwM8iymyM
 6mmMFsaybxhYERMmGO8XojS1NadDbs2k9CNX1JggkQTLXHGIt5jbYbTjmdBTyGi97M29
 2IBxAgjVPpckQcudz7fTMtq1V9PoD/HNJIeRaQShmrKpdWYbqTYTwU07jik6aRXAb4uS
 hSVzknUaReW4wRrLp/rQxmi+TCOqBH+pCVnPdyVOZ/AHfRKo08xxr1+a/w5llLa8WpFZ
 FxQSKOs4Dqv3J+3hy6dkHfjtv2ml5km8uv5kOjrc0qPaxdEQsXuDhI5ZvnY4dNHIF871
 fjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:from
 :subject:to:cc:references:content-language:in-reply-to
 :content-transfer-encoding;
 bh=LVjEuXC4rM+M4KlBcuViREGDCqC/LjjwgQGBbeoRrtI=;
 b=tUWjYzH/vcbC41j1gHA2LF65OG7l2euozW+qTPqJf14I0Yu1d25GaPdo7AdASrplF2
 yLly6wrpQMSH2A9xksrM5ts9xav/uda3ZPQBlt/TOCwWwnB+202QcNHQkTxea+jKvmy4
 bNM6PLKE9YAIVl4afcA+tkuiq+EV+G1VnqN22Owghicx/bhcPp+v+OoTAqACqaOAUdO1
 GErXZJDO3tzM/nrR7pyHFcvyggzB7oYByapC0eXlqjzoTRpHy1bGR1HDFWve9aJOJhn3
 s5Pg1rfs5xSV+NbIxymkC9Qw8+gY4WKGyfJAjcZPFQynM3K8xo8Je6BsFQ8FsU3d2w+F
 3O+A==
X-Gm-Message-State: AOAM532DhZ/BddxdwXQQKjEyjLgcem/2vy+9CZxrXBrbTj/39gU+aEfa
 VRKap4ZzZqaPC6MXOvOV2SECIQ==
X-Google-Smtp-Source: ABdhPJw0F7hYBQfsOlSn+F80ZnjIPIoHv31d+LYnxtNuPGlDmf1W8AVncrc0bl/870kVMdVLmt8Q2g==
X-Received: by 2002:a05:6a00:2348:b0:4f3:bfcd:8365 with SMTP id
 j8-20020a056a00234800b004f3bfcd8365mr1884832pfj.38.1646448455704; 
 Fri, 04 Mar 2022 18:47:35 -0800 (PST)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 c18-20020a056a000ad200b004cdccd3da08sm7198756pfl.44.2022.03.04.18.47.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Mar 2022 18:47:35 -0800 (PST)
Message-ID: <5394e049-38a0-bf00-64e9-0728901d44ed@google.com>
Date: Fri, 4 Mar 2022 18:47:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/3] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To: Marc Zyngier <maz@kernel.org>
References: <20220303035408.3708241-1-reijiw@google.com>
 <20220303035408.3708241-2-reijiw@google.com> <87tucf10fg.wl-maz@kernel.org>
 <75e90ab4-141f-21a8-1559-f792b84d60fa@google.com>
 <87mti522ax.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <87mti522ax.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Fri, Mar 4, 2022 at 6:57 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 04 Mar 2022 08:00:20 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > > +{
> > > > +     bool is32bit;
> > > > +     bool allowed = true;
> > > > +     struct kvm *kvm = vcpu->kvm;
> > > > +
> > > > +     is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> > > > +
> > > > +     mutex_lock(&kvm->lock);
> > > > +
> > > > +     if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
> > > > +             allowed = (is32bit ==
> > > > +                        test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
> > > > +     } else {
> > > > +             if (is32bit)
> > > > +                     set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
> > >
> > > nit: probably best written as:
> > >
> > >                 __assign_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags, is32bit);
> > >
> > > > +
> > > > +             set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
> > >
> > > Since this is only ever set whilst holding the lock, you can user the
> > > __set_bit() version.
> >
> > Thank you for the proposal. But since other CPUs could attempt
> > to set other bits without holding the lock, I don't think we
> > can use the non-atomic version here.
>
> Ah, good point. Keep the atomic accesses then.
>
> >
> > >
> > > > +     }
> > > > +
> > > > +     mutex_unlock(&kvm->lock);
> > > > +
> > > > +     return allowed ? 0 : -EINVAL;
> > > > +}
> > > > +
> > > >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> > > >                              const struct kvm_vcpu_init *init)
> > > >  {
> > > > @@ -1140,6 +1177,10 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> > > >
> > > >       /* Now we know what it is, we can reset it. */
> > > >       ret = kvm_reset_vcpu(vcpu);
> > > > +
> > > > +     if (!ret)
> > > > +             ret = kvm_register_width_check_or_init(vcpu);
> > >
> > > Why is that called *after* resetting the vcpu, which itself relies on
> > > KVM_ARM_VCPU_EL1_32BIT, which we agreed to get rid of as much as
> > > possible?
> >
> > That's because I didn't want to set EL1_32BIT/REG_WIDTH_CONFIGURED
> > for the guest based on the vCPU for which KVM_ARM_VCPU_INIT would fail.
> > The flags can be set in the kvm_reset_vcpu() and cleared in
> > case of failure.  But then that temporary value could lead
> > KVM_ARM_VCPU_INIT for other vCPUs to fail, which I don't think
> > is nice to do.
>
> But it also means that userspace is trying to create incompatible
> vcpus concurrently. Why should we care? We shouldn't even consider
> resetting the flags on failure, as userspace has already indicated its
> intention to create a 32 or 64bit VM.


Right, I understand it won't practically matter:)
I will fix the code to set the flags based on the first vCPU that calls
kvm_reset_vcpu() (and keep the flags even if kvm_reset_vcpu() fails).

Thank you!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
