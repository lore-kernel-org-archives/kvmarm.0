From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v3 27/28] arm64: signal: Report signal frame size to
 userspace via auxv
Date: Wed, 11 Oct 2017 14:14:13 +0100
Message-ID: <20171011131411.GU3602@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-28-git-send-email-Dave.Martin@arm.com>
 <59DDF017.7090203@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59DDF017.7090203@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, nd <nd@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Richard Sandiford <Richard.Sandiford@arm.com>, "tokamoto@jp.fujitsu.com" <tokamoto@jp.fujitsu.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 11, 2017 at 11:19:03AM +0100, Szabolcs Nagy wrote:
> On 10/10/17 19:38, Dave Martin wrote:
> > Stateful CPU architecture extensions may require the signal frame
> > to grow to a size that exceeds the arch's MINSIGSTKSZ #define.
> > However, changing this #define is an ABI break.
> > 
> > To allow userspace the option of determining the signal frame size
> > in a more forwards-compatible way, this patch adds a new auxv entry
> > tagged with AT_MINSIGSTKSZ, which provides the maximum signal frame
> > size that the process can observe during its lifetime.
> > 
> > If AT_MINSIGSTKSZ is absent from the aux vector, the caller can
> > assume that the MINSIGSTKSZ #define is sufficient.  This allows for
> > a consistent interface with older kernels that do not provide
> > AT_MINSIGSTKSZ.
> > 
> 
> the posix sigaltstack api shall fail with ENOMEM
> if smaller than MINSIGSTKSZ stack size is used.
> 
> so it is important to note somewhere if AT_MINSIGSTKSZ
> is intended to be always >= MINSIGSTKSZ define (which
> is rounded up to 5k) or it may be smaller as it provides
> the precise value of the largest signal frame.
> 
> (i think it makes sense for it to be a precise value,
> but then users should do the >= check before calling
> the sigaltstack api, so they should be aware of this
> issue)

This is a good point, and one that I don't have an answer for yet.

POSIX[1] says that sigaltstack() _shall_ return EPERM if ss_size
< MINSIGSTKSZ.

I don't know the full rationale behind this.

The ENOMEM return here doesn't guarantee that signal delivery will
definitely fail or compromise safety when ss_size or less of stack is
available.

A 0 return doesn't guarantee that signal delivery on the registered
alternate stack will succeed or be safe.

So while the ENOMEM return has some sanity-check value, it's very
limited in its usefulness.


I currently saw no good reason to misrepresent the true signal frame
size in AT_MINSIGSTKSZ, so it is currently a precise value that can be
< MINSIGSTKSZ (and is, in the default case).

In an ideal world, my preference would be to relax the check in
sigaltstack() to check >= AT_MINSIGSTKSZ, but it is technically an ABI
break...


We _could_ paper over this by rounding up the AT_MINSIGSTKSZ value
reported by the kernel to be always >= MINSIGSTKSZ.  This seems ugly,
but may be the most pragmatic option.


Thoughts?

Cheers
---Dave


[1] SUSv7 / IEEE Std 1003.1-2008 (2016): sigaltstack
http://pubs.opengroup.org/onlinepubs/9699919799/functions/sigaltstack.html
