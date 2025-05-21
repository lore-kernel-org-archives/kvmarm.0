Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B68322FDFF
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 06:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747808194; cv=none; b=O2OSDobRnpPIdbr3m3vOWZKbqp/1LQvAV87PZv+cOjzJST1+1p84SXwMyc3PelTCPKFvJK0wVCbI9jwFCuxk8CJWwQsykLE0q2zIiWLAZrZItXAEfINJWCDKbwDEXYzLZ9A1/3qqH7a+KqZOwQDghCuDp/gAGlbn14f3lPkTsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747808194; c=relaxed/simple;
	bh=/PmoCyZ6dzOc/MlhabM3w+kAofXoLQ2s+DiWceK6Kz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z5twCWn46AucqpIqGSZ4Dwz8MAnXEeBVWXsemUxHTvec208HujBb5mZHbIoY1TlhsssV9HmPyUqiifAOrYjXAzn4RfKs+JIMgIQE1oE9kbbZakPca0+NB0hfaQ829Vss0ohVg5VsFHPOqHbLvzHdCtArh5UvpGcJ/6BWHJPyxX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HiK3d3LX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HiK3d3LX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747808191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw5uJHJc2V+sRbe4e4Tg6n7ubVHazSs+sdmDhxZTg8c=;
	b=HiK3d3LXL9bN7GdSU2TR5Swdm6WzzRdKLsjky3on3jtCbN1aGs4dhzMVPcyn0JjIhdS8ul
	UFk2s+5OF7sCdMDBV1reWA1AWINz5WCLTI2zBjaCddHtAi9NZTAYQmhQxcL6qX013x6bg7
	APkSzbQdpMK3Mqi1Nu96E4DRI44Tf+A=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-x7uMxNuZNEi4UiJXTZ-eTQ-1; Wed, 21 May 2025 02:16:28 -0400
X-MC-Unique: x7uMxNuZNEi4UiJXTZ-eTQ-1
X-Mimecast-MFC-AGG-ID: x7uMxNuZNEi4UiJXTZ-eTQ_1747808187
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so6814861a12.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 23:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747808187; x=1748412987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iw5uJHJc2V+sRbe4e4Tg6n7ubVHazSs+sdmDhxZTg8c=;
        b=oRicwGVjr4Q1+aIcuJixrgGC/CfwOLZorwDq6D6F3urXIdL0IBS++y6O/ipFE0yQzF
         TecGSrgdcGMM3jttFSkFaJM9yLBvZFsOcBJUWD94P45Y/cXcQP7yrXsppSP+wY8TF1W6
         h1Nnv8oQKeiLrv/RfuEeuAlydAHU5wtfJg3u7Xh14WnITBTYQxN9YhCg3TJwABonOJjo
         Pq99LEiBL4WHeQzi8BgXvrOZhbbWhtV2l+DK1DWPfeXIQ7XMs3+ExexaoAuWzhS0nRNe
         goJYsN3JLSMnNU3LE5/9QG1AbdEIiXTD6WDKwyPOIBr7VnotE2U5sBJb6SIdRu6ssfF3
         R8YA==
X-Forwarded-Encrypted: i=1; AJvYcCXkoUpgmFd8lADtmPCl7hZdurtCd0dpfvD84ZNh/FWq92FvGJvSRSWwoDyUARx/VTYeE5KAiKw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywo89sO8HzzeveFlhChfpMatMdXYlDjQYHgdIoZBsMRK0O2eD/8
	wuC82iixOojg+Nth2uxn6/lNYSWjs4GS2fAlKjSDO0/wU1gbrSJK9MM1xpBL5hwmFbtP6Icz3u/
	A+SPZ6dG0RTVI2ZEiMD2bWBNtw+unMhW44yaOopKvZc9BJhKHA8itvL1Rew==
X-Gm-Gg: ASbGncsKmFz8bj15VWY2HF2NI7T8cSFqPiP9IGx2uyeJUXVYNTnaGEJzTmtITqPjzNS
	DD/9dzCZ9jiQ7cRdCOr/JGNjsr0NOERWrqN8RQQI/urAGaOEf3JbyIFntFTQWBpCvBEKMQtNzkz
	AereOXCAqTV5XK6s5EqXgeQfag48NE2i7pqS5gH8HgG4unyUG7YwOrryu7g1LAqMpJJnFB6QXbn
	5++Y0/X1y9KNIowXlS6NMjWIZEghi9UVPYL/hdmqWINxMq50Xh2/NE7Js4peGa6MfnR6xui6fb0
	sdxmMX0j3Dra8NA=
X-Received: by 2002:a17:902:fc46:b0:231:bf74:e1df with SMTP id d9443c01a7336-231de3515demr258862335ad.7.1747808187207;
        Tue, 20 May 2025 23:16:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMaGJi9XZe04iIaqoT0LCToE4EYldNnY+Yj53uJr8Djqjif4zPPKYkEdeIkY17gXv01FY1iA==
X-Received: by 2002:a17:902:fc46:b0:231:bf74:e1df with SMTP id d9443c01a7336-231de3515demr258862005ad.7.1747808186859;
        Tue, 20 May 2025 23:16:26 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed5460sm85707015ad.241.2025.05.20.23.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:16:26 -0700 (PDT)
Message-ID: <b5d2d946-7f46-4908-b44a-6ce80b67c46c@redhat.com>
Date: Wed, 21 May 2025 14:16:18 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 14/16] scripts/mkstandalone: Export
 $TARGET
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-15-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-15-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rIqtEz9dtu36-G3q8_Pa5-W1DCkHJbSLtguMU9rl2HQ_1747808187
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> $TARGET is needed for the test runner to decide if it should use qemu or
> kvmtool, so export it.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/mkstandalone.sh | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 4f666cefe076..3b2caf198b00 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -47,6 +47,7 @@ generate_test ()
>   	config_export ARCH_NAME
>   	config_export TARGET_CPU
>   	config_export DEFAULT_QEMU_CPU
> +	config_export TARGET
>   
>   	echo "echo BUILD_HEAD=$(cat build-head)"
>   

-- 
Shaoqin

