Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDDE246788
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790554675; cv=none; b=IdZ0+c20Du3WDxIHgxBuGe9SPI58jeT44/NvaV5lFAbrdqHo4g0ltf5b2tHOn3doUMW0D6XRwpjnAIQcoZz3aGkcn6d7Oie3UGmrJHp50L2tlK6lC6RTAWzjrBtEXLiltdIPTusmLnjmskGzIcoTNZGvOLL3zIv1JVzWofA91FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790554675; c=relaxed/simple;
	bh=ifw+HzxZH0UaVzz+sFjUcHPMO+kHUsiZo7FPvHHz3Mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egceK4bITGpWpPm9LuYRZ9KwVjuMtGQWrxkIAevi6O+ivgFLBUPuorJRikOtjSmrjv9UjnbCO5c6whYPUYNCoygM1aET257gVXsnW/tBgWKa/nYggQUjVPFssRug9ddOLmlMPlxeKLgS4n2FoxCuzqLWg1S1U5SoCZp1YJbJGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BFAqeBTN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFAqeBTN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790554673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2m73jnLSddTXID/zMijmWEgMqVn35akPc9oFGshsowE=;
	b=BFAqeBTNvA0oPO8w5a16/g2OwWHe4lpQo11zmnLZxZy+veF/QwIbV2XHS1/D4wFYoEKqfV
	/8i03xM0d0vxq1B4rvVLRxwtyFkvO9KW2M4JXr77Egw9x/Buifb9uj6JZeErg9DruWdMKk
	j0h/g/kjRWztKZgJVzPkW7b1TuebXGw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-TSf8iftFNvu5wNbRcv6jjQ-1; Sun, 27 Sep 2026 20:17:51 -0400
X-MC-Unique: TSf8iftFNvu5wNbRcv6jjQ-1
X-Mimecast-MFC-AGG-ID: TSf8iftFNvu5wNbRcv6jjQ_1790554670
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86917d18a02so1953007b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 17:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790554670; x=1791159470;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2m73jnLSddTXID/zMijmWEgMqVn35akPc9oFGshsowE=;
        b=DWijZyYtNwma2rDwLSCsROvPXhaO3q5LhJOUekLCZaHCUnlWAOTbQ8DH/h7UKc72Qe
         334rGbb1B471D2HJZUpCkTvXSydZoK0D5Ji2ab+JtvA1V30/5G5XtT/5yNjC5GZxmBZ9
         OgjlDVvX6NN5JMHBMgWmA0yfJ1VYxNeA5QLCGqWKBdNNXQlyvzE6nrGAWmszb9cSGgjN
         BSElTC/QDPODPscUBneLZ49OE+vokepG3Ee4nOjbyDi3yyrNxOdFgAUYqshEC5DgyJQ3
         VEfKUyhWHL7sQa54jRfMAWa+fsVMEVG3EIN2Ce2aZHWy2HZGKAwdxN0+x79zPXskjGnh
         tvDw==
X-Forwarded-Encrypted: i=1; AKwUvBxwfxvBMl0f1LdM2mWzYV8Zy/tBHqU+97qRkDNkHC3CoJaAVWytFeBGuYa9ABPUxvqPtJxhf7E=@lists.linux.dev
X-Gm-Message-State: AFuF++nfntaDFTo8qKD/5zzeeLktUZnaPZ2YFF78NXmpN7ieg2n39zEi
	sL8V7b998G6zYzkz9/LCaJ+SUdz0m/2NnvLF1km9dD3+sJQbDAc5VKpQfvWcGEJEMYVmm8RGdGG
	Un8MSuTzyyGEn+d8TCHr0X7Bh+4Sk6vxD94JMq7LwjOVo15hS3d50UsK/UA==
X-Gm-Gg: AYBFou2P3ksxtE8zg+s3QyCX/S6iBCG3Yl/Bm+rlmm8qljjbFII/DIY4r1LlwVG33+o
	K49AIFAkXDaGWwj3EOHV4zDglglj/AKM1ZA58S7UX2kr/cbQa1bEHTNy2MSdMRmdLeNgk+QdJhY
	Uwc7YkVpAqhjDSxW9SLp1MyAy2pRXa6QKLWyGWVx4ibaF6NRKq15VfAl6FtgF7FuYpn7lKf3nGg
	Qs0bX04jD/RMacM2owy0p6nufc/YBsw0ZZIscAr+rL+H4GnfFomGOkk1E1tZo/aIGCUDVOvgUdp
	CH6FMK5EPL7xPceNnAGnHLZfG1IHySs+fLSLYjZfwS4OVxK3aa9jNyQTKCl9VpW5Fi5pibMHFyg
	DnDd71Y0Rb9XCUqIjbS+Bwm3BWsPmssskOIgIIYWbSQ==
X-Received: by 2002:a05:6a00:90a6:b0:878:34e7:9a3c with SMTP id d2e1a72fcca58-87e9c06a4b9mr9378153b3a.53.1790554670310;
        Sun, 27 Sep 2026 17:17:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:90a6:b0:878:34e7:9a3c with SMTP id d2e1a72fcca58-87e9c06a4b9mr9378123b3a.53.1790554669847;
        Sun, 27 Sep 2026 17:17:49 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-880951dbb8esm2754588b3a.24.2026.09.27.17.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 17:17:48 -0700 (PDT)
Message-ID: <ca399842-678a-4c82-81fb-2c66b95329bb@redhat.com>
Date: Mon, 28 Sep 2026 10:17:40 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 08/20] KVM: arm64: Reuse kvm_stage2_unmap_range in
 kvm_unmap_gfn_range
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
 <20260920212845.707-9-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-9-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 09vP8WgniNtOa-NzbdCmwMxzSpRtDbiYsnPZQISdJGo_1790554670
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> In preparation for adding VM specific backends for stage2 operation,
> switch to kvm_stage2_unmap_range() instead of __unmap_stage2_range()
> from the kvm_unmap_gfn_range(). Drop the bail out check for protected
> VMs and defer that to the one in kvm_stage2_unmap_range(). Later we
> would replace the logic in kvm_stage2_unmap_range() with VM specific
> backends.
> 
> No functional changes intended.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

