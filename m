From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 14:13:31 +0000
Message-ID: <26a25069-ea1d-5fb3-549c-ab653f454a30@arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrey,

On 16/03/18 13:49, Andrey Konovalov wrote:
> Hi!
> 
> I've recently tried to boot clang built kernel on real hardware
> (Odroid C2 board) instead of using a VM. The issue that I stumbled
> upon is that arm64 kvm built with clang doesn't boot.
> 
> Adding -fno-jump-tables compiler flag to arch/arm64/kvm/* helps. There
> was a patch some time ago that did exactly that
> (https://patchwork.kernel.org/patch/10060381/), but it wasn't accepted
> AFAICT (see the discussion on that thread).

I wasn't aware of that discussion, but this is indeed quite annoying.
Note that you should be able to restrict this to arch/arm64/kvm/hyp/*
and virt/kvm/arm/hyp/*.

> What would be the best way to get this fixed?

Ideally, I'd like to see is a way to stick to PC-relative addressing
within a compilation unit.

> I've also had to disable CONFIG_JUMP_LABEL to get the kernel boot
> (even without kvm enabled), but that might be a different (though
> related) issue.

That's quite bizarre. Does clang has the equivalent of "asm goto"? Or do
you rely on reading a variable to decide whether or not to branch?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
