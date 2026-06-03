Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A8D37B012;
	Wed,  3 Jun 2026 10:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780481740; cv=none; b=q451SgEEGPzFn29V6P+BbPwHTTzTrozwREkUvTcGe5Wiy2CERoUVibWpb8U7AothhOvT+RgSESSqB1lA1y5zoAXCwT6n8cJ5Iyz5amAbfg4ZXM0QGLqY2YuLy8vrFNmZ5/JKWkGoTxPqI1aJz6OTvWpsrZovrczuQk2P3cvo6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780481740; c=relaxed/simple;
	bh=5pJBsfHqtfuBBV3AHbQunZhY9vkYfgbc9VmYOhx6YXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfqkodGJM7csNEbqN8DZA+UGrU7Wv5Q69CkCIfRA3OuOG4UBbAhHvCzhkjaog48jEoPT7vMAHj9lNwO7JNgErQyG5AvuQZbu6NkvU6oSVWMIZ7MUPV/2zAv0V7pn7m19gTgOhNJDWJQYdsf7IM6XJQPNc8aJ5vJfGtUuCUkhGJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a3tFk1kh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a3tFk1kh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B683A49CF;
	Wed,  3 Jun 2026 03:15:30 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2F2C3F632;
	Wed,  3 Jun 2026 03:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780481735; bh=5pJBsfHqtfuBBV3AHbQunZhY9vkYfgbc9VmYOhx6YXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a3tFk1khemwD9g5LaC2t2teF0HtH4Dpwpf3xOUJR26p+g4ZJnnOWZmoD9h6frZHuj
	 OmkCSVrsN/SUCQuC9+0HQKpN2/cHv+SxD5E1grWZpIdFgvPug2xo8ZVC6X3QNRNJFh
	 yj9zU81YBoaetujXyTDSOjevEaNye32bXTzK++14=
Message-ID: <c217a495-bd39-408c-9040-010c30bed1e6@arm.com>
Date: Wed, 3 Jun 2026 11:15:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/44] arm64: RMI: Add SMC definitions for calling the
 RMM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
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
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-5-steven.price@arm.com> <86ecj5vsu4.wl-maz@kernel.org>
 <3261b04f-1a0c-451d-8981-1e2bccc8a9ca@arm.com> <87jysvahpb.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <87jysvahpb.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/05/2026 10:58, Marc Zyngier wrote:
> On Thu, 21 May 2026 16:33:09 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 21/05/2026 13:40, Marc Zyngier wrote:
>>> On Wed, 13 May 2026 14:17:12 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> The RMM (Realm Management Monitor) provides functionality that can be
>>>> accessed by SMC calls from the host.
>>>>
>>>> The SMC definitions are based on DEN0137[1] version 2.0-bet1
>>>>
>>>> [1] https://developer.arm.com/documentation/den0137/2-0bet1/
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v13:
>>>>  * Updated to RMM spec v2.0-bet1
>>>> Changes since v12:
>>>>  * Updated to RMM spec v2.0-bet0
>>>> Changes since v9:
>>>>  * Corrected size of 'ripas_value' in struct rec_exit. The spec states
>>>>    this is an 8-bit type with padding afterwards (rather than a u64).
>>>> Changes since v8:
>>>>  * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
>>>>    permits to be modified.
>>>> Changes since v6:
>>>>  * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>>>>    these are flag values.
>>>> Changes since v5:
>>>>  * Sorted the SMC #defines by value.
>>>>  * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>>>>    RMI calls.
>>>>  * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>>>>    number of available list registers could be lower.
>>>>  * Provided a define for the reserved fields of FeatureRegister0.
>>>>  * Fix inconsistent names for padding fields.
>>>> Changes since v4:
>>>>  * Update to point to final released RMM spec.
>>>>  * Minor rearrangements.
>>>> Changes since v3:
>>>>  * Update to match RMM spec v1.0-rel0-rc1.
>>>> Changes since v2:
>>>>  * Fix specification link.
>>>>  * Rename rec_entry->rec_enter to match spec.
>>>>  * Fix size of pmu_ovf_status to match spec.
>>>> ---
>>>>  arch/arm64/include/asm/rmi_smc.h | 448 +++++++++++++++++++++++++++++++
>>>>  1 file changed, 448 insertions(+)
>>>>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>>>
>>>> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
>>>> new file mode 100644
>>>> index 000000000000..a09b7a631fef
>>>> --- /dev/null
>>>> +++ b/arch/arm64/include/asm/rmi_smc.h
>>>> @@ -0,0 +1,448 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (C) 2023-2026 ARM Ltd.
>>>> + *
>>>> + * The values and structures in this file are from the Realm Management Monitor
>>>> + * specification (DEN0137) version 2.0-bet1:
>>>> + * https://developer.arm.com/documentation/den0137/2-0bet1/
>>>
>>> How long is this spec going to be available on the ARM web site, which
>>> has a tendency of being reorganised every other week? And there is
>>> already a beta2.
>>
>> Obviously I can't predict the next reorganisation - but at least it's a
>> link that could be fed into archive.org or similar.
> 
> I found that the PDF spec was less susceptible to creative nonsense,
> and people can download it for future reference, whereas ARM has
> happily *deleted* specs from the website over time (try to find PSCI
> 0.1, for example...).

Sadly the nearest I found to a link directly to the PDF is:

https://documentation-service.arm.com/static/69cb945ac1586b7c59b1c00c

But I have 0 confidence that that link will work for long (if indeed it
even works for others now!). If you know of any way of getting a better
link out of the Arm website that I'm all ears!

> [...]
> 
>>>> +struct realm_params {
>>>> +	union { /* 0x0 */
>>>> +		struct {
>>>> +			u64 flags;
>>>> +			u64 s2sz;
>>>> +			u64 sve_vl;
>>>> +			u64 num_bps;
>>>> +			u64 num_wps;
>>>> +			u64 pmu_num_ctrs;
>>>> +			u64 hash_algo;
>>>> +			u64 num_aux_planes;
>>>> +		};
>>>> +		u8 padding0[0x400];
>>>
>>> SZ_1K? And similarly all over the shop?
>>
>> I'm a bit less sure that makes the code more readable - these structures
>> are a bit of a pain because they are somewhat sparse. I've left a
>> comment where the beginning of each union is, and personally I find it
>> easier to see 0x0 + 0x400 == 0x400 rather than trying to work out what
>> SZ_1K is in hex. This is particularly the case in terms of:
>>
>>> struct rec_params {
>>> 	union { /* 0x0 */
>>> 		u64 flags;
>>> 		u8 padding0[0x100];
>>> 	};
>>> 	union { /* 0x100 */
>>> 		u64 mpidr;
>>> 		u8 padding1[0x100];
>>> 	};
>>> 	union { /* 0x200 */
>>> 		u64 pc;
>>> 		u8 padding2[0x100];
>>> 	};
>>> 	union { /* 0x300 */
>>> 		u64 gprs[REC_CREATE_NR_GPRS];
>>> 		u8 padding3[0xd00];
>>> 	};
>>> };
>>
>> Where 0xd00 doesn't even have a correspoding SZ_ define.
> 
> Indeed, but it is (SZ_4K - SZ_256 * 3).

Do you really think

 		u8 padding3[SZ_4K - SZ_256 * 3];

is better? I certainly don't. I'll give you (SZ_4K - 0x300) is tempting.
Although it then makes the BUILD_BUG_ON idea below somewhat pointless.

> And a lot of these structures> seem to be designed to form a 4kB blob.
I'm sure we can make use of
> that information (BUILD_BUG_ON?).

BUILD_BUG_ON requires being in a function. But static_assert() can be
used in the header by the struct definitions - I'll add that, thanks for
the suggestion.

>>
>> The RMM deals with this with macro magic:
>>
>>> struct rmi_rec_params {
>>>         /* Flags */
>>>         SET_MEMBER_RMI(unsigned long flags, 0, 0x100);  /* Offset 0 */
>>>         /* MPIDR of the REC */
>>>         SET_MEMBER_RMI(unsigned long mpidr, 0x100, 0x200);      /* 0x100 */
>>>         /* Program counter */
>>>         SET_MEMBER_RMI(unsigned long pc, 0x200, 0x300); /* 0x200 */
>>>         /* General-purpose registers */
>>>         SET_MEMBER_RMI(unsigned long gprs[REC_CREATE_NR_GPRS], 0x300, 0x1000); /* 0x300 */
>>> };
>>
>> where the offsets are just directly encoded in the macro - but it's not
>> an especially robust macro and I'm not convinced it's more readable.
> 
> I think this is just as horrible, but at least it seems to take the
> boundaries of the structure into account.
> 
>>
>> I'm happy to hear other suggestions on how to encode this neatly.
> 
> Honestly, I wouldn't mind having the structures described in a more
> abstract way and then pre-processed to generate the include files. If
> the architectural MRS wasn't so huge, I would have added it to the
> kernel and used that directly for KVM.
> 
>>
>>> I haven't checked the details of the encodings (life is too short),
>>> but I wonder how much of this exists as an MRS and could be
>>> automatically generated?
>>
>> Automatically generating this would be good - I'm not sure whether we
>> have a (public) source available to generate from at the moment. I have
>> tried to methodically work through the spec when updating this file, but
>> as Gavin has already pointed out there was at least one mistake (in
>> currently unused definitions) this time.
> 
> I'm slightly baffled that even the RMM is written this way. Given the
> formalism used in the RMM spec, I was expecting that you'd have a
> bunch of JSON at hand and able to generate any output from that. Doing
> this stuff by hand is both incredibly dull work *and* extremely error
> prone.

I'll look into the possibility of generating the headers. While dull and
error prone I have found it is sometimes useful for forcing a review of
the spec itself. There have been a number of bugs I've found (and have
been corrected) in the spec while writing the header files - it's very
easy to skim read those parts of the document otherwise.

Writing the structures out in a "more abstract way" might be a good
idea, but I'm just a little wary of writing another tool which is only
used in this one spot. The RMM structures are somewhat unusual in being
so sparse.

Thanks,
Steve

> Thanks,
> 
> 	M.
> 

