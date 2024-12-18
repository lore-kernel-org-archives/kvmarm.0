Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AFD1B425F
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734534709; cv=none; b=cSdmZB3F+Rxs5CFGK8ZoIjiRWYlXfeoNkLZVRdm/Gs3Xbt3WO6z24SI6dbVxzGl4yyK4Ty87FaZ9EX9VyWPfzdNl1OJA2t326W5eQYv75efP8SW6PoNe7isDlVUcaWynyV4e9FccfLwoJQBk7pcGFx0mT0NSqln+VXCC4/vM7+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734534709; c=relaxed/simple;
	bh=RtflLNw8wwkX3eJNwCNbOQERvYpK+oZDMVueO6lPkOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PmmW6sMBGCDMKf1mkVmJTUn5IZRGEoEh8jFUQimQuEG2d5eP+NroOMJ5Q1NcfT53jIXvO2ZsEbIEnnfo/A0Fd7CW2+mLGzJNfVfsujz2da/fc2MxyDpE0aDfn9yfoPht67X/AevszY9aI3V8EyOrKY7iYELP27qESCnRI3EafNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwNjdGsC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwNjdGsC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734534706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MUtnKQLrfLfRrfKGlctx27oDxF7G9rAMQsgI0XWA0dA=;
	b=TwNjdGsCsH4SNSajpitGnrKT1steLlplzN5tmxnnbjqHY+KRC88S8NPfhgalnFac58JBaE
	rvfYh6ug4wywsYRRh5V8wL00+p1Yor/nK6NIIQauCijZjZlpgo+kkjO9UgpYm4z6WvCjR2
	Zgw1kE/7I25XlOQW1ZgaEzjnx3KGQe0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-lrWXtzq_OIS_QKO0zEMUrg-1; Wed, 18 Dec 2024 10:11:45 -0500
X-MC-Unique: lrWXtzq_OIS_QKO0zEMUrg-1
X-Mimecast-MFC-AGG-ID: lrWXtzq_OIS_QKO0zEMUrg
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d88ccf14aeso120830756d6.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 07:11:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734534704; x=1735139504;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MUtnKQLrfLfRrfKGlctx27oDxF7G9rAMQsgI0XWA0dA=;
        b=oY7/1TNfDg9NJyg1czP6vkxZDUdAGbtSO5wls6JLmn0+nFhqZMU8KNNjDuqngY2ZIp
         GgDjivVCw933mGdpyy5Kj/Y/EXwKP/JTqFZkjmX/OOJpHgCdV9MjqqstpZdIRQwrzXb+
         FIVhrLE/ZvDhdqwLlR4HVwoFswskornpKOV25XJClzylOZo/D2qp8jLNlHIWx94ZYkAN
         1rN5THG3rezcrTicA1yKOyiHIZF1GLfNe60sMulp4cxNNLpB7nF08vo+4q/VLF+SOjGP
         mynKobEE4alip91DQC8O+p5PaaTNgCNxXNq/NLrLcalPKu7ExKENMrOJ3NcGVq3g1z0G
         luXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVRtOunkFioa9DRRNBZj+gDzU1fEhIbFUYYpLPAS4y5ZNeU4AEdu8bf2sn9zjj9k+60uz3Xhw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwkBwxIiE9/OHyOArGfmt7+t+67jPUsfKAJpflfHWJGvxN1kDoy
	fHF9/YzGh3ryjdZAwqj1iXb5H4+HnHlBtrwUnHYqCtUBIw/fHe2w6IjUGsSK5Eii8M7RsYSMvdX
	YCR93cQdX9T2+PC8GARnhCxGw3euk3k3z1F0bx1XvXQCo4PrLxa5rwvPWO6Xj0w==
X-Gm-Gg: ASbGncsL47t/6WUOzu1TFuVgESbBCqPC3nvPNH7A3E8XvRuoe/US63aR4j5PEkC4aS8
	eqwZMbsu4piYaA92GrkGG1+Bb39+NVGQ89GyFG9prlFu8HnQs20GbDUfndZD0IUO0gz36iKpB5v
	RYO9/y9I807VQZvtJUTTs0iJd1/zuUOQyP4HpEvPKj6tEy8cZn/69lPBH6NzYngjm2jdB1lIol5
	okUvBSg7PvnEcbs3cXhVMgGIUMuOXbJ34To/ksj83PrAdVqY3JRw8AKo+xGJi5MCNDgtGVAkjMT
	TDkmj8sp4IhAqCZ32Tz/YnM=
X-Received: by 2002:ad4:5fc8:0:b0:6d4:2fee:c27b with SMTP id 6a1803df08f44-6dd091db2e0mr52459476d6.27.1734534704612;
        Wed, 18 Dec 2024 07:11:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEv9VZAsXavLqKttfeD9dxe21gsPq9vvsGrZIzMw31wmGaL8NQWnX5hi1ykqI/y4qaIyV3JGA==
X-Received: by 2002:ad4:5fc8:0:b0:6d4:2fee:c27b with SMTP id 6a1803df08f44-6dd091db2e0mr52459176d6.27.1734534704326;
        Wed, 18 Dec 2024 07:11:44 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd3a4c5esm49752486d6.131.2024.12.18.07.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 07:11:43 -0800 (PST)
Message-ID: <8df1140d-5364-4979-b572-127067b18f90@redhat.com>
Date: Wed, 18 Dec 2024 16:11:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 06/46] arm64/sysreg: Add register fields for
 HDFGWTR2_EL2
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-7-anshuman.khandual@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20241210055311.780688-7-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E6c5kOCqGtQhD8ZWTQHxbAAlzuhBYnkELgqvwjm0o90_1734534705
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 06:52, Anshuman Khandual wrote:
> This adds register fields for HDFGWTR2_EL2 as per the definitions based
> on DDI0601 2024-09.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/tools/sysreg | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a56f7384d0db..1a7d8c03f844 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2591,6 +2591,34 @@ Field	1	nPMIAR_EL1
>  Field	0	nPMECR_EL1
>  EndSysreg
>  
> +Sysreg HDFGWTR2_EL2	3	4	3	1	1
> +Res0	63:25
> +Field	24	nPMBMAR_EL1
> +Field	23	nMDSTEPOP_EL1
> +Field	22	nTRBMPAM_EL1
> +Field	21	nPMZR_EL0
> +Field	20	nTRCITECR_EL1
> +Field	19	nPMSDSFR_EL1
> +Res0	18:17
> +Field	16	nSPMSCR_EL1
> +Field	15	nSPMACCESSR_EL1
> +Field	14	nSPMCR_EL0
> +Field	13	nSPMOVS
> +Field	12	nSPMINTEN
> +Field	11	nSPMCNTEN
> +Field	10	nSPMSELR_EL0
> +Field	9	nSPMEVTYPERn_EL0
> +Field	8	nSPMEVCNTRn_EL0
> +Field	7	nPMSSCR_EL1
> +Res0	6
> +Field	5	nMDSELR_EL1
> +Field	4	nPMUACR_EL1
> +Field	3	nPMICFILTR_EL0
> +Field	2	nPMICNTR_EL0
> +Field	1	nPMIAR_EL1
> +Field	0	nPMECR_EL1
> +EndSysreg
> +
>  Sysreg HDFGRTR_EL2	3	4	3	1	4
>  Field	63	PMBIDR_EL1
>  Field	62	nPMSNEVFR_EL1

