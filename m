Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B91C3594F
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 02:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444492; cv=none; b=YKNYlfFDxkKgEEghWyIcQi/4Z3qH2tAPsXa+dVm7pvklMX47zqKBoWR+j0eFRYKS3kVLKmniiD8nT0EBy9mZrwme1GT0tGBQ6YkaIVhJ8rJTvZHacaihX++g34Zj0k2NeEgfdNj/ZoRJ5GRNMo5Gs0/CD8Xo/DjnOLpN4k8tvlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444492; c=relaxed/simple;
	bh=3XJ0E0t/lrfTXBaQBUSLvzJGf7lkABcHmUz+xpXmHDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgfa8vLa3Ir9nFAHEgfQDGq5NE90awa3RL8FU0jfvZJXdM/xkL9oD1g8OMTwFd4KlOBzXKtQ2pSKIEi4HngSkYLR38Mph6zJEtkH2lADtHvb+lfO7eMuPBo1TuCl4X895GeqlyLaBM2hcxwI5ns5N5mT9WykPDmxRYnX64i/LP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PuZ1e4sc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PuZ1e4sc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768444490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oGiT+gTRHW6+vyeX/7XbiXkh9SWazVUy4G0tzPiSMOI=;
	b=PuZ1e4scztXXpI3Hm6GW5OP350bHorgC5IXyktiGRx4ezYN2YOvpNk59/4aRE14nh18uEH
	DKHA3vwZhn4Pyi5yRLYs5jVlp7JPoyCzEbB61MgmF6Ro9jNmvRUWGIfvT5veP5laJKiKhF
	vDx43yJIMLwqs9rze6fcctp9YFROdz8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-A1jtMQA2OJy2B70dmERHEA-1; Wed, 14 Jan 2026 21:34:48 -0500
X-MC-Unique: A1jtMQA2OJy2B70dmERHEA-1
X-Mimecast-MFC-AGG-ID: A1jtMQA2OJy2B70dmERHEA_1768444488
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7fc82eff4adso355239b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 18:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444488; x=1769049288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGiT+gTRHW6+vyeX/7XbiXkh9SWazVUy4G0tzPiSMOI=;
        b=wU+gHfBOfnQEJmgVWMaO20Tjz+W/r+xdr6eVv/EO47dEg7NUbrpWvY+B7Brp9ce271
         6kwkBG1ZXns7UKZAsOyjhsBFo2DtyNEb4VXMOsUyRPWOHIfIlZgUjVpvFlYa441yuM/L
         kHiNeAPr7PIM2G6vPCHYRnbykxmeAa12bMMIgJv4YdOUm/y2TVEjBqE51/oDVUpedkWC
         8YqrZC6hi6hiUI6Oy7tAEBM44G8wLMK52ClQ6Xo/Lq0KKFAWJeQH/spFF3hUh0Shoj5d
         6nXVTmxKy5idng82+HZII5kzEeGinzh5WKLL5SRVFt9/axyCD1gRaqG3gYncvOlz8fl+
         NotQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbME5bH6gFSUlKj04YMO9hGFFG1sc+mZ0tdiATzEkUAAkd2aT/V3eIVWzl1ortb1ZkLn+bbBg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7BN0+qm4UAaFxNA4ThSlzza1+zST7xBW3W8fN88N97fYXzUFc
	RvOByY7YH/Rv+lIPEJLmXzS3Jar7aQcvyYfHeYL5Zt/RVKlWxCtGoqlHHT0WpeSVDGd/+hkc6Ix
	zSJgxU8Q/Pcm8bhUtKbkYmm20Dk87kBjkIhUOuNELznRFmgs8B8JTF7kNqA==
X-Gm-Gg: AY/fxX7T7taMqTjKKhcmrxIkgHW6Sy1bHIaB/zgoIMWU8RKRyY4m8Um8ICZJD4No1vA
	iDOP45F9BY2H3GB0TqN/eNNQIjdfwZKk0z6G90W/8w17HVKH53pczYioWKxqq617IugrNavrbu0
	mSxhGTOveAiLIOEVEu7iWKsTiBJ365RFeIMFTuItcjA3k3FDYAKlhdM19RyZikQdSq0QqjU+zZ6
	3+rbhXQuIT31rZCX+Dgn7gZbtFtuasT5JSnWNuqUbk6PozaRBJBk/wovtbWYgf42MlMSQKXG2Or
	TSQ7tOxI6jCCnfSJxmW6vvTfzhtGP6kb0DwOFV5DgF0n1RxkH3wlPUY6AeF4JtGXk6+03SW/lJN
	yh9uCpUfMZ5E=
X-Received: by 2002:a05:6a00:1304:b0:7e8:3fcb:9b09 with SMTP id d2e1a72fcca58-81f8f187df0mr1395835b3a.31.1768444487900;
        Wed, 14 Jan 2026 18:34:47 -0800 (PST)
X-Received: by 2002:a05:6a00:1304:b0:7e8:3fcb:9b09 with SMTP id d2e1a72fcca58-81f8f187df0mr1395789b3a.31.1768444487478;
        Wed, 14 Jan 2026 18:34:47 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f8e6a71c6sm821559b3a.63.2026.01.14.18.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 18:34:46 -0800 (PST)
Message-ID: <f1ba964e-9d52-4942-bf31-906b88dfc87f@redhat.com>
Date: Thu, 15 Jan 2026 10:34:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/47] KVM: arm64: Make MPAMSM_EL1 accesses UNDEF
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
 <20260112165914.4086692-6-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-6-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3QguVUeV2Tj4p47RDDDAcpNkPN5yEsRQWH000MeT7M4_1768444488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> The MPAMSM_EL1 controls the MPAM labeling for an SMCU, Streaming Mode
> Compute Unit. As there is on MPAM support in kvm, make sure MPAMSM_EL1
> accesses trigger an UNDEF.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Remove paragraph from commit on allowed range of values
> ---
>   arch/arm64/kvm/sys_regs.c | 2 ++
>   1 file changed, 2 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

