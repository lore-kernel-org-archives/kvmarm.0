From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 01/13] arm64: cpufeature: __this_cpu_has_cap()
 shouldn't stop early
Date: Fri, 15 Dec 2017 16:24:13 +0000
Message-ID: <5bd2a296-d46b-5d84-191b-5dc2390f1eb9@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F7340D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 11:20:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jBKSp9b7n+E1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 11:20:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE4B40795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 11:20:40 -0500 (EST)
In-Reply-To: <20171215155101.23505-2-james.morse@arm.com>
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
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/17 15:50, James Morse wrote:
> this_cpu_has_cap() tests caps->desc not caps->matches, so it stops
> walking the list when it finds a 'silent' feature, instead of
> walking to the end of the list.
> 
> Prior to v4.6's 644c2ae198412 ("arm64: cpufeature: Test 'matches' pointer
> to find the end of the list") we always tested desc to find the end of
> a capability list. This was changed for dubious things like PAN_NOT_UAO.
> v4.7's e3661b128e53e ("arm64: Allow a capability to be checked on
> single CPU") added this_cpu_has_cap() using the old desc style test.
> 
> CC: Suzuki K Poulose <suzuki.poulose@arm.com>
> CC: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> So far only ARM64_HAS_SYSREG_GIC_CPUIF and errata use this_cpu_has_cap(),
> all the errata have descriptions, and the GIC_CPUIF feature is first in
> the list, so its not possible to hit this with mainline. I don't think
> this should go to stable - this is not intended as a fix.
> 
>   arch/arm64/kernel/cpufeature.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c5ba0097887f..68a49f7fb75c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1236,8 +1236,8 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
>   	if (WARN_ON(preemptible()))
>   		return false;
>   
> -	for (caps = cap_array; caps->desc; caps++)
> -		if (caps->capability == cap && caps->matches)
> +	for (caps = cap_array; caps->matches; caps++)
> +		if (caps->capability == cap)
>   			return caps->matches(caps, SCOPE_LOCAL_CPU);

Thanks for catching this !

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
