From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 6/7] arm64: Do not apply vector harderning for hyp entries
 from EL2
Date: Thu, 8 Nov 2018 12:31:34 +0000
Message-ID: <3da632e3-d6e2-7595-2c39-587b81852e89@arm.com>
References: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
 <1537970184-44348-7-git-send-email-julien.thierry@arm.com>
 <20181107215926.GH12248@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28EE14A330
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 07:31:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2tFixLHiHDVp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 07:31:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB9E4A30F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 07:31:38 -0500 (EST)
In-Reply-To: <20181107215926.GH12248@brain-police>
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
To: Will Deacon <will.deacon@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 07/11/18 21:59, Will Deacon wrote:
> On Wed, Sep 26, 2018 at 02:56:23PM +0100, Julien Thierry wrote:
>> When an EL2 entry of __kvm_hyp_vector is taken, it means an entry from a
>> lower EL was previously taken to exit the guest. Taking that lower EL entry
>> already applied vector hardening if needed, so there is no need to do it
>> again.
>>
>> Only apply vector hardening for exception coming from lower EL.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>   arch/arm64/kvm/hyp/hyp-entry.S | 17 ++++++++++++++---
>>   1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>> index 24b4fba..da31386 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -257,7 +257,15 @@ ENTRY(__kvm_hyp_vector)
>>   ENDPROC(__kvm_hyp_vector)
>>
>>   #ifdef CONFIG_KVM_INDIRECT_VECTORS
>> -.macro hyp_ventry
>> +.macro hyp_el2_ventry
>> +	.align 7
>> +1:	b	__kvm_hyp_vector + (1b - 0b)
>> +	.rept 31
>> +	nop
>> +	.endr
>> +.endm
>> +
>> +.macro hyp_el1_ventry
>>   	.align 7
>>   1:	.rept 27
>>   	nop
>> @@ -290,8 +298,11 @@ alternative_cb_end
> 
> I think it would be cleaner to take the EL as a macro parameter, but again,
> I defer to Marc and Christoffer.

I'd argue they don't have much in common here. Unless I put the branch 
for the el2 ventry after 27 nops like for the el1, we wouldn't gain much 
from putting the two in the same macro IMO.

I'll see what Marc and Christoffer think about it.

Thanks,

-- 
Julien Thierry
