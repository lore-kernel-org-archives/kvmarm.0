From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 06/27] arm64/sve: System register and exception syndrome
 definitions
Date: Mon, 21 Aug 2017 15:26:28 +0100
Message-ID: <20170821142627.GQ6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-7-git-send-email-Dave.Martin@arm.com>
 <87a82t5kos.fsf@linaro.org>
 <8760dh5cbl.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760dh5cbl.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 21, 2017 at 01:34:38PM +0100, Alex Bennée wrote:
> 
> Alex Bennée <alex.bennee@linaro.org> writes:
> 
> > Dave Martin <Dave.Martin@arm.com> writes:

[...]

> OK no I'm working directly from the unpacked ZIP file with the rest of
> the details I think this should be:
> 
>   #define SYS_ZCR_EL2			sys_reg(3, 5, 1, 2, 0)
> 
> e.g. op1 = 101 / 5

No, that's the encoding for ZCR_EL12.  Where did you get this from?

(This encoding follows the general pattern of the v8.1 Virtualization
Host Extensions.)

[...]

> >> +#define ZCR_ELx_LEN_SHIFT	0
> >> +#define ZCR_ELx_LEN_SIZE	9
> >> +#define ZCR_ELx_LEN_MASK	0x1ff
> >> +
> 
> LEN should be 0/4/0xf
> 
> LEN, bits [3:0]
> 
> Constrains the scalable vector register length for EL1 and EL0 to
> (LEN+1)x128 bits.

The SVE supplement is not very explicit about the meaning of bits [8:4],
but they are reserved to extend the LEN field in the future, in case
that's ever needed for future architecture revisions.  I've aimed for
Linux to cope with this.

Basically bits [8:4] are read-as-zero, write-ignore today, but in
the future some or all of them may be LEN field bits.

In particular, this means that writing all bits [8:0] with 1 will
configure the largest supported vector length, even on future
architecture versions that may have a larger LEN field.

It didn't seem useful to distinguish the two classes of bits here.

Cheers
---Dave
