From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 00/13] arm64/KVM: RAS & IESB for firmware first support
Date: Tue, 16 Jan 2018 17:36:44 +0000
Message-ID: <20180116173644.njykhr3jck46gofm@armageddon.cambridge.arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04E1349E0C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 12:31:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8uePXdl6qKD9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 12:31:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A9F49DDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 12:31:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 15, 2018 at 07:38:53PM +0000, James Morse wrote:
> Dongjiu Geng (1):
>   KVM: arm64: Emulate RAS error registers and set HCR_EL2's TERR & TEA
> 
> James Morse (11):
>   arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early
>   arm64: sysreg: Move to use definitions for all the SCTLR bits
>   arm64: kernel: Survive corrected RAS errors notified by SError
>   arm64: Unconditionally enable IESB on exception entry/return for
>     firmware-first
>   arm64: kernel: Prepare for a DISR user
>   KVM: arm/arm64: mask/unmask daif around VHE guests
>   KVM: arm64: Set an impdef ESR for Virtual-SError using VSESR_EL2.
>   KVM: arm64: Save/Restore guest DISR_EL1
>   KVM: arm64: Save ESR_EL2 on guest SError
>   KVM: arm64: Handle RAS SErrors from EL1 on guest exit
>   KVM: arm64: Handle RAS SErrors from EL2 on guest exit
> 
> Xie XiuQi (1):
>   arm64: cpufeature: Detect CPU RAS Extentions

Queued for 4.16. Thanks.

-- 
Catalin
