Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1ACD2D0636
	for <kvmarm@lists.linux.dev>; Fri,  2 Jan 2026 11:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354231; cv=none; b=iix3NxvP+LuwX2TislSRGn8VMXQAjmdOaP+OH+jf4mt4FlegTWpM4WVewv5aLTYk7Xsx3t62HQX3hmfIJVXGhbm6Rb7+HuzIsHt4nMfRlfIlmbV7N+QKIqqez75zV9AfPoojxKa34PfgDsmqQucieAfgD6TDwzp5SYn0mNc4Km0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354231; c=relaxed/simple;
	bh=xJwGmhXkOkhk4HhlGaMLySyIX4vb2ceapOSwG9YqAIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mEdMm6NWIvVssRpByZi4/uLpWd1FDVb7jbmhVMW3smDN4VcItFN6WACV1iXjXgMHg5f25l2h3/ZHCg7xB1cR74DcRS9TFdh86QYcepyEn89cFJqR+tW2ZHZQj2i8qtKkRzqS7xEZW459i9oHZVa6m4dCS2O3co7CBMQMu3cOJAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06138497;
	Fri,  2 Jan 2026 03:43:42 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B0813F63F;
	Fri,  2 Jan 2026 03:43:43 -0800 (PST)
Message-ID: <187ac0bf-cd7e-4fed-8236-9097c938ab8c@arm.com>
Date: Fri, 2 Jan 2026 11:43:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/45] KVM: arm64: Preserve host MPAM configuration
 when changing traps
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
 <20251219181147.3404071-6-ben.horgan@arm.com> <aUWvGjGyU7DUW8MI@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aUWvGjGyU7DUW8MI@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 12/19/25 20:01, Oliver Upton wrote:
> Hi Ben,
> 
> On Fri, Dec 19, 2025 at 06:11:07PM +0000, Ben Horgan wrote:
>> When kvm enables or disables MPAM traps to EL2 it clears all other bits in
>> MPAM2_EL2.  Notably, it clears the partition ids (PARTIDs) and performance
>> monitoring groups (PMGs). Avoid changing these bits in anticipation of
>> adding support for MPAM in the kernel. Otherwise, on a VHE system with the
>> host running at EL2 where MPAM2_EL2 and MPAM1_EL1 access the same register,
>> any attempt to use MPAM to monitor or partition resources for kernel space
>> would be foiled by running a KVM guest. Additionally, MPAM2_EL2.EnMPAMSM is
>> always set to 0 which causes MPAMSM_EL1 to always trap. Keep EnMPAMSM set
>> to 1 when not in a guest so that the kernel can use MPAMSM_EL1.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index c5d5e5b86eaf..63195275a8b8 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -269,7 +269,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>>  
>>  static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>>  {
>> -	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>> +	u64 clr = MPAM2_EL2_EnMPAMSM;
>> +	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>>  
>>  	if (!system_supports_mpam())
>>  		return;
>> @@ -279,18 +280,21 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
>>  	} else {
>>  		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
>> -		r |= MPAM2_EL2_TIDR;
>> +		set |= MPAM2_EL2_TIDR;
>>  	}
>>  
>> -	write_sysreg_s(r, SYS_MPAM2_EL2);
>> +	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
> 
> I'd recommend documenting that writes to MPAM1_EL1 are followed by an
> ISB. Otherwise it isn't obvious here where context synchronization is
> happening (if at all).

Ok, but why are you mentioning it here?

This is just updating the traps while ensuring the partid/pmg are
unchanged. The traps are only relevant once we change exception level
and for activation they are synchronized in __guest_enter() and the eret
when returning to userspace.

> 
> Thanks,
> Oliver

Thanks,

Ben

