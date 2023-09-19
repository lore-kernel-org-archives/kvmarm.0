Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 805723D82
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 11:26:18 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CECA51FB;
	Tue, 19 Sep 2023 04:26:54 -0700 (PDT)
Received: from [10.1.36.155] (e126864.cambridge.arm.com [10.1.36.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E62923F67D;
	Tue, 19 Sep 2023 04:26:14 -0700 (PDT)
Message-ID: <e892be93-6b5a-940c-c07f-7164646d5aca@arm.com>
Date: Tue, 19 Sep 2023 12:26:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/3] KVM: arm64: Configure HCRX_EL2 dynamically
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Vladimir Murzin <vladimir.murzin@arm.com>,
 Colton Lewis <coltonlewis@google.com>, linux-kernel@vger.kernel.org
References: <20230915124840.474888-1-kristina.martsenko@arm.com>
 <20230915124840.474888-2-kristina.martsenko@arm.com>
 <865y47enz2.wl-maz@kernel.org>
From: Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <865y47enz2.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/09/2023 12:10, Marc Zyngier wrote:
> Hi Kristina,

Hi Marc,

> On Fri, 15 Sep 2023 13:48:38 +0100,
> Kristina Martsenko <kristina.martsenko@arm.com> wrote:
>>
>> At the moment the HCRX_EL2 system register is always initialized to
>> HCRX_GUEST_FLAGS when running a guest. Instead, choose the configuration
>> at vcpu reset time and save it in the vcpu struct, similarly to how
>> HCR_EL2 is set up. This will be needed in a subsequent change to
>> configure the register based on CPU features detected at runtime.
>>
>> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h    | 5 +++++
>>  arch/arm64/include/asm/kvm_host.h       | 1 +
>>  arch/arm64/kvm/arm.c                    | 1 +
>>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 1 +
>>  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 1 +
>>  6 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 3d6725ff0bf6..64ea27e6deb1 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -134,6 +134,11 @@ static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
>>  }
>>  
>> +static inline void vcpu_reset_hcrx(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
>> +}
>> +
>>  static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
>>  {
>>  	return vcpu->arch.vsesr_el2;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index af06ccb7ee34..2764748756a7 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -487,6 +487,7 @@ struct kvm_vcpu_arch {
>>  
>>  	/* Values of trap registers for the guest. */
>>  	u64 hcr_el2;
>> +	u64 hcrx_el2;
> 
> Do we really need this extra field? Yes, this is only an extra 64bit,
> but they tend to accumulate...
> 
> Looking at patch #3, the change is related to this:
> 
>  	vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
> +
> +	if (cpus_have_final_cap(ARM64_HAS_MOPS)) {
> +		vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
> +		vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
> +	}
> 
> meaning that this is a constant value for a given boot of the host.
> 
> At this stage, I'd rather you define HCRX_GUEST_FLAGS as:
> 
> #define HCRX_GUEST_FLAGS \
> 	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
> 	 cpus_have_final_cap(ARM64_HAS_MOPS) ? \
> 	 (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0)
> 
> and drop the new field altogether, until we have something that
> requires dynamic flipping of an HCRX_EL2 field.

Makes sense, the field isn't strictly required yet, I'll drop it in v2.

Thanks,
Kristina

