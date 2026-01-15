Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6F829A2
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 02:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768443397; cv=none; b=YZ2f/clO7hppGM2OKF8Y+gtlukXL7fJeZSZYz3N6Z/OaD/6VF2IsCWDPUiooYtw8MCzZv5YipGtuhPapAb2FKA3tn1K1cgmCa44ep/8Nvf0kypyoeRXS9T+H6Oa/6D9kDKDV9ruJA1MPPB1aIQ0nHSJTT9+KLFO8sv8R4CpAJog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768443397; c=relaxed/simple;
	bh=XRbqoNb+TPuwNugFKX3t0XCiYfn4NeEV3B9HNRbntt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLwlFuCVLbdX2IlE6LlbXTQXtN1PLevoFPydTjgegFf80H62Op/5zj7sFZe95MT0fAo2PHEJ3wCfnJTNdihEzBNvha2auvntI4A7OGC953yolIlpbN3V8SisG/nfbuR+Hs7qfa6BMvEIXVvweWDFpL4g2MCGuSj5bMkuJYw8N88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=clojrNpT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="clojrNpT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768443395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dlgkmxWqaDOQOHWSmTqUqR3tikn8dprMTMa25/WTs0=;
	b=clojrNpThDyewucDxQIn4WKg8CoIxsn17MoVc0o6zwb7S4a6D0EPscN3En+yk9VxtqqWow
	FibfLGRu5x/xlPgYWc0kQTxEnzRjnmfGDuTq7WJcj+S2354o3FnMqiGJJxtfD1M7KzAMH9
	5QCGAvssFOC1yothszbhhXHm1dsAWJI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-6rSUSPypOeeRnozokCsoww-1; Wed, 14 Jan 2026 21:16:33 -0500
X-MC-Unique: 6rSUSPypOeeRnozokCsoww-1
X-Mimecast-MFC-AGG-ID: 6rSUSPypOeeRnozokCsoww_1768443392
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a0a4b748a0so10868175ad.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 18:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768443392; x=1769048192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dlgkmxWqaDOQOHWSmTqUqR3tikn8dprMTMa25/WTs0=;
        b=h6vFxMFVTZvvlt4cmBXuzXKkcQVG3qqtGCbRVm2q1s6ttyrmcpf3swXlGmwVFKRisJ
         hfgejMHxSrMi4t6G2lTVjC/xRrNM93MwpszZhGTHoNbNXKW8Iyic81JPo2iZyTD6cioo
         Pt6OrqCjVz6pzLFVAwBl2ojIq3cPp5eI4dl0qx7S5v4sozOzmbr/+UJSqNLHNruJRMBK
         WSL2RszLtkOEa2DR0fuBXMiiS4L+It4TmM2v1OLobHJrHD6IuRt/BRGcMolT96cnVioC
         cq6aNqCk78AzzEnFDeLz1liZIKc4qP9UjdAml+tFJX7jJ8k3zVClnbjx1fWNZkhczuis
         2WHg==
X-Forwarded-Encrypted: i=1; AJvYcCXTemv/PFOhdornvOw3hqM1JTJ7cOouYqG4ooVOE/87NvatGLy4cebZTrj+XpaeubK6tV3jYdE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMErmaY3hNHx08eeLx3E6CH8cnkzWhPTQUmZhWUDaSOPEgUDg7
	oyY0LOzfI48JJAHWHP3NxYJ7+CD615iLcqluoc1/G2C0Nyhg7gmmY9ugvZN8C6QXl2q1mPDC+Lc
	pd2xyuLk4w/QhORkZvNTnSvM/TKM6j63auj2vu7BP6x+q1zJfyUAMZXVZYA==
X-Gm-Gg: AY/fxX6PzWOYodChqJhQJgi7MQhZAeiYHqNKK7obeRHt4EY5BcuZ/27xOp246EQzdQ7
	44tgLYQ0U3O7BhJ7zjbBfSz0ZjYOreldKt0g1hWq6s2FJ1ksD/1QC3libIrg5V8QEQlf0rSkuoe
	OvYJaA7CdYFKqNJrHv9ZR/gQveCQbogBnBD38v1k43nU3orfSDiDrVoo4idwsaC8cNeiGNw5nab
	rWEHZvnA0333XjFcWO+vktK9J3uwpy1caYmNq4hXwWd+oKFtgnuoTwfvDK+lAInorntLhVjScW1
	TfRgF62395GxnOfqF2AAEMbFVJAWENiQ1AzufvpzUyXKDlOPKB2tJQXNNIdm8qsWzN03kbuo+nQ
	liuRQkrX4tcI=
X-Received: by 2002:a17:902:ce92:b0:2a0:97d2:a25d with SMTP id d9443c01a7336-2a59bb51ffemr43748495ad.15.1768443392059;
        Wed, 14 Jan 2026 18:16:32 -0800 (PST)
X-Received: by 2002:a17:902:ce92:b0:2a0:97d2:a25d with SMTP id d9443c01a7336-2a59bb51ffemr43748275ad.15.1768443391605;
        Wed, 14 Jan 2026 18:16:31 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3ae21sm233902385ad.7.2026.01.14.18.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 18:16:31 -0800 (PST)
Message-ID: <fa352909-0a8d-45a6-8965-6328299e2e0d@redhat.com>
Date: Thu, 15 Jan 2026 10:16:08 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/47] arm64/sysreg: Add MPAMSM_EL1 register
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-4-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-4-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hb72Wl5JLSQgP7QLsfLrH1FJtIE7FtsihLPf5t1qVWw_1768443392
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> The MPAMSM_EL1 register determines the MPAM configuration for an SMCU. Add
> the register definition.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/tools/sysreg | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

