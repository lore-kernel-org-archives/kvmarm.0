From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 21/21] arm64: KVM: Remove weak attributes
Date: Wed, 2 Dec 2015 17:21:34 +0100
Message-ID: <20151202162134.GN18376@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-22-git-send-email-marc.zyngier@arm.com>
 <20151202114732.GA18376@cbox>
 <565F0C8D.9010505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <565F0C8D.9010505@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 02, 2015 at 03:21:49PM +0000, Marc Zyngier wrote:
> On 02/12/15 11:47, Christoffer Dall wrote:
> > On Fri, Nov 27, 2015 at 06:50:15PM +0000, Marc Zyngier wrote:
> >> As we've now switched to the new world switch implementation,
> >> remove the weak attributes, as nobody is supposed to override
> >> it anymore.
> > 
> > Why not remove the aliases and change the callers?
> 
> This is likely to be a bigger patch, and it would affect the 32bit as
> well. So far, I'm choosing to keep things the same. Another solution
> would be to completely drop the aliases, and just rename the new
> function to have the old names.
> 
> I don't mind either way.
> 
I didn't think of the 32-bit side.  I think eventually we should get rid
of the aliases and just have the funcitons named as they are called, but
there's no rush.  We can wait until we've the done the 32-bit side if
you prefer.

-Christoffer
