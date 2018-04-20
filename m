From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Clang arm64 build is broken
Date: Fri, 20 Apr 2018 16:21:32 +0100
Message-ID: <74f96c43-cfce-ca78-56e3-0e3a0f1f5a8a@arm.com>
References: <CAAeHK+wDMH_G=3UuGOda2t0g4TH4TmDAeyG-ydJwg9vmThd3eQ@mail.gmail.com>
 <c61336a2-7c66-ea48-3daa-e644403d7a6e@arm.com>
 <CAAeHK+zpAnC3Ppjq2W=r-5fYh+ceEwYymER0iLTan7+pcFDiJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeHK+zpAnC3Ppjq2W=r-5fYh+ceEwYymER0iLTan7+pcFDiJg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

[fixing up Christoffer's address]

On 20/04/18 15:59, Andrey Konovalov wrote:
> On Fri, Apr 20, 2018 at 10:13 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> The issue is that
>>> clang doesn't know about the "S" asm constraint. I reported this to
>>> clang [2], and hopefully this will get fixed. In the meantime, would
>>> it possible to work around using the "S" constraint in the kernel?
>>
>> I have no idea, I've never used clang to build the kernel. Clang isn't
>> really supported to build the arm64 kernel anyway (as you mention
>> below), and working around clang deficiencies would mean that we leave
>> with the workaround forever. I'd rather enable clang once it is at
>> feature parity with GCC.
> 
> The fact that there are some existing issues with building arm64
> kernel with clang doesn't sound like a good justification for adding
> new issues :)

Once clang is in a state where it actually compiles a full-featured
kernel that can be subsequently booted, I'll definitely care about it,
and will make sure it doesn't break. In the meantime, I'm targeting GCC,
which is the only sane option for arm64 at the moment. Waiting for clang
to fixed is not an option.

> However in this case I do believe that this is more of a bug in clang
> that should be fixed.

Absolutely. Lack of GCC compatibility is what impairs the adoption of clang.

>>> While we're here, regarding the other issue with kvm [3], I didn't
>>> receive any comments as to whether it makes sense to send the fix that
>>> adds -fno-jump-tables flag when building kvm with clang.
>>
>> Is that the only thing missing? Are you sure that there is no other way
>> for clang to generate absolute addresses that will then lead to a crash?
>> Again, I'd rather make sure we have the full picture.
> 
> Well, I have tried applying that patch and running kvm tests that I
> could find [1], and they passed (actually I think there was an issue
> with one of them, but I saw the same thing when I tried running them
> on a kernel built with GCC).
> 
> [1] https://www.linux-kvm.org/page/KVM-unit-tests

Which issue? Maybe it'd be worth reporting it?

To the original discussion about absolute addresses: I'm not so much
looking for additional testing (I trust that you've tested the patch
before sending it). I'm more after a statement from the LLVM folks
indicating in which conditions the compiler will emit absolute addresses
instead of PC-relative ones, and whether there is a way to make sure
that we always get the latter. If '-fno-jump-tables' is the only missing
flag, great. Otherwise, I'd like to know.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
