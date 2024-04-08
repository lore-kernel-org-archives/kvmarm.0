Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7980A10976
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 06:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712557703; cv=none; b=tgb3j9EgeMNeqCKRBwniqpPC2h5+Jpx+O/cqnUPwYlCjIToMOGEifsK8wg6knUVkmcO4jqTNzU0Tgc79xa889djIFs2zhA5Mino54p93mSAgrivyXweRf46JvP1UDnxwiIyVN9sjs89W2jRsmuOJd/4dEWN4ZV3REhf2x9vmPEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712557703; c=relaxed/simple;
	bh=IE2dQfOBUfWFV2sRzZOKfpp0BxlqrHbr9xEZn3IEuP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFldxWEbn/pCVgz+RSjqD4D80lo7gbmpikh3WnR+WkLVJlPKiNoxpjwT0Np6oEJ1H2ScfgDdGSGukQUGtBdaXH93JlvMPmCgI8sltxa0+yNd+lBD6e9Jvj/dwjAI6eV6RiPogphbYiRnyHLKZUPBumZinFEpA4frgwrhLBt9KBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KP4MfVDl; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KP4MfVDl"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5684db9147dso5300611a12.2
        for <kvmarm@lists.linux.dev>; Sun, 07 Apr 2024 23:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712557700; x=1713162500; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z6EgD/Muel3BqCojSMMdXuM1Td/LzqFDog01ouaIAt4=;
        b=KP4MfVDlURMcpf+qGu8I9FXDCp19EEc2nXU2or3pA5biTsdljXkcZ5iUBnK8gPDj4i
         WFmBPmdqYaW5GmG3NfDgHI7f9rIa9GLuMOjV8MByvq15TRoTuk8lVvuWtrRku7Tl5/x8
         1G65pPYKi/LMJ4W9u24BqA732mTdxBhLkow8zVM5ejRb5OeRdN9IbgzIobBAw2c3egY4
         dRT+rhZhQ67RUfAc/Yf5sFauRCb+kK6LdI9VXTdWXXlaRKKOqHJWce4cN9PGEVJ7PlQe
         GoX03OIXtrHj2Dz7+b8/ZCLb8Eg2mapKnv3hD1IiPKI/zKhjMrMKfIp9qSaa+5j0MdGR
         lN6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712557700; x=1713162500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6EgD/Muel3BqCojSMMdXuM1Td/LzqFDog01ouaIAt4=;
        b=cF5uQ1HmwSsvgFy4fGYAkonGfhdqleu0k9myvyVIY7zYGrB/+bqUYm/G8HOpTUKoot
         MG1QD29SedvSG61Xbv3dv4CfBj+1CrJ0hf+ClbLDVidRe5n3w4HPYe6wrbncRbHCkZVr
         9DecSysrkma1+YpUxutiMnmNEWaFWD8bm/D6mOMhNhUqM2lDBwaQn/nghbQ1SKhcGTOZ
         LIk7oIUqBhsT2mPuWuE2TKbo+X7JlxubOeufxQl0Y4erz0hGs+fsI6vtSdcUYC51vAOv
         kb2t/9ODEWwC7rsyFGtvn98ZcfdlJWCfH8L78A4R/nUyN4MfzLVaz5A8C7sEtwwe9WFf
         4htQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+8UEm+gPrG17/bQMSxx8drh9ihItYghFebe4d/eOyrxGIK4cQg/3n1c5qQViO3SlTicbVo/sF53Rwj0VK0E8rfaziag1C
X-Gm-Message-State: AOJu0YxWN4AMkr4XeH3A524T7/jgNmPW5zvdM2cIngVSmmRb+0DhV2TW
	4dZEKKcAPt70AOc1t3VwlJJUKXNoqchBEtp1mKBR9f9Xpnc3SUcp4yfC/CNaYSg=
X-Google-Smtp-Source: AGHT+IEW7NFlAXtt0eb3qEVFrk9JxABFiNRfMx5pOzC0ESg5/RMCffY6KCodQ4v8J7x5a4GlkvTfcw==
X-Received: by 2002:a50:bae3:0:b0:56c:18d5:1e27 with SMTP id x90-20020a50bae3000000b0056c18d51e27mr5576700ede.5.1712557699936;
        Sun, 07 Apr 2024 23:28:19 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.144.67])
        by smtp.gmail.com with ESMTPSA id k19-20020aa7c393000000b0056bfb7004basm3538428edq.90.2024.04.07.23.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 23:28:19 -0700 (PDT)
Message-ID: <2e481816-2b06-432c-b09c-e92e230debe8@linaro.org>
Date: Mon, 8 Apr 2024 08:28:16 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: replace set_pte_at_notify() with just
 set_pte_at()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Sean Christopherson
 <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-5-pbonzini@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240405115815.3226315-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/4/24 13:58, Paolo Bonzini wrote:
> With the demise of the .change_pte() MMU notifier callback, there is no
> notification happening in set_pte_at_notify().  It is a synonym of
> set_pte_at() and can be replaced with it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   include/linux/mmu_notifier.h | 2 --
>   kernel/events/uprobes.c      | 5 ++---
>   mm/ksm.c                     | 4 ++--
>   mm/memory.c                  | 7 +------
>   mm/migrate_device.c          | 8 ++------
>   5 files changed, 7 insertions(+), 19 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

