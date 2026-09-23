Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F260F4949E5;
	Wed, 23 Sep 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176314; cv=none; b=BwkVHtOPdglkdnbD5dL2dKhMggtOJ/L6rZjf+wOKjnx2v4n355RNa++LkhTH1xMqXRP2jpYtmb5mBM7bmLpDwxOt0CiyPKOqhbGyE2pL0z/Ch85iCquRyO4LHsyNure2t1a4vkjlbtqk5sgeyg2Lws8AnffO1fH5NGQxRqotbjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176314; c=relaxed/simple;
	bh=0ZF92qlGhBT9ghFKBAdomT/d7B9mUVR6sojJo9EGm84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rH+ED5GVbbd19BTRHaQ4+yPU1VNJ2NNHiK28/47s9gye+1f6SQftcngWowYOY8KxnN1P959TBWf8hsC+V2olZEkh1oU5RO+4Ah1EoRQIufl/+yFStuKAgO4WU/mXaz415CK3bQJHaCnKEeirFJCo2hKSZqCdnBwCG8qhEy4yM0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bOu4yUj0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bOu4yUj0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8C911A32;
	Wed, 23 Sep 2026 08:11:47 -0700 (PDT)
Received: from [192.168.4.158] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BF113F86F;
	Wed, 23 Sep 2026 08:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790176311; bh=0ZF92qlGhBT9ghFKBAdomT/d7B9mUVR6sojJo9EGm84=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bOu4yUj0Q/cyKCDPQmnlZSSfBzN2YZFcQ+BYeXIGsn3j2NxCyoWazWfOEchSwBK6z
	 p7crav7v88lmt9BsVnUEIn7iRY066xMU2EuJK+FPQ0L1X2J3RaUrkxZaBNckO20vz+
	 0TW+qGgaK5iTEA87RU/L+SeG35VjqNjOB4ZTOJt0=
Message-ID: <86fb3438-8028-49c5-9b4e-2a0970efb91d@arm.com>
Date: Wed, 23 Sep 2026 16:11:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Content-Language: en-GB
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, Michael Kelley <mhklinux@outlook.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org> <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org> <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org> <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca> <yq5atsng10b2.fsf@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5atsng10b2.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Cc: Michael Kelley
On 23/09/2026 15:58, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
>> On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:
>>
>>> The simplest is probably to always zero in the backend and ignore
>>> __GFP_ZERO to the allocator. But it's probably only marginally smaller
>>> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
>>> and compare the diffstat.
>>
>> For patch ordering I would convert to use the allocator first
>>
>> The semantics of the new API should be clear
>>
>> If you pass GFP_ZERO then the resulting allocated memory is zero
>>
>> Otherwise the allocator does Whatever The Arch Needs to not leak
>> private data out.
>>
> 
> ok
> 
>>
>> Once places are converted to the allocator lets go see what is left
>> and ask why it is left and what API it actually needs.
>>
> 
> I'm also considering requiring the address passed to cc_make_shared() to
> be in the linear map. This is currently required by both TDX and CCA,
> while AMD SNP appears to support vmalloc addresses. The only user of
> that vmalloc support is Hyper-V VMBus GPADL setup
> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
> allocator handle this?

This came up in the past and there was a recommendation to alloc shared
pages and vmap them ? I have lost track of it.

Cheers
Suzuki>
> -aneesh

