Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB731C862F
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 00:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294625; cv=none; b=is9/eEbOG1zDtRo1at6cYg6vfweLmt3jyW9Ppbf4urDYYa8/7tpKsXFDvhGR3dZtdCK2kNvtZMFxrJTsMuVw2k0FuGUHxVSPt9tJLoE2Q/P78l7SiIfBnFsVtXF31kZi5NCe8lPzJ3/c5KQtGZem8kt+wAm5kxRMG7y2aDA6J8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294625; c=relaxed/simple;
	bh=58hYY3yihzi3KN5FnXcSkwBcSphKQIyF6se4Nsd8i3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TEadnB9vEy7swTcYPJYjNd9yff/PUGs4+ZhWjeljNzkvvYKzN6dDgZ9qMb+7ebcnlyrQIjKVvSE9uXXTNPu9bG8U/I/DJweQdP1GwGBtafWvliNIqIrnXxcGbsGmYFIWtnaRxm2qutQIBQet+ArzSGyYls9yOlCtw+qZ7kbjs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HL4/Ucuu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HL4/Ucuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790294621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwFdRAn9knyJ21BVNTcGe7areSLJLdB+xLeTWdZf3T4=;
	b=HL4/UcuuX7TcUEaMwCZ2G08ZoWPsnw4N0MrJwJXMGBC0+LurNmnS6FAqLxNGFoEPXAqrwX
	qCH5M1gCNO1oa8fG47CQkrrczS86RL536TGgFIdI+i2paJI5GUAysTrPbVlOjeDgIruMop
	0JwuUHCkPEsMcC+GXRGSkhrzBHRKy4U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-gcLb1f3JMMyXQC67704Z0Q-1; Thu, 24 Sep 2026 20:03:37 -0400
X-MC-Unique: gcLb1f3JMMyXQC67704Z0Q-1
X-Mimecast-MFC-AGG-ID: gcLb1f3JMMyXQC67704Z0Q_1790294617
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e3f521346so397250a91.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790294617; x=1790899417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwFdRAn9knyJ21BVNTcGe7areSLJLdB+xLeTWdZf3T4=;
        b=CUs07RJf8IHp9/qQKBQb5rYHK7ZWGMD0oWlNOiE24ez9rHF/CtpOGdpzOaw60XEKZA
         A3t0xe6hgJEOxcgXR5olsjdEVjJ4r0NvL0VLPO7KWZlfgac76GsNBqMOV+AnFhiZs583
         6DkGiZz6A2w4iEE77etNqdkPi6aSNXYzyR+VxaZWhXe9FLYXj/2QttGVFHexdKDWKSbv
         ugNgCu2BmLdcRy7jK6gli7+p72GIsUmBb9lQ0ZKkQJWWnMs+TsOcz7ISmocYs3/Hce9s
         sn8Dqa0uJQYix4OvAVqqhC0oBtWBFwDvG/BWyMc+aaOiN7QquvL5FeGb/T1Bydk0SG7U
         AMig==
X-Forwarded-Encrypted: i=1; AKwUvBwlFQUP67BXmBrpH05Yp7hcVhBTu0hgrW1izdjJh9KYHmTJijuAoqRy637Q7xZKMr9ZyGu3sLg=@lists.linux.dev
X-Gm-Message-State: AFuF++krxfj197xgjUIZumaybPQ3UqTTTq+w8HZ8INoiZpLlUMiIbVoC
	OQFLsq6rZtomzLHg/pSkZcclPQDbO0dEPK6oNsq/OO3a7OhciiHNxOPeqoS878PhqbKOlPGfpPO
	X1AxFn7jUvVDggUu2uzUT+J2hii8eOP9V7Z8o51mVJyMk6fgiyZvBrUkA1Q==
X-Gm-Gg: AYBFou1yhFs2bze1Z0fer6BDGC19BLI27HUjaPyCY9vamiLA5cBRgoqHI0Ilxct/lnR
	so42v0xyRGFZC8yaWp6ifOOebwJeU0hiiB4SOUP9w91oWZ9JPVlmISiVPNPT1515lZyuuDsbJH7
	WW8sQkToxfqpOq777We8wYyKty/NV/bYrFB40MJY3WE0X48Rwi+ZcLw+GbV7EXTaTNyl0fhodnF
	EX7xFzq1MMqIcp4IgDQVKqZSEp26Z41/6wjAl5QCxzPDvl2n1w3PR7Uw5J3B+PcbG+cnx5oP6P4
	QtD28ukTIHChYvNxNA3bXa9G7WJHDCraHogalhqgXaZBSpYmLk4yugqR4QbQBPz64Dn6oMlARx4
	DWwj3r9Stzeco3kjft+slldZAtFnuMUpTvkN1NGUlKQ==
X-Received: by 2002:a17:90b:4a50:b0:3a0:bdd8:fb11 with SMTP id 98e67ed59e1d1-3a0bdd8ff40mr225055a91.66.1790294616798;
        Thu, 24 Sep 2026 17:03:36 -0700 (PDT)
X-Received: by 2002:a17:90b:4a50:b0:3a0:bdd8:fb11 with SMTP id 98e67ed59e1d1-3a0bdd8ff40mr225029a91.66.1790294616280;
        Thu, 24 Sep 2026 17:03:36 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976c8f8dsm7318263a91.12.2026.09.24.17.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 17:03:34 -0700 (PDT)
Message-ID: <cd2d60d7-fd6a-4f61-ac94-2190d364229b@redhat.com>
Date: Fri, 25 Sep 2026 10:03:26 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
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
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-4-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260924135201.850038-4-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZoQNgWSLO0fdQ_t1TvOmT2EyUe38BLfLf3jpusSA3Ss_1790294617
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 11:51 PM, Suzuki K Poulose wrote:
> RMM v2.0 brings the ability to set the RMM's granule size. Check the
> feature registers and configure the RMM so that it matches the host's
> page size. This means that operations can be done with a granularity
> equal to PAGE_SIZE.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v18:
>    * Move the rmi_config_set closer to rmi_configure, drop the comment
>    * Use __free() magic for rmm_config object
>   Changes since v17:
>    * Move rmi_config_set() out of the header file.
>    * Print the error message for rmi_config_set if it fails
>   Changes since v15:
>    * Actually check the feature register for the host's page-size support.
>   Changes since v14:
>    * Move the implementation into drivers/firmware/arm_rmm.
>   Changes since v13:
>    * Moved out of KVM.
> ---
>   drivers/firmware/arm_rmm/rmi.c | 70 ++++++++++++++++++++++++++++++++++
>   1 file changed, 70 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

