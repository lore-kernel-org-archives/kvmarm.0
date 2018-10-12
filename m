From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 01/17] arm64: add pointer authentication register bits
Date: Fri, 12 Oct 2018 10:50:08 +0100
Message-ID: <20181012095008.swtk4gazlrc6rwdj@lakrids.cambridge.arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-2-kristina.martsenko@arm.com>
 <20181011162814.GC17000@arm.com>
 <20181012085352.xi6rkcpm62iqd6ru@lakrids.cambridge.arm.com>
 <20181012085605.GB11847@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181012085605.GB11847@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 12, 2018 at 09:56:05AM +0100, Will Deacon wrote:
> On Fri, Oct 12, 2018 at 09:53:54AM +0100, Mark Rutland wrote:
> > On Thu, Oct 11, 2018 at 05:28:14PM +0100, Will Deacon wrote:
> > > On Fri, Oct 05, 2018 at 09:47:38AM +0100, Kristina Martsenko wrote:
> > 
> > > > +#define ESR_ELx_EC_PAC		(0x09)
> > > 
> > > Really minor nit: but shouldn't this be ESR_EL2_EC_PAC, since this trap
> > > can't occur at EL1 afaict?
> > 
> > It can also be taken to EL3 dependent on SCR_EL3.API.
> > 
> > We use ESR_ELx_EC_<foo> for other exceptions that can't be taken to EL1
> > (e.g. ESR_ELx_EC_SMC{32,64}), so I think it would be more consistent to
> > leave this as ESR_ELx_EC_PAC rather than ESR_EL2_EC_PAC.
> 
> Fair enough, but if we grow a different EC for ESR_EL1 that uses encoding
> 0x09, this all falls apart.

We haven't had overlapping encodings so far, and if we did, we'd want to
apply some policy to all of these definitions, no?

> At the very list, maybe we should comment those that are EL2 or higher
> with /* EL2 and above */ or just fix the misnomer and drop the useless
> _ELx_ part of the names completely.

A comment sounds fine to me.

I'm not sure that s/_ELx// buys us any clarity, though; I don't think
that ESR_EC_PAC is clearly more constrained than ESR_ELx_EC_PAC.

Thanks,
Mark.
