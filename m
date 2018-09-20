From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 07/18] kvm: arm64: Configure VTCR_EL2 per VM
Date: Thu, 20 Sep 2018 11:38:51 +0100
Message-ID: <b9d1aa2d-4c9d-5da4-d627-aad7a8e110ee@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-8-suzuki.poulose@arm.com>
 <3c4d3139-1b8b-12fd-bd41-10a21b86e7b5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BCE74A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 06:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yz5ErCfp3BuE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Sep 2018 06:38:58 -0400 (EDT)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on0066.outbound.protection.outlook.com [104.47.2.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED60C49F8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Sep 2018 06:38:57 -0400 (EDT)
In-Reply-To: <3c4d3139-1b8b-12fd-bd41-10a21b86e7b5@redhat.com>
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
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 20/09/18 11:21, Auger Eric wrote:
> Hi Suzuki,
>
> On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
>> Add support for setting the VTCR_EL2 per VM, rather than hard
>> coding a value at boot time per CPU. This would allow us to tune
>> the stage2 page table parameters per VM in the later changes.
>>
>> We compute the VTCR fields based on the system wide sanitised
>> feature registers, except for the hardware management of Access
>> Flags (VTCR_EL2.HA). It is fine to run a system with a mix of
>> CPUs that may or may not update the page table Access Flags.
>> Since the bit is RES0 on CPUs that don't support it, the bit
>> should be ignored on them.
>>
>> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
>> Acked-by: Christoffer Dall <cdall@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index b0c07dab5cb3..e0c49377b771 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -26,6 +26,7 @@
>>
>>   #include <kvm/arm_arch_timer.h>
>>
>> +#include <asm/cpufeature.h>
>>   #include <asm/cputype.h>
>>   #include <asm/ptrace.h>
>>   #include <asm/kvm_arm.h>
>> @@ -134,9 +135,38 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>      return kvm_timer_vcpu_reset(vcpu);
>>   }
>>
>> +/*
>> + * Configure the VTCR_EL2 for this VM. The VTCR value is common
>> + * across all the physical CPUs on the system. We use system wide
>> + * sanitised values to fill in different fields, except for Hardware
>> + * Management of Access Flags. HA Flag is set unconditionally on
>> + * all CPUs, as it is safe to run with or without the feature and
>> + * the bit is RES0 on CPUs that don't support it.
>> + */
>>   int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>>   {
>> +    u64 vtcr = VTCR_EL2_FLAGS;
> #define VTCR_EL2_FLAGS                        (VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
>
> in include/asm/kvm_arm.h
>
> I don't see T0SZ=24 encoded there and I don't see it set either in the
> code below? For bisection purpose.

You're right, I am missing it here. I have fixed this up for v6,
with the following hunk.


diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e0c49377b771..fa897eafc2c9 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -147,6 +147,7 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long
type)
  {
        u64 vtcr = VTCR_EL2_FLAGS;
        u64 parange;
+       u32 phys_shift;

        if (type)
                return -EINVAL;
@@ -156,6 +157,9 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long
type)
                parange = ID_AA64MMFR0_PARANGE_MAX;
        vtcr |= parange << VTCR_EL2_PS_SHIFT;

+       phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+       vtcr |= VTCR_EL2_T0SZ(phys_shift > 40 ? 40 : phys_shift);
        /*
         * Enable the Hardware Access Flag management, unconditionally
         * on all CPUs. The features is RES0 on CPUs without the support


Thanks
Suzuki
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
