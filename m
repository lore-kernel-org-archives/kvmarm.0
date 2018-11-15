From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Thu, 15 Nov 2018 10:25:39 +0000
Message-ID: <20181115102537.GL3505@e103592.cambridge.arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com>
 <20181019111542.6wrvjguirglzg7vg@mbp>
 <20181019112404.GD14246@arm.com>
 <20181114181138.GB2580@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114181138.GB2580@brain-police>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Adam Wallis <awallis@codeaurora.org>, Kristina Martsenko <kristina.martsenko@arm.com>, gorcunov@openvz.org, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 14, 2018 at 06:11:39PM +0000, Will Deacon wrote:

[...]

> On Fri, Oct 19, 2018 at 12:24:04PM +0100, Will Deacon wrote:

[...]

> > FWIW: I think we should be entertaining a prctl() interface to use a new
> > key on a per-thread basis. Obviously, this would need to be used with care
> > (e.g. you'd fork(); use the prctl() and then you'd better not return from
> > the calling function!).
> > 
> > Assuming we want this (Kees -- I was under the impression that everything in
> > Android would end up with the same key otherwise?), then the question is
> > do we want:
> > 
> >   - prctl() get/set operations for the key, or
> >   - prctl() set_random_key operation, or
> >   - both of the above?
> > 
> > Part of the answer to that may lie in the requirements of CRIU, where I
> > strongly suspect they need explicit get/set operations, although these
> > could be gated on CONFIG_CHECKPOINT_RESTORE=y.
> 
> I managed to speak to the CRIU developers at LPC. The good news is that
> their preference is for a ptrace()-based interface for getting and setting
> the keys, so the only prctl() operation we need is to set a random key
> (separately for A and B).

That's good if it works for them, and it seems the cleaner approach.

_If_ they run the new thread up to a checkpoint, restoring the memory
and doing all the setup that requires in-thread syscalls, then stop it
in ptrace to finally inject the regs, then it makes sense to set the
keys at that stop -- i.e., you set the keys atomically* with the final
setting of the thread's PC.

(* with respect to the target thread)

So long as you're confident they've understood the implications of
ptrauth for CRIU, I guess this can work.


(In other news, they will also need to do some work to support SVE, but
that's unrelated to ptrauth.)

Cheers
---Dave
