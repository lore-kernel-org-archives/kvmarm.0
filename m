From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: Clang arm64 build is broken
Date: Fri, 20 Apr 2018 16:59:35 +0200
Message-ID: <CAAeHK+zpAnC3Ppjq2W=r-5fYh+ceEwYymER0iLTan7+pcFDiJg@mail.gmail.com>
References: <CAAeHK+wDMH_G=3UuGOda2t0g4TH4TmDAeyG-ydJwg9vmThd3eQ@mail.gmail.com>
 <c61336a2-7c66-ea48-3daa-e644403d7a6e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c61336a2-7c66-ea48-3daa-e644403d7a6e@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 20, 2018 at 10:13 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> The issue is that
>> clang doesn't know about the "S" asm constraint. I reported this to
>> clang [2], and hopefully this will get fixed. In the meantime, would
>> it possible to work around using the "S" constraint in the kernel?
>
> I have no idea, I've never used clang to build the kernel. Clang isn't
> really supported to build the arm64 kernel anyway (as you mention
> below), and working around clang deficiencies would mean that we leave
> with the workaround forever. I'd rather enable clang once it is at
> feature parity with GCC.

The fact that there are some existing issues with building arm64
kernel with clang doesn't sound like a good justification for adding
new issues :)

However in this case I do believe that this is more of a bug in clang
that should be fixed.

>> While we're here, regarding the other issue with kvm [3], I didn't
>> receive any comments as to whether it makes sense to send the fix that
>> adds -fno-jump-tables flag when building kvm with clang.
>
> Is that the only thing missing? Are you sure that there is no other way
> for clang to generate absolute addresses that will then lead to a crash?
> Again, I'd rather make sure we have the full picture.

Well, I have tried applying that patch and running kvm tests that I
could find [1], and they passed (actually I think there was an issue
with one of them, but I saw the same thing when I tried running them
on a kernel built with GCC).

[1] https://www.linux-kvm.org/page/KVM-unit-tests
