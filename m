Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020260;
	b=BTQd77fJhQaVK8iBFbOoEw2NxX9M/uQ9GcQQ6XhEVutcAYUiDbt+61KWVp3dXjaIInsq
	 euuJoxLEdNyjYh/MS9cu5XWEfzLsn9zkxIJd7RUQja9SSOB42ct4+KT62/x+8qSLLRuEe
	 ktxLnc+VyEmtfPtyJwUQT252kLniTMkBQWdnKEZ6SnoWisWfFeafiKxZqtZajSX+T/Ae9
	 TrlRgqHk/1iUwPfY7oONbCcA+FtUQD83/3q7AMcHmOTV8ScixXJm8bQI8nY4T0UMWlWEl
	 Rb3fXr0k8Y7wW1xebrUECAjer5I1v1qldImsUVMRf9hKA/NacnBNPXbheVRGHZu52Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020260;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=e3zPJLk1ySjBurHoSI4OkViSnLgnltmuyr0c6QjYQ7c=;
	b=fYX1w07bMKczFfFSUU1CHW5jpsPNUxvmwBni1TRP8gvPm+iJNKV4LEjCjyBHQ1Oy2AtX
	 qqS7yYav8cHASUZ+P+stQHB+84DWPsO/ItWGxFsKpzn0P3XCjztApyzdz3pQKUDCjZCPf
	 UcqgPPuc5GvOduw15bwmUZvUuOcaG2vDPLz3M/slWyFQoWJbM/rgwvMxpnPPtP/wBJyih
	 zmzXsPBrrfoIi1v0PEbYGxKlpRjYyQrs/9SLl1a1RqnNcynEBTz+1w6QAJhEQ4AdFLt5t
	 MIIc1MZrwPRVPVOiH//+1kQ9JImCHjVEpO469Mx7Or6KvhpAHXf8IRYza3DHQ79OcMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LsE0t9C+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49C3606A333;
	Wed, 18 Nov 2026 16:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E49C3606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LsE0t9C+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CA9A143D;
	Wed, 18 Nov 2026 08:44:16 -0800 (PST)
Received: from [10.57.62.206] (unknown [10.57.62.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BCD93F673;
	Wed, 18 Nov 2026 08:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795020259; bh=M48qF4mwQ+N0oE4m3XylKiVT0MRA7C7bZCPmGFy5x4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LsE0t9C+ZgenEg2QddEfwdg5DGwi2dsfyO2JM9Q8d2HoHmUh/I//rbIFgVIvFVdw8
	 fTddz0NQOIZiIblOpZSsiIPI6DndtLdeWzM20S9urm05p/Mg1Hua+aVUhDWOs8CbSl
	 HlnkbZcOQ8GoKY4ub4fvi7ayLjgnmnwkTNfr81VY=
Message-ID: <ac61e062-6d33-4166-8ecc-a9648bbffc5b@arm.com>
Date: Wed, 18 Nov 2026 16:44:11 +0000
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
Subject: Re: [PATCH v3 07/11] KVM: Allow architectures to reject memslot
 changes before invalidation
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
 <20261116164358.142785-8-steven.price@arm.com>
 <CA+EHjTwqYUBvhjF8dxqVA1mF_Qe1r2UZdwkZ+Zirgmm2um=skg@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <CA+EHjTwqYUBvhjF8dxqVA1mF_Qe1r2UZdwkZ+Zirgmm2um=skg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/11/2026 14:31, Fuad Tabba wrote:
> Hi Suzuki,
> 
> On Mon, 16 Nov 2026 16:43:53 +0000, Steven Price <steven.price@arm.com> wrote:
> [...]
>> Architectures may need to reject deletion of a memory slot without
>> changing the guest's memory mappings. Currently, KVM invalidates the slot
>> and calls kvm_arch_flush_shadow_memslot() before
>> kvm_arch_prepare_memory_region() can reject the request. On arm64, this
>> unmaps the slot from stage-2. Restoring the old memslot on failure does not
>> restore those mappings, so even a rejected deletion has side effects.
> [...]
>> Move arm64's protected VM checks into the new hook so that unsupported
>> deletions and moves are rejected before stage-2 unmapping. Keep resource
>> preparation after invalidation, since invalidation drops slots_arch_lock
>> and allows concurrent updates to architecture-specific memslot metadata.
> 
> For pVMs the invalidation doesn't touch stage-2
> (protected_pkvm_vm_s2_ops uses no_stage2_unmap_range()), so the reason
> for the hook is the Realm case in the next patch. Can you change the
> message to say that?

Yes I'll clarify that.

Thanks,
Steve

