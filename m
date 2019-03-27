From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 9/10] KVM: arm64: docs: document KVM support of
 pointer authentication
Date: Wed, 27 Mar 2019 10:44:29 +0000
Message-ID: <20190327104428.GV3567@e103592.cambridge.arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-10-git-send-email-amit.kachhap@arm.com>
 <23e4a9d4-e9e1-2c1f-32ce-e7fd96080437@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23e4a9d4-e9e1-2c1f-32ce-e7fd96080437@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 25, 2019 at 08:05:49PM +0000, Kristina Martsenko wrote:
> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
> > This adds sections for KVM API extension for pointer authentication.
> > A brief description about usage of pointer authentication for KVM guests
> > is added in the arm64 documentations.
> > 
> > Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> 
> I think it makes sense to also update the Kconfig symbol description for
> CONFIG_ARM64_PTR_AUTH, since it currently only mentions userspace
> support, but now the option also enables KVM guest support.
> 
> It's also worth mentioning that CONFIG_ARM64_VHE=y is required for guest
> support.

Is it worth making this dependency explicit in Kconfig?

For SVE, I have

config ARM64_SVE
	depends on !KVM || ARM64_VHE

to implement this.

Cheers
---Dave
