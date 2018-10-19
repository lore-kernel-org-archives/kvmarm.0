From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Fri, 19 Oct 2018 16:54:10 +0100
Message-ID: <20181019155410.wsbmhluq4xqcyty2@lakrids.cambridge.arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com>
 <20181019111542.6wrvjguirglzg7vg@mbp>
 <20181019112404.GD14246@arm.com>
 <CAGXu5j+2axuzPJji_eCvMZDiPvrPsP3kAnG0CY_rsL5c=uFQFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+2axuzPJji_eCvMZDiPvrPsP3kAnG0CY_rsL5c=uFQFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-arch <linux-arch@vger.kernel.org>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 19, 2018 at 08:36:45AM -0700, Kees Cook wrote:
> On Fri, Oct 19, 2018 at 4:24 AM, Will Deacon <will.deacon@arm.com> wrote:
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
> Oh CRIU. Yikes. I'd like the get/set to be gated by the CONFIG, yes.
> No reason to allow explicit access to the key (and selected algo) if
> we don't have to.

As a minor aside, the PAC algorithm (which can be IMPLEMENTATION
DEFINED) is fixed in HW, and cannot be selected dynamically.

Thus if a process is using pointer authentication, it would not be
possible for CRIU to migrate that process to a CPU with a different PAC
algorithm.

Thanks,
Mark.
