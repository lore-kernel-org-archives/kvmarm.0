From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 23/27] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Date: Wed, 10 Apr 2019 13:35:19 +0100
Message-ID: <20190410123518.GH3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-24-git-send-email-Dave.Martin@arm.com>
 <20190404203109.lrt5czzlqpritecd@kamzik.brq.redhat.com>
 <20190405093610.GN3567@e103592.cambridge.arm.com>
 <20190405102204.m4depbrkn5f3btnz@kamzik.brq.redhat.com>
 <20190405140640.GC3567@e103592.cambridge.arm.com>
 <20190405154131.ecbq33b3o7pvfmrw@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7B14A47A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:35:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rRMppz2zfqGV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 08:35:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E29D94A36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 08:35:23 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190405154131.ecbq33b3o7pvfmrw@kamzik.brq.redhat.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 05:41:31PM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 03:06:40PM +0100, Dave Martin wrote:

[...]

> > Clearing KVM_ARM64_GUEST_HAS_SVE could be done on finalization failure;
> > it just feels a bit weird.
> 
> Let's leave it. It's safe now, and there's always risk new code could
> screw something up, no matter which way we go now, so let's pick the
> simpler way.

OK, I can't argue with that.

Cheers
---Dave
