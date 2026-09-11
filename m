Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38B049B5D6
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142991; cv=none; b=TRo1fVQ1eYVVMyzNVfydhnwgMyaBwwh6gjsUAV1BDrEKNqRg6vxizrVU8xi2ws0MfcPL6K5wgzFj9k6eZHf/yh1GZH4dI7KHL207ol6I8LrNuylvPZk20yzCjR1ppUNziRYGyJ2YIcDtNQXlQ7fvPOALnLCG5nrKYk7dmfESAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142991; c=relaxed/simple;
	bh=R3y5188pd0F5/104NAoFNHI16Opb2VM5/osMkCNme7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dr1AYObeGNTxjeqgPlWxU5V9VcxjfThqEL3ldlNBm3o+QxiB1RHFx9IB2Pi1CzilagCYrt4HEoPo4l1cJ6q3QTTEQriQtsfFVRgezhnfFKLshXepvgXUeYjlbM4J1MvjMusmMc7gKch3N4YIWYeB01iFzOTBYYzelpO/RVkDtS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JshXtrxS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JshXtrxS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 688F22A6B;
	Fri, 11 Sep 2026 09:09:45 -0700 (PDT)
Received: from [10.0.129.245] (unknown [10.0.129.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 784C03F7B4;
	Fri, 11 Sep 2026 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789142989; bh=R3y5188pd0F5/104NAoFNHI16Opb2VM5/osMkCNme7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JshXtrxSRrDc6ppaqUNxzL3+c8nw0Rq35ew6fiWeq9Y8nm1TzCoTY6U7coeQnvSml
	 Qv4sQtRVYZK0c/4QXq/1rq3WTwF+RdF/XL1fDQGAj6JQcJ4vA28kWeWlVfaQZz51A+
	 9iPAGWE9xFM7a4K6nGjuMb7d0/ETE/256oE+FFVc=
Message-ID: <16a02301-96a1-42cd-95ed-ed773f4ad77e@arm.com>
Date: Fri, 11 Sep 2026 17:09:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 0/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Content-Language: en-GB
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, maz@kernel.org,
 pavan.kondeti@oss.qualcomm.com, tabba@google.com, aneesh.kumar@kernel.org,
 mark.rutland@arm.com, sdonthineni@nvidia.com, steven.price@arm.com,
 gshan@redhat.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
 <aqP72gst-Y0KtxA5@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aqP72gst-Y0KtxA5@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/09/2026 14:02, Will Deacon wrote:
> On Mon, Sep 07, 2026 at 05:22:03PM +0100, Suzuki K Poulose wrote:
>> This single patch teaches the arm64 fault handling code about Granule
>> Protection Faults, introduced by FEAT_RME. This was posted with KVM CCA
>> support series, but split from that, to allow for other users of GPF.
>>
>> The immediate user is KVM CCA, where the host may fault if it accesses
>> granules that have been delegated for use by a Realm. However, the fault
>> handling itself is architectural and not KVM-specific. It should also be useful
>> for other FEAT_RME users where an access to secure memory or root memory can
>> result in a GPF.
>>
>> GPFs during a page table walk are treated as kernel bugs, while non-page-walk
>> faults can be reported to userspace with SIGBUS. The patch also allows existing
>> exception-table fixups to handle known in-kernel accesses such as
>> load_unaligned_zeropad() while private memory remains mapped in the linear map.
> 
> I assume you can't handle GUP for realm memory, so you must be using
> guest_memfd to avoid userspace mappings of realm memory. In that case,
> why don't you unmap it from the linear map entirely? There's ongoing work
> to do that afaik, it can be done largely outside of arch code and it
> seems like people want it to defend against side channels anyway.

Yes, thats the plan. Sorry, the commit message is a bit vague. Until we
have that support, we should try to fixup the exception.
Once we get the support to unmap them from the linear map, we could
relax this.


Cheers
Suzuki

> 
> Will

