Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34E91A0BF3
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762509989; cv=none; b=UlJ4cW+qkyWPUgZEao3JYg9a1oIMd96ca4QOA0L7OoirIqHlRFERJzO55Yv72tS2cOnXMLSfZ/frwbjf/xyxKuQnvndLYFekjfTCk8A6/bAkU+pA5urAsghsS8RpIQdg4Ga/c56e6aLSgu2w2QuxYSPAa4D0Z6L9CncwWRk2/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762509989; c=relaxed/simple;
	bh=e1JOdRzLeuWX3PVxN52agD5YetnAyZ0LklkuKw8GlZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aFS7h+boi9HFKT+70QncswtxxSkX+3l9faG2wFisQz/TDh1Ft2KUfeNamD3hEzwEceIQqYV6i+jk3gMW2QQP4OztyWjsCVDUxA+8lZj5zCfLtERArrHXPx9ha49Pu4GFR9NXbe7CCzao9kDdJGEeOkPsiPwskYnuHemOuA+24e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C75E14BF;
	Fri,  7 Nov 2025 02:06:18 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 496A53F66E;
	Fri,  7 Nov 2025 02:06:25 -0800 (PST)
Message-ID: <264b9f2d-5fca-4fda-a0ce-1b0223906560@arm.com>
Date: Fri, 7 Nov 2025 10:06:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Maydell <peter.maydell@linaro.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 30/10/2025 12:27, Marc Zyngier wrote:
> Peter reported[0] that restoring a GICv2 VM fails badly, and correctly
> points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
> equivalent is. I broke that in 6.12.
> 
> The other thing is that fixing the ID regs at runtime isn't great.
> specially when we could adjust them at the point where the GIC gets
> created.
> 
> This small series aims at fixing these issues. I've only tagged the
> first one as a stable candidate. 

But, all 3 patches have the same Fixes tag, was that intentional ?

Otherwise looks good.

Suzuki


With these fixes, I can happily



> save/restore a GICv2 VM (both 32 and 64bit) on my trusty Synquacer.
> 
> * From v1 [1]:
> 
>    - Make all 32bit ID regs writable
> 
>    - Use official accessors to manipulate ID regs
> 
>    - Rebased on 6.18-rc3
> 
> [0] https://lore.kernel.org/r/CAFEAcA8TpQduexT=8rdRYC=yxm_073COjzgWJAvc26_T+-F5vA@mail.gmail.com
> [3] https://lore.kernel.org/r/20251013083207.518998-1-maz@kernel.org
> 
> Marc Zyngier (3):
>    KVM: arm64: Make all 32bit ID registers fully writable
>    KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
>    KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace
>      irqchip
> 
>   arch/arm64/kvm/sys_regs.c       | 71 ++++++++++++++++++---------------
>   arch/arm64/kvm/vgic/vgic-init.c | 14 ++++++-
>   2 files changed, 50 insertions(+), 35 deletions(-)
> 

