From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Mon, 10 Dec 2018 16:09:35 +0000
Message-ID: <20181210160934.GF4048@arrakis.emea.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
 <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
 <20181210120330.GB4048@arrakis.emea.arm.com>
 <ba48e082-3e47-43bc-77d1-97d741c59284@linaro.org>
 <20181210142944.GA13100@edgewater-inn.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181210142944.GA13100@edgewater-inn.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Richard Henderson <richard.henderson@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, Steve Capper <Steve.Capper@arm.com>, linux-kernel@vger.kernel.org, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dave P Martin <dave.martin@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 10, 2018 at 02:29:45PM +0000, Will Deacon wrote:
> On Mon, Dec 10, 2018 at 08:22:06AM -0600, Richard Henderson wrote:
> > On 12/10/18 6:03 AM, Catalin Marinas wrote:
> > >> However, it won't be too long before someone implements support for
> > >> ARMv8.2-LVA, at which point, without changes to mandatory pointer tagging, we
> > >> will only have 3 authentication bits: [54:52].  This seems useless and easily
> > >> brute-force-able.
[...]
> > Perhaps the opt-in should be at exec time, with ELF flags (or equivalent) on
> > the application.  Because, as you say, changing the shape of the PAC in the
> > middle of execution is in general not possible.
> 
> I think we'd still have a potential performance problem with that approach,
> since we'd end up having to context-switch TCR.T0SZ, which is permitted to
> be cached in a TLB and would therefore force us to introduce TLB
> invalidation when context-switching between tasks using 52-bit VAs and tasks
> using 48-bit VAs.
> 
> There's a chance we could get the architecture tightened here, but it's
> not something we've pushed for so far and it depends on what's already been
> built.

Just a quick summary of our internal discussion:

ARMv8.3 also comes with a new bit, TCR_EL1.TBIDx, which practically
disables TBI for code pointers. This bit allows us to use 11 bits for
code PtrAuth with 52-bit VA.

Now, the problem is that TBI for code pointers is user ABI, so we can't
simply disable it. We may be able to do this with memory tagging since
that's an opt-in feature (prctl) where the user is aware that the top
byte of a pointer is no longer ignored. However, that's probably for a
future discussion.

-- 
Catalin
