Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFEA61F191
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEC32C15;
	Wed, 11 Oct 2023 05:33:59 -0700 (PDT)
Received: from [10.57.3.164] (unknown [10.57.3.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE5E53F5A1;
	Wed, 11 Oct 2023 05:33:17 -0700 (PDT)
Message-ID: <24d7dda6-888c-141e-3aa0-9319987360d7@arm.com>
Date: Wed, 11 Oct 2023 13:33:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 James Clark <james.clark@arm.com>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231011081649.3226792-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/2023 09:16, Oliver Upton wrote:
> Prevent the guest from setting the NSH bit, which enables event counting
> while the PE is in EL2. kvm_pmu_create_perf_event() never wired up the
> bit, nor does it make any sense in the context of a guest without NV.
> 
> While at it, build the event type mask using explicit field definitions
> instead of relying on ARMV8_PMU_EVTYPE_MASK. KVM probably should've been
> doing this in the first place, as it avoids changes to the
> aforementioned mask affecting sysreg emulation.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/pmu-emul.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0666212c0c15..087764435390 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -663,8 +663,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>   	if (!kvm_vcpu_has_pmu(vcpu))
>   		return;
>   
> -	mask  =  ARMV8_PMU_EVTYPE_MASK;
> -	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
> +	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
>   	mask |= kvm_pmu_event_mask(vcpu->kvm);
>   

The change looks good to me and complies with what we do.

However, I think we are missing the support for a guest using the
combination of PMEVTYPER.NS{K/U} instead of the PMEVTYPER.{P/U} for
filtering the events. As per Arm ARM, it is permitted to use the
PMEVTYPER.NSK/U (leaving PMEVTYPER.{P,U} == 0) for filtering in 
Non-Secure EL1.

It is true that, Linux guests uses P/U, but another OS/entity could
use NSK/NSU.

Anyways, for this patch:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com?

Suzuki



>   	reg = counter_index_to_evtreg(pmc->idx);

