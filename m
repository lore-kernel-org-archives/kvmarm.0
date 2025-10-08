Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC7C279DCD
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759934544; cv=none; b=ObyZm1mepOS5La4al3wUS7EVWpTRgblJU6xm6N4/eluwgR9ZoVuPPxUFSg5O3wcehe8Q5499l5zElsV1eVULXpVU2ikSsjrmb9xCYvDrsCpYVoJtAnzpkfUOw/dbw79OZXObnawsPjIP3hn39+AMwjIFXM4JTfOCg2ATfTYlGfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759934544; c=relaxed/simple;
	bh=Iz/BfAIRXWkIfnTm6UE4k6iw5ur75qIza3WL9hRE9zU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eEqOQvv1T63pSEyrtY8WGgz+SwSFkLmRlgguXMuXhj7KLwqDjrfiM3ntN+w1mGAssGuJUfmodZbZsr4cRuxkIG21H/3bvoIwc8IiMMfLdFmaoVOpd6w5FbYiry7/OuM1T5pm2Cf9rDIGXSAv7KNeYRItS8toLsDEDrXrGPa7v9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FZrlubw/; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FZrlubw/"
Message-ID: <f2504698-a956-44a4-8481-8b0b27c2ebc7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759934538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oh9kSiItHcBRzBauuSwy0qtu3GYxQt/SvSqIFf6Mzaw=;
	b=FZrlubw//yRXZ4A3FVL9Gso3nPigfwN5YtOP0BTSsrk30wI/IkZQN2AXF3KEGYvzuYb3ad
	+BqFhrVsK27coSnETgLaZ2VEahKHPiGwJao7umbNaIUYtPYp6RDLoWF62C2NPCKGavWI/d
	FVlrhP4lv4qEEDpar6czkMhZe3BvR3E=
Date: Wed, 8 Oct 2025 22:42:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: arm64: selftests: Actually enable IRQs in
 vgic_lpi_stress
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251007195254.260539-1-oliver.upton@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20251007195254.260539-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2025/10/8 03:52, Oliver Upton wrote:
> vgic_lpi_stress rather hilariously leaves IRQs disabled for the duration
> of the test. While the ITS translation of MSIs happens regardless of
> this, for completeness the guest should actually handle the LPIs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> index 87922a89b134..b890d7d91de1 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> @@ -123,6 +123,7 @@ static void guest_setup_gic(void)
>  static void guest_code(size_t nr_lpis)
>  {
>  	guest_setup_gic();
> +	local_irq_enable();
>  
>  	GUEST_SYNC(0);

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>

Thanks,
Zenghui
