Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D554143E072;
	Wed, 12 Aug 2026 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537133; cv=none; b=KkjT+myRRRJpRLn4Qkqeq8NtrCHeWysAOBARNSaFgFEvM6yzxNbUCaGZbw4+coeuVaZHuq4A8L97dQq7CJG39Pe5i0CRtpHxEHHK/eDgTbiy3Se4R7cvbigHyan+p/YNEBS+RpQ3T+QMjGjr00xCKxcpjXgC2dULJHYYf4bFUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537133; c=relaxed/simple;
	bh=enjpyTGV6J/Ax7972/ygga5P+saUH5TOac+lROt0YfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIC00CGPFt7C8zbHG4Or5UCqhZlaMjm8dFZJu6ymcqP9Ypc5OKJauG+uzheIVtAfOUM4Npv7s9OVL0kwhit/6L0UhksCAeLOV/Q1AnuFt49Z+tL16tvhmdSSvPxUdUK6qEUxKw+5jSZWTe6tfl3YcBCoPNJ9KDZn51rxAkOv4vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kNCmgPa7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kNCmgPa7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19FC61596;
	Wed, 12 Aug 2026 05:18:45 -0700 (PDT)
Received: from [10.57.44.219] (unknown [10.57.44.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 614353F632;
	Wed, 12 Aug 2026 05:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786537129; bh=enjpyTGV6J/Ax7972/ygga5P+saUH5TOac+lROt0YfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kNCmgPa7qbwWpc4aPu/N9O4IsZPqlPzAwORtgDQiHuFdRMliEFHLMbHgcSvs8EDCJ
	 n4amYci4PH8hgMq4unWEILtiTirpl3DM9zhHsyb+uOFBMrPYCDKBIgGlx4RPhm6WqX
	 pG4b/waj23NmfedDPTA6MyJ3XEjTDadHBaaYzNUc=
Message-ID: <650bb70a-a02d-4976-a5c8-7cc5fb811b55@arm.com>
Date: Wed, 12 Aug 2026 13:18:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Alper Gun <alpergun@google.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Javier.AlmansaSobrino@arm.com
References: <20260803134403.80630-1-steven.price@arm.com>
 <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
 <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com>
 <5e86232a-89ed-40ff-89e2-9e48fbf9554e@arm.com>
 <e2894206-7470-4606-b9ac-eedc8d2bdaf3@redhat.com>
 <CABpDEukGY+ctSi6wHAaC7o4pGmastX_Y18K2_VYDhNME7TF+wQ@mail.gmail.com>
 <f5d47f5f-5869-4e3a-a176-4fd632567975@arm.com>
 <ad7d1093-685d-4c11-807d-929d16271cdb@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ad7d1093-685d-4c11-807d-929d16271cdb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/08/2026 11:35, Gavin Shan wrote:
> Hi Alper and Suzuki,
> 
> On 8/12/26 4:04 PM, Suzuki K Poulose wrote:
>> Hi Alper, Gavin
>>
>> On 12/08/2026 04:25, Alper Gun wrote:
>>> On Tue, Aug 11, 2026 at 8:08 PM Gavin Shan <gshan@redhat.com> wrote:
>>>> As the following calltrace indicates, -EAGAIN is returned from tf- 
>>>> rmm::update_ripas()
>>>> because true is returned from s2tte_drain_pending() for the S2TTE 
>>>> corresponding to
>>>> IPA 0x80000000. Linux host received error (RMI_ERROR_RTT, level=3) 
>>>> in ripas_change().
>>>> Upon this specific error and the IPA range [0x80000000 0x90000000], 
>>>> find_map_level()
>>>> returns level of 2, and realm_create_rtt_levels() returns 0 without 
>>>> populating any
>>>> RTTs. After that, rmi_rtt_set_ripas() is re-executed and the above 
>>>> loop starts over
>>>> again.
>>>>
>>>>     Linux host
>>>>     ==========
>>>>     kvm_arch_vcpu_ioctl_run                     // cca/host-v16
>>>>       check_vcpu_requests
>>>>         kvm_check_request
>>>>           kvm_rec_handle_request
>>>>             kvm_complete_ripas_change
>>>>               realm_set_ipa_state
>>>>                 ripas_change
>>>>                   rmi_rtt_set_ripas
>>>>                     SMC_RMI_RTT_SET_RIPAS
>>>>
>>>>     TF-RMM
>>>>     ======
>>>>     SMC_RMI_RTT_SET_RIPAS                      // tf-rmm/topics/rmm- 
>>>> v2.0-poc_3
>>>>       smc_rtt_set_ripas
>>>>         s2tt_walk_lock_unlock
>>>>         rtt_set_ripas_range
>>>>           update_ripas
>>>>             s2tte_drain_pending                // true, returns -EAGAIN
>>>>
>>>> The problem is the pending-bit for RTE corresponding IPA address 
>>>> 0x80000000 isn't cleared
>>>> when SMC_RMI_RTT_SET_RIPAS is invoked. I didn't figure out how this 
>>>> bit is set and why
>>>> it's not cleared in time.
>>
>> Thanks for the details.
>>
>>>>
>>>
>>> Hi Gavin, Suzuki,
>>>
>>> I think I ran into a similar issue on rmm-v2.0-poc_3 last week.
>>> This looks like a potential RMM bug: could bit 32 be part of the 
>>> physical
>>> Address (if PA >= 4 GiB)?
>>>
>>> It seems s2tte_drain_pending() in lib/s2tt/src/s2tt.c checks bit 32 
>>> without
>>> checking whether the descriptor is valid or invalid.
>>>
>>> In my testing, guarding the drain checks with a check for 
>>> S2TTE_INVALID seemed
>>> to resolve the boot hang:
>>> --- a/lib/s2tt/src/s2tt.c
>>> +++ b/lib/s2tt/src/s2tt.c
>>> @@ -1701,6 +1701,10 @@ unsigned long
>>> s2tte_clear_drain_pending(unsigned long s2tte)
>>>
>>>   bool s2tte_drain_pending(unsigned long s2tte)
>>>   {
>>> + if ((s2tte & S2TT_DESC_VALID_MASK) != S2TTE_INVALID) {
>>> + return false;
>>
>> We should use also consider cases where the entry is INVALID, but
>> has HIPAS=ASSIGNED/ASSIGNED_DEV to make it tighter. So, I think
>> it is better to use :
>>
>> s2tte_is_unassigned() or in the library stick to :
>>
>> if (!s2tte_has_hipas(s2tte, S2TTE_INVALID_HIPAS_UNASSIGNED))
>>      return false;
>>
>> May be we should assert this and make the caller responsible for
>> checking the bit. I will leave it to the tf-RMM team to fix.
>>
>> But for now, please use the above fix.
>>
> 
> Both worked for me. With the extra check in place, the realm guest can boot
> up successfully.
> 
> FYI, The below additional checks in s2tte_tlbi_pending() and 
> s2tte_drain_handle()
> aren't needed because they're always guarded by s2tte_drain_pending() in 
> all
> calling sites.

fyi, the tf-RMM patch is out for review here : (Thanks Javier)

https://review.trustedfirmware.org/c/TF-RMM/tf-rmm/+/53531

Please feel free to cherry-pick that one

Cheers
Suzuki
