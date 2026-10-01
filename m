Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE57C28B7EA
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790890911; cv=none; b=AGo3YuVR2ndLEihDnqw0FTe/8Ehc1atQ23iBlfkJ5GJ28ll15k1RNrWRNnREdZKPoo/RlqA2xxCkROYUxLiyS/czjBjWobXP8Di0fJC4WsdRtrHVAOJ9vhiKJpsTGBstbhGK7wUIPjzGBKeEjj3iJso/FHtClAW76vSLIbLRFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790890911; c=relaxed/simple;
	bh=fPmxCx4qpK2t/MvuNp/xRsfzossr1PfbTfKiv5o2cf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7dk0pgrSetzho2wjYRO7HVI2flgz8o3s3lrSL9b+G+IHFtp6G+8vaVkqvKiUfSBWzN9rM1fTQ01KZf22GzHF0rIv0Vy6QT3ddEOPMVoSTAlr4NzFm9h/p6UUQ75ilVdFJWSagtXZQuhnK43RC4L3+ms0vi/bW1qkyzsjHK4zPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RX++VI9A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RX++VI9A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790890908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oaFDnLPAu8Azz5pGOzAaVOnZU0E7BdpohXF2E62Q87s=;
	b=RX++VI9AHz5vfn1fXYGsJfzS/rX7vXXI4rJuNUvFppKhaITyoLWRLw9omTUWXFJST5ZtyT
	mzBMzz7ee/JK7/G2jDNF5l+9qMnoyP8PF8+K814IJTwbhBTnsXywQEQfl0OUSmG/d/W+XY
	7zdvy1hQhQgvTfOPZ0H2mdJOnWcjwvs=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-STqGzqHXMwOU3eUzC4_OHg-1; Thu, 01 Oct 2026 17:41:47 -0400
X-MC-Unique: STqGzqHXMwOU3eUzC4_OHg-1
X-Mimecast-MFC-AGG-ID: STqGzqHXMwOU3eUzC4_OHg_1790890906
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88078ca8725so2525138b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 14:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790890906; x=1791495706;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oaFDnLPAu8Azz5pGOzAaVOnZU0E7BdpohXF2E62Q87s=;
        b=Evgbt153OKRhrbjOzxIJ8x6x1wlM6kCkmtA9KAlOsCiKBKie/UOuNd66gp/jSHlnUu
         V2WwUd+yua6FNFaMp0MjA0yddWKeUq574idQInSbY1to9kdZZrnxT2/Z2YuHKasesh2C
         t69YnSTsvLA5TT2A4x6NVma8DtqbVQF0M4ucqF/ZwSmwY/doziTtUquHmxzyQQJEeSi5
         v6ZIjFL6qI0LqSZa+GIZA8kGCG9R8MjH+i9uGtQM+ShNlSYFGbJla9MccO+HJM/SPQ/m
         liebVG8CEBUbqKPuoIkWWskmyAbokGWaKXCw4dAmxE0jJCOtTjDAUFj0z4f2eXi3276E
         ED6w==
X-Forwarded-Encrypted: i=1; AKwUvBztYNBkLnHqvH+zNAXHpMrSWHROB1HHdSN7xchMREMCTwZ/V/AwwxUWFOGwX3L8SGx8Kh69XAE=@lists.linux.dev
X-Gm-Message-State: AFuF++kQaUQN12Vz4qfb+svMtxjyqxBGC6tcGtTDIb/Z7JMcX79qIVWV
	mlJfRc3pEYv5gBimsq2/3RRSEoHm/O46UlUJ8GgqQ/mHiSDKmSOYvCspFCCDAMKJkCBfFafBJDE
	2+z0pbrNSJBw7cJsqzdYbPPrzvjBIwa8dkFk/I7qXxpqlPuQ9GcYqrSK4Aw==
X-Gm-Gg: AYBFou0/SKzyta83mz3C5MfMP58ax+C00GQl/WNZs5hhfOBM5o14v60pfhOgORvrDJi
	zSUyu37YK/v3KukTmfy8IXrPVImqXQf552lhWdROGOz/j5Ov21u4er14szMFVG9CDJy+nIK3Kt6
	t+r/Vz5PPZCw4CPZCuFo9ElGb5eJjD1oKNL+/dOLgrFnYeSbJbwmNCbjYXEXgwZaENARIns7YBP
	ClxqI92BnsZzSI5MpUh/QbWlw1GW/b4qLUH4EU6srtKA2MQZioWMjI56vRiYZQHKEVbbQVMXQ8D
	EM1XK61vJcIKkxjVzGMz5+KMU3/HomiEEaPp14Bhe4i3CMrtyamHCLuQF5hXEYXpuLixahd+cBO
	tBek4AOHbr45pUgLtq43ufYjpoHl/b0efCShm6LOqvQ==
X-Received: by 2002:a05:6a00:409a:b0:882:1b4d:1840 with SMTP id d2e1a72fcca58-88af58d4e46mr745873b3a.24.1790890906229;
        Thu, 01 Oct 2026 14:41:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:409a:b0:882:1b4d:1840 with SMTP id d2e1a72fcca58-88af58d4e46mr745848b3a.24.1790890905746;
        Thu, 01 Oct 2026 14:41:45 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0cb72834sm165561b3a.45.2026.10.01.14.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 14:41:45 -0700 (PDT)
Message-ID: <1ed590aa-a4bf-4980-82e1-185aee205909@redhat.com>
Date: Fri, 2 Oct 2026 07:41:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/23] KVM: arm64: CCA: Add basic plumbing for Realms
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
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wDCvmjVXqQZmDTL-fjKzCnLaocHF29-TQkDNqV6aajg_1790890906
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 10/2/26 7:06 AM, Suzuki K Poulose wrote:

[...]

> 
> NOTE: There is a conflict with Fuad's patch to drop the WARN for unknown vm
> ioctls, that is queued in fixes.
> 
>    https://lore.kernel.org/all/20260914093838.1082637-1-fuad.tabba@linux.dev
> 
> This series is comprised of (3) and (4) above.
> 
> The integration branch has been tested with the following components:
> 
>    tf-RMM:   main branch (commit 5e6e2acd) compliant to RMM-v2.0-beta3 [4]
>    kvmtool: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git tag:cca-kvm-v20
> 
> [0] Arm CCA KVM Support v16 : https://lore.kernel.org/all/20260803134403.80630-1-steven.price@arm.com
> [1] Linux firmware RMI v22 https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/fw_rmm/v22
> [2] Linux GPF Host  https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/host-gpf/v19
> [3] https://git.gitlab.arm.com/linux-arm/linux-cca/ cca/cca-host/kvm-v21/integration-v3

This branch doesn't exist. I guess it's "cca/cca-host/kvm-v21/integration-v2" instead?

> [4] https://support.arm.com/documentation/den0137/2-0bet3/
> 

Thanks,
Gavin

