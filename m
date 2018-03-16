From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 14:13:14 +0000
Message-ID: <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 16, 2018 at 02:49:00PM +0100, Andrey Konovalov wrote:
> Hi!

Hi,
 
> I've recently tried to boot clang built kernel on real hardware
> (Odroid C2 board) instead of using a VM. The issue that I stumbled
> upon is that arm64 kvm built with clang doesn't boot.
> 
> Adding -fno-jump-tables compiler flag to arch/arm64/kvm/* helps. There
> was a patch some time ago that did exactly that
> (https://patchwork.kernel.org/patch/10060381/), but it wasn't accepted
> AFAICT (see the discussion on that thread).
> 
> What would be the best way to get this fixed?

I think that patch is our best bet currently, but to save ourselves pain
in future it would be *really* nice if GCC and clang could provide an
option line -fno-absolute-addressing that would implicitly disable any
feature that would generate an absolute address as jump tables do.

> I've also had to disable CONFIG_JUMP_LABEL to get the kernel boot
> (even without kvm enabled), but that might be a different (though
> related) issue.

With v4.15 (and clang 5.0.0), I did not have to disable jump labels to
get a kernel booting on a Juno platform, though I did have to pass
-fno-jump-tables to the hyp code.

Which kernel version and clang version are you using?

Thanks,
Mark.
