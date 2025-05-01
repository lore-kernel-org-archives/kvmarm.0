Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568912B9BF;
	Thu,  1 May 2025 15:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112292; cv=none; b=ITFY+1H8BiCaDQT6ovq5dncoyovg8NSNS4hXWuW+MZdEB7B8vnz5VQzT1+c7bLSQZDssbCSQ8cO6KnR9xlzGCnMg9Epl/SKfvkgsQAo149lWhvBsLevl91DwGcQQ9TkPjVGPGqYAA14IfFId6wDOImejKzSNNDIW72RBh5aW7Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112292; c=relaxed/simple;
	bh=YS1ws/oR65iSm0f1cRnI9+7FfzgIluKVHFfkJQnRbwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rg3VbcQU3HOzMNKJmP/GXyZC0DII/ry2KGfMjX0lHcTbWqQGYNOxFX1OTO75szj4y+vMqp/KaQlaKtO8IQw+7oXvxol9SzyJhTQFmSJ/vkRmLi+uDHlbsRj8D2yjWIPCdugt6kXg3XmkB0eVMkelPDi6d+ofBEOH8fHH1d8eSAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02E27168F;
	Thu,  1 May 2025 08:11:23 -0700 (PDT)
Received: from [10.1.33.27] (e122027.cambridge.arm.com [10.1.33.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E55573F5A1;
	Thu,  1 May 2025 08:11:26 -0700 (PDT)
Message-ID: <9e5c26e9-a710-4ae6-ab2e-5706204d4f4f@arm.com>
Date: Thu, 1 May 2025 16:11:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/43] arm64: RME: ioctls to create and configure
 realms
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-8-steven.price@arm.com>
 <1802ffb9-798a-4c48-8420-c046f86c548c@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <1802ffb9-798a-4c48-8420-c046f86c548c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/04/2025 06:39, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
[...]
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 67cf2d94cb2d..dbb6521fe380 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
[...]
>> +
>> +static int kvm_create_realm(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    int ret;
>> +
>> +    if (!kvm_is_realm(kvm))
>> +        return -EINVAL;
> 
> This check is duplicate because the only caller kvm_realm_enable_cap()
> already
> has the check. So it can be dropped.

Ah, good spot - thanks!

Steve

