Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B408A376BCB
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 11:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768475687; cv=none; b=MmaNg72QO5UP/ALYwyQKMq5VwLcIkx8SLTqBU0h7newqPwvWc1cYCpQOc7o6zSehz6PwRtAhE/UxCZZva21qTyEs8a+v3mLtM/XRxQv7TCulBZGErLwpghZ3d6/Yim4DQEUiS6Rvn1CUjw693ZoCAhe8zM4LWjYTnxyiIAaUyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768475687; c=relaxed/simple;
	bh=w7/iqn+78jZRPgXEzgLSBfmcfgyDzGis0VukwpUAfbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqphrdLCqhopikAG9PajefQb4b1G8GkTAIiBI8KWz4JcIMP/aUmBuYS3BixHFLCylGm0+wz+G1uPGMOIOJ7OPr83MdNqYFh8seWW7fdPdRSa7AKtSS0+6T3c79zgkI0ulWB1ezIuSHPW68oLwhg4qjRoNGaWR4XO18jIoSYMrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45626FEC;
	Thu, 15 Jan 2026 03:14:36 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 217083F694;
	Thu, 15 Jan 2026 03:14:37 -0800 (PST)
Message-ID: <585ef596-47bf-462f-92da-4a322178115c@arm.com>
Date: Thu, 15 Jan 2026 11:14:36 +0000
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
 <92041294-b332-4b8b-aeed-d8bbad1a7289@arm.com> <86ldhzkzzb.wl-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <86ldhzkzzb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 1/15/26 09:05, Marc Zyngier wrote:
> On Wed, 14 Jan 2026 14:50:22 +0000,
> Ben Horgan <ben.horgan@arm.com> wrote:
>>
>> Hi Marc,
>>
>> On 1/14/26 12:06, Marc Zyngier wrote:
>>> On Mon, 12 Jan 2026 16:58:39 +0000,
>>> Ben Horgan <ben.horgan@arm.com> wrote:
>>>>
>>>> From: James Morse <james.morse@arm.com>
>>>>
>>>> While we trap the guest's attempts to read/write the MPAM control
>>>> registers, the hardware continues to use them. Guest-EL0 uses KVM's
>>>> user-space's configuration, as the value is left in the register, and
>>>> guest-EL1 uses either the host kernel's configuration, or in the case of
>>>> VHE, the UNKNOWN reset value of MPAM1_EL1.
>>>>
>>>> We want to force the guest-EL1 to use KVM's user-space's MPAM
>>>> configuration. On nVHE rely on MPAM0_EL1 and MPAM1_EL1 always being
>>>> programmed the same and on VHE copy MPAM0_EL1 into the guest's
>>>> MPAM1_EL1. There is no need to restore as this is out of context once TGE
>>>> is set.
>>>>
>>>> Signed-off-by: James Morse <james.morse@arm.com>
>>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>>> ---
>>>> Changes since rfc:
>>>> Drop the unneeded __mpam_guest_load() in nvhre and the MPAM1_EL1 save restore
>>>> Defer EL2 handling until next patch
>>>>
>>>> Changes since v2:
>>>> Use mask (Oliver)
>>>> ---
>>>>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>>>> index f28c6cf4fe1b..9fb8e6628611 100644
>>>> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>>>> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
>>>> @@ -183,6 +183,18 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
>>>>  }
>>>>  NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
>>>>  
>>>> +/*
>>>> + * The _EL0 value was written by the host's context switch and belongs to the
>>>> + * VMM. Copy this into the guest's _EL1 register.
>>>> + */
>>>> +static inline void __mpam_guest_load(void)
>>>> +{
>>>> +	u64 mask = MPAM0_EL1_PARTID_D | MPAM0_EL1_PARTID_I | MPAM0_EL1_PMG_D | MPAM0_EL1_PMG_I;
>>>> +
>>>> +	if (system_supports_mpam())
>>>> +		write_sysreg_el1(read_sysreg_s(SYS_MPAM0_EL1) & mask, SYS_MPAM1);
>>>> +}
>>>> +
>>>>  /**
>>>>   * __vcpu_load_switch_sysregs - Load guest system registers to the physical CPU
>>>>   *
>>>> @@ -222,6 +234,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
>>>>  	 */
>>>>  	__sysreg32_restore_state(vcpu);
>>>>  	__sysreg_restore_user_state(guest_ctxt);
>>>> +	__mpam_guest_load();
>>>
>>> What's the rationale for doing this independently of rest of the MPAM
>>> stuff in __activate_traps_mpam()?
>>
>> The __activate_traps_mpam() is relevant even for nvhe but
>> __mpam_guest_load() is only need in vhe as otherwise we can rely on
>> MPAM1_EL1 and MPAM0_EL0 having the same partid/pmg configuration
> 
> It is completely unclear to me what enforces this. Please point me to
> the code that does that.

The new MPAM arch code always configures kernel space MPAM configuration
in tandem, same value to MPAM0_EL1 and MPAM1_EL1 (will access MPAM2_EL2
in vhe).

For the cpu part see
PATCH v3 07 arm64: mpam: Re-initialise MPAM regs when CPU comes online
and for context switching part see
PATCH v3 06 arm64: mpam: Context switch the MPAM registers

> 
>> (although this MPAM policy will likely become configurable sometime down
>> the line).
> 
> Or not. the VM only exists as an extension of userspace, and I don't
> see on what grounds it should get its own MPAM configuration.

There are no plans to give the VM it's own MPAM configuration. The
intent of this patch is to give all the code running in the VM, whether
or not it is at EL0 or EL1, uses the MPAM partid/pmg configuration of
the userspace VMM that is running it. What I was alluding to here is
that if a future host MPAM policy allows the partid/pmg to differ for
the kernel and userspace then we won't be able rely on the EL1
configuration matching EL0 in the nvhe case and so would have to copy
the host EL0 configuration to EL1 (and add a restore).

> 
>> Besides that it just makes the naming less exact.
> 
> I don't care about the naming. I care about how the configuration flow
> is organised. And so far, this seems extremely messy.
> 
> Can you please document what gets configured when and in which mode?

The goal is that all times the VM runs with the same MPAM partid/pmg
configuration
as the userspace vmm running it.

In VHE:

Host kernel configuration is in MPAM2_EL2
Host userspace configuration is in MPAM0_EL1

Guest kernel configuration needs to be in MPAM1_EL1 and so we copy it
there from MPAM0_EL1 when
switching to the guest. On switching back to the host we can just leave
it there as the host doesn't use it.
Guest userspace configuration is in MPAM0_EL1, just keep that unchanged.

In nVHE:
Host kernel configuration is in MPAM1_EL1
Host userspace configuration is in MPAM0_EL1

Once again, guest userspace configuration is in MPAM0_EL1, just keep
that unchanged. As host policy ensures MPAM0_EL1 == MPAM1_EL1 for
pmg/partid we rely on this to skip changing MPAM1_EL1 on guest entry and
to skip the restore on guest exit.

I hope this makes the intent clearer.

Would you prefer to decouple the kvm handling of the MPAM configuration
from the host policy? If so, I expect the MPAM handling can be done
together in __activate_traps_mpam().

Thoughts?

Thanks,

Ben

