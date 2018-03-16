From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: arm64 kvm built with clang doesn't boot
Date: Fri, 16 Mar 2018 17:18:13 +0000
Message-ID: <38b3c636-38cd-2cc5-79d0-8ccf234e2b26@arm.com>
References: <CAAeHK+xjnXnrG0p06r-QRcUucYi5vcTJOn3mSS-JVxX9_TYg4w@mail.gmail.com>
 <26a25069-ea1d-5fb3-549c-ab653f454a30@arm.com>
 <CAAeHK+zq4-mw3pCNf3nob3gN-s+aWVq7vUy1p8yY4bU4QYNNMg@mail.gmail.com>
 <2e84a842-96e8-aec4-8b85-9ee879bb323a@arm.com>
 <CAKwvOd=-TeLJn9=V_Dmj-X+qcRBcfH8tcktbm33xAx671VCYUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOd=-TeLJn9=V_Dmj-X+qcRBcfH8tcktbm33xAx671VCYUw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, Stephen Hines <srhines@google.com>, Greg Hackmann <ghackmann@google.com>, christoffer.dall@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Sami Tolvanen <samitolvanen@google.com>, takahiro.akashi@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/18 16:52, Nick Desaulniers wrote:

[dropping kernel-dynamic-tools@google.com which keeps bouncing]

> Is this in regards to: commit "arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP
> hardening support"? Has anyone tried to upstream a fix for this?  We
> probably want to be very explicit with register widths here.
What do you mean? The current code is as strict as it gets, and
explicitly tells the compiler to use the right register width, based on
the SMC call parameter types.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
