Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477C92568
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 14:52:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADC3223A;
	Thu, 27 Oct 2022 07:52:38 -0700 (PDT)
Received: from [10.1.31.29] (e122027.cambridge.arm.com [10.1.31.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 433313F7B4;
	Thu, 27 Oct 2022 07:52:30 -0700 (PDT)
Message-ID: <73681d8e-95ab-aa1b-ddd3-5ada79321901@arm.com>
Date: Thu, 27 Oct 2022 15:52:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled
 systems.
To: Ryan Roberts <ryan.roberts@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu
References: <20221027120945.29679-1-ryan.roberts@arm.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20221027120945.29679-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Message-ID: <20221027145228.dEgAbK3KVICfj29V2swO_OxwZ8BymqvnhGY5Ua0pOdU@z>

On 27/10/2022 13:09, Ryan Roberts wrote:
> enter_exception64() performs an MTE check, which involves dereferencing
> vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
> a kern va pointer.
> 
> Fix this by first converting kvm to a hyp va pointer. If the system does
> not support MTE, the dereference is avoided in the first place.
> 
> Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

It's worth pointing out this only affects non-VHE mode, which is unusual
on hardware which supports MTE (and therefore VHE). But, of course,
about to get more usual with pKVM.

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/kvm/hyp/exception.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index b7557b25ed56..791d3de76771 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -13,6 +13,7 @@
>  #include <hyp/adjust_pc.h>
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
> 
>  #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
>  #error Hypervisor code only!
> @@ -115,7 +116,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
> 
> -	if (kvm_has_mte(vcpu->kvm))
> +	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
>  		new |= PSR_TCO_BIT;
> 
>  	new |= (old & PSR_DIT_BIT);
> --
> 2.17.1
> 

