Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE9F349CEF;
	Wed, 22 Jul 2026 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727123; cv=none; b=F37ydgVgLJxVNlsCzxkDj6AnT2PhiB59bqJT0r+oriH0q55iGPA31yyE1PxzokgmsVMmeS6UGvaNbssmTZHM/RRvwT17/VKyjHbl5COTjUJ4PlgVZH/mI7t2r7mu0lUZgR6DI3ohAfdEhfDjJLPC0p/YAphndnquCPbzecrx0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727123; c=relaxed/simple;
	bh=6AxZbM3+o8fEzuQd3zgOIISjc+Vr+68x4REjcsi72PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MjYyiiG1tgFWVNa1FcWagm+B6Ara3wRUkrODM2byXhIo2BKvbhpvWyAsSD+oG3Ft90Z7Q+aTdjLX4QVNe5bSh3RMegE4jcbW5QtgbW2bskq1Wx4m+4LAJjRaswo2L6XrPl/3TH551z3uCuJ4xTJ++20eX36vhg2niMirK6NrYzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZVW6ftl+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZVW6ftl+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41F5B1595;
	Wed, 22 Jul 2026 06:31:56 -0700 (PDT)
Received: from [10.57.86.63] (unknown [10.57.86.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 040433F58B;
	Wed, 22 Jul 2026 06:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784727120; bh=6AxZbM3+o8fEzuQd3zgOIISjc+Vr+68x4REjcsi72PY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZVW6ftl+NWzDeteskCjMo4aVNi1XQiZaplBWqUD6PO1uqdcf2vJvElv7Fu9S9IFcp
	 LH7e1FbyjpMl6pVeztbeRHRFBFnMG4HoJcYxs/VL13MCByX5fjTlo9r2zB/re27opm
	 M9hCclLQ1h6SwXoQnRJogmfM/3Jz6rRB/cwX3GHY=
Message-ID: <b71e81ee-372c-4963-a1f7-bd301aee89cb@arm.com>
Date: Wed, 22 Jul 2026 14:31:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/37] KVM: arm64: CCA: Support the VGIC in realms
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-13-steven.price@arm.com>
 <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/07/2026 09:27, Kohei Enju wrote:
> On 07/15 15:28, Steven Price wrote:
>> The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
>> the registers are passed in the system registers so this works similar
>> to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
>> and realm guests don't support GICv2 even if the host does.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> Hi Steven,

Hi Kohei,

> I've been testing this series and found that when the host CPU doesn't have
> ARM64_HAS_ICH_HCR_EL2_TDIR this series doesn't work as expected.

Thanks for testing!

> Since commit 2a28810cbb8b ("KVM: arm64: GICv3: Detect and work around the lack
> of ICV_DIR_EL1 trapping"), when the host CPU doesn't support this feature, KVM
> traps all GIC sysreg accesses in the common group. However, currently trap
> handlers for ICC_{PMR,RPR,CTLR}_EL1 registers are missing [0]. So when Realm
> guests try to access those registers, KVM traps them but just emits the warning
> shown in [1], and Realm guests fail to boot.
> 
> As far as I can tell, the CCA requirements don't require the
> ARM64_HAS_ICH_HCR_EL2_TDIR feature. If that's the case, this seems to be a
> problem. Is there any workaround for this issue, or should we implement trap
> handlers for those registers?

As Marc has already said in his reply, I'm really surprised you have a
CPU which implements CCA but doesn't have ARM64_HAS_ICH_HCR_EL2_TDIR.
Can you give some more details about the platform you are testing on?

Ultimately there are two options here - either don't support CCA (so
detect the lack of ARM64_HAS_ICH_HCR_EL2_TDIR and bail out early), or
plumb in the trap handlers - as commit 2a28810cbb8b points out this
isn't something we really want to support if we can avoid it.

Hence I'm interested to know where this sits between "hacked up test
system" and "production hardware". E.g. if this is an emulator it might
be possible to just enable the CPU feature.

Thanks,
Steve

> Thanks,
> Kohei
> 
> [0]
> static const struct sys_reg_desc sys_reg_descs[] = {
>     ...
> 	{ SYS_DESC(SYS_ICC_PMR_EL1), undef_access },
> 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
> 	{ SYS_DESC(SYS_ICC_CTLR_EL1), undef_access },
> };
> 
> [1]
> ------------[ cut here ]------------
> Unexpected undefined exception injection to REC
> WARNING: arch/arm64/kvm/inject_fault.c:330 at kvm_inject_undefined+0x100/0x148, CPU#1: kvm-vcpu-0/370
> Modules linked in:
> CPU: 1 UID: 0 PID: 370 Comm: kvm-vcpu-0 Not tainted 7.2.0-rc1-00096-gd6d40e6a3103 #161 PREEMPT(lazy)
> [...]
> Call trace:
>  kvm_inject_undefined+0x100/0x148 (P)
>  undef_access+0x18/0x30
>  perform_access+0x54/0x1d0
>  kvm_handle_sys_reg+0xfc/0x308
>  rec_exit_sys_reg+0x34/0x168
>  handle_rec_exit+0x12c/0x4c8
>  kvm_arch_vcpu_ioctl_run+0x7a0/0x9a8
>  kvm_vcpu_ioctl+0x180/0xb50
>  __arm64_sys_ioctl+0xb4/0x118
>  invoke_syscall.constprop.0+0xb8/0x120
>  do_el0_svc+0x48/0xc8
>  el0_svc+0x44/0x248
>  el0t_64_sync_handler+0xa0/0xe8
>  el0t_64_sync+0x198/0x1a0
> ---[ end trace 0000000000000000 ]---
>  [...]
> 
>> ---
>> Changes from v12:
>>  * GIC registers are now passed in the system registers rather than via
>>    rec_entry/rec_exit which removes most of the changes.
>> Changes from v11:
>>  * Minor changes to align with the previous patches. Note that the VGIC
>>    handling will change with RMM v2.0.
>> Changes from v10:
>>  * Make sure we sync the VGIC v4 state, and only populate valid lrs from
>>    the list.
>> Changes from v9:
>>  * Copy gicv3_vmcr from the RMM at the same time as gicv3_hcr rather
>>    than having to handle that as a special case.
>> Changes from v8:
>>  * Propagate gicv3_hcr to from the RMM.
>> Changes from v5:
>>  * Handle RMM providing fewer GIC LRs than the hardware supports.
>> ---
>>  arch/arm64/kvm/arm.c            | 11 ++++++++---
>>  arch/arm64/kvm/vgic/vgic-init.c |  2 +-
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 38fac98cd6a4..2959a1451232 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -791,19 +791,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
>>  	}
>>  
>> +	kvm_timer_vcpu_put(vcpu);
>> +	kvm_vgic_put(vcpu);
>>  	kvm_vcpu_put_debug(vcpu);
>> +
>> +	vcpu->cpu = -1;
>> +
>> +	if (vcpu_is_rec(vcpu))
>> +		return;
>> +
>>  	kvm_arch_vcpu_put_fp(vcpu);
>>  	if (has_vhe())
>>  		kvm_vcpu_put_vhe(vcpu);
>> -	kvm_timer_vcpu_put(vcpu);
>> -	kvm_vgic_put(vcpu);
>>  	kvm_vcpu_pmu_restore_host(vcpu);
>>  	if (vcpu_has_nv(vcpu))
>>  		kvm_vcpu_put_hw_mmu(vcpu);
>>  	kvm_arm_vmid_clear_active();
>>  
>>  	vcpu_clear_on_unsupported_cpu(vcpu);
>> -	vcpu->cpu = -1;
>>  }
>>  
>>  static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index 907057881b26..fd77db35ef02 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -81,7 +81,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>>  	 * the proper checks already.
>>  	 */
>>  	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
>> -		!kvm_vgic_global_state.can_emulate_gicv2)
>> +	    (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
>>  		return -ENODEV;
>>  
>>  	/*
>> -- 
>> 2.43.0
>>
>>

