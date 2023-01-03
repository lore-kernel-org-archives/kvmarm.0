Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCC2C46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 14:27:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C58FF4BB5B;
	Tue,  3 Jan 2023 09:27:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7YGWpoG6V5JP; Tue,  3 Jan 2023 09:27:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 617A34BB41;
	Tue,  3 Jan 2023 09:27:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 767724BB3A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 09:27:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ai-JXoVT4uKK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 09:26:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 927994BB39
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 09:26:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD9DA152B;
 Tue,  3 Jan 2023 06:27:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18E183F587;
 Tue,  3 Jan 2023 06:26:57 -0800 (PST)
Date: Tue, 3 Jan 2023 14:26:51 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <Y7Q7K2f9aJe2my29@monolith.localdoman>
References: <YvJowFt+U/qCqNVV@monolith.localdoman>
 <YvKq1IK7T/nGSKpt@google.com>
 <YvN8VvqvutZ4ti8g@monolith.localdoman>
 <YvPOBPZa2/cHombZ@google.com>
 <YvZQKXtRpptpaWAI@monolith.localdoman>
 <Yv0Dzy4sbGLWvHuZ@google.com>
 <Yx9HRqZluagQtVCJ@monolith.localdoman>
 <YyBiZ4WXL+qn9w3d@google.com>
 <YyB6MAv5UZkiY66a@monolith.localdoman>
 <YyCPYLVayX+NwR4K@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyCPYLVayX+NwR4K@google.com>
Cc: maz@kernel.org, Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi,

Just a heads-up, sent a new proposal for SPE emulation which removes the need to
pin memory at stage 2 [1].

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2022-November/056637.html

Thanks,
Alex

On Tue, Sep 13, 2022 at 03:13:31PM +0100, Oliver Upton wrote:
> On Tue, Sep 13, 2022 at 01:41:56PM +0100, Alexandru Elisei wrote:
> > Hi Oliver,
> > 
> > On Tue, Sep 13, 2022 at 11:58:47AM +0100, Oliver Upton wrote:
> > > Hey Alex,
> > > 
> > > On Mon, Sep 12, 2022 at 03:50:46PM +0100, Alexandru Elisei wrote:
> > > 
> > > [...]
> > > 
> > > > > Yeah, that would be good to follow up on what other OSes are doing.
> > > > 
> > > > FreeBSD doesn't have a SPE driver.
> > > > 
> > > > Currently in the process of finding out how/if Windows implements the
> > > > driver.
> > > > 
> > > > > You'll still have a nondestructive S2 fault handler for the SPE, right?
> > > > > IOW, if PMBSR_EL1.DL=0 KVM will just unpin the old buffer and repin the
> > > > > new one.
> > > > 
> > > > This is how I think about it: a S2 DABT where DL == 0 can happen because of
> > > > something that the VMM, KVM or the guest has done:
> > > > 
> > > > 1. If it's because of something that the host's userspace did (memslot was
> > > > changed while the VM was running, memory was munmap'ed, etc). In this case,
> > > > there's no way for KVM to handle the SPE fault, so I would say that the
> > > > sensible approach would be to inject an SPE external abort.
> > > > 
> > > > 2. If it's because of something that KVM did, that can only be because of a
> > > > bug in SPE emulation. In this case, it can happen again, which means
> > > > arbitrary blackout windows which can skew the profiling results. I would
> > > > much rather inject an SPE external abort then let the guest rely on
> > > > potentially bad profiling information.
> > > > 
> > > > 3. The guest changes the mapping for the buffer when it shouldn't have: A.
> > > > when the architecture does allow it, but KVM doesn't support, or B. when
> > > > the architecture doesn't allow it. For both cases, I would much rather
> > > > inject an SPE external abort for the reasons above. Furthermore, for B, I
> > > > think it would be better to let the guest know as soon as possible that
> > > > it's not following the architecture.
> > > > 
> > > > In conclusion, I would prefer to treat all SPE S2 faults as errors.
> > > 
> > > My main concern with treating S2 faults as a synthetic external abort is
> > > how this behavior progresses in later versions of the architecture.
> > > SPEv1p3 disallows implementations from reporting external aborts via the
> > > SPU, instead allowing only for an SError to be delivered to the core.
> > 
> > Ah, yes, missed that bit for SPEv1p3 (ARM DDI 0487H.a, page D10-5180).
> > 
> > > 
> > > I caught up with Will on this for a little bit:
> > > 
> > > Instead of an external abort, how about reporting an IMP DEF buffer
> > > management event to the guest? At least for the Linux driver it should
> > > have the same effect of killing the session but the VM will stay
> > > running. This way there's no architectural requirement to promote to an
> > > SError.
> > 
> > The only reason I proposed to inject an external abort is because KVM needs
> > a way to tell the guest that something outside of the guest's control went
> > wrong and it should drop the contents of the current profiling session. An
> > external abort reported by the SPU seemed to fit the bit.
> > 
> > By IMP DEF buffer management event I assume you mean PMBSR_EL1.EC=0b011111
> > (Buffer management event for an IMPLEMENTATION DEFINED reason).
> 
> Yup, that's it. You also get two whole bytes of room in PMBSR_EL1.MSS
> which is also IMP DEF, so we could even stick some ASCII in there to
> tell the guest how we really feel! :-P
> 
> > I'm thinking that someone might run a custom kernel in a VM, like a vendor
> > downstream kernel, with patches that actually handle this exception class,
> > and injecting such an exception might not have the effects that KVM
> > expects. Am I overthinking things? Is that something that KVM should take
> > into consideration? I suppose KVM can and should also set
> > PMBSR_EL1.DL = 1, as that means per the architecture that the buffer
> > contents should be discarded.
> 
> I agree with you that PMBSR_EL1.DL=1 is the right call for this. With
> that, I'd be surprised if there was a guest that tried to pull some
> tricks other than blowing away the profile. The other option that I
> find funny is if we plainly report the S2 abort to the guest, but that
> wont work well when nested comes into the picture.
> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
