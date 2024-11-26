Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83C21D618E
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 18:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732645737; cv=none; b=qjfQ5CapcS64Xa0L5JUp6tfdPz0sIhJ/IpL6quaq6yUUB7GF2pO2p+Si5I8kC/000ph+Ug3nN6s/BntPL1luVZMi+I5T0blvqyPUvLgZE2qZxuUaJrA5Iu6XvUOUsO5V7o1MsT8ZlqNC03zmsG6B6lz2p2YVzeOtsF10DLTmsIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732645737; c=relaxed/simple;
	bh=L87P+tJ0iUoGd5v6N+fkKpe6k/msnKG7rUK5kHVpMS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9l6aREiK+mxIS3QBUsdFz6a5MY0GkccyjmEhcdQouuKeHufqMZQEwZTAat5H98afkped230+9y2IEdIdcU9UzrCRzGau7bXO04d/DC7bX05NzCOcDoMjmYJV6Ii38LAzEG6MdwUgxply+WHp+mlBfZZ5pLwhkl5jIjOIQn5f74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E21C4175D;
	Tue, 26 Nov 2024 10:29:23 -0800 (PST)
Received: from [10.1.38.124] (e126864.cambridge.arm.com [10.1.38.124])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A1FB3F66E;
	Tue, 26 Nov 2024 10:28:51 -0800 (PST)
Message-ID: <100b6b71-22d4-4513-9f8f-849a11c0a809@arm.com>
Date: Tue, 26 Nov 2024 18:28:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] KVM: arm64: Rework specifying restricted
 features for protected VMs
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
 will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
 qperret@google.com
References: <20241122110622.3010118-1-tabba@google.com>
 <20241122110622.3010118-8-tabba@google.com>
Content-Language: en-US
From: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>
In-Reply-To: <20241122110622.3010118-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 22/11/2024 11:06, Fuad Tabba wrote:
> The existing code didn't properly distinguish between signed and
> unsigned features, and was difficult to read and to maintain.
> Rework it using the same method used in other parts of KVM when
> handling vcpu features.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---


> +static const struct pvm_feature pvmid_aa64isar2[] = {
> +	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, _vcpu_has_ptrauth),
> +	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, _vcpu_has_ptrauth),
> +	MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
> +	FEAT_END
> +};

Just wondering - did you intentionally hide the MOPS feature from protected
guests here? (It was exposed before)

I did notice that the HCRX trap setting is currently broken/missing in upstream
pKVM, which means MOPS instructions UNDEF in the guest. Is it related to that?

Thanks,
Kristina

