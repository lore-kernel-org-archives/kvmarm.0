Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F619218827
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 08:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664619; cv=none; b=mmzVwTBmhiSTLH7PPlJwhtRHojGEC1u3ZfnqjqiYj+P5htmre2V4grdgIZu7NREoYsXv/TJg6RTUxudjTSYpfWcyAQFblOkLy/frUIY5SNjZORJ0JBO7sweNz8nBiGDKWGiClyy7b4kKgGk43f9ai/er4RZmf6SkahjzMk820LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664619; c=relaxed/simple;
	bh=ljPIFfOFsoD0IY+vD8iQiUhW6H9eT1RLD0DfmAdK6+0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=kLCp4+PdljRNJ/zgyEINNujKw2ewUixNOHZYPfO2pOq6I/BMkNejjhBnQ8NRGxVU7cNbSBnGUSOG7tG+WxRoJRvIJy0yZDWl2e8a5X3Ok5WT3owYhGgRFkjYuUWQ140afashY5bNVXtCU4ct+YPtG8jE0CvO6lKUbuE9O8CgjC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQJakQkS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQJakQkS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664616;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FhxQP8uDcgw+uSq85Q9qXw4+E7SaR3rSwXRIV3Ffat8=;
	b=JQJakQkSQiLJHAJqTWJMqNYjtwvusFEvwZfhA8uYCqNm69tcHWsoMMwowwF+qqPr86Le2k
	H2Jjkz2cGWOzFDdOIpc61pkxFFiGZZmjtGVU7n8UuIvH3vkdRCJfUFOh5J1ptL58vAXGFG
	7gYrt0h/EWby5JawTkyYWov/pVoT7cQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-3XxX7KA9NRC1woNhHA9P4A-1; Tue, 02 Dec 2025 03:36:54 -0500
X-MC-Unique: 3XxX7KA9NRC1woNhHA9P4A-1
X-Mimecast-MFC-AGG-ID: 3XxX7KA9NRC1woNhHA9P4A_1764664614
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b225760181so589138585a.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 00:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764664614; x=1765269414;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:reply-to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FhxQP8uDcgw+uSq85Q9qXw4+E7SaR3rSwXRIV3Ffat8=;
        b=Bk59EKOLr88rICgFdcp38aLHPTOuyi//GsvfIhcwlyDQLVPPThTKTv4bQYCnFOq9sn
         smIeX7Yq70TP86eKJU3+S6tgvL9KGvCo3pL2tevwyiVNhDgoa0xXwUm75ExjkjRk7S4W
         Jmz0e3BkFUax4HIAEbyk3wBFstp+Cz3u0x6/zIXSRGasazfe9YFwykoFbcv+fWTXhQr3
         J1REvIqRWtmtFSHh4/z1bYW+b2PEkx4HJnSP1FIUmAkjMoNyZbO3tjAq/f3XPt79S7CW
         R1RXNm3F3+pjhYq1guOz7J+/uCLCml3boGbNN6V9G1HNogh+X/QrkF+dNLiLgACqQvbx
         QChw==
X-Forwarded-Encrypted: i=1; AJvYcCVeFAS5wQznU/7uAllR9Tr4PiujlQwrQR3f+ybGXYGTf8p0SMpSCyUnQESD6aawoUtI2H7PCjM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwD7KXQdEVoCpca6552NTfQ7YEIVPQ+9IoDKVPlCixGdL/Zk2c9
	KDhq7IQ75ZkXD4FmlLl+2KxG6nsGKFusha4+hI8tEOxVCtucbpuRLEPKzyNZhGKPNFzVA5KAjQ8
	t3etdPz9M2VVjxvQWUskxg9T4kKN+c56uDVKJqsloGXKtg5YSQuwBdripMA==
X-Gm-Gg: ASbGncsVkrakLR2QTMI+V2fNFwIZlv+7hnFhQ2Z23t3uxW0w3qKV/O2Jcpcw8F/5qJC
	XNcwv9sOSHwr2AEGBtqpyP7OyUtYLKBuVOJGInz3EAIWKlOPrbHqOlCe59ahmkBKdzkCicwcrik
	eAn/mdttmQutuHMHIu0K3GzC/L6CdtjvC+J3+zwb5fqyRaCRdWauRjOKpFewtxIYKVe4NW60oRw
	ufzV4TeMnn+jdQYR5Vff6gCUaIfQe96HZvtlBcHIbYKZTWI32l2Nlc+Cn8X3aZS/JFSFpRcnL67
	GAt/LChXBbY7q3vviUig530tnNQvLuItxrde5y98ichP/doiMfGxhP3yzCEFWp3ZPfyOfs54kPC
	/aWj6Axf2HPKUOz0Q8tL55JRPa0TIt14qk57fAm4slbI32jupIPNay0hP2g==
X-Received: by 2002:a05:620a:3188:b0:8b2:a0cd:90f1 with SMTP id af79cd13be357-8b4ebdad2d8mr4544476485a.61.1764664614329;
        Tue, 02 Dec 2025 00:36:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGd9tm/hSDq7CPEdeY5DUJhc1/EEJO8Va3XfuxS5ihcgleQQ+YC8AQSXG14NIQ79+naXx2fkA==
X-Received: by 2002:a05:620a:3188:b0:8b2:a0cd:90f1 with SMTP id af79cd13be357-8b4ebdad2d8mr4544473885a.61.1764664613886;
        Tue, 02 Dec 2025 00:36:53 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b529993978sm1036295885a.5.2025.12.02.00.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 00:36:53 -0800 (PST)
Message-ID: <afd45a76-b215-40e2-b7d3-457bf7e0b2b4@redhat.com>
Date: Tue, 2 Dec 2025 09:36:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 05/10] arm64: micro-bench: fix timer IRQ
Reply-To: eric.auger@redhat.com
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-6-joey.gouly@arm.com>
In-Reply-To: <20250925141958.468311-6-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TtgWZIk_AC-JNkKVtPqh-JfJ917B0XxqSlhq4M1MWZ0_1764664614
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Enable the correct (hvtimer) IRQ when at EL2.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 22408955..f47c5fc1 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -42,7 +42,7 @@ static void gic_irq_handler(struct pt_regs *regs)
>  	irq_received = true;
>  	gic_write_eoir(irqstat);
>  
> -	if (irqstat == TIMER_VTIMER_IRQ) {
> +	if (irqstat == TIMER_VTIMER_IRQ || irqstat == TIMER_HVTIMER_IRQ) {
>  		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
>  			     cntv_ctl_el0);
>  		isb();
> @@ -215,7 +215,11 @@ static bool timer_prep(void)
>  	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	local_irq_enable();
>  
> -	gic_enable_irq(TIMER_VTIMER_IRQ);
> +	if (current_level() == CurrentEL_EL1)
> +		gic_enable_irq(TIMER_VTIMER_IRQ);
> +	else
> +		gic_enable_irq(TIMER_HVTIMER_IRQ);
> +
>  	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  

