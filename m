From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Mon, 10 Dec 2018 12:03:30 +0000
Message-ID: <20181210120330.GB4048@arrakis.emea.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
 <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a31ca10a-ee1a-71fb-2c3d-a6184e12b543@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Henderson <richard.henderson@linaro.org>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Steve Capper <Steve.Capper@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Dec 09, 2018 at 09:41:31AM -0600, Richard Henderson wrote:
> On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> > When pointer authentication is in use, data/instruction pointers have a
> > number of PAC bits inserted into them. The number and position of these
> > bits depends on the configured TCR_ELx.TxSZ and whether tagging is
> > enabled. ARMv8.3 allows tagging to differ for instruction and data
> > pointers.
> 
> At this point I think it's worth starting a discussion about pointer tagging,
> and how we can make it controllable and not mandatory.
> 
> With this patch set, we are enabling 7 authentication bits: [54:48].
> 
> However, it won't be too long before someone implements support for
> ARMv8.2-LVA, at which point, without changes to mandatory pointer tagging, we
> will only have 3 authentication bits: [54:52].  This seems useless and easily
> brute-force-able.

Such support is already here (about to be queued):

https://lore.kernel.org/linux-arm-kernel/20181206225042.11548-1-steve.capper@arm.com/

> I assume that pointer tagging is primarily used by Android, since I'm not aware
> of anything else that uses it at all.

I would expect it to be enabled more widely (Linux distros), though only
the support for instructions currently in the NOP space.

> Unfortunately, there is no obvious path to making this optional that does not
> break compatibility with Documentation/arm64/tagged-pointers.txt.

There is also the ARMv8.5 MTE (memory tagging) which relies on tagged
pointers.

> I've been thinking that there ought to be some sort of global setting, akin to
> /proc/sys/kernel/randomize_va_space, as well as a prctl which an application
> could use to selectively enable TBI/TBID for an application that actually uses
> tagging.

An alternative would be to allow the opt-in to 52-bit VA, leaving it at
48-bit by default. However, it has the problem of changing the PAC size
and not being able to return.

> The global /proc setting allows the default to remain 1, which would let any
> application using tagging to continue working.  If there are none, the sysadmin
> can set the default to 0.  Going forward, applications could be updated to use
> the prctl, allowing more systems to set the default to 0.
> 
> FWIW, pointer authentication continues to work when enabling TBI, but not the
> other way around.  Thus the prctl could be used to enable TBI at any point, but
> if libc is built with PAuth, there's no way to turn it back off again.

This may work but, as you said, TBI is user ABI at this point, we can't
take it away now (at the time we didn't forsee the pauth).

Talking briefly with Will/Kristina/Mark, I think the best option is to
make 52-bit VA default off in the kernel config. Whoever needs it
enabled (enterprise systems) should be aware of the reduced PAC bits. I
don't really think we have a better solution.

-- 
Catalin
