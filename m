From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 00/20] SError rework + RAS&IESB for firmware first
 support
Date: Wed, 18 Oct 2017 17:55:12 +0100
Message-ID: <20171018165511.d7a42nakchowbo6k@armageddon.cambridge.arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7CDD40795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 12:54:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0ut2WdKi9eK1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 12:54:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F15406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 12:54:15 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 05, 2017 at 08:17:52PM +0100, James Morse wrote:
> James Morse (18):
>   arm64: explicitly mask all exceptions
>   arm64: introduce an order for exceptions
>   arm64: Move the async/fiq helpers to explicitly set process context
>     flags
>   arm64: Mask all exceptions during kernel_exit
>   arm64: entry.S: Remove disable_dbg
>   arm64: entry.S: convert el1_sync
>   arm64: entry.S convert el0_sync
>   arm64: entry.S: convert elX_irq
>   KVM: arm/arm64: mask/unmask daif around VHE guests
>   arm64: kernel: Survive corrected RAS errors notified by SError
>   arm64: cpufeature: Enable IESB on exception entry/return for
>     firmware-first
>   arm64: kernel: Prepare for a DISR user
>   KVM: arm64: Set an impdef ESR for Virtual-SError using VSESR_EL2.
>   KVM: arm64: Save/Restore guest DISR_EL1
>   KVM: arm64: Save ESR_EL2 on guest SError
>   KVM: arm64: Handle RAS SErrors from EL1 on guest exit
>   KVM: arm64: Handle RAS SErrors from EL2 on guest exit
>   KVM: arm64: Take any host SError before entering the guest
> 
> Xie XiuQi (2):
>   arm64: entry.S: move SError handling into a C function for future
>     expansion
>   arm64: cpufeature: Detect CPU RAS Extentions

For patches 1-14 (not the KVM ones):

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

I'm also in favour of renaming the macros to local_daif_save etc. as per
Julien's suggestion.

-- 
Catalin
