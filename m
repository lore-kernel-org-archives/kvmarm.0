Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707C0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 19:35:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5DD54BA40;
	Thu, 24 Feb 2022 14:35:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iWrIzx4p4LDd; Thu, 24 Feb 2022 14:35:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FAB14B95E;
	Thu, 24 Feb 2022 14:35:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B600640096
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:35:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z2yvNC3KiNMo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 14:35:38 -0500 (EST)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 425F84BBE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:35:38 -0500 (EST)
Received: by mail-il1-f172.google.com with SMTP id z7so2570988ilb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nhX3bsgpSDyttb54655oQihTzzAj4GP6gmlwB+g2+XU=;
 b=npt5FKr2XpSxwA7sZmT2ddB61OwNxFOyr3+/FXeYQNRnR1oW8Y1dFHHWbz1/Ppa5C6
 GyylKF/3cCFL2kNt8zNbFRz7zfMn/9+bkcKjXEXjyf3ZdUTE6t0Wh2FZ6aipgmbwwl6G
 BJUooKVDLML2H/Y1q3mzCarwNOqIFe0Ju7FaYiNQFQ2w5/xx1PKBFkQWcGHlBncWODIn
 8uHuupKUAm522TKMXZwSuX4d9zvJH0cRrvvBsMaaUJ089uRfxVwoucU7KF+7ApTQoTpC
 BOqBjO9N9vIQgjlGr+GCG5l5rNyzYMZIFEWWkUJDPdlh4yKu0ylQWGq10JdVnVd4PObE
 Otjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nhX3bsgpSDyttb54655oQihTzzAj4GP6gmlwB+g2+XU=;
 b=LYc+NlAvmyn4z+GeSXC2VFj34nIJzVgyIMXGd35cvFp/YI7+cM3b37ZJzmzQkWrP6Z
 BIojKpFLiYGL9nCW3ol0bABU1Kjzi7VjRfSLXBcbhUvqlESBCTTbhYhW3IauI9Iq1Rao
 B+T9oVD6l5jfDO/gi5Ipx3Sd9G53KHG5+33l52aglL8no2SrMOO4FY/kslR73FJOAmoa
 SnXC9hET/iOojc/axR9mDpObzPV1JzCETFqV7O8t8dqCth5LA8dD3PuKlqlixWykd71l
 40iQ0lTqkAK9OZCdv5g4kYzAzbAQYhSQECzbVbVjsA9paSvxM+tniT8LoFa+Zvv9mion
 +0zw==
X-Gm-Message-State: AOAM5317xsDJzdH7CsrGxY3Cw2RYSOpRE8g6G9kBF36IeeEDiG22p8Ip
 2epAgXx4AD2qjwuRKPg1dIzucQ==
X-Google-Smtp-Source: ABdhPJycwpD6mXs4gDPbvHxlvan4Cix0pIzqdjhyt1BYJVKfcy2+h/UY61uiRrBXWobwtcCTXb8Z9w==
X-Received: by 2002:a05:6e02:1c28:b0:2bf:4c8a:6207 with SMTP id
 m8-20020a056e021c2800b002bf4c8a6207mr3328664ilh.249.1645731337242; 
 Thu, 24 Feb 2022 11:35:37 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 v3-20020a5d9483000000b00640d3d4acabsm281032ioj.44.2022.02.24.11.35.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Feb 2022 11:35:36 -0800 (PST)
Date: Thu, 24 Feb 2022 19:35:33 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 09/19] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
Message-ID: <YhfeBfgbDA8IGc9f@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-10-oupton@google.com>
 <87wnhk2whx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87wnhk2whx.wl-maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Thanks for reviewing the series. ACK to the nits and smaller comments
you've made, I'll incorporate that feedback in the next series.

On Thu, Feb 24, 2022 at 02:02:34PM +0000, Marc Zyngier wrote:
> On Wed, 23 Feb 2022 04:18:34 +0000,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
> > software to request that a system be placed in the deepest possible
> > low-power state. Effectively, software can use this to suspend itself to
> > RAM. Note that the semantics of this PSCI call are very similar to
> > CPU_SUSPEND, which is already implemented in KVM.
> > 
> > Implement the SYSTEM_SUSPEND in KVM. Similar to CPU_SUSPEND, the
> > low-power state is implemented as a guest WFI. Synchronously reset the
> > calling CPU before entering the WFI, such that the vCPU may immediately
> > resume execution when a wakeup event is recognized.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/psci.c  | 51 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c |  3 ++-
> >  2 files changed, 53 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 77a00913cdfd..41adaaf2234a 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -208,6 +208,50 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
> >  	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
> >  }
> >  
> > +static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_reset_state reset_state;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct kvm_vcpu *tmp;
> > +	bool denied = false;
> > +	unsigned long i;
> > +
> > +	reset_state.pc = smccc_get_arg1(vcpu);
> > +	if (!kvm_ipa_valid(kvm, reset_state.pc)) {
> > +		smccc_set_retval(vcpu, PSCI_RET_INVALID_ADDRESS, 0, 0, 0);
> > +		return 1;
> > +	}
> > +
> > +	reset_state.r0 = smccc_get_arg2(vcpu);
> > +	reset_state.be = kvm_vcpu_is_be(vcpu);
> > +	reset_state.reset = true;
> > +
> > +	/*
> > +	 * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
> > +	 * calling vCPU) be in an OFF state, as determined by the
> > +	 * implementation.
> > +	 *
> > +	 * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
> > +	 */
> > +	mutex_lock(&kvm->lock);
> > +	kvm_for_each_vcpu(i, tmp, kvm) {
> > +		if (tmp != vcpu && !kvm_arm_vcpu_powered_off(tmp)) {
> > +			denied = true;
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&kvm->lock);
> 
> This looks dodgy. Nothing seems to prevent userspace from setting the
> mp_state to RUNNING in parallel with this, as only the vcpu mutex is
> held when this ioctl is issued.
> 
> It looks to me that what you want is what lock_all_vcpus() does
> (Alexandru has a patch moving it out of the vgic code as part of his
> SPE series).
> 
> It is also pretty unclear what the interaction with userspace is once
> you have released the lock. If the VMM starts a vcpu other than the
> suspending one, what is its state? The spec doesn't see to help
> here. I can see two options:
> 
> - either all the vcpus have the same reset state applied to them as
>   they come up, unless they are started with CPU_ON by a vcpu that has
>   already booted (but there is a single 'context_id' provided, and I
>   fear this is going to confuse the OS)...
> 
> - or only the suspending vcpu can resume the system, and we must fail
>   a change of mp_state for the other vcpus.
> 
> What do you think?

Definitely the latter. The documentation of SYSTEM_SUSPEND is quite
shaky on this, but it would appear that the intention is for the caller
to be the first CPU to wake up.

> > +
> > +	if (denied) {
> > +		smccc_set_retval(vcpu, PSCI_RET_DENIED, 0, 0, 0);
> > +		return 1;
> > +	}
> > +
> > +	__kvm_reset_vcpu(vcpu, &reset_state);
> > +	kvm_vcpu_wfi(vcpu);
> 
> I have mixed feelings about this. The vcpu has reset before being in
> WFI, while it really should be the other way around and userspace
> could rely on observing the transition.
> 
> What breaks if you change this?

I don't think that userspace would be able to observe the transition
even if we WFI before the reset. I imagine that would take the form
of setting KVM_REQ_VCPU_RESET, which we explicitly handle before
letting userspace access the vCPU's state as of commit
6826c6849b46 ("KVM: arm64: Handle PSCI resets before userspace
touches vCPU state").

Given this, I felt it was probably best to avoid all the indirection and
just do the vCPU reset in the handling of SYSTEM_SUSPEND. It does,
however, imply that we have slightly different behavior when userspace
exits are enabled, as that will happen pre-reset and pre-WFI.

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
