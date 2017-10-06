From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 26/28] arm64/sve: Add documentation
Date: Fri, 6 Oct 2017 18:37:15 +0100
Message-ID: <20171006173715.GC3611@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
 <59D7A4AF.40408@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59D7A4AF.40408@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>nd@arm.com, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:43:43PM +0100, Szabolcs Nagy wrote:
> On 31/08/17 18:00, Dave Martin wrote:
> > +9.  System runtime configuration
> > +--------------------------------
> > +
> > +* To mitigate the ABI impact of expansion of the signal frame, a policy
> > +  mechanism is provided for administrators, distro maintainers and developers
> > +  to set the default vector length for userspace processes:
> > +
> > +/proc/cpu/sve_default_vector_length
> 
> 
> elsewhere in the patch series i see
> 
> /proc/sys/abi/sve_default_vector_length
> 
> is this supposed to be the same?

Good spot, thanks!

/proc/cpu/ was the old location: they should both say /proc/abi/.
I'll fix it.

---Dave
