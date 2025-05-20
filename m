Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CE119DF4F;
	Tue, 20 May 2025 12:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745534; cv=none; b=g556JQ95TQvL7l9+zsbGXcSi+vEUDfwNbvsmg01HxlfN90EP277Dai3PmdnnW9a2+Vvw939gsWXl1vxa/khgem12OZc+aBjm52O0cD0eqkDntUwfVaP+IkC5IlbVxemOkiUEkeWnQ5QMQCKxBP4+IqE2WvX9RsftXH2GhBivPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745534; c=relaxed/simple;
	bh=cndGM1XkNtcIDNZXZKNsY1qesIcrcvdhU2CzwqJpH3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fsfo3PtmVVJ4iCIVzkudMcMB2RjSlq+ttLPuqTcB5ASBNppMffFcaTgZ+zxlshngC4x/IU6XjEqKjTWge842+ygJdWCW+IqO2QqBS05m3VQy86HIKpuXAZnX12ofy16DYnjKeLoAq04Ok6TcF9soFAL61u9yZvmssjtHyt+aeUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA8D81516;
	Tue, 20 May 2025 05:51:59 -0700 (PDT)
Received: from [10.1.36.74] (Suzukis-MBP.cambridge.arm.com [10.1.36.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BADF53F5A1;
	Tue, 20 May 2025 05:52:09 -0700 (PDT)
Message-ID: <4f1d5bd0-f06a-408a-9468-307a83d05b7d@arm.com>
Date: Tue, 20 May 2025 13:52:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 38/43] arm64: RME: Configure max SVE vector length for
 a Realm
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250416134208.383984-39-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-39-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:42, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Obtain the max vector length configured by userspace on the vCPUs, and
> write it into the Realm parameters. By default the vCPU is configured
> with the max vector length reported by RMM, and userspace can reduce it
> with a write to KVM_REG_ARM64_SVE_VLS.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

