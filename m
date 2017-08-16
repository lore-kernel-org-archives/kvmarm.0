From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 23/27] arm64/sve: KVM: Hide SVE from CPU features exposed
 to guests
Date: Wed, 16 Aug 2017 12:22:34 +0100
Message-ID: <20170816112234.GD6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-24-git-send-email-Dave.Martin@arm.com>
 <39b6ee07-1258-e733-3495-38b0d31ab800@arm.com>
 <20170816105438.GA6321@e103592.cambridge.arm.com>
 <63ca85dc-24fe-ca82-c83b-e3235766c86c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <63ca85dc-24fe-ca82-c83b-e3235766c86c@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 16, 2017 at 12:10:53PM +0100, Marc Zyngier wrote:
> On 16/08/17 11:54, Dave Martin wrote:
> > On Tue, Aug 15, 2017 at 05:37:55PM +0100, Marc Zyngier wrote:
> >> On 09/08/17 13:05, Dave Martin wrote:

[...]

> >>> +	if (id == SYS_ID_AA64PFR0_EL1) {
> >>> +		static bool printed;
> >>> +
> >>> +		if ((val & (0xfUL << ID_AA64PFR0_SVE_SHIFT)) && !printed) {
> >>> +			kvm_info("SVE unsupported for guests, suppressing\n");
> >>> +			printed = true;
> >>> +		}
> >>
> >> Ideally, this should be a vcpu_unimpl_once(). But:
> >> - it doesn't exist
> >> - vcpu_unimpl looks hopelessly x86 specific
> > 
> > Yeah, I looked for an appropriate function and didn't find one ... and
> > writing one just for this seemed overkill.
> > 
> >> How about turning it into a pr_err_once() instead?
> > 
> > Can do, though should it be an err?
> > 
> > No error has occurred here, rather I want people who discover that their
> > guest mysteriously doesn't see SVE gets a clue about why.
> An "err" is a good way to make it appear on the console. If you want to
> make it noticed, that's the way.

OK, I was concerned that overuse of err might be frowned upon.

If this is the preferred way to signal such things, I'm happy to that.

Cheers
---Dave
