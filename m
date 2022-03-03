Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5554FC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  3 Mar 2022 01:01:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCDE40BE7;
	Wed,  2 Mar 2022 20:01:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cGe9dC3M+O6Q; Wed,  2 Mar 2022 20:01:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF2F43C96;
	Wed,  2 Mar 2022 20:01:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1A243C8C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 20:01:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iA-McRKFvVsS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 20:01:45 -0500 (EST)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DBAC40BED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 20:01:45 -0500 (EST)
Received: by mail-il1-f176.google.com with SMTP id h28so2839097ila.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 17:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bw/3FwLAZ/97IOiQ/OlX0pek7atqWiYa92rf2xXeE3c=;
 b=bnX45XwZIe5Igz+UbKzuLRzvCiCmdc1JYid8Mwhq3QcQ8mg70E0i8I2yftkscMZ1ew
 OUkFL8KWuyDQ+KlDoyqz+TWopkATcRwge/wWFy9kAwniBFa3bQRZeRG4Uqsho0A4iPK9
 n9XmBZIy3U33YXbSUxRFud8UcfH0IrLXLSqD5VkBPPG+2gQ4xH33t9M3fDMPzD07E+ej
 Ke0k2wN01Tqqzi8sAjCj9aGc3dEKRr/i5IoJ67c8f4Ef/qu4+f6OCvOVVW5XJriV9bFy
 z0MaVqmEQTv4DFcotPWY188pmlJGUJoxGTginjYvZwYoD75u1lD6kFJ368nX+eD96iKj
 +Z7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bw/3FwLAZ/97IOiQ/OlX0pek7atqWiYa92rf2xXeE3c=;
 b=G/b+4imqf3IzseJURSYxXEhGtLmRfgnNBgjGVF5DEN9QEzlp9NT9Z4/zA96YkeFWXN
 2i5I3b7Z53iq955TQooGvba+uvsWnid0e7oGy7Tv2YhFIOi+q9J0J8hJ2x7zeBclDVZo
 U3kdRuPsXdJHv2eMDzS6Pu7CwCvq6+5a6spz8B70/uv4FUzv95yBTM7u4dx3KW+YlFj4
 gWmqc7o8GRQKEh2xgOlaJwg7OrOTDsGywunL2GWJCO//MKTg1byqMMowRAO2pz9jNoX4
 dBwrCRKSYNX1QOg5CsesgsP91llwOnczztCYyHqSW2x2SWtsE6ZxMq4EP+A1PBbrvzn5
 ASOw==
X-Gm-Message-State: AOAM532FnoEZ3RPgKUOSakYcnxrydu/hTi5ufNM9KBpuPfeAoExTBE+C
 AsnQdZ3B3bGcOdfEdbXrj0fvEA==
X-Google-Smtp-Source: ABdhPJwcOV1qGqUMFYUQMeUuJBpzh80qLtx6g2iKgk6nHuDgUKpkvy8bueiDtmQN2/wdeS2qAaWYCQ==
X-Received: by 2002:a05:6e02:1445:b0:2c2:ea36:dcab with SMTP id
 p5-20020a056e02144500b002c2ea36dcabmr15849971ilo.200.1646269304472; 
 Wed, 02 Mar 2022 17:01:44 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d5-20020a056e021c4500b002c569b47329sm389404ilg.60.2022.03.02.17.01.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Mar 2022 17:01:43 -0800 (PST)
Date: Thu, 3 Mar 2022 01:01:40 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 09/19] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
Message-ID: <YiATdBvHOvlTzhIF@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-10-oupton@google.com>
 <87wnhk2whx.wl-maz@kernel.org> <YhfeBfgbDA8IGc9f@google.com>
 <87fso63ha2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fso63ha2.wl-maz@kernel.org>
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

On Fri, Feb 25, 2022 at 06:58:13PM +0000, Marc Zyngier wrote:
> On Thu, 24 Feb 2022 19:35:33 +0000,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Hi Marc,
> > 
> > Thanks for reviewing the series. ACK to the nits and smaller comments
> > you've made, I'll incorporate that feedback in the next series.
> > 
> > On Thu, Feb 24, 2022 at 02:02:34PM +0000, Marc Zyngier wrote:
> > > On Wed, 23 Feb 2022 04:18:34 +0000,
> > > Oliver Upton <oupton@google.com> wrote:
> > > > 
> > > > ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND" describes a PSCI call that allows
> > > > software to request that a system be placed in the deepest possible
> > > > low-power state. Effectively, software can use this to suspend itself to
> > > > RAM. Note that the semantics of this PSCI call are very similar to
> > > > CPU_SUSPEND, which is already implemented in KVM.
> > > > 
> > > > Implement the SYSTEM_SUSPEND in KVM. Similar to CPU_SUSPEND, the
> > > > low-power state is implemented as a guest WFI. Synchronously reset the
> > > > calling CPU before entering the WFI, such that the vCPU may immediately
> > > > resume execution when a wakeup event is recognized.
> > > > 
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  arch/arm64/kvm/psci.c  | 51 ++++++++++++++++++++++++++++++++++++++++++
> > > >  arch/arm64/kvm/reset.c |  3 ++-
> > > >  2 files changed, 53 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 77a00913cdfd..41adaaf2234a 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -208,6 +208,50 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
> > > >  	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
> > > >  }
> > > >  
> > > > +static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct vcpu_reset_state reset_state;
> > > > +	struct kvm *kvm = vcpu->kvm;
> > > > +	struct kvm_vcpu *tmp;
> > > > +	bool denied = false;
> > > > +	unsigned long i;
> > > > +
> > > > +	reset_state.pc = smccc_get_arg1(vcpu);
> > > > +	if (!kvm_ipa_valid(kvm, reset_state.pc)) {
> > > > +		smccc_set_retval(vcpu, PSCI_RET_INVALID_ADDRESS, 0, 0, 0);
> > > > +		return 1;
> > > > +	}
> > > > +
> > > > +	reset_state.r0 = smccc_get_arg2(vcpu);
> > > > +	reset_state.be = kvm_vcpu_is_be(vcpu);
> > > > +	reset_state.reset = true;
> > > > +
> > > > +	/*
> > > > +	 * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
> > > > +	 * calling vCPU) be in an OFF state, as determined by the
> > > > +	 * implementation.
> > > > +	 *
> > > > +	 * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
> > > > +	 */
> > > > +	mutex_lock(&kvm->lock);
> > > > +	kvm_for_each_vcpu(i, tmp, kvm) {
> > > > +		if (tmp != vcpu && !kvm_arm_vcpu_powered_off(tmp)) {
> > > > +			denied = true;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +	mutex_unlock(&kvm->lock);
> > > 
> > > This looks dodgy. Nothing seems to prevent userspace from setting the
> > > mp_state to RUNNING in parallel with this, as only the vcpu mutex is
> > > held when this ioctl is issued.
> > > 
> > > It looks to me that what you want is what lock_all_vcpus() does
> > > (Alexandru has a patch moving it out of the vgic code as part of his
> > > SPE series).
> > > 
> > > It is also pretty unclear what the interaction with userspace is once
> > > you have released the lock. If the VMM starts a vcpu other than the
> > > suspending one, what is its state? The spec doesn't see to help
> > > here. I can see two options:
> > > 
> > > - either all the vcpus have the same reset state applied to them as
> > >   they come up, unless they are started with CPU_ON by a vcpu that has
> > >   already booted (but there is a single 'context_id' provided, and I
> > >   fear this is going to confuse the OS)...
> > > 
> > > - or only the suspending vcpu can resume the system, and we must fail
> > >   a change of mp_state for the other vcpus.
> > > 
> > > What do you think?
> > 
> > Definitely the latter. The documentation of SYSTEM_SUSPEND is quite
> > shaky on this, but it would appear that the intention is for the caller
> > to be the first CPU to wake up.
> 
> Yup. We now have clarification on the intent of the spec (only the
> caller CPU can resume the system), and this needs to be tightened.
> 

I'm beginning to wonder if the VMM/KVM split implementation of
system-scoped PSCI calls can ever be right. There exists a critical
section in all system-wide PSCI calls that currently spans an exit to
userspace. I cannot devise a sane way to guard such a critical section
when we are returning control to userspace.

For example, KVM offlines all of the CPUs except for the exiting CPU
when handling SYSTEM_RESET or SYSTEM_OFF, but nothing prevents an
interleaving KVM_ARM_VCPU_INIT or KVM_SET_MP_STATE from disturbing the
state of the VM. Couldn't even say its a userspace bug, either, because
a different vCPU could do something before the caller has exited. Even
if we grab all the vCPU mutexes, we'd need to drop them before exiting
to userspace.

If userspace decides to reject the PSCI call, we're giving control
back to the guest in a wildly different state than it had making the
PSCI call. Again, the PSCI spec is vague on this matter, but I believe
the intuitive answer is that we should not change the VM state if the call
is rejected. This could upset an otherwise well-behaved KVM guest.

Doing SYSTEM_SUSPEND in userspace is better, as KVM avoids mucking with
the VM state before the PSCI call is actually accepted. However, any of
the consistency checks in the kernel for SYSTEM_SUSPEND are entirely
moot. Anything can happen between the exit to userspace and the moment
userspace actually recognizes the SYSTEM_SUSPEND call on the exiting
CPU.

KVM rejecting attempts to resume vCPUs besides the caller will break
a correct userspace, given the inherent race that crops up when exiting.
Blocking attempts to resume other vCPUs could have unintented
consequences as well. It seems that we'd need to prevent
KVM_ARM_VCPU_INIT calls as well as KVM_SET_MP_STATE, even though the
former could be used in a valid SYSTEM_SUSPEND implementation.

I really do hate to go back to the drawing board on the PSCI stuff
again, but there seems to be a fundamental issue in how system-scoped
calls are handled. Userspace is probably the only place where we could
quiesce the VM state, assess if the PSCI call should be accepted, and
change the VM state.

Do you think all of this is an issue as well?

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
