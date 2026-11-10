Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323205;
	b=a617o7r3xigm8Xxp2umA9R6YupwZRJ2ER9MztCRJIYf/2qXfPW6L/+w3srkvcXOsETVE
	 hvCkGEpH3bZSVMbI1ajOHApo9Ag0Fdlj9BQd/7y9C+k2DNNFVll9F5zWcClcY6YDYyv1q
	 R5IC6Jw9yLAUGXk5NfSLugUXzANDjZfkP7kAB6psY0ifODsgFFejI2v7S6xU9uYtVUkRy
	 eA3N1R2nk9d0DpWRwT6xPdt35ywUNiksWINBw2dURlx6GLTxMOX3MTy9fS5wNP8W754f/
	 KuXxFBloMzuHnCdzOYY8KpfGXP+KRun1v0NukvOYjqgnCIddblt6qcYYQfci3S7900g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323205;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Z9mSb2fKY5P4mSCROzwhq12HIFLb50lizJbHfw87JAk=;
	b=fmP5aMcgqVRZ9WItNrDJoznfTdt6KO+vblj8LJWUcKIRdmrRgiS4MGEO6r48LTDEXr1F
	 a5N7LnxfgfQxpaKpI+covRLvQzIl2Ds+b2shu1Y31bhE5pSvu7MpSHShCsFNjS2B8bSTN
	 RozbHbbtyCrWsmCnFTW6OP0tKrPPgi+v4G+wPtUC6W0gE4imBV817dmtlaXsONj0IFJB6
	 gzBpZp/hgy2NuzIRWiQ4ZwH4Ws4HEwkOjlfd3tkYLhL2pqlvtaSj9ZAUi0BjhZli9S2sh
	 iuPnuOlzYicDnMR354HmrokaEdSOw2O8FrBbvwTVJ4glx48895L4ZgMWrQ0Jf4fxb7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ab8k8ewK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC573606AA69
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC573606AA69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ab8k8ewK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CA3E1477;
	Tue, 10 Nov 2026 07:06:41 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 963143F85F;
	Tue, 10 Nov 2026 07:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794323204; bh=3AVzy3LH/1lk5LMXc+9PvHcKygJvWkNZG8Ry0iHFvns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ab8k8ewKYHGmHgYuEIcO6FkKErMHR2SspTHB22RMqygNyUptQi5r24oV4BAjoUK0S
	 BLVt3pxo3D9PSRuPdLO4a+rrO2dzStTeXSbD/iywfdWOl14f/3tRuu+OvEsGKAsBZc
	 3EXMXU9zZnauzmsJpS4e4liImaEGargDhCm0Fhlo=
Message-ID: <839a24e5-5797-4077-ba4a-0a76f644a4b7@arm.com>
Date: Tue, 10 Nov 2026 15:06:40 +0000
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
Subject: Re: [PATCH kvmtool v4 08/23] arm64: Start GICv5 SPI line allocation
 at zero
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-9-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> GICv5 SPIs start at zero, while earlier GICs use an offset of 32.
> Select the zero offset before allocating any interrupt lines.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index df5689a7..58644036 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -234,6 +234,9 @@ static int gic__set_spi(enum irqchip_type type)
>  		break;
>  	}
>  
> +	if (gic_spi_base == GICV5_SPI_IRQ_BASE)
> +		return irq__init_irq_offset(gic_spi_base);
> +
>  	return 0;
>  }
>  
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

