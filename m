Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690499;
	b=JYPiOPjSQqsKenX5ZUeTNdOIATtneLXhTGq3YYF6CfbaW0WNArXDjRLvQlM0Cj3PHRmk
	 TYPmEp3AY4nl9WC+nWr56kd4mcUNeEB9976J/swqHq/ijyHXXzAB3V4nQOaxS13RbpwOP
	 XAuVAkmLewSPq4QjQ4jY66EtQfopwmblCCmmgo5YYmWIPy9ElgWvFVatPJM7HNlTxkM92
	 S0p19sv9B5pGAkJ8PE4dIv6ETK6fSizUdYEc8+oKihxXsMEreqQDsqLwy5C/byxWfovYD
	 n2FmJEfGzQsMuRLvZGExE86Hu/LYh01FzewitklC075+e/jcoMLML+ny2MrI16/HE6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690499;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8J1zzDxtlEA13ky6xYJ/w+ZJ3LY5rj/np53fpaLDum8=;
	b=oFWvX2Fi6Ji7U5NmDKrDm1gp2E77s1jabc/oM+O8BfBtKXVS/dKps9Gtu1oEGqqWnSh5
	 tFjdKI4XbF69VGu2NxAfLeE4FxB7LWa57eTL2aAWQ9t9GRdlR61EmNvVIz0+hm/Ves21t
	 36vYkts1WjwjCu4LGoLe28CQt8p0mkjO7hgu9URiXPpi8UvRNDz6zBX7fiobC88mNpL01
	 T4lhWKl+UmszSvNSLL0Xg4w7M/WQPvpdf3D7wzKdfTNiRBwRZZ1/+5AB6GZPXmE6gq5Wf
	 P/eO30ewDGkOab4ct1dKBEmYe5PmUmhv6pAlGr2loNElOF208gPamgRJSiLYzLBOJdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cr+LiqX6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7EB7606AB63
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 17:34:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7EB7606AB63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cr+LiqX6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8364E1691;
	Thu, 22 Oct 2026 10:34:48 -0700 (PDT)
Received: from [10.57.76.220] (unknown [10.57.76.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CB493F673;
	Thu, 22 Oct 2026 10:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792690491; bh=wULjyGcKG4QcdOpXfpsEHSuPmredAn2/K/5P6lqhDNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cr+LiqX6dxnXyLCw6xcG/iiQ6lcbH2bua/6JIR9Sdx6NiJ7Zxwgdi5SE9qksYSe+b
	 ktoOVvsAeu4AJfhU0NNcOhHnAIuqI5pXCJdoySjpJTN9pJXqo6xGAOR9TzidsE9XnW
	 EI2YkVhAW7DbynslCf0yp9btO9PFWcp7CkDg3Gd8=
Message-ID: <84e2b43b-5c4e-4e15-813d-856ce21d25d7@arm.com>
Date: Thu, 22 Oct 2026 18:34:47 +0100
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
Subject: Re: [PATCH kvmtool v3 01/21] arm64: Propagate IRQ routing
 initialisation errors
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-2-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261016153939.913764-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 16:39, Sascha Bischoff wrote:
> irq__routing_init() can fail while allocating entries for the default
> routing table. gic__init_gic() currently ignores that error and
> continues with a partially populated table. Return the error before
> the VGIC is marked as initialised.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arm64/gic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 1e400962..debb0381 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -344,7 +344,9 @@ static int gic__init_gic(struct kvm *kvm)
>  		}
>  	}
>  
> -	irq__routing_init(kvm);
> +	ret = irq__routing_init(kvm);
> +	if (ret)
> +		return ret;
>  
>  	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
>  		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &vgic_init_attr);
> -- 2.34.1
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

