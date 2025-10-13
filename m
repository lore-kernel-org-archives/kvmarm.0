Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB95826E706
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 12:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760358034; cv=none; b=oUz2Mjku7t3VAYM5XSWupK8aRU/9TEq8arPjuTNzMFR14fYSDZpy1TcIMtNnr1TA+OoX0UlG0HCo4L9r0etgj7D8cLkR+1iTOgiJbLzl16d0JIDWDaP/AI77wGmR/+0xDFyCrGzfCRibsr/KIkz03Si2s+qDsm/+fc3OHDnbNQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760358034; c=relaxed/simple;
	bh=Bu8J2m4vI1pZkzIHinjXEWh9VbZQJuxJkYHRlIdEzrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZGOw/nPtCSmiulFhv/XDnZseYO/uHm/DGqdcUEa2pBlyrpPKyNzQmDdVN5z+cZ0+/2rF5UuMjdYt1D63QV+/GdGtljO/XbgTnLYkV9FBjuYH0YASqNQO17rUbtlV5ZJNf7x/ujRCBZSMy9djEE9tA+SEqG7V75ECdRX3wiQD2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DA97113E;
	Mon, 13 Oct 2025 05:20:23 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A4993F738;
	Mon, 13 Oct 2025 05:20:30 -0700 (PDT)
Message-ID: <25a19af8-2026-45b6-8d0f-42c371c8ff95@arm.com>
Date: Mon, 13 Oct 2025 13:20:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: selftests: Sync ID_AA64PFR1, MPIDR, CLIDR in
 guest
To: Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com
References: <20251012154352.61133-1-zenghui.yu@linux.dev>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251012154352.61133-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Zenghui,

On 10/12/25 16:43, Zenghui Yu wrote:
> We forgot to sync several registers (ID_AA64PFR1, MPIDR, CLIDR) in guest to
> make sure that the guest had seen the written value.
> 
> Add them to the list.
> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 8ff1e853f7f8..5e24f77868b5 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -249,11 +249,14 @@ static void guest_code(void)
>  	GUEST_REG_SYNC(SYS_ID_AA64ISAR2_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64ISAR3_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64PFR0_EL1);
> +	GUEST_REG_SYNC(SYS_ID_AA64PFR1_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR0_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
> +	GUEST_REG_SYNC(SYS_MPIDR_EL1);
> +	GUEST_REG_SYNC(SYS_CLIDR_EL1);

Why did you choose this position in the list for these 2?

>  	GUEST_REG_SYNC(SYS_CTR_EL0);
>  	GUEST_REG_SYNC(SYS_MIDR_EL1);
>  	GUEST_REG_SYNC(SYS_REVIDR_EL1);

Looks good to me.

Reviewed-By: Ben Horgan <ben.horgan@arm.com>
Thanks,

Ben

