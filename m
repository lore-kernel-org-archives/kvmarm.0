Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392D81F941
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706783033; cv=none; b=SjZUg6p5mcX/Re65i+gc+iPg1Azk+peVSLZ42uI4NbHgcaSRJKAPAwBA1CmmzdWrrmel1nqqVgKHaiBqymkGS6hAQGBNiCDkojDVVDQfsl/QUTFiG/SG0qGx8/rHSEdroLQZhh8j9dVz3WhqlOssmw/0j9Um5xK4jpWyExJJtGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706783033; c=relaxed/simple;
	bh=l9xtZA6JyQO0ZHM7v7uq57ACeSAqeiH0RxnWACFvzGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LcQgNz0SXYvVNbItUwquo9enuzmqDfXqkdD+4YAh7z6825Y85fRUxaMr7gFqSButkWOyk4HdU423XzJkuRo53saW8KSGBbLwvzItkqXUiD2l3djMPFIzoIC96UuVtDfrnvxtLmiHPo2QtNyiLhdiKJGX4LfLVS2Bpvdg3X9xb2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 48D84DA7;
	Thu,  1 Feb 2024 02:24:33 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C7F73F738;
	Thu,  1 Feb 2024 02:23:47 -0800 (PST)
Message-ID: <a05a9c6a-af7a-4591-a6b7-69e15109aed2@arm.com>
Date: Thu, 1 Feb 2024 10:23:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] KVM: arm64: fix many kernel-doc warnings
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20240117230714.31025-1-rdunlap@infradead.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240117230714.31025-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/01/2024 23:07, Randy Dunlap wrote:
> Fix a bunch of kernel-doc warnings in arch/arm64/kvm/.
> 
>   [PATCH 01/10] KVM: arm64: debug: fix kernel-doc warnings
>   [PATCH 02/10] KVM: arm64: guest: fix kernel-doc warnings
>   [PATCH 03/10] KVM: arm64: hyp/aarch32: fix kernel-doc warnings
>   [PATCH 04/10] KVM: arm64: vhe: fix a kernel-doc warning
>   [PATCH 05/10] KVM: arm64: mmu: fix a kernel-doc warning
>   [PATCH 06/10] KVM: arm64: PMU: fix kernel-doc warnings
>   [PATCH 07/10] KVM: arm64: sys_regs: fix kernel-doc warnings
>   [PATCH 08/10] KVM: arm64: vgic-init: fix a kernel-doc warning
>   [PATCH 09/10] KVM: arm64: vgic-its: fix kernel-doc warnings
>   [PATCH 10/10] KVM: arm64: vgic: fix a kernel-doc warning
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

For the series:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

