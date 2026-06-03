Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3D53DA5CC;
	Wed,  3 Jun 2026 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780501725; cv=none; b=odAiXk8q0RbIc1ydlr5Dubg+B0/Dc7lZK5ySWA1Lzld4/hU02HkRrvdAqzBNeNoJR8UpmsZBi3aB52O+Q/UF0dNt4nMBCg4m7vAY0q9CefCsFGojj/+QkDT4FYa3OqzP5uX72iGlFYcidOgkA3FSvagW+yzN68rhHGu6OP1Ebvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780501725; c=relaxed/simple;
	bh=gqLBwuKK3OfG+2a0A3qyNuqqqbc1gbuZmlk165lnpZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D//aS2gHHZn9zzWAn7vB/0LO8zViYf87NjgJi/nRErEu90lQ7fkgyVBAFr2e6REyyTWO3YoLp8sObleNvKHFCy8iVpZTLal/Ow3QjYRtzjTvmsIHOE6c9C4FZJFkEhZ1ip6us5ktLRyXaxfM9Sg7Zk4jg74qRhssFcrxQcxCX4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c5DgxOOG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c5DgxOOG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F44E3431;
	Wed,  3 Jun 2026 08:48:37 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B08E3F86F;
	Wed,  3 Jun 2026 08:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780501722; bh=gqLBwuKK3OfG+2a0A3qyNuqqqbc1gbuZmlk165lnpZE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c5DgxOOGAWdq2gXOK1CYNaWj3q4PadaF75H23goD8ixRkIMBbCsBhc0KJafpfQ9cn
	 hopzMfQm07oFUh6GpVXOV+lqiTE9x8k82v4kO7pw7KgQoOIHnzl8N9YyTyF4GkwcYP
	 HoKCswJlnkRICQ8rbMEBj/DT69d2cDnsIRQCMU4k=
Message-ID: <346a2ab7-6399-4ed3-bd4b-a1f2bd127e0e@arm.com>
Date: Wed, 3 Jun 2026 16:48:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/44] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
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
 <20260513131757.116630-9-steven.price@arm.com> <yq5aa4twt03b.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5aa4twt03b.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/05/2026 06:55, Aneesh Kumar K.V wrote:
>> +
>> +bool rmi_is_available(void)
>> +{
>> +	return arm64_rmi_is_available;
>> +}
>> +
> 
> Can we rename to is_rmi_available(void) ?

Sure, will do.

Thanks,
Steve
