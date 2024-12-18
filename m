Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C435948
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734536682; cv=none; b=tbyAUBu6wI7RKMShEAjg6+4BwTefXLKa4k3XoByBsJOunaOeCqVlnfNWt2zuWNn7oZE+W+RuNNx5e/ctTYiG+o0qAYB71NvoR2xEJxYesyc5bM35jCuYXRdfRrC7KmPEUZyNl5xuekPkb2LmjXClk2Qwyf40pvV38Sjr2vuv3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734536682; c=relaxed/simple;
	bh=YFRvb8GgIZMPw0TwvQkBSpHl51MoB92w6NQShR4HO3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ia2glb2hqRgT0tPavC+EKS6xuS19u0mbebZDO1ARIUiMq9IYkuZub9VoU6J8wU+c8mW5nyAo0EA2bwv5EBZFYYmwq9lfqJCboGbuKtYEFO3roOKexchK7BQ03TF53yipyHNswActOK1FUCCNdbGA+Gaju5RKabWxqzGi1+MRP+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xb+ub4S1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xb+ub4S1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734536679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C3ifdfTGR5Rf0e/AlHAnHM95LFu2ogRCoh2wTPFdlPU=;
	b=Xb+ub4S1FKyBv5c1ykU9C7VI3NaPBybeYA+/IMZld3q8v990j7HgZEAA6Ve24Nk8exM1FF
	l3Xkr2RnW2ekB3Y5TLqODxpJm9aoWvDN4lQasgIrPN4/8X7qMyT9xYdg31ERNGTFhYP3zP
	t5ze0Opb00vpJcw6CDYN+q4+mhcQFcc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-Di_BPVEiN5-rwvd-pILBGQ-1; Wed, 18 Dec 2024 10:44:38 -0500
X-MC-Unique: Di_BPVEiN5-rwvd-pILBGQ-1
X-Mimecast-MFC-AGG-ID: Di_BPVEiN5-rwvd-pILBGQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385d52591d6so494856f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734536677; x=1735141477;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3ifdfTGR5Rf0e/AlHAnHM95LFu2ogRCoh2wTPFdlPU=;
        b=kd38ZnF0b/h2G4jG2xnkaXrfDtZRGGzswrdH6/qFunXmpqYQnXMfpz+/+c7ImlQx5Z
         3y+MGlvun1zwzciUL4OE2cKbEmgEAAX2ScviEqFGublteLTfyaT951IlDA2S9stytKnK
         jWYraQoiFAtjDUOU0ozD65hhQ5IehBiJmoXeMAnfVZemTJb2wf+mpbxXEsdeOV1t7bhm
         SLFgyWhPLc7xoiTBZk0Hf7cXkP8f63/lAg+L9cyeRDmj7VCQYPuhPIs01ULlulMDv6Os
         LGLdS4m5qeAiaMrBmwWbaO0Wm0A9ra5CJu6WzkdvpEVYh8+AcECAGLsXeMxKOopuBccc
         IlgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy0tuQIEfJD6TELIYFD1CGqybnwdp07cSVemEhJXE46+Xd/JIXZTQeKIih0GipHVOeLad3dwo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWCfJYYjrZh1iPsPVOTA6j8YJExAoydZ0DE2Rix5tHGMoKs11k
	8TrmBkl3quATttcQGAOVQKEUzBLTMOhehA6Na6wtEW4JUrLzUds7PjbLf+g5ISXX8Mod3TOjPNj
	yRk+zgCcQt8xkESm+aIbTLuDW8UwyY/rYj+NVCnx6Upcgz/Ab4KkoTQ==
X-Gm-Gg: ASbGncsfOaGA5f4CO6xpZZ0I2hK/OqCX67SfGtshU/wQRQsF+qgkWKGtHu7RM1oDIEY
	zY6osLaiCyghX6fHXKaHECmrkvSxSSoCoW8Ik0o6bh4fBxj5KulDoYX8/k6c8pro8EfHnb/SNNT
	682yMz2HpmE8Zm9/B9W5fhkf1jUhqhF7SJzcSklR0xHD+EGuoGVn8YGDXk9DelZ2rhfyvD4CjNT
	uoxj36heOVCjPi0MN2cUDx3pV+kpRa0JIEBcgGU49dI6cXjaY5JBQCp7TPO/ZK5+CuZnor/hcz9
	nOBbf0vsvPxaoR7CmCVghRE=
X-Received: by 2002:a5d:6d8b:0:b0:382:485b:f976 with SMTP id ffacd0b85a97d-388e4e3d357mr2818106f8f.15.1734536677329;
        Wed, 18 Dec 2024 07:44:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkzdf4fxP5M4SPQuoo1R6EBPnYIaLKjVKkyUcjnN78feNSRH+ROtspoppv94GCosu9QuzV+Q==
X-Received: by 2002:a5d:6d8b:0:b0:382:485b:f976 with SMTP id ffacd0b85a97d-388e4e3d357mr2818080f8f.15.1734536676943;
        Wed, 18 Dec 2024 07:44:36 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8047151sm14151675f8f.66.2024.12.18.07.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:44:36 -0800 (PST)
Message-ID: <196ef833-e3f6-4314-8448-7053850d3e49@redhat.com>
Date: Wed, 18 Dec 2024 16:44:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 16/46] arm64/sysreg: Add register fields for PMIAR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-17-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-17-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rxEQxEUpztWEbQbJvX5Ii4pMR1hf7kTBT_TgIVj8uOE_1734536677
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for PMIAR_EL1 as per the definitions based
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
>  arch/arm64/tools/sysreg | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e33edb41721a..ff09da6c0b1e 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2349,6 +2349,10 @@ Res0	63:5
>  Field	4:0	SEL
>  EndSysreg
>  
> +Sysreg	PMIAR_EL1	3	0	9	14	7
> +Field	63:0 ADDRESS
> +EndSysreg
> +
>  SysregFields	CONTEXTIDR_ELx
>  Res0	63:32
>  Field	31:0	PROCID

