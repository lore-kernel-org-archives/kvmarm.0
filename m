Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5916E3ECBEE
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284126; cv=none; b=E46wGF14c0YVKEA3FIBqq3dj1iOOTnEtFgbCKrK3ZAKM1O1yuCHL6X5Er3UyXY34iNwCTCXx2Hj/UGABZGX43+aXKc+JqNdWQbvqrQPZvh60lbiiTpvSR8H5NuAMmhzeA81h0fM3XngEedX4ngVfyF9jlNFo9KribU/JI/ta2RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284126; c=relaxed/simple;
	bh=5vxcZkzEtmN43OFsk6YElbKdFFPmtXw6xx1BuTII70M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWKzd+0IY2mT8lGlMY0C8wLqSDxAHM4exgu/5HT1OBpLUEp2Wj9Yyta2rrf/jpoy/tQBWAryGH+ZT2o1U9jJ8TnPjjlL7JkX3BULijSadzROmV13yO8+EKz8RFcxVnziToS1SP1S8HEewOCovaJpmkts55utraTO+Cv+VkbHqwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TlXlQ5YL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TlXlQ5YL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5823C1476;
	Fri, 17 Jul 2026 03:28:40 -0700 (PDT)
Received: from [10.57.41.23] (unknown [10.57.41.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F41B3F7D8;
	Fri, 17 Jul 2026 03:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784284124; bh=5vxcZkzEtmN43OFsk6YElbKdFFPmtXw6xx1BuTII70M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TlXlQ5YLScUb+Tklku+f3lBDRai7frJfu8g0dE0QVqodDSgEeFqVbNpBu7S3B4gwc
	 +ePN5Gu23RoOCcOman2Ix/Quuw/G0aZsUeLhGbIAxwuw4TL9aW/LUNV1iV8lRGQHpN
	 MhAYcqZZEixiIyKFFK3fazc1SivJypgrohu+ButA=
Message-ID: <ec5210e5-eef1-4188-b094-74908046533e@arm.com>
Date: Fri, 17 Jul 2026 11:28:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 0/4] Add guest_memfd support for arm64
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

On 12/07/2026 15:25, Fuad Tabba wrote:
> Hi folks,
> 


> Due to popular demand, i.e., Alexandru asking me about it, I repolished my
> guest_memfd support series. The one I sent years ago was stale and
> over-engineered, so this is a fresh start instead.
> 
> This series adds support for backing guest RAM with guest_memfd on
> arm64, for non-protected VMs under both regular KVM and pKVM.
> 
> The first two patches are standalone fixes in the code this series
> builds on: an uninitialized return value in kvm__for_each_mem_bank(),
> and doubled newlines in die() messages. Patch 3 adds guest_memfd
> plumbing to kvm__register_mem(), using kvm_userspace_memory_region2
> only for guest_memfd-backed slots.
> 
> A new --guest-memfd option creates guest RAM from a guest_memfd with
> mmap support (GUEST_MEMFD_FLAG_MMAP and GUEST_MEMFD_FLAG_INIT_SHARED,
> Linux 6.18+), maps it to provide the userspace mapping, and registers
> it with KVM_SET_USER_MEMORY_REGION2.
> 
> Protected VMs need in-place shared/private conversion of guest_memfd,
> which is still in progress in the kernel [3], so --protected rejects
> the option.
> 
> Based on kvmtool master (ca0ddafa941d).
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20260708182239.1489297-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20260706083555.302972-1-fuad.tabba@linux.dev/
> [3] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/
> 
> Fuad Tabba (4):
>    Initialize the return value in kvm__for_each_mem_bank()
>    Remove newline from end of die() aborts
>    Add support for registering guest_memfd-backed memory regions
>    arm64: Add --guest-memfd option to back guest RAM with guest_memfd

Thanks for reworking this again ! For the series:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

