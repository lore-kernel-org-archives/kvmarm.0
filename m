Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6881A8F6D;
	Tue, 20 May 2025 12:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745308; cv=none; b=dBS1PL6zABi6gH7SCvg3LFYHyv6JFvL4YYFsqMfnRvHNvh0Ems5bVLaGm0+4DHAQyLz41lTZT6A/k1rTIG6/p7+UVwYir0uxsXj6CLyTt3md8j6PoT039A0TO5shSnhsWwsCUIh6wTmT+H6V1gWvEdEookwEOWLnjdFQDKx27Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745308; c=relaxed/simple;
	bh=Q54ESb5TkHZjpeeUYH9Du5AoLX2a+t29iwcjsyIfM9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W1EVQNE6YPG9Uk7mriPsqP4BNYFD9bIAC56vbfG1CZytwKUNC2hEAkRHc+oboZT+hYDU2N1sh44+hkK3G7x/gN7CeZz6zrIQKsuG3zrBhv35K+IS9vvb0C6elpWt9zEGNBO3KZgi04omeO+N9zYpi1DWpfCM6JF78rX0t6pUytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 272E41516;
	Tue, 20 May 2025 05:48:13 -0700 (PDT)
Received: from [10.1.36.74] (Suzukis-MBP.cambridge.arm.com [10.1.36.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 21F103F5A1;
	Tue, 20 May 2025 05:48:22 -0700 (PDT)
Message-ID: <210c6f71-68da-4226-8a60-bbedb014628f@arm.com>
Date: Tue, 20 May 2025 13:48:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 35/43] arm64: RME: Set breakpoint parameters through
 SET_ONE_REG
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-36-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-36-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Allow userspace to configure the number of breakpoints and watchpoints
> of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.
> 
> The KVM sys_reg handler checks the user value against the maximum value
> given by RMM (arm64_check_features() gets it from the
> read_sanitised_id_aa64dfr0_el1() reset handler).
> 
> Userspace discovers that it can write these fields by issuing a
> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


