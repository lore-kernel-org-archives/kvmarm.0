Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70202C04A68
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jul 2022 10:38:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB2A74C354;
	Wed, 27 Jul 2022 06:38:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gIxY8FnKTRJZ; Wed, 27 Jul 2022 06:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C304C339;
	Wed, 27 Jul 2022 06:38:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A01814C339
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:38:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XaCbMpHTLslY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jul 2022 06:38:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C88A4C336
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jul 2022 06:38:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03925D6E;
 Wed, 27 Jul 2022 03:38:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67E743F70D;
 Wed, 27 Jul 2022 03:38:17 -0700 (PDT)
Date: Wed, 27 Jul 2022 11:38:53 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <YuEVq8Au7YsDLOdI@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
 <Yt5nFAscgrRGNGoH@monolith.localdoman>
 <YuApmZFdZzTi5ROu@google.com> <875yjiyka4.wl-maz@kernel.org>
 <874jz2yja5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <874jz2yja5.wl-maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Wed, Jul 27, 2022 at 10:52:34AM +0100, Marc Zyngier wrote:
> On Wed, 27 Jul 2022 10:30:59 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Tue, 26 Jul 2022 18:51:21 +0100,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > 
> > > Doesn't pinning the buffer also imply pinning the stage 1 tables
> > > responsible for its translation as well? I agree that pinning the buffer
> > > is likely the best way forward as pinning the whole of guest memory is
> > > entirely impractical.
> 
> Huh, I just realised that you were talking about S1. I don't think we
> need to do this. As long as the translation falls into a mapped
> region (pinned or not), we don't need to worry.
> 
> If we get a S2 translation fault from SPE, we just go and map it. And
> TBH the pinning here is just a optimisation against things like swap,
> KSM and similar things. The only thing we need to make sure is that
> the fault is handled in the context of the vcpu that owns this SPU.
> 
> Alex, can you think of anything that would cause a problem (other than
> performance and possible blackout windows) if we didn't do any pinning
> at all and just handled the SPE interrupts as normal page faults?

PMBSR_EL1.DL might be set 1 as a result of stage 2 fault reported by SPE,
which means the last record written is incomplete. Records have a variable
size, so it's impossible for KVM to revert to the end of the last known
good record without parsing the buffer (references here [1]). And even if
KVM would know the size of a record, there's this bit in the Arm ARM which
worries me (ARM DDI 0487H.a, page D10-5177):

"The architecture does not require that a sample record is written
sequentially by the SPU, only that:
[..]
- On a Profiling Buffer management interrupt, PMBSR_EL1.DL indicates
  whether PMBPTR_EL1 points to the first byte after the last complete
  sample record."

So there might be gaps in the buffer, meaning that the entire buffer would
have to be discarded if DL is set as a result of a stage 2 fault.

Also, I'm not sure if you're aware of this, but SPE reports the guest VA in
PMBPTR_EL1 (not the IPA) on a fault, so KVM would have to walk the guest's
stage 1 tables to service the faults, which would add to the overhead of
servicing the fault. Don't know if that makes a difference, just thought I
should mention it as another peculiarity of SPE.

[1] https://lore.kernel.org/all/Yl7KewpTj+7NSonf@monolith.localdoman/

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
