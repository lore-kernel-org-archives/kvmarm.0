From: Andrey Konovalov <andreyknvl@google.com>
Subject: Clang arm64 build is broken
Date: Thu, 19 Apr 2018 19:06:31 +0200
Message-ID: <CAAeHK+wDMH_G=3UuGOda2t0g4TH4TmDAeyG-ydJwg9vmThd3eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc!

Your recent commit [1] broke clang build on arm64. The issue is that
clang doesn't know about the "S" asm constraint. I reported this to
clang [2], and hopefully this will get fixed. In the meantime, would
it possible to work around using the "S" constraint in the kernel?

While we're here, regarding the other issue with kvm [3], I didn't
receive any comments as to whether it makes sense to send the fix that
adds -fno-jump-tables flag when building kvm with clang.

Thanks!

[1] https://github.com/torvalds/linux/commit/44a497abd621a71c645f06d3d545ae2f46448830

[2] https://github.com/ClangBuiltLinux/linux/issues/13

[3] https://lkml.org/lkml/2018/3/16/476
