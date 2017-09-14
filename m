From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 13/28] arm64/sve: Signal handling support
Date: Thu, 14 Sep 2017 10:30:20 +0100
Message-ID: <87inglaaqb.fsf@linaro.org>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com> <1504198860-12951-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-reply-to: <1504198860-12951-14-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Dave Martin <Dave.Martin@arm.com> writes:

> This patch implements support for saving and restoring the SVE
> registers around signals.
>
> A fixed-size header struct sve_context is always included in the
> signal frame encoding the thread's vector length at the time of
> signal delivery, optionally followed by a variable-layout structure
> encoding the SVE registers.
>
> Because of the need to preserve backwards compatibility, the FPSIMD
> view of the SVE registers is always dumped as a struct
> fpsimd_context in the usual way, in addition to any sve_context.
>
> The SVE vector registers are dumped in full, including bits 127:0
> of each register which alias the corresponding FPSIMD vector
> registers in the hardware.  To avoid any ambiguity about which
> alias to restore during sigreturn, the kernel always restores bits
> 127:0 of each SVE vector register from the fpsimd_context in the
> signal frame (which must be present): userspace needs to take this
> into account if it wants to modify the SVE vector register contents
> on return from a signal.
>
> FPSR and FPCR, which are used by both FPSIMD and SVE, are not
> included in sve_context because they are always present in
> fpsimd_context anyway.
>
> For signal delivery, a new helper
> fpsimd_signal_preserve_current_state() is added to update _both_
> the FPSIMD and SVE views in the task struct, to make it easier to
> populate this information into the signal frame.  Because of the
> redundancy between the two views of the state, only one is updated
> otherwise.  In order to avoid racing with a pending discard of the
> SVE state, this flush is hoisted before the sigframe layout phase,
> so that the layout and population phases see a consistent view of
> the thread.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Alex Bennée <alex.bennee@linaro.org>
>

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
