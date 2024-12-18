Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4C31B425A
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536305; cv=none; b=QBbx6MLf11rNgROTgipf36rz6ea9CK5BHYM9rW3XYNZvRe3lQOv9hVSevUnoKd1r4ilD2/HxCWDMveGG1ltJAID6NSl+Khn/UYaI6saF80hOBJvXPo3Eg0LUjHqUOFDR9FlLENP5IxI71uAorC015/7ptz4WmS41ZYcqI8DpLJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536305; c=relaxed/simple;
	bh=AOlEUuFoRqStqF64WcHDBrrCt7qGB6dC0+pelX6PHeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4jJQRJtJ9mjMzG3VoVZt+VKFumBntIpaOPn2KuTwPd1CWxn2iUGt164N8CCQ2+uqiM/PByNJwgRHJivc8vO084i9Pj/nmqZ5JOuLXGqUqVN5aiXagLE4iWJbIZChPQJ0FfnG5M+GpGNRxEBrj1YE4fgk9ADFA0hRinOcv0ZEAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+lL2enk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+lL2enk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734536302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3kbK60y/pUMEt0V0kvEsFvlsUJreh5s9ctQMUNyEJLM=;
	b=B+lL2enkkxF+T6Xjqi1ALgg4P+9kf2NlUuqalAQ7gDuVCC4ugcw1d2fnxSsnwsJEpl1jOW
	Yt3kwgUFeHPmXLAOyozzKrXzE1T/ibHXGmsX40ImuxPT4PCzAwpB6MRc3sp7N6hbrkvYhx
	I3iwI+qQGz+Cip91/YD3heG5hcDHstY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-mJWPtGzoOHWNuz2M7rIgIA-1; Wed, 18 Dec 2024 10:38:21 -0500
X-MC-Unique: mJWPtGzoOHWNuz2M7rIgIA-1
X-Mimecast-MFC-AGG-ID: mJWPtGzoOHWNuz2M7rIgIA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3862c67763dso2800091f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536300; x=1735141100;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3kbK60y/pUMEt0V0kvEsFvlsUJreh5s9ctQMUNyEJLM=;
        b=BfBAzF617QcL50Em+LjozM5CBx/b9miCv/YWFLMO8HPYuFeVmDcAXUr9tWBS5tf7D+
         dnIiJbPSJbE+cmNCMTyh066B6VLw06tHDmO57juW49snUq8qJ/IOf8tl/Ij222UdMJHJ
         vB1O9urRy/6JR3LihhwYNVOti8yyQiSdoSP5TJyd3g3m/vwPkOOuA2j1T3NhJ06JjVpR
         JLDAVzvgHEhsAfeOBKpo/7LZhvXvSzVGWZZzLZHlFvbbUMOUXVoS8YKCEDA9zqR26euY
         2X5aFJ7EUv7z6WwsnJh++/zKzlxUia9bUka7Fu7V6/QVXEgflcYXhNqa5YlteoLGq6I4
         ROug==
X-Forwarded-Encrypted: i=1; AJvYcCWXS1Xf0mRVRyNiwFfAWvGYxQIuXBMD5+Zt7GhfUITczDEHi70cixRwRd8+fuQIMciVB8MPDm8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyAldW/MDcJRt6ZyOPpFkG/+azjvyLqi7Rvj8M48g2PsExNofo
	ktTOe6R0m/HoLFSpFrXxUyhnnQn5/6JQw43r53Q/TSpCKW95ouHbYUov4kHhR8yHFs40PfwF5TK
	keEJAor2nHW04BMjKvrsyDyt+BHAe3u1NmSa+hawRasfB5/fr8XbsZA==
X-Gm-Gg: ASbGncvA0jvXY5eWX4CqVaT5ZiR4XhVqDFT74SQJjtIf50Megc2zi2hKm1mKNDCkKZj
	J5IgMj3YjcGaWlHAOxGYkx7sUGyuE4Tq/vCFnh9qENXQI2wT4aINnsPOl8Os4GOLx+4Yo3LRSCD
	NZv3njnXujf9FNkajL9Rfo/DOa++wGUMJ7zl4Bkt+H4DhoCu07jaAECiNpg5fMLvwtckXtj5dJa
	HIJI91CKt0qKShoLgJnwXCV0gnccB99++xsz8A29ntD1PfccB+TI3pLSQX27+20cs4+NZyVDWoq
	V4bH9WJcKeMZ1jSAP8sClsk=
X-Received: by 2002:a05:6000:1aca:b0:385:f4b0:596 with SMTP id ffacd0b85a97d-388e4d5e9a7mr3000677f8f.18.1734536300106;
        Wed, 18 Dec 2024 07:38:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaIBVGaClqVQCcf0GlKKl/+K/rYd0fvTMmkJPmKBwWs+HFfhrEAIJd6lLn5sqzfUQW1YJFug==
X-Received: by 2002:a05:6000:1aca:b0:385:f4b0:596 with SMTP id ffacd0b85a97d-388e4d5e9a7mr3000654f8f.18.1734536299751;
        Wed, 18 Dec 2024 07:38:19 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c801643fsm14360353f8f.41.2024.12.18.07.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:38:19 -0800 (PST)
Message-ID: <4ecf7136-e9ff-4eb0-b464-47356ec1adab@redhat.com>
Date: Wed, 18 Dec 2024 16:38:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 14/46] arm64/sysreg: Add register fields for
 SPMDEVAFF_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-15-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-15-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hc4xyQX13--_c4ySDDaPcsDPMdQVadE9mtrabq7fntQ_1734536300
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for SPMDEVAFF_EL1 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/tools/sysreg | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index fcb4ecd85d35..18b814ff2c41 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -114,6 +114,18 @@ Res0	63:1
>  Field	0	OSLK
>  EndSysreg
>  
> +Sysreg	SPMDEVAFF_EL1	2	0	9	13	6
> +Res0	63:40
> +Field	39:32	Aff3
> +Field	31	F0V
> +Field	30	U
> +Res0	29:25
> +Field	24	MT
> +Field	23:16	Aff2
> +Field	15:8	Aff1
> +Field	7:0	Aff0
> +EndSysreg
> +
>  Sysreg ID_PFR0_EL1	3	0	0	1	0
>  Res0	63:32
>  UnsignedEnum	31:28	RAS

