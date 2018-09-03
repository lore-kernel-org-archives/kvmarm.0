From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v4 06/20] arm64: Add a helper for PARange to physical
 shift conversion
Date: Mon, 3 Sep 2018 11:06:44 +0100
Message-ID: <30b9aa82-7600-8094-dca3-44a5e79caf5a@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
 <1531905547-25478-7-git-send-email-suzuki.poulose@arm.com>
 <20180830094227.GB4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C174A1FF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 06:06:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C4bmMz9uCKlF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 06:06:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E8B14A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 06:06:49 -0400 (EDT)
In-Reply-To: <20180830094227.GB4029@e113682-lin.lund.arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/18 10:42, Christoffer Dall wrote:
> On Wed, Jul 18, 2018 at 10:18:49AM +0100, Suzuki K Poulose wrote:
>> On arm64, ID_AA64MMFR0_EL1.PARange encodes the maximum Physical
>> Address range supported by the CPU. Add a helper to decode this
>> to actual physical shift. If we hit an unallocated value, return
>> the maximum range supported by the kernel.
>> This will be used by KVM to set the VTCR_EL2.T0SZ, as it
>> is about to move its place. Having this helper keeps the code
>> movement cleaner.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since V2:
>>   - Split the patch
>>   - Limit the physical shift only for values unrecognized.
>> ---
>>   arch/arm64/include/asm/cpufeature.h | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 1717ba1..855cf0e 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -530,6 +530,19 @@ void arm64_set_ssbd_mitigation(bool state);
>>   static inline void arm64_set_ssbd_mitigation(bool state) {}
>>   #endif
>>   
>> +static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
>> +{
>> +	switch (parange) {
>> +	case 0: return 32;
>> +	case 1: return 36;
>> +	case 2: return 40;
>> +	case 3: return 42;
>> +	case 4: return 44;
>> +	case 5: return 48;
>> +	case 6: return 52;
>> +	default: return CONFIG_ARM64_PA_BITS;
> 
> I don't understand this case?  Shouldn't this include at least a WARN()
> ?

If a new value gets assigned in the future, an older kernel might not
be aware of it. As per the Arm ARM ID feature value rules, we are
guaranteed that the next higher value must indicate higher value.
So, WARN() may not be the right choice. Hence, we restrict it to
the value supported by the kernel.

Suzuki
