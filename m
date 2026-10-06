Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D382DB7BF
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256236; cv=none; b=bPedfMf527i2d8ZWtC2AhWFTicSBLNiFrvdV3eFPt9Ax+62jA250XPQjF8vuPumM25JQSbf0wJn7rR/c63HaLjdOVMCbnyzU1RB6LTBbHU7Bi3ovcfvn5vsN/4vPbmUEbaCJvA461zSrinwIHCvzskuJ1aaMrvD2gcx7pc8conk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256236; c=relaxed/simple;
	bh=76WpONBN9qNsewPTXdIKmJj1yYZGsKR8SJ9xH6J+4Rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEn3jym0BFieJtH9NMUnX8fP4r6W8+T++OqXN+QHHqizQmhSvcGc0gppMSLRLb7A5UP6BTbZPwXvZvBJ+MocxHbseAH/RAaNUm0LGE/EDd/hx7Qi6Xa6rw+PMBuqACN8IWFM6Xmfah5VgNKTyLUAIztoMZPXhBsGJyX478C4BJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YuRrdDRE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YuRrdDRE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791256233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NLjBEqzF3bLvG463L+dBKbw7TfCoymi8l+jbKvUBXR4=;
	b=YuRrdDREoZ0OmVjroFprv7kY4F8AQw6a76xGpRKBILkoDumRgOvXUH3H45hYuN8xBY0Cr7
	Md7GYXgXDbX9iJ4w9wsyMNROWyYptk7ELoF/bPmGnOszqHNH7DtMCfXdN8yb/bzfW8LKfc
	vQXrDPQ/PQ/YUjVP32DZJajkYS2kvCc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-HMWyacS5Pi2dRSLB5N0EsQ-1; Mon, 05 Oct 2026 23:10:32 -0400
X-MC-Unique: HMWyacS5Pi2dRSLB5N0EsQ-1
X-Mimecast-MFC-AGG-ID: HMWyacS5Pi2dRSLB5N0EsQ_1791256226
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a46f0f158dso616944a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791256225; x=1791861025;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLjBEqzF3bLvG463L+dBKbw7TfCoymi8l+jbKvUBXR4=;
        b=EOOqkCZixWAl1I5G7jCHMmCjmJMD3CEEwmE8ae5+6a76NqT3b1RogSWO+zTqIGJNTV
         250pPLLAK3Mzu8vE+r+D9jEHRWzbmm/CaPKasatBkYX7t5zgrLz4qummykWtZcVC6gyk
         Qw0w8iYuNrhTuMyNelj6Ul2ZxJ2izVE/4bNmZksvXeB4pDNmmysNol6yjXn56VQCzfTm
         nKhbNPind0ZyCDGlAIebRUFJn15p3O2CKUhV7u7dyGvYYckFoaJVG4/1LqmGsrW0fUH1
         Mddjg/zVcx0FkKl+ALYdI+a0MxVThEFEY8pCBaspkw1lttm8sTJl9wqRSX4ZbgjEcWZj
         2M4A==
X-Forwarded-Encrypted: i=1; AKwUvBzePnygrqfX4Bx1hhZ1BWozYgsk/4SgNQiyn+AA/sl0DMjbU7dQeRsQS3QNEfv9U17jXNEGI8Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYJu1SlLCNQpcOWu8lzW/lXYJTLw485QPv9U8M8R7GYgWePXANHB
	xnM4/Yp19m4grNjc8RCkzK9PGrCQhd32DR9I95Re5QnbVFl8ZPn74KzkUCg8LNNdgapof0h4dz8
	muoFxlX6Czgx3K/aGPEEuRFgE6jsgQLmcbnYA5l3LTXm3ES17QuvLrcfT+g==
X-Gm-Gg: AYBFou38wdC+VQOskfoBlAk1wGwDYQ7InEvXjrgyuyKCAlOup6FiY5eUL++BgBff3Gm
	OIEYIa2Xk2vvq3NYd+LIFBaFb0DgIduriTL7uWBh0irlcvBF+ZoJ4jJIuSxn+PGGznskMBXP/tS
	t1z7sW1pj789ccki+RMK+Nv9DnNRt1Unat9woOLOS9uE/whc/9qWjoAis9aDmkAyOIC9UAVTKtF
	kd4X2X/QcaD/cgx1yNEx+P3gJcGlhofXaQQLc4muJgEtihsqmH20LsB8WJOV9GtDyLCXVl3WsVN
	PonNwgCOBJXN5IYkmNZRKKYxxqrRsmGfUVVSuhAWfiJWET164uvljpXs7l4rRYLcU2SeOUoNfse
	JDSBYkOax4TmUrVOYtEoEAIxHBQRVQ8tctFlX/ogY+w==
X-Received: by 2002:a17:90a:d64b:b0:3a6:d2ac:74ce with SMTP id 98e67ed59e1d1-3a87368d0admr19249a91.19.1791256224582;
        Mon, 05 Oct 2026 20:10:24 -0700 (PDT)
X-Received: by 2002:a17:90a:d64b:b0:3a6:d2ac:74ce with SMTP id 98e67ed59e1d1-3a87368d0admr19217a91.19.1791256224127;
        Mon, 05 Oct 2026 20:10:24 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543b0c1fsm3110944a91.14.2026.10.05.20.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:10:23 -0700 (PDT)
Message-ID: <9f9575f0-be48-4dd0-ba1f-98d8dd39f10c@redhat.com>
Date: Tue, 6 Oct 2026 13:10:13 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 14/23] KVM: arm64: Mandate VGIC v3 for pKVM VMs and
 Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-15-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-15-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3TdvRouJFoAV37ARLTR456ZbgEpzZap_KSQb-vsyh1c_1791256226
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> pKVM does not trust the host. Realm VMs follow a similar trust model, with
> the Realm Management Monitor owning the protected state instead of the
> host. Add a helper to identify VMs that run under a host-distrusting
> hypervisor.
> 
> Use this for blocking ioremap of vgic-v2 into stage2 and prevent creation
> of VGIC other than v3.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 4 ++++
>   arch/arm64/kvm/mmu.c              | 2 +-
>   arch/arm64/kvm/vgic/vgic-init.c   | 2 ++
>   3 files changed, 7 insertions(+), 1 deletion(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

