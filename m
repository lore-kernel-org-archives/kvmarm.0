From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 15:50:19 +0100
Message-ID: <CAAeHK+ydD1TWpUkvFojwaP_F1B+UYtT_YW6G94JriXvZdu6zwQ@mail.gmail.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316141313.q5vjmj627rv7r7kf@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 16, 2018 at 3:13 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> I think that patch is our best bet currently, but to save ourselves pain
> in future it would be *really* nice if GCC and clang could provide an
> option line -fno-absolute-addressing that would implicitly disable any
> feature that would generate an absolute address as jump tables do.
>

Let me know if you want me to mail that patch again.

Perhaps Nick can comment on whether something like
-fno-absolute-addressing would be feasible in clang. Although even if
it gets implemented, it won't fix the already released clang versions.

> With v4.15 (and clang 5.0.0), I did not have to disable jump labels to
> get a kernel booting on a Juno platform, though I did have to pass
> -fno-jump-tables to the hyp code.
>
> Which kernel version and clang version are you using?

I've rechecked and I think I was wrong here. I disabled
COFNIG_JUMP_LABEL while trying to get the kernel booting before I
added the kvm flags. It seems it's not needed after all.

But just for the reference, I'm using 4.16-rc4 with a patch to fix
SMCCC issues that you mentioned. As for clang, I'm using LLVM revision
325711 (a couple of weeks old).
