Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E5E233933
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 00:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790554481; cv=none; b=gMNXeLMlA6UFMRdvu0rEoPAlTlqONTlnjkk/wS9xcCq+wHSNr6cXCqEFc+bBxhfuZyPx/4VDGttGwB01kkiim2NZ0FZ2bJJry3RGuJp5ubAsgQp66YtfTQEm0azQXTVH8vllcEICVo6UVeIKx7+gIt3n/cN/sIOgUls8FyUjX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790554481; c=relaxed/simple;
	bh=IWNXAcTPuVoDpaI/S3Bd3QXcIjw/fAWvlfconBsmVgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9bRcu4dYXCcX6+v6AVVLX5zBm3vmHmwKeEcdN0zLoRKLP2yF/yRgYaOs8lwhP299wxrV8gb3SP12N2CWaYNzBiJ5Yn+eHUDvR/UE1BTRscki97qeHcp9lhxnNpnK7aK8bpINx009Kp4Ymvhl8dzBgJFyt5egw+JOwLyKyqFYtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbBgAn56; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbBgAn56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790554466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3pHPTXlsx3JeIcn/vypuvLo0a6E/wjvoL+H11fk+xgI=;
	b=PbBgAn564dLOz1h5F8N6agKyxL6Ei4tZK/tUoRQrSxj6Ek1RGEXthhVuIYzCXTtk28i3iL
	DmNPNK4N5EFj+2WLoWlRvVw19FzpvRN9T3jU4aiXOMB++VUD7lnvoJM13pdL9I9uyCr8jG
	ade2j2UZlYThTmddQW2yE512Tysbcjo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-y_8mvIjyPOybwBHRBUjMtA-1; Sun, 27 Sep 2026 20:14:24 -0400
X-MC-Unique: y_8mvIjyPOybwBHRBUjMtA-1
X-Mimecast-MFC-AGG-ID: y_8mvIjyPOybwBHRBUjMtA_1790554463
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a0bce9739bso3439788a91.0
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 17:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790554463; x=1791159263;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pHPTXlsx3JeIcn/vypuvLo0a6E/wjvoL+H11fk+xgI=;
        b=pzdal6PAY9QZN0SgCmj6x5U21U9A2forbbmcykJydj5fi/SaUk+Wv6VAw/YVFzk9so
         yhGOJr02cpWoAAbpfTph19d26gLnQ51OO8ljIux0xfOMsP/s9PZapyng/b7vT7iHke+n
         yreoFvOF96/XjwJYmmWZ4a9jRAWqHpJdv/0d5g8/sG8cbkGz4Z9+aXYlLkeIbAmbt1Iu
         x91Csl4F2KBKZxybDd8OtjITori/RIBQ29yRpUUuJ6RdvlnQ+ZxNdKrYXsgHbaKs45ax
         H7qETOSsJVqDxxesoC6GnQLbjntxJavVhyYarBXtgliibbhZlpq9plZCCurJT9/DluVc
         a25w==
X-Forwarded-Encrypted: i=1; AKwUvBx5kbKxy0JWiioTpsjlqqkYMg6biKZtEEzpGMSBgJJbqfhCcCPsmGA4yW4rEkA0EclH6WuDAEo=@lists.linux.dev
X-Gm-Message-State: AFq9FYKIXSW2EbXZY/VDfMGhaH6fonYXz9/NpoCzYX6vqmovIDiDvVTW
	PeFWs4GtFiCavRDTyM5FZuLD764QoeA0I+I97JOb/tL79nHb6YSpDoCbIZIYJNhwS9YZbXmWjEq
	K2NSzvoyf8zMxU0JKFGwuFj0kVenH9VLDbsxtp4TLWiI/8xBfp7PrxUpGBg==
X-Gm-Gg: AYBFou1VkVSzgTLHNF0x6VbvvrlOYP37YMEkF2GMKGCimnjhQIBAc3JOgkDdM6TpJoY
	nHVMQVRFzz3qxc/+qW5Qn6HKg9+lABemteSSXyHC7g3FxUY1gNqJ2VYMZmLCetkMrCznKUHgEJy
	R14Xq0QB5orG0hHxZT3KVOGeC7btmQSc4c1QirmuYF09yNum97Jf8vngSWvDnLQz6XbdgY7yy/x
	aWBeQvM8B8UQrzOzI8d/pRVMIOJrnG+VG7YCsali2vmbVnkoQrQ/Bhb54JWZptz3IRNRMC6kerB
	OshBb1QNrl7HGMCqF6yhBExupaX8vaF9Ro2cd7KI3CO6KAoF2rfQg+HKQEcX2zlCPFF/SMPqNSK
	64B2hlVOc/nNCfTYPAjlIdIs00RniIjxZpNoaebhVMA==
X-Received: by 2002:a17:90b:274b:b0:39e:6ec6:f4d0 with SMTP id 98e67ed59e1d1-3a0bb553222mr5783314a91.8.1790554463436;
        Sun, 27 Sep 2026 17:14:23 -0700 (PDT)
X-Received: by 2002:a17:90b:274b:b0:39e:6ec6:f4d0 with SMTP id 98e67ed59e1d1-3a0bb553222mr5783291a91.8.1790554462940;
        Sun, 27 Sep 2026 17:14:22 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0bec30aaasm16424179a91.15.2026.09.27.17.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 17:14:22 -0700 (PDT)
Message-ID: <5987866e-92b6-41d7-87a7-ca1dee2647af@redhat.com>
Date: Mon, 28 Sep 2026 10:14:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 02/20] KVM: arm64: Disable Steal time accounting for
 protected guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-3-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-3-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wV0lAWzxEJ7oCkzQFJocgs5gMVRPboHJYF8AzO9LAdw_1790554463
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
> account the kvm instance. Even with that, a VMM could skip the CAP check
> and proceed to configure the PVTIME as we don't do further check on the
> DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
> possible and catch things early.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/kvm/arm.c              |  2 +-
>   arch/arm64/kvm/pvtime.c           | 14 +++++++-------
>   3 files changed, 9 insertions(+), 9 deletions(-)
>
Reviewed-by: Gavin Shan <gshan@redhat.com>

