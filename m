From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 17/18] kvm: arm64: Limit the minimum number of page
 table levels
Date: Tue, 25 Sep 2018 11:25:35 +0100
Message-ID: <1486a576-dc71-9b88-688f-317fb662ff69@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-18-suzuki.poulose@arm.com>
 <59231541-311f-e04b-3e6b-e073a8392316@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59231541-311f-e04b-3e6b-e073a8392316@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/25/2018 11:00 AM, Auger Eric wrote:
> Hi Suzuki,
> 
> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>> Since we are about to remove the lower limit on the IPA size,
>> make sure that we do not go to 1 level page table (e.g, with
>> 32bit IPA on 64K host with concatenation) to avoid splitting
>> the host PMD huge pages at stage2.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/stage2_pgtable.h |  8 +++++++-
>>   arch/arm64/kvm/reset.c                  | 12 +++++++++++-
>>   2 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
>> index 352ec4158fdf..6a56fdff0823 100644
>> --- a/arch/arm64/include/asm/stage2_pgtable.h
>> +++ b/arch/arm64/include/asm/stage2_pgtable.h
>> @@ -72,8 +72,14 @@
>>   /*
>>    * The number of PTRS across all concatenated stage2 tables given by the
>>    * number of bits resolved at the initial level.
>> + * If we force more number of levels than necessary, we may have
> more levels?


>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 76972b19bdd7..0393bb974b23 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c

>> @@ -210,7 +219,8 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>>   	vtcr |= (kvm_get_vmid_bits() == 16) ?
>>   		VTCR_EL2_VS_16BIT :
>>   		VTCR_EL2_VS_8BIT;
>> -	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(KVM_PHYS_SHIFT));
>> +
> nit: new line not requested
> 

Fixed all the above

Suzuki
