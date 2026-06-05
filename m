Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601DC406285;
	Fri,  5 Jun 2026 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780671767; cv=none; b=YlZoumHfk7JZx4JySAvR5VG8KxfpRUavrsJsYj1Gk4GLxJzK/uWHpKlDgPJngMCxxm9JWx7tPqDqSjxyKxvmBBXJozconH4N01PbK6JidP1K14BJPHyp7UmI2aCEoq+4qgpG0sRjrDHmZVnnHD3+EJDFWzSlOtXr1YanmcvnnHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780671767; c=relaxed/simple;
	bh=mQFuhzCodCnbKJAkWMqNA1+nCgRbGyCC+kn20N2486I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TNHLPgB7okXaZt8G7dIUvocefCZh7BBKkuz64A8qL6pkrkHWDZYxSwExdOq86jKUW8DGAM91KBincJibYmqchSZfi8TLPQFPdauyHoq00Pkln1cuha+t+7UB4m78ZiIb9eexuWOYEnifN/8dPYqjUKDrcjOpe97RrZkclTg6w70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OvWTy3Fe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OvWTy3Fe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC0D2169C;
	Fri,  5 Jun 2026 08:02:40 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B1DC3F7D8;
	Fri,  5 Jun 2026 08:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780671765; bh=mQFuhzCodCnbKJAkWMqNA1+nCgRbGyCC+kn20N2486I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OvWTy3FeM5VwgjocrtZQg5Jg2KwnIeQPMOlAF5KB/6umOkBHoV8atthWthwLV+aOk
	 KzZiAaFiBYCOb6Fvk9P1hXIDBpEZ4A4zj/KVPtpJCV6PgnEAokBrDAwkfxyHMpNqyf
	 uAORbqalVv9zH7QohKxQN6w5M+KEi/it2AwcCoN4=
Message-ID: <e99800dd-6568-44bd-922b-c06891a528c8@arm.com>
Date: Fri, 5 Jun 2026 16:02:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 23/44] arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-24-steven.price@arm.com> <yq5ay0hfspok.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5ay0hfspok.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/05/2026 10:40, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
> ...
> 
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> +			   unsigned long size, bool unmap_private,
>> +			   bool may_block)
>> +{
>> +	unsigned long end = start + size;
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	if (!kvm_realm_is_created(kvm))
>> +		return;
>> +
>> +	end = min(BIT(realm->ia_bits - 1), end);
>> +
>> +	realm_unmap_shared_range(kvm, start, end, may_block);
>> +	if (unmap_private)
>> +		realm_unmap_private_range(kvm, start, end, may_block);
>> +}
>> +
>  
> kvm_gmem_invalidate_begin() indicates a private-only invalidation. How
> is that supported?

Because we treat the private and shared spaces are aliasing we don't
really support a "private-only" invalidation. So the shared space will
be invalidated as well. Something has gone wrong if we've ended up with
the 'same' IPA being used in both the private and shared spaces.

Private has to be treated slightly specially because removing a private
mapping is observable by the guest (the page can't be reinserted without
the guest agreeing and the contents being wiped). For shared mappings
the page can simply be refaulted.

That said, I'll look into Wei-Lin's suggestion to use
kvm_gfn_range_filter which would allow all three combinations of
private-only, shared-only and private+shared.

Thanks,
Steve

