Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020566;
	b=y71IfVom7jsMdJT+A28xFSdNR63+G3No4gMzctRRbK5QCE1GEXP0kWIAKCpnJpBR+EEq
	 7V27fZG75GBIvZywyTsv9GMtqpK42bfjghN14fqfKO4XKSXfBjHHW275AUkFYVYzJEn+d
	 E8NJk5iuVbeYn21G9UHPEHIy4TyEXqx9z5+Cu85oWt5GO/lNBtvfEXn8NsT7exT6+t0Lp
	 dqk5YbWk0rHpLXJM5Ap3G2iGDYEuiCpn5ZTtdor2WHwv/5yvt9/k6NwT+8FcpwelRmxAY
	 qs0sYsImdrr0aJHSJ/a7fVhTdlY87xBp66/uN7bxHSy7cm2JxGUcoyc2bqETXcEtfhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020566;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=We1LJjJy1kCPW5EPJlSwLuh9zShR5MvSm97HULZTIo4=;
	b=vov5+mjQOOaURHxGqawMWpQCrs9DKHdoIg8nbYpyG4odk7G+B3znpUGEnKOyrPM8Tu9Z
	 cIaldZeu8J5UZjI4Jh2PzLufZp9yYn2SgkdHjXMP3dX/xo81LcNHA0bWPDZHI2MlVfMQI
	 DqGM7fYBso8BwJC8sCW9rCgEZpkDGw+FcZ9yXon+AND7yxXaEQF6iBK/37TshYRUydDn5
	 0DbIYfn5GPIln8L14I2zDyPrPMCx0k6Nd2Gdu8VJBzW2ekVafcRPok+pnvyFoFoT/ZEwx
	 Cyoi0PJ508pwQ7lk7PjpR6V9x1qJ2lnalDZO8WITqrlNraJFQIyV0Jgx307Xo+zXonQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="UAM//OUL";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E011606A325;
	Wed, 18 Nov 2026 16:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E011606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UAM//OUL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5AFD143D;
	Wed, 18 Nov 2026 08:49:21 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 571CE3F673;
	Wed, 18 Nov 2026 08:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795020564; bh=5DF3UMuuIAB9eEb863SsQyI53Bmrii/ORFqImQUx9Ck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UAM//OULyFGAv7/1q3GJ435EUNjO1b4O1WG5u+nQr9NMdylc3Fx2uWKh14BhWsVMS
	 TBOFPuGu3IpQ2ztmBBQhLPAMHzdUK8EcCrJCKwYaZFxQATLKRAyFJG0WzAKC4qGTja
	 AegXQAErNCqkoGgBNl0v1dds8/wdY+g3Tusstjj0=
Message-ID: <9b42bb54-97aa-4b2f-94f8-0c887a7f82a2@arm.com>
Date: Wed, 18 Nov 2026 16:49:17 +0000
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
Subject: Re: [PATCH v3 08/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-9-steven.price@arm.com>
 <CA+EHjTzAo+5FhtxfX8mQ4t3k5BhatR15UKNSAQw+CRbxJ=wz7A@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTzAo+5FhtxfX8mQ4t3k5BhatR15UKNSAQw+CRbxJ=wz7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/11/2026 14:42, Fuad Tabba wrote:
> On Mon, 16 Nov 2026 16:43:54 +0000, Steven Price <steven.price@arm.com> wrote:
> [...]
>> Define kvm_arch_has_private_mem() so generic KVM recognizes Realm VMs
>> as supporting private memory.
> [...]
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> [...]
>> @@ -1611,6 +1611,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>>
>>  #define kvm_vm_hyp_is_distrusting(kvm)        ((kvm)->arch.vm_flavor >= __VM_DISTRUSTING_HYP)
>>
>> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
> 
> Could the message say that defining the macro makes
> gmem_in_place_conversion true for every arm64 VM? One visible change
> is that KVM_SET_MEMORY_ATTRIBUTES2 on a non-Realm VM's guest_memfd
> returns -EINVAL instead of -ENOTTY.

True - I'll explicitly mention that the commit message just in case
anyone bisects that in the future.

> [...]
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
>> @@ -2887,10 +2903,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>                  return 0;
>>
>>          /*
>> -         * Prevent userspace from creating a memory region outside of the IPA
>> -         * space addressable by the KVM guest IPA space.
>> +         * Realm shared IPAs alias the corresponding private IPAs, so memslots
>> +         * must reside entirely in the canonical lower half of the IPA space.
>>           */
>> -        if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
>> +        ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
>> +        if (kvm_vm_is_realm(kvm))
>> +                ipa_limit >>= 1;
>> +        if (new->base_gfn + new->npages > ipa_limit)
>>                  return -EFAULT;
> 
> This check still applies to every VM, so I'd keep the old comment and
> add the Realm sentence to it.

Ack.

Thanks,
Steve

