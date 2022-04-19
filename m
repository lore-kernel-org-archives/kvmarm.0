Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B45CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 14:44:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D474B246;
	Tue, 19 Apr 2022 10:44:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zi0snIjbwNGg; Tue, 19 Apr 2022 10:44:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DCD549DFF;
	Tue, 19 Apr 2022 10:44:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDAB41173
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:44:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yYM8Va7pndbz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 10:44:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F88F40B7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:44:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE751063;
 Tue, 19 Apr 2022 07:44:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 395F33F766;
 Tue, 19 Apr 2022 07:44:05 -0700 (PDT)
Date: Tue, 19 Apr 2022 15:44:02 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <Yl7KewpTj+7NSonf@monolith.localdoman>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
 <20220419141012.GB6143@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419141012.GB6143@willie-the-truck>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Tue, Apr 19, 2022 at 03:10:13PM +0100, Will Deacon wrote:
> On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> > The approach I've taken so far in adding support for SPE in KVM [1] relies
> > on pinning the entire VM memory to avoid SPE triggering stage 2 faults
> > altogether. I've taken this approach because:
> > 
> > 1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
> > and at the moment KVM has no way to resolve the VA to IPA translation.  The
> > AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
> > in the case of a stage 2 fault on a stage 1 translation table walk.
> > 
> > 2. The stage 2 fault is reported asynchronously via an interrupt, which
> > means there will be a window where profiling is stopped from the moment SPE
> > triggers the fault and when the PE taks the interrupt. This blackout window
> > is obviously not present when running on bare metal, as there is no second
> > stage of address translation being performed.
> 
> Are these faults actually recoverable? My memory is a bit hazy here, but I
> thought SPE buffer data could be written out in whacky ways such that even
> a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
> and so pinning is the only game in town.

Ah, I forgot about that, I think you're right (ARM DDI 0487H.a, page
D10-5177):

"The architecture does not require that a sample record is written
sequentially by the SPU, only that:
[..]
- On a Profiling Buffer management interrupt, PMBSR_EL1.DL indicates
  whether PMBPTR_EL1 points to the first byte after the last complete
  sample record.
- On an MMU fault or synchronous External abort, PMBPTR_EL1 serves as a
  Fault Address Register."

and (page D10-5179):

"If a write to the Profiling Buffer generates a fault and PMBSR_EL1.S is 0,
then a Profiling Buffer management event is generated:
[..]
- If PMBPTR_EL1 is not the address of the first byte after the last
  complete sample record written by the SPU, then PMBSR_EL1.DL is set to 1.
  Otherwise, PMBSR_EL1.DL is unchanged."

Since there is no way to know the record size (well, unless
PMSIDR_EL1.MaxSize == PMBIDR_EL1.Align, but that's not an architectural
requirement), it means that KVM cannot restore the write pointer to the
address of the last complete record + 1, to allow the guest to resume
profiling without corrupted records.

> 
> A funkier approach might be to defer pinning of the buffer until the SPE is
> enabled and avoid pinning all of VM memory that way, although I can't
> immediately tell how flexible the architecture is in allowing you to cache
> the base/limit values.

A guest can use this to pin the VM memory (or a significant part of it),
either by doing it on purpose, or by allocating new buffers as they get
full. This will probably result in KVM killing the VM if the pinned memory
is larger than ulimit's max locked memory, which I believe is going to be a
bad experience for the user caught unaware. Unless we don't want KVM to
take ulimit into account when pinning the memory, which as far as I can
goes against KVM's approach so far.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
