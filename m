From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 12/26] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Tue, 26 Feb 2019 12:07:52 +0000
Message-ID: <20190226120752.GN3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
 <2819c91f-3a28-b878-0ea1-d20afcf05895@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0FA4A3BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9MzV2lctl-YR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:07:57 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A6F4A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:07:57 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <2819c91f-3a28-b878-0ea1-d20afcf05895@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 20, 2019 at 02:33:44PM +0000, Julien Thierry wrote:
> 
> 
> On 18/02/2019 19:52, Dave Martin wrote:
> > Some optional features of the Arm architecture add new system
> > registers that are not present in the base architecture.
> > 
> > Where these features are optional for the guest, the visibility of
> > these registers may need to depend on some runtime configuration,
> > such as a flag passed to KVM_ARM_VCPU_INIT.
> > 
> > For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
> > is not enabled for the guest, even though these registers may be
> > present in the hardware and visible to the host at EL2.
> > 
> > Adding special-case checks all over the place for individual
> > registers is going to get messy as the number of conditionally-
> > visible registers grows.
> > 
> > In order to help solve this problem, this patch adds a new sysreg
> > method restrictions() that can be used to hook in any needed
> > runtime visibility checks.  This method can currently return
> > REG_NO_USER to inhibit enumeration and ioctl access to the register
> > for userspace, and REG_NO_GUEST to inhibit runtime access by the
> > guest using MSR/MRS.
> > 
> > This allows a conditionally modified view of individual system
> > registers such as the CPU ID registers, in addition to completely
> > hiding register where appropriate.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks
---Dave
