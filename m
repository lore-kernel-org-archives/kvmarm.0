Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E26A2D8DC2
	for <kvmarm@lists.linux.dev>; Fri,  2 Jan 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354504; cv=none; b=cV7psNhGsM1NRiaXN1/dqIoJ+JItuSP+o3SZj6e6Tj1Pls0XYvM9PirWFcswJI7S865EHWhXf5awHeqbumkXFRqZ967nbD392F4vhvAbeAUcEr626xmazN6rV4PVnKo1M30X+9ZfNQmGSqinHGszclSiAhGfW0rjiy2ViuC0PXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354504; c=relaxed/simple;
	bh=sSv6RO3o3rC6Da1Oa5tAQIbjpXTvj+64ziLV8K8Dx8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0oCIwkuveSSWCrWQ0W60j7JPRZv8xRhCGA+57L43x4tr8LRRk80JEKugd4bgVY3rjU7QtBNasJEGOeXWIGJudWUsF//+AMYmhftBNi/6zONhOf2BKojqeZJ7Dboj61owf/QCpik0tmFgAdiAcvUpqCT8IOd+T21b2ZPaRRAd9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3FAF497;
	Fri,  2 Jan 2026 03:48:14 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A2C63F63F;
	Fri,  2 Jan 2026 03:48:16 -0800 (PST)
Message-ID: <c3132e11-a4e5-4a74-96b5-4a253ff9e3e3@arm.com>
Date: Fri, 2 Jan 2026 11:48:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/45] KVM: arm64: Force guest EL1 to use user-space's
 partid configuration
To: Oliver Upton <oupton@kernel.org>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-14-ben.horgan@arm.com> <aUWxLp2GUk2_p58e@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aUWxLp2GUk2_p58e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 12/19/25 20:10, Oliver Upton wrote:
> On Fri, Dec 19, 2025 at 06:11:15PM +0000, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> While we trap the guest's attempts to read/write the MPAM control
>> registers, the hardware continues to use them. Guest-EL0 uses KVM's
>> user-space's configuration, as the value is left in the register, and
>> guest-EL1 uses either the host kernel's configuration, or in the case of
>> VHE, the UNKNOWN reset value of MPAM1_EL1.
>>
>> We want to force the guest-EL1 to use KVM's user-space's MPAM
>> configuration. On nVHE rely on MPAM0_EL1 and MPAM1_EL1 always being
>> programmed the same and on VHE copy MPAM0_EL1 into the guest's
>> MPAM1_EL1. There is no need to restore as this is out of context once TGE
>> is set.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Drop the unneeded __mpam_guest_load() in nvhre and the MPAM1_EL1 save restore
>> Defer EL2 handling until next patch
>> ---
>>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> index f28c6cf4fe1b..a2e8f6187675 100644
>> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> @@ -183,6 +183,16 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>>  }
>>  NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
>>  
>> +/*
>> + * The _EL0 value was written by the host's context switch and belongs to the
>> + * VMM. Copy this into the guest's _EL1 register.
>> + */
>> +static inline void __mpam_guest_load(void)
>> +{
>> +	if (system_supports_mpam())
>> +		write_sysreg_el1(read_sysreg_s(SYS_MPAM0_EL1), SYS_MPAM1);
> 
> nit: I'd prefer using a mask to extract the fields of interest, guarding
> against future architecture doing something silly with the RES0 fields
> of these registers.

Sure, I'll make this change.

> 
> Thanks,
> Oliver

Thanks,

Ben

