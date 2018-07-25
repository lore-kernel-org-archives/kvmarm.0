From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 10/16] KVM: arm64: Add a vcpu flag to control SVE
 visibility for the guest
Date: Wed, 25 Jul 2018 15:41:16 +0100
Message-ID: <20180725144115.GO4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-11-git-send-email-Dave.Martin@arm.com>
 <20180719110810.2edkoz53b6vrafum@kamzik.brq.redhat.com>
 <20180725114103.GG4240@e103592.cambridge.arm.com>
 <20180725134359.rebcjfsigkvbs2n5@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B963F49F89
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:41:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbXhUU5dm4HT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 10:41:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B3534045F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 10:41:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180725134359.rebcjfsigkvbs2n5@kamzik.brq.redhat.com>
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

On Wed, Jul 25, 2018 at 03:43:59PM +0200, Andrew Jones wrote:
> On Wed, Jul 25, 2018 at 12:41:06PM +0100, Dave Martin wrote:

[...]

> > The main purpose of system_supports_sve() here is to shadow the check on
> > vcpu_arch->flags with a static branch.  If the system doesn't support
> > SVE, we don't pay the runtime cost of the dynamic check on
> > vcpu_arch->flags.
> > 
> > If the kernel is built with CONFIG_ARM64_SVE=n, the dynamic check should
> > be entirely optimised away by the compiler.
> 
> Ah, that makes sense. Thanks for clarifying it.
> 
> > 
> > I'd rather not add an explicit comment for this because the same
> > convention is followed elsewhere -- thus for consistency the comment
> > would need to be added in a lot of places.
> 
> Agreed that we don't need a comment. A note in the commit message might
> have been nice though.

Sure, I'll add something in the respin.

Cheers
---Dave
