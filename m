Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F081A267
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 02:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252942; cv=none; b=aKx16JylBgqJHMujij8XDhM3l9ZxcTYFyY/tPtP755OOjSniH5uvVvAIWI2hzn56ZirMdMz+DXciP9ALRrBFkFcgdAHD9Q++QT0n4I+UxqcWTnTTrF/iNuYUtHaL7B4TJsKKMy6GjjxYsDJ/7z4EobNfsXsInYOHSKpkmKjVSiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252942; c=relaxed/simple;
	bh=Sx7g8hsp4aXStbrt4GpenXWJBZXKZdDVSxLF4rORla8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NF/+DM+NQ+zPrADZHfg61+/DmyD7yDgWN55s/rSlMaHr0yD+KB/CUxY+XFoZy6Pt2cMzLAMhGm0nyFocoO/s5julI/qvIcR2BJfY96GW97jpM0ePFFTrDObACwk7Mir7pqlwtXn0SIZ41pL6UDgBBX0LBTz3Mq3UxM2Dt2DE7mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5WafGFc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5WafGFc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791252940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxIeuyPsGM6bXB1gP5y8RQMrIArazkFLfv1yfn+nqd8=;
	b=G5WafGFc4YOxYm28QAizVYszBFEn4sv1QLo7oCrIfdQc7/sRXo8JjaUU4dgWnF107SWaU6
	ycxNDdQ8msS8B0V+EJAgtMtWjtxqrBFeln8AYefp+0QSRBVgykGY744yeZQMuJyh8F4ivE
	lTmCNwD682IJ5DIsrMMuMqsujLf3Uks=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-Ki13k9grMbmLEZF_IO5nrw-1; Mon, 05 Oct 2026 22:15:38 -0400
X-MC-Unique: Ki13k9grMbmLEZF_IO5nrw-1
X-Mimecast-MFC-AGG-ID: Ki13k9grMbmLEZF_IO5nrw_1791252938
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-395543dc382so2321438a91.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 19:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791252938; x=1791857738;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxIeuyPsGM6bXB1gP5y8RQMrIArazkFLfv1yfn+nqd8=;
        b=vyOKhhGPNsQt/FPfdyqaQ5WMsidwODvD7rYezogiiGeKSYtrbR4eGylroz/g8l2wXm
         Z6QcYxm7qb8MujSNc8RS/75u1POzD4QvrH2aFCClU+JTln9UoPb8GZX/y1tQk+W8PyWp
         12cLmIvRxi4QVOfJ1tdfZDJ/lL6sHmS7iSpurw+StdTMGq8aX9c6iwV7X/SXB9hLuPF1
         tqadOKsSnivb84yhbxYZjZUjqYj1Pl3h1yi41UhsO06g1uEM+7DrzyGI7JEpqu4bn7Ws
         CuYsjeVzBm/dEpI4t4Y4JLEK1omh0RRfzJsB4eCEPCtuNERy+ksnIpLyX+KtjgOo5XrG
         Jrrg==
X-Forwarded-Encrypted: i=1; AKwUvBx2eZrwSZNu0eSp0+bDV7NHmAHWSzgpppp5wxv88OpdEkGpIIvcXPKnlXwi6mN9QIjwYRQ9LH0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIUcOtHUrRw0/s0d70Gjdni4NorgW/if53LyH4iCT+lCJCmSV+I
	c4uOII9SXBOOQbQh3PtacvwkGY7ATw1tCtDgx4zgAKqGtDf3sSPBy6+O2t1PcVjn3mVQGl/dzT7
	Sadf0hSoEFpVk5pCAuwROZpjopyB08QbGV53UFSTi/eAMsGUP/oHgt9XQ/g==
X-Gm-Gg: AYBFou2aZSzJf1eDTu7Oi+gs7SLcajNT91nCd3Z0o7rmeYM6yFRyXPKL1yb9e3Qpp2x
	76lOayUe3cha+fpmUMHUJvugTSidPb3QMnTKn8E6sO9S1uCZIceicLRIMlAn6svspfEPq4LPYCz
	KlBNnAIH9RAuU0EexwOh5R6LjwfW7a2aqC3LI89riSrfE5/nufEre5iwDP1dXu3SUzHo63hh3hb
	GKeAkghIHXkJ1Dv2Lvy3jVzCRPHWPYqHssQpz1dqcWVuw6frGpXPCNQjo86hC1vPPGi0BqThTkm
	JRcY8Fqk3o/ZWRMKo2/U1DxBlAcMfTS39GRuciqfRf15wypVL1aaE0tY1M1UkKWbR1U/+pPX/CP
	mNsZjn382IgR5GL6mbPXTQmrh7KdLqmE4EX7cJbk5SA==
X-Received: by 2002:a17:90b:3e86:b0:3a1:66fd:94af with SMTP id 98e67ed59e1d1-3a6ce7f67b5mr4922654a91.37.1791252937703;
        Mon, 05 Oct 2026 19:15:37 -0700 (PDT)
X-Received: by 2002:a17:90b:3e86:b0:3a1:66fd:94af with SMTP id 98e67ed59e1d1-3a6ce7f67b5mr4922621a91.37.1791252937271;
        Mon, 05 Oct 2026 19:15:37 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm5404856a91.1.2026.10.05.19.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 19:15:36 -0700 (PDT)
Message-ID: <0f463e25-1536-473e-809e-6a358f27275f@redhat.com>
Date: Tue, 6 Oct 2026 12:15:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 08/23] KVM: arm64: Add vcpu load/put call backs for
 flavors
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-9-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-9-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AivfIxPooO3V_tCpjV2AOZM9v7kh2VQWvh7BUHlWhAc_1791252938
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> Add VM flavor specific handlers for VCPU load/put, in an effort to make it
> easier to follow the code. pauth traps were removed from VMs running PKVM
> as it is a no-op for them.
> 
> Based on a patch by Marc Zyngier
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v21:
>   - Add '&' into the KVM_VCPU_OPS() macro
> ---
>   arch/arm64/include/asm/kvm_host.h |   6 ++
>   arch/arm64/kvm/arm.c              | 138 +++++++++++++++++++++++-------
>   2 files changed, 114 insertions(+), 30 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

