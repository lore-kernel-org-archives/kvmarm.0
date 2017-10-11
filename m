From: Szabolcs Nagy <szabolcs.nagy@arm.com>
Subject: Re: [RFC PATCH v3 27/28] arm64: signal: Report signal frame size
 to userspace via auxv
Date: Wed, 11 Oct 2017 11:19:03 +0100
Message-ID: <59DDF017.7090203@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com> <1507660725-7986-28-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-28-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?windows-1252?Q?Alex_Benn?= =?windows-1252?Q?=E9e?= <alex.bennee@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/10/17 19:38, Dave Martin wrote:
> Stateful CPU architecture extensions may require the signal frame
> to grow to a size that exceeds the arch's MINSIGSTKSZ #define.
> However, changing this #define is an ABI break.
> 
> To allow userspace the option of determining the signal frame size
> in a more forwards-compatible way, this patch adds a new auxv entry
> tagged with AT_MINSIGSTKSZ, which provides the maximum signal frame
> size that the process can observe during its lifetime.
> 
> If AT_MINSIGSTKSZ is absent from the aux vector, the caller can
> assume that the MINSIGSTKSZ #define is sufficient.  This allows for
> a consistent interface with older kernels that do not provide
> AT_MINSIGSTKSZ.
> 

the posix sigaltstack api shall fail with ENOMEM
if smaller than MINSIGSTKSZ stack size is used.

so it is important to note somewhere if AT_MINSIGSTKSZ
is intended to be always >= MINSIGSTKSZ define (which
is rounded up to 5k) or it may be smaller as it provides
the precise value of the largest signal frame.

(i think it makes sense for it to be a precise value,
but then users should do the >= check before calling
the sigaltstack api, so they should be aware of this
issue)
