From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 13/13] KVM: arm64: Emulate RAS error registers and
 set HCR_EL2's TERR & TEA
Date: Mon, 08 Jan 2018 16:27:13 +0000
Message-ID: <5A539BE1.20003@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-14-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E44C349DE6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 11:24:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6JuLiqwepWDD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 11:24:49 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C427A49D27
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 11:24:49 -0500 (EST)
In-Reply-To: <20171215155101.23505-14-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 15/12/17 15:51, James Morse wrote:
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

v4 of this patch had a Reviewed-by Marc and Christoffer, which I didn't pick up
because I'm an idiot:

https://patchwork.kernel.org/patch/10017537/


Thanks,

James
