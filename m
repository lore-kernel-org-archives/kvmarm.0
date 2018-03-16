From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 17:13:49 +0000
Message-ID: <20180316171349.fodlraapz2sq2hhs@lakrids.cambridge.arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <26a25069-ea1d-5fb3-549c-ab653f454a30@arm.com>
 <CAAeHK+zq4-mw3pCNf3nob3gN-s+aWVq7vUy1p8yY4bU4QYNNMg@mail.gmail.com>
 <2e84a842-96e8-aec4-8b85-9ee879bb323a@arm.com>
 <CAKwvOd=-TeLJn9=V_Dmj-X+qcRBcfH8tcktbm33xAx671VCYUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOd=-TeLJn9=V_Dmj-X+qcRBcfH8tcktbm33xAx671VCYUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: marc.zyngier@arm.com, Andrey Konovalov <andreyknvl@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, christoffer.dall@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, kernel-dynamic-tools <kernel-dynamic-tools@google.com>, Sami Tolvanen <samitolvanen@google.com>, takahiro.akashi@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 16, 2018 at 04:52:08PM +0000, Nick Desaulniers wrote:
> + Sami (Google), Takahiro (Linaro)
> 
> Just so I fully understand the problem enough to articulate it, we'd be
> looking for the compiler to keep the jump tables for speed (I would guess
> -fno-jump-tables would emit an if-else chain) but only emit relative jumps
> (not absolute jumps)?

Our main concern is that there is no absolute addressing. If that rules
out using a relative jump table, that's ok.

We want to avoid the fragility of collecting -f-no-* options as future
compiler transformations end up introducing absolute addressing.

Thanks,
Mark.
