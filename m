Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D9E23C4F2;
	Thu, 12 Mar 2026 10:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773312327; cv=none; b=kh0srF7+AvCWYFgnJCW7wwcxhSjVAmqAfn05pyJ5uNZp5v9D4ODJullOUqvXGmhHKn4N1FZvS5hX2Jm9dOmS86f8MBoODWwAZBy7/tQ4/zBJELcQiXzZO6py00Mkq44il0frKAMe+4yAjnmkf6HvBfQL421GKAaR5c5cSxW7XDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773312327; c=relaxed/simple;
	bh=l08jxwdCYCfpzqBDE5vY1CxLuVpa9caXm3o6QBAP73c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raXvFbDkqucdotqY014BIeUit+yREZaXuquJ5+AUyO8v6fDxV0UXnMVLWTzgpcXesQPLwXjgFxPbjBDpEDfEbAq95RfXJDtImh0I6gAUvETq3MTS24rENX/qrtfZ6fEIqdM43IlegDX4TGjxjeSz8QNhFtrEI+ZuZuXUxCJhyh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC80E165C;
	Thu, 12 Mar 2026 03:45:18 -0700 (PDT)
Received: from [10.1.26.37] (e122027.cambridge.arm.com [10.1.26.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B85C3F694;
	Thu, 12 Mar 2026 03:45:21 -0700 (PDT)
Message-ID: <45798b53-e18b-4e7b-a49c-37d1783f3444@arm.com>
Date: Thu, 12 Mar 2026 10:45:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
To: Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>
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
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-7-steven.price@arm.com> <86tsuy8g0u.wl-maz@kernel.org>
 <33053e22-6cc6-4d55-bc7f-01f873a15d28@arm.com> <87v7f2chde.wl-maz@kernel.org>
 <dd6f4715-e8be-41d1-af60-00f068e9d730@arm.com> <86342575ev.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86342575ev.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/03/2026 09:39, Marc Zyngier wrote:
> On Thu, 12 Mar 2026 09:28:16 +0000,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> On 11/03/2026 19:10, Marc Zyngier wrote:
>>> On Mon, 02 Mar 2026 15:23:44 +0000,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>>>> +  struct kvm_arm_rmi_populate {
>>>>>> +	__u64 base;
>>>>>> +	__u64 size;
>>>>>> +	__u64 source_uaddr;
>>>>>> +	__u32 flags;
>>>>>> +	__u32 reserved;
>>>>>> +  };
>>>>>> +
>>>>>> +Populate a region of protected address space by copying the data from the user
>>>>>> +space pointer provided. This is only valid before any VCPUs have been run.
>>>>>> +The ioctl might not populate the entire region and user space may have to
>>>>>> +repeatedly call it (with updated pointers) to populate the entire region.
>>>>>
>>>>> size as a __u64 is odd, as the return value from the ioctl is a signed
>>>>> int. This implies that you can't really report how many bytes you have
>>>>> copied.  Some form of consistency wouldn't hurt.
>>>>
>>>> Good spot. In practice this works because >2GB in one operation is
>>>> highly unlikely to be processed in one go. But I guess I'll change this
>>>> to have an output size argument. I guess I could make the kernel update
>>>> all of base,size,source_uaddr which would simplify user space.
>>>
>>> In a conversation with Suzuki, I suggested that splice(2) could be a
>>> nicer way to express this, and allow asynchronous use with io-uring.
>>>
>>> After all, having a guestmem backend for CCA is not exactly
>>> outlandish, and having a splice implementation realistic enough.
>>>
>>> Thoughts?
>>
>> One issue that I realised, is about the "flags" for the populate.
>> Data can be loaded as measured vs unmeasured in CCA (and in TDX
>> and SNP). I don't see a way to convey this with splice.
> 
> Surely that should me a property of the memory region, and not the way
> it is copied, right?

I'm not sure what the current thoughts on the matter are, but there was
an intention in the past that some data could be measured and some not
within a region which is logically the same. E.g. the DT might be
deliberately unmeasured so that the same measurement would cover a
selection of different configurations (with the guest obviously
validating that it was sane before continuing). Forcing the memory to be
split into multiple memslots just so a measurement flag can be set
correctly seems like a poor uAPI.

While splice(2) certainly looks similar to what we want, it does
(according to the man page at least) have the requirement that "one of
the file descriptors must refer to a pipe" which seems less than ideal
for the DT case where it's likely to be generated in memory by the VMM.
Or is my man page out of date and the pipe restriction isn't there in
the kernel?

Thanks,
Steve

