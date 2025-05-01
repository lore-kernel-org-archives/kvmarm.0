Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114A6125D6;
	Thu,  1 May 2025 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746118317; cv=none; b=uCDR3gQEL12sm78cgU1pD3vL06+CmwY2ni4JoLvVzkkguAWyUhx+04nSmARiRuLf4nCwiZpYYWsSSA0FDFAvi56nyLMBrmuJrCzN2zKOONrGJIZJKMEwCkC9D4y3H1jIfI/8gAzkKLNHGxu3n6Pl3qbZgj8p3k1qqlgBeJH+Lok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746118317; c=relaxed/simple;
	bh=q8ZdxI0NO5ktJC+bm4+pEhbU/iZA+Iu0Tamg0vfxKIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MPTfuRA0pOYhGHKTWM6fsncMVMobuvpxQfGIIp230FbU7jAIJz1uijNaA6adjObkK3jny1hlnVJfjjVf7w6rfnwr5+tlB3DprAk4tnAMFDlTgNKxyW9l3ZN2fR5yJVVSqn7VUX/MmANSZ+g4yj/C+XU2eJjXlEw+WrTeKoB51p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7428168F;
	Thu,  1 May 2025 09:51:47 -0700 (PDT)
Received: from [10.57.43.85] (unknown [10.57.43.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D0BD13F5A1;
	Thu,  1 May 2025 09:51:51 -0700 (PDT)
Message-ID: <0a13ff01-c5f4-40c1-93b4-60e58b0b4ae4@arm.com>
Date: Thu, 1 May 2025 17:51:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/43] KVM: arm64: vgic: Provide helper for number of
 list registers
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250416134208.383984-13-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-13-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> Currently the number of list registers available is stored in a global
> (kvm_vgic_global_state.nr_lr). With Arm CCA the RMM is permitted to
> reserve list registers for its own use and so the number of available
> list registers can be fewer for a realm VM. Provide a wrapper function
> to fetch the global in preparation for restricting nr_lr when dealing
> with a realm VM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


