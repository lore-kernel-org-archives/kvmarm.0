Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794231438;
	b=M13vXJeL/cx/i1azwaw1TF8PS8LOoqcDeWTPcw6JA1v0A2bVqYbzga95rq66f1CrxxTI
	 XVv1ZFlWNqpGJyCkBGLTMLtWAs+SpUgdKNcEkRymauumO00m1BZf57e0c7NiIwCNdseKV
	 HmPGlT9Klhto6nkl9wdG5wiuvNA20WvaMmCh/iOO9D7hF59/U+QbCcA+tYOf5yXeBN3zy
	 NGFHrvxRnf6p5PeP486jqsyNeuTxOEpiFwEITTV/ugqaeh4NoQ+x+q/cYorHsYr/tNRxC
	 KnwP8WeEhSkXZpDMFE8hD9+vYBaEZUVk6ke+6r16uFKTAg4UV3Nd3Vqk4w9605rc9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794231438;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=XLjVVqRd3p8pCryT/VdTNuVykrHMu0nh/BoWx9VVYBY=;
	b=rZsRmBV3r2XYrfEqraZajrROOVP98YOHcLRtxISFANbu8aIh5fuyVm6H+rI5HJbjbjD2
	 v+YJxyK6T/tS0emhplfeoIVVmxKexZvejYNY5QNn2cgEB5chvmkyWWqFFL7ffZHhiPAX0
	 zAXpvuRz2SysnRNgmkqF6UGUvmcnwCktG4jkqQyLbXo/uexe7RKwygbKzFrj0tR4s+N8J
	 M+thSx+DSkkS/FEh4+cM4y28fWA14GqyxL+4/WA8uiUyqvFdbH4ZNVgzZ4FyEmZQkTRHp
	 PeBX5gzfyiCgRQQKUqdFP2IpKjVNDIVAZhUbs9or3o3wsdZ6++sr3lKKzYQ+AaVHA+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hqlHWuAO;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C37606A335;
	Mon,  9 Nov 2026 13:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84C37606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hqlHWuAO
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACB4014BF;
	Mon,  9 Nov 2026 05:37:12 -0800 (PST)
Received: from [10.57.60.25] (unknown [10.57.60.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD2543F632;
	Mon,  9 Nov 2026 05:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794231435; bh=NnQ/lEoIzA5Usu4Fnnce/QHJMYYmA9ABd8vXbiATAAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hqlHWuAOhP2c6MKtExUEUsXcpTvjTSy/wmSieETuzLi3Tp9gaYEk34F5HIiSJJGGO
	 hjEnQpAD91vJGTYBOKKPDeTPncDQybIkK8mynI3UZeNxt32odugTQYOrDZ/eg9ywOu
	 gIBIPBiML6bNn8UnkUiygB6P8gIDKVKxRVz4+FTc=
Message-ID: <473e0c95-e027-44dc-a355-eed26d8a3926@arm.com>
Date: Mon, 9 Nov 2026 13:37:03 +0000
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
Subject: Re: [PATCH 10/11] KVM: arm64: CCA: Support runtime faulting of memory
To: Fuad Tabba <tabba@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-11-steven.price@arm.com>
 <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com>
 <CA+EHjTy970AWnhYoZ5OqxQ8ojCAELeejw60y2NmpDsM_ZMdu4Q@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTy970AWnhYoZ5OqxQ8ojCAELeejw60y2NmpDsM_ZMdu4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/11/2026 07:40, Fuad Tabba wrote:
> Hi Suzuki, Steve,

Hi Fuad,

> On Thu, 05 Nov 2026 17:30:16 +0000, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
>>> @@ -1816,13 +1828,28 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>>         /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>>         smp_rmb();
>>>
>>> +        if (kvm_vm_is_realm(kvm)) {
>>> +                is_realm_private = kvm_realm_is_private_address(&kvm->arch.realm,
>>> +                                                                s2fd->fault_ipa);
>>> +
>>> +                if (is_realm_private != kvm_gmem_is_private_gfn(kvm, canonical_gfn)) {
> [...]
>> I am wondering there is a way to make it a bit more generic. The issue
>> is, only Realm has private memory with guest_memfd for now. Don't know
>> the pKVM plans for it.
> 
> The plan is for protected pKVM VMs to be backed by guest_memfd too,
> which would also hold each page's private/shared state [1]. So
> kvm_arch_has_private_mem() will be true for them, and this comparison
> applies as is. Only how the expected state is computed differs: for a
> pVM it comes from the per-page share state rather than an IPA bit.
> 
> Steve, could you gate the guest_memfd checks on
> kvm_arch_has_private_mem(kvm) rather than kvm_vm_is_realm(), this one
> and the memslot check you proposed for 02/11? Only the
> kvm_realm_is_private_address() and realm_map_ipa() calls are
> realm-specific, and they could be VM_REALM cases of a switch on
> vm_flavor, as Marc asked for on the v21 memslot check [2]. The macro
> would then only widen to protected VMs when pKVM's guest_memfd support
> lands.

Sure I can include that in v2.

Thanks,
Steve

> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/CA+EHjTz+WgXEW5RTxXf4oGeEb1Tsm5Ha4nOc4S1jBcp7jxP4+A@mail.gmail.com/
> [2] https://lore.kernel.org/all/86mrsw2jrn.wl-maz@kernel.org/

