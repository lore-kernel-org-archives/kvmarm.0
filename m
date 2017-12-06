From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 15/30] arm64/sve: Signal handling support
Date: Wed, 6 Dec 2017 11:56:50 -0800
Message-ID: <CAGXu5jJgsAg1VBMbx=mV3ep4hzs+1G46Sow4eeFqCK31b_sORA@mail.gmail.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com> <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509465082-30427-16-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch <linux-arch@vger.kernel.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha <libc-alpha@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 31, 2017 at 8:51 AM, Dave Martin <Dave.Martin@arm.com> wrote:
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
> otherwise.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
>
> ---
>
> **Dropped** Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> (Non-trivial changes.)
>
> Changes since v4
> ----------------
>
> Requested by Will Deacon:
>
>  * Fix inconsistent return semantics in restore_sve_fpsimd_context().
>
>    Currently a nonzero return value from __copy_from_user() is passed
>    back as-is to the caller or restore_sve_fpsimd_context(), rather than
>    translating it do an error code as is done elsewhere.
>
>    Callers of restore_sve_fpsimd_context() only care whether the return
>    value is 0 or not, so this isn't a big deal, but it is more
>    consistent to return proper error codes on failure in case we grow a
>    use for them later.
>
>    This patch returns -EFAULT in the __copy_from_user() error cases
>    that weren't explicitly handled.
>
> Miscellaneous:
>
>  * Change inconsistent copy_to_user() calls to __copy_to_user() in
>    preserve_sve_context().
>
>    There are already __put_user_error() calls here.
>
>    The whole extended signal frame is already checked for
>    access_ok(VERIFY_WRITE) in get_sigframe().

Verifying all these __copy_to/from_user() calls is rather non-trivial.
For example, I had to understand that the access_ok() check actually
spans memory that both user->sigframe and user->next_frame point into.
And it isn't clear to me that all users of apply_user_offset() are
within this range too, along with other manually calculated offsets in
setup_sigframe().

And it's not clear if parse_user_sigframe() is safe either. Are
user->fpsimd and user->sve checked somewhere? It seems like it's
safely contained by in sf->uc.uc_mcontext.__reserved, but it's hard to
read, though I do see access_ok() checks against __reserved at the end
of the while loop.

Can we just drop all the __... calls for the fully checked
copy_to/from_user() instead?

-Kees

--=20
Kees Cook
Pixel Security
