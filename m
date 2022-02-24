Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81261C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 19:48:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20A44BCDE;
	Thu, 24 Feb 2022 14:48:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YFmyP2E5QS0D; Thu, 24 Feb 2022 14:48:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D954A4BC76;
	Thu, 24 Feb 2022 14:48:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE66C4BC6B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:48:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5zpcCPgKBgoo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 14:47:59 -0500 (EST)
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com
 [209.85.166.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32EFC4BC5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 14:47:59 -0500 (EST)
Received: by mail-il1-f178.google.com with SMTP id e11so2612981ils.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bYQIbSI+0cYufItGnzrM9ro9d7yWCUyUlQcdEvQVed8=;
 b=eJ5LuaRPO2W0fHdFX4VRCntgtLxfwqyq9GTXZUXiD3CiOv9ztFrRimuW0D1IurKo+U
 dn9BrPSJG2ytIAu6scEmrBgnxr8M4QewK+VhXqGQR62qtl5pct85/1gDOIyf1hLokJpG
 YJr1uNLd1wtpQJYUoF6/Xq9ZCK1wboSrqU9YAe5CakXDWcAHZsHRAcA+DFF6m7p7FsPY
 +xWuK71h7zJlr/mP/ZQ76w5KjYoNisglVnBEiRMYQkpVQ7e7n79QGhNje4QkXJvrYmG+
 THHmOSsScuFktCWKgfq0siADTiAtkXG7K9s2SArrCu7wX1AHj3nroWbBSktsWDP2Wtvj
 ihsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bYQIbSI+0cYufItGnzrM9ro9d7yWCUyUlQcdEvQVed8=;
 b=Sy4HMBfEMNjslWuGj7P+57WZrrZfIec6aA+g2oxLZDNqTbmuiq23oWDIW5PZfsPGMG
 dbE2EARN0UhB13POPN3u6Jy/V0dr9FPRJ8jS9rhTUfihPqQp/tRyoiin5sSnoOrWpq5m
 a7fkvubGRCb4wyOOiArySe03aXQSeN3MGdx9/zpGHWOhiWAdM+HUtW4XZWagePAXuo6O
 KTnVzLF14WjkBIrHdn671wUNBpO0tkrla9WYJFgeDEGEZcGLWUS5dae+b4Eu2tHSIKOT
 bkT7MZ7tZH2LcVl6+GgdtOajJJhP3QIwc/EjyYtu1mIrpYvUu6eOVcnhD8jDGlkuisYx
 tkjw==
X-Gm-Message-State: AOAM533cqSIhJfUDJsEiV4zQqef1HsQZDxQN3YmgMwGl65toXywNePGH
 WTkn/Iy+kbAbEIdESmVyD+62wg==
X-Google-Smtp-Source: ABdhPJwCi1RoWRtIORHenxIls5RWYm2wPPjI8YXTjvK2dOdeGqsmSczDpWgDRetkOzJ45vVquD5kCg==
X-Received: by 2002:a05:6e02:17ca:b0:2c2:5709:76cf with SMTP id
 z10-20020a056e0217ca00b002c2570976cfmr3583125ilu.312.1645732078162; 
 Thu, 24 Feb 2022 11:47:58 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 17-20020a921311000000b002c25bb16970sm281260ilt.77.2022.02.24.11.47.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Feb 2022 11:47:57 -0800 (PST)
Date: Thu, 24 Feb 2022 19:47:54 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 12/19] KVM: arm64: Add support for userspace to
 suspend a vCPU
Message-ID: <Yhfg6iQ1hR9/SozK@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-13-oupton@google.com>
 <87tuco2t9q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87tuco2t9q.wl-maz@kernel.org>
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

On Thu, Feb 24, 2022 at 03:12:17PM +0000, Marc Zyngier wrote:
> On Wed, 23 Feb 2022 04:18:37 +0000,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Introduce a new MP state, KVM_MP_STATE_SUSPENDED, which indicates a vCPU
> > is in a suspended state. In the suspended state the vCPU will block
> > until a wakeup event (pending interrupt) is recognized.
> > 
> > Add a new system event type, KVM_SYSTEM_EVENT_WAKEUP, to indicate to
> > userspace that KVM has recognized one such wakeup event. It is the
> > responsibility of userspace to then make the vCPU runnable, or leave it
> > suspended until the next wakeup event.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 23 ++++++++++++++++++--
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/arm.c              | 35 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 ++
> >  4 files changed, 59 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index a4267104db50..2b4bdbc2dcc0 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1482,14 +1482,29 @@ Possible values are:
> >                                   [s390]
> >     KVM_MP_STATE_LOAD             the vcpu is in a special load/startup state
> >                                   [s390]
> > +   KVM_MP_STATE_SUSPENDED        the vcpu is in a suspend state and is waiting
> > +                                 for a wakeup event [arm/arm64]
> 
> nit: arm64 only (these are host architectures, not guest).

Roger that.

> Eventually, someone needs to do a bit of cleanup in the docs to remove
> any trace of ye olde 32bit stuff.
>

I'm just going to act like I didn't read this ;-)

> 
> >     ==========================    ===============================================
> >  
> >  On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
> >  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
> >  these architectures.
> >  
> > -For arm/arm64/riscv:
> > -^^^^^^^^^^^^^^^^^^^^
> > +For arm/arm64:
> > +^^^^^^^^^^^^^^
> > +
> > +If a vCPU is in the KVM_MP_STATE_SUSPENDED state, KVM will block the vCPU
> > +thread and wait for a wakeup event. A wakeup event is defined as a pending
> > +interrupt for the guest.
> 
> nit: a pending interrupt that the guest can actually handle (a masked
> interrupt can be pending). It'd be more accurate to describe this
> state as the architectural execution of a WFI instruction.
>

Yeah, probably better than paraphrasing.

> > +
> > +If a wakeup event is recognized, KVM will exit to userspace with a
> > +KVM_SYSTEM_EVENT exit, where the event type is KVM_SYSTEM_EVENT_WAKEUP. If
> > +userspace wants to honor the wakeup, it must set the vCPU's MP state to
> > +KVM_MP_STATE_RUNNABLE. If it does not, KVM will continue to await a wakeup
> > +event in subsequent calls to KVM_RUN.
> 
> I can see a potential 'gotcha' here. If the VMM doesn't want to set
> the vcpu as runnable, but doesn't take action on the source of the
> wake-up (masking the interrupt), you'll get an immediate wake-up event
> again. The VMM is now eating 100% of the CPU and not making forward
> progress. Luser error, but you may want to capture the failure mode
> and make it crystal clear in the doc.
> 
> It also mean that at the point where it decides to restart the guest
> for real, it must restore the interrupt state as it initially found
> it.
> 

Yeah, I had realized this when working on the series, but lazily swept
it under the rug of user error. But, it is probably better to be more
descriptive in the documentation, so I'll adopt the suggestion. Thanks!

> > +
> > +For riscv:
> > +^^^^^^^^^^
> >  
> >  The only states that are valid are KVM_MP_STATE_STOPPED and
> >  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> > @@ -5914,6 +5929,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
> >    #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> >    #define KVM_SYSTEM_EVENT_RESET          2
> >    #define KVM_SYSTEM_EVENT_CRASH          3
> > +  #define KVM_SYSTEM_EVENT_WAKEUP         4
> >  			__u32 type;
> >  			__u64 flags;
> >  		} system_event;
> > @@ -5938,6 +5954,9 @@ Valid values for 'type' are:
> >     has requested a crash condition maintenance. Userspace can choose
> >     to ignore the request, or to gather VM memory core dump and/or
> >     reset/shutdown of the VM.
> > + - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
> > +   has recognized a wakeup event. Userspace may honor this event by marking
> > +   the exiting vCPU as runnable, or deny it and call KVM_RUN again.
> >  
> >  ::
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 33ecec755310..d32cab0c9752 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -46,6 +46,7 @@
> >  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
> >  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
> >  #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
> > +#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
> >  
> >  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> >  				     KVM_DIRTY_LOG_INITIALLY_SET)
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f6ce97c0069c..d2b190f32651 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -438,6 +438,18 @@ bool kvm_arm_vcpu_powered_off(struct kvm_vcpu *vcpu)
> >  	return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED;
> >  }
> >  
> > +static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +	vcpu->arch.mp_state = KVM_MP_STATE_SUSPENDED;
> > +	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +	kvm_vcpu_kick(vcpu);
> 
> I wonder whether this kvm_vcpu_kick() is simply cargo-culted. The
> mp_state calls can only be done from the vcpu fd, and thus the vcpu
> cannot be running, so there is nothing to kick. Not a big deal, but
> something we may want to look at later on.
>

True, and hopefully this isn't an open invitation to add support for
vCPUs suspending other vCPUs, which would be a mess.

> > +}
> > +
> > +bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
> 
> static?
> 
> > +{
> > +	return vcpu->arch.mp_state == KVM_MP_STATE_SUSPENDED;
> > +}
> > +
> >  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >  				    struct kvm_mp_state *mp_state)
> >  {
> > @@ -458,6 +470,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >  	case KVM_MP_STATE_STOPPED:
> >  		kvm_arm_vcpu_power_off(vcpu);
> >  		break;
> > +	case KVM_MP_STATE_SUSPENDED:
> > +		kvm_arm_vcpu_suspend(vcpu);
> > +		break;
> >  	default:
> >  		ret = -EINVAL;
> >  	}
> > @@ -719,6 +734,23 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
> >  	preempt_enable();
> >  }
> >  
> > +static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
> > +{
> > +	if (!kvm_arm_vcpu_suspended(vcpu))
> > +		return 1;
> > +
> > +	kvm_vcpu_wfi(vcpu);
> > +
> > +	/*
> > +	 * The suspend state is sticky; we do not leave it until userspace
> > +	 * explicitly marks the vCPU as runnable. Request that we suspend again
> > +	 * later.
> > +	 */
> > +	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
> > +	kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_WAKEUP);
> > +	return 0;
> > +}
> > +
> >  /**
> >   * check_vcpu_requests - check and handle pending vCPU requests
> >   * @vcpu:	the VCPU pointer
> > @@ -757,6 +789,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> >  			kvm_pmu_handle_pmcr(vcpu,
> >  					    __vcpu_sys_reg(vcpu, PMCR_EL0));
> > +
> > +		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > +			return kvm_vcpu_suspend(vcpu);
> >  	}
> >  
> >  	return 1;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 5191b57e1562..babb16c2abe5 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -444,6 +444,7 @@ struct kvm_run {
> >  #define KVM_SYSTEM_EVENT_SHUTDOWN       1
> >  #define KVM_SYSTEM_EVENT_RESET          2
> >  #define KVM_SYSTEM_EVENT_CRASH          3
> > +#define KVM_SYSTEM_EVENT_WAKEUP         4
> >  			__u32 type;
> >  			__u64 flags;
> >  		} system_event;
> > @@ -634,6 +635,7 @@ struct kvm_vapic_addr {
> >  #define KVM_MP_STATE_OPERATING         7
> >  #define KVM_MP_STATE_LOAD              8
> >  #define KVM_MP_STATE_AP_RESET_HOLD     9
> > +#define KVM_MP_STATE_SUSPENDED         10
> >  
> >  struct kvm_mp_state {
> >  	__u32 mp_state;
> 
> This patch looks OK as is, but it is the interactions with PSCI that
> concern me. What we have here is per-CPU suspend triggered by
> userspace. PSCI OTOH offers two variants of suspend triggered by the
> guest. All of them get different implementations, and I have a hard
> time figuring out how they all interact...

Yeah, all of this suspend logic could become a tangle.

There is likely an opportunity to share some bits between CPU_SUSPEND
and SYSTEM_SUSPEND, but userspace-directed suspends are different enough
that it warrants a different implmentation.

Thanks again for the review!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
