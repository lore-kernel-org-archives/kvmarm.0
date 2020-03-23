Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E1BC4332B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 09:07:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7DE720769
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 09:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HbAcxhCN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7DE720769
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 564A94B0C2;
	Mon, 23 Mar 2020 05:07:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 12DU8ZJ8sGYr; Mon, 23 Mar 2020 05:07:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A734A551;
	Mon, 23 Mar 2020 05:07:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FDA4A551
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:07:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mWcMrKckwD+5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 05:07:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A5BC94A523
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 05:07:15 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5E68C2072D;
 Mon, 23 Mar 2020 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584954434;
 bh=c3gD7Ndez0PnhQ/J9rA27+cPGjqK/Gk9bVdWL5sM6nc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=HbAcxhCNU1EXaHaiVIWpo7fie7A4YEvMk/f3vmHM67/59Vz4fLNTEzs8V8gP3ZZwJ
 stkmCmPcHn0FZjd+lMwoQrQX2N7zPS9GOnt+j53aI0FVF5bRpDSft7wdOTB7hswUEe
 q8BangTOtWBGHWhvd2vimYH9I0gyxa/gDiJwYLRE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jGJ3A-00EuLn-J3; Mon, 23 Mar 2020 09:07:12 +0000
MIME-Version: 1.0
Date: Mon, 23 Mar 2020 09:07:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Lev Aronsky <aronsky@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add support for IDSR exits to userspace
In-Reply-To: <20200323082217.GA1509@ewr1-t1.small.x86-01>
References: <20200322093650.50621-1-aronsky@gmail.com>
 <61ae80130b47dc23d00d5010eccee0b2@kernel.org>
 <20200322142010.GA3337@ewr1-t1.small.x86-01>
 <d19c6aad8de7bfa182b7872ebeec57b5@kernel.org>
 <20200323082217.GA1509@ewr1-t1.small.x86-01>
Message-ID: <d2c184326523ffe5b2e700b25b07b6a8@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: aronsky@gmail.com, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-03-23 08:22, Lev Aronsky wrote:
> On Sun, Mar 22, 2020 at 05:29:52PM +0000, Marc Zyngier wrote:
>> On 2020-03-22 14:20, Lev Aronsky wrote:
>> > On Sun, Mar 22, 2020 at 11:34:35AM +0000, Marc Zyngier wrote:
>> > > Hi Lev,
>> > >
>> > > Thanks for this.
>> > >
>> > > On 2020-03-22 09:36, aronsky@gmail.com wrote:
>> > > > From: Lev Aronsky <aronsky@gmail.com>
>> > > >
>> > > > As per ARM DDI 0487E.a, section D12.3.2, there can be various
>> > > > system registers that are IMPLEMENTATION DEFINED.
>> > > >
>> > > > So far, KVM would inject an undefined instruction into the guest,
>> > > > whenever access to an implementation defined system register (from
>> > > > here on referred to as IDSR) was trapped. This makes sense, since a
>> > > > general-purpose OS probably shouldn't rely on the existence of IDSRs.
>> > > >
>> > > > This patch introduces an option to give userspace a chance to handle
>> > > > these traps. This can be used to emulate specific architectures, and
>> > > > virtualize operating systems that rely on the existence of specific
>> > > > IDSRs.
>> > >
>> > > Do you have an example of such operating systems? Also, do you have
>> > > an example where userspace could actually do something useful about
>> > > such access, other than maybe treating it as RAZ/WI?
>> >
>> > I ran into the issue when working on our company's project, which aims
>> > to emulate Apple's iOS under QEMU. While emulation currently works
>> > nicely, we were looking to improve performance by using hardware
>> > virtualization, and that's when we ran into the issue of
>> > implementation-defined system registers, since iOS uses those. Frankly,
>> > in our case, we don't really know the purpose of those registers, as far
>> > as the iOS kernel is concerned. When emulating them, we treat them as
>> > simple 64-bit storage areas. It's possible that treating them as RAZ/WI
>> > would work, as well.
>> 
>> It's not really reassuring, is it? :-/
> 
> It's not perfect, but also not too bad - the system is booting as
> expected. It might not be a 100% perfect emulation of a real device
> without a proper implementation of those registers, but it's good 
> enough
> in our case.

Hum. OK, I guess.

>> > > > Similarly to the recently introduced NISV exits, this is an ABI to
>> > > > userspace, and comes with a matching new capability that allows the
>> > > > configuration of the behavior.
>> > >
>> > > These are different issues: one is a shortcoming of the architecture,
>> > > the other a shortcoming (or hyperspecialization) of the guest OS.
>> >
>> > You're correct. I mentioned the NISV exits because my code is modeled
>> > after them, and was hoping it would make following my changes easier.
>> 
>> It does. IT is just that wou did seem to conflate the two things, 
>> which
>> triggered an allergic reaction... ;-)
>> 
>> > > > This patch introduces KVM_CAP_ARM_IDSR_TO_USER, which can be used to
>> > > > enable userspace exits due to access to IDSRs. Additionally, it
>> > > > introduces a matching new exit reason, KVM_EXIT_ARM_IDSR, to report
>> > > > those events to userspace. Userspace can choose to emulate the access
>> > > > based on the architecture requirements, or refuse to emulate it and
>> > >
>> > > s/architecture/implementation/
>> >
>> > Sorry for the newbie question - but how do I change the description now?
>> > I will upload an updated patch, based on your following comments, but
>> > I'm not sure how to change the original commit description the correct
>> > way.
>> 
>> git commit --amend
> 
> Thanks. I know about amending commits - I was wondering about what to 
> do
> with the amended commit. As far as I understand, given there are
> additional changes I'll have to make, I'd have to make a v2 of the
> patch, but according to the guides I've seen, I would only add the
> changelog of the newer version of the patch, so I wasn't sure whether 
> to
> make the correction in the original description of the patch or not.

In general, the commit log must be accurate, so you are free to change
it at any time to reflect what the patch does.

> 
>> >
>> > > > let the kernel continue with the default behavior (injecting an
>> > > > undefined instruction exception into the guest).
>> > > >
>> > > > Signed-off-by: Lev Aronsky <aronsky@gmail.com>
>> > > > ---
>> > > >  arch/arm64/include/asm/kvm_coproc.h |  1 +
>> > > >  arch/arm64/include/asm/kvm_host.h   |  6 +++
>> > > >  arch/arm64/kvm/sys_regs.c           | 66 ++++++++++++++++++++++++++++-
>> > > >  include/uapi/linux/kvm.h            | 14 ++++++
>> > > >  tools/include/uapi/linux/kvm.h      | 14 ++++++
>> > > >  virt/kvm/arm/arm.c                  | 11 +++++
>> > > >  6 files changed, 111 insertions(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/arch/arm64/include/asm/kvm_coproc.h
>> > > > b/arch/arm64/include/asm/kvm_coproc.h
>> > > > index 0185ee8b8b5e..34b45efffe52 100644
>> > > > --- a/arch/arm64/include/asm/kvm_coproc.h
>> > > > +++ b/arch/arm64/include/asm/kvm_coproc.h
>> > > > @@ -33,6 +33,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct
>> > > > kvm_run *run);
>> > > >  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> > > >  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> > > >  int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> > > > +int kvm_handle_idsr_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> > > >
>> > > >  #define kvm_coproc_table_init kvm_sys_reg_table_init
>> > > >  void kvm_sys_reg_table_init(void);
>> > > > diff --git a/arch/arm64/include/asm/kvm_host.h
>> > > > b/arch/arm64/include/asm/kvm_host.h
>> > > > index d87aa609d2b6..951c7e6fec8b 100644
>> > > > --- a/arch/arm64/include/asm/kvm_host.h
>> > > > +++ b/arch/arm64/include/asm/kvm_host.h
>> > > > @@ -91,6 +91,12 @@ struct kvm_arch {
>> > > >  	 * supported.
>> > > >  	 */
>> > > >  	bool return_nisv_io_abort_to_user;
>> > > > +
>> > > > +	/*
>> > > > +	 * If we encounter an access to an implementation-defined system
>> > > > +	 * register, report this to user space.
>> > > > +	 */
>> > > > +	bool return_idsr_to_user;
>> > >
>> > > If we are going to add flags like this, maybe we'd be better off
>> > > having
>> > > actual flags as an unsigned long.
>> >
>> > I don't mind either way - as I mentioned, I tried to follow the NISV
>> > exits style, and therefore used `bool`. Should I keep it, change it to
>> > `unsigned long`, or change both mine and the NISV flag to `unsigned
>> > long`?
>> 
>> Change return_nisv_io_abort_to_user to "unsigned long flags", add a 
>> new
>> RETURN_NISV_IO_ABORT_TO_USER flag and repaint all the current users
>> in a preliminary patch.
> 
> Will do. This means there will be two patchsets, right?

One patch-set, at least two patches (and a cover letter).

[...]

>> > I must admit that I haven't taken an in-depth look at 32-bit accesses,
>> > since it was out of scope of our project (which currently focuses only
>> > on newish versions of iOS). IMO, the patch is useful as is, even without
>> > the 32-bit support - but I can see how it looks like a job half-done.
>> 
>> The 32bit guest support definitely isn't optional. I appreciate that 
>> you
>> focus on 64bit, but having different behaviours between the two is not
>> really something I want to entertain.
> 
> Totally understandable - but I'm afraid that in this case, the patch
> will have to wait, as we currently focus our R&D resources on further
> advancing our project. I will do my best, however, to try and find some
> time to work on it in the near future. Would booting a 32-bit ARM Linux
> and using a kernel module to write/read implementation-defined 
> registers
> be an acceptable approach to test it? Also, just to make sure I
> understand correctly - we're talking about AArch32 mode of arm64
> processors, right? Not testing it on 32-bit ARM cores (which, as I
> understand, are being retired in 5.7 anyway).

32bit-on-64bit is what I care about, yes. 32bit *host* is on its way to
retirement, as you found out. And yes, just booting any 32bit guest and
checking that you indeed trap access to an IMPDEF register would be 
enough.

> 
>> > Unfortunately, we don't have a 32-bit setup that would allow us to
>> > properly test the code before submitting. I could copy the changes over,
>> > but submitting the patches without actually testing them seems
>> > irresponsible to me.
>> 
>> Well, you seem to at least have QEMU. This should be enough to test
>> *something*. Also, if you're testing this with KVM, what are you 
>> running
>> KVM on?
> 
> We're running it on an ARM cloud server (we were hoping to be able to
> use SBCs for the project, but iOS uses 16K pages for kernel mode, and 
> we
> found out (the hard way) that most older/cheaper ARM cores don't 
> support
> it (Cortex A76 being the first one to support it, IIRC).

I think there is more than just A76. A55 definitely has TGran16, as well 
as
A73, A75, A65 (I've stopped looking in the various TRMs). So definitely
in the realm of SBCs (I have a quad A55 on my desk, worth $70).

>> 
>> > Interestingly, EL0 access to implementation-defined registers currently
>> > results in an UNDEF, even though I expected it to be passed on to our
>> > handler (I saw this behavior with a custom system register we defined
>> > for direct communication with the hypervisor from a user-mode program we
>> > developed). I tried following the ARM documentation to figure out what
>> > could cause such a behavior, but so far I'm at a loss.
>> 
>> Here's your answer:
>> 
>> "When the value of HCR_EL2.TIDCP is 1, it is IMPLEMENTATION DEFINED 
>> whether
>> any of this functionality accessed from EL0 is trapped to EL2. If it 
>> is not,
>> then it is UNDEFINED, and any attempt to access it from EL0 generates 
>> an
>> exception that is taken to EL1."
>> 
>> Also, I don't really understand how you define a custom system 
>> register.
>> Unless you're writing the HW as well, of course.
> 
> We are using QEMU as the hypervisor. QEMU allows for definition of
> arbitrary system registers (based on opc0/opc1/opc2/crm/crn), with
> custom read/write callback functions. We have a custom machine for
> iPhone emulation (you can take a look at our code at
> https://github.com/alephsecurity/xnu-qemu-arm64, if you're interested),
> so yeah - you could say we're writing the hardware, as well.

I'm pretty sure this wouldn't work with HW virtualization. I suspect
this would UNDEF directly on the CPU, leading to an exception being 
taken
at EL1 without intervention of the hypervisor. Which makes sense as 
you'd
be executing an instruction that the CPU really doesn't implement.

>> > As far as the whole idea of supporting non-architectural guests... First
>> > of all, you're absolutely spot-on regarding your guess - as mentioned
>> > above, we're attempting to virtualize iOS. I believe that in the current
>> > state of the patch, given its opt-in nature and limited scope
>> > (implementation-defined registers), its benefits (the potential to
>> > successfully execute non-architetural guests) outweigh the negatives
>> > (extra code in the kernel, that's unnecessary to most of the guests
>> > under ARM/KVM). I would be happy to give more examples (other than iOS)
>> > that use these registers, but unfortunately, I'm not aware of any such
>> > systems (though I wouldn't be surprised if Samsung has some
>> > Exynos-specifc code, but that's just a shot in the dark).
>> 
>> Oh, absolutely *all* implementations have IMPDEF registers. You just
>> have to look at the TRM for any of the ARM implementations, which
>> document a number of them.
>> 
>> And as for having non-architectural code in the kernel, that's of 
>> course,
>> as you've guessed, a total no-no-no. We made that mistake on 32bit, 
>> and
>> stopped quickly!
>> 
>> My worry is more that you'd need to start faking a lot more than just 
>> a
>> couple of IMPDEP sysregs. All the ID registers, for a start. Then find
>> ways to deal with the host's errata, that the guest has to know about
>> (despite the ID registers being faked). And make sure that no 
>> workaround
>> that happen in the guest result in anything unexpected.
>> 
>> Some of that is possible (the ID register bit, although it requires 
>> some
>> very serious work), and you could cross your fingers hoping that no 
>> erratum
>> will get in the way. But it seems pretty fragile...
> 
> That's definitely something we're worried about, but so far our efforts
> have been successful (as in, right now, with the above changes in the
> kernel and matching updates to QEMU, our iOS image boots to user-mode
> successfully). We are definitely skipping on some parts of the OS (for
> example, anything related to TPM). It's possible that as we attempt to
> improve the accuracy of our emulation/virtualization, we'll run into 
> the
> problems you're describing.

Fun! ;-)

I'm looking forward to your posting of the next version that would 
include
32bit supoport. Another thing I'd ask is a corresponding support patch 
for
a userspace VMM of your choice (QEMU, kvmtool) so that I can at least 
exercise
the support.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
