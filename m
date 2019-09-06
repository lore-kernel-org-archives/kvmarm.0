Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBA3C43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 07:58:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A877E2082C
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 07:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A877E2082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B7A4A5BB;
	Fri,  6 Sep 2019 03:58:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xdTyiWD87WCM; Fri,  6 Sep 2019 03:58:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F9A34A5A4;
	Fri,  6 Sep 2019 03:58:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 941AA4A59A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 03:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MT7-GpuTh8oC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 03:58:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E014A56C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 03:58:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 206E928;
 Fri,  6 Sep 2019 00:58:23 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A78CE3F718;
 Fri,  6 Sep 2019 00:58:22 -0700 (PDT)
Date: Fri, 6 Sep 2019 09:58:21 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
Message-ID: <20190906075821.GE4320@e113682-lin.lund.arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
 <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
 <20190905092223.GC4320@e113682-lin.lund.arm.com>
 <27e7edd6-1c4f-c970-3395-ecb4f176f858@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <27e7edd6-1c4f-c970-3395-ecb4f176f858@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Thu, Sep 05, 2019 at 03:25:47PM +0200, Heinrich Schuchardt wrote:
> On 9/5/19 11:22 AM, Christoffer Dall wrote:
> > On Thu, Sep 05, 2019 at 09:56:44AM +0100, Peter Maydell wrote:
> > > On Thu, 5 Sep 2019 at 09:52, Marc Zyngier <maz@kernel.org> wrote:
> > > > 
> > > > On Thu, 05 Sep 2019 09:16:54 +0100,
> > > > Peter Maydell <peter.maydell@linaro.org> wrote:
> > > > > This is true, but the problem is that barfing out to userspace
> > > > > makes it harder to debug the guest because it means that
> > > > > the VM is immediately destroyed, whereas AIUI if we
> > > > > inject some kind of exception then (assuming you're set up
> > > > > to do kernel-debug via gdbstub) you can actually examine
> > > > > the offending guest code with a debugger because at least
> > > > > your VM is still around to inspect...
> > > > 
> > > > To Christoffer's point, I find the benefit a bit dubious. Yes, you get
> > > > an exception, but the instruction that caused it may be completely
> > > > legal (store with post-increment, for example), leading to an even
> > > > more puzzled developer (that exception should never have been
> > > > delivered the first place).
> > > 
> > > Right, but the combination of "host kernel prints a message
> > > about an unsupported load/store insn" and "within-guest debug
> > > dump/stack trace/etc" is much more useful than just having
> > > "host kernel prints message" and "QEMU exits"; and it requires
> > > about 3 lines of code change...
> > > 
> > > > I'm far more in favour of dumping the state of the access in the run
> > > > structure (much like we do for a MMIO access) and let userspace do
> > > > something about it (such as dumping information on the console or
> > > > breaking). It could even inject an exception *if* the user has asked
> > > > for it.
> > > 
> > > ...whereas this requires agreement on a kernel-userspace API,
> > > larger changes in the kernel, somebody to implement the userspace
> > > side of things, and the user to update both the kernel and QEMU.
> > > It's hard for me to see that the benefit here over the 3-line
> > > approach really outweighs the extra effort needed. In practice
> > > saying "we should do this" is saying "we're going to do nothing",
> > > based on the historical record.
> > > 
> > 
> > How about something like the following (completely untested, liable for
> > ABI discussions etc. etc., but for illustration purposes).
> > 
> > I think it raises the question (and likely many other) of whether we can
> > break the existing 'ABI' and change behavior for missing ISV
> > retrospectively for legacy user space when the issue has occurred?
> > 
> > Someone might have written code that reacts to the -ENOSYS, so I've
> > taken the conservative approach for this for the time being.
> > 
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 8a37c8e89777..19a92c49039c 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -76,6 +76,14 @@ struct kvm_arch {
> > 
> >   	/* Mandated version of PSCI */
> >   	u32 psci_version;
> > +
> > +	/*
> > +	 * If we encounter a data abort without valid instruction syndrome
> > +	 * information, report this to user space.  User space can (and
> > +	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
> > +	 * supported.
> > +	 */
> > +	bool return_nisv_io_abort_to_user;
> >   };
> > 
> >   #define KVM_NR_MEM_OBJS     40
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f656169db8c3..019bc560edc1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -83,6 +83,14 @@ struct kvm_arch {
> > 
> >   	/* Mandated version of PSCI */
> >   	u32 psci_version;
> > +
> > +	/*
> > +	 * If we encounter a data abort without valid instruction syndrome
> > +	 * information, report this to user space.  User space can (and
> > +	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
> > +	 * supported.
> > +	 */
> > +	bool return_nisv_io_abort_to_user;
> 
> How about 32bit ARM?
> 

What about it?  Not sure I understand the comment.

> >   };
> > 
> >   #define KVM_NR_MEM_OBJS     40
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 5e3f12d5359e..a4dd004d0db9 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
> >   #define KVM_EXIT_S390_STSI        25
> >   #define KVM_EXIT_IOAPIC_EOI       26
> >   #define KVM_EXIT_HYPERV           27
> > +#define KVM_EXIT_ARM_NISV         28
> > 
> >   /* For KVM_EXIT_INTERNAL_ERROR */
> >   /* Emulate instruction failed. */
> > @@ -996,6 +997,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
> >   #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> >   #define KVM_CAP_PMU_EVENT_FILTER 173
> > +#define KVM_CAP_ARM_NISV_TO_USER 174
> > 
> >   #ifdef KVM_CAP_IRQ_ROUTING
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 35a069815baf..2ce94bd9d4a9 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -98,6 +98,26 @@ int kvm_arch_check_processor_compat(void)
> >   	return 0;
> >   }
> > 
> > +int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > +			    struct kvm_enable_cap *cap)
> 
> This overrides the weak implementation in virt/kvm/kvm_main.c. OK.
> 

Yes.

> > +{
> > +	int r;
> > +
> > +	if (cap->flags)
> > +		return -EINVAL;
> > +
> > +	switch (cap->cap) {
> > +	case KVM_CAP_ARM_NISV_TO_USER:
> > +		r = 0;
> > +		kvm->arch.return_nisv_io_abort_to_user = true;
> > +		break;
> > +	default:
> > +		r = -EINVAL;
> > +		break;
> > +	}
> > +
> > +	return r;
> > +}
> > 
> >   /**
> >    * kvm_arch_init_vm - initializes a VM data structure
> > @@ -196,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   	case KVM_CAP_MP_STATE:
> >   	case KVM_CAP_IMMEDIATE_EXIT:
> >   	case KVM_CAP_VCPU_EVENTS:
> > +	case KVM_CAP_ARM_NISV_TO_USER:
> >   		r = 1;
> >   		break;
> >   	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> > @@ -673,6 +694,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >   		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> >   		if (ret)
> >   			return ret;
> > +	} else if (run->exit_reason == KVM_EXIT_ARM_NISV) {
> > +		kvm_inject_undefined(vcpu);
> 
> So QEMU can try to enable the feature via IOCTL. And here you would
> raise the 'undefined instruction' exception which QEMU will have to
> handle in the loop calling KVM either by trying to make sense of the
> instruction or by passing it on to the guest.
> 
> Conceptually this looks good to me and meets the requirements of my
> application.
> 
> Thanks a lot for your suggestion.
> 

I will change the undef to an external abort as I think that's more in
line with the architecture, and document this, test and send out as a
proper patch.

Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
