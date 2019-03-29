From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 00/27] KVM: arm64: SVE guest support
Date: Fri, 29 Mar 2019 14:56:36 +0000
Message-ID: <bed45c04-9b67-9e30-d73e-adc07a902de1@arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C42B4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 10:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WtHDBYNm4sNs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 10:56:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7AFD4A2B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 10:56:43 -0400 (EDT)
In-Reply-To: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 29/03/2019 13:00, Dave Martin wrote:
> This series implements support for allowing KVM guests to use the Arm
> Scalable Vector Extension (SVE), superseding the previous v6 series [1].
> 
> The patches are also available on a branch for reviewer convenience. [2]
> 
> The patches are based on v5.1-rc2.
> 
> This series addresses a couple of minor review comments received on v6
> and otherwise applies reviewer tags only.  The code differences
> between v6 and this series consist of minor cosmetic fixups only.
> 
> Draft kvmtool patches were posted separately [3], [4].
> 
> For a description of minor updates, see the individual patches.
> 
> 
> Thanks go to Julien Thierry and Julian Grall for their review efforts,
> and to Zhang Lei for testing the series -- many thanks for their help
> in getting the series to this point!
> 
> 
> Reviewers' attention is drawn to the following patches, which have no
> Reviewed-by/Acked-by.  Please take a look if you have a moment.
> 
>  * Patch 11 (KVM: arm64: Support runtime sysreg visibility filtering)
> 
>    Previously Reviewed-by Julien Thierry, but this version of the
>    patch contains some minor rework suggested by Mark Rutland during
>    the v5 review [5].
> 
>  * Patch 15 (KVM: arm64: Add missing #include of <linux/string.h>
>    in guest.c)
> 
>    (Trivial patch.)
> 
>  * Patch 26: (KVM: Document errors for KVM_GET_ONE_REG and
>    KVM_SET_ONE_REG)
> 
>    (Documentation only.)
> 
>  * Patch 27: KVM: arm64/sve: Document KVM API extensions for SVE
> 
>    (Documentation only.)

In order to get people to test this a bit more, I've now pushed this
series into -next. I'm pretty confident that it won't break a thing, but
better safe than sorry. I also expect any fix to be pushed on top of
this series.

This doesn't mean that the review is over, quite the opposite. I intend
to go over it once more, and I'd like other people to do the same
(specially anyone looking at implementing the required support in QEMU).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
