Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624942;
	b=3q0TSuc8Li/3vk5D/P30sdQrB4els300lCs0Ml2FUG8e6VNF6ILnz2O5bJPjnb6H4dJ1
	 7g5krvEj5JACLsmarz4/NKSytpfP69UWtJTc3jfpt5MBD9G1e4BKApTCErCn6jn6welKl
	 q+BIxNOm6lLaBHlkDkeA3o0pA1ZW6m5ocMJcYNI83qb7gTUqvbvuxilLhYiaLAUKnw1/W
	 3W5ieZPSbTwaBe8CRAtT55YUnBhussolSBNzPYnj2oNiaC67AVUFlVl2E9dEzOWpmhwPW
	 erkcAyihYoNq6+HIIXjWYG7Z1TO221+3NO8xQO0c6xvoDneMTY2sSe+8v/iO/CQQtfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624942;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ej3rFQntXuPoH8vhrYecOGevuw9dr5POrf+y7c/G9Zk=;
	b=YdVwLUzvDmTZKqVITcrXPVEUuKT+HqHFlhvu61DaIFr59qHwUXeId6Bx3vYDTgdcWkQJ
	 lo8MtoSinYdcgYsjFAj1zACsfVnh9YP3UX+sCdwKQL/U292laxQN0zqmjkO9FUIljo+/B
	 2iB2e+c14WKgdH8m9M4Nt5V3QnA9z4D8SMc2FVnUvXe177M+aQFvpto3Cb1LOJEClyCTT
	 6loBcC+4phvz98fbvMsBEUZS2uJ0TBzYLgqMQvb8y0lenLVYBzyaRYYIr75d66rQCp9T1
	 kWx+/mlNhtdINtj+JSBb4WwZ5Mv4/FQujcKJxXTj1+w5rkP2Djhxd00LiXxSZSULfGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WwFnfJ7L;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1E7606A31E;
	Wed, 25 Nov 2026 16:42:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D1E7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WwFnfJ7L
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD3932F;
	Wed, 25 Nov 2026 08:42:17 -0800 (PST)
Received: from [10.57.32.107] (unknown [10.57.32.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E83383F632;
	Wed, 25 Nov 2026 08:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795624940; bh=SKTswPHzr8rBc1/6nMKHnghgefBWUWYQqZrixcwzN+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WwFnfJ7LsvuDHGrf9RJkXT6gKAm+PjLazrGgVKRy0f6czqlXxnoMkJnwnFt+tRIdU
	 Sc+BhhxOwDww78oXiF9cRnBSgYVehtI/C4D7BB6pTilTS8zWmSNpemsDJvRn10VU0z
	 V4xvRQmhVmlwI+nuVNknZUvN4NC9mhAuyMoBfwGI=
Message-ID: <19432d85-2923-4037-98fa-cffb664dc342@arm.com>
Date: Wed, 25 Nov 2026 16:42:13 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-8-steven.price@arm.com>
 <d332948e-48ac-4f84-b620-d39d36992c55@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d332948e-48ac-4f84-b620-d39d36992c55@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/11/2026 13:32, Suzuki K Poulose wrote:
> On 23/11/2026 10:42, Steven Price wrote:
>> Add the RMI RTT creation and unmap helpers needed by CCA Realm stage-2
>> memory operations. REC exit handling and guest requested RIPAS changes
>> follow in the vCPU series.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
> ...
> 
> 
> 
> --8>--
> 
>>   static int realm_destroy_rtts(struct kvm *kvm)
>>   {
>>       struct realm *realm = &kvm->arch.realm;
>>       unsigned int ia_bits = realm->ia_bits;
>>         lockdep_assert_held(&kvm->arch.config_lock);
>> +    if (WARN_ON_ONCE(!realm->stage2_unmapped))
>> +        return -EINVAL;
> 
> minor nit: Does this hunk belong to the previous patch ?

Yes, sorry about that!

Thanks,
Steve
