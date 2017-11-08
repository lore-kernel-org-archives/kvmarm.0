From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Wed, 8 Nov 2017 16:11:32 +0000
Message-ID: <20171108161116.GA20202@e103592.cambridge.arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
 <87vaimql46.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vaimql46.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 01:22:33PM +0000, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > This patch implements support for saving and restoring the SVE
> > registers around signals.
> >
> > A fixed-size header struct sve_context is always included in the
> > signal frame encoding the thread's vector length at the time of
> > signal delivery, optionally followed by a variable-layout structure
> > encoding the SVE registers.
> >
> > Because of the need to preserve backwards compatibility, the FPSIMD
> > view of the SVE registers is always dumped as a struct
> > fpsimd_context in the usual way, in addition to any sve_context.
> >
> > The SVE vector registers are dumped in full, including bits 127:0
> > of each register which alias the corresponding FPSIMD vector
> > registers in the hardware.  To avoid any ambiguity about which
> > alias to restore during sigreturn, the kernel always restores bits
> > 127:0 of each SVE vector register from the fpsimd_context in the
> > signal frame (which must be present): userspace needs to take this
> > into account if it wants to modify the SVE vector register contents
> > on return from a signal.
> >
> > FPSR and FPCR, which are used by both FPSIMD and SVE, are not
> > included in sve_context because they are always present in
> > fpsimd_context anyway.
> >
> > For signal delivery, a new helper
> > fpsimd_signal_preserve_current_state() is added to update _both_
> > the FPSIMD and SVE views in the task struct, to make it easier to
> > populate this information into the signal frame.  Because of the
> > redundancy between the two views of the state, only one is updated
> > otherwise.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Cc: Alex Bennée <alex.bennee@linaro.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Will Deacon <will.deacon@arm.com>
> 
> After adding SVE support for RISU I was able to confirm consistent
> signal delivery with a decent context over multiple runs and after
> hacking echo "32" > /proc/sys/abi/sve_default_vector_length to change
> the default length the tests would fail (as expected).
> 
> Tested-by: Alex Bennée <alex.bennee@linaro.org>

Good to have confirmation of this, thanks

[...]

Cheers
---Dave
