Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B654D2EB1F
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 08:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729240726; cv=none; b=sY5hzrkLWqDVNkCBU0MiB79CcyCvf2vYpBspLMZfiO1cuqpTG6BKc2nZxxf6Frge094dap8qKiin3Tyvy5GB4wktpOhFxAaZL6NBjI4dmxm1uaxSk3G9m8SVYb+jNx32a1ZFTjt9QFIbWDjj1CzlAVmY64lDJISWtipmoJZ/ghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729240726; c=relaxed/simple;
	bh=hL8UuHqCpojMaxpGJbQTNKSaEQSLBzU0jdkgH5Zu2h4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rvbqjtaQucc5DILPfeRmQrFWlWfU4DKZY98RjA14HIr14Ba0SM2PQIb68Tsns2AEqrTYDKunsE2Fe/N3c53qluXW7jxsBJp0Cn5/uA5Z+NpIDrvpwSTzJl83FZDBvdHwsh77FkPy+4qWjBnOkduOcW38y3Z1rS27ci7BWOAweiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z75K0ll/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z75K0ll/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729240723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJzH1gSOEl11wR3YSK4ZKedRTlS0Fmi69LaWvUhmAr8=;
	b=Z75K0ll/+gKg0wS7GSCWDAyZh1dusjWXoGvDQzSRI3Gt4f7h5rLXNcY8st1JzFhEyPyGZ3
	g/Ko/9gpHJ+eVeJWyXTD336kQLBxa4RAo0q/SLg/q0b2bJr6w8pDWR01/iNMVGkWi+dkt9
	8mi+NBWhj8JcUJWlfexTjPeUYTajedM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-2gNnmzaNNz-rHbdbHcZRWA-1; Fri, 18 Oct 2024 04:38:42 -0400
X-MC-Unique: 2gNnmzaNNz-rHbdbHcZRWA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a7fa073718so290761685a.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 01:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729240722; x=1729845522;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uqhXnCT4fCKlCTVuHx3dAlyeKQVM4rIUCf2AtXG9+c0=;
        b=XX8gCW5hn3jSzHF+PHqlo++YK5RJByLapARdWe2jXX1IH4TWi9zrOpIm9M5DtrLzc8
         LtCIDjXFlCxwC4yrq7n6kAYTrewDYoHaQIErIlVYQXK7slKL0KLu9J8RvLaJPsLwfn2Q
         +cCWZXZct5ZzRTPdFjQMTrG1a3aRn5jVJnP04cljG1aItb+RxLsGIiakLpeCF7EsOTBM
         m+Tgb/EtrmCTD4Fc1Tmx682Tmz0MKVEgE70EZIC/8kexYFit59Oo3z/nXv0up06LrZYl
         6q9UnEbPz7MGSHWjCRCZTrmjqCAP3ZKpMlJi/1C1vT78h9OclUIeU21hfcgyUg2p8CsH
         dTKA==
X-Gm-Message-State: AOJu0YzNrTsGpTISC9VDANyCNtVALg8jhRbHMtjWNa97tf2dUEJnYyMd
	OBZVNUnoF10RTGVNZbWG+x/RljT7ZShoP0jHCsYR6I3/Ei7YmLwu/Pk4ri5xKoxPRVNSba3vuDW
	CPaZincqNsaRVV5wrx9gxorTlobLQOrQxogAiK2xDMCX8Ob0Fy12chA==
X-Received: by 2002:a05:6214:3386:b0:6cb:c798:3103 with SMTP id 6a1803df08f44-6cde159f1bcmr14536776d6.39.1729240721810;
        Fri, 18 Oct 2024 01:38:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmZcOYlqsHk2v9hqL7U4vCWowWz33zFjEP+dFo4/G3ZcIL6X0y8NNJAKQTIjk1MRHdiDSrjw==
X-Received: by 2002:a05:6214:3386:b0:6cb:c798:3103 with SMTP id 6a1803df08f44-6cde159f1bcmr14536706d6.39.1729240721472;
        Fri, 18 Oct 2024 01:38:41 -0700 (PDT)
Received: from rh-2.fritz.box (p200300f6af01c000f92aec4042337510.dip0.t-ipconnect.de. [2003:f6:af01:c000:f92a:ec40:4233:7510])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cde114e6d7sm4966706d6.52.2024.10.18.01.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 01:38:40 -0700 (PDT)
Date: Fri, 18 Oct 2024 10:38:35 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    james.morse@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
    yuzenghui@huawei.com, wangzhou1@hisilicon.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH] KVM: arm64: Make L1Ip feature in CTR_EL0 writable from
 userspace
In-Reply-To: <20241017085925.40532-1-shameerali.kolothum.thodi@huawei.com>
Message-ID: <6d7c3d96-d1e9-d1b8-db3d-83ff2da00458@redhat.com>
References: <20241017085925.40532-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806798-552817351-1729240720=:8254"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806798-552817351-1729240720=:8254
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 17 Oct 2024, Shameer Kolothum wrote:
> Only allow userspace to set VIPT(0b10) or PIPT(0b11) for L1Ip based on
> what hardware reports as both AIVIVT (0b01) and VPIPT (0b00) are
> documented as reserved.
>
> Using a VIPT for Guest where hardware reports PIPT may lead to over
> invalidation, but is still correct. Hence, we can allow downgrading
> PIPT to VIPT, but not the other way around.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>
---1463806798-552817351-1729240720=:8254--

