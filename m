Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E6B78F29;
	Fri, 10 Apr 2026 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833957; cv=none; b=azI053NM7YAhAlVMvtsNPFye4YznsAPmYMrhe7nWUnacL++R76dtmT9v0qDdcqsJZ0ruZx/dYJ6oLtXaxnAQD2k2ESbXMyDr+yZeHX+TR14rGIsmv056F+w03zRtvBuNPnqzOAF45flGUX2pTPPRS2gOWnkDhYxkVF+jJmGkIzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833957; c=relaxed/simple;
	bh=tUJIj0Hyp53sZYA/2hZAp5bB68EFisIzjC9uDA35L50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QTKLRGrr4HQq16CDhWBQAw7/MdLrOOd5E5UqmiJ662ok7EvSiqmn1mEWg/LS01j4dUHEty1ouWQ9Qg+/ubYIF7EpESJw/l9j9248VfIYzwaz+zvhuYrnNvq/QTLNb1JBqZD2cumKVB0KDmdd3Pq8S6O+d7o5r763udbWEkfhy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FpNkfiJk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FpNkfiJk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F5564765;
	Fri, 10 Apr 2026 08:12:29 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 384E23FAA1;
	Fri, 10 Apr 2026 08:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833955; bh=tUJIj0Hyp53sZYA/2hZAp5bB68EFisIzjC9uDA35L50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FpNkfiJkuQ26Zy//0xfa9SbJWVQySMYuazfVL+O2kgLpv4D91gcjwg3jB1uvs7Tag
	 z7b6MNriYmZoeNZ0OzblQzcZ2dUry4sFGWIWLeAd8BoxXGRVdm8OB7UWlunFaHJcXJ
	 ZMb61s+59TcJ1gR1Yu5YpeiO9+Ua/aMPitZyDSOE=
Message-ID: <7481c2ec-7fea-4606-adc4-4e09b82fc10e@arm.com>
Date: Fri, 10 Apr 2026 16:12:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 46/48] KVM: arm64: Expose KVM_ARM_VCPU_REC to user
 space
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
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-47-steven.price@arm.com>
 <79564d59-032e-40c9-b4eb-f79f805b8238@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <79564d59-032e-40c9-b4eb-f79f805b8238@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/03/2026 17:36, Suzuki K Poulose wrote:
> On 18/03/2026 15:54, Steven Price wrote:
>> Increment KVM_VCPU_MAX_FEATURES to expose the new capability to user
>> space.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> Not needed any more as we don't need the VCPU feature.

This patch caused so much bother with rebasing in the past, I'd
completely forgotten it isn't actually needed! Thanks for spotting!

Thanks,
Steve

> Cheers
> Suzuki
> 
> 
> 
>> ---
>> Changes since v8:
>>   * Since NV is now merged and enabled, this no longer conflicts with it.
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/
>> asm/kvm_host.h
>> index 1d5fb001408c..b02f97de4436 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -40,7 +40,7 @@
>>     #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>   -#define KVM_VCPU_MAX_FEATURES 9
>> +#define KVM_VCPU_MAX_FEATURES 10
>>   #define KVM_VCPU_VALID_FEATURES    (BIT(KVM_VCPU_MAX_FEATURES) - 1)
>>     #define KVM_REQ_SLEEP \
> 

