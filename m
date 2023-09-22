Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83422943C
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 17:20:47 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3688DA7;
	Fri, 22 Sep 2023 10:21:23 -0700 (PDT)
Received: from [10.57.65.61] (unknown [10.57.65.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ED1C3F5A1;
	Fri, 22 Sep 2023 10:20:44 -0700 (PDT)
Message-ID: <07bd3b4e-05d8-79e0-94cc-e55d224a17be@arm.com>
Date: Fri, 22 Sep 2023 18:20:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 06/12] KVM: arm64: Allow userspace to change
 ID_AA64ISAR{0-2}_EL1
Content-Language: en-US
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Cornelia Huck <cohuck@redhat.com>,
 Jing Zhang <jingzhangos@google.com>, kvmarm@lists.linux.dev
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-7-oliver.upton@linux.dev>
 <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
In-Reply-To: <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/09/2023 18:18, Kristina Martsenko wrote:
> On 20/09/2023 19:33, Oliver Upton wrote:
>> Almost all of the features described by the ISA registers have no KVM
>> involvement. Allow userspace to change the value of these registers with
>> a couple exceptions:
>>
>>  - MOPS is not writable as KVM does not currently virtualize FEAT_MOPS.
>>
>>  - The PAuth fields are not writable as KVM requires both address and
>>    generic authentication be enabled.
>>
>>  - Override the kernel's handling of BC to LOWER_SAFE.
>>
>> Co-developed-by: Jing Zhang <jingzhangos@google.com>
>> Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++-----------
>>  1 file changed, 30 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 10e3e6a736dc..71664bec2808 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1225,6 +1225,10 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
>>                       break;
>>               }
>>               break;
>> +     case SYS_ID_AA64ISAR2_EL1:
>> +             if (kvm_ftr.shift == ID_AA64ISAR2_EL1_BC_SHIFT)
>> +                     kvm_ftr.type = FTR_LOWER_SAFE;
>> +             break;
>>       case SYS_ID_DFR0_EL1:
>>               if (kvm_ftr.shift == ID_DFR0_EL1_PerfMon_SHIFT)
>>                       kvm_ftr.type = FTR_LOWER_SAFE;
> 
> Nit: it shouldn't be necessary to override BC anymore, as it was recently fixed
> in the arm64 code:
>   https://lore.kernel.org/linux-arm-kernel/20230912133429.2606875-1-kristina.martsenko@arm.com/
> 
> Kristina
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 

Sorry, please ignore this disclaimer, I messed up my mail setup.

Kristina

