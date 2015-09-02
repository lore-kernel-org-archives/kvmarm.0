From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/14] arm64: Check for selected granule support
Date: Wed, 2 Sep 2015 11:48:41 +0200
Message-ID: <CAKv+Gu8vfsL+SFqgsXESfYC5a90-rnHbLqVFuOkvDXTt2b1E3Q@mail.gmail.com>
References: <1439465645-22584-1-git-send-email-suzuki.poulose@arm.com>
 <1439465645-22584-13-git-send-email-suzuki.poulose@arm.com>
 <CAPvkgC3=S1BxdzZM4uUOmyXLjii48SMpCof6i6HdNeTG_fydfg@mail.gmail.com>
 <55CCAD73.7080702@arm.com>
 <20150813172946.GD4602@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6986C41D42
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qi2SG8h6l4M8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 05:48:21 -0400 (EDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
 [209.85.223.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7862E41C8C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 05:48:21 -0400 (EDT)
Received: by ioii196 with SMTP id i196so13632125ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Sep 2015 02:48:41 -0700 (PDT)
In-Reply-To: <20150813172946.GD4602@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 13 August 2015 at 19:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, Aug 13, 2015 at 03:45:07PM +0100, Suzuki K. Poulose wrote:
>> On 13/08/15 13:28, Steve Capper wrote:
>> >On 13 August 2015 at 12:34, Suzuki K. Poulose <suzuki.poulose@arm.com> wrote:
>> >>  __enable_mmu:
>> >>+       mrs     x1, ID_AA64MMFR0_EL1
>> >>+       ubfx    x2, x1, #ID_AA64MMFR0_TGran_SHIFT, 4
>> >>+       cmp     x2, #ID_AA64MMFR0_TGran_ENABLED
>> >>+       b.ne    __no_granule_support
>> >>         ldr     x5, =vectors
>> >>         msr     vbar_el1, x5
>> >>         msr     ttbr0_el1, x25                  // load TTBR0
>> >>@@ -626,3 +643,8 @@ __enable_mmu:
>> >>         isb
>> >>         br      x27
>> >>  ENDPROC(__enable_mmu)
>> >>+
>> >>+__no_granule_support:
>> >>+       wfe
>> >>+       b __no_granule_support
>> >>+ENDPROC(__no_granule_support)
>> >>--
>> >>1.7.9.5
>> >>
>> >
>> >Is is possible to tell the user that the kernel has failed to boot due
>> >to the kernel granule being unsupported?
>>
>> We don't have anything up at this time. The "looping address" is actually a clue
>> to the (expert) user. Not sure we can do something, until we get something like DEBUG_LL(?)
>
> No.
>
>> Or we should let it continue and end in a panic(?). The current situation can boot a
>> multi-cluster system with boot cluster having the Tgran support(which doesn't make a
>> strong use case though). I will try out some options and get back to you.
>
> If the boot CPU does not support 16KB pages, in general there isn't much
> we can do since the console printing is done after we enabled the MMU.
> Even mapping the UART address requires fixmap support and the PAGE_SIZE
> is hard-coded in the kernel image. The DT is also mapped at run-time.
>
> While in theory it's possible to fall back to a 4KB page size just
> enough to load the DT and figure out the early console, I suggest we
> just live with the "looping address" clue.
>

Couldn't we allocate some flag bits in the Image header to communicate
the page size to the bootloader?
