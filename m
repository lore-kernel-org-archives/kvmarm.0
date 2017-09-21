From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Thu, 21 Sep 2017 12:19:45 +0100
Message-ID: <20170921111937.GA17434@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-15-git-send-email-Dave.Martin@arm.com>
 <FC5BA359-D37C-493C-87CD-146B83D3CCB5@arm.com>
 <20170920110902.GG24231@e103592.cambridge.arm.com>
 <E82895B2-3F95-4A54-8703-D654221F8CBA@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E82895B2-3F95-4A54-8703-D654221F8CBA@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Alan Hayward <Alan.Hayward@arm.com>
Cc: Dave Martin <dave.martin@foss.arm.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "gdb@sourceware.org" <gdb@sourceware.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Yao Qi <Yao.Qi@arm.com>, Will Deacon <Will.Deacon@arm.com>, Richard Sandiford <Richard.Sandiford@arm.com>, nd <nd@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 20, 2017 at 06:08:21PM +0000, Alan Hayward wrote:
> 
> > On 20 Sep 2017, at 12:09, Dave Martin <dave.martin@foss.arm.com> wrote:

[...]

> >> Given, sve_set_vector_length is called when setting the vector length in
> >> PTRACE_SETREGSET, it looks to me like if you set VL to a value that’s not
> >> supported by the hardware, then it’s going to round down to the previous value.
> >> Is that correct? I’m not sure if that’s explained in the docs?
> > 
> > Does this cover it?
> > 
> > "On success, the calling thread's vector length is changed to the
> > largest value supported by the system that is less than or equal to vl."
> > 
> > (For ptrace, I just cross-reference the PR_SVE_SET_VL behaviour, above.)
> 
> For ptrace is it worth mentioning user should do a GET after a SET to confirm
> what VL value was actually set?

This seems worth a clarification -- I'd thought this was already
mentioned, but it isn't.

How about:

  The caller must make a further GETREGSET call if it needs to know what VL is
  actually set by SETREGSET, unless is it known in advance that the requested
  VL is supported.


[...]

Cheers
---Dave
