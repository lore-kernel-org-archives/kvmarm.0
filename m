Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71EE33A6F1;
	Tue,  4 Aug 2026 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785845771; cv=none; b=s2rGgFVqXo7a9ixXNaAA7FcXRUeOBgOvlf4fDcWzVQ5eL6yQlJ09kr7z8/y06M26u6GCCHV1tvWPhNj0uMltKouvYrORsgBMJI3yUsMU3kEZdkOFjM4Pf+sIgKxbSHMtdl3nVZ+leMiV8aXinjXy1P3LLvgUkAU3MzNdHbU/0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785845771; c=relaxed/simple;
	bh=bcAMhZTiy49tEojqvYK5r5G3B51T0weL1dSTwGIlZwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJy26C3b+4UgPc6jjXDDnmrfkr68TPsLqotrRBiS9LxuoDXy5Owc0SSLcxD+XnhYoYg3kV/68bMCXqgEVIp7FlSE6Zcbv42BPxR4LxKLs8QwfBw+4rZpuFLrUfsbhAj+ajtk6S7gGC9T6/caCQND7EX8rurg8d76hoswfzqWd2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c6UEwA1t; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c6UEwA1t"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF8851476;
	Tue,  4 Aug 2026 05:16:03 -0700 (PDT)
Received: from [10.57.44.180] (unknown [10.57.44.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E55483F66F;
	Tue,  4 Aug 2026 05:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785845768; bh=bcAMhZTiy49tEojqvYK5r5G3B51T0weL1dSTwGIlZwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c6UEwA1tfFd2CmIo6fSWGXXuYEzA2q181oOLDQYEGFGK+6ReJcnh1HF8CmR55UEwS
	 4KYLjtJBdGc+eGUnk52Cn0Ek0phGnFAEbNgF42/95p8y/PHexLLabxa6ezN6urQQx8
	 oo4Cl+2TiqW9TB+qhDx/Li/qJmx1beTxD+VNJIHc=
Message-ID: <c1f0aad2-33cb-4dab-b54d-d09998fed36e@arm.com>
Date: Tue, 4 Aug 2026 13:16:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/45] KVM: arm64: CCA: Tear down RTTs
Content-Language: en-GB
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CABpDEun3NPr7Na85pmOvdfYQ1DB-2nCcocsyDESXM15bzJU1og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi there

On 03/08/2026 23:29, Alper Gun wrote:
> On Mon, Aug 3, 2026 at 6:45 AM Steven Price <steven.price@arm.com> wrote:
>> [...]
>> +static void realm_unmap_stage2(struct kvm *kvm)
>> +{
>> +       struct realm *realm = &kvm->arch.realm;
>> +
>> +       lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +       if (realm->stage2_unmapped)
>> +               return;
>> +
>> +       write_lock(&kvm->mmu_lock);
>> +       kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
>> +                              BIT(realm->ia_bits - 1), true);
>> +       write_unlock(&kvm->mmu_lock);
>> +
>> +       realm->stage2_unmapped = true;
>> +}
>> +
>> +int kvm_realm_teardown_stage2(struct kvm *kvm)
>> +{
>> +       lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +       realm_unmap_stage2(kvm);
>> +       return realm_destroy_rtts(kvm);
>> +}
> 
> Hi Steven,
> 
> I noticed a warning in dmesg when destroying a realm:
> 
>    [  158.533495] Call trace:
>    [  158.535927]  kvm_destroy_realm+0x208/0x218
>    [  158.540356]  kvm_arch_destroy_vm+0xc8/0xd8
>    [  158.544439]  kvm_put_kvm+0x324/0x4b0
>    [  158.548002]  kvm_vm_stats_release+0x1c/0x38

Thanks for the report and the detailed analysis.

> 
> I traced this and found the following:
> 
> At this point, calling realm_destroy_rtts() may fail destroying the RTTs
> because RECs are still active and the Realm is not terminated, but the
> walk finishes and still sets realm->rtts_destroyed = true.
> 
> Later, kvm_destroy_realm() calls rmi_realm_terminate() and then calls
> realm_destroy_rtts(kvm) again. But because realm->rtts_destroyed is already
> set to true, it exits early without tearing down the RTTs.
> 
> Consequently, rmi_realm_destroy() is invoked while the RTT tables still
> exist in RMM, which fails and triggers WARN_ON(rmi_realm_destroy).
> 
> The fix I used was to remove realm_destroy_rtts() from
> kvm_realm_teardown_stage2():
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -434,7 +434,7 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>    lockdep_assert_held(&kvm->arch.config_lock);
> 
>    realm_unmap_stage2(kvm);
> - return realm_destroy_rtts(kvm);
> + return 0;
>   }
> 
> I think we don't need RTT destruction here as it will be handled cleanly in
> kvm_destroy_realm() later.

That sounds sensible to me, I will take a look and fix it locally for 
the next version.


Thanks
Suzuki

> 
> Thanks,
> Alper

