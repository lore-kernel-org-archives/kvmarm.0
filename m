Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A1D31F998
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256332; cv=none; b=JBQ72yfSzptZ9JeEx1g56ZleO03m0aiDubPOA5rdEq8rd6C2TvVMMzeHTkJh5ZY50Nj3PW0F5jlv+24ugu8OuouDu1DON0i9GBG7DnK8qMgd4eM6DDC7MomjcxAjuxJHeNiK49hPEoEWkCulWfq1jRQ0kGvtufasHNOZXI+zX8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256332; c=relaxed/simple;
	bh=liZcKA5xMSphCw/JtZIGkUglVkn1mh/BgOSx/JkJum4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phETGx5TAT5v2z82HZHzf0qBtAh1m+aDy+4kEHIRaNXuy5om/V1GXwOVOZxv0Rg8lBzjBf17ZWf3McZ6R8X3mlQKi7u2BtBo0qcYo7XYRipx/DRBWswsf9e2b6Laqd93/aoQQw2HmwoVvYUNyi5Gj52YlBgGeaJ4rjHKPigt1aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BswY/ewp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BswY/ewp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791256329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kHj1RXYmclP68lBct4KNIr5BPd6z8PeEquooINbDID8=;
	b=BswY/ewp3QQ0mo4EGVRlV1vA7OtrOaarA1RTwczJxfJKE3Adyg0tbbtUgQhSEx65zZuPmB
	CB1sjovwhvrE33jH48LLnQcWVLi3DOymQq3DD+hqzcxXN+KZ+c0G5z5XOuk8AYzHf50VD/
	ieeUJ9JMqUsEEsOpp/zgybjCZYMevkc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-UlFyFcIbMbCScc2Lzexf9g-1; Mon, 05 Oct 2026 23:12:08 -0400
X-MC-Unique: UlFyFcIbMbCScc2Lzexf9g-1
X-Mimecast-MFC-AGG-ID: UlFyFcIbMbCScc2Lzexf9g_1791256327
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a7fa5e0442so2361365a91.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791256327; x=1791861127;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kHj1RXYmclP68lBct4KNIr5BPd6z8PeEquooINbDID8=;
        b=HQCmeu2weSWHor0ovGYsOAzHLZcaYbn8vwcjMocb8+yRNj7gXhyGFYfsDVVbybmxYA
         MzvS8tj3nejaXD0fi0JHCL+wz6QBm+bnPY50HT94Gpvkq2CJWvOOduvSmaFmzbBKlNjE
         HCJbzUxMFD0LLv+QQSa2mYt1fLqyasfi51cNmvLddeo3IUeRzhoTCSkcJDvv93b0fKe8
         hZnJwnrtPtiuPaDM6e3AHNmsnzIRAaIHosLKh4pEAqYoZvis8qX4rFJ7VFVrMqon9XAO
         RfDZ9VK6LF8jiiW17jwk7cyvqwniCEtiJA+azfJevCuUASbGvEQ0y6Qc+CdGZudUuD/P
         GBLA==
X-Forwarded-Encrypted: i=1; AKwUvBzD+xUHQ63b2gq6T/Ll491UPztU8Om9zSffevPk0IAJ4WwAN0uhuQ1t5iQucPvP84Z4/ncpHFY=@lists.linux.dev
X-Gm-Message-State: AFq9FYK9Tc6HIAyWBoHJrcZ+wTEO9vuSXr0VeoxNtSz6IkNL3UzrsDYQ
	exBt2JFg3ltctIWTf6KSrWD4oe/VuP93xev5kjLGdLzl9fMrFkNGG9qvFtpL870+IeAn1prvriz
	aaX+txqdyM9Z68ctPjLuumI4IVHOiRFPtecKriPwbRsFDigWuzf5EB9wrLg==
X-Gm-Gg: AYBFou3qmSORuFM9LkHRHtR06Uj8M7T+LqxhGNiHIvq5tCr9NlGIr8ChIl/6dyCapyc
	s60i5IbhqnRFXDr6nRxLj040EY1C4hUAQySkvafilj9619fAWIlkPQEW6PBSK9HMTDg6NSIztEk
	cAeXeX9MsENy6e0A6Nx3NM8OES33kKgDKc/aQCqD3M0lSpZhCrYe4yklEa3rLzT1XS8KshVr/Jw
	GvFBQIdO3yH1RyDsZgbv4XWEq3z3dDhFVRVotBCnVOCslbiHCAEWP0zP0DPsO+p/xhQSeEWbRFK
	3Lq55OnfabPQ4yAvf4vPqKamioS53A/h8gSnRmqyF5cbJ09ML2rUDxAy0SAZmOwzO+iKoct6AIr
	mPWAUFlwC1GnYu1Cu0cFE7Ab13ZozQKJN4z20FW91lg==
X-Received: by 2002:a17:90b:2e0b:b0:3a7:8c68:6446 with SMTP id 98e67ed59e1d1-3a8737a34cdmr26431a91.63.1791256327293;
        Mon, 05 Oct 2026 20:12:07 -0700 (PDT)
X-Received: by 2002:a17:90b:2e0b:b0:3a7:8c68:6446 with SMTP id 98e67ed59e1d1-3a8737a34cdmr26405a91.63.1791256326616;
        Mon, 05 Oct 2026 20:12:06 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ee97f3sm15210795ad.66.2026.10.05.20.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:12:06 -0700 (PDT)
Message-ID: <6d290cbf-5dee-40ff-9ca9-af544fdee791@redhat.com>
Date: Tue, 6 Oct 2026 13:11:56 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 15/23] KVM: arm64: CCA: Add a new mode for supporting
 Realm guests
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
 <20261005090754.2140522-16-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-16-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YPhpMTNVs3RTqGlCUDnMi-OK7Qk-uJxGZnJ3eD0JtPg_1791256327
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> Add an explicit mode to support Arm CCA guests.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Documentation/admin-guide/kernel-parameters.txt | 3 +++
>   arch/arm64/include/asm/kvm_host.h               | 1 +
>   arch/arm64/kvm/arm.c                            | 5 +++++
>   3 files changed, 9 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

