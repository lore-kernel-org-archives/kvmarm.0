From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [PATCH v2 26/28] arm64/sve: Add documentation
Date: Thu, 05 Oct 2017 17:39:24 +0100
Message-ID: <59D6603C.2040603@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com> <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/17 18:00, Dave Martin wrote:
> +prctl(PR_SVE_SET_VL, unsigned long arg)
> +
> +    Sets the vector length of the calling thread and related flags, where
> +    arg == vl | flags.
> +
> +    vl is the desired vector length, where sve_vl_valid(vl) must be true.
> +
> +    flags:
> +
> +	PR_SVE_SET_VL_INHERIT
> +
> +	    Inherit the current vector length across execve().  Otherwise, the
> +	    vector length is reset to the system default at execve().  (See
> +	    Section 9.)
> +
> +	PR_SVE_SET_VL_ONEXEC
> +
> +	    Defer the requested vector length change until the next execve().
> +	    This allows launching of a new program with a different vector
> +	    length, while avoiding runtime side effects in the caller.
> +
> +	    This also overrides the effect of PR_SVE_SET_VL_INHERIT for the
> +	    first execve().
> +
> +	    Without PR_SVE_SET_VL_ONEXEC, any outstanding deferred vector
> +	    length change is cancelled.
> +

based on later text it seems this works if exeve is
called in the same thread as prctl was called in.

this is a bit weird from user-space pov so it may
make sense to state it here explicitly.

> +    Return value: a nonnegative on success, or a negative value on error:
> +	EINVAL: SVE not supported, invalid vector length requested, or
> +	    invalid flags.
> +
> +    On success, the calling thread's vector length is changed to the largest
> +    value supported by the system that is less than or equal to vl.
> +    If vl == SVE_VL_MAX, the calling thread's vector length is changed to the
> +    largest value supported by the system.
> +
> +    The returned value describes the resulting configuration, encoded as for
> +    PR_SVE_GET_VL.
> +
> +    Changing the vector length causes all of P0..P15, FFR and all bits of
> +    Z0..V31 except for Z0 bits [127:0] .. Z31 bits [127:0] to become
> +    unspecified.  Calling PR_SVE_SET_VL with vl equal to the thread's current
> +    vector length does not constitute a change to the vector length for this
> +    purpose.
