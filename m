Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE441C43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:13:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50904206BB
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50904206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80E764A5AF;
	Fri,  6 Sep 2019 09:13:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qO1oWGxkldDc; Fri,  6 Sep 2019 09:12:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D714F4A5A4;
	Fri,  6 Sep 2019 09:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 735D54A59A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wjyHym2IeYbv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 09:12:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87D34A533
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:12:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4228E1570;
 Fri,  6 Sep 2019 06:12:54 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C93953F718;
 Fri,  6 Sep 2019 06:12:53 -0700 (PDT)
Date: Fri, 6 Sep 2019 15:12:52 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
Message-ID: <20190906131252.GG4320@e113682-lin.lund.arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
 <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
 <20190905092223.GC4320@e113682-lin.lund.arm.com>
 <4b6662bd-56e4-3c10-3b65-7c90828a22f9@kernel.org>
 <20190906080033.GF4320@e113682-lin.lund.arm.com>
 <a58c5f76-641a-8381-2cf3-e52d139c4236@amazon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a58c5f76-641a-8381-2cf3-e52d139c4236@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 06, 2019 at 02:08:15PM +0200, Alexander Graf wrote:
> 
> 
> On 06.09.19 10:00, Christoffer Dall wrote:
> > On Thu, Sep 05, 2019 at 02:09:18PM +0100, Marc Zyngier wrote:
> > > On 05/09/2019 10:22, Christoffer Dall wrote:
> > > > On Thu, Sep 05, 2019 at 09:56:44AM +0100, Peter Maydell wrote:
> > > > > On Thu, 5 Sep 2019 at 09:52, Marc Zyngier <maz@kernel.org> wrote:
> > > > > > 
> > > > > > On Thu, 05 Sep 2019 09:16:54 +0100,
> > > > > > Peter Maydell <peter.maydell@linaro.org> wrote:
> > > > > > > This is true, but the problem is that barfing out to userspace
> > > > > > > makes it harder to debug the guest because it means that
> > > > > > > the VM is immediately destroyed, whereas AIUI if we
> > > > > > > inject some kind of exception then (assuming you're set up
> > > > > > > to do kernel-debug via gdbstub) you can actually examine
> > > > > > > the offending guest code with a debugger because at least
> > > > > > > your VM is still around to inspect...
> > > > > > 
> > > > > > To Christoffer's point, I find the benefit a bit dubious. Yes, you get
> > > > > > an exception, but the instruction that caused it may be completely
> > > > > > legal (store with post-increment, for example), leading to an even
> > > > > > more puzzled developer (that exception should never have been
> > > > > > delivered the first place).
> > > > > 
> > > > > Right, but the combination of "host kernel prints a message
> > > > > about an unsupported load/store insn" and "within-guest debug
> > > > > dump/stack trace/etc" is much more useful than just having
> > > > > "host kernel prints message" and "QEMU exits"; and it requires
> > > > > about 3 lines of code change...
> > > > > 
> > > > > > I'm far more in favour of dumping the state of the access in the run
> > > > > > structure (much like we do for a MMIO access) and let userspace do
> > > > > > something about it (such as dumping information on the console or
> > > > > > breaking). It could even inject an exception *if* the user has asked
> > > > > > for it.
> > > > > 
> > > > > ...whereas this requires agreement on a kernel-userspace API,
> > > > > larger changes in the kernel, somebody to implement the userspace
> > > > > side of things, and the user to update both the kernel and QEMU.
> > > > > It's hard for me to see that the benefit here over the 3-line
> > > > > approach really outweighs the extra effort needed. In practice
> > > > > saying "we should do this" is saying "we're going to do nothing",
> > > > > based on the historical record.
> > > > > 
> > > > 
> > > > How about something like the following (completely untested, liable for
> > > > ABI discussions etc. etc., but for illustration purposes).
> > > > 
> > > > I think it raises the question (and likely many other) of whether we can
> > > > break the existing 'ABI' and change behavior for missing ISV
> > > > retrospectively for legacy user space when the issue has occurred?
> > > > Someone might have written code that reacts to the -ENOSYS, so I've
> > > > taken the conservative approach for this for the time being.
> > > > 
> > > > 
> > > > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > > > index 8a37c8e89777..19a92c49039c 100644
> > > > --- a/arch/arm/include/asm/kvm_host.h
> > > > +++ b/arch/arm/include/asm/kvm_host.h
> > > > @@ -76,6 +76,14 @@ struct kvm_arch {
> > > >   	/* Mandated version of PSCI */
> > > >   	u32 psci_version;
> > > > +
> > > > +	/*
> > > > +	 * If we encounter a data abort without valid instruction syndrome
> > > > +	 * information, report this to user space.  User space can (and
> > > > +	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
> > > > +	 * supported.
> > > > +	 */
> > > > +	bool return_nisv_io_abort_to_user;
> > > >   };
> > > >   #define KVM_NR_MEM_OBJS     40
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index f656169db8c3..019bc560edc1 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -83,6 +83,14 @@ struct kvm_arch {
> > > >   	/* Mandated version of PSCI */
> > > >   	u32 psci_version;
> > > > +
> > > > +	/*
> > > > +	 * If we encounter a data abort without valid instruction syndrome
> > > > +	 * information, report this to user space.  User space can (and
> > > > +	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
> > > > +	 * supported.
> > > > +	 */
> > > > +	bool return_nisv_io_abort_to_user;
> > > >   };
> > > >   #define KVM_NR_MEM_OBJS     40
> > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > index 5e3f12d5359e..a4dd004d0db9 100644
> > > > --- a/include/uapi/linux/kvm.h
> > > > +++ b/include/uapi/linux/kvm.h
> > > > @@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
> > > >   #define KVM_EXIT_S390_STSI        25
> > > >   #define KVM_EXIT_IOAPIC_EOI       26
> > > >   #define KVM_EXIT_HYPERV           27
> > > > +#define KVM_EXIT_ARM_NISV         28
> > > >   /* For KVM_EXIT_INTERNAL_ERROR */
> > > >   /* Emulate instruction failed. */
> > > > @@ -996,6 +997,7 @@ struct kvm_ppc_resize_hpt {
> > > >   #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
> > > >   #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> > > >   #define KVM_CAP_PMU_EVENT_FILTER 173
> > > > +#define KVM_CAP_ARM_NISV_TO_USER 174
> > > >   #ifdef KVM_CAP_IRQ_ROUTING
> > > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > > > index 35a069815baf..2ce94bd9d4a9 100644
> > > > --- a/virt/kvm/arm/arm.c
> > > > +++ b/virt/kvm/arm/arm.c
> > > > @@ -98,6 +98,26 @@ int kvm_arch_check_processor_compat(void)
> > > >   	return 0;
> > > >   }
> > > > +int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > > +			    struct kvm_enable_cap *cap)
> > > > +{
> > > > +	int r;
> > > > +
> > > > +	if (cap->flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	switch (cap->cap) {
> > > > +	case KVM_CAP_ARM_NISV_TO_USER:
> > > > +		r = 0;
> > > > +		kvm->arch.return_nisv_io_abort_to_user = true;
> > > > +		break;
> > > > +	default:
> > > > +		r = -EINVAL;
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	return r;
> > > > +}
> > > >   /**
> > > >    * kvm_arch_init_vm - initializes a VM data structure
> > > > @@ -196,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > > >   	case KVM_CAP_MP_STATE:
> > > >   	case KVM_CAP_IMMEDIATE_EXIT:
> > > >   	case KVM_CAP_VCPU_EVENTS:
> > > > +	case KVM_CAP_ARM_NISV_TO_USER:
> > > >   		r = 1;
> > > >   		break;
> > > >   	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> > > > @@ -673,6 +694,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > >   		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> > > >   		if (ret)
> > > >   			return ret;
> > > > +	} else if (run->exit_reason == KVM_EXIT_ARM_NISV) {
> > > > +		kvm_inject_undefined(vcpu);
> > > 
> > > Just to make sure I understand: Is the expectation here that userspace
> > > could clear the exit reason if it managed to handle the exit? And
> > > otherwise we'd inject an UNDEF on reentry?
> > > 
> > 
> > Yes, but I think we should change that to an external abort.  I'll test
> > something and send a proper patch with more clear documentation.
> 
> Why not leave the injection to user space in any case? API wise there is no
> need to be backwards compatible, as we require the CAP to be enabled, right?
> 

I'd prefer leaving it to userspace to worry about, but I thought Peter
said that had been problematic historically, which I took at face value,
but I could have misunderstood.

If QEMU, kvmtool, and whatever the crazy^H cool kids are using in
userspace these days are happy emulating the exception, then that's a
viable approach.  The main concern I have with that is whether they'll
all get it right, and since we already have the code in the kernel to do
this, it might make sense to re-use the kernel logic for it.

I'll leave it in for v1 of the patch, and if based on how that code and
interface looks like, we agree it's better to leave it to userspace, I
can remove it in v2.


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
