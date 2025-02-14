Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B32E267729
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554469; cv=none; b=hMdn/Gq2S7uMIk08HoF79qVW3ze/cEbfSkA5Z/iAZJBvgS/bPVNXkENBBULvAZbjwMjXkQ+kBe//C90DaIvgrUjJGc/hFhItuu/BTFwgoKqptz0R8rSV8b8F2VN9Grrnfq/GXKq+RgnwaeAH5+hVmBmvf3Q+T1O7UUxE6EvGrOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554469; c=relaxed/simple;
	bh=KPmiSig9DOyV6mJz/7R9mEO+NijYJqj6ntOO3piIZzw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rEGrZ6cha6nIgMRHMxmsVM3lTfpf1OTb+j8mu/NnVqUgQTv8McMWpAgRVC8WEqtcDtjSrNQrS8ULgLONStsAb49apQ2QAhHhqf76bKg4Av0WDqgDmOMnm1L81EYMK3VyILCpCHWq6Zw+JoIsBWQrrAhPTQZBrIBCDcc4y3uWywY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ie2DX2Ro; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ie2DX2Ro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739554467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1wZWBEhc+7XW/jxCHi0HvycEodKoaIiK2HmKP8Gx3AQ=;
	b=Ie2DX2RoZGaBFsV2DpU9pDjWgQz1xf27GM+RGGufcQzPeYGayDo9gx/3y5FU+fn0B/g1dK
	Y2aoBgnl3o3eAB3qaEh+08UxmyHdRE3XO0oOsLE1s/jFwIwvDwz6+0FZthavMGOMrtD7NT
	pG+4d/tqi2lqOugTwlIMlVsvU2MYA+c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-vY2FIhU3MdWMeGNdQfRBhw-1; Fri, 14 Feb 2025 12:34:23 -0500
X-MC-Unique: vY2FIhU3MdWMeGNdQfRBhw-1
X-Mimecast-MFC-AGG-ID: vY2FIhU3MdWMeGNdQfRBhw_1739554463
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38dcc9653a7so1263088f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 09:34:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739554462; x=1740159262;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hV8JhFPYcrWWOCZKVjI7/hmlqDr4nhneUKbFw+hGcGw=;
        b=AI58l6SK1zZpBBrnZok0vTxxVw4e35TGot79h+LStuUovF+/Am4+t4dYdVNNtDRC8J
         DeCVyk6cpubzTti3Gr36JRD/n8GDNKeS94yjz5M5cvwgCpJCv3Y2LqzyPbKzh0Y80dXe
         sUHkV8VSeUAmGAbjz+HNxiRkBYuGmlNZhQA9GAAFSqE/0ZIhsOT34z7VnfO8u5sxBP2b
         JhqJk9nQz/A9cA2OhpEQ/ekNArMbelOlr4badXKy0CgzNemreEYOifHqaiuyBuh8sf1u
         II2t9y5ZzNATPNJ3FE0MQNbhpT3sdnz3r7dUdZDYf3u1+NsPIG8ubN/L/vDQYiM9u6lO
         9/7Q==
X-Gm-Message-State: AOJu0YwKfJJz0tbJsXcQxExUXB8hfll45lhTTZYyHSJanxwyzY4BYQTK
	m+qXGjSyZdMvCP7NSt4UbBmZ0iBqom1x03HK7IavvjMN0x52CZvVDswq82ZzI/gmhIOrhJMOfPC
	jZFAyPAHvy5R4P/gmdAV7WRU6Dmj/XH8hrnZR7wF4tzV7Q8gMytdAxA==
X-Gm-Gg: ASbGncttQuvt1d5dbeRHv+Uktngrqf4rclzlMUDCMxf2IyWTP4zNApg2OAhOP/5jbFt
	pfkau4pdMmZPwa0vPE0gYGivZmZsia22Y9pDZPf6htCN1Q8rabpmU6nL2o6nf8CXbU7DnjvbT82
	QnKqC6y890GchUYB5NwJ7Ke9d8mMWDGF83tWbu5Om65WUk0834XMl7INCRCzTrRpiRAoApb3/SX
	MHp9pOzMMk7ef4Cozb+ZOYvIrdi0hJAbhelioBw/7fEFxKZhz2GGYc/bVCnCWaXzlvQWRlgwNlI
	U/Ai0qxp6e8Xkd+1RWvKddRw9l/pGBRACWczfPYJE25Niy1Y2E5FiA==
X-Received: by 2002:a05:6000:4008:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-38f244d648cmr12747556f8f.3.1739554462568;
        Fri, 14 Feb 2025 09:34:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLq9R9sFnDs+J8hpOwo9gOo3BsH3NCojh2IMq354S0SwWU05YmSPCHC41tpgN81o7+Z7dgWw==
X-Received: by 2002:a05:6000:4008:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-38f244d648cmr12747510f8f.3.1739554462192;
        Fri, 14 Feb 2025 09:34:22 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8115sm5200049f8f.92.2025.02.14.09.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 09:34:21 -0800 (PST)
Date: Fri, 14 Feb 2025 18:34:20 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
    catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
    cohuck@redhat.com, eric.auger@redhat.com, yuzenghui@huawei.com, 
    wangzhou1@hisilicon.com, jiangkunkun@huawei.com, 
    jonathan.cameron@huawei.com, anthony.jebson@huawei.com, 
    linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v7 0/5] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
Message-ID: <0ea00cd9-0cdc-aef9-7a3f-f0101295e03f@redhat.com>
References: <20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WbT0eHTWp5uRH0nLvjd3iXdeuNx-9cWwuGd0Xy5tIY4_1739554463
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-568075231-1739554461=:19562"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-568075231-1739554461=:19562
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 14 Feb 2025, Shameer Kolothum wrote:
> v6-->v7
> https://lore.kernel.org/kvmarm/20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com/
>
> Changes:
>  -Introduced KVM_REG_ARM_VENDOR_HYP_BMAP_2 register for new hypercall
>  support(patch #3)
> -Added selftest for KVM_REG_ARM_VENDOR_HYP_BMAP_2(patch #5).
>
> This can be sanity tested by the Qemu branch here,
> https://github.com/hisilicon/qemu/tree/v9.0-nv-rfcv4-vcpu-model-v2-target-cpu-errata
> (branch based on Eric's/Connie's NV + custom CPU series)
> Eg: to specify target impl CPUs,
> -machine virt,.., x-target-impl-cpus=0xMIDR1:0xREVIDR1-0xMIDR2:REVIDR2
>
> Please take a look and let me know your feedback.

Reviewed-by: Sebastian Ott <sebott@redhat.com>
---1463806286-568075231-1739554461=:19562--

