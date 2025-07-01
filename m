Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD3D2367B1;
	Tue,  1 Jul 2025 10:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751365000; cv=none; b=rIJ4hIJMhe3pcD8DWy/XPCoq953CoEahQXGfOM/wGqnACt+cO9O23mBUqO/KFY73Q6AhLBC4z0s8s7nEzALQKxShjJm2PUWUiBTX7cUnPbeRujRhfhwXm/HKFL807waNgHknmMPt605EM+dBZsJ45QNnfCiy0gbQMvHy2mlKVfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751365000; c=relaxed/simple;
	bh=wJ97PMZks1E68SWWxGLuV3ozwQ2QPNeGcHgxfiOSy6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T3MgFvIs48DLKdlwjQvhkqR/iQiQHnREmEYuKme33VO7q1TYjYKfEqgN1vDcev2A+I/w9uHv4TiElvi807fHTNmFVvJk+7vF/rZmH+cNP3trLL5xMeqGLa1LgsYruLtlQy3qGms+h6v4tfYcKXC7euG+xo0l69YesNtbFTPF/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C27FC1595;
	Tue,  1 Jul 2025 03:16:21 -0700 (PDT)
Received: from [10.57.84.92] (unknown [10.57.84.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 183133F58B;
	Tue,  1 Jul 2025 03:16:32 -0700 (PDT)
Message-ID: <8f59f1a5-64e7-4444-a8b6-d399e2822829@arm.com>
Date: Tue, 1 Jul 2025 11:16:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 12/43] KVM: arm64: vgic: Provide helper for number of
 list registers
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-13-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250611104844.245235-13-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/06/2025 11:48, Steven Price wrote:
> Currently the number of list registers available is stored in a global
> (kvm_vgic_global_state.nr_lr). With Arm CCA the RMM is permitted to
> reserve list registers for its own use and so the number of available
> list registers can be fewer for a realm VM. Provide a wrapper function
> to fetch the global in preparation for restricting nr_lr when dealing
> with a realm VM.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com

