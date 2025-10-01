Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309DF259CA0;
	Wed,  1 Oct 2025 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759331967; cv=none; b=Ap/9RHI7WuL6vSC3XrKnZ/QcdT01NIEnm97ZQYeOP2dguywItVGNddcW3PaB+jP9q124KDvSs9BlxFBe6+RqTwYDSStEQpC/xmDvYzEV2HZD3LX9usBvQhZGWBoEigxYHdEOpNQy0n3s8rB7Wa5YcnOOcCx1H32NKyz6bwxixAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759331967; c=relaxed/simple;
	bh=AuwwvpeSpDso60zCvsa1OUltjVmGQt8y3NeOBslXwNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2KGxWb+XzBfMgU8qx/73YTZvjrs5uTvu8OnokI6hr1FVB7YBCI0txZa9+dtKRHOCReMsGM9gpKs+gmhzOAp6JSK8uFb+oGKqsPU20/g0noL8fSqXjxGg2D9R/ekJFcCvfjFItWDkshXoqbbhVZDgVtrIToVOrlVNZI03WlJbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DB241424;
	Wed,  1 Oct 2025 08:19:16 -0700 (PDT)
Received: from [10.57.0.204] (unknown [10.57.0.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5E213F59E;
	Wed,  1 Oct 2025 08:19:18 -0700 (PDT)
Message-ID: <765f8a3e-2bdd-4352-ba89-99ce3dbc6e4c@arm.com>
Date: Wed, 1 Oct 2025 16:19:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/43] kvm: arm64: Don't expose debug capabilities for
 realm guests
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
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
 <20250820145606.180644-9-steven.price@arm.com> <86ikgyzrzj.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86ikgyzrzj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/2025 14:11, Marc Zyngier wrote:
> On Wed, 20 Aug 2025 15:55:28 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> RMM v1.0 provides no mechanism for the host to perform debug operations
>> on the guest. So don't expose KVM_CAP_SET_GUEST_DEBUG and report 0
>> breakpoints and 0 watch points.
> 
> What is the guest seeing for the same things?

The number of breakpoints/watchpoints is configured using the usual
architectural register ID_AA64DFR0_EL1. So the VMM can configure the
guest as it pleases to be able to debug itself.

Obviously CCA is about the host not seeing into the guest so debugging
the guest is generally not permitted.

RMM v1.1 should provide some mechanisms for the host to debug a realm -
but this would also change the attestation measurement so needs buy in
from the guest's attestation flow. I don't think the RMM API for that is
finalised yet, and I certainly don't have any Linux patches.

Thanks,
Steve

