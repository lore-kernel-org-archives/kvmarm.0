From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 26/28] arm64/sve: Add documentation
Date: Mon, 9 Oct 2017 10:49:32 +0100
Message-ID: <20171009094930.GD3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
 <59D7A4AF.40408@arm.com>
 <20171006173715.GC3611@e103592.cambridge.arm.com>
 <878tgkbr6m.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878tgkbr6m.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 09, 2017 at 10:34:25AM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:
> 
> > On Fri, Oct 06, 2017 at 04:43:43PM +0100, Szabolcs Nagy wrote:
> >> On 31/08/17 18:00, Dave Martin wrote:
> >> > +9.  System runtime configuration
> >> > +--------------------------------
> >> > +
> >> > +* To mitigate the ABI impact of expansion of the signal frame, a policy
> >> > +  mechanism is provided for administrators, distro maintainers and developers
> >> > +  to set the default vector length for userspace processes:
> >> > +
> >> > +/proc/cpu/sve_default_vector_length
> >>
> >>
> >> elsewhere in the patch series i see
> >>
> >> /proc/sys/abi/sve_default_vector_length
> >>
> >> is this supposed to be the same?
> >
> > Good spot, thanks!
> >
> > /proc/cpu/ was the old location: they should both say /proc/abi/.
> > I'll fix it.
> 
> Isn't /sys (or rather sysfs) the preferred location for modern control
> knobs that mirror the kernels object model or is SVE a special case for
> extending /proc?

I couldn't figure out which kernel object this maps to.  There's no
device, no driver.  This isn't even per-cpu.

sysctl is already used for similar knobs to this one, so I followed that
precedent -- though if someone argues strongly enough it could be
changed.

Are there already examples of arch controls like this in sysfs?  I
wasn't aware of any, but I didn't look all that hard...

Cheers
---Dave
