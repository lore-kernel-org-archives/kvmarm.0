From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 00/26] KVM/arm64: Randomise EL2 mappings (variant 3a
 mitigation)
Date: Fri, 16 Mar 2018 18:05:59 +0000
Message-ID: <a91ea637-1d20-2d9a-7da9-16fd695497a6@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180316174644.klbpmuhyod5qea3r@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B2D401AB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 13:58:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDAdFaP3D4Ns for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Mar 2018 13:58:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98FD04029E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Mar 2018 13:58:24 -0400 (EDT)
In-Reply-To: <20180316174644.klbpmuhyod5qea3r@armageddon.cambridge.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/03/18 17:46, Catalin Marinas wrote:
> On Wed, Mar 14, 2018 at 04:50:23PM +0000, Marc Zyngier wrote:
>> Whilst KVM benefits from the kernel randomisation via KASLR, there is
>> no additional randomisation when the kernel is running at EL1, as we
>> directly use a fixed offset from the linear mapping. This is not
>> necessarily a problem, but we could do a bit better by independently
>> randomizing the HYP placement.
> 
> For the rest of the patches in this series:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks for that.

> Some points for a future series:
> 
> - in bpi.S, drop the __smccc_workaround_1_hvc_start/end as HVC PSCI
>   conduit for hyp doesn't make much sense (could pass NULL instead to
>   __install_bp_hardening_cb())
> 
> - maybe move bpi.S under arch/arm64/kvm/ if it doesn't cause other
>   dependency issues in cpu_errata.c

Sure. I'll have a look at a bit of a post-paranoia cleanup next week.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
