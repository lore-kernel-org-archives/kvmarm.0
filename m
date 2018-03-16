From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 14:49:00 +0100
Message-ID: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi!

I've recently tried to boot clang built kernel on real hardware
(Odroid C2 board) instead of using a VM. The issue that I stumbled
upon is that arm64 kvm built with clang doesn't boot.

Adding -fno-jump-tables compiler flag to arch/arm64/kvm/* helps. There
was a patch some time ago that did exactly that
(https://patchwork.kernel.org/patch/10060381/), but it wasn't accepted
AFAICT (see the discussion on that thread).

What would be the best way to get this fixed?

I've also had to disable CONFIG_JUMP_LABEL to get the kernel boot
(even without kvm enabled), but that might be a different (though
related) issue.

Thanks!
