Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693739;
	b=lQwGpWPdXdAPT9Yjp2mbTyaDwoX7dwShrzZsc4grDwayEryaR70OQsLwxyQWMp7/Dbtc
	 naNbCZfjpkV6QMe2m0wU+8v+hVSvOggzFy9quH4cJeSdEpEr5hKTWTR9olvSEYi/4UuSI
	 GjYX19ggVzJLpHPLtOYNXQFPpjcE6/ioAKzlGLTXVZUKuaXeI2L0KWV5Qq4olBdOc1XQD
	 8bQkKszmelJrHJ1JSYc3Or4ysJxCcF4C6qnpPST81R0yGjXScjfhXv9nDknMDXEsFQHyY
	 dk1PLHrV/LNaHK/v43wSfwQ6kG4JB/tb80NEwvjkFM4VT8Wa9JGt3MPjmu5mMQZnUeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693739;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=f4pcoA9nQGiHGalq0OROLcmBR13f0e2VRwXmUp7izys=;
	b=SaFNi56WwJ2csr3CsqKlGKhQRnALXzJhDx0Uqp+PY64EmXiMvJ+/7Y4ALhGb3WcbN+OS
	 fvvstEt4CtFhgxFR4B66h7r1vBqmygWaclJFQ5bD8SlhjA3ik7C7mAVtTikv/LOeiUvZE
	 jaAO4kEOZpVxZfe5eNiVXqCZXF7oqODpcMpTxGQoQKF0D0nqvxkYtz611TMhYHPNeeocw
	 nLJxtMOZao1ZBV/YyihqX3q0Sj+p/qw1hw5/m1Q7ejoBdQvN97HOjRYI5bQ8BOnr92L4W
	 rdBTdVYVUFTF4DnKpiqPlIB2PsR/WFGwDBDBaPysHOpr+6KMx2zh0z9fUYxuviWTbsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d4dKmAYP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B455606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 18:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B455606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d4dKmAYP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 890E41692;
	Thu, 22 Oct 2026 11:28:54 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC9923F7B4;
	Thu, 22 Oct 2026 11:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792693737; bh=kun4vjW3lFkClvQKsGmACc8or4uvwpYyY+ppKVRza+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d4dKmAYPcUSumSMZQ+j7v2NTkfN8tOCBkRahw4SStQ0Net+HnMXCGjyY2pYokix9w
	 FUwHmCMg2e7sBp/jSLH6q0xXEoDjHXbB5iFDwljLE/ZoC4loiYy4vjZmy/WAGLEow+
	 2f9HqX2SrcYyduTFOH9Q5ueHme52kfMwckL0qEFg=
Message-ID: <a754d5cb-dc7f-49f9-a815-98efa3d57574@arm.com>
Date: Thu, 22 Oct 2026 19:28:53 +0100
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
Subject: Re: [PATCH kvmtool v3 08/21] arm64: Define GICv5 interrupt types
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-9-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> Define the PPI and SPI type values used by GICv5 interrupt specifiers,
> and the type-field shift used to construct a full GICv5 INTID for
> KVM's PMU IRQ attribute.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/include/kvm/gic.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
> index 991aa912..bef871be 100644
> --- a/arm64/include/kvm/gic.h
> +++ b/arm64/include/kvm/gic.h
> @@ -10,6 +10,10 @@
>  #define GIC_FDT_IRQ_TYPE_SPI		0
>  #define GIC_FDT_IRQ_TYPE_PPI		1
>  
> +#define GICV5_IRQ_TYPE_PPI		1
> +#define GICV5_IRQ_TYPE_SPI		3
> +#define GICV5_IRQ_TYPE_SHIFT		29
> +

Can we also add

#define GICV5_FDT_IRQ_TYPE_PPI          GICV5_IRQ_TYPE_PPI
#define GICV5_FDT_IRQ_TYPE_SPI          GICV5_IRQ_TYPE_SPI

since seeing both GIC_FDT_IRQ_... and GICV5_IRQ_... back to
back in FDT code is slightly confusing.

Cheers
Vladimir

>  #define GIC_FDT_IRQ_PPI_CPU_SHIFT	8
>  #define GIC_FDT_IRQ_PPI_CPU_MASK	(0xff << GIC_FDT_IRQ_PPI_CPU_SHIFT)
>  
> -- 2.34.1
> 

