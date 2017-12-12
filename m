From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 07/19] arm64: insn: Add encoder for bitwise operations
 using litterals
Date: Tue, 12 Dec 2017 18:56:06 +0000
Message-ID: <CAFEAcA9jSbx4UUgwn-GWJ3iU-uUJsW_aNUxUp5ck1DtGMC+Qnw@mail.gmail.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com> <20171211144937.4537-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171211144937.4537-8-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 December 2017 at 14:49, Marc Zyngier <marc.zyngier@arm.com> wrote:
> We lack a way to encode operations such as AND, ORR, EOR that take
> an immediate value. Doing so is quite involved, and is all about
> reverse engineering the decoding algorithm described in the
> pseudocode function DecodeBitMasks().

Is it possible to borrow the existing tested implementation
which a compiler surely must have for this, rather than having
to reinvent this rather complicated wheel? Here's LLVM's version:

https://github.com/llvm-mirror/llvm/blob/93e6e5414ded14bcbb233baaaa5567132fee9a0c/lib/Target/AArch64/MCTargetDesc/AArch64AddressingModes.h#L209

(confirming that the LLVM license is GPLv2 compatible is
left as an exercise for the reader, but I'm pretty sure it is)

PS: typo in subject: 'literal'.

thanks
-- PMM
