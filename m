Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C45290DBB;
	Sat,  3 Oct 2026 05:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791007050; cv=none; b=tUcEqt+KK7KIT2BHc59u0gX6eWLQjzzWoOnekMJy1lClP9Pj/OoyFDZce7uj3+FiJvMW5d4EU7Sb2+4M2u66z1lBFYqfjh05i9WYiv4y+bQi+uRQ6zbXQ17Q/pJxK9KKTNjNE5Ce8SeB8/YB0L/YdAySOCSM3gRZNcsHmDOivF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791007050; c=relaxed/simple;
	bh=tFDkya3P/yKLJCp1gICFrurPqs3+IzYRZ7NfNR2Iomo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gtg2iDqgt84VJV3wBRTm8PAbTtLILT2xLiGhxE2azrw3+Vlh9qVfmNskP/OpYugfkW+Jm9fbm64P4AKvuOoc6HJp6HAfqpy6G1pdx7Oh0577IouLRhyiIEP6ryEEgwX2TCIQmJzuM2qqDrMIZm77XsLk7RaRsOXhzr4Xe6b9w7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bnit/Ug3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bnit/Ug3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD65A2F;
	Fri,  2 Oct 2026 22:57:23 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89EEB3F85F;
	Fri,  2 Oct 2026 22:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791007047; bh=tFDkya3P/yKLJCp1gICFrurPqs3+IzYRZ7NfNR2Iomo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bnit/Ug3xfN4z/vm7IHCCvu/yhzCUCP2bfUgXXkrVejTIQk3nwQaE9o+lhUm+0OSB
	 9pJJtzlOIpii1/BjB6NI+OdW/Tsb9O7Hxz/K6vPWvuJRiV814decK32VCBnJfnL24W
	 hwCtS+hiUsp1YeQrX9W3rXlmXbrHVgi8SgQiDOlw=
Message-ID: <b0c3dfcd-d537-4553-a3bb-0dc2d3d3d82c@arm.com>
Date: Sat, 3 Oct 2026 06:57:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 00/10] firmware: arm_rmm: Add RMM v2.0 base RMI
 support
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, maz@kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 jonathan.cameron@oss.qualcomm.com, Fuad Tabba <fuad.tabba@linux.dev>,
 Sudeep Holla <sudeep.holla@kernel.org>, rafael@kernel.org
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <179096683487.2356212.5555509708136944708.b4-ty@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <179096683487.2356212.5555509708136944708.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 19:49, Catalin Marinas wrote:
> On Fri, 02 Oct 2026 07:14:56 +0100, Suzuki K Poulose wrote:
>> This series adds the generic firmware layer for talking to the Realm
>> Management Monitor (RMM), as specified by the RMM v2.0-bet3
>> specification[1]. It is the first part of the Arm CCA host support that
>> was previously posted as part of the larger KVM series.
>>
>> The split allows this RMM support to be used as a base for other work,
>> including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
>>   without depending on the KVM Realm support that will follow as separate
>>   series. (See more on that below)
>>
>> [...]
> 
> Applied to arm64 (for-next/fw-rmi), thanks!
> 
> Rafael, I took the liberty of merging patch 7 below adding an arch
> hibernation hook needed for arm64 (I changed the subject as well to
> PM: ...).
> 
> For now the RMI is default off. We should only make it default y when we
> have a deferred activation gated by kvm rmm option (or PCIe?).
> 
> There are a few typo fixes, some reordering of the Kconfig and Makefile
> entries to preserve a somewhat alphabetical order. No functional change
> though.

Thank you Catalin ! Much appreciated.

Cheers
Suzuki


> 
> [01/10] firmware: arm_rmm: Add SMC definitions for calling the RMM
>          https://git.kernel.org/arm64/c/9e201043cbd2
> [02/10] firmware: arm_rmm: Check for RMI support at init
>          https://git.kernel.org/arm64/c/24657f2ce536
> [03/10] firmware: arm_rmm: Configure the RMM with the host's page size
>          https://git.kernel.org/arm64/c/a0382431a0fe
> [04/10] firmware: arm_rmm: Add support for SRO
>          https://git.kernel.org/arm64/c/bc1360cabe27
> [05/10] firmware: arm_rmm: Activate the RMM
>          https://git.kernel.org/arm64/c/fa193c502990
> [06/10] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
>          https://git.kernel.org/arm64/c/c20b65a03eff
> [07/10] kernel: hibernate: Add an arch hook for preventing hiberation
>          https://git.kernel.org/arm64/c/5487bff69b85
> [08/10] arm64: Block hibernate and kexec while RMM is active
>          https://git.kernel.org/arm64/c/fe4a24613bc2
> [09/10] firmware: arm_rmm: Add wrappers for Realm related RMI commands
>          https://git.kernel.org/arm64/c/c4a16839abb1
> [10/10] firmware: arm_rmm: hotplug: Skip memory added to ZONE_MOVABLE
>          https://git.kernel.org/arm64/c/06898e5320b5

