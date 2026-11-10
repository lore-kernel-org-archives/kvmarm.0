Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323148;
	b=U5tzYKfquf98//rnDf/k4fVM8sNO+nElXFGaIUSH+t+LYZIznr98L3vYirQZ74+0p6Ji
	 2WUwlc48tWiOjBphbp+M2QUYzsVrO4h4c1LgS8stj/OZfCv5rIufVXDk8Caf7D3lDpLZ+
	 TXq3oT04TZ1dQ6rMyEg474mh3Gp0Tc06VFO6aHTu2NlGB7ffyTnQbWLbxxxd44VbH/Cjm
	 qtAXs2Q7Q5mkDC6gMfenPks9OSf3JPjpnwbHJWCpbFkSvDq0e5NFDA7BRC1s1VfYvbLeZ
	 aWX7BnLc3f2nas4aTDVEjCfnxs5iRX0ilLWcAPtU8C1s63Gpfqx0D5dpAaycMVtFXIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323148;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=P39SYhkxl4/ngLtLh51KyXOsxnaGXxP8TPN6UoALk8E=;
	b=1scSVufULyfUZDSUOwdEAcDKjrCBwKXMr3AztgwEDMgRIUswxuvuL+RI+C9QNAjF59q8
	 8KJRtRwQoTAOrSNvvWsGKWGxQ5Tzz2XFv1sTH5KTuu0HXT5YgTH9V4Fu035E6nXqMmzCn
	 235cNek3HK5gWtyMXSyeDCAyG07praDjs7URwCF35CLG1l5enyVwq1NkqhXRdy21RYauv
	 3la9Svx4SHdUkFd/s6Cq6M5Qg8x7r/yiiKa/8OYZENlKRVn3SjaOfvxfEI3LfYdJFPKTf
	 BixNx0TbpnTT3azj8NUZOCVOdV8G5bFRdg7FFQsoPL8kE4Xyzdmivt+7yvuilE9lCSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eDhG5A3L;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20EE5606A32A
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 15:05:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20EE5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eDhG5A3L
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6404A1477;
	Tue, 10 Nov 2026 07:05:44 -0800 (PST)
Received: from [10.0.154.42] (e121487-lin.cambridge.arm.com [10.0.154.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95B603F85F;
	Tue, 10 Nov 2026 07:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794323147; bh=S9WAA8JPo6WnpYiVXc4xjQGkR+i5X14Obnp98c898mE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eDhG5A3LBrAVykmcomPLqqQSAgI+eeuLWZT3ypz2Ici0NaPDKmyCH4471HzO2VzBl
	 YTb9qm/AL9WiV3LXwpFzr2sYws1NEYeMB0ug0yz16u81TtyhVs1ztP4xw+HkiGaaIY
	 94GQvLlLGE5qz6VcDPzqJ8lh8Ji83o7pCy8YfthE=
Message-ID: <204b3dd9-11fb-4639-b749-d14b923dbc6b@arm.com>
Date: Tue, 10 Nov 2026 15:05:43 +0000
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
Subject: Re: [PATCH kvmtool v4 07/23] irq: Allow the initial interrupt line
 number to be set
To: Sascha Bischoff <sascha.bischoff@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-8-sascha.bischoff@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20261102213413.4136118-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 21:33, Sascha Bischoff wrote:
> Allow callers to select the initial IRQ line number before allocating
> any lines. Track the selected offset when reporting the number of
> allocated lines.
> 

Interestingly, IRQ line allocation used to be per arch yet changed in
9dc5430ce7c9 ("kvm tools: irq: make irq__alloc_line generic") :D


> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  include/kvm/irq.h |  1 +
>  irq.c             | 15 ++++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
> index 2a3f8c9d..17113979 100644
> --- a/include/kvm/irq.h
> +++ b/include/kvm/irq.h
> @@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
>  extern struct kvm_irq_routing *irq_routing;
>  extern int next_gsi;
>  
> +int irq__init_irq_offset(u8 offset);
>  int irq__alloc_line(void);
>  int irq__get_nr_allocated_lines(void);
>  
> diff --git a/irq.c b/irq.c
> index cdcf9923..7c4bfec4 100644
> --- a/irq.c
> +++ b/irq.c
> @@ -8,6 +8,7 @@
>  #include "kvm/irq.h"
>  #include "kvm/kvm-arch.h"
>  
> +static u8 irq_offset = KVM_IRQ_OFFSET;
>  static u8 next_line = KVM_IRQ_OFFSET;
>  static int allocated_gsis = 0;
>  
> @@ -18,6 +19,18 @@ struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
>  
>  struct kvm_irq_routing *irq_routing = NULL;
>  
> +/* Override the default offset before the first IRQ allocation. */
> +int irq__init_irq_offset(u8 offset)
> +{
> +	if (irq__get_nr_allocated_lines())
> +		return -EBUSY;
> +
> +	irq_offset = offset;
> +	next_line = offset;
> +
> +	return 0;
> +}
> +
>  int irq__alloc_line(void)
>  {
>  	return next_line++;
> @@ -25,7 +38,7 @@ int irq__alloc_line(void)
>  
>  int irq__get_nr_allocated_lines(void)
>  {
> -	return next_line - KVM_IRQ_OFFSET;
> +	return next_line - irq_offset;
>  }
>  
>  int irq__allocate_routing_entry(void)
> -- 2.34.1
> 

FWIW

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

