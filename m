Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB295283C9F;
	Mon, 19 May 2025 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747678280; cv=none; b=KMFkCSlWuJC4rgJlvfC3kb/IYksqg9eotHFlpx44i4Dt1GNXwSDMLDmpAoYHBLwjbL9v1Ye6qaeKp123SHXGzGDnrZHqI0TkelBTloIVEKvO5nAB4Xq57emr/jmYIOIu2ZNHlWEEW67HZp5CCNyr19w2LbdZ2cQ7lTlwfd0bayk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747678280; c=relaxed/simple;
	bh=QWLv/sNrajXnw7weVtqS83ydRKmVbNikmGQnAG98wso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SYkf5LAWlsiWioPc9jWa6EqSzOdsgznV9Pqi+tgUCDGndOHPfq2iFFXo6FL4tSzjHPwqa088jY5d3n2lMZulP0sxMDgfuBVk0PYLy+KiAbOrnWSO9dNDW/rmzufiOdxhDXtIkUwXcHcr/zr3DUaOzYf9Pg50/sG8jghLlOCNlnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0352715A1;
	Mon, 19 May 2025 11:11:05 -0700 (PDT)
Received: from [10.57.50.157] (unknown [10.57.50.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E9DF73F5A1;
	Mon, 19 May 2025 11:11:13 -0700 (PDT)
Message-ID: <10a4d7be-b5a2-4ca8-8457-d4149c6a265c@arm.com>
Date: Mon, 19 May 2025 19:11:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/43] KVM: arm64: Handle realm MMIO emulation
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-19-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-19-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> MMIO emulation for a realm cannot be done directly with the VM's
> registers as they are protected from the host. However, for emulatable
> data aborts, the RMM uses GPRS[0] to provide the read/written value.
> We can transfer this from/to the equivalent VCPU's register entry and
> then depend on the generic MMIO handling code in KVM.
> 
> For a MMIO read, the value is placed in the shared RecExit structure
> during kvm_handle_mmio_return() rather than in the VCPU's register
> entry.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


