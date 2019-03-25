From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Mon, 25 Mar 2019 17:32:49 +0100
Message-ID: <20190325163249.rkk6vvnzex5d4z7k@kamzik.brq.redhat.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A1E24A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 12:33:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id weHxbgHcJSG2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Mar 2019 12:33:07 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40AE74A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Mar 2019 12:33:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, peter.maydell@linaro.org
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 19, 2019 at 05:51:51PM +0000, Dave Martin wrote:
> This series implements support for allowing KVM guests to use the Arm
> Scalable Vector Extension (SVE), superseding the previous v5 series [1].
> 
> The patches are also available on a branch for reviewer convenience. [2]
> 
> The patches are based on v5.1-rc1.
> 
> The series has been reworked to remove the dependency on [3],
> eliminating the ABI "fixes" but keeping the relevant cleanup/
> refactoring.  (See patch 16.)
> 
> This series addresses review comments received on v5, and contains one
> significant change:
> 
>  * A new ioctl KVM_ARM_VCPU_FINALIZE is added to replace the implicit
>    finalization behaviour in v5.  If userspace enables SVE, it must now
>    use this ioctl to finalize the vcpu configuration before KVM_RUN
>    etc. or SVE register access are permitted.
> 
> For a description of minor updates, see the individual patches.
> 
> 
> Known issues:
> 
>  * This update requires modifications to kvmtool that are not published
>    yet.  I will reply to this cover letter with a link when those are
>    available (hopefully within 24 hours of this posting).
>

Hi Dave and Peter,

Do either of you know if anyone has picked up the QEMU side of this?
If not, then I'll take it.

Thanks,
drew
