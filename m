From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v9 2/5] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Mon, 14 Jan 2019 12:07:55 +0000
Message-ID: <ff3cc5d4-061a-cabc-3c40-6f41fceb5ac2@arm.com>
References: <1546872089-56278-1-git-send-email-andrew.murray@arm.com>
 <1546872089-56278-3-git-send-email-andrew.murray@arm.com>
 <a5ff581b-5cfb-fea2-74b8-aa4dc3403518@arm.com>
 <20190110151605.GJ56789@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378C24A3F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 07:08:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DU446z36RZv0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jan 2019 07:07:58 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64824A3B1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 07:07:58 -0500 (EST)
In-Reply-To: <20190110151605.GJ56789@e119886-lin.cambridge.arm.com>
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
To: andrew.murray@arm.com
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/01/2019 15:16, Andrew Murray wrote:
> On Thu, Jan 10, 2019 at 11:36:01AM +0000, Suzuki K Poulose wrote:
>> Hi Andrew,
>>
>> On 07/01/2019 14:41, Andrew Murray wrote:
>>> The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
>>> a typedef to kvm_cpu_context and is used to store host cpu context. The
>>> kvm_cpu_context structure is also used elsewhere to hold vcpu context.
>>> In order to use the percpu to hold additional future host information we
>>> encapsulate kvm_cpu_context in a new structure and rename the typedef and
>>> percpu to match.
>>>
>>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>>> ---
>>>    arch/arm/include/asm/kvm_host.h   |  8 ++++++--
>>>    arch/arm64/include/asm/kvm_asm.h  |  4 ++--
>>>    arch/arm64/include/asm/kvm_host.h | 14 +++++++++-----
>>>    arch/arm64/kernel/asm-offsets.c   |  2 +-
>>>    virt/kvm/arm/arm.c                | 12 +++++++-----
>>>    5 files changed, 25 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index 79906ce..71645ba 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -145,7 +145,11 @@ struct kvm_cpu_context {
>>>    	u32 cp15[NR_CP15_REGS];
>>>    };
>>> -typedef struct kvm_cpu_context kvm_cpu_context_t;
>>> +struct kvm_host_data {
>>> +	struct kvm_cpu_context host_ctxt;
>>> +};
>>> +
>>> +typedef struct kvm_host_data kvm_host_data_t;
>>>    struct kvm_vcpu_arch {
>>>    	struct kvm_cpu_context ctxt;
>>> @@ -163,7 +167,7 @@ struct kvm_vcpu_arch {
>>>    	struct kvm_vcpu_fault_info fault;
>>>    	/* Host FP context */
>>> -	kvm_cpu_context_t *host_cpu_context;
>>> +	struct kvm_cpu_context *host_cpu_context;
>>>    	/* VGIC state */
>>>    	struct vgic_cpu vgic_cpu;
>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>> index 102b5a5..6a9bfd4 100644
>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>> @@ -102,12 +102,12 @@ extern u32 __init_stage2_translation(void);
>>>    .endm
>>>    .macro get_host_ctxt reg, tmp
>>> -	hyp_adr_this_cpu \reg, kvm_host_cpu_state, \tmp
>>> +	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
>>>    .endm
>>
>> minor nit: We now load "kvm_host_data" instead of the host_ctxt here,
>> even though they both are same. Do we need to make this explicitly load
>> the address of the host_ctxt member to make sure this doesn't break
>> with future changes to the structure ?
>> i.e,
>> 	add	\reg, \reg, #HOST_DATA_CONTEXT
>>
>> Otherwise,
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Thanks for spotting this.
> 
> Are you happy for me to add the Reviewed-by tag if I squash in the following?

Yes, that looks fine to me.

Cheers
Suzuki
