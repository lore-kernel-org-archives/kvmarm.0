Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECAC38B7D5;
	Thu, 12 Mar 2026 09:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773307708; cv=none; b=u8fZyYUZm4hld0pVV8tvJf9smv4+tGUU/LcRYEPXLxjwhwgjRxBQL7Q+9g8iy9QeN5KiOPnQ47JBNznWgCIWHOAG4L33mePdX8PY9Z76Khzsv7nxWQhc5ebhJhNEogfVM+OjI72Q8dQdNT21CxyDbfg2ZN5oAXVOoYmxsEIhAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773307708; c=relaxed/simple;
	bh=kzg5o1mkj+LHD/DxvO8RvKUij8FXYda7l9eciMFRSZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gnWfH+EST2xUDQPoPI4+JHQwsZfHAzpNefyvSOyZ1/OqoL3vhEXMCRX3YdExvOU/N+3Bbu3GG65Y9XCXleEI/cReBCl1E3ld/6yOxJ/bmSRLSv8LtBmog8QdVDXzniJh6wA14ATCE5GDh3LMAoflzVAMIbQVqCpn/AbbVj1X/zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66510165C;
	Thu, 12 Mar 2026 02:28:14 -0700 (PDT)
Received: from [10.57.18.49] (unknown [10.57.18.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CABE63F694;
	Thu, 12 Mar 2026 02:28:17 -0700 (PDT)
Message-ID: <dd6f4715-e8be-41d1-af60-00f068e9d730@arm.com>
Date: Thu, 12 Mar 2026 09:28:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 06/46] arm64: RMI: Define the user ABI
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
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
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <87v7f2chde.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/03/2026 19:10, Marc Zyngier wrote:
> On Mon, 02 Mar 2026 15:23:44 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>>>> +  struct kvm_arm_rmi_populate {
>>>> +	__u64 base;
>>>> +	__u64 size;
>>>> +	__u64 source_uaddr;
>>>> +	__u32 flags;
>>>> +	__u32 reserved;
>>>> +  };
>>>> +
>>>> +Populate a region of protected address space by copying the data from the user
>>>> +space pointer provided. This is only valid before any VCPUs have been run.
>>>> +The ioctl might not populate the entire region and user space may have to
>>>> +repeatedly call it (with updated pointers) to populate the entire region.
>>>
>>> size as a __u64 is odd, as the return value from the ioctl is a signed
>>> int. This implies that you can't really report how many bytes you have
>>> copied.  Some form of consistency wouldn't hurt.
>>
>> Good spot. In practice this works because >2GB in one operation is
>> highly unlikely to be processed in one go. But I guess I'll change this
>> to have an output size argument. I guess I could make the kernel update
>> all of base,size,source_uaddr which would simplify user space.
> 
> In a conversation with Suzuki, I suggested that splice(2) could be a
> nicer way to express this, and allow asynchronous use with io-uring.
> 
> After all, having a guestmem backend for CCA is not exactly
> outlandish, and having a splice implementation realistic enough.
> 
> Thoughts?

One issue that I realised, is about the "flags" for the populate.
Data can be loaded as measured vs unmeasured in CCA (and in TDX
and SNP). I don't see a way to convey this with splice.

Suzuki

> 
> 	M.
> 

