Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795440742;
	b=lyXnMrdjUlZzM1aDZdqcmYau/v44p/vK0vcZdyYHKAAg/cRgWIbhd4FzzXV9ia11GP6R
	 7yuWtIvY8L5OmOM/yGRR2C6l6IgrXt4kszf9srKOfI96IUPQCav/dbFGsxtAXFST4S12j
	 KHvuyW5TSONwFc7EOFL20Tx3zPiO+cCsv5g8yrIQUwR2XrNBZTEk7FS09HcgZlz3The7P
	 8NywiDd26WR6c0//nHOP4WUnhcjeaLpVn8DJC/uNo0xmHaHK724Pi/Ryg/nrE70EATEUr
	 Q/bdz1k9SGwXvgulfcqm9z+xRsZ1hSVn0AY49wz4X3dkfnW025paa4697M9NDwS3Lpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795440742;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0bvStAAxeZ8Gkfe5Tw5hh4wU3B/vHxdCM1DeCTbELao=;
	b=AJsEf78kL1UkNNvDiTRGgo8AqOc/McodKoQ1uc/n+eOHIBVMZe4p7btuiUQNiqlSa6tk
	 GmrN6dE4HhC/asSKMBaKMSdycIPzZwJLkpwFElF2Uny1fbLo2/GPdNdbkglupJaW5MHWE
	 hy1JmR216miR2wPqhc/eElhpZhQHsyFdfhBqy6jE40InO2mwK1IS2UAJBIpFYzCPj/zOl
	 JW3jtLHaPLHLkbcsVgmP0nXYqq4X3hPoXStoGNKpNTK+II8B3kcykrnVWB5pJZvARD5lD
	 P1pIUsSsWvaP2uKEEzy2T/YcDae9mho03hoyufdiYbDzOo8tomsNpZFygL9V/qZNK/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JhGBw1bG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC168606A31E;
	Mon, 23 Nov 2026 13:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC168606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JhGBw1bG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E63DA143D;
	Mon, 23 Nov 2026 05:32:17 -0800 (PST)
Received: from [10.0.129.12] (Suzukis-MBP.cambridge.arm.com [10.0.129.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 258BF3F86F;
	Mon, 23 Nov 2026 05:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795440740; bh=o6hmJo//5wX2bOXoad+z4zz40/4XRN6NpGXUmq6iWS0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JhGBw1bGfH7RhQ7jNe1Smx3D+gZlG+FUW1byFCfFuf6p6ojgIrqzytv1khguy8lQC
	 k9St/nUgNMFcrNzz+9t6s9WV5Y7fZKu9n6pUkwCGY26ICJ+aKcOSO6xgai0x/e2Whe
	 tzoWgRShMgYtuRSC29OBsisHnBm8nPoJPCy7Qoo0=
Message-ID: <d332948e-48ac-4f84-b620-d39d36992c55@arm.com>
Date: Mon, 23 Nov 2026 13:32:15 +0000
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
Subject: Re: [PATCH v4 07/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-8-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261123104233.95710-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/11/2026 10:42, Steven Price wrote:
> Add the RMI RTT creation and unmap helpers needed by CCA Realm stage-2
> memory operations. REC exit handling and guest requested RIPAS changes
> follow in the vCPU series.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> 
...



--8>--

>   static int realm_destroy_rtts(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
>   	unsigned int ia_bits = realm->ia_bits;
>   
>   	lockdep_assert_held(&kvm->arch.config_lock);
> +	if (WARN_ON_ONCE(!realm->stage2_unmapped))
> +		return -EINVAL;

minor nit: Does this hunk belong to the previous patch ?

Suzuki
