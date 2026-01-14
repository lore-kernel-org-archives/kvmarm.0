Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9323064AA
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768402232; cv=none; b=KwcFmwyuCfU7veYdQ37RGO7le5soszb40G0OEc7tknXWSUrliTFSooTwoYUT0NkIQtMSUxg/fJ3HvyqWd8L1NCeNlFbZiKD1MY4brn3fWGS8bwCO6VmPiCBwKJC5of2k+6FP5YVKZ6KTf6LHXt2jARZ1nLFr+GEf/h+2/7VxxkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768402232; c=relaxed/simple;
	bh=6PDjBOLXWmP0CIkBSdwEQyKrZNHMaUvn87PxDab6h5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OhXEtpMsaUUQiOuvb6PiCNOAsBzshNgOGHUr4547Wel7gIYIQxU3Yt38+I1dWtt4rKgDizzCKFTx+zxRs3a29X80PPF9bOcIsBHHZy2YpPpAy2aW7qDpsEbGUYWOamFBMLdzoUM8aRaCcAYWtmtCMrqgUV3wQvvJ0LWjYyg4mKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC3FD1515;
	Wed, 14 Jan 2026 06:50:21 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA94E3F632;
	Wed, 14 Jan 2026 06:50:23 -0800 (PST)
Message-ID: <92041294-b332-4b8b-aeed-d8bbad1a7289@arm.com>
Date: Wed, 14 Jan 2026 14:50:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/47] KVM: arm64: Force guest EL1 to use user-space's
 partid configuration
To: Marc Zyngier <maz@kernel.org>
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
 will@kernel.org, corbet@lwn.net, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-13-ben.horgan@arm.com> <86pl7cl7p7.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <86pl7cl7p7.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 1/14/26 12:06, Marc Zyngier wrote:
> On Mon, 12 Jan 2026 16:58:39 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
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
>>
>> Changes since v2:
>> Use mask (Oliver)
>> ---
>>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> index f28c6cf4fe1b..9fb8e6628611 100644
>> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>> @@ -183,6 +183,18 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>>  }
>>  NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
>>  
>> +/*
>> + * The _EL0 value was written by the host's context switch and belongs to the
>> + * VMM. Copy this into the guest's _EL1 register.
>> + */
>> +static inline void __mpam_guest_load(void)
>> +{
>> +	u64 mask = MPAM0_EL1_PARTID_D | MPAM0_EL1_PARTID_I | MPAM0_EL1_PMG_D | MPAM0_EL1_PMG_I;
>> +
>> +	if (system_supports_mpam())
>> +		write_sysreg_el1(read_sysreg_s(SYS_MPAM0_EL1) & mask, SYS_MPAM1);
>> +}
>> +
>>  /**
>>   * __vcpu_load_switch_sysregs - Load guest system registers to the physical CPU
>>   *
>> @@ -222,6 +234,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
>>  	 */
>>  	__sysreg32_restore_state(vcpu);
>>  	__sysreg_restore_user_state(guest_ctxt);
>> +	__mpam_guest_load();
> 
> What's the rationale for doing this independently of rest of the MPAM
> stuff in __activate_traps_mpam()?

The __activate_traps_mpam() is relevant even for nvhe but
__mpam_guest_load() is only need in vhe as otherwise we can rely on
MPAM1_EL1 and MPAM0_EL0 having the same partid/pmg configuration
(although this MPAM policy will likely become configurable sometime down
the line). Besides that it just makes the naming less exact.

> 
> 	M.
> 

Thanks,

Ben

