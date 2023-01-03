Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AE0C46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 14:28:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3424C4BB50;
	Tue,  3 Jan 2023 09:28:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V604bVghT2P5; Tue,  3 Jan 2023 09:28:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C607C4BB45;
	Tue,  3 Jan 2023 09:28:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B5B4BB41
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 09:28:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gkC59Km0EjrE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 09:28:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F5B4BB3B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 09:28:04 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98DDE152B;
 Tue,  3 Jan 2023 06:28:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 617043F587;
 Tue,  3 Jan 2023 06:28:02 -0800 (PST)
Date: Tue, 3 Jan 2023 14:27:59 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu
Subject: Re: KVM: arm64: A new approach for SPE support
Message-ID: <Y7Q7b7+BKKBajIo2@monolith.localdoman>
References: <Y34GvXY/xMpev39K@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y34GvXY/xMpev39K@monolith.localdoman>
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

Gentle ping regarding this.

Thanks,
Alex

On Wed, Nov 23, 2022 at 11:40:45AM +0000, Alexandru Elisei wrote:
> The previous discussion about how best to add SPE support to KVM [1] is
> heading in the direction of pinning at EL2 only the buffer, when the guest
> enables profiling, instead of pinning the entire VM memory. Although better
> than pinning the entire VM at EL2, it still has some disadvantages:
> 
> 1. Pinning memory at stage 2 goes against the design principle of secondary
> MMUs, which must reflect all changes in the primary (host's stage 1) page
> tables. This means a mechanism by which to pin VM memory at stage 2 must be
> created from scratch just for SPE. Although I haven't done this yet, I'm a
> bit concerned that this will turn out to be fragile and/or complicated.
> 
> 2. The architecture allows software to change the VA to IPA translations
> for the profiling buffer when the buffer is enabled if profiling is
> disabled (the buffer is enabled, but sampling is disabled). Since SPE can
> be programmed to profile EL0 only, and there is no easy way for KVM to trap
> the exact moment when profiling becomes enabled in this scenario to
> translate the buffer's guest VAs to IPA, to pin the IPAs at stage 2, it is
> required for KVM impose limitations on how a guest uses SPE for emulation
> to work.
> 
> I've prototyped a new approach [2] which eliminates both disadvantages, but
> comes with its own set of drawbacks. The approach I've been working on is
> to have KVM allocate a buffer in the kernel address space to profile the
> guest, and when the buffer becomes full (or profiling is disabled for other
> reasons), to copy the contents of the buffer to guest memory.
> 
> I'll start with the advantages:
> 
> 1. No memory pinning at stage 2.
> 
> 2. No meaningful restrictions on how the guest programs SPE, since the
> translation of the guest VAs to IPAs is done by KVM when profiling has been
> completed.
> 
> 3. Neoverse N1 errata 1978083 ("Incorrect programming of PMBPTR_EL1 might
> result in a deadlock") [6] is handled without any extra work.
> 
> As I see it, there are two main disadvantages:
> 
> 1. The contents of the KVM buffer must be copied to the guest. In the
> prototype this is done all at once, when profiling is stopped [3].
> Presumably this can be amortized by unmapping the pages corresponding to
> the guest buffer from stage 2 (or marking them as invalid) and copying the
> data when the guest reads from those pages. Needs investigating.
> 
> 2. When KVM profiles the guest, the KVM buffer owning exception level must
> necessarily be EL2. This means that while profiling is happening,
> PMBIDR_EL1.P = 1 (programming of the buffer is not allowed). PMBIDR_EL1
> cannot be trapped without FEAT_FGT, so a guest that reads the register
> after profiling becomes enabled will read the P bit as 1. I cannot think of
> any valid reason for a guest to look at the bit after enabling profiling.
> With FEAT_FGT, KVM would be able to trap accesses to the register.
> 
> 3. In the worst case scenario, when the entire VM memory is mapped in the
> host, this approach consumes more memory because the memory for the buffer
> is separate from the memory allocated to the VM. On the plus side, there
> will always be less memory pinned in the host for the VM process, since
> only the buffer has to be pinned, instead of the buffer plus the guest's
> stage 1 translation tables (to avoid SPE encountering a stage 2 fault on a
> stage 1 translation table walk). Could be mitigated by providing an ioctl
> to userspace to set the maximum size for the buffer.
> 
> I prefer this new approach instead of pinning the buffer at stage 2. It is
> straightforward, less fragile and doesn't limit how a guest can program
> SPE.
> 
> As for the prototype, I wrote it as a quick way to check if this approach
> is viable. Does not have SPE support for the nVHE case because I would have
> had to figure out how to map a continuous VA range in the EL2's translation
> tables; supporting only the VHE case was a lot easier.  The prototype
> doesn't have a stage 1 walker, so it's limited to guests that use id-mapped
> addresses from TTBR0_EL1 for the buffer (although it would be trivial to
> modify it to accept addresses from TTBR1_EL1) - I've used kvm-unit-tests
> for testing [4]. I've tested the prototype on the model and on an Ampere
> Altra.
> 
> For those interested, kvmtool support to run the prototype has also been
> added [5] (add --spe to the command line to run a VM).
> 
> [1] https://lore.kernel.org/all/Yl6+JWaP+mq2Nc0b@monolith.localdoman/
> [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v6-copy-buffer-wip4-without-nvhe
> [3] https://gitlab.arm.com/linux-arm/linux-ae/-/blob/kvm-spe-v6-copy-buffer-wip4-without-nvhe/arch/arm64/kvm/spe.c#L197
> [4] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/kvm-spe-v6-copy-buffer-wip4
> [5] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v6-copy-buffer-wip4
> [6] https://developer.arm.com/documentation/SDEN885747/latest
> 
> Thanks,
> Alex
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
