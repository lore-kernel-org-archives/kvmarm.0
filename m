Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322950;
	b=YQ9Oy04N6ff8TBuwiDnqbtjXnq3w6fcErtLlRRvFpHLdJOOR84sr8lrjyc7tHjmi4Rif
	 6zYQYF0qEvrAqNT1oMCa0zBIUN3/crIqHdFENc07PDA3LTFrs13cz8i+1XOXAo7h55JFC
	 zB2Ss5qCPEXyhx3ajgVBnEn4rWw1D7VVlhK5t4hbHoQ9hT4fYhvKz9NaUgYc5V1y0YICa
	 4eSy9dSrZqh3AZ/ZNFyDAs8QSoSAea1mPsLiA17fdaKYdMbCmwLOrl96zW+9fALdPiUQT
	 e/gqFIhiFCtb+sV4mJ0GpoilxuDPEtHkdYp+CF7z99t0i6ZeJ/faHWmB4ndywbW0ZCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322950;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=4gXXedfU+at3CF8LAScfFVlF8KoBb0SDUnRC5ZiBGXc=;
	b=qoIAZq6INRco2GPXdholSUZMN2AZ/bWVCxOxyG5qvUvKvAlaSoEXarbEk0Jq9SQLOYDs
	 dfTWgNxotgD/J1srWFNBJuM9EbNHOKG5F/ZiyF7Y9mDOJopCq1mxNVnFMpkvMqKAbtIsP
	 xB70khz5tKE3wixNd8zqagu/GpzCMnz8uXW+9O/8iai7EINSxGNlmYhMh3Kqwvr4fAkif
	 59lvcgu/guLzAh6vdxmokLyZKkUCWC6R41TvCnWTHP799pOgqiuwRDeXyl/qUKTtuyJI3
	 F85v1LR3TayBf0yR5FXpE6XPQsgiYo4gSrwYE/lY0cL+DYJ2XvGgFccudn+NdpoALlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Tf8dVvER;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF83C606A326
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF83C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Tf8dVvER
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B84D1477;
	Tue, 10 Nov 2026 07:02:26 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A2D33F632;
	Tue, 10 Nov 2026 07:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794322949; bh=ZEzp2lVsIPCY2+Z0Y8hijRS/rpyqEe8uNVwKEbqyqPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tf8dVvERyVnFiUAzScbcZwyhRckiQFKWX13YdOcJaVhPbUC+J1XmrCRu8V6R55Tdy
	 dlGVLHVklAtkPrMas+g5509s0WPg8B3a3V6OHB0EYtHG9QRX++OVdW9Idq6PDlIktP
	 nEWL0Lqr5euPuhApVe8lt2oXrgkigTHFZFVe8r9g=
Message-ID: <b36259d1-b9cc-4389-82aa-ea7dd5691e32@arm.com>
Date: Tue, 10 Nov 2026 15:02:25 +0000
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
Subject: Re: [PATCH kvmtool v4 05/23] arm64: Add GICv5 irqchip device support
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-6-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-6-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> Add IRQCHIP_GICV5 and create KVM_DEV_TYPE_ARM_VGIC_V5 for it. GICv5
> has no distributor or redistributor MMIO frame, so omit those address
> attributes.
> 
> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c             | 5 +++++
>  arm64/include/kvm/gic.h | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 57f3fa02..51a32159 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -227,6 +227,9 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>  	case IRQCHIP_GICV3_ITS:
>  		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
>  		break;
> +	case IRQCHIP_GICV5:
> +		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V5;
> +		break;
>  	case IRQCHIP_AUTO:
>  		return -ENODEV;
>  	}
> @@ -321,6 +324,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
>  		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
>  		gic_msi_base = gic_redists_base - gic_msi_size;
>  		break;
> +	case IRQCHIP_GICV5:
> +		break;
>  	default:
>  		return -ENODEV;
>  	}
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index 8490cca6..630f0bbd 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -29,6 +29,7 @@ enum irqchip_type {
>  	IRQCHIP_GICV2M,
>  	IRQCHIP_GICV3,
>  	IRQCHIP_GICV3_ITS,
> +	IRQCHIP_GICV5,
>  };
>  
>  struct kvm;
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

