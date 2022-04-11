Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300E0C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Apr 2022 10:46:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4D4A4B2A3;
	Mon, 11 Apr 2022 06:46:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yxb4tLWH8IrD; Mon, 11 Apr 2022 06:46:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2DF4B29E;
	Mon, 11 Apr 2022 06:46:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF31C4B299
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 06:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fI0a-gtIQ8Ie for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2022 06:46:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1534B295
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 06:46:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89DC4169E;
 Mon, 11 Apr 2022 03:46:15 -0700 (PDT)
Received: from e121798.cambridge.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 372993F5A1;
 Mon, 11 Apr 2022 03:46:14 -0700 (PDT)
Date: Mon, 11 Apr 2022 11:46:09 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5/5] KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high
Message-ID: <YlQGh6Ky2oqrS89y@e121798.cambridge.arm.com>
References: <20220407162327.396183-1-alexandru.elisei@arm.com>
 <20220407162327.396183-6-alexandru.elisei@arm.com>
 <87ee28auff.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ee28auff.wl-maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Fri, Apr 08, 2022 at 08:47:00AM +0100, Marc Zyngier wrote:
> Hi Alex,
> 
> On Thu, 07 Apr 2022 17:23:27 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > When userspace is debugging a VM, the kvm_debug_exit_arch part of the
> > kvm_run struct contains arm64 specific debug information: the ESR_EL2
> > value, encoded in the field "hsr", and the address of the instruction
> > that caused the exception, encoded in the field "far".
> > 
> > Linux has moved to treating ESR_EL2 as a 64-bit register, but unfortunately
> > kvm_debug_exit_arch.hsr cannot be changed to match because that would
> > change the memory layout of the struct on big endian machines:
> > 
> > Current layout:			| Layout with "hsr" extended to 64 bits:
> > 				|
> > offset 0: ESR_EL2[31:0] (hsr)   | offset 0: ESR_EL2[61:32] (hsr[61:32])
> > offset 4: padding		| offset 4: ESR_EL2[31:0]  (hsr[31:0])
> > offset 8: FAR_EL2[61:0] (far)	| offset 8: FAR_EL2[61:0]  (far)
> > 
> > which breaks existing code.
> > 
> > The padding is inserted by the compiler because the "far" field must be
> > aligned to 8 bytes (each field must be naturally aligned - aapcs64 [1],
> > page 18) and the struct itself must be aligned to 8 bytes (the struct must
> > be aligned to the maximum alignment of its fields - aapcs64, page 18),
> > which means that "hsr" must be aligned to 8 bytes as it is the first field
> > in the struct.
> > 
> > To avoid changing the struct size and layout for the existing fields, add a
> > new field, "hsr_high", which replaces the existing padding. "hsr_high" will
> > be used to hold the ESR_EL2[61:32] bits of the register. The memory layout,
> > both on big and little endian machine, becomes:
> > 
> > Layout with "hsr_high" added:
> > 
> > offset 0: ESR_EL2[31:0]  (hsr)
> > offset 4: ESR_EL2[61:32] (hsr_high)
> > offset 8: FAR_EL2[61:0]  (far)
> 
> My concern with this change is that it isn't clear what the padding is
> currently initialised to, and I don't think there is any guarantee
> that it is zeroed. With that, a new userspace on an old kernel would
> interpret hsr_high, and potentially observe stuff that wasn't supposed
> to be interpreted.

You are right, I didn't think about this scenario. Did some digging, and
C99 explicitely states that padding is uninitialized (September 7, 2007,
draft, page 38), so I assume that it's the same for C89 (couldn't find a
free source for the standard).

> 
> That's yet another mistake in our userspace ABI (where is the time
> machine when you need it?).

To avoid this sort of thing happening in the future, KVM/arm64 could
mandate that all structs that are part of the userspace API have the
padding explicitly declared as a struct field and that padding must always
be set to zero by userspace before a syscall. KVM would then check that the
padding is zero and return -EINVAL if userspace didn't clear it correctly,
to enforce this convention. I think that should be forward compatible with
repurposing the padding to add another field, unless 0 has a special
meaning for the field that is added, which I believe to be highly unlikely.

> 
> In order to do this, we must advertise to userspace that we provide
> more information. This probably means adding a flag of some sort to
> kvm_run (there are at least 128 bits of x86 stuff that can be readily
> reclaimed).

We could add a flag to kvm_run.flags that is set only when
kvm_run.exit_reason == KVM_EXIT_DEBUG, something like
KVM_DEBUG_ARM_HSR_HIGH_SET (or PRESENT). flags has 16 bits which are unused
today, so I don't think it's too costly to use one bit for this.

One other option would be to wait to expose the upper 32 bits until KVM
supports a hardware feature that makes use of those bits. That means
advertising the feature to userspace, which KVM might or might not want to
do. And KVM today doesn't do any sanitisation/masking on the hsr value that
is reported to userspace, and tying hsr_high to a particular feature might
mean that KVM will have to sanitise the upper bits if said feature is
opt-in by userspace.

My preference is for the first approach because the second approach looks
more complicated.

There's always the option to wait until KVM makes use of the upper 32 bits
and decide then, when we have more information.

Thanks,
Alex

> 
> What do you think?
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
