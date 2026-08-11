Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C07B335081;
	Tue, 11 Aug 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786459915; cv=none; b=s0X3IMB4B+ctoyC3OHHWH+3tm/QwKvDPZNJp42nzf2fcXsxYxJYwaZ5nva4RRgp3GM8FNjPGwAZa7X5HhcH8tvVNUYywm15Pwa/EycfV0N2O/BlEMKH3gwyH0rCvGLvKSpCf5cKeJWOrG+EyMJ+JPh49bqDM254EKPNVHxjuqC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786459915; c=relaxed/simple;
	bh=1s6ZQV6pRCW5kArfN9tYwqwxGiAeoOQtAZi2wQkdZBI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RyMK9SRTylaMblfiOYntVOeUQLPYfneVyzozEhu6TnxR/p6G4joajkj9FMwYO/yIXpn+RShX6al9z7uGXu9jCkY5JUQp/8LL658wTUn61fyBjtAc5Cqwim8KucTmxTDDoaJoJb0eVfCE3BvexfmmC/R5wIbz32YBd7Rq8+lMXAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=em6+r3Lb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="em6+r3Lb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 315191516;
	Tue, 11 Aug 2026 07:51:48 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F9A13F86F;
	Tue, 11 Aug 2026 07:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786459912; bh=1s6ZQV6pRCW5kArfN9tYwqwxGiAeoOQtAZi2wQkdZBI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=em6+r3LbzTlgSKSNZBdpoHPdVJ/A/9H7tz5lRjUTSTGDXsheQDI/PbhdSWSfCkKD4
	 OstIRRfmg21tnaS3Sd9Rpb6hUiI3Gno4xMF2mfxA8snZGNYJFPlVzaaCPFUqqiH3/K
	 kj180dHzcXOEDh3kD4ThESmDXLfT29tXMrD8+mEs=
Message-ID: <73a03e76-10b1-4e05-b9ea-a2f3b5dc6b3e@arm.com>
Date: Tue, 11 Aug 2026 15:51:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/45] KVM: arm64: CCA: Tear down RTTs
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Alper Gun <alpergun@google.com>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-18-steven.price@arm.com>
 <CABpDEun3NPr7Na85pmOvdfYQ1DB-2nCcocsyDESXM15bzJU1og@mail.gmail.com>
 <c1f0aad2-33cb-4dab-b54d-d09998fed36e@arm.com>
Content-Language: en-US
In-Reply-To: <c1f0aad2-33cb-4dab-b54d-d09998fed36e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 04/08/2026 13:16, Suzuki K Poulose wrote:
> Hi there
> 
> On 03/08/2026 23:29, Alper Gun wrote:
>> On Mon, Aug 3, 2026 at 6:45 AM Steven Price <steven.price@arm.com> wrote:
>>> [...]
>>> +static void realm_unmap_stage2(struct kvm *kvm)
>>> +{
>>> +       struct realm *realm = &kvm->arch.realm;
>>> +
>>> +       lockdep_assert_held(&kvm->arch.config_lock);
>>> +
>>> +       if (realm->stage2_unmapped)
>>> +               return;
>>> +
>>> +       write_lock(&kvm->mmu_lock);
>>> +       kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
>>> +                              BIT(realm->ia_bits - 1), true);
>>> +       write_unlock(&kvm->mmu_lock);
>>> +
>>> +       realm->stage2_unmapped = true;
>>> +}
>>> +
>>> +int kvm_realm_teardown_stage2(struct kvm *kvm)
>>> +{
>>> +       lockdep_assert_held(&kvm->arch.config_lock);
>>> +
>>> +       realm_unmap_stage2(kvm);
>>> +       return realm_destroy_rtts(kvm);
>>> +}
>>
>> Hi Steven,
>>
>> I noticed a warning in dmesg when destroying a realm:
>>
>>    [  158.533495] Call trace:
>>    [  158.535927]  kvm_destroy_realm+0x208/0x218
>>    [  158.540356]  kvm_arch_destroy_vm+0xc8/0xd8
>>    [  158.544439]  kvm_put_kvm+0x324/0x4b0
>>    [  158.548002]  kvm_vm_stats_release+0x1c/0x38
> 
> Thanks for the report and the detailed analysis.
> 
>>
>> I traced this and found the following:
>>
>> At this point, calling realm_destroy_rtts() may fail destroying the RTTs
>> because RECs are still active and the Realm is not terminated, but the

May be we should bail out early in the realm_map_ipa() based on the
state of the Realm (i.e. state != ACTIVE). But looking at this
I see that we serialize the state of the realm using the config_lock,
which is a bit odd.

>> walk finishes and still sets realm->rtts_destroyed = true.
>>
>> Later, kvm_destroy_realm() calls rmi_realm_terminate() and then calls
>> realm_destroy_rtts(kvm) again. But because realm->rtts_destroyed is 
>> already
>> set to true, it exits early without tearing down the RTTs.
>>
>> Consequently, rmi_realm_destroy() is invoked while the RTT tables still
>> exist in RMM, which fails and triggers WARN_ON(rmi_realm_destroy).
>>
>> The fix I used was to remove realm_destroy_rtts() from
>> kvm_realm_teardown_stage2():
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -434,7 +434,7 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>>    lockdep_assert_held(&kvm->arch.config_lock);
>>
>>    realm_unmap_stage2(kvm);
>> - return realm_destroy_rtts(kvm);
>> + return 0;
>>   }
>>
>> I think we don't need RTT destruction here as it will be handled 
>> cleanly in
>> kvm_destroy_realm() later.
> 
> That sounds sensible to me, I will take a look and fix it locally for 
> the next version.

On a second look, I think the rtts_destroyed flag may not be saving us
much. If the RTTs are destroyed, we should complete the second round
fairly easily.

Suzuki

> 
> 
> Thanks
> Suzuki
> 
>>
>> Thanks,
>> Alper
> 

