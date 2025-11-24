Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D761D555
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 10:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763980762; cv=none; b=kAU+EeVwoYDeAV3kMyb/hHBv19UGMteBP96qcJTT9QRfKFbkl5sp2QxhTvY/k/PZsmFbTZ4snDfAQGV4ySk272jy+WsJqkM9a1tcH4LlBzM57m7zx+bJPUZU5hyHs4MIczOAQ+1pndOCGdlAEQAA6s6x+rfco9fiBicXGHLx9uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763980762; c=relaxed/simple;
	bh=sKzSYKgfcLzAIYddODcCTT28lZBov8xUXigByO0kSKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tfwXqNugZFhRtOT4fkHMLAT7FIMpUQMbTwg/Jxi2ROK2uDaTzksr5PpywsSQICSOqH0sV92OGLOWgrKBIgJr4nPDpVRcE9l434r3uZRjEgJ5utq7PI5e4epavlz5Y+ZnKJMqKzz7wADkmdEcaikVw/5XpAp6YdQ9+apLWWMqObk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 923C0497;
	Mon, 24 Nov 2025 02:39:11 -0800 (PST)
Received: from [10.1.39.148] (e121487-lin.cambridge.arm.com [10.1.39.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6B8C3F6A8;
	Mon, 24 Nov 2025 02:39:15 -0800 (PST)
Message-ID: <ff581325-199a-4bcb-bf5b-43a6f5ec64be@arm.com>
Date: Mon, 24 Nov 2025 10:38:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] KVM: arm64: Add pre_fault_memory implementation
To: Jack Thomson <jackabt.amazon@gmail.com>, maz@kernel.org,
 oliver.upton@linux.dev, pbonzini@redhat.com
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 isaku.yamahata@intel.com, xmarcalx@amazon.co.uk, kalyazin@amazon.co.uk,
 jackabt@amazon.com
References: <20251119154910.97716-1-jackabt.amazon@gmail.com>
 <20251119154910.97716-2-jackabt.amazon@gmail.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20251119154910.97716-2-jackabt.amazon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jack,

On 11/19/25 15:49, Jack Thomson wrote:
> From: Jack Thomson <jackabt@amazon.com>
> 
> Add kvm_arch_vcpu_pre_fault_memory() for arm64. The implementation hands
> off the stage-2 faulting logic to either gmem_abort() or
> user_mem_abort().
> 
> Add an optional page_size output parameter to user_mem_abort() to
> return the VMA page size, which is needed when pre-faulting.
> 
> Update the documentation to clarify x86 specific behaviour.
> 
> Signed-off-by: Jack Thomson <jackabt@amazon.com>

It works quite well for a few cases I have, so FWIW

Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>

Cheers
Vladimir
