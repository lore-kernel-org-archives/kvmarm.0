From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 12/16] KVM: arm64/sve: Context switch the SVE registers
Date: Wed, 25 Jul 2018 15:12:12 +0100
Message-ID: <20180725141212.GL4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-13-git-send-email-Dave.Martin@arm.com>
 <20180719131338.jsgezassnjhdbotd@kamzik.brq.redhat.com>
 <20180725115045.GJ4240@e103592.cambridge.arm.com>
 <20180725135733.wx4eqrp7cyghcigq@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0127049F89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:12:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcWEJ2cNX9va for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:12:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0CC4045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:12:17 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180725135733.wx4eqrp7cyghcigq@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 25, 2018 at 03:57:33PM +0200, Andrew Jones wrote:
> On Wed, Jul 25, 2018 at 12:50:45PM +0100, Dave Martin wrote:
> > > > +	if (system_supports_sve() && guest_has_sve)
> > 
> > As elsewhere, the system_supports_sve() check uses a static key and
> > should be very cheap (or free in a CONFIG_ARM64_SVE=n kernel).
> >
> 
> Yup, I'm clear on that now. Thanks again for explaining. It might
> be nice for a small helper function in this case in order to avoid
> the 'system_supports_sve() &&' everywhere and the chance that the
> order of the checks gets swapped during some code refactoring someday.

This is what guest_has_sve() is for.

In hyp_switch_fpsimd() I wanted to avoid runtime checks wherever
possible, but it may be overkill to keep checking system_supports_sve()
like this.

It might take some benchmarking to figure out whether the extra checks
have any merit here...

Cheers
---Dave
