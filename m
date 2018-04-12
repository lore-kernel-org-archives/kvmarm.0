From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Thu, 12 Apr 2018 19:35:16 +0200
Message-ID: <CAAeHK+wqogT5-iZiWzBMyNEtxxTE2JrgcdVK1+6WFgRm77+cRA@mail.gmail.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com> <20180316143119.cdjw4dhm6crcjyrd@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316143119.cdjw4dhm6crcjyrd@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 16, 2018 at 3:31 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Mar 16, 2018 at 02:13:14PM +0000, Mark Rutland wrote:
>> On Fri, Mar 16, 2018 at 02:49:00PM +0100, Andrey Konovalov wrote:
>> > Hi!
>>
>> Hi,
>>
>> > I've recently tried to boot clang built kernel on real hardware
>> > (Odroid C2 board) instead of using a VM. The issue that I stumbled
>> > upon is that arm64 kvm built with clang doesn't boot.
>> >
>> > Adding -fno-jump-tables compiler flag to arch/arm64/kvm/* helps. There
>> > was a patch some time ago that did exactly that
>> > (https://patchwork.kernel.org/patch/10060381/), but it wasn't accepted
>> > AFAICT (see the discussion on that thread).
>> >
>> > What would be the best way to get this fixed?
>>
>> I think that patch is our best bet currently, but to save ourselves pain
>> in future it would be *really* nice if GCC and clang could provide an
>> option line -fno-absolute-addressing that would implicitly disable any
>> feature that would generate an absolute address as jump tables do.
>>
>> > I've also had to disable CONFIG_JUMP_LABEL to get the kernel boot
>> > (even without kvm enabled), but that might be a different (though
>> > related) issue.
>>
>> With v4.15 (and clang 5.0.0), I did not have to disable jump labels to
>> get a kernel booting on a Juno platform, though I did have to pass
>> -fno-jump-tables to the hyp code.
>
> FWIW, with that same compiler and patch applied atop of v4.16-rc4, and
> some bodges around clang not liking the rX register naming in the SMCCC
> code, I get a kernel that boots on my Juno, though I immediately hit a
> KASAN splat:
>
> [    8.476766] ==================================================================
> [    8.483990] BUG: KASAN: slab-out-of-bounds in __d_lookup_rcu+0x350/0x400
> [    8.490664] Read of size 8 at addr ffff8009336e2a30 by task init/1

Hi Mark!

Just FYI, this should be fixed with https://reviews.llvm.org/D44981 +
https://patchwork.kernel.org/patch/10339103/

Thanks!
