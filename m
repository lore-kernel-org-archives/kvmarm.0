From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 21/21] KVM: arm64: Trap RAS error registers and set
 HCR_EL2's TERR & TEA
Date: Tue, 31 Oct 2017 06:32:53 +0000
Message-ID: <86y3nr3jze.fsf@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-22-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9FE849D4F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 02:31:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xjWmLCYHWkUh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 02:31:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4C249D24
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 02:31:23 -0400 (EDT)
In-Reply-To: <20171019145807.23251-22-james.morse@arm.com> (James Morse's
 message of "Thu, 19 Oct 2017 15:58:07 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 19 2017 at  4:58:07 pm BST, James Morse <james.morse@arm.com> wrote:
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> ARMv8.2 adds a new bit HCR_EL2.TEA which routes synchronous external
> aborts to EL2, and adds a trap control bit HCR_EL2.TERR which traps
> all Non-secure EL1&0 error record accesses to EL2.
>
> This patch enables the two bits for the guest OS, guaranteeing that
> KVM takes external aborts and traps attempts to access the physical
> error registers.
>
> ERRIDR_EL1 advertises the number of error records, we return
> zero meaning we can treat all the other registers as RAZ/WI too.
>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> [removed specific emulation, use trap_raz_wi() directly for everything,
>  rephrased parts of the commit message]
> Signed-off-by: James Morse <james.morse@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
