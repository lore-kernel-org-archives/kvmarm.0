Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BEF2EBBB2;
	Wed,  8 Oct 2025 08:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759913190; cv=none; b=kaZGW7WWaHMSyQzbFsn09Nl5yFjRpXCw/X1DF6uXdf5DE09UDr0Z5aNZgoaEaujB6dRw+1f6n6pgfQnu8qdO1Qvlgt8uKEzd4NbGUhBlBaM6hqREMYE/knilci9etOwFoXB+cIBM7auUm2NsfYqDJTrgMdRRP9y7xZDollXZt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759913190; c=relaxed/simple;
	bh=+XznjIOve31pzE7pEfFd9HONdlJdvzdANALqU09QmDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JKoIVmi3Qk6WYLTPbXI5s2XpUKB12nq6tKqBwxONhtwLLKiVJviRYwQynlcZmgC+prlKWomtSL36IvNfuRbsDzlVHUp5CxzrvDobcGgDS0URTEEnmpy0ht4xUfKhmYqb6VY2Xq1LAWk0592WBen+k56ce82Y+XG82fC9xJ1g0aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D7FD113E;
	Wed,  8 Oct 2025 01:46:13 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 616CB3F738;
	Wed,  8 Oct 2025 01:46:18 -0700 (PDT)
Message-ID: <21424147-f060-4a96-a362-23dc4378a2d5@arm.com>
Date: Wed, 8 Oct 2025 09:46:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/43] arm64: RME: Add SMC definitions for calling the
 RMM
To: Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-4-steven.price@arm.com> <86o6qrym2b.wl-maz@kernel.org>
 <747ab990-d02d-4e7c-9007-a7ac73bb1062@arm.com> <86ldluzvdb.wl-maz@kernel.org>
 <990a62ee-c7a7-4cdf-9e0a-efc7908a1f2e@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <990a62ee-c7a7-4cdf-9e0a-efc7908a1f2e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 01/10/2025 15:05, Steven Price wrote:
> On 01/10/2025 12:58, Marc Zyngier wrote:
>> On Wed, 01 Oct 2025 12:00:14 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 01/10/2025 11:05, Marc Zyngier wrote:
>>>> On Wed, 20 Aug 2025 15:55:23 +0100,
>>>> Steven Price <steven.price@arm.com> wrote:
>>>>>
>>>>> The RMM (Realm Management Monitor) provides functionality that can be
>>>>> accessed by SMC calls from the host.
>>>>>
>>>>> The SMC definitions are based on DEN0137[1] version 1.0-rel0
>>>>>
>>>>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>>>>>
>>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>> ---
>>>>> Changes since v9:
>>>>>   * Corrected size of 'ripas_value' in struct rec_exit. The spec states
>>>>>     this is an 8-bit type with padding afterwards (rather than a u64).
>>>>> Changes since v8:
>>>>>   * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
>>>>>     permits to be modified.
>>>>> Changes since v6:
>>>>>   * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>>>>>     these are flag values.
>>>>> Changes since v5:
>>>>>   * Sorted the SMC #defines by value.
>>>>>   * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>>>>>     RMI calls.
>>>>>   * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>>>>>     number of available list registers could be lower.
>>>>>   * Provided a define for the reserved fields of FeatureRegister0.
>>>>>   * Fix inconsistent names for padding fields.
>>>>> Changes since v4:
>>>>>   * Update to point to final released RMM spec.
>>>>>   * Minor rearrangements.
>>>>> Changes since v3:
>>>>>   * Update to match RMM spec v1.0-rel0-rc1.
>>>>> Changes since v2:
>>>>>   * Fix specification link.
>>>>>   * Rename rec_entry->rec_enter to match spec.
>>>>>   * Fix size of pmu_ovf_status to match spec.
>>>>> ---
>>>>>   arch/arm64/include/asm/rmi_smc.h | 269 +++++++++++++++++++++++++++++++
>>>>>   1 file changed, 269 insertions(+)
>>>>>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
>>>>> new file mode 100644
>>>>> index 000000000000..1000368f1bca
>>>>> --- /dev/null
>>>>> +++ b/arch/arm64/include/asm/rmi_smc.h
>>>>
>>>> [...]
>>>>
>>>>> +#define RMI_PERMITTED_GICV3_HCR_BITS	(ICH_HCR_EL2_UIE |		\
>>>>> +					 ICH_HCR_EL2_LRENPIE |		\
>>>>> +					 ICH_HCR_EL2_NPIE |		\
>>>>> +					 ICH_HCR_EL2_VGrp0EIE |		\
>>>>> +					 ICH_HCR_EL2_VGrp0DIE |		\
>>>>> +					 ICH_HCR_EL2_VGrp1EIE |		\
>>>>> +					 ICH_HCR_EL2_VGrp1DIE |		\
>>>>> +					 ICH_HCR_EL2_TDIR)
>>>>
>>>> Why should KVM care about what bits the RMM wants to use? Also, why
>>>> should KVM be forbidden to use the TALL0, TALL1 and TC bits? If
>>>> interrupt delivery is the host's business, then the RMM has no
>>>> business interfering with the GIC programming.
>>>
>>> The RMM receives the guest's GIC state in a field within the REC entry
>>> structure (enter.gicv3_hcr). The RMM spec states that the above is the
>>> list of fields that will be considered and that everything else must be
>>> 0[1]. So this is used to filter the configuration to make sure it's
>>> valid for the RMM.
>>>
>>> In terms of TALL0/TALL1/TC bits: these control trapping to EL2, and when
>>> in a realm guest the RMM is EL2 - so it's up to the RMM to configure
>>> these bits appropriately as it is the RMM which will have to deal with
>>> the trap.
>>
>> And I claim this is *wrong*. Again, if the host is in charge of
>> interrupt injection, then the RMM has absolutely no business is
>> deciding what can or cannot be trapped. There is zero information
>> exposed by these traps that the host is not already aware of.
>>
>>> [1] RWVGFJ in the 1.0 spec from
>>> https://developer.arm.com/documentation/den0137/latest
>>
>> Well, until someone explains what this is protecting against, I
>> consider this as broken.
> 
> I'm not sure I understand how you want this to work. Ultimately the
> realm guest entry is a bounce from NS-EL2 to EL3 to R-EL2 to R-EL1/0. So
> the RMM has to have some control over the trapping behaviour for its own
> protection. The current spec means that the RMM does not have to
> implement the trap handlers for TALL0/TALL1/TC and can simply force
> these bits to 0. Allowing the host to enable traps that the RMM isn't
> expecting will obviously end in problems.

The RMM design took a conservative approach of exposing bare minimum
controls to the host to manage the VGIC, without increasing the
complexity in the RMM. But if you think that the current set of
controls are not sufficient for the Host to manage the Realm VGIC,
like Steven mentions below, we could feed this back to the RMM spec
and extend it in the future versions. I expect the new traps
would be reported back as "sysreg" accesses (similar to the already
exposed ICC_DIR, ICC_SGIxR).

Thanks
Suzuki


> 
> If your argument is that because the NS host is emulating the GIC it
> needs to be able to do these traps, then that's something that can be
> fed back to the spec and hopefully improved. In that case the trap
> information would be provided in the rec_entry structure and on trap the
> RMM would return prepare information in the rec_exit structure. This
> could in theory be handled similar to an emulatable data abort with a
> new exit reason.
> 
> The other approach would be to push more GIC handling into the RMM such
> that these trap bits are not needed (i.e. there's no requirement to exit
> to the NS host to handle the trap, and the RMM can program them
> independently). I'm afraid I don't understand the GIC well enough to
> know how these traps are used and how feasible it is for the RMM to just
> "do the right thing" here.
> 
>>>>> +	union { /* 0x300 */
>>>>> +		struct {
>>>>> +			u64 gicv3_hcr;
>>>>> +			u64 gicv3_lrs[REC_MAX_GIC_NUM_LRS];
>>>>> +			u64 gicv3_misr;
>>>>
>>>> Why do we care about ICH_MISR_EL2? Surely we get everything in the
>>>> registers themselves, right? I think this goes back to my question
>>>> above: why is the RMM getting in the way of ICH_*_EL2 accesses?
>>>
>>> As mentioned above, the state of the guest's GIC isn't passed through
>>> the CPU's registers, but instead using the rec_enter/rec_exit
>>> structures. So unlike a normal guest entry we don't set all the CPU's
>>> register state before entering, but instead hand over a shared data
>>> structure and the RMM is responsible for actually programming the
>>> registers on the CPU. Since many of the registers are (deliberately)
>>> unavailable to the host (e.g. all the GPRs) it makes some sense the RMM
>>> also handles the GIC registers save/restore.
>>
>> And I claim this is nonsense. There is nothing in these registers that
>> the host doesn't need to know about, which is why they are basically
>> copied over.
> 
> Well it's fairly obvious that the host (generally) doesn't need to know
> the general purpose registers. And it's fairly clear that confidential
> compute would be pretty pointless if the hypervisor leaked those
> registers. So I hope we agree that some architectural registers are
> going to have to be handled differently from a normal guest.
> 
> The GIC is unusual because it's (partly) emulated by the host. The
> configuration is also complex because during guest entry rather than
> just dropping down to EL1/0 we're actually performing an SMC to EL3 and
> world-switching. So I'm not sure to what extent programming the
> architectural registers in the normal world would work.
> 
>> It all feels just wrong.
> 
> I think fundamentally the confusing thing is there are two hypervisors
> pretending to be one. Both KVM and the RMM are providing part of the
> role of the hypervisor. It would "feel" neater for the RMM to take on
> more responsibility of the hypervisor role but that leads to more
> complexity in the RMM (whose simplicity is part of the value of CCA) and
> potentially less flexibility because you haven't got the functionality
> of KVM.
> 
> Thanks,
> Steve

