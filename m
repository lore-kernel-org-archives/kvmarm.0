Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794224138;
	b=kzuw0wUe3tUo8P4oo5nYMPhGA71Xf7SDnK+2Ywyr6MjFdu/75H/cl3DufEtM6xUE/13U
	 AWz/hf4be8b/6n9vJopd0xE+TPgGsRFVT5cYrlzSVi2NTB4mWP1bRPTm/HBFZ4uKOHDIz
	 UtPlRGgF9flpaGkIapa6x3rBw86CNI7jMUdqYUGI9EVLgWBMCvURQoFwpz4oVt21iU3PJ
	 czF9n/GASEqMcckjeuZvcLzrUz7yOqh5f5PfdvUa+xsDTBSrFjBTX68ysS39MKHlifO+n
	 wKKKMwV2qiqleA16nUD1zi/Cn+M4e3JdCB4xOcXzDVgIMy71/JiP+u/gQp7s4QLntMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224138;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PYV844ivqJ39fhXbpbQJt7ThrmrdZ/Uef1Hl7B/7mic=;
	b=Av9F/6Ks7fULUfJD9ST9pWl7HlfidP/99ZzkRh7mAp5+GZ0LeMRSUm9IjFRskTJnarOm
	 dHVcBlTfPoa+NI9XZP/efCSMSE05hKyz+Q+QIYUjwyh576GCP/VGIc5PawbxDNW8ZTeFa
	 Wf6q9YL8cxchk5lYxyJlqltrFV7JLtp7vh476lTpEtQr2ba5qHcCdFN8/fMuZwOPAYQlf
	 Wfh/OUshkcFkOXtGXTgu2qjtIik8vPYlct//q+J1ACVt7iHo+8I+W1ci5jizdnqTnbpHU
	 bzicjd6x1DSaKcsaD0v4ED2gE02F8Qxlmt8LRrijXJbTQ30SvxORSHgYNqI/zPO8/Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Qzcy7j5c;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A60606A321;
	Mon,  9 Nov 2026 11:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41A60606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Qzcy7j5c
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37FB61516;
	Mon,  9 Nov 2026 03:35:33 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B59B93F85F;
	Mon,  9 Nov 2026 03:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794224136; bh=rTLHWsiv8pph/dAfc4DcKVgal8O6MwfZfU2M1D232cA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qzcy7j5c8+tbgnD1Z9hB0H2xfYVSag9SEoaDEDoibA7M1o5laQrfJaS2pa7i5zACm
	 0Wgo+QHOtul0e27z4on0wY4fO+kWBT/9IiUgRtGqRXOU8DsIHZh5o41QjjaZjx8WoB
	 tleUJKwVUK/luuLMar6jw5SH1NCbv5e66XgI8lXc=
Message-ID: <06e52c9c-9026-4279-b8c0-53a54a667dad@arm.com>
Date: Mon, 9 Nov 2026 11:35:31 +0000
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
To: Fuad Tabba <tabba@google.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev,
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
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CA+EHjTy970AWnhYoZ5OqxQ8ojCAELeejw60y2NmpDsM_ZMdu4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad

Thanks for sharing the pVM gmem details, some more questions below.

On 09/11/2026 07:40, Fuad Tabba wrote:
> Hi Suzuki, Steve,
> 
> On Thu, 05 Nov 2026 17:30:16 +0000, Suzuki K Poulose
> <suzuki.poulose@arm.com> wrote:
> [...]
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> [...]
>>> @@ -1816,13 +1828,28 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>>          /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>>          smp_rmb();
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

When you say, per-page, you mean per-IPA or per "backing page" ? i.e.,
can pKVM do something like :

    kvm_ipa_is_private(kvm, ipa) ?

(similar to Realm) or does it need the struct page backing the "ipa" ?

> 
> Steve, could you gate the guest_memfd checks on
> kvm_arch_has_private_mem(kvm) rather than kvm_vm_is_realm(), this one
> and the memslot check you proposed for 02/11? Only the
> kvm_realm_is_private_address() and realm_map_ipa() calls are
> realm-specific, and they could be VM_REALM cases of a switch on
> vm_flavor, as Marc asked for on the v21 memslot check [2]. The macro
> would then only widen to protected VMs when pKVM's guest_memfd support

Makes sense.

Suzuki

> lands.
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/CA+EHjTz+WgXEW5RTxXf4oGeEb1Tsm5Ha4nOc4S1jBcp7jxP4+A@mail.gmail.com/
> [2] https://lore.kernel.org/all/86mrsw2jrn.wl-maz@kernel.org/

