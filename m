Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4902E634
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 02:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729132685; cv=none; b=Z7DLmeuXTr+h03z1bbKXrWGLKrZSiNnWT851Ga0mIXbCkBxlTlhaMnIt2MrhQneC5c0v/X0ocq0Un2jz6FWRSiPeQskqh+dCj0tCAS+3dJnXjYjoJZpTsyt4D6pb2DsHJU8RqXgyEUqXspqCwBNtyj6iMAFNib7xRJFvBi6COM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729132685; c=relaxed/simple;
	bh=O6JoqdyaEJ4wmHrEXRIP7LMWonueU7nIGf9wVlVCmO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tHgUXDe7TBUQrP4qzWE6V+Tn4Fa2TNGzwRtOSCz87uteF0KyIE8udx/lanzM9IWjB6izZ4Yrby0MiAy+trwhiOGXkiLE6vUwRFWzaBRacjm38UZRgZk0r+qp4+KTVZq7hZqol/l+Al306Dqw/YqcXC5sYRC3KtF4/zn/APsAD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RL8gXspi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RL8gXspi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729132681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S/LpMWZANTWFt7tdLKcsQ3egkAnPKynw0hAtE2owsqA=;
	b=RL8gXspiDNgQ9xNlF5/K3LZJvewmTxL/hLXWOFtHPyr9iJh6i+FaoowEt+Mwx8vGGy4a3l
	sG1nBhgY3D8lCQkyAKXD3jweas2hma/xZz3SscaGHlRnKFEDLJcERwEKMbVbHAR24Pz9Po
	AKUOCRtowXp9UP1DHy/u5BfxOWsFhao=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-LHYCzyf7Pya3BJEglCDnTw-1; Wed, 16 Oct 2024 22:38:00 -0400
X-MC-Unique: LHYCzyf7Pya3BJEglCDnTw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso402808a12.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 19:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729132679; x=1729737479;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/LpMWZANTWFt7tdLKcsQ3egkAnPKynw0hAtE2owsqA=;
        b=NTUVf8uE3OCDod4QEU6S2kjiTUOgVuSQRlfs6qx+fUjs857tbQTjxuUsQQDgrzkGsg
         sdhW/Eb+uHf+jFulLJghEbMgiaAwBVTMEhJdljiWjl5M8KGQITu07nVzcQAyLM4FDkO8
         vwgfOtaMCSM9IQ0VoGqAeTeVQEl0UBIYYP5gU3HCKebPTrdM0F17G0qlqIfretV8Y9Xg
         P2sRHgBlr9nek3Hz2az25QcePvKVPuC9UnSgsJw6IQv7sSIJ/rE1rgp13c8zJuKunGoS
         jtelcsP/ddQZrOHCZbnWTIOWZc6EOVfVs6SLTovHt/0BuFn7yZNaG8rBxEw4xsr4GlwZ
         pDxA==
X-Forwarded-Encrypted: i=1; AJvYcCXqLY0EmGFH1s5m5SG7MlpYJNoEyv4fY8QTNQVTGl3XUJPlJKtRzsGQgbqN/iirKLMusppVC+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkJQl7Z/ppofwEBLHoR1uannsMQ50S6tr/Ai7GpclUr0rZ2+F+
	RMyIqEyM4R/ILqsi17mMK2kChRWgBc+rNtiGhm8jmq7SewaICXQB2b+mIITZWNJTl/URBPYiwUS
	BPxX4R1VLJOcCUcBNuS70R/7KbDWlrLjKVycaW6FcC4xv3ZXHiFAlIA==
X-Received: by 2002:a05:6a20:b40a:b0:1d3:2929:b0d9 with SMTP id adf61e73a8af0-1d91c6bd237mr2113468637.19.1729132679465;
        Wed, 16 Oct 2024 19:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF87nN3J0/XW5GcPzxQUQ+ArJU1IirkEVtbjxL+PIeXg7iFk2B4LNnAJlSOiz2thH0YvLzF2w==
X-Received: by 2002:a05:6a20:b40a:b0:1d3:2929:b0d9 with SMTP id adf61e73a8af0-1d91c6bd237mr2113445637.19.1729132679137;
        Wed, 16 Oct 2024 19:37:59 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774a28a9sm3770951b3a.138.2024.10.16.19.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 19:37:58 -0700 (PDT)
Message-ID: <c6377524-8527-4fc2-a244-d250a4c2df48@redhat.com>
Date: Thu, 17 Oct 2024 12:37:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: arm64: Disable MPAM visibility by default and
 ignore VMM writes
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-7-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241015133923.3910916-7-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 11:39 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 011e5f5bf529f ("arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR0 register") exposed the MPAM field of AA64PFR0_EL1 to guests,
> but didn't add trap handling. A previous patch supplied the missing trap
> handling.
> 
> Existing VMs that have the MPAM field of ID_AA64PFR0_EL1 set need to
> be migratable, but there is little point enabling the MPAM CPU
> interface on new VMs until there is something a guest can do with it.
> 
> Clear the MPAM field from the guest's ID_AA64PFR0_EL1 and on hardware
> that supports MPAM, politely ignore the VMMs attempts to set this bit.
> 
> Guests exposed to this bug have the sanitised value of the MPAM field,
> so only the correct value needs to be ignored. This means the field
> can continue to be used to block migration to incompatible hardware
> (between MPAM=1 and MPAM=5), and the VMM can't rely on the field
> being ignored.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 41 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

